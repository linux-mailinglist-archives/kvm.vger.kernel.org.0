Return-Path: <kvm+bounces-30593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 77A4D9BC332
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 03:32:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CCA6FB21972
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 02:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7C9433C4;
	Tue,  5 Nov 2024 02:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qWgSGFsl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7D61CFA9
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 02:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730773930; cv=none; b=itJKzSY01swsT0ohI2je/so+0/cOToEhgBh3n2o+X57F9xdjoosyODQUH68+dWe/m6J/KnjxnHObF2JSIkiFTPcxkZXDb/Id3XakVvvK5zbTCtMZfbwMjZXCJS9McbhQgQULWfj+xw9i5m2v1LBcJRIwS0VeSVgAt6NmLdRnFnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730773930; c=relaxed/simple;
	bh=KQJtKiVaaRTt8hYZ3W3eUKCdfecVmeiYhG7gJjIOh/Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jq6Zyd7z04hl0l4C47T3ykmKgQinH+iqB9YEvZMBQUuzFpvoUYhy3Me/QVP07egxaYJketXamie11fVyC8L3JQ/XXvh46ax3viRBCs4zk2ZvOUh6wwdJo/BK/vSblmBadyGNbQSi3N9d0d8XFMsNCsmVYYXk1A2ypNcm6lh5UvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qWgSGFsl; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e292dbfd834so8429506276.3
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 18:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730773928; x=1731378728; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eUrF1PfgDeoOAbr1FXJaTxi0xlu7yzW0qufWd71y+Gw=;
        b=qWgSGFsl9BfT5RzKrigsEoNLHIJWEvSIwpo9PNhRc/ma0z1srOsP4N4VR+N0hZEaq8
         Vlgwby18Yx2zIJMj4fE+Sdtl8yHBXm+sgUzv1/dgfAxFi1Wo8F/BAIUlL/LnJL8B/I4y
         +bgKkYchD74w7zJpZToR0wFihpBxgkb5YAxZYbGBrw8HRVAxrB1SRgpxRjAsOhj9Ncbl
         CzvKtp2Ogj9xI2mZb9BQjXZ2JN6fH2bJtDf+k7SY7DlE8jFm0r9edxEUAjXQyBGaJxw/
         QdVx5kG+CFMZNDSlkeq1V3U6zES7EWfCaWChUz2DM/eDdi68OAYFC/k6yTnhQRygIeWx
         /8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730773928; x=1731378728;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eUrF1PfgDeoOAbr1FXJaTxi0xlu7yzW0qufWd71y+Gw=;
        b=k1BKX9JqEJ8kTS80xP/HUpSN1v13eSrgtX9qK9WzZBNfAqra/4TJPPfAlvV7qlWsWE
         DqAR63yNa/NkLfjIzHs7DHxRHa7BWV0YZbCAPFvlrwK675QgGflhmNFoPbWx+x83D8I3
         ljheSe7Qr6HyuLKDNEr9k9yPBxQGg5nEICuyMwrlgEm2EQbUJy9v+A39FSYV1gX6z8IF
         4pPpmCRAcodDpyjLGppkXpA4b0O9lkCpXpWs22TNqt7nSxQ9qNlZWuEmdT2vboyvo73c
         /N25Df+0iCPf2XiB6/06xi5lXn+7g2pUd7wbmHWwRf3gfnbWbFqkAVyBtQvE4s+kWffC
         JXAQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0wSBiQevhRAkldN5LdUfjZ2SAF8j1JF1MdjEXEuO5P8WZqATaIfdYqvOGvtyo5Nu5UHM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwySGEP+2x62527J+Ch0otL1BFyvhTRbgVPztCOQQKQpNIvWwB5
	jAjtXpHeypzFx7j6hxVcjZHNAW3MDmOTlPtiX7YHvL9vRW3QgYNEsznQBuXoXkEOxjpYOjZiKoP
	T0A==
X-Google-Smtp-Source: AGHT+IGIl3yfwt8B3h+iAEiK+V9QL9PJ61czwqQvMJKcMs79Mlr091aI8roUJg9n8mEHrZRH9Vmhgn7SPAs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:df8e:0:b0:e30:d896:dde3 with SMTP id
 3f1490d57ef6-e33026cf50fmr18747276.11.1730773927808; Mon, 04 Nov 2024
 18:32:07 -0800 (PST)
Date: Mon, 4 Nov 2024 18:32:06 -0800
In-Reply-To: <95c92ff265cfa48f5459009d48a161e5cbe7ab3d.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-2-binbin.wu@linux.intel.com> <ZyKbxTWBZUdqRvca@google.com>
 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
 <ZyLWMGcgj76YizSw@google.com> <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
 <ZyUEMLoy6U3L4E8v@google.com> <f95cd8c6-af5c-4d8f-99a8-16d0ec56d9a4@linux.intel.com>
 <95c92ff265cfa48f5459009d48a161e5cbe7ab3d.camel@intel.com>
Message-ID: <ZymDgtd3VquVwsn_@google.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace generically
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	"yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 04, 2024, Kai Huang wrote:
> On Mon, 2024-11-04 at 16:49 +0800, Binbin Wu wrote:
> > On 11/2/2024 12:39 AM, Sean Christopherson wrote:
> > > On Fri, Nov 01, 2024, Kai Huang wrote:
> > > > On Thu, 2024-10-31 at 07:54 -0700, Sean Christopherson wrote:

...

> > > Lightly tested.  Assuming this works for TDX and passes testing, I'll=
 post a
> > > mini-series next week.
> > >=20
> > > --
> > > From: Sean Christopherson <seanjc@google.com>
> > > Date: Fri, 1 Nov 2024 09:04:00 -0700
> > > Subject: [PATCH] KVM: x86: Refactor __kvm_emulate_hypercall() to acce=
pt reg
> > >   names, not values
> > >=20
> > > Rework __kvm_emulate_hypercall() to take the names of input and outpu=
t
> > > (guest return value) registers, as opposed to taking the input values=
 and
> > > returning the output value.  As part of the refactor, change the actu=
al
> > > return value from __kvm_emulate_hypercall() to be KVM's de facto stan=
dard
> > > of '0' =3D=3D exit to userspace, '1' =3D=3D resume guest, and -errno =
=3D=3D failure.
> > >=20
> > > Using the return value for KVM's control flow eliminates the multiple=
xed
> > > return value, where '0' for KVM_HC_MAP_GPA_RANGE (and only that hyper=
call)
> > > means "exit to userspace".
> > >=20
> > > Use the direct GPR accessors to read values to avoid the pointless ma=
rking
> > > of the registers as available, but use kvm_register_write_raw() for t=
he
> > > guest return value so that the innermost helper doesn't need to multi=
plex
> > > its return value.  Using the generic kvm_register_write_raw() adds ve=
ry
> > > minimal overhead, so as a one-off in a relatively slow path it's well
> > > worth the code simplification.
> > >=20
> > > Suggested-by: Kai Huang <kai.huang@intel.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---

...

> > > -	ret =3D __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit=
, cpl);
> > > -	if (nr =3D=3D KVM_HC_MAP_GPA_RANGE && !ret)
> > > -		/* MAP_GPA tosses the request to the user space. */
> > > +	r =3D __kvm_emulate_hypercall(vcpu, rax, rbx, rcx, rdx, rsi,
> > > +				    is_64_bit_hypercall(vcpu),
> > > +				    kvm_x86_call(get_cpl)(vcpu), RAX);
> > Now, the register for return code of the hypercall can be specified.
> > But in=C2=A0 ____kvm_emulate_hypercall(), the complete_userspace_io cal=
lback
> > is hardcoded to complete_hypercall_exit(), which always set return code
> > to RAX.
> >=20
> > We can allow the caller to pass in the cui callback, or assign differen=
t
> > version according to the input 'ret_reg'.=C2=A0 So that different calle=
rs can use
> > different cui callbacks.=C2=A0 E.g., TDX needs to set return code to R1=
0 in cui
> > callback.
> >=20
> > How about:
> >=20
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index dba78f22ab27..0fba98685f42 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2226,13 +2226,15 @@ static inline void kvm_clear_apicv_inhibit(stru=
ct kvm *kvm,
> >  =C2=A0int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned lo=
ng nr,
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long a0, unsigned long a1,
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long a2, unsigned long a3,
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 int op_64_bit, int cpl, int ret_reg);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 int op_64_bit, int cpl, int ret_reg,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 int (*cui)(struct kvm_vcpu *vcpu));
> >=20
>=20
> Does below (incremental diff based on Sean's) work?
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 734dac079453..5131af97968d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10075,7 +10075,6 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vc=
pu,
> unsigned long nr,
>                         vcpu->run->hypercall.flags |=3D
> KVM_EXIT_HYPERCALL_LONG_MODE;
> =20
>                 WARN_ON_ONCE(vcpu->run->hypercall.flags &
> KVM_EXIT_HYPERCALL_MBZ);
> -               vcpu->arch.complete_userspace_io =3D complete_hypercall_e=
xit;
>                 /* stat is incremented on completion. */
>                 return 0;
>         }
> @@ -10108,8 +10107,11 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>         r =3D __kvm_emulate_hypercall(vcpu, rax, rbx, rcx, rdx, rsi,
>                                     is_64_bit_hypercall(vcpu),
>                                     kvm_x86_call(get_cpl)(vcpu), RAX);
> -       if (r <=3D 0)
> +       if (r <=3D 0) {
> +               if (!r)
> +                       vcpu->arch.complete_userspace_io =3D
> complete_hypercall_exit;
>                 return 0;
> +       }

I think I prefer Binbin's version, as it forces the caller to provide cui()=
, i.e.
makes it harder KVM to fail to handle the backend of the hypercall.

Side topic, unless I'm missing something, all of the instruction VM-Exits t=
hat are
piped through #VMGEXIT to svm_invoke_exit_handler() will make a bogus call =
to
kvm_skip_emulated_instruction().  It "works", but only because nothing ever=
 looks
at the modified data.

At first, I thought it was just VMMCALL, and so was wondering if maybe we c=
ould
fix that wart too.  But it's *every* instruction, so it's probably out of s=
cope.

The one thing I don't love about providing a separate cui() is that it mean=
s
duplicating the guts of the completion helper.  Ha!  But we can avoid that =
by
adding another macro (untested).

More macros/helpers is a bit ugly too, but I like the symmetry, and it will
definitely be easier to maintain.  E.g. if the completion phase needs to pi=
vot
on the exact hypercall, then we can update common code and don't need to re=
member
to go update TDX too.

If no one objects and/or has a better idea, I'll splice together Binbin's p=
atch
with this blob, and post a series tomorrow.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 8e8ca6dab2b2..0b0fa9174000 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2179,6 +2179,16 @@ static inline void kvm_clear_apicv_inhibit(struct kv=
m *kvm,
        kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
 }
=20
+#define kvm_complete_hypercall_exit(vcpu, ret_reg)                        =
     \
+do {                                                                      =
     \
+       u64 ret =3D (vcpu)->run->hypercall.ret;                            =
       \
+                                                                          =
     \
+       if (!is_64_bit_mode(vcpu))                                         =
     \
+               ret =3D (u32)ret;                                          =
       \
+       kvm_##ret_reg##_write(vcpu, ret);                                  =
     \
+       ++(vcpu)->stat.hypercalls;                                         =
     \
+} while (0)
+
 int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
                              unsigned long a0, unsigned long a1,
                              unsigned long a2, unsigned long a3,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 425a301911a6..aec79e132d3b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9989,12 +9989,8 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, u=
nsigned long dest_id)
=20
 static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 {
-       u64 ret =3D vcpu->run->hypercall.ret;
+       kvm_complete_hypercall_exit(vcpu, rax);
=20
-       if (!is_64_bit_mode(vcpu))
-               ret =3D (u32)ret;
-       kvm_rax_write(vcpu, ret);
-       ++vcpu->stat.hypercalls;
        return kvm_skip_emulated_instruction(vcpu);
 }
=20


