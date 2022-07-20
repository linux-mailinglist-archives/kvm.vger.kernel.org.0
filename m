Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901EC57B03B
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 07:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237152AbiGTFNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 01:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGTFNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 01:13:13 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACA84AD65;
        Tue, 19 Jul 2022 22:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658293992; x=1689829992;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=eAtnJumVQAm0T+41TDojL5uPrcX3NmL0wuZdQlTLyz8=;
  b=b8ZRICjPnugnfmEVD32w6lEyxeR0K6PulyzIK41x4RoGrQIHYMHh+Q69
   LYdlOj65ba9ux6nTYTkBmdIxC0PsxXaRAYwH3xrIIzIpJjX6f0vHv+shW
   F8m4RN4l1GeRAud2+ToSpHFFN1HTt3Zh3xXC3x1xV5jmTjn1BrXWY+lYU
   1jkRcLsWDjPkxwtV14MXd55JO1XtH09kreOVDRSMtKHWjrWI+hvwegl4c
   UXa04A/clR5c5JAugApBCqyu0iN/vQ0Loytd8go90AvynZZo3ChDrOuEW
   JhYIHRcBJQV/v2wUR+bPcpPe0vnEXN2pcdYE0zziiOesrqnZHO08efUIH
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="348375437"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="348375437"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 22:13:12 -0700
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="601837332"
Received: from ecurtis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.162.137])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 22:13:10 -0700
Message-ID: <9945dbf586d8738b7cf0af53bfb760da9eb9e882.camel@intel.com>
Subject: Re: [PATCH v7 041/102] KVM: VMX: Introduce test mode related to EPT
 violation VE
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 20 Jul 2022 17:13:08 +1200
In-Reply-To: <20220719144936.GX1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <cadf3221e3f7b911c810f15cfe300dd5337a966d.1656366338.git.isaku.yamahata@intel.com>
         <52915310c9118a124da2380daf3d753a818de05e.camel@intel.com>
         <20220719144936.GX1379820@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-19 at 07:49 -0700, Isaku Yamahata wrote:
> On Fri, Jul 08, 2022 at 02:23:43PM +1200,
> Kai Huang <kai.huang@intel.com> wrote:
>=20
> > On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >=20
> > > To support TDX, KVM is enhanced to operate with #VE.  For TDX, KVM pr=
ograms
> > > to inject #VE conditionally and set #VE suppress bit in EPT entry.  F=
or VMX
> > > case, #VE isn't used.  If #VE happens for VMX, it's a bug.  To be
> > > defensive (test that VMX case isn't broken), introduce option
> > > ept_violation_ve_test and when it's set, set error.
> >=20
> > I don't see why we need this patch.  It may be helpful during your test=
, but why
> > do we need this patch for formal submission?
> >=20
> > And for a normal guest, what prevents one vcpu from sending #VE IPI to =
another
> > vcpu?
>=20
> Paolo suggested it as follows.  Maybe it should be kernel config.
> (I forgot to add suggested-by. I'll add it)
>=20
> https://lore.kernel.org/lkml/84d56339-4a8a-6ddb-17cb-12074588ba9c@redhat.=
com/
>=20
> >=20

OK.  But can we assume a normal guest won't sending #VE IPI?

