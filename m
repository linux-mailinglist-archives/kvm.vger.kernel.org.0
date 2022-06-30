Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC42562637
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 00:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiF3Wpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 18:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiF3Wpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 18:45:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E56A3700C;
        Thu, 30 Jun 2022 15:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656629130; x=1688165130;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Xb450WiZHQ3MWldX3bJSCbMlNm5BeYPsosRG7tOgLeo=;
  b=nv1ELTApa3fRPA0Aq24Pz6AZo7OU9FDCgjSVw8XdYGecI1ACqGFuTq+N
   4qDbAJgHxGlWZkiG+VmF8X1Bn1jfjzCezhtwI+Yn0YVzltpGaKPM/BU82
   c3dVALoKU7TVbKqSqiIu8y9Dcqwkdki9FwsimKwSeMNlYYedUm1nr0Boe
   UhQ0WpIEOuwcsUT1Ofl/99F7/tyOOoGXTf3irYWH2KRJOUk1h6VIj1S1J
   vVlCIBCHb2sXNF2v+wz42irA1yNZjE5Q1LHiMnAt2XgIqHKCM+uRluSif
   mrckWbIkKGgTrWrFxj4nzi+pkSIYfavKcKt968XWsw0zCpfnMwpXMxW/B
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="280035927"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="280035927"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 15:45:30 -0700
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="596002223"
Received: from sanketpa-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.86.143])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 15:45:26 -0700
Message-ID: <dcdbadde527b4dc67efb5df64179fd1ec1bb073c.camel@intel.com>
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
Date:   Fri, 01 Jul 2022 10:45:24 +1200
In-Reply-To: <6abe32e1-51f8-a303-4ddb-2347dddcc960@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <3a1c9807d8c140bdd550cd5736664f86782cca64.1655894131.git.kai.huang@intel.com>
         <20220624014112.GA15566@gao-cwp>
         <951da5eeb4214521635602ce3564246ad49018f5.camel@intel.com>
         <a2277c2f-91a1-871f-08f1-42950bca53b3@intel.com>
         <292182cbe779aade47580ac23dc304856619c799.camel@intel.com>
         <6abe32e1-51f8-a303-4ddb-2347dddcc960@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-06-30 at 08:44 -0700, Dave Hansen wrote:
> On 6/29/22 16:02, Kai Huang wrote:
> > On Wed, 2022-06-29 at 07:22 -0700, Dave Hansen wrote:
> > > On 6/24/22 04:21, Kai Huang wrote:
> > > What does that #ifdef get us?  I suspect you're back to trying to
> > > silence compiler warnings with #ifdefs.  The compiler *knows* that it=
's
> > > only used in this file.  It's also used all of once.  If you make it
> > > 'static inline', you'll likely get the same code generation, no
> > > warnings, and don't need an #ifdef.
> >=20
> > The purpose is not to avoid warning, but to make intel_cc_platform_has(=
enum
> > cc_attr attr) simple that when neither TDX host and TDX guest code is t=
urned on,
> > it can be simple:
> >=20
> > 	static bool  intel_cc_platform_has(enum cc_attr attr)
> > 	{
> > 		return false;
> > 	}
> >=20
> > So I don't need to depend on how internal functions are implemented in =
the
> > header files and I don't need to guess how does compiler generate code.
>=20
> I hate to break it to you, but you actually need to know how the
> compiler works for you to be able to write good code.  Ignoring all the
> great stuff that the compiler does for you makes your code worse.

Agreed.

>=20
> > And also because I personally believe it doesn't hurt readability.=20
>=20
> Are you saying that you're ignoring long-established kernel coding style
> conventions because of your personal beliefs?  That seem, um, like an
> approach that's unlikely to help your code get accepted.

Agreed.  Will keep this in mind.  Thanks.

>=20
> > > The other option is to totally lean on the compiler to figure things
> > > out.  Compile this program, then disassemble it and see what main() d=
oes.
> > >=20
> > > static void func(void)
> > > {
> > > 	printf("I am func()\n");
> > > }
> > >=20
> > > void main(int argc, char **argv)
> > > {
> > > 	if (0)
> > > 		func();
> > > }
> > >=20
> > > Then, do:
> > >=20
> > > -	if (0)
> > > +	if (argc)
> > >=20
> > > and run it again.  What changed in the disassembly?
> >=20
> > You mean compile it again?  I have to confess I never tried and don't k=
now.=20
> > I'll try when I got some spare time.  Thanks for the info.
>=20
> Yes, compile it again and run it again.
>=20
> But, seriously, it's a quick exercise.  I can help make you some spare
> time if you wish.  Just let me know.

So I tried.  Took me less than 5 mins:)

The
	if (0)
		func();

never generates the code to actually call the func():

0000000000401137 <main>:=20
  401137:       55                      push   %rbp     =20
  401138:       48 89 e5                mov    %rsp,%rbp=20
  40113b:       89 7d fc                mov    %edi,-0x4(%rbp)
  40113e:       48 89 75 f0             mov    %rsi,-0x10(%rbp)
  401142:       90                      nop
  401143:       5d                      pop    %rbp   =20
  401144:       c3                      ret   =20

While
	if (argc)
		func();

generates the code to check argc and call func():

0000000000401137 <main>:=20
  401137:       55                      push   %rbp    =20
  401138:       48 89 e5                mov    %rsp,%rbp =20
  40113b:       48 83 ec 10             sub    $0x10,%rsp
  40113f:       89 7d fc                mov    %edi,-0x4(%rbp)
  401142:       48 89 75 f0             mov    %rsi,-0x10(%rbp)
  401146:       83 7d fc 00             cmpl   $0x0,-0x4(%rbp)
  40114a:       74 05                   je     401151 <main+0x1a>
  40114c:       e8 d5 ff ff ff          call   401126 <func>
  401151:       90                      nop                     =20
  401152:       c9                      leave               =20
  401153:       c3                      ret  =20

This is kinda no surprise.

Were you trying to make point that

	if (false)
		func();

doesn't generate any additional code?

I get your point now.  Thanks :)
