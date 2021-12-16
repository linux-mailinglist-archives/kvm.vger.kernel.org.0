Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F73E47693D
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 05:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhLPEr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 23:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbhLPEr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 23:47:29 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204F0C061574;
        Wed, 15 Dec 2021 20:47:29 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JF02x44Tsz4xdH;
        Thu, 16 Dec 2021 15:47:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1639630043;
        bh=zKmSZMNPIgiKwlgxADX1iohJOULkY/c5F13cvNewuTo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ZOfTD0BXcFIqxxhRpzTV/vMyHKeJ6QMD5XrWvygvwdTwcKLdcj666kD9hEDcN5evE
         BrywrRaQCOYOxSbLOuMbxe/JKNds06k4E2oISYNNxz5+go3ZaHQQMwTbO4J5F9Z9aH
         7qSVZrPWTizTPbNBY6sCgmuxqtw6N5DNGI11U7FcnRQ1r22LCMABfbEr7b9l48msqv
         jjUYecdtaXQfTrdtpVjrNmCGg9z8+Bw5XXbn88Npts4bHEyh/vP7YzTvZh/MMWDN2l
         SrGtTpxvZhMvgyak91KLPosyH6CzeSwXQEVvepecURWwxuH3N/Shh9HUkf49jaVFRo
         gCBUP8jNLfSzw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     broonie@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: linux-next: manual merge of the kvm tree with the kvm tree
In-Reply-To: <20211215131033.2541027-1-broonie@kernel.org>
References: <20211215131033.2541027-1-broonie@kernel.org>
Date:   Thu, 16 Dec 2021 15:47:12 +1100
Message-ID: <87wnk5kvfz.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

broonie@kernel.org writes:
> Hi all,
>
> Today's linux-next merge of the kvm tree got a conflict in:
>
>   arch/powerpc/kvm/book3s_hv.c
>
> between commit:
>
>   511d25d6b789f ("KVM: PPC: Book3S: Suppress warnings when allocating too big memory slots")
>
> from the kvm tree and commits:

That's from the powerpc tree.

>   537a17b314930 ("KVM: Let/force architectures to deal with arch specific memslot data")
>   eaaaed137eccb ("KVM: PPC: Avoid referencing userspace memory region in memslot updates")
>
> from the kvm tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Thanks.

Paolo, if you want to avoid the conflict going to Linus, I have that
commit (and others) in a topic branch here (based on rc2):

  https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git/log/?h=topic/ppc-kvm


cheers


> diff --cc arch/powerpc/kvm/book3s_hv.c
> index f64e45d6c0f4c,51e1c29a6fa08..0000000000000
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@@ -4866,21 -4854,17 +4866,22 @@@ static void kvmppc_core_free_memslot_hv
>   }
>   
>   static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
> - 					struct kvm_memory_slot *slot,
> - 					const struct kvm_userspace_memory_region *mem,
> - 					enum kvm_mr_change change)
> + 				const struct kvm_memory_slot *old,
> + 				struct kvm_memory_slot *new,
> + 				enum kvm_mr_change change)
>   {
> - 	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
> - 
>   	if (change == KVM_MR_CREATE) {
> - 		unsigned long size = array_size(npages, sizeof(*slot->arch.rmap));
>  -		new->arch.rmap = vzalloc(array_size(new->npages,
>  -					  sizeof(*new->arch.rmap)));
> ++		unsigned long size = array_size(new->npages,
> ++						sizeof(*new->arch.rmap));
>  +
>  +		if ((size >> PAGE_SHIFT) > totalram_pages())
>  +			return -ENOMEM;
>  +
> - 		slot->arch.rmap = vzalloc(size);
> - 		if (!slot->arch.rmap)
> ++		new->arch.rmap = vzalloc(size);
> + 		if (!new->arch.rmap)
>   			return -ENOMEM;
> + 	} else if (change != KVM_MR_DELETE) {
> + 		new->arch.rmap = old->arch.rmap;
>   	}
>   
>   	return 0;
