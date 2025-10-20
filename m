Return-Path: <kvm+bounces-60552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D5C09BF2722
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 18:33:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4CFB74E1D95
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 16:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D33F928D830;
	Mon, 20 Oct 2025 16:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O08gzrWL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1878F28C009
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 16:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760977971; cv=none; b=DjTq/iiNDrJ77jpsrj37075JlbnmX7DQJ4rKgJ8fE2F+04fFSwu1m9sbS2DMWjHK1M+xVpp9kv2+1WWizGjzLz+EFSR/1028eu6Uy2XpoytAZ73Ry+4LGiwGq5Vp6idhO4sXrdokOlDx+RYlAnvKPRnnhG4TJjt89nkoR7Rt/r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760977971; c=relaxed/simple;
	bh=kHu/zwUbCrQZ2tme86OxuUxLlfikNWjv8AaS4WsjHQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sEYU8qTdkXaSzbnf/OiBETyPWPoH4cHH2zOAybpVK6FUI0RWUJL/5D695tZRXaycPOlKTWRuG7JB+L4uWSHEzJ0xUprcCCXDSldmNf4hTAfKkh9DZLyYyEE+XT80R3NyQQIdsv45bpOvTOI0cGRBVWAH88mpq1kBZQ5KKdxc6NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O08gzrWL; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-28973df6a90so44942045ad.2
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 09:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760977969; x=1761582769; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Diz1lCzHvuhLNBvdbjp3hmbn87n7UqeGb+eLzgGMNx0=;
        b=O08gzrWLfmGPK/lAeZ3guB94XFV3FO5ZHTPXFTZmfk4BijFb5i2+tsWEmscjVnXzPM
         36nR1W0u3qA1Ld4xPzSjSYHrk5rlJcefT3W9NnkNqiTlVALJX1GKpD/1zABOCb5q+Z+l
         h1JpJeqYr3LHICWNBKwTRJYBPL/kKGocKpAdPeIFJeSCpSk1z/qcLO7MZu7n7oUp6Xd3
         J95ng2iRGpggiyj/Xlomwd0UrO7IOVSQUXUQQcv11+5ZNqKwriGPxgNBY53sZDUCVp4+
         MP7QqxbieJw1lnf6KfJ4nLWpfFYyyG+xDGpruPAoKbwKv4RnX/gGYO/LD4Nn9SicvYW2
         tNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760977969; x=1761582769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Diz1lCzHvuhLNBvdbjp3hmbn87n7UqeGb+eLzgGMNx0=;
        b=G1Ebm66EbeMNjk6IHAJVvScm6cdVOe6cwRxF3Ru9dCECiH/OoGn0iMzgLw0JUvvkkH
         8Le41/0LfuNOnQNojfXYHzrNMdbgnme3beXh7b6lErnHo00Ff3pM+imsBbdUk3nGzNrq
         vTAvBmoVjgo/xrVux/z8A0oYKfGg8Pgwcm4yawC36hkXUT0v/dGM58t1gAQ0fSi2vZZJ
         IcMiEcn3Dw8tKR3cBTblYlOnroJnSxT++Lf/cMSeWN+fxaJDnMxGo2nhaKGsybnsliW+
         Ivi+usbIiNl3xBFsUM9jSqSS/pkcDgMBArfKaKd8y0uI/cWqXcHAfHMn2BVn4H6ehP4M
         sNEQ==
X-Gm-Message-State: AOJu0YyZq7ezbDgDBqeFF5pyUFEyj5C3N2YJ+gLQpTgbkXq04QLOMxDh
	gp4IGJhf5IlAoPGLgPPLk9n08vXAKZE8qbGG/Kj3237KbVrNklejpIJRNcvLBw8ECm25v9BbZau
	r0mx+5g==
X-Google-Smtp-Source: AGHT+IEBssmEK7IRnbhmUgh1LvtwLWzxveFfoJwgyr9fXBCvprfyt2fJMMmtuyxeI3YpRV0rM/SKweh7WoY=
X-Received: from pjww4.prod.google.com ([2002:a17:90b:58a4:b0:33b:c327:1273])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f543:b0:24c:965a:f97e
 with SMTP id d9443c01a7336-290c9cf2e68mr182575675ad.2.1760977969344; Mon, 20
 Oct 2025 09:32:49 -0700 (PDT)
Date: Mon, 20 Oct 2025 09:32:47 -0700
In-Reply-To: <176055119471.1528900.16047808072294975428.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007-b4-kvm-mmu-stresstest-1proc-v1-1-8c95aa0e30b6@google.com>
 <176055119471.1528900.16047808072294975428.b4-ty@google.com>
Message-ID: <aPZkLykr3L_cBeqN@google.com>
Subject: Re: [PATCH] KVM: selftests: Don't fall over when only one CPU
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 15, 2025, Sean Christopherson wrote:
> On Tue, 07 Oct 2025 19:12:31 +0000, Brendan Jackman wrote:
> > Running this test on a system with only one CPU is not a recipe for
> > success. However, there's no clear-cut reason why it absolutely
> > shouldn't work, so the test shouldn't completely reject such a platform.
> > 
> > At present, the *3/4 calculation will return zero on these platforms and
> > the test fails. So, instead just skip that calculation.
> > 
> > [...]
> 
> Applied to kvm-x86 selftests, thanks!
> 
> [1/1] KVM: selftests: Don't fall over when only one CPU
>       https://github.com/kvm-x86/linux/commit/98dea1b75186

FYI, I rebased this onto 6.18-rc2 so that I could apply selftests changes that
conflicted with fixes that went into -rc2 (yet another lesson learned about the
dangers of using -rc1 as a base).  New hash:

[1/1] KVM: selftests: Don't fall over in mmu_stress_test when only one CPU is present
      https://github.com/kvm-x86/linux/commit/b146b289f759

