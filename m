Return-Path: <kvm+bounces-30372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99EE49B989A
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC1811C21D5F
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE111D0F50;
	Fri,  1 Nov 2024 19:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z+chgdOb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDD91D0483
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 19:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730489327; cv=none; b=Iy2TmXK+QcVxwxm/tXLCTEMvTRRXNYi058OL5OQgoxCbMmQrWdaNqguCmV3Y3DT/uPJl9ZMiGls7lRl6wMZUtNnEYWFl/FLjR26xib78AeI0dwPRAilWfjpK9K2lJ6/kJDDlIB8dNrK54CkyH1VUI8t5IYVomqD5HAjr4MoAR9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730489327; c=relaxed/simple;
	bh=QYMoFeTxUGOO5P9zHc1Yw6Ch3laB+TBFlt2b43Fl9Xc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SztfK8e7hbsdy5zycdXEitO84NBiL849QpjKGblXOL2ghxZH/R//PEt0Zp94KO12G7WdhBbI/hkN8/tiK5oPd8Y+lqAfnXFYjZIVwQT5PR/fYQhFOo/b4C0IEGGxgBFxIIlruTmiaXudrK0JmNP069YaHXaqd+M6GBGOP0IXAgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z+chgdOb; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e3c638cc27so47606457b3.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 12:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730489324; x=1731094124; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UHqjs2CWPbla3bx78NBZn/Aq6Iz5K05gv+DiEMvLcXA=;
        b=z+chgdObFGSiyAeJCwpjFqGYq4k0Ud+Riu0v8H7Im5pHqQyPCSq8Y0Us1zNoEPj0Oq
         lvrMcmUy2sJ/AnWVgb93a1XvQp2OdNXox3Gd6n05X9tfJ2JMg3trpmJ2H4cz/MN6rmhD
         10OJEhNh6pSk4CeEVf7voO1AOL6gZOEzqN4L8BzC8IOM+3NEyoUV/r/dkvjUKsmG1+Wp
         bBwQxhiE4bewc80aYqGZ0uJ7e5oI7KA1ogoDgaQoZhjBuPA/NisPyGHQQcJR62h1Lv7r
         s/+8Cl1RE5qv4V/fT12pJFhZ0YKkqil+Mi6E6/nho3SiC7hKXL5LdI8rf4aeElyVg69N
         LGzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730489324; x=1731094124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UHqjs2CWPbla3bx78NBZn/Aq6Iz5K05gv+DiEMvLcXA=;
        b=mC4RyfjCuejzFUYAuh8ncR4/Z8x7VmK8D8rayPWwGcbe9H0OeJS4ZN4sHXVeTjj2Lp
         9V49Rn8qfq3uQutb52DHZdnGWSabteAbNXx6c1MD4V6eT9ITA0QW8EDzEmCqC6R2a7lu
         3pZj77NNOZfEpH2Ttq97cZJ6IF2aH7KJ9bf9kGHPIBvkRBOqkka4F+FxXrmnFXyyYRCp
         bQVrTBnKlShFgYu3SX2YCFbhw18J3u6wOyF0TGePRT2vafrzh462RFt5Auldena7JDQL
         qrAxln4SlCnSyKl82i0mks6XFcmsQOoKr7jHnXFnrfE3THymjPvdOcqF7Yl+ciCtL7x/
         2FMA==
X-Gm-Message-State: AOJu0YzBIIjqqjnVUSjfbzeS+E67xbAUWeClIgJCT1zbGvRpFy8rQ+mo
	uDbLuOFUji2fVqIyKMbHf22vgbJEvWZpF47VssX0TtPLwCt9uX8GmWVsS+xfVwRzvkgFXlFeo08
	5HQ==
X-Google-Smtp-Source: AGHT+IF8HLLTOuTCNq7vh6SdOkqFvsj1dyHQ1QM611ov8SmP4NWwxRqDVQZ0yGsjshQGf+9BUmJlS42aWrY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:11:b0:6ea:6872:2fe6 with SMTP id
 00721157ae682-6ea68723031mr479037b3.4.1730489324538; Fri, 01 Nov 2024
 12:28:44 -0700 (PDT)
Date: Fri, 1 Nov 2024 12:28:43 -0700
In-Reply-To: <ZyT7uDqK29J46a0P@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011214353.1625057-1-jmattson@google.com> <173039500211.1507616.16831780895322741303.b4-ty@google.com>
 <20241101153857.GAZyT2EdLXKs7ZmDFx@fat_crate.local> <ZyT7uDqK29J46a0P@google.com>
Message-ID: <ZyUr64wRvSbSB378@google.com>
Subject: Re: [PATCH v5 0/4] Distinguish between variants of IBPB
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, dave.hansen@linux.intel.com, 
	hpa@zytor.com, jpoimboe@kernel.org, kai.huang@intel.com, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pawan.kumar.gupta@linux.intel.com, pbonzini@redhat.com, sandipan.das@amd.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 01, 2024, Sean Christopherson wrote:
> On Fri, Nov 01, 2024, Borislav Petkov wrote:
> > On Thu, Oct 31, 2024 at 12:51:33PM -0700, Sean Christopherson wrote:
> > > [1/4] x86/cpufeatures: Clarify semantics of X86_FEATURE_IBPB
> > >       https://github.com/kvm-x86/linux/commit/43801a0dbb38
> > > [2/4] x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
> > >       https://github.com/kvm-x86/linux/commit/99d252e3ae3e
> > 
> > ff898623af2e ("x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET")
> 
> Doh.  I think I'll rebase the entire misc branch onto rc5, realistically the only
> downside is having to send updates for all of the hashes.
> 
> Thanks for catching this!

New hashes after the rebase:

[3/4] KVM: x86: Advertise AMD_IBPB_RET to userspace
      https://github.com/kvm-x86/linux/commit/71dd5d5300d2
[4/4] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
      https://github.com/kvm-x86/linux/commit/de572491a975

