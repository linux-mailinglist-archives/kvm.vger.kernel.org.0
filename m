Return-Path: <kvm+bounces-38226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1939DA36A8D
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:06:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D3BF16BAAF
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A0D1FF7CD;
	Sat, 15 Feb 2025 00:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D4xV/ppt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AF11ACEC6
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739581007; cv=none; b=sPj8U0BvVr+/gPBqUpjxUpBGzWRnq8WVzYhDgSb6ILBNkMYU+QcHeD9EwSWqLq59U4EuyHCz1u+/inIr5vFKR6/ZwojM6aN2Ab/W1j992aRCxFXnz29cGKpSRGzAdRUCN81n+tLgTzx6La6hIiRBi5aUR2ltxHCPz4WoMUiKtWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739581007; c=relaxed/simple;
	bh=LJfY5V0AHFisX5DCVy3Z1JSu56syEEHDsV35P/BAjg8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f3mXOx9bOX9WHCQlMbtyST9zYUmJoXyjJDplBOqiMmXbZz7CdKdm5i/e3OBKwMwGsXTDjLo9gjw7yPKtrv3LzprwHM3FiSsiS3rEbt/aTpAPyKXjbkp4F/vvvkASoZkuOzMRLFB6CsSkd96P5sspIQvvd1meSHchQi/4QWfNzcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D4xV/ppt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc3e239675so1611074a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739581006; x=1740185806; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4fey4QnA3/tUxXpzdywyoLd/ynLqE1XVFF3uBKJyeoE=;
        b=D4xV/ppt0rJYU28U2vYJth3t6nWs9+cR7i561xYv7VmS2ml2fsDF3umhhWKAWt+9uk
         MEFOdIXl49vgK2x/eRK+v4+aGThYtQfrLe1yYyVZQXFlpjBXSC/f9lcrivcQTZtiFp/H
         hZliQv5bniTreawNz1eUdRF6Hnp6JOFJa75MeJSRd6NTeUf+AzpGhCJPIXR8jQackolY
         r6ZmuALZ5a/DRRyNct3vPzmGGlSCZ7xzDsCFbzJLZpiAQW9CY1zvOWjSu11sdnEf2W1Z
         DtHrkJlm27IQYEOKPvr5FQouZUfLGc/rr7BRrjJZ4K27vXE8+KBCATGk04iy+Vm2KMqF
         EE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739581006; x=1740185806;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4fey4QnA3/tUxXpzdywyoLd/ynLqE1XVFF3uBKJyeoE=;
        b=NudXMF7QZRs/KgqmP7GSOvOJHGrcB1HmmdwUskquKk/WjT7w7vT66MojZrOKBYNAp0
         mhIZw08/2JeQ9ihEE0BjszGRIHbN0RWcYKsxF03RiLOXVd0phC+RuJF0tXIScKlRHS3T
         WRi/pUJAzc4xhBDZ/S7SiiREbWi4z8gia+iuCCqAhuSw6W4O6c7NauH8ylM0WZr5hLaS
         X5Yjw8UVNUj+1HjIB4GWlou+cENZAzFBnwXgBlRucaIrbx/yNR75BY+tYkKEvKFmwADf
         LMcI4bYvMo1cqLtnfBtq66jTnEJDvVjqlaYdV71izBQnPW9hmqM6l5lo8DtF9D4R4j8g
         WHjg==
X-Forwarded-Encrypted: i=1; AJvYcCVvQjyqNfjfSKMEVKXdi8r0YwM1cXN0E8elUfYCsAnVEjoE/0DygAg+GX/WuHWvryj3I5A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxufEPQ9qwIgiLbk9+RTKlEHMOJ/wF5yQBGLcoGujK5zARatwPk
	yc1gyMAA71Gp8AAAzoEn9oA94A60kaq715Z0ss1qTmfl8ZQ3k0+Rex4663js5EerFmU4fQKfiDN
	EXg==
X-Google-Smtp-Source: AGHT+IGoq6w6j4Pky52o1x0/J9ln/3l3jO2+Y7yM7hbmnUIWDRrg50we84A8nhSOUEAnLx2MB/HIYKpCKlE=
X-Received: from pfbdl7.prod.google.com ([2002:a05:6a00:4907:b0:730:9617:a4c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3c91:b0:730:97a6:f04
 with SMTP id d2e1a72fcca58-7326179e966mr2105483b3a.7.1739581005802; Fri, 14
 Feb 2025 16:56:45 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:37 -0800
In-Reply-To: <20250123055140.144378-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250123055140.144378-1-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958011559.1187935.11817733306531023481.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SEV: Use to_kvm_sev_info() for fetching kvm_sev_info struct
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	Nikunj A Dadhania <nikunj@amd.com>
Cc: thomas.lendacky@amd.com, santosh.shukla@amd.com
Content-Type: text/plain; charset="utf-8"

On Thu, 23 Jan 2025 11:21:40 +0530, Nikunj A Dadhania wrote:
> Simplify code by replacing &to_kvm_svm(kvm)->sev_info with
> to_kvm_sev_info() helper function. Wherever possible, drop the local
> variable declaration and directly use the helper instead.
> 
> No functional changes.
> 
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SEV: Use to_kvm_sev_info() for fetching kvm_sev_info struct
      https://github.com/kvm-x86/linux/commit/8a01902a0168

--
https://github.com/kvm-x86/linux/tree/next

