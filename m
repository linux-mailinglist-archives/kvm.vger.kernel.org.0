Return-Path: <kvm+bounces-8041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8620B84A296
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 19:42:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B455E1C2172B
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 18:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56477482E6;
	Mon,  5 Feb 2024 18:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hj3NkIPf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331B4482C3
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 18:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707158558; cv=none; b=DIsivY1G/K0FQPH7zzmObq1phs8hNKc+y8qGr15P5acd+Wy74vF9um1mqPjFjMKhZ1Px+thzbMfWTVOON3CddWfczPmq5NNaCTwE71F7cwpHiR6xzWhTzHIcXk98fn5UKtKjY349ucHsYXf99Fqz+XDOCb3eEYIvcqN5FTqjwqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707158558; c=relaxed/simple;
	bh=hsXDem8Y3M+oohOGRny116A3kDHq1d9RWZGu1I/7riU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l7m6KgrWglra74koZicSHDsmxRGr3owht+gchAtGAbHf2Z6ZlTJiDJ7Ha6eynQTP/xrgvvp9B4yyCfZNG9dYbF/nWBZ9uBUABphmUHqkjZBP3kVKyo1QESnlKaRJuFJQOXRkAJKjHqCddrvBbMFJeEekKjfGejCFmRPlT9Hlne8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hj3NkIPf; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8bff2b792so5369006a12.1
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 10:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707158556; x=1707763356; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=23qGvins0n0Yw3cJLuu5spy2O2ZYqvAvIIW3CPOzeBQ=;
        b=Hj3NkIPfs5sJKz/7oi2aN4qnzHYZs+SNaPjVWAsQACsqvvv2TOIzK68QNlDnqSUZel
         GfVwxpEj/RRmy9QZqEMDpqaBSHsbfMUVFEPht3jgzWbJ7Pm85i9GjX0mnrTYSRsDjezA
         oW5OLSJtSgQ9avJi05QskKWejDdx3XBwCoSqF4cico1EqQMZfckmNe5ItdEq3PpbMqWp
         34ulMIYJgzqrIt61MXcJpEiI7NY5okWQYUYBadIuFEoPqpqEuw3q+OCu/0G3JHbAvqE0
         mHy49HhR0/L3fyQ6hrraEY6U6swKQYM/yOl4+mGLyHq+aLop+gYrmVnkJLEEfaJqRMHq
         2S6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707158556; x=1707763356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=23qGvins0n0Yw3cJLuu5spy2O2ZYqvAvIIW3CPOzeBQ=;
        b=dMODgbBJohzDtXXnWRrAWwd33CS9y1sueCHdD3r/gcYDfdIDo0bcn6o0Njk7PSNWyp
         85EDPlX/kbYcTZvB3Jm04EJ4Y7AG7LF5MOclUHCBgNRMbacwO8QkEBYPSzKmCdubA1bN
         W0OZ2UIXNOkpzHZHz7J7ih9dtwlZLpGaMOWE46kbaLDYyNq24rsCay6tR+7knpYzwLRt
         KoWu3mDNxwflnLh7jxI7eGPqi2+N3sbdFnXpoMr0NPr+44mriie4I4My88rX7ilr5u/m
         b16LR4L3DDNaUAP1vETYikWyZnqAUocKGmhjByrYngdlVmtKkjCic+dRRSD16a5Hx1CF
         VxPw==
X-Gm-Message-State: AOJu0YzKmlgGBqcV0W5rXwig/W0CSZ4zgpUJK7eLUidp5FphzJRb/4fh
	Gxv891/pjddX2lGivmlqAa8SUH1gI/DF+iX9njZeKwF6hR5FSfYcl2Kvvo14cxLmfwELO/FfLs/
	HWg==
X-Google-Smtp-Source: AGHT+IG17AZq289xK7R9TRTi9fID3woYoGycDrkeDwDYOaawbTWAzSKJ1eiBYtTGQkiq5ZC5hRltz8MhMvw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6bcc:0:b0:5dc:1099:9585 with SMTP id
 e12-20020a656bcc000000b005dc10999585mr29137pgw.2.1707158556530; Mon, 05 Feb
 2024 10:42:36 -0800 (PST)
Date: Mon, 5 Feb 2024 10:42:35 -0800
In-Reply-To: <20240203124522.592778-2-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203124522.592778-1-minipli@grsecurity.net> <20240203124522.592778-2-minipli@grsecurity.net>
Message-ID: <ZcEsG8ohXfgcYvB0@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Fix KVM_GET_MSRS stack info leak
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Feb 03, 2024, Mathias Krause wrote:
> Commit 6abe9c1386e5 ("KVM: X86: Move ignore_msrs handling upper the
> stack") changed the 'ignore_msrs' handling, including sanitizing return
> values to the caller. This was fine until commit 12bc2132b15e ("KVM:
> X86: Do the same ignore_msrs check for feature msrs") which allowed
> non-existing feature MSRs to be ignored, i.e. to not generate an error
> on the ioctl() level. It even tried to preserve the sanitization of the
> return value. However, the logic is flawed, as '*data' will be
> overwritten again with the uninitialized stack value of msr.data.

Ugh, what a terrible commit.  This makes no sense:

    Logically the ignore_msrs and report_ignored_msrs should also apply to feature
    MSRs.  Add them in.

The whole point of ignore_msrs was so that KVM could run _guest_ code that isn't
aware it's running in a VM, and so attempts to access MSRs that the _guest_ thinks
are always available.

The feature MSRs API is used only by userspace which obviously should know that
it's dealing with KVM.  Ignoring bad access from the host is just asinine.

At this point, it's not worth trying to revert that commit, but oof.

> Fix this by simplifying the logic and always initializing msr.data,
> vanishing the need for an additional error exit path.

Out of curiosity, was this found by inspection, or by some other means?  I'm quite
surprised none of the sanitizers stumbled across this.

> Fixes: 12bc2132b15e ("KVM: X86: Do the same ignore_msrs check for feature msrs")

I'll apply this for 6.8.  I think I'll also throw together a follow-up series to
clean up some of this mess.  There's no good reason this code has to be so grossly
fragile.

