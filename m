Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C5055D40A
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242754AbiF0Wuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 18:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240124AbiF0Wup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 18:50:45 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4131F215;
        Mon, 27 Jun 2022 15:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656370244; x=1687906244;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=WBRX+DWd953nPYpjovL55VvK/pzOBLMxlYRtnDYODx4=;
  b=hhabvVspqnN2ILFUOdfdtrA02ieJ2XRYJqkOTsFgusGSv5UO5AhZjq+/
   aU+2r/e0PzJnZEpDanf2gJhkOcdfM+7roE8KssAz/FvC5PN6nlnYSLt4W
   J5jgzhnad1c0iJlfKrmpv/jvRk8Du+aGDHNEcm3rE2aRPwCfwDVK5boa+
   1LVOPicRn9rVwGADRvCAId3LsCyEjsdftJLmrQyJmF/NLcuUOsj6wPqfy
   6HVvPSnmTN+frGaVFAWaUsl9UouPsXXEqZqcKpKp79OY1yzPFNqCygaB7
   qYGTD5eWdOh6Z5XzJzCh4tYR7lieYbLUnw4OXGCXIZazAsVhPdudUsirC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="343268820"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="343268820"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 15:50:42 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="616964404"
Received: from iiturbeo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.89.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 15:50:38 -0700
Message-ID: <a610ae9bd554f31364193abc928fad86ed5ebf7c.camel@intel.com>
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
Date:   Tue, 28 Jun 2022 10:50:36 +1200
In-Reply-To: <b43bf089-1202-a1fe-cbb3-d4e0926cab67@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <c504a8acd06dc455050c25e2a4cc70aef5eb9358.1655894131.git.kai.huang@intel.com>
         <e72703b0-767a-ec88-7cb6-f95a3564d823@intel.com>
         <b376aef05bc032fdf8cc23762ce77a14830440cd.camel@intel.com>
         <b43bf089-1202-a1fe-cbb3-d4e0926cab67@intel.com>
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

On Mon, 2022-06-27 at 13:41 -0700, Dave Hansen wrote:
> On 6/27/22 03:31, Kai Huang wrote:
> > > > +/* Page sizes supported by TDX */
> > > > +enum tdx_page_sz {
> > > > +	TDX_PG_4K,
> > > > +	TDX_PG_2M,
> > > > +	TDX_PG_1G,
> > > > +	TDX_PG_MAX,
> > > > +};
> > > Are these the same constants as the magic numbers in Kirill's
> > > try_accept_one()?
> > try_accept_once() uses 'enum pg_level' PG_LEVEL_{4K,2M,1G} directly.  T=
hey can
> > be used directly too, but 'enum pg_level' has more than we need here:
>=20
> I meant this:
>=20
> +       switch (level) {
> +       case PG_LEVEL_4K:
> +               page_size =3D 0;
> +               break;
>=20
> Because TDX_PG_4K=3D=3Dpage_size=3D=3D0, and for this:
>=20
> +       case PG_LEVEL_2M:
> +               page_size =3D 1;
>=20
> where TDX_PG_2M=3D=3Dpage_size=3D=3D1
>=20
> See?
>=20
> Are Kirill's magic 0/1/2 numbers the same as
>=20
> 	TDX_PG_4K,
> 	TDX_PG_2M,
> 	TDX_PG_1G,
>=20
> ?

Yes they are the same.  Kirill uses 0/1/2 as input of TDX_ACCEPT_PAGE TDCAL=
L.=20
Here I only need them to distinguish different page sizes.

Do you mean we should put TDX_PG_4K/2M/1G definition to asm/tdx.h, and
try_accept_one() should use them instead of magic 0/1/2?


--=20
Thanks,
-Kai


