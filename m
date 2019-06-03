Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90F633584
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 18:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfFCQ43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 12:56:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727866AbfFCQ41 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 12:56:27 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 683FE8B947;
        Mon,  3 Jun 2019 16:56:22 +0000 (UTC)
Received: from flask (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with SMTP id 456101017E3E;
        Mon,  3 Jun 2019 16:56:17 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Mon, 03 Jun 2019 18:56:17 +0200
Date:   Mon, 3 Jun 2019 18:56:17 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v3] KVM: x86: Add Intel CPUID.1F cpuid emulation
 support
Message-ID: <20190603165616.GA11101@flask>
References: <20190526133052.4069-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190526133052.4069-1-like.xu@linux.intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 03 Jun 2019 16:56:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-05-26 21:30+0800, Like Xu:
> Add support to expose Intel V2 Extended Topology Enumeration Leaf for
> some new systems with multiple software-visible die within each package.
> 
> Per Intel's SDM, when CPUID executes with EAX set to 1FH, the processor
> returns information about extended topology enumeration data. Software
> must detect the presence of CPUID leaf 1FH by verifying (a) the highest
> leaf index supported by CPUID is >= 1FH, and (b) CPUID.1FH:EBX[15:0]
> reports a non-zero value.
> 
> Co-developed-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> ==changelog==
> v3:
> - Refine commit message and comment
> 
> v2: https://lkml.org/lkml/2019/4/25/1246
> 
> - Apply cpuid.1f check rule on Intel SDM page 3-222 Vol.2A
> - Add comment to handle 0x1f anf 0xb in common code
> - Reduce check time in a descending-break style
> 
> v1: https://lkml.org/lkml/2019/4/22/28
> 
>  arch/x86/kvm/cpuid.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 80a642a0143d..f9b41f0103b3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -426,6 +426,11 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  
>  	switch (function) {
>  	case 0:
> +		/* Check if the cpuid leaf 0x1f is actually implemented */
> +		if (entry->eax >= 0x1f && (cpuid_ebx(0x1f) & 0x0000ffff)) {
> +			entry->eax = 0x1f;

Sorry for my late reply, but I think this check does more harm than
good.

We'll need to change it if we ever add leaf above 0x1f, which also puts
burden on the new submitter to check that exposing it by an unrelated
feature doesn't break anything.  Just like you had to see whether the
leaf 0x14 is still ok when exposing it without f_intel_pt.

Also, I don't see anything that would make 0x1f worthy of protection
when enabling it also exposes unimplemented leaves (0x14;0x1f).
Zeroing 0x1f.ebx disables it and that is implicitly being done if the
presence check above would fail.

> +			break;
> +		}
>  		entry->eax = min(entry->eax, (u32)(f_intel_pt ? 0x14 : 0xd));

Similarly in the existing code.  If we don't have f_intel_pt, then we
should make sure that leaf 0x14 is not being filled, but we don't really
have to limit the maximal index.

Adding a single clamping like

		/* Limited to the highest leaf implemented in KVM. */
		entry->eax = min(entry->eax, 0x1f);

seems sufficient.

(Passing the hardware value is ok in theory, but it is a cheap way to
 avoid future leaves that cannot be simply zeroed for some weird reason.)

Thanks.
