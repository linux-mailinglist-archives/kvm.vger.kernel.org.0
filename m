Return-Path: <kvm+bounces-7886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB0EA847DA3
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:14:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 604FAB21DE9
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC1A63AE;
	Sat,  3 Feb 2024 00:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ua01M4jw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD884697
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706919127; cv=none; b=mdBEA5OakOQbIsPUSgQOZTN76r1xYmWWbgLnY4AMgbdEQcvyr/3hNjE2oB2hqdE3ReBMAiy91IYnX4MYSHNl5hVcUYPFfVZ+EUF3Pt47USEPkzzKqDcirOdBsifelHU6okJAZ/E3Xn5PfS48zlqhRWRQ2W4SbxEkyiQ5raUiOho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706919127; c=relaxed/simple;
	bh=Q1o0DofRcMLTLWDBsn9giV1FxN9HMwZqB6JfLff9xJw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WYZ4rl4Ck9BIxra/V4gCkLN6DhNSEsVgw9hL1QDgYNy81O7UAWZV3Nw5LRC7XMs94ZWmWcAeUBjV733Vwx75eNnXPoSf6shTuHbJzKfJm32e+B6PduxOJe+wMpWMrG/TQbXnHinxrCDEpxw40829Yw52ggUfHFcV2FHcpAzyeaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ua01M4jw; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ddc2aefbe4so2648218b3a.0
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706919125; x=1707523925; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CXBUPXpWgAm5r1Pnwblz/7nmofC0KqBjONaFx44tX7w=;
        b=ua01M4jwGIW06XAqfJ55qP01Y0fI+E4x+oVxmSkh+0wX8EL3Qr3iQNOvKxaSPwGu+C
         AW7a5nGXh1s77c5p18hIwh1i5biLUmAWZ4FTU10p5BP97XHQgZg5aAKHxLnASFUCJd81
         wDX3rePJRwQ81EloYsTWIHPACum+u+d2Qi85V0ukxUiXq5WnTOJqr7UxCONVA571eUTw
         mzxwx+XGrtmQKMpkFe1m1L3t9TKTm1WG07qltU0/Mo9W6NybiTwe5loiM2kSg5nllzw0
         rCoq06LLuEpIYAfnXTK1PqOdWrTTttFlZTmmM83FdZ2pMBp9NjzHX/+06r89nmeGakYc
         iw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706919125; x=1707523925;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CXBUPXpWgAm5r1Pnwblz/7nmofC0KqBjONaFx44tX7w=;
        b=cw4baEjlIQOVQGYvJkZ9OkjWKUJ9lmgEKAw4/WWHUb5qwbKC0Kxt+JCw2GnFoHOglz
         W/VBn0ZotqS70tMsaHMwOwoMFSCKMw7ciStmGONNZ9B+n7vrIvAKfbXCl1WfJrMjwnku
         Qa5kxgG28YPteMI6BkTtyhv2YqgA6/jZsyhuFWCNbqHPGsn8UZnKINdBpU2WV0zsDLFN
         oeHCixm5Uw28H/bOdnxhWoCAVa5/RkXVpgTMgP11SeCO5ECYH147WugJSfN007kaFMiX
         8SMN5mzV6wCeRtG0wQLX/qW9Dj+l2qV+nDRZ92tngltHnh/YmMGR4v8piQ38sgik/Oyd
         au3g==
X-Gm-Message-State: AOJu0YwPOA/qIXw0Db5sPZiU+MY1fOdJJ5DzftC53I6zNewylaeyRF5B
	i2e/ysAVCwyvTe5ZxrhBjuVoQ4N7gBjmtefpHiU1dC43lTgBh9Vu66ohzD3oUmO3Pgs7sERKqw/
	39A==
X-Google-Smtp-Source: AGHT+IErdY/aHbCZMaGScpUo+KPbsMLgvZWLiqTFMDl9S8nTCSiyYvbbxCi7nFL9smHWAhbI9VH2yM8yCtU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1744:b0:6e0:2755:e56 with SMTP id
 j4-20020a056a00174400b006e027550e56mr19680pfc.3.1706919125499; Fri, 02 Feb
 2024 16:12:05 -0800 (PST)
Date: Fri,  2 Feb 2024 16:11:29 -0800
In-Reply-To: <20240123221220.3911317-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240123221220.3911317-1-mizhang@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <170691180776.332020.3187581586977661860.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Fix type length error when reading pmu->fixed_ctr_ctrl
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Mingwei Zhang <mizhang@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 23 Jan 2024 22:12:20 +0000, Mingwei Zhang wrote:
> Fix type length error since pmu->fixed_ctr_ctrl is u64 but the local
> variable old_fixed_ctr_ctrl is u8. Truncating the value leads to
> information loss at runtime. This leads to incorrect value in old_ctrl
> retrieved from each field of old_fixed_ctr_ctrl and causes incorrect code
> execution within the for loop of reprogram_fixed_counters(). So fix this
> type to u64.
> 
> [...]

Applied to kvm-x86 fixes.  I'll let it stew in -next for a few days before
sending a pull request to Paolo.  Thanks!

[1/1] KVM: x86/pmu: Fix type length error when reading pmu->fixed_ctr_ctrl
      https://github.com/kvm-x86/linux/commit/05519c86d699

--
https://github.com/kvm-x86/linux/tree/next

