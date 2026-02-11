Return-Path: <kvm+bounces-70872-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2PW7G2yujGl/sAAAu9opvQ
	(envelope-from <kvm+bounces-70872-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:29:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C98921261D2
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:29:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 42832304520C
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023FB33FE35;
	Wed, 11 Feb 2026 16:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ss09orXp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2173433F38C
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770827317; cv=none; b=uim57px+tj7hXJDm+M2B5azMGcDGoHEjC01gCJnS0Vuep/p5ltfzS60P6ItLu0rXhBL3oUj6pTPgvkjAa7nHrtAH+cyDR6fA0dB9+0oFVdvrbQ+Shugw2GcGZ37t0rpg4tzdzcDsDbDzIncPKISWdx7DVPQ9EiWKmqoGMOPKvGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770827317; c=relaxed/simple;
	bh=U+cPEElKThFnDHVfgnxSQE1ymjjnaLfhLZ4SW2NbBv8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bMx9K/VxbTDflO9ADJteh3ujJPoOY/DreeKEJTP+UMWJLzWa++NvQxATIMYSh05/PnPRbgL0jzGpR45r9lwR6KdODPZ7yAkzVn2qeKaYm0HNiYQomiGrslnrHl9JGrPTjiuQtcf5hT2OhlN+ccJvdV1zOF0qeEZYckLMqM4992A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ss09orXp; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354be486779so4341577a91.0
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 08:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770827315; x=1771432115; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H5lF3URYjElzfLukro0tcBvHJBsX+iaWEIkLwMGC0+s=;
        b=ss09orXpKvV8MlCBQyhHE4x8fZBdpwEORTpKuqg01kujc5xlwdyaKUt2s39yZ7eKLR
         0Ips4mwVn1LTGu0NghXvLB4gom/Z9JTb/eypDO9JYHNSCBWm0fB8it3FENgOlvQKVZZm
         uQj2uQTKi062xRLQjVlfx7jiuUTFmu0TF72u8akcyImowxapvOVIeurHBjksM7bOHLqN
         I/7NrWInZGcThzpFnP9Cr0wZen+fBrW2d6Xv4zOvCqulmUqPNMopy7aj0VHDFxT5P3Pv
         b2CpVHz7RXtunQROLVTngAdHca9RXmlHEmT4ivTQUcx0BrVi3tNKiSmxvkzE1+V5A/ie
         e0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770827315; x=1771432115;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H5lF3URYjElzfLukro0tcBvHJBsX+iaWEIkLwMGC0+s=;
        b=FwY50DltAB6fDxd4UqJHc4KGJgvhEk79Fe6NkqhBvCcvlZLB7p0P4LHe8vmdpK/QZG
         riR2NEWU0ezz08enHjQVKo6/ExH2o/rE20VSoIl1xysSZ64VOwEKUjEFRfXNBJsVovaV
         DtbnZR/KH7xY7lXY0XsR9xsL/U+Jwg36RaNsbWOPWXCKQLEAYzaw9b08uPJ1mgurAeDH
         nDhhC6DQ+Od8LB5aA/sAW0nI610nPOLukQiwC9owdiIoTSKChQD56xkV6731Fwr+SjDi
         OTlsRZkwbFv0HGAW1XchLdP3jvaSTWDmdRiP/gPXJaJYVmEQwT/CRE4Nu4X1PfcsPts3
         LuWA==
X-Forwarded-Encrypted: i=1; AJvYcCVvHpZpUwNj2RL3IuvxnNhfmHFp0RCud7UNRKrKDkfIRW8eP0AAnIem4mwGPw3OL1jyZUk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrHNe+e7UbBgqfgH9bY4V4XZZTSLBzGF6UF1660h1/PJDmxwp3
	85kXECaDPa6M/gKzZ6TZU5YHQRXXcaX7Uetb9itC4PzOa4628mtL8BD6YovlwdYPmxre/mIqV/9
	Er9yruQ==
X-Received: from plsr7.prod.google.com ([2002:a17:902:be07:b0:2a0:84dc:a82f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a0c:b0:38e:9e55:6df6
 with SMTP id adf61e73a8af0-393acf9cbe5mr18514534637.3.1770827315468; Wed, 11
 Feb 2026 08:28:35 -0800 (PST)
Date: Wed, 11 Feb 2026 08:28:34 -0800
In-Reply-To: <20260211161723.GDaYyrk9gZfONLoARz@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aYn3_PhRvHPCJTo7@google.com> <20260209153243.GBaYn-G02QE86Fje7g@fat_crate.local>
 <aYoLcPkjJChCQM7E@google.com> <20260209174559.GDaYodVxWsiesiedLJ@fat_crate.local>
 <aYpNzX8KhnQTmzyH@google.com> <20260210200711.GCaYuP74dOknGNV1DT@fat_crate.local>
 <aYvD6IHpEgS0DZBT@google.com> <20260211133226.GCaYyE6u_IMik5DY4m@fat_crate.local>
 <aYymNqGGnan7Ga1D@google.com> <20260211161723.GDaYyrk9gZfONLoARz@fat_crate.local>
Message-ID: <aYyuMkN56sNZBY9f@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70872-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C98921261D2
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Borislav Petkov wrote:
> On Wed, Feb 11, 2026 at 07:54:30AM -0800, Sean Christopherson wrote:
> > If the kernel tracks both raw CPUID *and* kernel caps, then KVM can use the
> > table without having to (re)do CPUID when configuring KVM's feature set.  But
> > KVM would still need to have processing for SYNTHESIZED_F, PASSTHROUGH_F, and F,
> > to derive the correct state from the raw+kernel tables.
> 
> That's what I meant - the macros and the confusion which one to use would go
> away.

Again, the macros would go away, but they would simply be replaced by labels in
a table.  I.e. the "confusion" won't go away, because it can't simply disappear.
That knowledge must live somewhere.

