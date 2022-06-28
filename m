Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EFF55C8FA
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243957AbiF1C7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 22:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243163AbiF1C7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 22:59:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FA4E57;
        Mon, 27 Jun 2022 19:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656385144; x=1687921144;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=sVoUlH6maLKR/PkF8oqytFzMhM9Ho9rUbcb5QoSP0sk=;
  b=SJSSmcQNoJraxx5/s4nYo/Vmy1EB/Y9suDIZhTFfbteFp3SmMainxoTG
   cEfeYefNx+EtMtlIxXS80Urlg1Y9u9v/+rwhoETw52oNBza+rlG0QLpsZ
   XCsN1lieGpl0p9UcncVRQ9hosBOu3OzRSmmF7sg8k2FdNXRWQYd5wqICw
   6TNULtTKyTA2pDnBUmRrMyFdORTZ+gQ+94FyUrXzMv7AeT1RZqjlIcYAL
   34fOjdbpH48LwnRfcmAPyPQrbW8C170C0CMbuUBuQD9K5eP2SEvFbXtXd
   crfl+2WJPX8JM4m/ee99s+fGmJxEjw+I14Fgxkl8Kn8XvJ9+qM53t7zVI
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="343305994"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="343305994"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 19:59:04 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="590143490"
Received: from iiturbeo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.89.183])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 19:59:02 -0700
Message-ID: <8dc8bf255982e75c8b9032916903ae3ff3e7a632.camel@intel.com>
Subject: Re: [PATCH v7 007/102] KVM: Enable hardware before doing arch VM
 initialization
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Tue, 28 Jun 2022 14:59:00 +1200
In-Reply-To: <e3ccffe3a46f994779037e4965313e7df9980ddc.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <e3ccffe3a46f994779037e4965313e7df9980ddc.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:52 -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>=20
> Swap the order of hardware_enable_all() and kvm_arch_init_vm() to
> accommodate Intel's TDX, which needs VMX to be enabled during VM init in
> order to make SEAMCALLs.
>=20
> This also provides consistent ordering between kvm_create_vm() and
> kvm_destroy_vm() with respect to calling kvm_arch_destroy_vm() and
> hardware_disable_all().

Reviewed-by: Kai Huang <kai.huang@intel.com>

>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cee799265ce6..0acb0b6d1f82 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1138,19 +1138,19 @@ static struct kvm *kvm_create_vm(unsigned long ty=
pe)
>  		rcu_assign_pointer(kvm->buses[i],
>  			kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
>  		if (!kvm->buses[i])
> -			goto out_err_no_arch_destroy_vm;
> +			goto out_err_no_disable;
>  	}
> =20
>  	kvm->max_halt_poll_ns =3D halt_poll_ns;
> =20
> -	r =3D kvm_arch_init_vm(kvm, type);
> -	if (r)
> -		goto out_err_no_arch_destroy_vm;
> -
>  	r =3D hardware_enable_all();
>  	if (r)
>  		goto out_err_no_disable;
> =20
> +	r =3D kvm_arch_init_vm(kvm, type);
> +	if (r)
> +		goto out_err_no_arch_destroy_vm;
> +
>  #ifdef CONFIG_HAVE_KVM_IRQFD
>  	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
>  #endif
> @@ -1188,10 +1188,10 @@ static struct kvm *kvm_create_vm(unsigned long ty=
pe)
>  		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
>  #endif
>  out_err_no_mmu_notifier:
> -	hardware_disable_all();
> -out_err_no_disable:
>  	kvm_arch_destroy_vm(kvm);
>  out_err_no_arch_destroy_vm:
> +	hardware_disable_all();
> +out_err_no_disable:
>  	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
>  	for (i =3D 0; i < KVM_NR_BUSES; i++)
>  		kfree(kvm_get_bus(kvm, i));

