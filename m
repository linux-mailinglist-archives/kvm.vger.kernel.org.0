Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96190560CEB
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 01:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiF2XCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 19:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiF2XCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 19:02:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72D8103;
        Wed, 29 Jun 2022 16:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656543757; x=1688079757;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=3LwbZC6SpyOpkEwBO5bm7kbaT9CNgLksFlrTWyOhb6A=;
  b=kYUwK18WcFKdbNonoZYwY7V2IHWHMHU7oIJtYlDnp8CUMsUj9Whit/cL
   r0lMYfclfJt6nG1pJFN5fgS9JyZ9jSN0szQ6Dl8A+r77hYx5SpJmkHMfv
   OhSgxReMnxhbHIv2QDDIo3KYlOyaabD5jcwqTpsLtnIRdpjbspai5N8zU
   73INQm8ZDfXhHl+lxGLbQBUiW8k4hawmv05RvCX+wuEm6WDIBtBSeIWRq
   aV1qBwhE/QGI+FhGFHRRzxLFkoAI+IqP/ZldqruMQ14RLL+Yjpd045mZc
   twKgKph2RgYvNc9Oi4qIDY+ZD+SsHOZZNzUKgzrKrdZUGFXLOpkBtPFmJ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="368500691"
X-IronPort-AV: E=Sophos;i="5.92,232,1650956400"; 
   d="scan'208";a="368500691"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 16:02:37 -0700
X-IronPort-AV: E=Sophos;i="5.92,232,1650956400"; 
   d="scan'208";a="647619213"
Received: from zhihuich-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.49.124])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 16:02:33 -0700
Message-ID: <292182cbe779aade47580ac23dc304856619c799.camel@intel.com>
Subject: Re: [PATCH v5 04/22] x86/virt/tdx: Prevent ACPI CPU hotplug and
 ACPI memory hotplug
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, Chao Gao <chao.gao@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com
Date:   Thu, 30 Jun 2022 11:02:31 +1200
In-Reply-To: <a2277c2f-91a1-871f-08f1-42950bca53b3@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <3a1c9807d8c140bdd550cd5736664f86782cca64.1655894131.git.kai.huang@intel.com>
         <20220624014112.GA15566@gao-cwp>
         <951da5eeb4214521635602ce3564246ad49018f5.camel@intel.com>
         <a2277c2f-91a1-871f-08f1-42950bca53b3@intel.com>
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

On Wed, 2022-06-29 at 07:22 -0700, Dave Hansen wrote:
> On 6/24/22 04:21, Kai Huang wrote:
> > Personally I don't quite like this way.  To me having separate function=
 for host
> > and guest is more clear and more flexible.  And I don't think having
> > #ifdef/endif has any problem.  I would like to leave to maintainers.
>=20
> It has problems.
>=20
> Let's go through some of them.  First, this:
>=20
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
>=20
> What does that #ifdef get us?  I suspect you're back to trying to
> silence compiler warnings with #ifdefs.  The compiler *knows* that it's
> only used in this file.  It's also used all of once.  If you make it
> 'static inline', you'll likely get the same code generation, no
> warnings, and don't need an #ifdef.

The purpose is not to avoid warning, but to make intel_cc_platform_has(enum
cc_attr attr) simple that when neither TDX host and TDX guest code is turne=
d on,
it can be simple:

	static bool  intel_cc_platform_has(enum cc_attr attr)
	{
		return false;
	}

So I don't need to depend on how internal functions are implemented in the
header files and I don't need to guess how does compiler generate code.

And also because I personally believe it doesn't hurt readability.=20

>=20
> The other option is to totally lean on the compiler to figure things
> out.  Compile this program, then disassemble it and see what main() does.
>=20
> static void func(void)
> {
> 	printf("I am func()\n");
> }
>=20
> void main(int argc, char **argv)
> {
> 	if (0)
> 		func();
> }
>=20
> Then, do:
>=20
> -	if (0)
> +	if (argc)
>=20
> and run it again.  What changed in the disassembly?

You mean compile it again?  I have to confess I never tried and don't know.=
=20
I'll try when I got some spare time.  Thanks for the info.

>=20
> > +static bool intel_cc_platform_has(enum cc_attr attr)
> > +{
> > +#ifdef CONFIG_INTEL_TDX_GUEST
> > +	if (boot_cpu_has(X86_FEATURE_TDX_GUEST))
> > +		return intel_tdx_guest_has(attr);
> > +#endif
>=20
> Make this check cpu_feature_enabled(X86_FEATURE_TDX_GUEST).  That has an
> #ifdef built in to it.  That gets rid of this #ifdef.  You have
>=20
> > +#ifdef CONFIG_INTEL_TDX_HOST
> > +	if (platform_tdx_enabled())
> > +		return intel_tdx_host_has(attr);
> > +#endif
> > +	return false;
> > +}
>=20
> Now, let's turn our attention to platform_tdx_enabled().  Here's its
> stub and declaration:
>=20
> > +#ifdef CONFIG_INTEL_TDX_HOST
> > +bool platform_tdx_enabled(void);
> > +#else  /* !CONFIG_INTEL_TDX_HOST */
> > +static inline bool platform_tdx_enabled(void) { return false; }
> > +#endif /* CONFIG_INTEL_TDX_HOST */
>=20
> It already has an #ifdef CONFIG_INTEL_TDX_HOST, so that #ifdef can just
> go away.
>=20
> Kai, the reason that we have the rule that Yuan cited:
>=20
> > "Wherever possible, don't use preprocessor conditionals (#if, #ifdef) i=
n .c"
> > From Documentation/process/coding-style.rst, 21) Conditional Compilatio=
n.
>=20
> is not because there are *ZERO* #ifdefs in .c files.  It's because
> #ifdefs in .c files hurt readability and are usually avoidable.  How do
> you avoid them?  Well, you take a moment and look at the code and see
> how other folks have made it readable.  It takes refactoring of code to
> banish #ifdefs to headers or replace them with compiler constructs so
> that the compiler can do the work behind the scenes.

Yes I understand the purpose of this rule. Thanks for explaining.
=20
>=20
> Kai, could you please take the information I gave you in this message
> and try to apply it across this series?  Heck, can you please take it
> and use it to review others' code to make sure they don't encounter the
> same pitfalls?

Thanks for the tip.  Will do.

Btw this patch is the only one in this series that has this #ifdef problem,=
 and
it will be gone in next version based on feedbacks that I received.  But I'=
ll
check again.

--=20
Thanks,
-Kai


