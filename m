Return-Path: <kvm+bounces-33499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D74A69ED4A1
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 19:20:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08CBE280A11
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 18:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58307204088;
	Wed, 11 Dec 2024 18:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4eJwPPod"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE5A2010F6
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 18:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733941237; cv=none; b=seCOiKyVZbHxlPcMFelOZWy8HzLNeTEvJDKWeWJIc2hbxT6aznclCTtJQW03Z+O6ayMb61an7xHGnz5wv+2mE+cus6T/TwlaX+HK3UO827d+zZvAM3jS0s3t9vW16dz4RWPtDVBmcX6PuW4pfAAsbFIeXVl9qiZ4WAL7ap7k7NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733941237; c=relaxed/simple;
	bh=eLQNLd5wRv8SOWkCMUttN5dD8JyVnkMs9ZHP4OQrzcs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qvDHX2QDfZ0FBrjKC9naIl130EypSyjgZKdr97ETE7Jw0NUvYygW4LEFBVcDQ33wxDj6DHidbSyrT9gEUGkbCSe3RjjPxh9z8Ux4LyhpENeLUHClNt1na5rva4rNDTXactHrcrRJV/wYbrNx5aVnvV6RhBUKfL7vNwW+/M+l2BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4eJwPPod; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-725cab4d72bso3169688b3a.2
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 10:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733941235; x=1734546035; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t+Ox1uza8Q79A6RwFeyGkXs+VHW6BnofeA5s7qSYG3M=;
        b=4eJwPPodg6mtnp3VFSBnHN396zCQKMsddDlh5NS8jZqSShPHLqM4mHxNfqXeBygMwR
         lVAQ38m9BzqChj+byZ21K+XX5JjzRVaR7vxVUxiTJ501mVPAt4PYdX9hzN4xobsdi1UI
         g+I6lYegvVJjlKWZZVTVu9uS1olmtiNsW6h5P4lBBYSSKBDrgJzx4dWecfcniPExwY4o
         BGJM2II5ziQLi6OY+xeOiJAIygxIIRzl1ycWylY0G1NVPWElZ8lcGi21tdiOOb/fM0OB
         PmEHHu3L2Q0yHk5/YVTTNnj1j5AixR24thMLxMNu0FJwhpCcjsv9ygJa0RqLPl2aMXs3
         hVMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733941235; x=1734546035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t+Ox1uza8Q79A6RwFeyGkXs+VHW6BnofeA5s7qSYG3M=;
        b=LePdR9KizxXfEUsXQT0pqAcCWQQa0hbhqL8SeRAX8/L42EXZD9Xn0f1F6Lx/mzr4P9
         3qs93fNcIAwGd37hFI6tHgZyUYM+0Jc/GvdSlhT07LWI+MTl35/wD/c31Obk+LUSk+rA
         r+g2OwqSkQ8nQY5lGO0934W6F3E8O0POF+fXE7hCpeSGNvR4KMwRs9M/DT8N7kOH7moR
         EkMxB7CdWArQVfG3xgAx3FKE/khTdn/Kg1rEE233TkSsTAQyHcF6j28GZuY3pcW/wMnZ
         C0AevZEEpauITtyN4HD+iInlry6EkAIparzVY5SZIvjVf5FJ0thMEXlXWtuNeWk3fqon
         tfEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZUIOYwvZDgOK8TEXzMO2WikVINrhCzFEUKYrHRFdm+ZfBulZpMbj0dpgI90bTZ5at2LA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNRDXEPn01GLOjjhFQ1chHdNQ3IVcMiBqLiFxjZdcXY9T8dokS
	GG4LzTY96dElcxKoGhNmQ69qAads71fzriWEtiQ0CW5t9eoH5nfXeY+KOUF9ynhVa+WhR3oxdu+
	X4g==
X-Google-Smtp-Source: AGHT+IEZfd8RpvX3OL8+D64SC/c6EBzqjS61c4iGRcc1nCHXG9qtDFB2g/ZbpKx2mvqm2c2s2Smm91XqVPU=
X-Received: from pfwy4.prod.google.com ([2002:a05:6a00:1c84:b0:725:ceac:b484])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:10c8:b0:728:eb32:356c
 with SMTP id d2e1a72fcca58-728faa1fcb5mr375468b3a.11.1733941235183; Wed, 11
 Dec 2024 10:20:35 -0800 (PST)
Date: Wed, 11 Dec 2024 10:20:33 -0800
In-Reply-To: <20241111102749.82761-1-iorlov@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241111102749.82761-1-iorlov@amazon.com>
Message-ID: <Z1nX8aCfZMvJ4co4@google.com>
Subject: Re: [PATCH v2 0/6] Enhance event delivery error handling
From: Sean Christopherson <seanjc@google.com>
To: Ivan Orlov <iorlov@amazon.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, pdurrant@amazon.co.uk, 
	dwmw@amazon.co.uk
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 11, 2024, Ivan Orlov wrote:
> Currently, the situation when guest accesses MMIO during vectoring is
> handled differently on VMX and SVM: on VMX KVM returns internal error,
> when SVM goes into infinite loop trying to deliver an event again and
> again.
> 
> This patch series eliminates this difference by returning a KVM internal
> error when guest performs MMIO during vectoring for both VMX and SVM.
> 
> Also, introduce a selftest test case which covers the error handling
> mentioned above.
> 
> V1 -> V2:
> - Make commit messages more brief, avoid using pronouns
> - Extract SVM error handling into a separate commit
> - Introduce a new X86EMUL_ return type and detect the unhandleable
> vectoring error in vendor-specific check_emulate_instruction instead of
> handling it in the common MMU code (which is specific for cached MMIO)
> 
> Ivan Orlov (6):
>   KVM: x86: Add function for vectoring error generation
>   KVM: x86: Add emulation status for vectoring during MMIO
>   KVM: VMX: Handle vectoring error in check_emulate_instruction
>   KVM: SVM: Handle MMIO during vectroing error
>   selftests: KVM: extract lidt into helper function
>   selftests: KVM: Add test case for MMIO during vectoring

Minor nits throughout, but unless you disagree with my suggestions, I'll fix them
up when applying, i.e. no need to post a v3.

