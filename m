Return-Path: <kvm+bounces-70813-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qJZZCPbDi2mEagAAu9opvQ
	(envelope-from <kvm+bounces-70813-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:49:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AE69D1202D8
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:49:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A995530488AB
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 23:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1791833B6D0;
	Tue, 10 Feb 2026 23:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mXpO4ooS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54F43191C8
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 23:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770767340; cv=none; b=GR0dWsbmoVlc0iHsHYwxz1nITF9qhnL4OnK9VeOaGvN9T5/ADvAYJxoZGAXK7JNGl9iartwrBWwWKkA3/CxuBrvXd3oEQqxF9LglAkLmAjRlkjFjJNUGOLDyAhhGzE6AHPrSz+NwPXMTk96UdH6cGNUklNQt++jvz3vPUzbmvKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770767340; c=relaxed/simple;
	bh=m0wcRMgirYHHkIRrgdZXJEzICOnjjQQcHMFC5O5O7qM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CoM/36pc1ibwty9Td9lltOm8pYp8P8bmxoiQNQgefxjcS9zbtWmku45i11Rc+5tpY/zdxNR5KFW8sZ+zf85H2b9lRXSRIuOT0d15Vy+ZHICN8xoLt83/Dxw1Ad2mJPSVvB9L5gKu/WAvZ7KLvu5OWl7eoJaS5cww+tp5xE7weA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mXpO4ooS; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aaeafeadbcso32156435ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 15:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770767338; x=1771372138; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XlUmuX7/vbR7IsOkiKB9wOHjIuyQgf3rCm+NKZU32+U=;
        b=mXpO4ooSb5olm031BSpgwhcuIorTBGm5J22DJ7qPbAZqtN54utqg4q5FvsYAu9p1wN
         86a68mawyhpTQFivAjE7w+I7YWsN9BvfFmz6vRz1gz4hufp9eowsJKYDuojLbKoZYi3a
         AgmMJyIN0/1lpLNqL3AT9sZobIqQBI/85bM0kOVUSpCnJxMOKvS6/S3DDuqpUcXNjSI2
         dd1RDCW8tnt44B/oTxc7HLuu8n3pwlKdm2xeeak2Hy6CitwzUWaAAacsr1FD4GvzIrpG
         Nolu48+p1sy7NrEWJwpTn3/iH50yZZkcUVan1VLzvgezswKlujqQ8qRGRaBusANRS70v
         JDLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770767338; x=1771372138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XlUmuX7/vbR7IsOkiKB9wOHjIuyQgf3rCm+NKZU32+U=;
        b=xA3ohb2avpunvN0DkkVtWtrQNTVtszs0zEVBfwW3JWvF2vNelKu7xk8O5l6gYvDS9n
         BTh8/9fTqnfrSWhx8ZbuPF3DCYFJvWSyEZ+asyBzwnAelrawWFxfr48zQ9OG/Anqduvr
         Jfe9Y658gcTVgWVPoLcF6HYGLR5gdqdJP81p3R9Rqxy0nHtFWudiKWGOmhEfTsLut1YR
         pDku4ZeRDC3lqKKABXfrlekbkvZLHCWvJumH8Dsl7wMvvyDuTurWBnqkd0cDeweZQjyv
         pEhVUkysUy03fatAHC0Okaew1rIZrPnXDrzsYOlL38zN4WrC40+bOZ6XT/1LvbtKpcHF
         +yiw==
X-Forwarded-Encrypted: i=1; AJvYcCUc2AiyqK54ITRlX1BabDPyLTqH43BZDB9gehadXGYE8eBIiYIUnjRyxvaSeD2M2otBizc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIGaztmJ/nPOtF8CCs605a5cZPyHXcBCdfWj4ibKtl3JNezslO
	P8ZsyFAuLow+86us6n48jtDiZhtt7Ffj0ILW4isV7CyvgQEMar7u9fEGC398/nYQaCIPlMQMZBh
	uuHvUQA==
X-Received: from plmj1.prod.google.com ([2002:a17:903:2fc1:b0:2a9:8200:498b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:98d:b0:29f:2b8a:d3d
 with SMTP id d9443c01a7336-2ab102f3d5cmr37645685ad.4.1770767338179; Tue, 10
 Feb 2026 15:48:58 -0800 (PST)
Date: Tue, 10 Feb 2026 15:48:56 -0800
In-Reply-To: <20260210200711.GCaYuP74dOknGNV1DT@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CALMp9eQmwsND7whnvVof1i=OsCdo6wcwBWyDRwS3Ud69WkKf-g@mail.gmail.com>
 <20260208211342.GBaYj8hhtYM-lYfq-X@fat_crate.local> <CALMp9eSVB=iRec2A0tmRzkTBa9zz4BVS8Lu79vUuRPrTawYFcQ@mail.gmail.com>
 <e19b9666-b224-4fbd-92c9-82c712916a07@suse.de> <aYn3_PhRvHPCJTo7@google.com>
 <20260209153243.GBaYn-G02QE86Fje7g@fat_crate.local> <aYoLcPkjJChCQM7E@google.com>
 <20260209174559.GDaYodVxWsiesiedLJ@fat_crate.local> <aYpNzX8KhnQTmzyH@google.com>
 <20260210200711.GCaYuP74dOknGNV1DT@fat_crate.local>
Message-ID: <aYvD6IHpEgS0DZBT@google.com>
Subject: Re: [PATCH] KVM: x86: synthesize TSA CPUID bits via SCATTERED_F()
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Carlos =?utf-8?B?TMOzcGV6?=" <clopez@suse.de>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>, Babu Moger <bmoger@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70813-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AE69D1202D8
X-Rspamd-Action: no action

On Tue, Feb 10, 2026, Borislav Petkov wrote:
> On Mon, Feb 09, 2026 at 01:12:45PM -0800, Sean Christopherson wrote:
> > On Mon, Feb 09, 2026, Borislav Petkov wrote:
> > > On Mon, Feb 09, 2026 at 08:29:36AM -0800, Sean Christopherson wrote:
> > > > Nope.  KVM cares about what KVM can virtualize/emulate, and about helping userspace
> > > > accurately represent the virtual CPU that will be enumerated to the guest.
> > > 
> > > So why don't you key on that in those macros instead of how they're defined?
> > > 
> > > 	EXPOSE_TO_GUEST_F()
> > > 
> > > and then underneath we can figure out how to expose them.
> > 
> > Huh?  That's what the macros do, they describe KVM's handling of the associated
> > feature.  SYNTHESIZED is a bit weird because it bleeds some kernel details into
> > KVM, but ultimately it's still KVM decision as to whether or not "forced" features
> > can be synthesized for the guest.
> 
> My point is that you have to know *which* macro of all the available ones you
> need to use, in order to expose the feature. This thread is a case-in-point
> example about how it can get confusing. And it dudn't have to...

Yes, it did have to.  These are the choices.  Whether they're in raw C code,
macro hell, or a spreadsheet, the choices remain the same.

> > > We could have a helper table which determines what each feature is and how it
> > > should interact with raw host CPUID or something slicker.
> > > 
> > > >   F               : Features that must be present in boot_cpu_data and raw CPUID
> > > >   SCATTERED_F     : Same as F(), but are scattered by the kernel
> 
> Right, so what happens if we unscatter a leaf?

The build will fail.  Explicitly because of this:

	BUILD_BUG_ON(X86_FEATURE_##name >= MAX_CPU_FEATURES);	\

and also because attempting to defined the CPUID_fn_idx_REG enum will collide
with the existing enum in kvm_only_cpuid_leafs, and we'll go unscatter the KVM
code.

Even without those safeguards, everything would be totally fine, the "overhead"
is negligible.  In other words, scattered leafs require a bit of extra code to
handle correctly in KVM, whereas normal F() leaves Just Work.

> And why does it matter to KVM if the baremetal feature is scattered or not?
> KVM should only care whether the kernel has set it or not.

Because KVM needs to query features in _guest_ CPUID, and so the bit position
must match the architectural values.  KVM also cares if the feature is present
in raw CPUID.

E.g. X86_FEATURE_SGX1 is bit 8 in Linux-defined word 11.  But in CPUID, SGX1 is
bit 0 in CPUID.0x12.0.EAX.  If KVM tried to query bit 8 in CPUID.0x12.0.EAX, it
would read garbage.

> > > >   X86_64_F        : Same as F(), but are restricted to 64-bit kernels
> > > >   EMULATED_F      : Always supported; the feature is unconditionally emulated in software
> 
> And an emulated feature *can* be scattered or synthesized or whatever...

Yep.

> > > >   SYNTHESIZED_F   : Features that must be present in boot_cpu_data, but may or
> > > >                     may not be in raw CPUID.  May also be scattered.
> 
> So which one do I use here?
> 
> This is the confusion I'm taking about.

For the TSA stuff?  SYNTHESIZED_F(), because KVM's ABI is to advertise support
for the "features" even if they're not present in raw CPUID, so long as they're
supported by the host kernel.

> > > >   PASSTHROUGH_F   : Features that must be present in raw CPUID, but may or may
> > > >                     not be present in boot_cpu_data
> 
> Maybe there's a reason for it but why would the guest care if the feature is
> present in raw CPUID or not? The hypervisor controls what the guest sees in
> CPUID...

The VMM controls what the guest sees, _KVM_ does not.

> > > >   ALIASED_1_EDX_F : Features in 0x8000_0001.EDX that are duplicates of identical 0x1.EDX features
> > > >   VENDOR_F        : Features that are controlled by vendor code, often because
> > > >                     they are guarded by a vendor specific module param.  Rules
> > > >                     vary, but typically they are handled like basic F() features
> > > >   RUNTIME_F       : Features that KVM dynamically sets/clears at runtime, but that
> > > >                     are never adveristed to userspace.  E.g. OSXSAVE and OSPKE.
> > > 
> 
> Also, we're rewriting the whole CPUID handling on baremetal and someday the
> CPUID table in the kernel will be the only thing you query - not the CPUID
> insn.

Perhaps.  But the only if the table provides both the kernel's configuration *and*
raw CPUID, and is 100% comprehensive.  And even if that happens, it won't change
anything about KVM's macros, except I guess remove the need for SCATTERED_F() if
the tables are truly comprehensive.

> Then those names above become wrong/obsolete.

No, because the concepts won't change.  The code may look different, and KVM may
need to #define a pile of things to do what it needs to do, but the semantics of
how KVM supports various features isn't changing.

> > > And for the time being, I'd love if this were somewhere in
> > > arch/x86/kvm/cpuid.c so that it is clear how one should use those macros.
> > 
> > I'll a patch with the above and more guidance.
> > 
> > > The end goal of having the user not care about which macro to use would be the
> > > ultimate, super-duper thing tho.
> > 
> > And impossible, for all intents and purposes.  The user/contributor/developer
> > needs to define KVM's handling semantics *somehwere*. 
> 
> I still don't get this: why does KVM need to know whether a X86_FEATURE is
> scattered or synthesized or whatnot?

See above regarding scattered.  As for synthesized, KVM is paranoid and so by
default, requires features to be supported by the host kernel *and* present in
raw CPUID in order to advertise support to the guest.  Whether or not the paranoia
is justified is arguable, but in practice it costs KVM almost nothing, and at the
very least, IMO it's very helpful to document KVM's exact expectations/rules.

> > Sure, we could to that in a big array or something, but that's just
> > a different way of dressing up the same pig.  All of this very much is an
> > ugly pig, but it's the concepts and mechanics that are ugly and convoluted.
> 
> Well, if we're redoing how feature flags and CPUID leafs etc are being handled
> on baremetal, why not extend that handling so that KVM can put info there too,
> about each feature and how it is going to be exposed to the guest instead of
> doing a whole bucket of _F() macros?

Because IMO, that would be a huge net negative.  I have zero desire to go lookup
a table to figure out KVM's rules for supporting a given feature, and even less
desire to have to route KVM-internal changes through a giant shared table.  I'm
also skeptical that a table would provide as many safeguards as the macro magic,
at least not without a lot more development.

> > E.g. if we define a giant array or table, the contributor will need to map the
> > feature to one of the above macros.
> 
> We are on the way to a giant array/table anyway:
> 
> https://lore.kernel.org/r/20250905121515.192792-1-darwi@linutronix.de

Using something like that for the core kernel makes a lot of sense.  But I don't
see what would be gained by shoehorning KVM's ABI into that table.

> > In other words, kvm_initialize_cpu_caps() _is_ the helper table.
> 
> $ git grep kvm_initialize_cpu_caps
> $
> 
> I'm on current Linus/master.

Ah, sorry, it's kvm_set_cpu_caps() until this pull request:

https://lore.kernel.org/all/20260207041011.913471-5-seanjc@google.com

