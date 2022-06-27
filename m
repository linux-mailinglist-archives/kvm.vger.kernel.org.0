Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1607755B7BD
	for <lists+kvm@lfdr.de>; Mon, 27 Jun 2022 07:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiF0F0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 01:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiF0F0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 01:26:32 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE3F5FAB;
        Sun, 26 Jun 2022 22:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656307591; x=1687843591;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=iPSJPsF1tv3EGhocYM1AiKOjoEEAMTmjLe2J0E/veUM=;
  b=jWmMkZVoktC6cQX6lS1euceRa76XMrE/S1xRSMWJY7DwCg1JfZcOthIR
   JICPEcasdfm/4MtrBnwcYoK7l0VlqeR/65Kt7jgTlkRniAU+l/3eAe1Wu
   rzUQPGkDxyZ0y0Hv+tpNljyugqHoWpkthvzFpj5XspMaoRIJt19KtweoF
   fPv1pwNkRFOmYwGZD6V5VWy45k1V/0IaSl/rDXCyKxCmbja7sNkBui0uc
   bSDUzklK/ObIPTGx/AU3IRBf2mb895DpEiWT7UqfwUPwb/1WGAeEfJvcE
   0tGggr54LH5Tvgi1LYQ5ldqfR96C22DfFK3gnv2cMz8KTBjdnpplwJsjj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="264404720"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="264404720"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 22:26:30 -0700
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="539986175"
Received: from fzaeni-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.88.6])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 22:26:26 -0700
Message-ID: <cc90e5f8be0c6f48a144240d4569b15bd4b75dd8.camel@intel.com>
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
Date:   Mon, 27 Jun 2022 17:26:24 +1200
In-Reply-To: <765a20f1-681d-33c2-68e9-24cc249fe6f9@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <89fffc70cdbb74c80bb324364b712ec41e5f8b91.1655894131.git.kai.huang@intel.com>
         <765a20f1-681d-33c2-68e9-24cc249fe6f9@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-24 at 11:50 -0700, Dave Hansen wrote:
> So, the last patch was called:
>=20
> 	Implement SEAMCALL function
>=20
> and yet, in this patch, we have a "seamcall()" function.  That's a bit
> confusing and not covered at *all* in this subject.
>=20
> Further, seamcall() is the *ONLY* caller of __seamcall() that I see in
> this series.  That makes its presence here even more odd.
>=20
> The seamcall() bits should either be in their own patch, or mashed in
> with __seamcall().

Right.  The reason I didn't put the seamcall() into previous patch was it i=
s
only used in this tdx.c, so it should be static.  But adding a static funct=
ion
w/o using it in previous patch will trigger a compile warning.  So I introd=
uced
here where it is first used.

One option is I can introduce seamcall() as a static inline function in tdx=
.h in
previous patch so there won't be a warning.  I'll change to use this way.=
=20
Please let me know if you have any comments.

>=20
> > +/*
> > + * Wrapper of __seamcall().  It additionally prints out the error
> > + * informationi if __seamcall() fails normally.  It is useful during
> > + * the module initialization by providing more information to the user=
.
> > + */
> > +static u64 seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> > +		    struct tdx_module_output *out)
> > +{
> > +	u64 ret;
> > +
> > +	ret =3D __seamcall(fn, rcx, rdx, r8, r9, out);
> > +	if (ret =3D=3D TDX_SEAMCALL_VMFAILINVALID || !ret)
> > +		return ret;
> > +
> > +	pr_err("SEAMCALL failed: leaf: 0x%llx, error: 0x%llx\n", fn, ret);
> > +	if (out)
> > +		pr_err("SEAMCALL additional output: rcx 0x%llx, rdx 0x%llx, r8 0x%ll=
x, r9 0x%llx, r10 0x%llx, r11 0x%llx.\n",
> > +			out->rcx, out->rdx, out->r8, out->r9, out->r10, out->r11);
> > +
> > +	return ret;
> > +}
> > +
> > +static void seamcall_smp_call_function(void *data)
> > +{
> > +	struct seamcall_ctx *sc =3D data;
> > +	struct tdx_module_output out;
> > +	u64 ret;
> > +
> > +	ret =3D seamcall(sc->fn, sc->rcx, sc->rdx, sc->r8, sc->r9, &out);
> > +	if (ret)
> > +		atomic_set(&sc->err, -EFAULT);
> > +}
> > +
> > +/*
> > + * Call the SEAMCALL on all online CPUs concurrently.  Caller to check
> > + * @sc->err to determine whether any SEAMCALL failed on any cpu.
> > + */
> > +static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
> > +{
> > +	on_each_cpu(seamcall_smp_call_function, sc, true);
> > +}
>=20
> You can get away with this three-liner seamcall_on_each_cpu() being in
> this patch, but seamcall() itself doesn't belong here.

Right.  Please see above reply.

>=20
> >  /*
> >   * Detect and initialize the TDX module.
> >   *
> > @@ -138,7 +195,10 @@ static int init_tdx_module(void)
> > =20
> >  static void shutdown_tdx_module(void)
> >  {
> > -	/* TODO: Shut down the TDX module */
> > +	struct seamcall_ctx sc =3D { .fn =3D TDH_SYS_LP_SHUTDOWN };
> > +
> > +	seamcall_on_each_cpu(&sc);
> > +
> >  	tdx_module_status =3D TDX_MODULE_SHUTDOWN;
> >  }
> > =20
> > @@ -221,6 +281,9 @@ bool platform_tdx_enabled(void)
> >   * CPU hotplug is temporarily disabled internally to prevent any cpu
> >   * from going offline.
> >   *
> > + * Caller also needs to guarantee all CPUs are in VMX operation during
> > + * this function, otherwise Oops may be triggered.
>=20
> I would *MUCH* rather have this be a:
>=20
> 	if (!cpu_feature_enabled(X86_FEATURE_VMX))
> 		WARN_ONCE("VMX should be on blah blah\n");
>=20
> than just plain oops.  Even a pr_err() that preceded the oops would be
> nicer than an oops that someone has to go decode and then grumble when
> their binutils is too old that it can't disassemble the TDCALL.

I can add this to seamcall():

	/*
	 * SEAMCALL requires CPU being in VMX operation otherwise it causes
#UD.
	 * Sanity check and return early to avoid Oops.  Note cpu_vmx_enabled()
	 * actually only checks whether VMX is enabled but doesn't check
whether
	 * CPU is in VMX operation (VMXON is done).  There's no way to check
	 * whether VMXON has been done, but currently enabling VMX and doing
	 * VMXON are always done together.
	 */
	if (!cpu_vmx_enabled())	 {
		WARN_ONCE("CPU is not in VMX operation before making
SEAMCALL");
		return -EINVAL;
	}

The reason I didn't do is I'd like to make seamcall() simple, that it only
returns TDX_SEAMCALL_VMFAILINVALID or the actual SEAMCALL leaf error.  With
above, this function also returns kernel error code, which isn't good.

Alternatively, we can always add EXTABLE to TDX_MODULE_CALL macro to handle=
 #UD
and #GP by returning dedicated error codes (please also see my reply to pre=
vious
patch for the code needed to handle), in which case we don't need such chec=
k
here.

Always handling #UD in TDX_MODULE_CALL macro also has another advantage:  t=
here
will be no Oops for #UD regardless the issue that "there's no way to check
whether VMXON has been done" in the above comment.

What's your opinion?


--=20
Thanks,
-Kai


