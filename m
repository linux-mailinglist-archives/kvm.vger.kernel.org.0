Return-Path: <kvm+bounces-70864-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OJKmDD6mjGnVrwAAu9opvQ
	(envelope-from <kvm+bounces-70864-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:54:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C3B125DF0
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:54:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7820530146AD
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 15:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34351319843;
	Wed, 11 Feb 2026 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eRlHdXf6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DDB2EF64D
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770825273; cv=none; b=uLPydpP/iG6rdMly0iEKdaiy3YRpnC3Cz41Ic8Bq0UhHOx7pv9E/+Ep8R3VNfRdlb9pB3ppCZoRKVdcXkq9/LE6woDF0vJsEKu9TqFemq7TmUARy4kOyIYfcXzPM7DL0tjv1HtIKKooTKN98i/DVMdHf14M84bd83X1oTWvjmbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770825273; c=relaxed/simple;
	bh=udEYJzW/vExQgZ+1QN+mlGM7VGV9PWFLvvV/PuJPXAw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=So7P2B/xjd7FplU+JXe5mLjKSd2a+kfh2JNLvGnsvCKSSDLs4nlfVBijH7fvJLEI2pbU/aEmhwYA4GvGWzE0o7WYGQjh40hKxSXu/GmNB9CZblkcLBEjdAYdx5XtKc/VVV2WH1I/mHAe0CJH9+1yq6NLTVd5H/5uHfCp0lgecXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eRlHdXf6; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a377e15716so134664545ad.3
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 07:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770825272; x=1771430072; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9n7HkCUm+70QYWul854vYpIiRTrImnKsgAkfNc3Krg4=;
        b=eRlHdXf6fFauDyDup82rpE5lKs/hLUHXXtVlF497E8Q5c/Nw9fa+zBLepe5SP4u3A6
         YshaEycIzhDlnbZn0Ox9sankl9DXxET70kWHuaUp8YapYDb39LwOTHecBH0Wzpod2Ib0
         +1Ua6SC7GfLYY51gRlYt64uJITQoRmfJhL4C7519XoJ25D7cUadFww7/4RUUyPWlZ1Xh
         iYgVPDXtW3bSRQPnSkgfXhwnkrMCAUqkNvQk1UsF99gT7vo7hXdwvLAABkOs0Ou3xPOs
         DzyHzqK3g2eCi9z9xquxGD+yRmgnJncSVl8p4fMv6efw4nV0v95mbjVSTlONfJmdcN4S
         I1kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770825272; x=1771430072;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9n7HkCUm+70QYWul854vYpIiRTrImnKsgAkfNc3Krg4=;
        b=TgNayjiOtivyoX03zUU9Vyv0apqdyADOhM9rpAcZGzr8qBQOJI0F3rHWH2wZ1KaToq
         QtvtoW9rYVV7+BKFC57qG9zqGIr6kZODG8/KOelNFwAZM9ZfrmvXiMAMHchM4I1p9nuN
         fA374/2jh1RbGxtq93mgaPheyOXToruVaYD5egYI2jARhnOYlz9s7QnHcpSOJGh2yxAg
         Xlf0OHaP8vVox1A7eB3AZUcuC61tejn7Kv+FYiNdspO1w+EqYwhHGCruC4jvmeqV3xcg
         +N/HCE5u7Pn2iDqXNAeF+2NOZ/Fh4kWZj6QGmtflIkDfACFQql3c2azJt88DFUm/Re76
         11hw==
X-Forwarded-Encrypted: i=1; AJvYcCW+SFVGhoWVxb7c3ZRtXAi0Z6Fz8wIqA+gWUYjEYdPJOzalquQlRq7BY82dpgHJe3SbP4M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4t28NggrhsVPwRYCR8Af7yfd/rnIEsebB4y44UV3QaCq9lyDr
	/5v2EwvPnLsmmLqvxnO5lQrJn3dClHAiXmZJA219lHI0Q//Td+kCTtRmyXfP6ZLVS6SEQuPV4kt
	SixZgFw==
X-Received: from plblf15.prod.google.com ([2002:a17:902:fb4f:b0:2aa:d3db:54c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2c05:b0:2a9:327f:ac56
 with SMTP id d9443c01a7336-2ab280c8557mr31541045ad.55.1770825271576; Wed, 11
 Feb 2026 07:54:31 -0800 (PST)
Date: Wed, 11 Feb 2026 07:54:30 -0800
In-Reply-To: <20260211133226.GCaYyE6u_IMik5DY4m@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CALMp9eSVB=iRec2A0tmRzkTBa9zz4BVS8Lu79vUuRPrTawYFcQ@mail.gmail.com>
 <e19b9666-b224-4fbd-92c9-82c712916a07@suse.de> <aYn3_PhRvHPCJTo7@google.com>
 <20260209153243.GBaYn-G02QE86Fje7g@fat_crate.local> <aYoLcPkjJChCQM7E@google.com>
 <20260209174559.GDaYodVxWsiesiedLJ@fat_crate.local> <aYpNzX8KhnQTmzyH@google.com>
 <20260210200711.GCaYuP74dOknGNV1DT@fat_crate.local> <aYvD6IHpEgS0DZBT@google.com>
 <20260211133226.GCaYyE6u_IMik5DY4m@fat_crate.local>
Message-ID: <aYymNqGGnan7Ga1D@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70864-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A5C3B125DF0
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Borislav Petkov wrote:
> On Tue, Feb 10, 2026 at 03:48:56PM -0800, Sean Christopherson wrote:
> > See above regarding scattered.  As for synthesized, KVM is paranoid and so by
> > default, requires features to be supported by the host kernel *and* present in
> > raw CPUID in order to advertise support to the guest.
> 
> Yes, it will check for X86_FEATURE to be and then look at CPUID.
> 
> > Because IMO, that would be a huge net negative.  I have zero desire to go lookup
> > a table to figure out KVM's rules for supporting a given feature, and even less
> > desire to have to route KVM-internal changes through a giant shared table.  I'm
> > also skeptical that a table would provide as many safeguards as the macro magic,
> > at least not without a lot more development.
> 
> Lemme cut to the chase because it seems to me like my point is not coming
> across:

I understand what the goal is, I just don't want to buy what you're selling.

> We're changing how CPUID is handled on baremetal. Consider how much trouble
> there was and is between how the baremetal kernel handles CPUID features and
> how KVM wants to handle them and how those should be independent but they
> aren't and if we change baremetal handling - i.e., unscatter a leaf - we break
> KVM, yadda yadda, and all the friction over the years.

Those problems are _entirely_ limited to the fact that the kernel's feature tracking
isn't 100% comprehensive.  It's completely orthogonal to KVM's enumeration of its
supported feature.

> Now we have the chance to define that cleanly and also accomodate KVM's needs.
> 
> As in, you add a CPUID flag in baremetal and then in the representation of
> that flag in our internal structures, there are KVM-specific attributes which
> are used by it to do that feature flag's representation to guests.
> 
> The new scheme will get rid of the scattered crap as it is not needed anymore
> - we'll have the *whole* CPUID leaf hierarchy. Now wouldn't it be lovely to
> have a
> 
> 	.kvm_flags = EMULATED_F | X86_64_F ... RUNTIME_F
> 
> which is per CPUID feature bit and which KVM code queries?

No, it honestly sounds rather awful.

> SCATTERED_F, SYNTHESIZED_F, PASSTHROUGH_F become obsolete.

SCATTERED_F will become obsolete, SYNTHESIZED_F and PASSTHROUGH_F will not.  They
cannot.  It's impossible to express three states with one bit.  

                SYNTHESIZED_F     PASSTHROUGH_F     F
raw CPUID           DONT_CARE                 Y     Y
kernel caps                 Y         DONT_CARE     Y


If the kernel tracks both raw CPUID *and* kernel caps, then KVM can use the
table without having to (re)do CPUID when configuring KVM's feature set.  But
KVM would still need to have processing for SYNTHESIZED_F, PASSTHROUGH_F, and F,
to derive the correct state from the raw+kernel tables.

> No need for those macros, adding new CPUID feature flags would mean simply
> adding those .kvm_flags things which denote what KVM does with the feature.
> Not how it is defined internally.
> 
> And then everything JustWorks(tm) naturally without having to deal with those
> macros.
> 
> And you'd get rid of the KVM-only CPUID leafs too because everything will be
> in one central place.

Again, that's achieved purely by tracking the full CPUID hierarchy.  It has nothing
to do with EMULATED_F, X86_64_F, RUNTIME_F, SYNTHESIZED_F, PASSTHROUGH_F, etc. 

> Now why wouldn't you want that wonderful and charming thing?!

Because from my perspective, centralizing *everything* is all pain, no gain.  It
would bleed KVM details into the broader kernel, unnecessarily limit KVM's ability
to change how KVM emulates/virtualizes features, and require querying a lookaside
table to understand KVM's rules/handling.  No thanks.

