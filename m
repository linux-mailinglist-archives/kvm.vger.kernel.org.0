Return-Path: <kvm+bounces-71055-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kAd6EUpBj2nqOQEAu9opvQ
	(envelope-from <kvm+bounces-71055-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:20:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E200137764
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:20:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C7AE1301BCB5
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07A4B3624B7;
	Fri, 13 Feb 2026 15:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p6yPUz0K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEA2361DCF
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770996032; cv=none; b=RofA6bnRNzSYk5J2Ptnf8mWSpxIJXNH0mPby/44WOknRwjyyEV1OjzgsynSV0VlVLBlpL6QHwBxnMtO3MaYiH89GUeR9wHFJ4VVfSwRhmzMPr+IMaBjsyzKemlec+EXTZ9lAlavOVj/80fz/ysEYpf5lfidv/U5e7yILzoWFF10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770996032; c=relaxed/simple;
	bh=Rttl4d9sGgG3Lhh7v6oLA+vPF2preIIqOyYcVD4IJkw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fo9MCf7lGmm0YZGLmrjeYI+XVO65Y+qZbOl2jXSnNeDNNQdcmUGpbZHsl4p7jwjltjlWiKkROjGzx0aS3Qd5w2blz3VKzL3yYuIziznEfxxD9OgI+so09hDFSVDp3ca0/yHwJufWULyosabz2oGCYwPAUf351V37tdF1ydxIr5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p6yPUz0K; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6187bdadcdso630576a12.0
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 07:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770996030; x=1771600830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DXZgws1eGwFodcFEr+AzFaRA44BFbU5sqkzQqm7Vi/g=;
        b=p6yPUz0KaPYL/rL6Wu8Isz56jaZb5L3X3EcnX+A3LHfm2WpjGdrbwTdaEh9bHv77sd
         E34ItJt27w8LVnpfGwxUyVvTsZ2reAhyL8Ep0Ja+EusUl1LEPAy0DdYizWx5dKOCDhPW
         3I/itbDOcHCoHjFA7/FG3Scg+Ej3QCoYzs0vGoY+rM6dlU1IAmNlnkfjs8LoTN/hiTQb
         AH3RNF4dr62pPAbFH4HFCo90/AJRhvPrRG36b8x5B7v11zPnjmxBkKRfGryZIYkV7RrP
         vxnUWyzDCChOf3+H1hceMD1U8PnlpBKEbz/51DvjDscS0K2OXtTR3vFhYWOcQ4lI582i
         e1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770996030; x=1771600830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DXZgws1eGwFodcFEr+AzFaRA44BFbU5sqkzQqm7Vi/g=;
        b=KPoES4a+BM6tOBF2X7fzap+dA8TeNfic94Wq6TLhKbBxqn8PQMP4qbmFZhBa/4nIvN
         9ieKSaDZWhyFFBF+QeBdIflsRFyBZ5nQS18yTLX/I5dVaJ7XXNJiordkaA1zppmIH8Eu
         GKUdL1428uMsKQlLDueZfhnYUS9NvrdPh08Dxl+1uewmpiCt0HERXa8TsXEtFrvt32tN
         +DQKSTPWQEPx6yJz//WYt+B8SerFkSHjht4MWWzecZbeOolaytlp/+PI9U4IDlQnSLys
         OcWMtLUjcvUIyDnc73lFuj3fLVRF9JK9e7S1zpuLwIgrjwo6k+Bc4NWePkTHb2C34ajV
         8sbg==
X-Forwarded-Encrypted: i=1; AJvYcCXSvmfCMw8vBZZDiqEWhZSvS89xy1YS2SX7Y62ToAQD0oYkE0k4BOgn3C7oN1zY6OsAugM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrV8W5/Aihqx7E43z1gQQg4tSQ+4CH6Najv9sy71bSMYd85MAQ
	OJk4VsFr/npRmSa8EezyLyjsJtVUvi1Jr0BZqEK4AYRrgA6Ac0qR0B3s9bCbHG0wkyoiVyqDjLn
	24q6pYw==
X-Received: from pjvn19.prod.google.com ([2002:a17:90a:de93:b0:34c:c510:f186])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:486:b0:2bf:183c:ac86
 with SMTP id adf61e73a8af0-3946c816108mr1883855637.25.1770996030340; Fri, 13
 Feb 2026 07:20:30 -0800 (PST)
Date: Fri, 13 Feb 2026 07:20:28 -0800
In-Reply-To: <gqj4y6awen5dfxy32lbskcxw6xdv4xiiouycyftjacndjinhvp@7p4dtgdh6tjw>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com> <20260212155905.3448571-5-jmattson@google.com>
 <gqj4y6awen5dfxy32lbskcxw6xdv4xiiouycyftjacndjinhvp@7p4dtgdh6tjw>
Message-ID: <aY9BPKhzgxo4UuHB@google.com>
Subject: Re: [PATCH v4 4/8] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71055-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4E200137764
X-Rspamd-Action: no action

Please trim your replies.  Scrolling through 100+ lines of quoted text to find
the ~12 lines of context that actually matter is annoying.

On Fri, Feb 13, 2026, Yosry Ahmed wrote:
> On Thu, Feb 12, 2026 at 07:58:52AM -0800, Jim Mattson wrote:
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index a49c48459e0b..88549705133f 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -607,6 +607,22 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
> >  	return svm->nested.ctl.misc_ctl & SVM_MISC_ENABLE_NP;
> >  }
> >  
> > +static inline void svm_set_gpat(struct vcpu_svm *svm, u64 data)
> > +{
> > +	svm->nested.save.g_pat = data;
> > +	vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
> > +}
> > +
> > +static inline void svm_set_hpat(struct vcpu_svm *svm, u64 data)
> > +{
> > +	svm->vcpu.arch.pat = data;
> > +	if (npt_enabled) {

Peeking at the future patches, if we make this:

	if (!npt_enabled)
		return;

then we can end up with this:

	if (npt_enabled)
		return;

	vmcb_set_gpat(svm->vmcb01.ptr, data);
	if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(svm))
		vmcb_set_gpat(svm->nested.vmcb02.ptr, data);

	if (svm->nested.legacy_gpat_semantics)
		svm_set_l2_pat(svm, data);

Because legacy_gpat_semantics can only be true if npt_enabled is true.  Without
that guard, KVM _looks_ buggy because it's setting gpat in the VMCB even when
it shouldn't exist.

Actually, calling svm_set_l2_pat() when !is_guest_mode() is wrong too, no?  E.g.
shouldn't we end up with this?

  static inline void svm_set_l1_pat(struct vcpu_svm *svm, u64 data)
  {
	svm->vcpu.arch.pat = data;

	if (npt_enabled)
		return;

	vmcb_set_gpat(svm->vmcb01.ptr, data);

	if (is_guest_mode(&svm->vcpu)) {
		if (svm->nested.legacy_gpat_semantics)
			svm_set_l2_pat(svm, data);
		else if (!nested_npt_enabled(svm))
			vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
	}
  }


> > +		vmcb_set_gpat(svm->vmcb01.ptr, data);
> > +		if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(svm))
> > +			vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
> > +	}
> > +}
> 
> Is it me, or is it a bit confusing that svm_set_gpat() sets L2's gPAT
> not L1's, and svm_set_hpat() calls vmcb_set_gpat()?

It's not just you.  I don't find it confusing per se, more that it's really
subtle.

> "gpat" means different things in the context of the VMCB or otherwise,
> which kinda makes sense but is also not super clear. Maybe
> svm_set_l1_gpat() and svm_set_l2_gpat() is more clear?

I think just svm_set_l1_pat() and svm_set_l2_pat(), because gpat straight up
doesn't exist when NPT is disabled/unsupported.

