Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BC355D058
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242382AbiF0X7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 19:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiF0X7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 19:59:39 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43FD10FE4;
        Mon, 27 Jun 2022 16:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656374374; x=1687910374;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=uWA5FILtKykV3W795a+PPaDHxmv1MhnOh5nR9EErLao=;
  b=GR4+5Rd5KE9UqBfcTtWROJUauQ5twDS/YGgTMrJ8tVE29s7s/ey5RWvh
   OpNf+Xq1FemrYCPJBQh8oAKgyyqMX3lMW7cR/RZmb3O6QhWL9RfUmYbas
   CEyViroGCGvw/4nPBx3MlkYLmwMJbIQv1bjAcBd+8Lo9IU+H/SksuE+KX
   0Ixv7CnAuxTfiCkpv0iZa8GiYh/iUzTjv/tm7M/9RwzPLpfmsnJNh4Cib
   F5W2veeaySSTrPI5rGRrU0TSyy7lCZ70Kiaa3FC//EJKxU681vWiF9Wmf
   6GyKtKrUiOcQizHvBRrOOU1KiPlXfpUov956dFaWDZN21B+MgQJKbQv9r
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="367903473"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="367903473"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 16:59:34 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="590100661"
Received: from iiturbeo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.89.183])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 16:59:30 -0700
Message-ID: <a3831d3fc926905585f9fb1e14e13e502c1f5b65.camel@intel.com>
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
Date:   Tue, 28 Jun 2022 11:59:28 +1200
In-Reply-To: <6ed2746d-f44c-4511-7373-5706dd7c3f0f@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <89fffc70cdbb74c80bb324364b712ec41e5f8b91.1655894131.git.kai.huang@intel.com>
         <765a20f1-681d-33c2-68e9-24cc249fe6f9@intel.com>
         <cc90e5f8be0c6f48a144240d4569b15bd4b75dd8.camel@intel.com>
         <77c90075-79d4-7cc7-f266-1b67e586513b@intel.com>
         <2b94afd608303f104376e6a775b211714e34bc7e.camel@intel.com>
         <6ed2746d-f44c-4511-7373-5706dd7c3f0f@intel.com>
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

On Mon, 2022-06-27 at 15:56 -0700, Dave Hansen wrote:
> On 6/27/22 15:34, Kai Huang wrote:
> > On Mon, 2022-06-27 at 13:46 -0700, Dave Hansen wrote:
> > I think I can just use __always_unused for this purpose?
> >=20
> > So I think we put seamcall() implementation to the patch which implemen=
ts
> > __seamcall().  And we can inline for seamcall() and put it in either td=
x.h or
> > tdx.c, or we can use __always_unused  (or the one you prefer) to get ri=
d of the
> > warning.
> >=20
> > What's your opinion?
>=20
> A temporary __always_unused seems fine to me.

Thanks will do.

>=20
> > > > Alternatively, we can always add EXTABLE to TDX_MODULE_CALL macro t=
o handle #UD
> > > > and #GP by returning dedicated error codes (please also see my repl=
y to previous
> > > > patch for the code needed to handle), in which case we don't need s=
uch check
> > > > here.
> > > >=20
> > > > Always handling #UD in TDX_MODULE_CALL macro also has another advan=
tage:  there
> > > > will be no Oops for #UD regardless the issue that "there's no way t=
o check
> > > > whether VMXON has been done" in the above comment.
> > > >=20
> > > > What's your opinion?
> > >=20
> > > I think you should explore using the EXTABLE.  Let's see how it looks=
.
> >=20
> > I tried to wrote the code before.  I didn't test but it should look lik=
e to
> > something below.  Any comments?
> >=20
> > diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> > index 4b75c930fa1b..4a97ca8eb14c 100644
> > --- a/arch/x86/include/asm/tdx.h
> > +++ b/arch/x86/include/asm/tdx.h
> > @@ -8,6 +8,7 @@
> >  #include <asm/ptrace.h>
> >  #include <asm/shared/tdx.h>
> >=20
> > +#ifdef CONFIG_INTEL_TDX_HOST
> >  /*
> >   * SW-defined error codes.
> >   *
> > @@ -18,6 +19,21 @@
> >  #define TDX_SW_ERROR                   (TDX_ERROR | GENMASK_ULL(47, 40=
))
> >  #define TDX_SEAMCALL_VMFAILINVALID     (TDX_SW_ERROR | _UL(0xFFFF0000)=
)
> >=20
> > +/*
> > + * Special error codes to indicate SEAMCALL #GP and #UD.
> > + *
> > + * SEAMCALL causes #GP when SEAMRR is not properly enabled by BIOS, an=
d
> > + * causes #UD when CPU is not in VMX operation.  Define two separate
> > + * error codes to distinguish the two cases so caller can be aware of
> > + * what caused the SEAMCALL to fail.
> > + *
> > + * Bits 61:48 are reserved bits which will never be set by the TDX
> > + * module.  Borrow 2 reserved bits to represent #GP and #UD.
> > + */
> > +#define TDX_SEAMCALL_GP                (TDX_ERROR | GENMASK_ULL(48, 48=
))
> > +#define TDX_SEAMCALL_UD                (TDX_ERROR | GENMASK_ULL(49, 49=
))
> > +#endif
> > +
> >  #ifndef __ASSEMBLY__
> >=20
> >  /*
> > diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/td=
xcall.S
> > index 49a54356ae99..7431c47258d9 100644
> > --- a/arch/x86/virt/vmx/tdx/tdxcall.S
> > +++ b/arch/x86/virt/vmx/tdx/tdxcall.S
> > @@ -1,6 +1,7 @@
> >  /* SPDX-License-Identifier: GPL-2.0 */
> >  #include <asm/asm-offsets.h>
> >  #include <asm/tdx.h>
> > +#include <asm/asm.h>
> >=20
> >  /*
> >   * TDCALL and SEAMCALL are supported in Binutils >=3D 2.36.
> > @@ -45,6 +46,7 @@
> >         /* Leave input param 2 in RDX */
> >=20
> >         .if \host
> > +1:
> >         seamcall
> >         /*
> >          * SEAMCALL instruction is essentially a VMExit from VMX root
> > @@ -57,9 +59,25 @@
> >          * This value will never be used as actual SEAMCALL error code =
as
> >          * it is from the Reserved status code class.
> >          */
> > -       jnc .Lno_vmfailinvalid
> > +       jnc .Lseamcall_out
> >         mov $TDX_SEAMCALL_VMFAILINVALID, %rax
> > -.Lno_vmfailinvalid:
> > +       jmp .Lseamcall_out
> > +2:
> > +       /*
> > +        * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
> > +        * the trap number.  Check the trap number and set up the retur=
n
> > +        * value to %rax.
> > +        */
> > +       cmp $X86_TRAP_GP, %eax
> > +       je .Lseamcall_gp
> > +       mov $TDX_SEAMCALL_UD, %rax
> > +       jmp .Lseamcall_out
> > +.Lseamcall_gp:
> > +       mov $TDX_SEAMCALL_GP, %rax
> > +       jmp .Lseamcall_out
> > +
> > +       _ASM_EXTABLE_FAULT(1b, 2b)
> > +.Lseamcall_out
>=20
> Not too bad, although the end of that is a bit ugly.  It would be nicer
> if you could just return the %rax value in the exception section instead
> of having to do the transform there.  Maybe have a TDX_ERROR code with
> enough bits to hold any X86_TRAP_FOO.

We already have declared bits 47:40 =3D=3D 0xFF is never used by TDX module=
:

/*
 * SW-defined error codes.
 *
 * Bits 47:40 =3D=3D 0xFF indicate Reserved status code class that never us=
ed by
 * TDX module.
 */
#define TDX_ERROR                       _BITUL(63)
#define TDX_SW_ERROR                    (TDX_ERROR | GENMASK_ULL(47, 40))
#define TDX_SEAMCALL_VMFAILINVALID      (TDX_SW_ERROR | _UL(0xFFFF0000))

So how about just putting the X86_TRAP_FOO to the last 32-bits?  We only ha=
ve 32
traps, so 32-bits is more than enough.

#define TDX_SEAMCALL_GP		(TDX_SW_ERROR | X86_TRAP_GP)
#define TDX_SEAMCALL_UD		(TDX_SW_ERROR | X86_TRAP_UD)

If so,  in the assembly, I think we can just XOR TDX_SW_ERROR to the %rax a=
nd
return %rax:

2:
        /*
	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
	 * the trap number.  Convert trap number to TDX error code by setting
	 * TDX_SW_ERROR to the high 32-bits of %rax.
	 */
	xorq	$TDX_SW_ERROR, %rax

How does this look?



--=20
Thanks,
-Kai


