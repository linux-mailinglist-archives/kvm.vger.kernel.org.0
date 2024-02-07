Return-Path: <kvm+bounces-8189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34CF184C2FC
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 04:18:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 600F01C2191D
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 03:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F132910949;
	Wed,  7 Feb 2024 03:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D/+k48pg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA17FC0E
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 03:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707275879; cv=none; b=sItX17THT83T/JgxjUgLWkMcN25/jfAFpUftNGrQ8/OD2BEPsRUi9smH4TwUecsqf76xvafppVSX4hFO7wFnVnkYTtKeNxEZz7mtunqeMKFSakyQVOsY9AItHSdXsVSQvrTzw9FTnH+j9yv/kLahwYXyVigY4d5V97QFB6r1E0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707275879; c=relaxed/simple;
	bh=xv4B1LEIU4KOtG2Ub7BjbYH4Tj88+0kJFfUuhhkXn10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZVPKb5m4ubYZv4yghUxV3D/m3xiXp8yuuvKOZltD79HPCT++/Sz4bYTbgOt2Lr780XeNuKM3bmAUKfha94AB02KPxnw7k0fkoTqoSf8rPlAht7gAe7X3egBG+lGuWUNa7DuedBjYGdJ5JbXXbvDH3B6cGdzgbu62vT3OGLgqVfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D/+k48pg; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6e6bc4aa3so213721276.0
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 19:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707275876; x=1707880676; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c4CjCucqTLIudtP5PVERixa/oHt8DzPccdaWLPRE6E0=;
        b=D/+k48pg4+cPb4R97X9AG8UgLKAiJ34XAIe4MLydGty8u8Y8skBBgydIYZ+3EpySDH
         uVJcq703Ljn5fui46gS6pzdOwwhhFsd4XQl0t2bYvK65VlOaAItTIMH7M5oVsu3iv7Tc
         0cN+/fmbt74DmVaG57gGZ28NNqhKdaHEoiv0lny2QBO9BWg8FhDaHTQp/TISI0pDJpP/
         S0BrPTA1cKugS4Z/j/0TQyFW2ayEE4JNZXGSps0yotn8Sn7xSJ2eS4pT5V4Z9ydPSne1
         hKcX+XQz/zYfLwJuOINqz8PvAm9LJILYPReuXxNFO3LQ4NCBeQnMnCwwxTaUU4VCNkaK
         XXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707275876; x=1707880676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c4CjCucqTLIudtP5PVERixa/oHt8DzPccdaWLPRE6E0=;
        b=r2ztk1LT2FaDz4DEmvhpPgKtDsaWbYaGeLvpLCvPtR9qkqiftDqO8nj3HxJEVLl0Zk
         WoAyxP/07y4iDevHuIoluwt9KlcUYEREQVSPn6W+8hKpZlUXfWQIT4j3y4B2hQ1ZIAXH
         O8VRjF3iEyqe+nxHxOP/AmwjJEvmlMvcHvk3On1LoNWZMQLMpNSkDcNgJAgmDqRw+aJt
         Hn4X71MtDfxkfuZx8/sz/mwJcteAUryXLBTC4UpwKENAK/pWFnRzEvmzwLgtE06S5oV8
         qQitIsBT6Rvc2n707QFrbtHw3+6GujITZ1wNZL1zIoDRW76AvgtemFb2ikcjfsyoI2Q6
         Pm/A==
X-Forwarded-Encrypted: i=1; AJvYcCVpjPU+VDzJQ7urQcdCCjthvH95WoMMh0ykxqVFheuppu+Cll2mPdDltU1Hxiyz8lu8p3NmHc1Ql+oTeEdFyVRMuAEE
X-Gm-Message-State: AOJu0Yw9LPEfT9fo0eV5c0UVk5A3uT8QnZtcaTKERxxm5jb3QgGbMYIG
	OtVKuZCrcj6qOhpgWbaEqCUMn/zZVAZjAmMWQJDBLkLNhv5FChiIqtKtPcLoTaqhthxXtPoJspN
	oLg==
X-Google-Smtp-Source: AGHT+IEDt9S4Bp3akJ9/asxSh8xQpB7ev1QayNj+tDmZqMrZWt3F4FRrmzgPTDDZ2QioeOUf8ryjx+YClGg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:e01:b0:dc6:b768:2994 with SMTP id
 df1-20020a0569020e0100b00dc6b7682994mr152301ybb.0.1707275876698; Tue, 06 Feb
 2024 19:17:56 -0800 (PST)
Date: Tue, 6 Feb 2024 19:17:55 -0800
In-Reply-To: <20240115125707.1183-4-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240115125707.1183-1-paul@xen.org> <20240115125707.1183-4-paul@xen.org>
Message-ID: <ZcL2Y1gpRG8C1_8f@google.com>
Subject: Re: [PATCH v12 03/20] KVM: xen: mark guest pages dirty with the
 pfncache lock held
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <paul@xen.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Shuah Khan <shuah@kernel.org>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

KVM: x86/xen: for the scope please.  A few commits have "KVM: xen:", but "x86/xen"
is the overwhelming favorite.

