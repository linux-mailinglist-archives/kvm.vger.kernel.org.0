Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486B857AF66
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 05:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbiGTDPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 23:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242648AbiGTDPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 23:15:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBAB323;
        Tue, 19 Jul 2022 20:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658286744; x=1689822744;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ySMjzh3NsTJKTRrIejBJDaESWOXt7P0Fuvi7p6w8yJ0=;
  b=fvqXHNxyKJBi4fyA1OQ2GWC6m4ZXZ4KeGJ+2j2Ad7GL3BGZYcbS8F+8s
   WO6ECzg4F6u9JuAg03VrxCGy5xURWH/WihjJaYKU/fOW9v9GWGJeqb6IH
   K5fVu3LwO8i7cwYKG+kL5//z1QidnrRsZc4rJw8xeG0vh9vEe1mFmwbpQ
   GGWoI07305MfRmR1e5vjE8jF1gI4I5DVxKcUoUko0dZAsxHy0p+sMX4+o
   zbiDYVUAWoMK8+Koz3w3rRU04BfK7dG6EMqwthyFPlJk+8msDNZbyDALp
   01oaJZzrlgG0fRbCZi/S01MZrS0aXRUW6ruea8gV4hHWAucaStTP3QzNZ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="269693302"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="269693302"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 20:12:21 -0700
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="630603712"
Received: from ecurtis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.162.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 20:12:18 -0700
Message-ID: <d7f60ee5e2bdd72e8b1fbcabb753170167674eee.camel@intel.com>
Subject: Re: [PATCH v7 036/102] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>, isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Date:   Wed, 20 Jul 2022 15:12:16 +1200
In-Reply-To: <20220714184111.GT1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <f74b05eca8815744ce1ad672c66033101be7369c.1656366338.git.isaku.yamahata@intel.com>
         <20220714184111.GT1379820@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -36,6 +36,9 @@ u64 __read_mostly shadow_present_mask;
>  u64 __read_mostly shadow_me_value;
>  u64 __read_mostly shadow_me_mask;
>  u64 __read_mostly shadow_acc_track_mask;
> +#ifdef CONFIG_X86_64
> +u64 __read_mostly shadow_nonpresent_value;
> +#endif

Is this ever used?

> =20
>  u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
>  u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
> @@ -360,7 +363,7 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 m=
mio_mask, u64 access_mask)
>  	 * not set any RWX bits.
>  	 */
>  	if (WARN_ON((mmio_value & mmio_mask) !=3D mmio_value) ||
> -	    WARN_ON(mmio_value && (REMOVED_SPTE & mmio_mask) =3D=3D mmio_value)=
)
> +	    WARN_ON(mmio_value && (__REMOVED_SPTE & mmio_mask) =3D=3D mmio_valu=
e))
>  		mmio_value =3D 0;

This chunk doesn't look right, or necessary.  We need mmio_mask/mmio_value =
which
causes EPT violation but with "suppress #VE" bit clear. =20

So, actually, we want to make sure SHADOW_NONPRESENT_VALUE is *NOT* in mmio=
_mask
and mmio_value.  Using (REMOVED_SPTE & mmio_mask) =3D=3D mmio_value can act=
ually
ensure SHADOW_NONPRESENT_VALUE is never set in MMIO spte, correct?  So I th=
ink
using REMOVED_SPTE is fine.

Or maybe additionally adding a explicit check is even better:

	if (WARN_ON(mmio_mask & SHADOW_NONPRESENT_VALUE))
		mmio_value =3D 0;

But this change maybe should be in another patch which deals setting up per=
-VM
mmio_mask/mmio_value anyway.  This patch, instead, focuses on allowing non-=
zero
value for non-present SPTE.

