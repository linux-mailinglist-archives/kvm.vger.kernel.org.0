Return-Path: <kvm+bounces-73311-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4PPiAszirmmoJgIAu9opvQ
	(envelope-from <kvm+bounces-73311-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:10:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 622E223B51C
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:10:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C547A3126C55
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021C83D75DE;
	Mon,  9 Mar 2026 15:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZVwyCNzP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803573D6681
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 15:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773068771; cv=none; b=bmXVWfNw5HB6T2Y2c86YxkW5Hf23L256a6SwFpvbo02PH3KipVQ4752pNuC6aMu0s3Qn+yTPermw1BxG/s9OPtf5sdg0rDtp6yGWGJEYSsuxbkm4lfbCIv9+y92S4DODEBa9uCK3nNJS0w4MK194LbSTuJDXIn/WsCBBQLStqy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773068771; c=relaxed/simple;
	bh=/MOHaVgNHRp4JBw8+Wq3HwMoLhDR1d5oqHOoghhG4VY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kDoqMnNlRyOaTJC5Ix5w8diS9eed4b5yik00/8JkyUmRUtmI0fQ3dP5SQSD7z5+XA+IRb3SlhXyfPLIbq4HK7LmI1dU/kaWJZOSyYhKi+03nf2yLyIH8fnlCVpWqxiq2WjJ91INBisD3Grj82KfVpVFFVw8+3SUeh5r4FzO75gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZVwyCNzP; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c73b1376f98so5098976a12.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 08:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773068769; x=1773673569; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X6+jvs0ikVmPfIUblxLDk+jmVbMmxtDwNslNjGhaR8Y=;
        b=ZVwyCNzPfhXT70Z/jo3Ho7/UT/FGRYDvKSmKX+1IniEfWDSl8+MBd6Z01veQAXsEiQ
         b+/W3bzWZcpxjBGmlk9IKbOwjRNyKK07YPGidR0VofvibooMjGQKM4bQlA/Tk2op0Cyq
         lJoQNurDHwqnk+FOwT4KjubFiIUVmX3jbH6xlZD2uEW9wA4Jf0O4ybxMcfAwS8DXAb4c
         5hHNxS7cXmRwWmCb6Nr/pLYT9yFa0l/nKjvEEM0c8C6LlBkR3zYxx9Sc4iO8IB1y9x6z
         7UGV0vWTuPDkIONcnfneKwKhAeGObTEjRRCdp5RSg1YNFKEWiQ0iaDSLeBSSUg17KjMr
         bjqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773068769; x=1773673569;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X6+jvs0ikVmPfIUblxLDk+jmVbMmxtDwNslNjGhaR8Y=;
        b=Myf07CVeadPLMdQK1/3mMGhk3uK3/99JRuyvGDCyijrjrP6+6I9GqLHkxbml/kW+rn
         5PaGsDZCp/x064OLQLhYAp88vnipd1yl5ujbMowdGulMvl3Pmgj1pV9EQUk2AO4GDrTt
         hNwY4yzQ83izE7w7k7Dp0ui+Vv8eKe9bGBau0QX80bJWwvBHZTQSz3epyfWDuBSedxcw
         2hWHesoGdCSmRdNA8LjU1AnhAeTao2H7VcjhDvEweaE+BmDYXjpB2+y4UvFJvVa3LdjI
         KSEgszy1VO3ot/cyoBTYZ1I60dOnfOMvNee8s9Q85E85vW18NpQSHnYiK3+Kwu37lATl
         v3tA==
X-Forwarded-Encrypted: i=1; AJvYcCV1gUiKyoiOfwTuJ60I6NAQeNjcT+5h5s/rrE4T0CRRtotT4siKuC6+1OWw6MTPnJM6w3E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/ttMG5ZPAx2aSPRQGPzzeYMhGyTudG9XMEPpAAiPYjPcu+3xC
	OG83ButNK7WSGGXI7kttHpoK0/EaMf6dMMAXLUM36I1BUuMkXrMQAzt4t7cLN38BllaHZ6c54+M
	Roy+ljw==
X-Received: from pfw6.prod.google.com ([2002:a05:6a00:a266:b0:824:a303:863c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6b0d:b0:394:56ae:8a7f
 with SMTP id adf61e73a8af0-3985908ba31mr11560818637.42.1773068768737; Mon, 09
 Mar 2026 08:06:08 -0700 (PDT)
Date: Mon, 9 Mar 2026 08:06:07 -0700
In-Reply-To: <CAO9r8zOM0OWaFvAQd6FGkCC6WxkVBbQZa10pFm9b-wF1G1A6ew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260307011619.2324234-4-yosry@kernel.org> <34cbc227-f01f-4d4b-b6ab-19bcb02d7e3c@citrix.com>
 <CAO9r8zOM0OWaFvAQd6FGkCC6WxkVBbQZa10pFm9b-wF1G1A6ew@mail.gmail.com>
Message-ID: <aa7h39_Vp6P5TVA7@google.com>
Subject: Re: [PATCH v2 3/3] KVM: SVM: Advertise Translation Cache Extensions
 to userspace
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, venkateshs@chromium.org, 
	venkateshs@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 622E223B51C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73311-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.942];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[chromium.org:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,citrix.com:email]
X-Rspamd-Action: no action

On Mon, Mar 09, 2026, Yosry Ahmed wrote:
> On Fri, Mar 6, 2026 at 5:54=E2=80=AFPM Andrew Cooper <andrew.cooper3@citr=
ix.com> wrote:
> >
> > > From: Venkatesh Srinivas <venkateshs@chromium.org>
> > >
> > > TCE augments the behavior of TLB invalidating instructions (INVLPG,
> > > INVLPGB, and INVPCID) to only invalidate translations for relevant
> > > intermediate mappings to the address range, rather than ALL intermdia=
te
> > > translations.
> > >
> > > The Linux kernel has been setting EFER.TCE if supported by the CPU si=
nce
> > > commit 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions=
"),
> > > as it may improve performance.
> > >
> > > KVM does not need to do anything to virtualize the feature, only
> > > advertise it and allow setting EFER.TCE. If a TLB invalidating
> > > instruction is not intercepted, it will behave according to the guest=
's
> > > setting of EFER.TCE as the value will be loaded on VM-Enter. Otherwis=
e,
> > > KVM's emulation may invalidate more TLB entries, which is perfectly f=
ine
> > > as the CPU is allowed to invalidate more TLB entries that it strictly
> > > needs to.
> > >
> > > Advertise X86_FEATURE_TCE to userspace, and allow the guest to set
> > > EFER.TCE if available.
> > >
> > > Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
> > > Co-developed-by: Yosry Ahmed <yosry@kernel.org>
> > > Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> >
> > I'll repeat what I said on that referenced patch.
> >
> > What's the point?  AMD have said that TCE doesn't exist any more; it's =
a
> > bit that's no longer wired into anything.
> >
> > You've got to get to pre-Zen hardware before this has any behavioural
> > effect, at which point the breath of testing is almost 0.
>=20
> Oh, I did not know that, thanks for pointing it out.
>=20
> I'll leave it up to Sean whether to pick this up (because Linux guests
> still set the bit), just pick up patches 1-2 as cleanups, or drop this
> entirely.

I'll grab 1-2 and leave 3 alone, at least for now.  It _should_ do no harm,=
 but
it would really suck to discover that pre-Zen hardware has a TLB bug that a=
ffects
TCE, or worse, affects TCE but only for ASID!=3D0 translations or something=
.

If new CPUs ever use TCE, it'll be trivial to enable at that time.

