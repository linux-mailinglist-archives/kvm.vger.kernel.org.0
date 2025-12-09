Return-Path: <kvm+bounces-65589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E5203CB0DD1
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 19:42:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 764E330AD6BD
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 18:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C69302CD9;
	Tue,  9 Dec 2025 18:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NtuwsvmS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CAE2E2DF4
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 18:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765305744; cv=none; b=shNxV0AACbtTecUoI25Ev5b/vZfJjZq9Es6YZYLtoQ/La8qq+mu7vKcLr2Z2DwIX3qe/XdyMEGoJa5t9kLhzm9y0gLPFQOCKmewdwlRYL+lMINdUnt0AFvmcCJjPfL0NqfiGF/QnECkTBB1S6Lt5aoy65EhwRMc8nYU8vTxv8E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765305744; c=relaxed/simple;
	bh=vMvsk3oUTASmZOfW6S7iQlTaxU1FZzX8m9pijyy/yi8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l1wOmQwBr463wm32ZsDkzEs101hxsAL2g7H3NCLoJJFhIu2Jw0JOk2GObj5O8itHyJDZpzYYHJ5iCTmIN7rwE+lbmOFsw4b7qOAzykJkDU0I5G7K5tWJ9D4zlxiPqfRKrUa18AvFJJxw19JnmNs+ZCW8Nwr0Bm7wTd11g30ciOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NtuwsvmS; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b4933bc4aeso6027826b3a.2
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 10:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765305742; x=1765910542; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T9wtgZU3PD0RINuovlbS/4juWgq3hGIlsoGbD5fVH4s=;
        b=NtuwsvmSCnXOumBFdNgTB73ZrGNcwnxOLSaEUaRn6XD/AJ63FrHbrZmnXKxfoenOGS
         lf0pmpNgN06S8a64WVzxaYbY9AFHyoCY9DqheoYeII3ZHXfU2abTCqDjGX1mCQdZR8KG
         r+Xo+rBnfHb7EkvFjAUc8hWIylxyhwPrOffRfK7XQVSv0uA0CQLyDWSZ3b6M8Zl53Q5w
         0qs5tGo8+4g/NnpDMIVpLGEFd5BRSv+2gI2gCFzQfbiLSo6A5cmHorOA57mFIfTwyQ1E
         6iQWTeCSeke8arbfm0f0NUza7ojMAAH3cPGTAGIF+PDIcr8yAfGrCPTVNn9/szucBKs0
         Hi9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765305742; x=1765910542;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T9wtgZU3PD0RINuovlbS/4juWgq3hGIlsoGbD5fVH4s=;
        b=VAvr76+woOMYtpXGJAm+R+zcVzSzXrr1c1z2LjldNuN+zlpMiO04+hfohA3pQA0hfX
         fGbqOU7/pcIA2duUyjbVWdWXnuMLElzZxwvOk2VTKdZd2WXwy/xRImlujr9E+J6M7cML
         aRKDfFq1F3f/+7VYYXhVFXBbHICnmTGIVDfNT+dTy3iAcFnEpSS4pr/YqBzvYHp6hxjk
         xR340cUA+MaNqnjRVbJFAuRcpQ24MQZmCfZYJaRdOqBjgD0bWJFxGOivV2i1Q9IKZB7C
         pRoeArpV9F0ldRlX4YUbhm/0nQMT0jRmkRCNen0etI5sIMa2/XTly+58xRkkY3/IaJiu
         F6OA==
X-Forwarded-Encrypted: i=1; AJvYcCXxCSlk4k7n6y2zepHXl4h/g8FFfPSwwClYg7hoVlamjEs9Ae9SgYgXhBxqr9e75Xzf20Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy89VJhtDmROlVt2SLMVkZlIfhOisJC60hF7z/MOpsD4Agj2U0m
	gYlPgfUTUYgcJ92YKnWwlxrOl0JGLuxepuZH68O9vaNCG/qoo6KAB9hF4s1vhZQ5IP+AUczPNAK
	z4ZeZWg==
X-Google-Smtp-Source: AGHT+IG3+6tzSTh3tO8xfTSomzmQRRp+qWKw7IOCDl9RyfheDs5OTW6gt5YqHwnS2EMkpF+d1nUsSW/o8ds=
X-Received: from pgct22.prod.google.com ([2002:a05:6a02:5296:b0:be5:9a9b:6b5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a0c:b0:35e:8b76:c960
 with SMTP id adf61e73a8af0-36618164868mr12418789637.48.1765305742416; Tue, 09
 Dec 2025 10:42:22 -0800 (PST)
Date: Tue, 9 Dec 2025 10:42:21 -0800
In-Reply-To: <fg5ipm56ejqp7p2j2lo5i5ouktzqggo3663eu4tna74u6paxpg@lque35ixlzje>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-5-yosry.ahmed@linux.dev> <aThN-xUbQeFSy_F7@google.com>
 <nyuyxccvnhscbo7qtlbsfl2fgxwood24nn4bvskhfqghgli3jo@xsv4zbdkolij>
 <aThp19OAXDoZlk3k@google.com> <fg5ipm56ejqp7p2j2lo5i5ouktzqggo3663eu4tna74u6paxpg@lque35ixlzje>
Message-ID: <aThtjYG3OZTtdwUA@google.com>
Subject: Re: [PATCH v2 04/13] KVM: nSVM: Fix consistency checks for NP_ENABLE
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> On Tue, Dec 09, 2025 at 10:26:31AM -0800, Sean Christopherson wrote:
> > On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> > > > > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > > > > index f6fb70ddf7272..3e805a43ffcdb 100644
> > > > > --- a/arch/x86/kvm/svm/svm.h
> > > > > +++ b/arch/x86/kvm/svm/svm.h
> > > > > @@ -552,7 +552,8 @@ static inline bool gif_set(struct vcpu_svm *svm)
> > > > >  
> > > > >  static inline bool nested_npt_enabled(struct vcpu_svm *svm)
> > > > >  {
> > > > > -	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> > > > > +	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_NPT) &&
> > > > > +		svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> > > > 
> > > > I would rather rely on Kevin's patch to clear unsupported features.
> > > 
> > > Not sure how Kevin's patch is relevant here, could you please clarify?
> > 
> > Doh, Kevin's patch only touches intercepts.  What I was trying to say is that I
> > would rather sanitize the snapshot (the approach Kevin's patch takes with the
> > intercepts), as opposed to guarding the accessor.  That way we can't have bugs
> > where KVM checks svm->nested.ctl.nested_ctl directly and bypasses the caps check.
> 
> I see, so clear SVM_NESTED_CTL_NP_ENABLE in
> __nested_copy_vmcb_control_to_cache() instead.
> 
> If I drop the guest_cpu_cap_has() check here I will want to leave a
> comment so that it's obvious to readers that SVM_NESTED_CTL_NP_ENABLE is
> sanitized elsewhere if the guest cannot use NPTs. Alternatively, I can
> just keep the guest_cpu_cap_has() check as documentation and a second
> line of defense.
> 
> Any preferences?

Honestly, do nothing.  I want to solidify sanitizing the cache as standard behavior,
at which point adding a comment implies that nested_npt_enabled() is somehow special,
i.e. that it _doesn't_ follow the standard.

