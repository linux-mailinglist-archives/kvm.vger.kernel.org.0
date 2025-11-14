Return-Path: <kvm+bounces-63165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A83C1C5AD69
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:48:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DF983B61F3
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C49242D70;
	Fri, 14 Nov 2025 00:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EmB8hTwc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE59921ADB7
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763081257; cv=none; b=oZ7zcJU0i1lEdEJ/iljORtQHk+MWRzthEyAIlyCYUGb7lZrzaYihJ4r/Uj26E9+bqUX8Nucs4p/kasPsowAv8+g/CsLBP81QdsXcTZgTcUKC4ZhXK8RrODZwn5M5qKXAriM9OXx4wHVo74g70Ai1gboENhdWTOhlbbHfPO58IAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763081257; c=relaxed/simple;
	bh=sUIkTimVmMzrn6W3mfZBB4kEtJCeeFQ76IKk5QMtTu8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tNo2k0UEKXWlp6LE6hSmzv6As+iUzXsqIdnL5NPjyYkrdQYsAIFpClrleixmifeu8JKdq5jblH+R2g1a5Znn7k8ZKYa3TGWz3oxFAxSZE8d6XS8a45SOI1eLVgDEVArwyw6pf8+cJUGph70/TSVZDY/Xb1/pcYfCCVm/lPdhIBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EmB8hTwc; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b8ed43cd00so1797047b3a.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763081255; x=1763686055; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V89RgdOCB2GTsttfBVIttwbOk7GKNXKV4z2HImGCsug=;
        b=EmB8hTwcgy0ZpY+0TRrUMeFObqcGLoFIgyES0o2lfKKxhafVJBvdtRgg1mMXPdHyNy
         JZ/y3ONFD/3kLmtc0T+zup82PLBL3/jr2uIdTUX/im/Cfpjms7m1a39J6vfZQTi1dvTo
         nHZZJsGVjG7Z3g0Y9TB6hnHKMNzrlOszo3RlwCJ7KQEdcC8v/tqMaHT2FRmafHxr2t0n
         rLxm0kkbvrz3aK7rcXezvtspQnrC3zjHqw/BDM6T6YE99ThHDuTzpVJeZAx9sT45LS12
         IflIpKYTXzaOFuPwJwo0cKpDJzyGVVrsWKok4IpPljZxOOeRce3aj0pLuGnD0HtPvouz
         TQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763081255; x=1763686055;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V89RgdOCB2GTsttfBVIttwbOk7GKNXKV4z2HImGCsug=;
        b=Y7PrUlcDqe/2DqHgcXHuSYDLGKhXAyPQS5UJD9+o1+X0gJlSCpDzA3q3ot7X48+0kn
         2+YfZKMzsDxhzYYTQ8BQFkXXrr73of6bUGjw9F1PKHo7llQjygqma6cQroDESa9/tXtF
         VPZrEVMaMgmTxZTn0OqFmbAz0bkrgt/rlgvjcOUQ4gqt85GdD5Cjov998C7JDaXspI4J
         hCb1pzIlXgd5zgS+HEtajYmJM4Q3ujXimAPKttJ/+n/Im+xNPJxEaLyk79RK8ZfDs5vP
         u+GvyeJPlDQHedlAMGXu4b8u+HccawLg4DL3P7I+1pg96kZb3hsh2SyYPMRTfdkXRQYE
         RehQ==
X-Forwarded-Encrypted: i=1; AJvYcCUr0FekNisY5x/FD1EQxehRRj4LvRX08HGH7itl3B1TvakoqgNdErJNomNQPEkhvpmBW0s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3Z2RsGSF1iUH+tZ/cmCAOsRPdZzr9SZyBYZd//WENlkc5gFwW
	k1JEQf8P21zAYLwFb6dO4j3E5gLqvvubbi1Ruyqky6kCL68SyA7Xw4FwN/iKlYvJO0HIF/JZRQb
	AJmmv6g==
X-Google-Smtp-Source: AGHT+IEBCcYi5IXDXywof+v46PCd55ao3/mcwgvVYMuI7wXX2ywbYjLb9BpsFLUUUpZ04U2oievz0raOPeA=
X-Received: from pgc28.prod.google.com ([2002:a05:6a02:2f9c:b0:b49:d798:eefa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f81:b0:334:7bce:8394
 with SMTP id adf61e73a8af0-35ba2c7f49fmr1832396637.51.1763081254828; Thu, 13
 Nov 2025 16:47:34 -0800 (PST)
Date: Thu, 13 Nov 2025 16:46:13 -0800
In-Reply-To: <20251110232642.633672-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176307992383.1723017.8674241803582531057.b4-ty@google.com>
Subject: Re: [PATCH v3 00/14] Improvements for (nested) SVM testing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 10 Nov 2025 23:26:28 +0000, Yosry Ahmed wrote:
> This is a combined v2/v3 of the patch series in [1] and [2], with a
> couple of extra changes.
> 
> The series mostly includes fixups and cleanups, and more importantly new
> tests for selective CR0  write intercepts and LBRV, which cover bugs
> recently fixed by [3] and [4].
> 
> [...]

Applied to kvm-x86 next.  In the future, please only bundle related and/or
dependent patches, especially for one-off patches.  It's a lot easier on my
end (and likely for most maintainers and reviewers) to deal separate series.

E.g. if you need to spin a new version, then you aren't spamming everyone
with 10+ patches just to rev one patch that might not even be realted to the
rest.  And having separate series makes it easier to select exactly what I
want to apply.

Concretely, at a glance, this could/should be 7 different patches/series:

   1, 2, 3-5 + 7 + 10-11, 6, 8, 9, 12-13, 14

[01/14] scripts: Always return '2' when skipping tests
        https://github.com/kvm-x86/kvm-unit-tests/commit/1825b2d46c1a
[02/14] x86/vmx: Skip vmx_pf_exception_test_fep early if FEP is not available
        https://github.com/kvm-x86/kvm-unit-tests/commit/cab22b23b676
[03/14] x86/svm: Cleanup selective cr0 write intercept test
        https://github.com/kvm-x86/kvm-unit-tests/commit/5f57e54c42e6
[04/14] x86/svm: Move CR0 selective write intercept test near CR3 intercept
        https://github.com/kvm-x86/kvm-unit-tests/commit/0fa8b9beffba
[05/14] x86/svm: Add FEP helpers for SVM tests
        https://github.com/kvm-x86/kvm-unit-tests/commit/1c5e0e1c75aa
[06/14] x86/svm: Report unsupported SVM tests
        https://github.com/kvm-x86/kvm-unit-tests/commit/d7e64b50d0e3
[07/14] x86/svm: Move report_svm_guest() to the top of svm_tests.c
        https://github.com/kvm-x86/kvm-unit-tests/commit/9af8f8e09dff
[08/14] x86/svm: Print SVM test names before running tests
        https://github.com/kvm-x86/kvm-unit-tests/commit/044c33c54661
[09/14] x86/svm: Deflake svm_tsc_scale_test
        [ DROP ]
[10/14] x86/svm: Generalize and improve selective CR0 write intercept test
        https://github.com/kvm-x86/kvm-unit-tests/commit/cc34f04ac665
[11/14] x86/svm: Add more selective CR0 write and LMSW test cases
        https://github.com/kvm-x86/kvm-unit-tests/commit/09e2c95edefd
[12/14] x86/svm: Cleanup LBRV tests
        https://github.com/kvm-x86/kvm-unit-tests/commit/114a564310f6
[13/14] x86/svm: Add more LBRV test cases
        https://github.com/kvm-x86/kvm-unit-tests/commit/ffd01c54af99
[14/14] x86/svm: Rename VMCB fields to match KVM
        [ WAIT ]

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

