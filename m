Return-Path: <kvm+bounces-39195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 638AAA45065
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 23:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 842953A89C9
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B72221577;
	Tue, 25 Feb 2025 22:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jKfdjdnf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACDD221561
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 22:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740523173; cv=none; b=UyRND+atJh6ZSgUHai4Qsq4yicWFtEbfVAD4C8A1Pg5dxmZYGfJ7LQT7PakP1rLixiWW3IrwP2ap8tcUL2a7pmQ4rIcmqJTYeY1nJX62C9mUDK9Sy8r/TIDk6N8FTrxQiJ7DJOEiLL5FK8+JgIlOrLbWbKXsV4Lw1xut8GRpjgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740523173; c=relaxed/simple;
	bh=p7oGnaWvWXTBzXokZuyHvv8SGeM17iNUeK8uO978Owk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pNk0pEC6vtAWEWNxdbG9dnVLd8Czjio4RWEapM+gv6+t+Vvodn9i8rjEo1xoRfYDO6Onp5TpN5OzuqzrDEVxB3RymHfVFQw6fxCHXno0zX0fRwxwlaiAhIm8MAy1ngITW6UaDPLCmBdSxQpVhad1o7xjSGJWXYtHehmghdwO/tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jKfdjdnf; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1c3b3dc7so11838773a91.2
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 14:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740523171; x=1741127971; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zh7JWOkY6aMHEwem4sxE2JFtaVUakgwBnhbfU9uucGs=;
        b=jKfdjdnfDPBOLGhfPcWoh8w91vDm2PmtaPKmypW17c0P4yw60Qv9j4oJVgoXoQzC2l
         /+xfE5Svh2htSqZ8a+3JghkLjIqPMbjVgwLkyYgcDA4t50JfQg9EoqEaxA5a5e+7l7pR
         BCkvgI9B3qQTmnqeW5cyEkYSj942GLPjpbbeJ0IyscrojOTH7xyU80H6EY73de5rnEix
         KUXXcQAasLCcLp71ZNAi7I1YWs0kd1JPSdax9N+x4LfaU9NvjLZPyBSq/1qREemkZLJZ
         0dYDmTPVQ9Y+DTgI+usTDpT1HY0vKysPIyRkJBqMyMrlbPIlIr8D4a5HssipRr8krgCm
         qCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740523171; x=1741127971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zh7JWOkY6aMHEwem4sxE2JFtaVUakgwBnhbfU9uucGs=;
        b=Dy1cUTOb5BUDeN15joqohDHKhB/6cNilF9pM5xTC77cWn3vHtAWo7+QRF6xjEaLyQC
         w/qfWXCz9Eg35Q8F5QkP532njJDPQSwWQLjok5003Tp8Is3JPr4BEdD6+0H1HrDmlXI1
         ez7b5QISFS6nbQhz7vmibcYNZjT2oUyC1DoxzlyqUki4xKXZ5xWy0wnUoQfh+kTSfzGU
         TNgoEuoM9Ae6c4YWHGrVRcyYQliiCsqpFFtOF/Ze5PsG0UVv9mp+d4IUIFqSrbhZ/43/
         afV+6xG+cMPGVTcjmmhPuRdPF048zB0nixHuQn+R+iEPjpVOKDFXPvOANXVXXIffc8fK
         ffkA==
X-Forwarded-Encrypted: i=1; AJvYcCVSLHJRZ5YyBbztzJeSsM1c7rI1c9XPzA6LBWL9zJiVI7wc8eqbFBtnDDjMEQXumGw27cA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0vkkMMKTvsl3W9yvktm+sNpYbzTt8BkJXXyWINqq3U1mcW1mf
	reZGWHt/SlmByEk4MOtHbl1+ZRw0VGr4NyEvzhiYJyzQG0IecZWGk6g6swAViJtKeCoobxDBL1p
	YOQ==
X-Google-Smtp-Source: AGHT+IFih1XaydANV5Xgmoe228nGIMEYPUMEHKoNEF0RFGmWeCQNMBJFR8dzqqODQUEd+6xSMEHR2FrDGqs=
X-Received: from pjx14.prod.google.com ([2002:a17:90b:568e:b0:2ea:5084:5297])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dd1:b0:2ee:b875:6d30
 with SMTP id 98e67ed59e1d1-2fe7e3163b9mr1809896a91.9.1740523171586; Tue, 25
 Feb 2025 14:39:31 -0800 (PST)
Date: Tue, 25 Feb 2025 14:39:30 -0800
In-Reply-To: <20250225213937.2471419-1-huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250225213937.2471419-1-huibo.wang@amd.com>
Message-ID: <Z75GoiqAHb6sLUEh@google.com>
Subject: Re: [PATCH v5 0/2] KVM: SVM: Make VMGEXIT GHCB exit codes more readable
From: Sean Christopherson <seanjc@google.com>
To: Melody Wang <huibo.wang@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Paluri PavanKumar <pavankumar.paluri@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 25, 2025, Melody Wang wrote:
> Melody Wang (2):
>   KVM: SVM: Convert plain error code numbers to defines
>   KVM: SVM: Provide helpers to set the error code
> 
>  arch/x86/include/asm/sev-common.h |  8 +++++++
>  arch/x86/kvm/svm/sev.c            | 39 +++++++++++++++++--------------
>  arch/x86/kvm/svm/svm.c            |  6 +----
>  arch/x86/kvm/svm/svm.h            | 29 +++++++++++++++++++++++
>  4 files changed, 59 insertions(+), 23 deletions(-)

A few nits, but I'll fixup when applying.  No need for a new version.

