Return-Path: <kvm+bounces-50546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52F51AE6FEC
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:43:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7064317BF14
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B152ED85D;
	Tue, 24 Jun 2025 19:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p+Y8pUAs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9942ECE8A
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750794101; cv=none; b=Smk+xw3vKyUF8S1M8+2ezNXVv+GnIAMVtbWjh3CPvjmHHVh9AVNUrwqN3qYoLdgg3M51HdSOFuPFIegBpBTPgO+tK59T9grcp949q4etl7amEpyRdm1vLkEFTwuR7IaCxEMbdInqwvTFlHYGd8VCoE6gH2dY0E+SFs2jd2QBVPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750794101; c=relaxed/simple;
	bh=EnSuPTvF4DhnwZO1Ijbg2f9PLrxOuT35VfH6B31Xb+4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P01U2ocIjlEBEagk7AyINX48uktJpifkl5VveX0378Q4k9FDBOsNiNW8y0VpB/EUUCokp0bzULx7kwfPvmWf+Z8jdYxFZQ5TBRF9/PheAlTTLPOwMwYLQPqRrBco99WxeMBtN2dF/d01ynGZJc4PPwSvyLTqHio0YpYWdbjoNUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p+Y8pUAs; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313d6d671ffso800150a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750794099; x=1751398899; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/TcDR0ilC08SnX/gngiJov3sYl1/0VcHc8Gnu/5DjpQ=;
        b=p+Y8pUAstNDnqNeT2taK+wDdjfyHqZwQGkytolXDoadIaFlgE9pgHoD5jXpON8KqRj
         OIRUZYBX+Pn0E1aDCAxPR5nSbdtS/MhqMaegtDFvqCe6hU/MZT8B0Rpa02dph5M129DU
         LtCEDybmWO9ObWugIjWWWuKrB9NVdjI1pa9x+o0BpJOwCtuOSGEkYW7PF9fN9lZ+XXWT
         FJtRjFEy32M0dYYb/QsIUDiKPQyakbDcGHDvsMZ25GRU0hoHJWP26O1EUwvCoc7D7jn2
         hNXnqFcMvVUYYBwtGgr60PaPJmrdUTIZVFM8do/Uc2tkZn+CK5/1Nl9mxD1dIV/tZWKL
         iu7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750794099; x=1751398899;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/TcDR0ilC08SnX/gngiJov3sYl1/0VcHc8Gnu/5DjpQ=;
        b=uOqH25BjpQrKtaDn8qHQm2Nh8Ah5VmA4jHXmApqPVib7Q+O/JoiwU4vk2PMETLS/XL
         nhTJN3uX0WOF+sYZMb+i9o+e2qhIxiRr9K2Kc3z5qExF3pgf5hefhYY0o0rr06B+372s
         nyKXPLoxkNzrZ/bRbEuoizQbZX7cKgrpqw4umbCuTYtBOTVqabRY9zIPcWLARd2lGKDa
         ejkrzWN94eg9EEudgt9qP6qbHqusMULA2MnLy6ShKm09nS9N0sWI+jom1O869DMFnZY2
         3rEnbimCSvdXkAQV3IOSZLVgQPqMj+lG/Z635aUXZzfv6FS5bjhVzR+fdFdDNd2uZXT9
         w/jw==
X-Gm-Message-State: AOJu0YyDhEd7PDC5poVftjIHFczYDEgcJKMOxcrApVM176NglTD5EkhI
	kgSOzumNvf3owq7P8i8W5KvlSNrL637MMQzVRgYuEKi/LanFJlAH4FchfVwbpF62hC1ffA9lIDe
	BthnNIQ==
X-Google-Smtp-Source: AGHT+IFbBoWMRk0OScINUnw6Tc/wO2MzRodBFr/PyAQsm0W8Pkgc1eEhPr2RMhZpwxAHIhiM9y/OwUpIO2I=
X-Received: from pjbsc5.prod.google.com ([2002:a17:90b:5105:b0:2fc:3022:36b8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c85:b0:312:e6f1:c05d
 with SMTP id 98e67ed59e1d1-315f25e7388mr192262a91.2.1750794099336; Tue, 24
 Jun 2025 12:41:39 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:38:30 -0700
In-Reply-To: <20250605195018.539901-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605195018.539901-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <175079323951.521058.7931806146009208206.b4-ty@google.com>
Subject: Re: [PATCH 0/4] KVM: x86: Fix WFS vs. pending SMI WARN
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+c1cbaedc2613058d5194@syzkaller.appspotmail.com
Content-Type: text/plain; charset="utf-8"

On Thu, 05 Jun 2025 12:50:14 -0700, Sean Christopherson wrote:
> Fix a user-triggerable WARN that syzkaller found by stuffing INIT_RECEIVED,
> a.k.a. WFS, and then putting the vCPU into VMX Root Mode (post-VMXON).  Use
> the same approach KVM uses for dealing with "impossible" emulation when
> running a !URG guest, and simply wait until KVM_RUN to detect that the vCPU
> has architecturally impossible state.
> 
> Sean Christopherson (4):
>   KVM: x86: Drop pending_smi vs. INIT_RECEIVED check when setting
>     MP_STATE
>   KVM: x86: WARN and reject KVM_RUN if vCPU's MP_STATE is SIPI_RECEIVED
>   KVM: x86: Move INIT_RECEIVED vs. INIT/SIPI blocked check to KVM_RUN
>   KVM: x86: Refactor handling of SIPI_RECEIVED when setting MP_STATE
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/4] KVM: x86: Drop pending_smi vs. INIT_RECEIVED check when setting MP_STATE
      https://github.com/kvm-x86/linux/commit/c4a37acc5193
[2/4] KVM: x86: WARN and reject KVM_RUN if vCPU's MP_STATE is SIPI_RECEIVED
      https://github.com/kvm-x86/linux/commit/16777ebded41
[3/4] KVM: x86: Move INIT_RECEIVED vs. INIT/SIPI blocked check to KVM_RUN
      https://github.com/kvm-x86/linux/commit/0fe3e8d804fd
[4/4] KVM: x86: Refactor handling of SIPI_RECEIVED when setting MP_STATE
      https://github.com/kvm-x86/linux/commit/58c81bc1e71d

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

