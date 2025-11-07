Return-Path: <kvm+bounces-62351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0427C4163D
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 20:08:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CB89188ED2C
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 19:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF5C2D6638;
	Fri,  7 Nov 2025 19:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="azlffg9Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D499526CE3F
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 19:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762542519; cv=none; b=YDMuVQnwKF+yDyTn8J+fwBOdQb8M3YZGakWSTJ4y2G546e1exsqUVvMcCbl/5dv9sfssOhfm4aLhS4uBvEUWTjKyzSEUufS4q0XBe9fMhu36Alhn7Reeh1eU3SJ70PhBpzHc+sljhDix7EhE5vp6t9mzTX7r2sPPXrxDkxzmzLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762542519; c=relaxed/simple;
	bh=YEApJjb+BKSUJEihP5IIJwfQnVF2BrNHxqVRXXY4P7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LFsMpGFKXfu67s3oRoRKYhwxbjy7CfApqBTJhgKdErGziCJF9lY3zS2PMfKLbtMxLaxNlpOpkVOrYZ+3PWlHc9TrQG7qo6hKCuSXems/ixaWBOhqXFqZ+GTGQKNbradvlGXo/uUWkEdxpX+zaG7zoTJ2R7RKJC4oOYRl1gAaNoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=azlffg9Y; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640fb02a662so909a12.1
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 11:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762542516; x=1763147316; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YEApJjb+BKSUJEihP5IIJwfQnVF2BrNHxqVRXXY4P7U=;
        b=azlffg9Yk8/EA28FE7gn+RB2mYHYJK3rOSM6wH0cyeuTij2n2pznAeqjxOTprjmWrz
         DVcUcLvkiVBRXT8UR1T23vm2W2cTZVzx6LEGLYDW1shuCostxGbgB+i0IV0wvX/8hEjC
         yv4Onqae1z8ve9b3xCL2e8r/hb/J072rbp1XBbL2v9BMnUCT1g3auSVwQ5iSHRaSneYo
         XCIWQ7+xJPPzAUmAhEDtUuxScZeiWEIlpzPOPCtZxudkgWFNLGNyvKLts3zK3Wcn3scx
         p9e7t3nrBriQJXsv7f1aV4yUIeP7I8nTBx6ea6MD1oWfI/R1AQB6nAGxY1G4xnVklALq
         jYHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762542516; x=1763147316;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YEApJjb+BKSUJEihP5IIJwfQnVF2BrNHxqVRXXY4P7U=;
        b=mCirk//p8TgISiXHFMBGLKKmxm7HNaGx+P/KKmLB95hOdy0nB9Fr9dmgiPSnIXrUM8
         3+oNqHbT6m1t4KC7L5p2cHXDWT1Gfdpi+oU/OudfZWqbjDYdU6jQtHrGRiJ/k2IOtNkn
         rbZGZbNv0pxShSzv58VHQTwcMoedKL27DwyyGjJ208CbB5Y4zmYwOGhYwQpvQbc2ZoyY
         r27gyQ8fsynwkCh+9i6SdexodgPHYwliouDiZAr3aRyEUQuldzObrUBXpLmIUMcmEZCU
         aj5c2NxgZoyEfdc4rVizQ3K+W+ukvIzcZv8LMDef0Vrrs7Pv/dgX0+BaQEHeTnht1LUi
         J/Mw==
X-Forwarded-Encrypted: i=1; AJvYcCVPzr3MaLBu3MUCEgWr3CpLA0pBuSa1pzkgZ2UJ22qJbN+Yhp6uZ4odgV7B3oUhJhyUYLc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4I8CUEFZPxghG03bcv0R5NVpAuUmh9dkMugyiQXLQ6u91MY86
	l8cMY2XH/OXi6oy0rEHU3tbqRfOoJ4FzRkKzoF+czNcmBx+K5rCE8Xnmpi8twNhPYRCj8E2mOfP
	/HqIZ2ZnyPSDkxwCContrFhrjTZqxV5+ZZRQvvOmC
X-Gm-Gg: ASbGncujBM4b+eOxml2FgKnUnW1ADzrq4fHh8x0fp0dY8HayKVVEm8FdjRIZdd0/cYE
	wiYJCwYCGN6EBWfTPbCcsUXQraRTxKQ99Li8AGafC3zpaB37lddUzSJqm4MDeLujZHVbt8oolNb
	aihM4mo743jhCT6ldTfpFQWvrq99Udqr/n7k6q+7fk3P4kj6yVPqkRUxHlTDXUliI6TwI8oc3Bh
	EyYvPFWzbMbw13r2TW0GUo32WRlpD6bsmZhrUekSPp3+mQjHxBdXTwUFfo7
X-Google-Smtp-Source: AGHT+IGG6ljG8dQXrbPMHMngTWoRxuoBwiYTf1g+loJabph/3sJvjF+CAfgur8C+kI6DxVyO7cJEyTRIhbK+lyOGqDM=
X-Received: by 2002:aa7:de05:0:b0:62f:9f43:2117 with SMTP id
 4fb4d7f45d1cf-6415d3ae66cmr9769a12.0.1762542516150; Fri, 07 Nov 2025 11:08:36
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251101000241.3764458-1-jmattson@google.com> <6f749888-28ef-419b-bc0a-5a82b6b58787@amd.com>
 <CALMp9eQJ69euqBs2NF6fQtb-Vf_0XqSiXs07h29Gr57-cvdGJg@mail.gmail.com> <93211ebf-1b8b-4543-bd1c-f3805a54833e@amd.com>
In-Reply-To: <93211ebf-1b8b-4543-bd1c-f3805a54833e@amd.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 7 Nov 2025 11:08:24 -0800
X-Gm-Features: AWmQ_bkz3gjPINUjSPU2FE5U7CJsGeQ2ZdXMf9L_NIA6-76979_FlFZxjte5sfY
Message-ID: <CALMp9eSVXX4mdPP-t_m9R553qaRY_i5q=+1d-9cC3ZuBkynxOA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: SVM: Mark VMCB_LBR dirty when L1 sets DebugCtl[LBR]
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, nikunj.dadhania@amd.com, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Matteo Rizzo <matteorizzo@google.com>, evn@google.com
Content-Type: text/plain; charset="UTF-8"

I'm going to rescind this patch. Yosry is going to handle the
situation differently in his LBRV patch series.

