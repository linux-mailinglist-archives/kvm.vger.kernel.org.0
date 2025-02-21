Return-Path: <kvm+bounces-38914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F89FA40381
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 00:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AA1E19C5DE8
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 23:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A843720AF8E;
	Fri, 21 Feb 2025 23:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lceo4LSs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD7A2066DB
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 23:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740180885; cv=none; b=PRSJ3eiYaXE12ezHtJE4iS2nMK0YYqRWT/Qw7vRsLtC29C8MV+D6L4f6bxTdFV4wyTt7AI2M9iwiICNrean1n36fVodzwR13fPInghg13DCGVDl4FaR1qgakKlWPpV70kp257O/+UeAZqGzw279LImrcGGXdR895GHeJG2Q58qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740180885; c=relaxed/simple;
	bh=sLcN+WrAzZsqWywRxIulrOAkH6iiocquDgSNtXtUZY8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=HEDwPHye6xA8PWep+LlxVWFRozAohShwTFxJn6lf4fW7mJFHLsh32ZXc1k+HIF832q4h4S65gJ8B8gbdUyXi+TcyUGtN2DE1zb/CYGwPTynmRWTj4GpTg5m8YKmNr9robrurRrgJyfSyljd81Y/m7RE1HTlXSTjTEb6IgJgeX4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lceo4LSs; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22119b07d52so35034895ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 15:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740180884; x=1740785684; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PPibVXWvp4DoY9G+kf9mR9h729oRmuO7481VoJ3ZIhk=;
        b=Lceo4LSsPa1aVmUuLOdi7jDvVOCCnx7GdtsaCqZOXsWn8t0VReErmVzbVw5rrGlbC0
         SR6y3ksr38/lzvlzydcBwzADZQr4rthybLufvRr0BdK2LH0h0avG0k8xk8n11xBenH8O
         gN4j7JtjDNyHWNyptrgT1fHdRzk3mfXVgTEe7KenMCOON1QUSrxvF/CWcTa//uBWAR+f
         Wdh/FBuVKL8Ovfh4/LR997JcH2eQ40qAnHUjEN14ApDT57+PaTRGlU6l0hvEWWNmsyUj
         E3nN5WqzGHG5is6tr4gYW1eD3ISVETBTFwIUv+i4PPGwiCm0WuCeWyWbuh4OqGM1sN6L
         i7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740180884; x=1740785684;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PPibVXWvp4DoY9G+kf9mR9h729oRmuO7481VoJ3ZIhk=;
        b=Qggre/DgkB8khdhOmUZGMR1kfUnvhi4jz1VHBhKAB9q9XQBl7qS5EE/IDDtIpfZaMC
         ILIpzJG6wUNiAYusT1etzj84Y9m5Ksuidop6ZmRasyP7YwRyg4Wi7xk8D1jo6A7YcaIv
         H34mghJD6qyDkHvC8Qvd3NoHGlwGRrnLvbajgv5pn9nu4q5NYXP6N62iF6XOZctLDESI
         KbLx9koBO8Rnk1L7plV+poVh5fIY3v7Z6hH9RPcIOPFpm9vQU1j/O0bFVNGAFi49p/ci
         jxRSwjvYpp43O+5YdLvcwbqRlj92/95u+KzxLJCAZAMSuWUFFvvvsCwgU8Ok+shtbII4
         zPFw==
X-Forwarded-Encrypted: i=1; AJvYcCX/MLEexfVKLE5SHJozZmDAs6x7fop+rNJK13qXSxfptCp/PVEzwib66nI5enLWVsKWvaY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4sczaT0mhDKKmWgK1l20l6l3ohB/ij9kKcE3+T+fIvIJEccc+
	59uP59iR/ye1wh8YwSa6ACa7LWHWE+xIG5x9tOozxi0i5spSnRln1Zd8Odn9yFvKQY8qZTTnd49
	14w==
X-Google-Smtp-Source: AGHT+IHC94y33dtc3E0c8AoQS1InIa0oMPBZcc1PAQaC5SDYjLj76IBWdM8eSy/g+hFozAENWXjtFldes58=
X-Received: from pjbsv12.prod.google.com ([2002:a17:90b:538c:b0:2e9:38ea:ca0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f650:b0:216:1543:195d
 with SMTP id d9443c01a7336-2219ff6301cmr95240685ad.25.1740180883787; Fri, 21
 Feb 2025 15:34:43 -0800 (PST)
Date: Fri, 21 Feb 2025 15:34:42 -0800
In-Reply-To: <20250221225406.2228938-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221225406.2228938-1-seanjc@google.com> <20250221225406.2228938-4-seanjc@google.com>
Message-ID: <Z7kNkpcMZfbopCMH@google.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: replace segment selector magic
 number with macro definition
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Hang SU <darcy.sh@antgroup.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 21, 2025, Sean Christopherson wrote:
> @@ -15,7 +17,7 @@ sipi_entry:
>  	or $1, %eax
>  	mov %eax, %cr0
>  	lgdtl ap_rm_gdt_descr - sipi_entry
> -	ljmpl $8, $ap_start32
> +	ljmpl $KERNEL_CS32, $ap_start32

Gah, this is wrong, it should be KERNEL_CS, not KERNEL_CS32.  It was wrong in the
original posting as well.  Not sure how I missed it the first time around.

I'll fixup when applying.

