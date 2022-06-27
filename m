Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14BC455D683
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240947AbiF0XFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 19:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241325AbiF0XFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 19:05:46 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0452822505;
        Mon, 27 Jun 2022 16:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656371145; x=1687907145;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=uLaA/4ndZpFufF/4En6ObZrDG4ixWE8Z0A/2SpuaNbw=;
  b=d8aq18CYMTKcyQS9sq6WJjQiQIllJ5rEeuk7cHA7utkEFgtbnUoGvix4
   Ag+rqDJ5ymib+wXS5nLedQ10qULLG5ywP5XwdiklSYaVmNtRC++QNS/LP
   /s9Z34Y15yXIAiqs/jbKYGb+mNPppPndN9vmfjd3xDTvwl95kOF8o09SH
   XXdpLfJf4MBXCn/y0sFJ7YHFi7R8knj+qHGoCVR/RNwH11E1Foyw0Ggil
   0f9F5NFiUzs/cUb+gTnsRRA5Ou8fCppCXZ8XgyDxdG48vEUKcAUh39z8c
   UbnMLSedTR41N/qN/Db/Ni5fWo7nDsuJZikDICgOG5/tD4PA3Bxk++aHl
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="367895815"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="367895815"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 16:05:45 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="622723951"
Received: from iiturbeo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.89.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 16:05:42 -0700
Message-ID: <cd20e976db25b16ed5152bb3c6dc357d64922c5f.camel@intel.com>
Subject: Re: [PATCH v5 15/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Tue, 28 Jun 2022 11:05:40 +1200
In-Reply-To: <3253e9fa-14f8-085e-5f13-bb70fea89abf@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <c504a8acd06dc455050c25e2a4cc70aef5eb9358.1655894131.git.kai.huang@intel.com>
         <e72703b0-767a-ec88-7cb6-f95a3564d823@intel.com>
         <b376aef05bc032fdf8cc23762ce77a14830440cd.camel@intel.com>
         <b43bf089-1202-a1fe-cbb3-d4e0926cab67@intel.com>
         <a610ae9bd554f31364193abc928fad86ed5ebf7c.camel@intel.com>
         <3253e9fa-14f8-085e-5f13-bb70fea89abf@intel.com>
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

On Mon, 2022-06-27 at 15:57 -0700, Dave Hansen wrote:
> On 6/27/22 15:50, Kai Huang wrote:
> > > Are Kirill's magic 0/1/2 numbers the same as
> > >=20
> > > 	TDX_PG_4K,
> > > 	TDX_PG_2M,
> > > 	TDX_PG_1G,
> > >=20
> > > ?
> > Yes they are the same.  Kirill uses 0/1/2 as input of TDX_ACCEPT_PAGE T=
DCALL.=20
> > Here I only need them to distinguish different page sizes.
> >=20
> > Do you mean we should put TDX_PG_4K/2M/1G definition to asm/tdx.h, and
> > try_accept_one() should use them instead of magic 0/1/2?
>=20
> I honestly don't care how you do it as long as the magic numbers go away
> (within reason).

OK.  I'll write a patch to replace 0/1/2 magic numbers in try_accept_one().

--=20
Thanks,
-Kai


