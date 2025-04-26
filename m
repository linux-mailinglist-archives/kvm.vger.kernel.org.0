Return-Path: <kvm+bounces-44386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93965A9D6BA
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 02:34:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E81379C0A26
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:34:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B991E5213;
	Sat, 26 Apr 2025 00:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lnGkaI1l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503A719DF6A
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 00:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745627651; cv=none; b=skWCKWv1MhVBCtjG5Y6NdrQ9NVtFUoCht5mR8Rq3gxqPdOAsEkHbNRvLYa3RJxrCzFxuv2Uksv1tZTq9+kpAMmr8PuX9S+AeioimJFFrh/QiH3GQq7V4H48i9Ib30Y27SPkL9D3DIfjEgEvSCjYmduiU7PSX43MKxU/D7lCE9Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745627651; c=relaxed/simple;
	bh=Mq33vldSR/ATwoxyU7PNGDaQUVPFt5WsKW7rOhaAAqU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c3Yav3zPjLAWiBgRZCPIJREe/qaEEyYIgtUXL4P56jYmpXAh4Zqqqpy3fO1kSTCtx+IlI0e02UVU6KBkdB1qVxRBnrnBkJkJ/05bAqA4vGuZxeERMRyqmfpq3j3Z/T1o2gFf2M6BhMpBhRan3G1zP0lZifvaLuTUGpYabfV5pGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lnGkaI1l; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff798e8c90so2662461a91.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 17:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745627649; x=1746232449; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YDf2J2PcDCSyWKA3oeM/sk2ULm9hDpCeNfW73+AzdwM=;
        b=lnGkaI1lH+k1H2F+nS5XrpIdEsV9fKsgodCA35duA1NR3hJS/3FAskPA99LHIYny7Y
         XSZ/cknUYjBZL1fJ6EqJ8rTXaeVfwIR8vN1gwAbxvfT4f9IiGF1C8F7vJpRD9rOIHkUN
         onX8MPeQG401FJoefixUASvWa4dwsbSKUdBXjWJZvX3C+szc3Ad+ZC6lXTxfkVxb396A
         z2lJ/ivlPWs9LMxAwr0a4Jr5wZ+lUNq13YczAzSbg5mft5+apOoCyRO1O0cirDjfDt4Z
         FBQxTWrAnTDkjLq7+doWRYO0ezi4a+Lq9bUNfKAG7nZE5LuqH1jEGGkGfL/4yPQJPHKZ
         Upbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745627649; x=1746232449;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YDf2J2PcDCSyWKA3oeM/sk2ULm9hDpCeNfW73+AzdwM=;
        b=KM1iEfjUiAZMFM1y0NwIPvGX4NHq9UMnD9BWpVLTsVf1I7sQ/s1GItDIVy2fEvl21E
         iL3Oomej0J9QUKq4fEKiN1nS9l0GR0nURhDWGp1P6vtZDr6EjCxpTugejRiPKnpyngBi
         djKkg54zoqo9suS3SoYvTyPBQanHAZIN8pj22Ap8bKu7iKVR/XqYvR1iP1KWZbV3b7kw
         TPU/rYUWrlgLPq8aPhUT9g9iNvT4Es1Wl0nWH2uttbc4Ca+NdmOAJ67v/FRPshBoUEt4
         4+LpuEXecboBLQKqUdgk/HRZeChABHnarKG4NysFNB8+0crD3e8SikPD/qZx0ftEsIzW
         C3nw==
X-Forwarded-Encrypted: i=1; AJvYcCWBYjVlWdR0Jbd7dItbhNy3YbYNifEUZ6yfoAJZmU0MF1X4s9WUkGje3qGUfq3Xz8T2pZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YydnGzFlMBPFkC3BoPZUjYwkcxnHsWFBFruyQEgCz0O9sDRaecp
	dWDAn0GrVycc+bH5pQGI8UyVQLf79kMj7M8XE5AiWkQdPGjALOI/VjxyvsOQcj6drc4lth/nWsC
	aow==
X-Google-Smtp-Source: AGHT+IG/HtrMJuMhlKJVdX9a6Pdk9FErJIBtdSdgXi2vAyOyRtjdTZRlhf0jfCwUG3z/vdaH5mj9CwIi0l4=
X-Received: from pjbsb7.prod.google.com ([2002:a17:90b:50c7:b0:2ff:5344:b54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a43:b0:2ff:6fc3:79c4
 with SMTP id 98e67ed59e1d1-30a013995camr2050753a91.27.1745627649627; Fri, 25
 Apr 2025 17:34:09 -0700 (PDT)
Date: Fri, 25 Apr 2025 17:34:08 -0700
In-Reply-To: <20250421073110.2259397-3-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250421073110.2259397-1-maobibo@loongson.cn> <20250421073110.2259397-3-maobibo@loongson.cn>
Message-ID: <aAwqAM2JKxpsSWfu@google.com>
Subject: Re: [PATCH v10 2/5] KVM: selftests: Add KVM selftests header files
 for LoongArch
From: Sean Christopherson <seanjc@google.com>
To: Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 21, 2025, Bibo Mao wrote:
> Add KVM selftests header files for LoongArch, including processor.h
> and kvm_util_base.h. 

Nit, kvm_util_arch.h, not kvm_util_base.h.  I only noticed because I still have
nightmares about kvm_util_base.h. :-)

