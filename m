Return-Path: <kvm+bounces-30297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C890F9B8EA1
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 11:07:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBD551C20DC2
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 10:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728D017108A;
	Fri,  1 Nov 2024 10:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GdOaMJ5L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57DE165EFA
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 10:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730455631; cv=none; b=YEj87urJvGvqzVb9DJBej25QT+4+CVbrURQkKRtNcIX+DtkVi/dTQmPDJ+gjaCjyDyi7Zm24tB7bXHU5hjI/1MNZmiMpapd0g8s7MthaQoKeo1lf8AxWzmbwa9+R3I+m+O/dwZ5rceBr0XVVPyf//WM2JLQLqjjPbrC1fWStgvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730455631; c=relaxed/simple;
	bh=Qjn63ek4WImsoAqV+BDmfS1xuW6xzS9m5vZvn7z3SqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y6+3FT5Dzh8dpKU4tDi7c5HAC826pRgOmvGdiKIzrszFl9ALaf1mw8ooEuEDFte73ssD4S28ZPN6S9R0ugZpbuP5Ws0wYU/9IIEIkHn3BeDGfw4kbQva1r6HNJpEmluMATSF2zyGtA3e7CWOThCfr5cwXXChMslCewSxqNBzYMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GdOaMJ5L; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a4e4776f79so175465ab.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 03:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730455629; x=1731060429; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Qjn63ek4WImsoAqV+BDmfS1xuW6xzS9m5vZvn7z3SqM=;
        b=GdOaMJ5LUgp1mn5iuHOh5Te8KzyytLvyh33ZNFV6cflsDaRKa68wjS7nVTR6P7WYBi
         LRs2f/30UkYYxylgdCBSMFPLR+qaCOvgSFEjvzWmIlkt5f5zhPykSG4qhkw8KyF1VX+D
         QgFDutS7K8KTLNBLTVqOx2IqtlDb1qrmb8TaYX/6vHAnL8Fb5BvCp7jwqO21dzAZ1NCm
         HNFwY/At/dYbn78fx4Lwzz6jSrgChlGOykAcw4bgRjSYZ2KFLjk/s7dMjYCzzSk6BdUF
         t9TuOab/JpM6PFkO2ft+UWO1vzDDnBKcb4Hwb6W6uo52lXYXIsPMwy4q70Hngqnzgr4d
         ea9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730455629; x=1731060429;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qjn63ek4WImsoAqV+BDmfS1xuW6xzS9m5vZvn7z3SqM=;
        b=QJ5uIF7D7+PXCJk37gLJ/veMPVWsSJ9dSmhbIgm5t3WxigJTE9/DZN41g8AD1yFs74
         siv0/I3CQWO77OjiCw4y3ytB86glPxdTSzuW15GBl0jMaGE55PRnOwrxf95VfWd/eCm9
         o23yRw1uM5a38cmfA+EwAKzO+KJJcOkHC+nf6x/t0HbN+0EX0vHXbcvytRnbigE+wRF9
         z83q2a8dWSBb0J/U+NlYDAeov5dzZf6YH2h3pkENDWSQ+wPbL8aMT1BX5i38/Vmu1fiq
         m1IGFAAqnyTzBgIV+grjEqfqIsv8PfMVUhk3e3+aJM88+Myq1kAqVWKnPoiXlx9QXo7W
         JoXg==
X-Forwarded-Encrypted: i=1; AJvYcCUIKXYaJtEv2Yc9LREXW31MxT+rAe8lhhYUyFeVDHFzygyK4MDmLDRfHrZ+iT6r67f/Tk8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVPMA5Me3ySZMVYj97tNXiDjmHsFaInlKIg2vFYtO9eC8+gKWa
	/0vjNZfrDC3Cby0I0w3YLD6MkaSFS21FsoWE1XUuDeKckG3/NlTREJF89GfXtc548bMcssqXkEY
	ZJO8AQCHcADtWTrkhEUctHZBsteoiKlaWMsV0
X-Gm-Gg: ASbGncsx8RpNNmr1C64L9m9spEvj8kcUXKePxCEGE1uSUI28stc5FRLx4X/d+7A5LVU
	bQJJmkH870e717BWjvhdtsTQ9eslNdSt/yDzbIffgkhJSH3r+plldimmjPAu2
X-Google-Smtp-Source: AGHT+IE4pdolZqs/1Fb5VGhaHZXEPmot9uMPx/b9z9OT/5gEBhMY3DyJDsU3nlnPT5w485LLMMDaJtlZ55sPJ4zcwd0=
X-Received: by 2002:a05:6e02:152d:b0:3a6:af68:667e with SMTP id
 e9e14a558f8ab-3a6af686864mr4500845ab.28.1730455628625; Fri, 01 Nov 2024
 03:07:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
 <20240712-asi-rfc-24-v1-1-144b319a40d8@google.com> <20241025113455.GMZxuCX2Tzu8ulwN3o@fat_crate.local>
 <CA+i-1C3SZ4FEPJyvbrDfE-0nQtB_8L_H_i67dQb5yQ2t8KJF9Q@mail.gmail.com>
 <ab8ef5ef-f51c-4940-9094-28fbaa926d37@google.com> <878qu6205g.ffs@tglx> <d0a38982-b811-4429-8b89-81e5da3aaf72@google.com>
In-Reply-To: <d0a38982-b811-4429-8b89-81e5da3aaf72@google.com>
From: Brendan Jackman <jackmanb@google.com>
Date: Fri, 1 Nov 2024 11:06:57 +0100
Message-ID: <CA+i-1C0HKQS=SczTJEOsJLiUzhb60zAdi+27ey6VCLU5Ws9pfg@mail.gmail.com>
Subject: Re: [PATCH 01/26] mm: asi: Make some utility functions noinstr compatible
To: Junaid Shahid <junaids@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon <liran.alon@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Ofir Weisse <oweisse@google.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Patrick Bellasi <derkling@google.com>, KP Singh <kpsingh@google.com>, 
	Alexandra Sandulescu <aesa@google.com>, Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>, 
	x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 1 Nov 2024 at 02:44, Junaid Shahid <junaids@google.com> wrote:
> In any case, I guess we could just mark these functions as plain noinstr.

I wonder if it also would be worth having something like

/*
 * Inline this function so it can be called from noinstr,
 * but it wouldn't actually care itself about being instrumented.
 */
#define inline_for_noinstr __always_inline

Maybe there are already __always_inline functions this would apply to.
Then again, if you care about inlining them so much that you can't
just write "noinstr", then it's probably hot/small enough that
__always_inline would make sense regardless of noinstr.

Probably I'm over-thinking it at this point.

