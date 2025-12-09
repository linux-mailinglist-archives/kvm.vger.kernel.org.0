Return-Path: <kvm+bounces-65584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4F9CB0D71
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 19:28:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 721AD3046EDF
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 18:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1BDA2FFDFF;
	Tue,  9 Dec 2025 18:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hH2Fyrz5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3792E7653
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765304795; cv=none; b=HYlGp6EoIk+XhTXGuwiiH78edQMnfA3u7YoEyB5dftNXp9zmv7N1Dcrhl3VwzOC0Edt6m5wmtruEItUDsSnelMpNVJHfFNEI8OCH971uNYIapw4Fn11MJ1EP33dquWNMaCkjc443PW0l9QLYOvzUZIn5qK/Ncxs3JG75uPwztzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765304795; c=relaxed/simple;
	bh=nl3prqAPdUFLhr/YxSYqMVw69tQOJIma2pVVbrbh130=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XnaFoN6etjITdnG55XFNj/Xk66rGc6DR+UkA3idqWmbxuvmxCR1Q/N/jEbke71ttYGn34n9P7nG0+o1K2WRfQhrXhkPnC1kPKmETWrPl++esnX3hrStCeC/qpKwmSKM9H9hbbWptu238ose2b0cD0GPksZs008o2o7BR+zlghKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hH2Fyrz5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3436d81a532so10676200a91.3
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 10:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765304793; x=1765909593; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=chxjnCbu+CsaovuIX/QetPvLM5FaBl5fhlMK8A/Bgj8=;
        b=hH2Fyrz5z+s/kERuijL2B+DrQNFFRL+XPHrzTUkpEfHW16VsEdFFfgAo1k9QVx/XBc
         r6F9jLZ0lqxEc4za6v7f++A2Bpvo+kZUQ+p5WdwXv+4TBrPchdyaPp+knG74qV6no3O1
         xWrwq+zbzIqTsbZafB9OGw9BfQiRjIKABpnTS7UfhHkaTjKQRE0kejS1mJLdchRFoCpV
         IddUT0NjW0+biGt1gbTE32jVwuOJJ+HDXaTX/xRbFQGIYb4dh1v+8VqBftJ68dsGrbSg
         ZjFd1XFAheBgdapX9RVfGVNpnJ1YIi+wOnqcopePZC+kiJMUhqDJNAoPGu/IXoD76xa/
         uZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765304793; x=1765909593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=chxjnCbu+CsaovuIX/QetPvLM5FaBl5fhlMK8A/Bgj8=;
        b=qclzApj18XnV/viVXBz+qQ6x52xEPJdjl7kZyEYY/ETH3loeNX+Ljmu5l75FwU+Zs7
         ZpFBX5hwHdkBE0DXaQO81JPhbL61G2TJckDc5EIoUej/DcqiRZQO3we9jYkN+/Obz28d
         UxjkoYsO82GNIOMzTs8SuHCP4B6MYwX5AJy8yQGCSTXczN2l3BdU44E74AujNjyy1/Qz
         YVLdgl8zWOzPUo3wS/OIS2S5pWTrtE6pKjJMb28vuiMBOa6stgXsqseKYAvYlHlGSG6a
         7w31s5PsHbj0x3IZ783h3ebc/a4RWvVqRc8vxtdEPa0gCAnecNU0VBusKaIBB4ga71f5
         GAvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWk5pJoYJ35CsVP3XGjuFaW9D2FKaXMObXGeLV6r1rNf0saLAJ6TRCECUlDN9BnBgpgyDg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNn91wQhU8WyDWwHfFeE4cZm0VTxSAlLAJRmjhBeHiqHrbi+JS
	yg6PAPPOKlbJLdDFAKZvH9fXgvLEkDJprNJS0FNk6cFUHzWZFP7y7Ml3ulpHW7dhlNOlYMKlCZ9
	f0zEkYw==
X-Google-Smtp-Source: AGHT+IF9g3LPB+mmZ2YRjktllEedA1cuQ/18L7dOKJUqmYm9rjvLuinrRy1wx3pD8/5+tBZORwXl/VRl79k=
X-Received: from pjsa5.prod.google.com ([2002:a17:90a:be05:b0:33b:bb95:de6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d92:b0:33b:d74b:179
 with SMTP id 98e67ed59e1d1-349a25cee1emr8372293a91.27.1765304792940; Tue, 09
 Dec 2025 10:26:32 -0800 (PST)
Date: Tue, 9 Dec 2025 10:26:31 -0800
In-Reply-To: <nyuyxccvnhscbo7qtlbsfl2fgxwood24nn4bvskhfqghgli3jo@xsv4zbdkolij>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-5-yosry.ahmed@linux.dev> <aThN-xUbQeFSy_F7@google.com> <nyuyxccvnhscbo7qtlbsfl2fgxwood24nn4bvskhfqghgli3jo@xsv4zbdkolij>
Message-ID: <aThp19OAXDoZlk3k@google.com>
Subject: Re: [PATCH v2 04/13] KVM: nSVM: Fix consistency checks for NP_ENABLE
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> On Tue, Dec 09, 2025 at 08:27:39AM -0800, Sean Christopherson wrote:
> > On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > > @@ -400,7 +405,12 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
> > >  	struct vcpu_svm *svm = to_svm(vcpu);
> > >  	struct vmcb_ctrl_area_cached *ctl = &svm->nested.ctl;
> > >  
> > > -	return __nested_vmcb_check_controls(vcpu, ctl);
> > > +	/*
> > > +	 * Make sure we did not enter guest mode yet, in which case
> > 
> > No pronouns.
> 
> I thought that rule was for commit logs. 

In KVM x86, it's a rule everywhere.  Pronouns often add ambiguity, and it's much
easier to have a hard "no pronouns" rule than to try and enforce an inherently
subjective "is this ambiguous or not" rule.

> There are plenty of 'we's in the KVM x86 code (and all x86 code for that
> matter) :P

Ya, KVM is an 18+ year old code base.  There's also a ton of bare "unsigned" usage,
and other things that are frowned upon and/or flagged by checkpatch.  I'm all for
cleaning things up when touching the code, but I'm staunchly against "tree"-wide
cleanups just to make checkpatch happy, and so there's quite a few historical
violations of the current "rules".

> > > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > > index f6fb70ddf7272..3e805a43ffcdb 100644
> > > --- a/arch/x86/kvm/svm/svm.h
> > > +++ b/arch/x86/kvm/svm/svm.h
> > > @@ -552,7 +552,8 @@ static inline bool gif_set(struct vcpu_svm *svm)
> > >  
> > >  static inline bool nested_npt_enabled(struct vcpu_svm *svm)
> > >  {
> > > -	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> > > +	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_NPT) &&
> > > +		svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> > 
> > I would rather rely on Kevin's patch to clear unsupported features.
> 
> Not sure how Kevin's patch is relevant here, could you please clarify?

Doh, Kevin's patch only touches intercepts.  What I was trying to say is that I
would rather sanitize the snapshot (the approach Kevin's patch takes with the
intercepts), as opposed to guarding the accessor.  That way we can't have bugs
where KVM checks svm->nested.ctl.nested_ctl directly and bypasses the caps check.

