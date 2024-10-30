Return-Path: <kvm+bounces-30112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0792B9B6EBA
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 22:22:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E379B2155B
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 21:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6754821747F;
	Wed, 30 Oct 2024 21:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DN1zi0nr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EC521500A
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 21:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730323316; cv=none; b=FIt/kl83Z308pYRG+uS0sbnYnjqqiXZm5rsfUyTjKjiichEySzYB+MkyGyNsHfzj8ZgMwnLlnvq5qieutVKsjg24WgMY7s+loW95ZOCq3i43248iu0la9ECwtOSryPyVQTHFpA1bxqZ7xcgmA6xhr9oCqu0vFcfhQtoU/7kTrmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730323316; c=relaxed/simple;
	bh=MbbCCbjq5JrUGConaTKMydDsYPgTDYUDt9hl0GKh/J0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oJHZ5182rqmDpt4My5LGu9bG59nUqtrWaprvTmPLHn8/ua4qIU3ZC0+oKehxPwb9YmPrjpC2Eqotl9F9uMeYQn3i7KjmmNWKoLaV/zrkGVEYzir1RYAZItH1gn+te8M4fWGD+ZoSxHbjYLbiL7MKp/uj9DdLonuhrd+DiAH4O9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DN1zi0nr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730323313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fImY0tgPhU7C7Gbsu2PvJitaPu6EoaPbjdriZ08AJg8=;
	b=DN1zi0nrYcA/nXT0JYO9AjrC2LsbAgi/NqY3cyrUZjAkKG9g0R6L60s2mgz2nKUtVlahot
	Wc0DM/tfVER6p37m8D4Ar5dlV8U6uI+yB9DENd5r3xyH7ONGZlxzqD4TLfx3Ue3Q1Tpn8+
	TjxPPOZ7sSDiuIKLKeStIc2HPhaK53g=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-QbEb5wHdMhaBW5-NNpkPiQ-1; Wed, 30 Oct 2024 17:21:52 -0400
X-MC-Unique: QbEb5wHdMhaBW5-NNpkPiQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6cbceb26182so6813316d6.0
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 14:21:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730323311; x=1730928111;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fImY0tgPhU7C7Gbsu2PvJitaPu6EoaPbjdriZ08AJg8=;
        b=O5Um9ZBY4eFeBshk99HMIRMW8jAELOjVosKIAtr45rHgSfxXYOjrW1ni6c6eSJPC8v
         Dcec3IzluZGSKhYzqU8uR6t9giVecmHSYbA0yNxAA+JmVSZYHssXqapdScYJLmBHuKN5
         aS6V4pkC6yqnl6sccqIKrTR8YyKkeCigPhkLXudYyV+2TTvJgPQEiHJbeMm0nsamxOpB
         196Krpcp4XPk5mB1YN25IIVDvqdlx5aaBDr+7ZmhiUYTMffoOL1eaUAD97LdiDjfRKU1
         wQKAmpAoNy8PC6vfZadW1l9A+WwtATAkjIR+kQuNLJPUg1JkGbqxcH9JZKTCzW33l0mX
         QqJw==
X-Gm-Message-State: AOJu0YzX62YR74sXpEMHTl6LqFVm0/+3LddDe2hw6OWZjz/WVU02QuK6
	ofJKHvZfmzpjuH2StJD17AIi/ltmt5W4PXGB+dSX1lLFM0cqcdQkB4r6jRYUzvae+gQuN9nNIed
	JkJxrrMhHkJyGA0975deV7q4Lk1t8ycAmAsa45ezsiJDMuFWP1GAimAh3wq3+DUNnTZQXaQsRZg
	igN6FTmcDPgZB3toKmdjIWH5JjnQ6Wi8fhgQ==
X-Received: by 2002:a05:6214:419a:b0:6cd:5ff4:cb1f with SMTP id 6a1803df08f44-6d351a92c11mr11401436d6.3.1730323311383;
        Wed, 30 Oct 2024 14:21:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEr0fgtvMzz0D10iM8abFx6F7KGhICxqqQgW6cfSToB9LfZyBq1dF7BOnv89yuukqJXIUPsDQ==
X-Received: by 2002:a05:6214:419a:b0:6cd:5ff4:cb1f with SMTP id 6a1803df08f44-6d351a92c11mr11401186d6.3.1730323311045;
        Wed, 30 Oct 2024 14:21:51 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:760d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d354189baasm486516d6.143.2024.10.30.14.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 14:21:50 -0700 (PDT)
Message-ID: <d59b923ebd369415056c80b99ca4e0f75d60fa84.camel@redhat.com>
Subject: Re: [PATCH v5 0/3] KVM: x86: tracepoint updates
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Thomas
 Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Paolo
 Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, Sean
 Christopherson <seanjc@google.com>, "H. Peter Anvin" <hpa@zytor.com>, 
 linux-kernel@vger.kernel.org
Date: Wed, 30 Oct 2024 17:21:49 -0400
In-Reply-To: <20240910200350.264245-1-mlevitsk@redhat.com>
References: <20240910200350.264245-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2024-09-10 at 16:03 -0400, Maxim Levitsky wrote:
> This patch series is intended to add some selected information
> to the kvm tracepoints to make it easier to gather insights about
> running nested guests.
> 
> This patch series was developed together with a new x86 performance analysis tool
> that I developed recently (https://gitlab.com/maximlevitsky/kvmon)
> which aims to be a better kvm_stat, and allows you at glance
> to see what is happening in a VM, including nesting.
> 
> V5: rebased on top of recent changes
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (3):
>   KVM: x86: add more information to the kvm_entry tracepoint
>   KVM: x86: add information about pending requests to kvm_exit
>     tracepoint
>   KVM: x86: add new nested vmexit tracepoints
> 
>  arch/x86/include/asm/kvm-x86-ops.h |   1 +
>  arch/x86/include/asm/kvm_host.h    |   5 +-
>  arch/x86/kvm/svm/nested.c          |  22 ++++++
>  arch/x86/kvm/svm/svm.c             |  17 +++++
>  arch/x86/kvm/trace.h               | 107 ++++++++++++++++++++++++++---
>  arch/x86/kvm/vmx/main.c            |   1 +
>  arch/x86/kvm/vmx/nested.c          |  27 ++++++++
>  arch/x86/kvm/vmx/vmx.c             |  11 +++
>  arch/x86/kvm/vmx/x86_ops.h         |   4 ++
>  arch/x86/kvm/x86.c                 |   3 +
>  10 files changed, 189 insertions(+), 9 deletions(-)
> 
> -- 
> 2.26.3
> 
> 

Hi,
A very gentle ping on this patch series.

Best regards,
	Maxim Levitsky


