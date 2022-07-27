Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C515826ED
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 14:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbiG0MrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 08:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiG0MrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 08:47:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289D21CB26;
        Wed, 27 Jul 2022 05:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658926035; x=1690462035;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=6yfECxzeuBHnNk9O6XrYbgAxEG+46JckcwYj/fktdKI=;
  b=DXQw4sWGgCEanyfopO5HHcky6z1S3G91t8OxqJ+XBZDUUWdTnUK3eN+m
   3gYYxtHgxbmtIdfECcQjkRKf4CQ8zYosTHivGFaAESxZPTl+nMeFPoi2O
   aRJ887nyc/M5J31nnsF7RVzsUOHjXHrMH4DGF8OzB0qpNrj0UZPXOmYzs
   OxnOYiYqnKNYN+oRFknW0CFcaoGTOLuRtUbaMESLa56EniEcyLmrJO9sT
   +cW74NTr4ZlExSGIqPNroMJhtcH/X6iUrdIZVfqdC/I1FJwPUQKSMcfGS
   vm0BQAAN6OUjkRnCdvNZxAf54mc6sGXpDcl3wOgypicAXa1+SmzaJqF/C
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="268606391"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="268606391"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 05:47:01 -0700
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="604137145"
Received: from jlseahol-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.1.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 05:46:58 -0700
Message-ID: <59a2748ed446f3e8a00834982b54848937a97379.camel@intel.com>
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
Date:   Thu, 28 Jul 2022 00:46:56 +1200
In-Reply-To: <81b70f92-d869-f56d-a152-11aff4e1d785@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <095e6bbc57b4470e1e9a9104059a5238c9775f00.1655894131.git.kai.huang@intel.com>
         <069a062e-a4a6-09af-7b74-7f4929f2ec0b@intel.com>
         <5ce7ebfe54160ea35e432bf50207ebed32db31fc.camel@intel.com>
         <84e93539-a2f9-f68e-416a-ea3d8fc725af@intel.com>
         <6bef368ccc68676e4acaecc4b6dc52f598ea7f2f.camel@intel.com>
         <ea03e55499f556388c0a5f9ed565e72e213c276f.camel@intel.com>
         <978c3d37-97c9-79b9-426a-2c27db34c38a@intel.com>
         <0b20f1878d31658a9e3cd3edaf3826fe8731346e.camel@intel.com>
         <11b7e8668fde31ead768075e51f9667276ddc78a.camel@intel.com>
         <81b70f92-d869-f56d-a152-11aff4e1d785@intel.com>
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

On Tue, 2022-07-26 at 17:50 -0700, Dave Hansen wrote:
> On 7/26/22 17:34, Kai Huang wrote:
> > > This doesn't seem right to me.  *If* we get a known-bogus
> > > hot-remove event, we need to reject it.  Remember, removal is a
> > > two-step process.
> > If so, we need to reject the (CMR) memory offline.  Or we just BUG()
> > in the ACPI memory removal  callback?
> >=20
> > But either way this will requires us to get the CMRs during kernel boot=
.
>=20
> I don't get the link there between CMRs at boot and handling hotplug.
>=20
> We don't need to go to extreme measures just to get a message out of the
> kernel that the BIOS is bad.  If we don't have the data to do it
> already, then I don't really see the nee to warn about it.
>=20
> Think of a system that has TDX enabled in the BIOS, but is running an
> old kernel.  It will have *ZERO* idea that hotplug doesn't work.  It'll
> run blissfully along.  I don't see any reason that a kernel with TDX
> support, but where TDX is disabled should actively go out and try to be
> better than those old pre-TDX kernels.

Agreed, assuming "where TDX is disabled" you mean TDX isn't usable (i.e. wh=
en
TDX module isn't loaded, or won't be initialized at all).

>=20
> Further, there's nothing to stop non-CMR memory from being added to a
> system with TDX enabled in the BIOS but where the kernel is not using
> it.  If we actively go out and keep good old DRAM from being added, then
> we unnecessarily addle those systems.
>=20

OK.

Then for memory hot-add, perhaps we can just go with the "winner-take-all"
approach you mentioned before?

For memory hot-removal, as I replied previously, looks the kernel cannot re=
ject
the removal if it allows memory offline.  Any suggestion on this?

--=20
Thanks,
-Kai


