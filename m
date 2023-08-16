Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AD377EAB5
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 22:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346142AbjHPUad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 16:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346166AbjHPUaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 16:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028D62690;
        Wed, 16 Aug 2023 13:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9194365B52;
        Wed, 16 Aug 2023 20:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75C2C433C7;
        Wed, 16 Aug 2023 20:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692217821;
        bh=3CAn7T1ogNGUkodY6GQj69+AESw9KYAjOSCAr3tFUBc=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=nQRM1PnpRfI/ER25+ZrFj5j+xmVZYgsUbXzIrNZa20Oq3w0SUTNcK6cQOpj+waLFd
         hD856dW5pMSBMLwzNRjgtjRxCqRM68iFehkJZEak4VPHLTcnrFc97ixAPOwRrae+jw
         m9NIl6yykBoWgoELPBAdL+IyfjgC+Wxas9ZJ9FVz7wNitujQeRscwXbFxhsmplcwqV
         z6+MWlZ2GuKZw4tggdY3Y7kMQAXyEQ4TrJ/sUGce9UnblAKNt5FbiG3C5QXmOlXL3f
         yzqqoH2O/znNCRgBzDjIrv4cQU2GaDx2TqRAuqi/tiI5bi+RieS5SyUy57jSJ/JNTQ
         8M4qbbU5/3Arw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 16 Aug 2023 23:30:16 +0300
Message-Id: <CUU95GQH9815.1YH1SIFK4O6JG@suppilovahvero>
Subject: Re: [PATCH 5/8] KVM: gmem, x86: Add gmem hook for initializing
 private memory
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
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
X-Mailer: aerc 0.14.0
References: <cover.1692119201.git.isaku.yamahata@intel.com>
 <3d5079d0a58616726e7471a93e3295676148865a.1692119201.git.isaku.yamahata@intel.com>
In-Reply-To: <3d5079d0a58616726e7471a93e3295676148865a.1692119201.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue Aug 15, 2023 at 8:18 PM EEST,  wrote:
> From: Michael Roth <michael.roth@amd.com>
>
> All gmem pages are expected to be 'private' as defined by a particular
> arch/platform. Platforms like SEV-SNP require additional operations to
> move these pages into a private state, so implement a hook that can be
> used to prepare this memory prior to mapping it into a guest.
>
> In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
> 2MB mapping in the guest's nested page table depends on whether or not
> any subpages within the range have already been initialized as private
> in the RMP table, so this hook will also be used by the KVM MMU to clamp
> the maximum mapping size accordingly.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Link: https://lore.kernel.org/r/20230612042559.375660-2-michael.roth@amd.=
com
>
> ---
> Changes v2 -> v3:
> - Newly added
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  3 +++
>  arch/x86/kvm/mmu/mmu.c             | 12 ++++++++++--
>  3 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kv=
m-x86-ops.h
> index 13bc212cd4bc..439ba4beb5af 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -133,6 +133,7 @@ KVM_X86_OP(msr_filter_changed)
>  KVM_X86_OP(complete_emulated_msr)
>  KVM_X86_OP(vcpu_deliver_sipi_vector)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> +KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
> =20
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index bbefd79b7950..2bc42f2887fa 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1732,6 +1732,9 @@ struct kvm_x86_ops {
>  	 * Returns vCPU specific APICv inhibit reasons
>  	 */
>  	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
> +
> +	int (*gmem_prepare)(struct kvm *kvm, struct kvm_memory_slot *slot,
> +			    kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
>  };
> =20
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 05943ccb55a4..06900b01b8f0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4352,6 +4352,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu =
*vcpu,
>  				   struct kvm_page_fault *fault)
>  {
>  	int max_order, r;
> +	u8 max_level;
> =20
>  	if (!kvm_slot_can_be_private(fault->slot))
>  		return kvm_do_memory_fault_exit(vcpu, fault);
> @@ -4361,8 +4362,15 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu=
 *vcpu,
>  	if (r)
>  		return r;
> =20
> -	fault->max_level =3D min(kvm_max_level_for_order(max_order),
> -			       fault->max_level);
> +	max_level =3D kvm_max_level_for_order(max_order);
> +	r =3D static_call(kvm_x86_gmem_prepare)(vcpu->kvm, fault->slot, fault->=
pfn,
> +					      fault->gfn, &max_level);
> +	if (r) {
> +		kvm_release_pfn_clean(fault->pfn);
> +		return r;
> +	}
> +
> +	fault->max_level =3D min(max_level, fault->max_level);
>  	fault->map_writable =3D !(fault->slot->flags & KVM_MEM_READONLY);
>  	return RET_PF_CONTINUE;
>  }
> --=20
> 2.25.1

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
