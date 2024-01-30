Return-Path: <kvm+bounces-7495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46914842CFE
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 20:37:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7977A1C23135
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 19:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398717B3D9;
	Tue, 30 Jan 2024 19:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lFIF8fz6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6A326AFC
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 19:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706643420; cv=none; b=Wv+WVK7ulUUAoxMV0YjLLSPeHfnaNaTAmHKLYnBxjGaYcDU0icjE0dr8W7DXzZzMWcf2BCcDF1/3zLbB8bAClCxc5whpVKWlPXIV3+TzW7M0KKhUat9/fO/I2hDCXgiXpWxCWbMfZQvInaA9W/TwXBgF0NTZTsZiOd1bBf69ZnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706643420; c=relaxed/simple;
	bh=9iFEFvgWzuzqEkprkYsQv+QTmAPlOmQpdeuwM6vK0rw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZBHL0jFxB+KBM8Pmh2v2TocILBDsxxSZKSAj2cXOGpHBIa64oVdql10jfogZQxlmFesOk59OJT94gmi6nGRJacZ13PUOZfRJ+2rtGZOwc+EJZdvKVH31NLd30Yw1Ve0p7OZSWd+8JP/cA9UEQ+as3SeA0hoNHFegv1AUCFIcx6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lFIF8fz6; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-603c0e020a6so35803617b3.0
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 11:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706643418; x=1707248218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9btAcWVzSnK4CU/Kg+oImzOwolkjF54hGXFVcE1ZJ9o=;
        b=lFIF8fz6k/fKtJ9azSjT19N9wYuuvSUzON/uNCFDlZ7v3LvoWs3TcZ2USZI12Nn96f
         G1PVcINkzfQ3lAErTqUvaEtU0pKindPslbFKplMFZS/F7f3F+LSfMuZKxZInafDbbk4c
         NxTypjCQrNljNTi6/Ln4/I27PfoV5uy+q2kg0/Gievs9+2icqOGqkd2jvSAgZGGJe6ba
         ZKDtYiBfMg71A66ax8VTa/K/GjvkDV3BV5Au5xJZMr0RofJ6/Mk3Y4wt1VGHaTm+95gZ
         K+AM8UaL1pAxTltK8HMteJZ3logbY9uIXVMP6m4AI4B+WPfhPSX2tek1F0VoNQwC3MRr
         KuEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706643418; x=1707248218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9btAcWVzSnK4CU/Kg+oImzOwolkjF54hGXFVcE1ZJ9o=;
        b=BfiriKeZChPNn1nUzyb71jOsPzEx9WGzlPD5fJvy9GYY3Dnmngfu0TLoGk7cVBRD8q
         deFTeUg7Xy40nq0cfH1G4JgpWR8gYhmVuQFruqaEiWYkIMZqqdUynsPuWw5C5XVUh4tf
         xFkiwAjr7/fhut1RsW5m9I/0Jc7lt19id+5CKllQAR6l+6rH0mZZzdL0jZlfk2emueGj
         KZ9qWJkaFRu3E0MIdTjmbXbZd1qafW0A9ggd7ag0eVp8FP2Oll0elRBa6rA/mvJvJWYu
         8qH3lpGXT3kPH2Q0g7BXqtW2I9VwrBsYYpOoexxuMYaBr0LCMmPbQCSDQhlOGYvnRxeN
         ZIVg==
X-Gm-Message-State: AOJu0YxRS9BvrfYo2wqgbYuG3TW2EHjJ4uuBXr28XZOw2XA0v2DDfK5L
	ujndIrInVJA0hWttZlmHO1Km928TGTz266AIvv+cXMxD3uQDKrv5Qj+m/LedV/ilgA7gjOpPSNL
	4nQ==
X-Google-Smtp-Source: AGHT+IFehSk1FBhilJc/Mh9NEP0tu1XEpHzekynpi3Lw2EzlZPlnqBrFNvXjtF9MBkF3nQmubH2CeJ5E9iQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9853:0:b0:604:260:fc81 with SMTP id
 p80-20020a819853000000b006040260fc81mr153243ywg.0.1706643417900; Tue, 30 Jan
 2024 11:36:57 -0800 (PST)
Date: Tue, 30 Jan 2024 11:36:56 -0800
In-Reply-To: <20231218161146.3554657-9-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218161146.3554657-1-pgonda@google.com> <20231218161146.3554657-9-pgonda@google.com>
Message-ID: <ZblP2GUIJXB3M_ap@google.com>
Subject: Re: [PATCH V7 8/8] KVM: selftests: Add simple sev vm testing
From: Sean Christopherson <seanjc@google.com>
To: Peter Gonda <pgonda@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 18, 2023, Peter Gonda wrote:
> A very simple of booting SEV guests that checks SEV related CPUID bits
> and the SEV MSR.

Phrase changelogs as commands.

> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerly Tng <ackerleytng@google.com>
> cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Suggested-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../selftests/kvm/x86_64/sev_all_boot_test.c  | 59 +++++++++++++++++++
>  2 files changed, 60 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c

I think sev_smoke_test is more appropriate.  This isn't "booting" in the traditional
sense, e.g. it's not going through BIOS/firmware, transfering to a proper kernel,
etc.

