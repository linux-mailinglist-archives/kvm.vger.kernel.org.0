Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3DFB8F4EA
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 21:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733071AbfHOTmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 15:42:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730148AbfHOTmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 15:42:40 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5FC1644FB1;
        Thu, 15 Aug 2019 19:42:40 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBB788CBBD;
        Thu, 15 Aug 2019 19:42:39 +0000 (UTC)
Date:   Thu, 15 Aug 2019 13:42:39 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/MMU: Zap all when removing memslot if VM has
 assigned device
Message-ID: <20190815134239.555f3121@x1.home>
In-Reply-To: <20190815151228.32242-1-sean.j.christopherson@intel.com>
References: <1565855169-29491-1-git-send-email-pbonzini@redhat.com>
        <20190815151228.32242-1-sean.j.christopherson@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 15 Aug 2019 19:42:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 15 Aug 2019 08:12:28 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Alex Williamson reported regressions with device assignment when KVM
> changed its memslot removal logic to zap only the SPTEs for the memslot
> being removed.  The source of the bug is unknown at this time, and root
> causing the issue will likely be a slow process.  In the short term, fix
> the regression by zapping all SPTEs when removing a memslot from a VM
> with assigned device(s).
> 
> Fixes: 4e103134b862 ("KVM: x86/mmu: Zap only the relevant pages when removing a memslot", 2019-02-05)
> Reported-by: Alex Willamson <alex.williamson@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> An alternative idea to a full revert.  I assume this would be easy to
> backport, and also easy to revert or quirk depending on where the bug
> is hiding.
> 
>  arch/x86/kvm/mmu.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 8f72526e2f68..358b93882ac6 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -5659,6 +5659,17 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
>  	bool flush;
>  	gfn_t gfn;
>  
> +	/*
> +	 * Zapping only the removed memslot introduced regressions for VMs with
> +	 * assigned devices.  It is unknown what piece of code is buggy.  Until
> +	 * the source of the bug is identified, zap everything if the VM has an
> +	 * assigned device.
> +	 */
> +	if (kvm_arch_has_assigned_device(kvm)) {
> +		kvm_mmu_zap_all(kvm);
> +		return;
> +	}
> +
>  	spin_lock(&kvm->mmu_lock);
>  
>  	if (list_empty(&kvm->arch.active_mmu_pages))

Though if we want to zoom in a little further, the patch below seems to
work.  Both versions of these perhaps just highlight that we don't
really know why the original code doesn't work with device assignment,
whether it's something special about GPU mapping, or if it hints that
there's something more generally wrong and difficult to trigger.

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24843cf49579..3956b5844479 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5670,7 +5670,8 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 		gfn = slot->base_gfn + i;
 
 		for_each_valid_sp(kvm, sp, gfn) {
-			if (sp->gfn != gfn)
+			if (sp->gfn != gfn &&
+			    !kvm_arch_has_assigned_device(kvm))
 				continue;
 
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
