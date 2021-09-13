Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D0540889B
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 11:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238731AbhIMJ6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 05:58:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44675 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238444AbhIMJ6b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 05:58:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631527035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=siVDFr3S9ONYfda+VIgXBw6wFuMXnGso09DgHdeWDFw=;
        b=Pul+uPUmRBDHxBcQdbFjiTmpc8XFDYxLW1SCxQFCkGEINBkwMgx8WH1EzdV/nvo+TSDTIO
        GqZ1YaTcn4SWMppLhZ+I+BPg6sMne04I9w3v3m82CkzEKqWmCoBlIo5jlp7iTxF4hP93Le
        E6R8evdUHziIp0XAT4an41cIPJ7164I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227--9ytZSgmPYqLHdjCP02Xsg-1; Mon, 13 Sep 2021 05:57:14 -0400
X-MC-Unique: -9ytZSgmPYqLHdjCP02Xsg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC69D835DE3;
        Mon, 13 Sep 2021 09:57:12 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 785D95C25A;
        Mon, 13 Sep 2021 09:57:04 +0000 (UTC)
Message-ID: <9b70aeb7b6829f3d20da05f888f58eaa1c9abee6.camel@redhat.com>
Subject: Re: [PATCH 1/7] KVM: X86: Fix missed remote tlb flush in
 rmap_write_protect()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Date:   Mon, 13 Sep 2021 12:57:03 +0300
In-Reply-To: <20210824075524.3354-2-jiangshanlai@gmail.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
         <20210824075524.3354-2-jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-08-24 at 15:55 +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> When kvm->tlbs_dirty > 0, some rmaps might have been deleted
> without flushing tlb remotely after kvm_sync_page().  If @gfn
> was writable before and it's rmaps was deleted in kvm_sync_page(),
> we need to flush tlb too even if __rmap_write_protect() doesn't
> request it.
> 
> Fixes: 4731d4c7a077 ("KVM: MMU: out of sync shadow core")
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4853c033e6ce..313918df1a10 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1420,6 +1420,14 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
>  			rmap_head = gfn_to_rmap(gfn, i, slot);
>  			write_protected |= __rmap_write_protect(kvm, rmap_head, true);
>  		}
> +		/*
> +		 * When kvm->tlbs_dirty > 0, some rmaps might have been deleted
> +		 * without flushing tlb remotely after kvm_sync_page().  If @gfn
> +		 * was writable before and it's rmaps was deleted in kvm_sync_page(),
> +		 * we need to flush tlb too.
> +		 */
> +		if (min_level == PG_LEVEL_4K && kvm->tlbs_dirty)
> +			write_protected = true;

This is a bit misleading, as the gfn is not write protected in this case, but we
just want tlb flush. Maybe add a new output paramter to the function, telling
if we want a tlb flush?

>  	}
>  
>  	if (is_tdp_mmu_enabled(kvm))
> @@ -5733,6 +5741,14 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>  		flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
>  					  start_level, KVM_MAX_HUGEPAGE_LEVEL,
>  					  false);
> +		/*
> +		 * When kvm->tlbs_dirty > 0, some rmaps might have been deleted
> +		 * without flushing tlb remotely after kvm_sync_page().  If @gfn
> +		 * was writable before and it's rmaps was deleted in kvm_sync_page(),
> +		 * we need to flush tlb too.
> +		 */
> +		if (start_level == PG_LEVEL_4K && kvm->tlbs_dirty)
> +			flush = true;
>  		write_unlock(&kvm->mmu_lock);
>  	}
>  


Best regards,
	Maxim Levitsky

