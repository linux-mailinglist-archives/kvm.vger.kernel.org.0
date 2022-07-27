Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CF4581CC7
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 02:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbiG0Ae7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 20:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiG0Ae5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 20:34:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8EA21E3C;
        Tue, 26 Jul 2022 17:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658882096; x=1690418096;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=oj0a7ciB+oV2JDlpMOophnV6rsjbBt2dt3kT1WIKuDw=;
  b=SDQZCkp1FGsJgUXE9yDLMgd7hDpeXyxNb0Pzjwv/NLzI1N6+mR2Sl1FW
   kScMIFwlIycaG3cjGLpNhNgVoKOlll/+OOiAjgEFJG/a9uZeDizua63yc
   KW7exo1Ln3Qx6/qwBTkVlExOGZjTFYophCs5HTFeNh0pFPbQK1cHfWTM4
   rdtCqVgzGs/YYkcTKSjRvzE9GaMPI/1uWuI8cU3xCEO2LDbGRCSE8ZCqV
   kspNWa4J/CaMvt/K0/xevmcEHZhPM6CDSrptuJUckd5xGmbdgBHNGXYf1
   ef0koRnQHHKRrL9sek7kCKQHwvK3LcdwaPN7u35bt6hQMHf4iHS5F9xkA
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="289301241"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="289301241"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 17:34:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="600209055"
Received: from rgevard-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.32.51])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 17:34:52 -0700
Message-ID: <11b7e8668fde31ead768075e51f9667276ddc78a.camel@intel.com>
Subject: Re: [PATCH v5 07/22] x86/virt/tdx: Implement SEAMCALL function
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
Date:   Wed, 27 Jul 2022 12:34:50 +1200
In-Reply-To: <0b20f1878d31658a9e3cd3edaf3826fe8731346e.camel@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
         <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
         <5ce7ebfe54160ea35e432bf50207ebed32db31fc.camel@intel.com>
         <84e93539-a2f9-f68e-416a-ea3d8fc725af@intel.com>
         <6bef368ccc68676e4acaecc4b6dc52f598ea7f2f.camel@intel.com>
         <ea03e55499f556388c0a5f9ed565e72e213c276f.camel@intel.com>
         <978c3d37-97c9-79b9-426a-2c27db34c38a@intel.com>
         <0b20f1878d31658a9e3cd3edaf3826fe8731346e.camel@intel.com>
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

On Thu, 2022-07-21 at 13:52 +1200, Kai Huang wrote:
> > > BUT, since as the first step, we cannot get the CMR during kernel boo=
t (as
> > > it
> > > requires additional code to put CPU into VMX operation), I think for =
now
> > > we can
> > > handle ACPI memory hotplug in below way:
> > >=20
> > > - For memory hot-removal, we do nothing.
> >=20
> > This doesn't seem right to me.=C2=A0 *If* we get a known-bogus hot-remo=
ve
> > event, we need to reject it.=C2=A0 Remember, removal is a two-step proc=
ess.
>=20
> If so, we need to reject the (CMR) memory offline.=C2=A0 Or we just BUG()=
 in the
> ACPI
> memory removal=C2=A0 callback?
>=20
> But either way this will requires us to get the CMRs during kernel boot.
>=20
> Do you think we need to add this support in the first series?

Hi Dave,

In terms of whether we should get CMRs during kernel boot (which requires w=
e do
VMXON/VMXOFF during kernel boot around SEAMCALL), I forgot one thing:

Technically, ACPI memory hotplug is related to whether TDX is enabled in BI=
OS,
but not related to whether TDX module is loaded or not.  With doing
VMXON/VMXOFF, we can get CMRs during kernel boot by calling P-SEAMLDR's
SEAMCALL.  But theoretically, from TDX architecture's point of view, the P-
SEAMLDR may not be loaded even TDX is enabled by BIOS (in practice, the P-
SEAMLDR is always loaded by BIOS when TDX is enabled), in which case there'=
s no
way we can get CMRs.  But in this case, I think we can just treat TDX isn't
enabled by BIOS as kernel should never try to load P-SEAMLDR.

Other advantages of being able to do VMXON/VMXOFF and getting CMRs during k=
ernel
boot:

1) We can just shut down the TDX module in kexec();
2) We can choose to trim any non-CMR memory out of memblock.memory instead =
of
having to manually verify all memory regions in memblock are CMR memory.

Comments?
