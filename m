Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5A75849A1
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 04:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiG2CM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 22:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiG2CM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 22:12:56 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651427AB01;
        Thu, 28 Jul 2022 19:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659060775; x=1690596775;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=HomaGb7WPKgIXHbittVSfLe7rYuVaqAYcn+vSwJIlYI=;
  b=N0szalk33PN8MI8IkZ9R4K3DmhZmnU/4t0p2v2xCXUWJvhd1hXv6AK0H
   xE9u5x1+0JCaltKXYrbfvz1ihitcqpOQaH8tGOao1vCfjRGGHz3dpsSim
   7pEEwFUIhzJ4pg7CLdgUfsgwxa1/VcWi+LSNP2FYkwvaBWXfXI+gcUb83
   SPbzGw32//yuFfmd1x6TpzqGeeurejbvuzkR8X5DzOcktw0DmkXS34MWy
   77XJrGZwPXA5WnQtSAKoYgkX92MGC55yN92hktAJHr2XTtp5k5ADFNkEM
   aF8nNj2QMPUm6jB67RnOxZWuv53+haG1WFWtakOaxOBMXSYNNnP8EG0qb
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="289867272"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="289867272"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 19:12:54 -0700
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="660038623"
Received: from mdharmap-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.140])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 19:12:53 -0700
Message-ID: <d09972481dede743dd0a77409cd8ecaecdbf86b3.camel@intel.com>
Subject: Re: [PATCH 4/4] KVM: SVM: Disable SEV-ES support if MMIO caching is
 disable
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Fri, 29 Jul 2022 14:12:51 +1200
In-Reply-To: <20220728221759.3492539-5-seanjc@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
         <20220728221759.3492539-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-28 at 22:17 +0000, Sean Christopherson wrote:
> Disable SEV-ES if MMIO caching is disabled as SEV-ES relies on MMIO SPTEs
> generating #NPF(RSVD), which are reflected by the CPU into the guest as
> a #VC.  With SEV-ES, the untrusted host, a.k.a. KVM, doesn't have access
> to the guest instruction stream or register state and so can't directly
> emulate in response to a #NPF on an emulated MMIO GPA.  Disabling MMIO
> caching means guest accesses to emulated MMIO ranges cause #NPF(!PRESENT)=
,
> and those flavors of #NPF cause automatic VM-Exits, not #VC.
>=20
> Fixes: b09763da4dd8 ("KVM: x86/mmu: Add module param to disable MMIO cach=
ing (for testing)")
> Reported-by: Michael Roth <michael.roth@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu.h      |  2 ++
>  arch/x86/kvm/mmu/spte.c |  1 +
>  arch/x86/kvm/mmu/spte.h |  2 --
>  arch/x86/kvm/svm/sev.c  | 10 ++++++++++
>  4 files changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index a99acec925eb..6bdaacb6faa0 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -6,6 +6,8 @@
>  #include "kvm_cache_regs.h"
>  #include "cpuid.h"
> =20
> +extern bool __read_mostly enable_mmio_caching;
> +
>  #define PT_WRITABLE_SHIFT 1
>  #define PT_USER_SHIFT 2
> =20
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 66f76f5a15bd..03ca740bf721 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -22,6 +22,7 @@
>  bool __read_mostly enable_mmio_caching =3D true;
>  static bool __ro_after_init allow_mmio_caching;
>  module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
> +EXPORT_SYMBOL_GPL(enable_mmio_caching);
> =20
>  u64 __read_mostly shadow_host_writable_mask;
>  u64 __read_mostly shadow_mmu_writable_mask;
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 26b144ffd146..9a9414b8d1d6 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -5,8 +5,6 @@
> =20
>  #include "mmu_internal.h"
> =20
> -extern bool __read_mostly enable_mmio_caching;
> -
>  /*
>   * A MMU present SPTE is backed by actual memory and may or may not be p=
resent
>   * in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11=
, as it
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 309bcdb2f929..05bf6301acac 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -22,6 +22,7 @@
>  #include <asm/trapnr.h>
>  #include <asm/fpu/xcr.h>
> =20
> +#include "mmu.h"
>  #include "x86.h"
>  #include "svm.h"
>  #include "svm_ops.h"
> @@ -2205,6 +2206,15 @@ void __init sev_hardware_setup(void)
>  	if (!sev_es_enabled)
>  		goto out;
> =20
> +	/*
> +	 * SEV-ES requires MMIO caching as KVM doesn't have access to the guest
> +	 * instruction stream, i.e. can't emulate in response to a #NPF and
> +	 * instead relies on #NPF(RSVD) being reflected into the guest as #VC
> +	 * (the guest can then do a #VMGEXIT to request MMIO emulation).
> +	 */
> +	if (!enable_mmio_caching)
> +		goto out;
> +
>=20

I am not familiar with SEV, but looks it is similar to TDX -- they both cau=
ses
#VE to guest instead of faulting into KVM. =C2=A0And they both require expl=
icit call
from guest to do MMIO.

In this case, does existing MMIO caching logic still apply to them?  Should=
 we
still treat SEV and TDX's MMIO handling as MMIO caching being enabled?  Or
perhaps another variable?

--=20
Thanks,
-Kai


