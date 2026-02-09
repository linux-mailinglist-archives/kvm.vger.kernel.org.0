Return-Path: <kvm+bounces-70646-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KAZyFNxNiml9JQAAu9opvQ
	(envelope-from <kvm+bounces-70646-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 22:13:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D236114B4E
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 22:12:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 59D1030263C9
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 21:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2429730DED8;
	Mon,  9 Feb 2026 21:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="htyr5pDT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A1E30BF7D
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 21:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770671569; cv=none; b=aVWnamZoaCRZ7coJhI54rd80fMb5u5qLfwSgUTPlhmzTv8h0Bff2guULYay8S6fAE/D2EI+QIBG8X1VgCid7cMba0RP7kRu1YCYo2/T7pvMV8bvqDo//Ycxbo9eqPsqBz1E0QN/uBYovU9ZRWQ4r/A1WdALVH07nT4e/p67cLAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770671569; c=relaxed/simple;
	bh=Uxn+SvC4cwV/a8hZpODkPu6yuzOnTkz5evR3xUhgIBA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KbPRjlWFTNmb1XHYAZaG2I2NkOUDllUn7hMyhYHdc/FaCuINacpdZaMXBRpa3OuGc6Hzv1LT0J+5tXfXOTigHj55MDDCpimM87E2mtAZyfQWoVUSm9SvtO7Zd6ljQlzPBwGhe7Hr/rVkTvyk5Isa6y86bvNo837ABM3/tWBAPmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=htyr5pDT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3561f5bd22eso133682a91.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 13:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770671568; x=1771276368; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5JLkCGyOFIJqN8NxvIX+7FWicQMfpPV6EbEazy85XpY=;
        b=htyr5pDTymjWTtVyfsLaVIvaraI8RuD4Z00QSFJGZqCt61VqpVhSxdZcWuw7OBryAT
         YRlKWBXE8niz7Jnfm8BtBS5Und86thDtylum0rJG+MLkejrlXLk9g2Pj16bcTpUBYWy+
         VIXrNSs7eE6YaST3VxqfshAFlg+R7f73aE6QAPJGnROKXPcvEn1oVly4Kh4+oLuv9puO
         fVSiODHGyJ3LgiNRz1CX72315NF9lATbma2mh2z46+zWd+Xab4f+KA1rQzp7PjCWZHgX
         GlPWjRBcMS7wD7ng287+nxeAVoPRHJ1BJf6ppjqOdQm/YSNKT0yzPJ8JFOSGFXk99zaY
         KLAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770671568; x=1771276368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5JLkCGyOFIJqN8NxvIX+7FWicQMfpPV6EbEazy85XpY=;
        b=jr2rWaE4QGo5Dufe09MAneUYicz8UP18QBmoe3n9shcU+16jnhte106JXDA6rRy10J
         BcoL7sTQZHuvZYyJIRLD2gFLa5iBq6tzWTPNEq+giATmBgyAyhTy5MCj4Qw89mDN2CDt
         BvS4SskAMsCyktpRzhkknPa/JvSSiNXGyM4QQllXQAU759g/55sfXxl6Rty0BDonjDUR
         jOiGAimF7hD6DGSKo29LbtzAW1Wngh7p58K4UqssDYroxHZSh6l8SPrVRIjwDAm1m4wc
         /wti7Dbs37ES/UQO1Lg62ZsoSvZZ8yQBUMZWFq9UgZAal/0BAKk5tbY2Gn8LluqAb9tl
         qNAw==
X-Forwarded-Encrypted: i=1; AJvYcCVBOUDWKV/RUPu564ZnDEpBcvrdutXvn8Jf6VtQzlWJB+qX+Ck1oNQS0WdT5jLPOs/hkn0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxslRWakHCHYTu2AfqZ505hJwwR32yFSfvfJl5i3LeRrCwECRS
	vdDJcn7dHNkAR++vyI5TNEVZAR5o76e2hYzQLyK+vj5nFn3PXQ7BMb8JlKUpEd+wRDN3dgAlTLc
	19IfTAg==
X-Received: from pjbei13.prod.google.com ([2002:a17:90a:e54d:b0:354:aa76:8270])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6c8:b0:356:2872:9c50
 with SMTP id 98e67ed59e1d1-35628729fb0mr5833088a91.35.1770671567603; Mon, 09
 Feb 2026 13:12:47 -0800 (PST)
Date: Mon, 9 Feb 2026 13:12:45 -0800
In-Reply-To: <20260209174559.GDaYodVxWsiesiedLJ@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260208164233.30405-1-clopez@suse.de> <20260208182849.GAaYjV4Vh8i0kznTEK@fat_crate.local>
 <CALMp9eQmwsND7whnvVof1i=OsCdo6wcwBWyDRwS3Ud69WkKf-g@mail.gmail.com>
 <20260208211342.GBaYj8hhtYM-lYfq-X@fat_crate.local> <CALMp9eSVB=iRec2A0tmRzkTBa9zz4BVS8Lu79vUuRPrTawYFcQ@mail.gmail.com>
 <e19b9666-b224-4fbd-92c9-82c712916a07@suse.de> <aYn3_PhRvHPCJTo7@google.com>
 <20260209153243.GBaYn-G02QE86Fje7g@fat_crate.local> <aYoLcPkjJChCQM7E@google.com>
 <20260209174559.GDaYodVxWsiesiedLJ@fat_crate.local>
Message-ID: <aYpNzX8KhnQTmzyH@google.com>
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
	TAGGED_FROM(0.00)[bounces-70646-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 0D236114B4E
X-Rspamd-Action: no action

On Mon, Feb 09, 2026, Borislav Petkov wrote:
> On Mon, Feb 09, 2026 at 08:29:36AM -0800, Sean Christopherson wrote:
> > Nope.  KVM cares about what KVM can virtualize/emulate, and about helping userspace
> > accurately represent the virtual CPU that will be enumerated to the guest.
> 
> So why don't you key on that in those macros instead of how they're defined?
> 
> 	EXPOSE_TO_GUEST_F()
> 
> and then underneath we can figure out how to expose them.

Huh?  That's what the macros do, they describe KVM's handling of the associated
feature.  SYNTHESIZED is a bit weird because it bleeds some kernel details into
KVM, but ultimately it's still KVM decision as to whether or not "forced" features
can be synthesized for the guest.

> We could have a helper table which determines what each feature is and how it
> should interact with raw host CPUID or something slicker.
> 
> >   F               : Features that must be present in boot_cpu_data and raw CPUID
> >   SCATTERED_F     : Same as F(), but are scattered by the kernel
> >   X86_64_F        : Same as F(), but are restricted to 64-bit kernels
> >   EMULATED_F      : Always supported; the feature is unconditionally emulated in software
> >   SYNTHESIZED_F   : Features that must be present in boot_cpu_data, but may or
> >                     may not be in raw CPUID.  May also be scattered.
> >   PASSTHROUGH_F   : Features that must be present in raw CPUID, but may or may
> >                     not be present in boot_cpu_data
> >   ALIASED_1_EDX_F : Features in 0x8000_0001.EDX that are duplicates of identical 0x1.EDX features
> >   VENDOR_F        : Features that are controlled by vendor code, often because
> >                     they are guarded by a vendor specific module param.  Rules
> >                     vary, but typically they are handled like basic F() features
> >   RUNTIME_F       : Features that KVM dynamically sets/clears at runtime, but that
> >                     are never adveristed to userspace.  E.g. OSXSAVE and OSPKE.
> 
> And for the time being, I'd love if this were somewhere in
> arch/x86/kvm/cpuid.c so that it is clear how one should use those macros.

I'll a patch with the above and more guidance.

> The end goal of having the user not care about which macro to use would be the
> ultimate, super-duper thing tho.

And impossible, for all intents and purposes.  The user/contributor/developer
needs to define KVM's handling semantics *somehwere*.  Sure, we could to that in
a big array or something, but that's just a different way of dressing up the same
pig.  All of this very much is an ugly pig, but it's the concepts and mechanics
that are ugly and convoluted.

E.g. if we define a giant array or table, the contributor will need to map the
feature to one of the above macros.

In other words, kvm_initialize_cpu_caps() _is_ the helper table.  If someone wants
to try and do better, by all means, have at it.  But I won't hold my breath.

