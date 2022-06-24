Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE9E55986E
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 13:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiFXLWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 07:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiFXLWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 07:22:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8342079465;
        Fri, 24 Jun 2022 04:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656069725; x=1687605725;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=TqMaSYDiPwgOdjjOGF2zwrDO0PbjQMwjiYFS1UhbBm8=;
  b=YVEF//9tOZFfUAV97m8kEdPf0nsVz1FR/n50agr9aZjl/jTRk3rtl6jU
   y2nMqoYF5s9s2G96gaOmiMrukfyXGcCuuRRDp4O8Iy3frU1RaT6hGYmYU
   u6MsF9pbsDHkUepzYAPbTe3JAf+5ZPu0KkihJhCsfDrYGGRnHDZJRVU1l
   NFHklGs2zrsMBKY/mDBxYSKAShYn4BesjhEovVwL9xxnysgiMoki6gkUj
   e0sG0aGWx9LUcqf0qpuDwzJ7Vqzzxe+Rdv5CBkRm9V9cgjimf0P8SUnnh
   MJ8zsHFvWanREunyzN9c0VxL4pGb41cmzg9BEDQxnWU5nRleuHiE6uC46
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="264019964"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="264019964"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 04:22:05 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="835089568"
Received: from jvrobert-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.99.67])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 04:22:01 -0700
Message-ID: <951da5eeb4214521635602ce3564246ad49018f5.camel@intel.com>
Subject: Re: [PATCH v5 04/22] x86/virt/tdx: Prevent ACPI CPU hotplug and
 ACPI memory hotplug
From:   Kai Huang <kai.huang@intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com
Date:   Fri, 24 Jun 2022 23:21:59 +1200
In-Reply-To: <20220624014112.GA15566@gao-cwp>
References: <cover.1655894131.git.kai.huang@intel.com>
         <3a1c9807d8c140bdd550cd5736664f86782cca64.1655894131.git.kai.huang@intel.com>
         <20220624014112.GA15566@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-24 at 09:41 +0800, Chao Gao wrote:
> On Wed, Jun 22, 2022 at 11:16:07PM +1200, Kai Huang wrote:
> > -static bool intel_cc_platform_has(enum cc_attr attr)
> > +#ifdef CONFIG_INTEL_TDX_GUEST
> > +static bool intel_tdx_guest_has(enum cc_attr attr)
> > {
> > 	switch (attr) {
> > 	case CC_ATTR_GUEST_UNROLL_STRING_IO:
> > @@ -28,6 +31,33 @@ static bool intel_cc_platform_has(enum cc_attr attr)
> > 		return false;
> > 	}
> > }
> > +#endif
> > +
> > +#ifdef CONFIG_INTEL_TDX_HOST
> > +static bool intel_tdx_host_has(enum cc_attr attr)
> > +{
> > +	switch (attr) {
> > +	case CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED:
> > +	case CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED:
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +#endif
> > +
> > +static bool intel_cc_platform_has(enum cc_attr attr)
> > +{
> > +#ifdef CONFIG_INTEL_TDX_GUEST
> > +	if (boot_cpu_has(X86_FEATURE_TDX_GUEST))
> > +		return intel_tdx_guest_has(attr);
> > +#endif
> > +#ifdef CONFIG_INTEL_TDX_HOST
> > +	if (platform_tdx_enabled())
> > +		return intel_tdx_host_has(attr);
> > +#endif
> > +	return false;
> > +}
>=20
> how about:
>=20
> static bool intel_cc_platform_has(enum cc_attr attr)
> {
> 	switch (attr) {
> 	/* attributes applied to TDX guest only */
> 	case CC_ATTR_GUEST_UNROLL_STRING_IO:
> 	...
> 		return boot_cpu_has(X86_FEATURE_TDX_GUEST);
>=20
> 	/* attributes applied to TDX host only */
> 	case CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED:
> 	case CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED:
> 		return platform_tdx_enabled();
>=20
> 	default:
> 		return false;
> 	}
> }
>=20
> so that we can get rid of #ifdef/endif.

Personally I don't quite like this way.  To me having separate function for=
 host
and guest is more clear and more flexible.  And I don't think having
#ifdef/endif has any problem.  I would like to leave to maintainers.

--=20
Thanks,
-Kai


