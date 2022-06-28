Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 211A855CC52
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240998AbiF1ALr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 20:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiF1ALp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 20:11:45 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3A0E23;
        Mon, 27 Jun 2022 17:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656375104; x=1687911104;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=iWzth0TFp2xoI4HuDRWuLYcLQRT/vvYkmS/L3jpAi3Y=;
  b=AUaqnSpfoDxERaFAP3YFwGVRZakNPkWW6ev4dY+UXFpTUgGErTH02nKO
   t5/w03AEH7Co5LlrewpILe95OP2OTnHK2Rga/Qrji604V8M+ZJLzS6Edg
   sq1MDNwD9ftklLar+wYcUx/HKtvmywh6FyjZZf+M2h6L9RrUKEUK5T77E
   kZA80pIZPIZqi2fws3DLoc9tdzny9SXOZrp86ignT10oLTXXBerGAvJnV
   GjMS11wKJJlsANv5+dSDHvZ+ugmrV6nOOOwQUUia1JXxz1BOTrOgtwA2n
   UcL5dhLwm9EmC3WsWc35mTixjMgHlAXFcwQz0cBDSz74mPO0BOa9pbGZw
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282683743"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="282683743"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 17:11:43 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="679801539"
Received: from iiturbeo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.89.183])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 17:11:40 -0700
Message-ID: <cbc30b0ece76cc02cbfa20321ad9285f2322dfe6.camel@intel.com>
Subject: Re: [PATCH v5 08/22] x86/virt/tdx: Shut down TDX module in case of
 error
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
Date:   Tue, 28 Jun 2022 12:11:38 +1200
In-Reply-To: <606f7526-23b8-a114-020f-b5fcdeecf90b@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <89fffc70cdbb74c80bb324364b712ec41e5f8b91.1655894131.git.kai.huang@intel.com>
         <765a20f1-681d-33c2-68e9-24cc249fe6f9@intel.com>
         <cc90e5f8be0c6f48a144240d4569b15bd4b75dd8.camel@intel.com>
         <77c90075-79d4-7cc7-f266-1b67e586513b@intel.com>
         <2b94afd608303f104376e6a775b211714e34bc7e.camel@intel.com>
         <6ed2746d-f44c-4511-7373-5706dd7c3f0f@intel.com>
         <a3831d3fc926905585f9fb1e14e13e502c1f5b65.camel@intel.com>
         <606f7526-23b8-a114-020f-b5fcdeecf90b@intel.com>
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

On Mon, 2022-06-27 at 17:03 -0700, Dave Hansen wrote:
> On 6/27/22 16:59, Kai Huang wrote:
> > If so,  in the assembly, I think we can just XOR TDX_SW_ERROR to the %r=
ax and
> > return %rax:
> >=20
> > 2:
> >         /*
> > 	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
> > 	 * the trap number.  Convert trap number to TDX error code by setting
> > 	 * TDX_SW_ERROR to the high 32-bits of %rax.
> > 	 */
> > 	xorq	$TDX_SW_ERROR, %rax
> >=20
> > How does this look?
>=20
> I guess it doesn't matter if you know the things being masked together
> are padded correctly, but I probably would have done a straight OR, not X=
OR.
>=20
> Otherwise, I think that looks OK.  Simplifies the assembly for sure.

Right straight OR is better.  Thanks.

--=20
Thanks,
-Kai


