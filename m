Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C249A77EAAF
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 22:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346134AbjHPU25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 16:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346124AbjHPU20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 16:28:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AECC26A0;
        Wed, 16 Aug 2023 13:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED583651DC;
        Wed, 16 Aug 2023 20:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B776C433C7;
        Wed, 16 Aug 2023 20:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692217701;
        bh=yf25bicjIxz7p5iTZ7Dqx9bZgB66p7ZsNKtdIgM1exM=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=ebVrwvzD+buuQK53Q8z0GiOCnS2jSV+3peLErmUKaYpssZaJXqVpWu6EuRR4Q2OMe
         +vWIJxPxLesV+wZRs/9fDfgeFt82HeTj6obUoQ5wBBK9YfrNGDo3/HbyluKAcq/VRI
         2pkok435Zuuxwe3oTWqLQ9PK1hT8wHhjBRiggAVqpM4wb+Ti0ZktRuj8MZhUwRGCAq
         94omYkqu/unRfHIpWyp2/C9BMCtt5EcpzLox3S9SS21CmtxcqlyQrnGd6yVJ2MhIg/
         S8t7Iw1T6Ji71wEKHRZpIuqqX0N0MbXMiWA2sUjlHpvSXGDaPF0cGCq+8qR2ORPVSx
         DsDL2ly5IUiCA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 16 Aug 2023 23:28:15 +0300
Message-Id: <CUU93XA8UKMG.X15YWDK533GB@suppilovahvero>
Cc:     <isaku.yamahata@gmail.com>, "Michael Roth" <michael.roth@amd.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>, <erdemaktas@google.com>,
        "Sagi Shahar" <sagis@google.com>,
        "David Matlack" <dmatlack@google.com>,
        "Kai Huang" <kai.huang@intel.com>,
        "Zhi Wang" <zhi.wang.linux@gmail.com>, <chen.bo@intel.com>,
        <linux-coco@lists.linux.dev>,
        "Chao Peng" <chao.p.peng@linux.intel.com>,
        "Ackerley Tng" <ackerleytng@google.com>,
        "Vishal Annapurve" <vannapurve@google.com>,
        "Yuan Yao" <yuan.yao@linux.intel.com>,
        "Xu Yilun" <yilun.xu@intel.com>,
        "Quentin Perret" <qperret@google.com>, <wei.w.wang@intel.com>,
        "Fuad Tabba" <tabba@google.com>
Subject: Re: [PATCH 4/8] KVM: gmem: protect kvm_mmu_invalidate_end()
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.14.0
References: <cover.1692119201.git.isaku.yamahata@intel.com>
 <b37fb13a9aeb8683d5fdd5351cdc5034639eb2bb.1692119201.git.isaku.yamahata@intel.com>
In-Reply-To: <b37fb13a9aeb8683d5fdd5351cdc5034639eb2bb.1692119201.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue Aug 15, 2023 at 8:18 PM EEST,  wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> kvm_mmu_invalidate_end() updates struct kvm::mmu_invalidate_in_progress
> and it's protected by kvm::mmu_lock.  call kvm_mmu_invalidate_end() befor=
e
> unlocking it. Not after the unlock.
>
> Fixes: 8e9009ca6d14 ("KVM: Introduce per-page memory attributes")
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  virt/kvm/kvm_main.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8bfeb615fc4d..49380cd62367 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -535,6 +535,7 @@ struct kvm_mmu_notifier_range {
>  	} arg;
>  	gfn_handler_t handler;
>  	on_lock_fn_t on_lock;
> +	on_unlock_fn_t before_unlock;
>  	on_unlock_fn_t on_unlock;
>  	bool flush_on_ret;
>  	bool may_block;
> @@ -629,6 +630,8 @@ static __always_inline int __kvm_handle_hva_range(str=
uct kvm *kvm,
>  		kvm_flush_remote_tlbs(kvm);
> =20
>  	if (locked) {
> +		if (!IS_KVM_NULL_FN(range->before_unlock))
> +			range->before_unlock(kvm);
>  		KVM_MMU_UNLOCK(kvm);
>  		if (!IS_KVM_NULL_FN(range->on_unlock))
>  			range->on_unlock(kvm);
> @@ -653,6 +656,7 @@ static __always_inline int kvm_handle_hva_range(struc=
t mmu_notifier *mn,
>  		.arg.pte	=3D pte,
>  		.handler	=3D handler,
>  		.on_lock	=3D (void *)kvm_null_fn,
> +		.before_unlock	=3D (void *)kvm_null_fn,
>  		.on_unlock	=3D (void *)kvm_null_fn,
>  		.flush_on_ret	=3D true,
>  		.may_block	=3D false,
> @@ -672,6 +676,7 @@ static __always_inline int kvm_handle_hva_range_no_fl=
ush(struct mmu_notifier *mn
>  		.end		=3D end,
>  		.handler	=3D handler,
>  		.on_lock	=3D (void *)kvm_null_fn,
> +		.before_unlock	=3D (void *)kvm_null_fn,
>  		.on_unlock	=3D (void *)kvm_null_fn,
>  		.flush_on_ret	=3D false,
>  		.may_block	=3D false,
> @@ -776,6 +781,7 @@ static int kvm_mmu_notifier_invalidate_range_start(st=
ruct mmu_notifier *mn,
>  		.end		=3D range->end,
>  		.handler	=3D kvm_mmu_unmap_gfn_range,
>  		.on_lock	=3D kvm_mmu_invalidate_begin,
> +		.before_unlock	=3D (void *)kvm_null_fn,
>  		.on_unlock	=3D kvm_arch_guest_memory_reclaimed,
>  		.flush_on_ret	=3D true,
>  		.may_block	=3D mmu_notifier_range_blockable(range),
> @@ -815,6 +821,8 @@ static int kvm_mmu_notifier_invalidate_range_start(st=
ruct mmu_notifier *mn,
> =20
>  void kvm_mmu_invalidate_end(struct kvm *kvm)
>  {
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
>  	/*
>  	 * This sequence increase will notify the kvm page fault that
>  	 * the page that is going to be mapped in the spte could have
> @@ -846,6 +854,7 @@ static void kvm_mmu_notifier_invalidate_range_end(str=
uct mmu_notifier *mn,
>  		.end		=3D range->end,
>  		.handler	=3D (void *)kvm_null_fn,
>  		.on_lock	=3D kvm_mmu_invalidate_end,
> +		.before_unlock	=3D (void *)kvm_null_fn,
>  		.on_unlock	=3D (void *)kvm_null_fn,
>  		.flush_on_ret	=3D false,
>  		.may_block	=3D mmu_notifier_range_blockable(range),
> @@ -2433,6 +2442,8 @@ static __always_inline void kvm_handle_gfn_range(st=
ruct kvm *kvm,
>  		kvm_flush_remote_tlbs(kvm);
> =20
>  	if (locked) {
> +		if (!IS_KVM_NULL_FN(range->before_unlock))
> +			range->before_unlock(kvm);
>  		KVM_MMU_UNLOCK(kvm);
>  		if (!IS_KVM_NULL_FN(range->on_unlock))
>  			range->on_unlock(kvm);
> @@ -2447,6 +2458,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kv=
m, unsigned long attributes,
>  		.end =3D end,
>  		.handler =3D kvm_mmu_unmap_gfn_range,
>  		.on_lock =3D kvm_mmu_invalidate_begin,
> +		.before_unlock	=3D (void *)kvm_null_fn,
>  		.on_unlock =3D (void *)kvm_null_fn,
>  		.flush_on_ret =3D true,
>  		.may_block =3D true,
> @@ -2457,7 +2469,8 @@ static int kvm_vm_set_mem_attributes(struct kvm *kv=
m, unsigned long attributes,
>  		.arg.attributes =3D attributes,
>  		.handler =3D kvm_arch_post_set_memory_attributes,
>  		.on_lock =3D (void *)kvm_null_fn,
> -		.on_unlock =3D kvm_mmu_invalidate_end,
> +		.before_unlock =3D kvm_mmu_invalidate_end,
> +		.on_unlock =3D (void *)kvm_null_fn,
>  		.may_block =3D true,
>  	};
>  	unsigned long i;
> --=20
> 2.25.1

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
