Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4908D589450
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 00:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbiHCWPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 18:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiHCWPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 18:15:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D50D2C12F;
        Wed,  3 Aug 2022 15:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659564900; x=1691100900;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ihSBBiTfSIoIyGPwT8QW5ZYzZIq6pQBSuzZUV5fNZOA=;
  b=GWCr1WHNh1YJ+n34rJMRZB415n0nio6hT2yQ1gJTc6qGAaC8XO5kW6Fv
   4mkpwa7yiIIdjYpSCVn6wYNk6iwGzctKXTIGHTy81H2enRq4yrXOQADn8
   TpzItoApwme6n3HttZ7caQH8wSzKAoWU7rzHlPKieCJW8x2tOJ4AJjAO8
   KMIpan3ZTXSy1ytRGoD6f5SUkbk33A9w84JMjKnFt6KPyAHJfmkUx8y6J
   kdKmwbahsKfpskNfDcN0LXhecKWGWwSaersQKUa3cCp4JkWalzKok+GUF
   /iH+slnZFKO38HppOgTAq51yhtPXz/EhF3mA5iLS7S9WfIanrPgEAjUMK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10428"; a="291006601"
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="291006601"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 15:14:59 -0700
X-IronPort-AV: E=Sophos;i="5.93,214,1654585200"; 
   d="scan'208";a="930557380"
Received: from jangus-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.8.236])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 15:14:56 -0700
Message-ID: <b4c36488909b474af51b9b7c9d7857d9d6b43fb1.camel@intel.com>
Subject: Re: [PATCH v5 12/22] x86/virt/tdx: Convert all memory regions in
 memblock to TDX memory
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
Date:   Thu, 04 Aug 2022 10:14:54 +1200
In-Reply-To: <675ac8a7-be1c-9e9e-9530-bd1488c99dc9@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <8288396be7fedd10521a28531e138579594d757a.1655894131.git.kai.huang@intel.com>
         <20d63398-928f-0c6f-47ec-8e225c049ad8@intel.com>
         <76d7604ff21b26252733165478d5c54035d84d98.camel@intel.com>
         <880f3991-09e5-2f96-d5ba-213cff05c458@intel.com>
         <da423f82faec260150b158381a24300f3cd00ffa.camel@intel.com>
         <d3236016c46da2cbdf314839255e8806ae23f228.camel@intel.com>
         <675ac8a7-be1c-9e9e-9530-bd1488c99dc9@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-03 at 07:22 -0700, Dave Hansen wrote:
> On 8/2/22 18:30, Kai Huang wrote:
> > On Fri, 2022-07-08 at 11:34 +1200, Kai Huang wrote:
> > > > Why not just entirely remove the lower 1MB from the memblock struct=
ure
> > > > on TDX systems?=C2=A0 Do something equivalent to adding this on the=
 kernel
> > > > command line:
> > > >=20
> > > > =C2=A0	memmap=3D1M$0x0
> > > I will explore this option.=C2=A0 Thanks!
> > Hi Dave,
> >=20
> > After investigating and testing, we cannot simply remove first 1MB from=
 e820
> > table which is similar to what 'memmap=3D1M$0x0' does, as the kernel ne=
eds low
> > memory as trampoline to bring up all APs.
>=20
> OK, so don't remove it, but reserve it so that the trampoline code can
> use it.

It's already reserved in the existing reserve_real_mode().  What we need is=
 to
*remove* the first 1MB from memblock.memory, so that the
for_each_mem_pfn_range() will just not get any memory below 1MB.  Otherwise=
 we
need to explicitly skip the first 1MB in TDX code like what I did  in this
series.

--=20
Thanks,
-Kai


