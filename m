Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58CE5573476
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 12:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbiGMKli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 06:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGMKlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 06:41:37 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04061FD538;
        Wed, 13 Jul 2022 03:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657708897; x=1689244897;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=PwD9TFImE+PjxaSsdW4DYoJEIRrFNbRZl2lEnpZjWJw=;
  b=aiw10JWVvQ+fEoWt4pFNIuQgW3JMgbCp/8Rnq197IkzDJKal2jWhu0Uh
   hSZfl/PuaEKwrFTy9O0aTKTpqxggoThKl1zCzqUPUB3PPKWRIfAg4mRSc
   pbCDEW5e757m/tl5hPCqJrRIdK0wJ+UUBc1Obabu62E8xwyyIS6K3T1E5
   G74jrJAyhADCdxbeGB3D/uIGmjK2UIUIHsGgMzSeTofr+lsGwl+N//cle
   K8CLx7lTF2bjnZwodZVenaYAQtqZNmHpOplYpdoND8jbNOxxRb0z8ofKI
   H886PLmiOIPjCkyGf8WRKOHzKIHw22/Suwx4EAm2R3vZbYReezrzLubw8
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="283930597"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="283930597"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 03:41:36 -0700
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="841712353"
Received: from ifatima-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.1.196])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 03:41:35 -0700
Message-ID: <e4a106ba016d790af60ed72492695ab2b905ede1.camel@intel.com>
Subject: Re: [PATCH v7 033/102] KVM: x86/mmu: Add address conversion
 functions for TDX shared bits
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Date:   Wed, 13 Jul 2022 22:41:33 +1200
In-Reply-To: <20220713045225.GP1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <69f4b4942d5f17fad40a8d08556488b8e4b7954d.1656366338.git.isaku.yamahata@intel.com>
         <6cc36b662dffaf0aa2a2f389f073daa2d63a530b.camel@intel.com>
         <20220713045225.GP1379820@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> >=20
> > And by applying this patch, nothing will prevent you to turn on INTEL_T=
DX_HOST
> > and KVM_INTEL, which also turns on KVM_MMU_PRIVATE.
> >=20
> > So 'kvm_arch::gfn_shared_mask' is guaranteed to be 0?  If not, can lega=
l
> > (shared) GFN for normal VM be potentially treated as private?
> >=20
> > If yes, perhaps explicitly call out in changelog so people don't need t=
o worry
> > about?
>=20
> struct kvm that includes struct kvm_arch is guaranteed to be zero.
>=20
> Here is the updated commit message.
>=20
> Author: Isaku Yamahata <isaku.yamahata@intel.com>
> Date:   Tue Jul 12 00:10:13 2022 -0700
>=20
>     KVM: x86/mmu: Add address conversion functions for TDX shared bit of =
GPA
>    =20
>     TDX repurposes one GPA bit (51 bit or 47 bit based on configuration) =
to
>     indicate the GPA is private(if cleared) or shared (if set) with VMM. =
 If
>     GPA.shared is set, GPA is converted existing conventional EPT pointed=
 by
>     EPTP.  If GPA.shared bit is cleared, GPA is converted by TDX module.
>     VMM has to issue SEAMCALLs to operate.

Sorry what does "GPA is converted ..." mean?


--=20
Thanks,
-Kai


