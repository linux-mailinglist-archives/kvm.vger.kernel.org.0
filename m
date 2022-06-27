Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BB155CF81
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242645AbiF0WeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 18:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238985AbiF0WeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 18:34:19 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D111C933;
        Mon, 27 Jun 2022 15:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656369258; x=1687905258;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=oXD56QjJjpsr+G+HjDxUGpxMO6J556nK1Vnhy+SAfIQ=;
  b=HnbWicSL74+Gb+/WRqp1aZOy7ArPrAdfNAESmp67KT0KvkU86lXflkqG
   cB4JqMkFQPrrTIyLaHcES0WnPTu2qLQy9DDGKYo4gqakIuEmsltZ23Qpz
   WmFnoJ0mKfKH+Tzod/iQB/QW3meRpTBZuVbp4+8650sCk/q6dCr/GPq0L
   I955qLspl/DKZl5wH0LP9YRH0XLM3OeUY3aXgcfo/ReFOpsIzrshIEmVv
   si0QSIlsIRpSE4a7a5tKUl1Rf0EUg7ZCsWsd53uRobMmHIzvpigGZ6eWj
   mW54wVZ/LJkNOFrlsHXaRZeDZ9kOOzc3HDaEHb8e4G1EMaTIAqPUMibjZ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="343266379"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="343266379"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 15:34:16 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="916915824"
Received: from iiturbeo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.89.183])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 15:34:13 -0700
Message-ID: <2b94afd608303f104376e6a775b211714e34bc7e.camel@intel.com>
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
Date:   Tue, 28 Jun 2022 10:34:11 +1200
In-Reply-To: <77c90075-79d4-7cc7-f266-1b67e586513b@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <89fffc70cdbb74c80bb324364b712ec41e5f8b91.1655894131.git.kai.huang@intel.com>
         <765a20f1-681d-33c2-68e9-24cc249fe6f9@intel.com>
         <cc90e5f8be0c6f48a144240d4569b15bd4b75dd8.camel@intel.com>
         <77c90075-79d4-7cc7-f266-1b67e586513b@intel.com>
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

On Mon, 2022-06-27 at 13:46 -0700, Dave Hansen wrote:
> On 6/26/22 22:26, Kai Huang wrote:
> > On Fri, 2022-06-24 at 11:50 -0700, Dave Hansen wrote:
> > > So, the last patch was called:
> > >=20
> > > 	Implement SEAMCALL function
> > >=20
> > > and yet, in this patch, we have a "seamcall()" function.  That's a bi=
t
> > > confusing and not covered at *all* in this subject.
> > >=20
> > > Further, seamcall() is the *ONLY* caller of __seamcall() that I see i=
n
> > > this series.  That makes its presence here even more odd.
> > >=20
> > > The seamcall() bits should either be in their own patch, or mashed in
> > > with __seamcall().
> >=20
> > Right.  The reason I didn't put the seamcall() into previous patch was =
it is
> > only used in this tdx.c, so it should be static.  But adding a static f=
unction
> > w/o using it in previous patch will trigger a compile warning.  So I in=
troduced
> > here where it is first used.
> >=20
> > One option is I can introduce seamcall() as a static inline function in=
 tdx.h in
> > previous patch so there won't be a warning.  I'll change to use this wa=
y.=20
> > Please let me know if you have any comments.
>=20
> Does a temporary __unused get rid of the warning?

Yes, and both __maybe_unused and __always_unused also git rid of the warnin=
g
too.

__unused is not defined in compiler_attributes.h, so we need to use
__attribute__((__unused__)) explicitly, or have __unused defined to it as a
macro.

I think I can just use __always_unused for this purpose?

So I think we put seamcall() implementation to the patch which implements
__seamcall().  And we can inline for seamcall() and put it in either tdx.h =
or
tdx.c, or we can use __always_unused  (or the one you prefer) to get rid of=
 the
warning.

What's your opinion?
>=20
> > > >  /*
> > > >   * Detect and initialize the TDX module.
> > > >   *
> > > > @@ -138,7 +195,10 @@ static int init_tdx_module(void)
> > > > =20
> > > >  static void shutdown_tdx_module(void)
> > > >  {
> > > > -	/* TODO: Shut down the TDX module */
> > > > +	struct seamcall_ctx sc =3D { .fn =3D TDH_SYS_LP_SHUTDOWN };
> > > > +
> > > > +	seamcall_on_each_cpu(&sc);
> > > > +
> > > >  	tdx_module_status =3D TDX_MODULE_SHUTDOWN;
> > > >  }
> > > > =20
> > > > @@ -221,6 +281,9 @@ bool platform_tdx_enabled(void)
> > > >   * CPU hotplug is temporarily disabled internally to prevent any c=
pu
> > > >   * from going offline.
> > > >   *
> > > > + * Caller also needs to guarantee all CPUs are in VMX operation du=
ring
> > > > + * this function, otherwise Oops may be triggered.
> > >=20
> > > I would *MUCH* rather have this be a:
> > >=20
> > > 	if (!cpu_feature_enabled(X86_FEATURE_VMX))
> > > 		WARN_ONCE("VMX should be on blah blah\n");
> > >=20
> > > than just plain oops.  Even a pr_err() that preceded the oops would b=
e
> > > nicer than an oops that someone has to go decode and then grumble whe=
n
> > > their binutils is too old that it can't disassemble the TDCALL.
> >=20
> > I can add this to seamcall():
> >=20
> > 	/*
> > 	 * SEAMCALL requires CPU being in VMX operation otherwise it causes
> > #UD.
> > 	 * Sanity check and return early to avoid Oops.  Note cpu_vmx_enabled(=
)
> > 	 * actually only checks whether VMX is enabled but doesn't check
> > whether
> > 	 * CPU is in VMX operation (VMXON is done).  There's no way to check
> > 	 * whether VMXON has been done, but currently enabling VMX and doing
> > 	 * VMXON are always done together.
> > 	 */
> > 	if (!cpu_vmx_enabled())	 {
> > 		WARN_ONCE("CPU is not in VMX operation before making
> > SEAMCALL");
> > 		return -EINVAL;
> > 	}
> >=20
> > The reason I didn't do is I'd like to make seamcall() simple, that it o=
nly
> > returns TDX_SEAMCALL_VMFAILINVALID or the actual SEAMCALL leaf error.  =
With
> > above, this function also returns kernel error code, which isn't good.
>=20
> I think you're missing the point.  You wasted two lines of code on a
> *COMMENT* that doesn't actually help anyone decode an oops.  You could
> have, instead, spent two lines on actual code that would have been just
> as good or better than a comment *AND* help folks looking at an oops.
>=20
> It's almost always better to do something actionable in code than to
> comment it, unless it's in some crazy fast path.

Agreed.  Thanks.

>=20
> > Alternatively, we can always add EXTABLE to TDX_MODULE_CALL macro to ha=
ndle #UD
> > and #GP by returning dedicated error codes (please also see my reply to=
 previous
> > patch for the code needed to handle), in which case we don't need such =
check
> > here.
> >=20
> > Always handling #UD in TDX_MODULE_CALL macro also has another advantage=
:  there
> > will be no Oops for #UD regardless the issue that "there's no way to ch=
eck
> > whether VMXON has been done" in the above comment.
> >=20
> > What's your opinion?
>=20
> I think you should explore using the EXTABLE.  Let's see how it looks.

I tried to wrote the code before.  I didn't test but it should look like to
something below.  Any comments?

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 4b75c930fa1b..4a97ca8eb14c 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -8,6 +8,7 @@
 #include <asm/ptrace.h>
 #include <asm/shared/tdx.h>

+#ifdef CONFIG_INTEL_TDX_HOST
 /*
  * SW-defined error codes.
  *
@@ -18,6 +19,21 @@
 #define TDX_SW_ERROR                   (TDX_ERROR | GENMASK_ULL(47, 40))
 #define TDX_SEAMCALL_VMFAILINVALID     (TDX_SW_ERROR | _UL(0xFFFF0000))

+/*
+ * Special error codes to indicate SEAMCALL #GP and #UD.
+ *
+ * SEAMCALL causes #GP when SEAMRR is not properly enabled by BIOS, and
+ * causes #UD when CPU is not in VMX operation.  Define two separate
+ * error codes to distinguish the two cases so caller can be aware of
+ * what caused the SEAMCALL to fail.
+ *
+ * Bits 61:48 are reserved bits which will never be set by the TDX
+ * module.  Borrow 2 reserved bits to represent #GP and #UD.
+ */
+#define TDX_SEAMCALL_GP                (TDX_ERROR | GENMASK_ULL(48, 48))
+#define TDX_SEAMCALL_UD                (TDX_ERROR | GENMASK_ULL(49, 49))
+#endif
+
 #ifndef __ASSEMBLY__

 /*
diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcal=
l.S
index 49a54356ae99..7431c47258d9 100644
--- a/arch/x86/virt/vmx/tdx/tdxcall.S
+++ b/arch/x86/virt/vmx/tdx/tdxcall.S
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <asm/asm-offsets.h>
 #include <asm/tdx.h>
+#include <asm/asm.h>

 /*
  * TDCALL and SEAMCALL are supported in Binutils >=3D 2.36.
@@ -45,6 +46,7 @@
        /* Leave input param 2 in RDX */

        .if \host
+1:
        seamcall
        /*
         * SEAMCALL instruction is essentially a VMExit from VMX root
@@ -57,9 +59,25 @@
         * This value will never be used as actual SEAMCALL error code as
         * it is from the Reserved status code class.
         */
-       jnc .Lno_vmfailinvalid
+       jnc .Lseamcall_out
        mov $TDX_SEAMCALL_VMFAILINVALID, %rax
-.Lno_vmfailinvalid:
+       jmp .Lseamcall_out
+2:
+       /*
+        * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
+        * the trap number.  Check the trap number and set up the return
+        * value to %rax.
+        */
+       cmp $X86_TRAP_GP, %eax
+       je .Lseamcall_gp
+       mov $TDX_SEAMCALL_UD, %rax
+       jmp .Lseamcall_out
+.Lseamcall_gp:
+       mov $TDX_SEAMCALL_GP, %rax
+       jmp .Lseamcall_out
+
+       _ASM_EXTABLE_FAULT(1b, 2b)
+.Lseamcall_out





