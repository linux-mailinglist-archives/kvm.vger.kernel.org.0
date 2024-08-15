Return-Path: <kvm+bounces-24266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9975C953314
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:13:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BCA02885D2
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 14:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFCED1B14E9;
	Thu, 15 Aug 2024 14:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2QeJnNj5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996541A2564
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 14:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731044; cv=none; b=ZdWNuJXWgirbfeTVbnr9jon5lB3sN93rkTWcE2MVW1wvH0rcdxu7DuyJM9WwTP6QV8fNTxKmRo5EbYULg/eMFIl0KTPbU0tr0uyZeFqk3w41TCq2vq8dfzlKFaWNwExsiSJLsHwTmvM268x/UfZzd1zIeTo+BmYqI370gVjSan4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731044; c=relaxed/simple;
	bh=40j0e3Mvmb7WrK004NVl5blJt92PlmJDef6FrHW+bIk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=elSbSkh4ONohXHv3iTpUhrsv3f//+TIp55ZtyIZ0tuByxcaSAHQLIaxXFB5TJFmAe8bqm+qV1EPcWzJsEMUzGEtXAiM/8x5FGSMy8zK/1WZ0csNT+MZjn274YmXs2X1X3+T1DF1K8PDLpZ4IOfCYNqoPdZXROzkVqaltjI0wGXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2QeJnNj5; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc691f1f83aso434471276.1
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 07:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723731041; x=1724335841; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LTkI3wsyLsNDSBAGpuU/HH1hhVHus44TWdwDM7rFWno=;
        b=2QeJnNj5qWG1IXVZSiSRkXyh21zGR7hzYg4xjfYVDgN4p5L7kvpHMxpe6eOuLK6DoT
         VSVBfHX8dFPswd7ag5oYn/55lVA0XYdnSJO0C+fZihXib1Y+0PpSJHsu1ajPTRJRVmt3
         8R+up7qtImIqDta77g/vZJwdLNcp7AUQVgf4E1To0egSRgACAPukZw/hBlfkEau55Mva
         WTlP/m3iCYaLGrnzryeT5/8Inyj3FpmYpIGuCSAcOXNvGAlN2qCRfHHbXYzmVbDR1h0b
         FPpc41GS/jzYqFiND9hRazOR18OsQhBJc1O6Y5ovYgLX8uzIpykCeBHGEF5tU8HuGJ8v
         07vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723731041; x=1724335841;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LTkI3wsyLsNDSBAGpuU/HH1hhVHus44TWdwDM7rFWno=;
        b=MY8ZTc/WIPocbrqHhPGAU4X+jXX/gIadjv41Is0FRdaX8vyQZhHex4H05j/yXUKGbS
         CngifSp2H3sNmPJdoHtVcSLfmapOIJu3UlpzxgCOk3mTxsabAih2K+g97GFYIruc6esD
         hP413iE+l48YY54dk2HadFqZVTeqFsqEtv+6YfVO6laYGq3jlLPAqY8trEhN4Bq+Z5Q2
         6eNqy5g9KgUABCFA0TJ1lVd4ooJvvcK6hk3Bwlk3Tx54kufm1gSRCPGQ9oeKidGjl6R/
         jEj+bgWkkffldDiXKbkWGBKQ11v3a/nYRw3mWM5ngB/Sfl/o+xcvGhoIf38jcfYmlwNm
         TRIA==
X-Gm-Message-State: AOJu0YwRIU6T22U+UHV/M4b0ua3sjBbOZwyurmxiRGkMUmYSnsd7wYow
	xwlLKVtnjyeS9UyLbJ/ZYadqgwKDgVKYsQo4e6pTx3k8zOm8ooUnwbkUlei1izxqhzuejJfrQQG
	SMw==
X-Google-Smtp-Source: AGHT+IH0pTd3rLrKfwZLyotn/tm+cDBf4DXW8g4LPpDZGy112Wj3qEdw67GALP6EM6wTipE3BghmALeKdwk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1801:b0:e0b:dffc:d616 with SMTP id
 3f1490d57ef6-e116cf166afmr56139276.6.1723731041387; Thu, 15 Aug 2024 07:10:41
 -0700 (PDT)
Date: Thu, 15 Aug 2024 07:10:39 -0700
In-Reply-To: <2d485a6a-9665-4bb9-afdc-162b505462f9@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com> <20240809190319.1710470-11-seanjc@google.com>
 <2d485a6a-9665-4bb9-afdc-162b505462f9@redhat.com>
Message-ID: <Zr4MX4YdoMaoo-s1@google.com>
Subject: Re: [PATCH 10/22] KVM: x86/mmu: Replace PFERR_NESTED_GUEST_PAGE with
 a more descriptive helper
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Paolo Bonzini wrote:
> On 8/9/24 21:03, Sean Christopherson wrote:
> > -	if (direct &&
> > -	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE &&
> > +	if (direct && (is_write_to_guest_page_table(error_code)) &&
> 
> Too many parentheses. :)
> 
> Maybe put it before patch 3 if we decide not to Cc: stable?

Ya, I'll do this.

