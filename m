Return-Path: <kvm+bounces-58580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D4A1B96E12
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 18:52:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D950F3B6C77
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4EB328961;
	Tue, 23 Sep 2025 16:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LPSo4mPx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D388270551
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758646314; cv=none; b=nh7rxP9clu3m/eywRZlwc1KCXipdhGTRmmBDawdZh2zpj5emNNcvO43+xr5w0ck0kNmAc0MH5xmqTJbrkMYodC4kWr9i2LLndSDJDEz56d4FzrV+w/GnklXBiHisB/Kxy792tOskDEwwPZe//C478y+zkexYhIHghft/b2hlAxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758646314; c=relaxed/simple;
	bh=QxaQ7JYmW6SoppxdzNqff99uc2GQFsWJ8bkLHSqAb3s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ey09L40iyvVd/9a2mDCXcIS37isyDp8cjRJk+Ua/QANXTAU3tP4kvhZPlvvC3ruZWWH2zNHHsIDsFrT/JzsXGkc68OaLkwRJd5alZCVmI/L0jhN+q9S+L7riWic4lmQnyZu+DfGejkThHvSvEVDD3VOcKNA1HmOJ+RzfFJBxFfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LPSo4mPx; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-244570600a1so979555ad.1
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 09:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758646312; x=1759251112; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ttBHw83mBBKei73n8M/BNwMGiua/BJVn53tHa2ocQk=;
        b=LPSo4mPxcQBmLX2AxfdVcoMChvv9qDL2eJYwQwycq+jojs8BLMYioEl7A0s1AzStOU
         d1TmKNfAHQxRHqOvcz899ft7JxAUkbqrwEEfAIP5wLseIZ0nbMAnmjoU1/vDzA8SsRgw
         FXVivT3g/rMK4pNlgzwuJWfgdDeizVh7Kakt2kDYR7IZTVCA+8selkmCxunsWoYhUjCL
         iJHBrbGMGceLDcB1Gfr4urQ77S9lftua0Q6YKPixXhEVwBtlmKLT4Bk0+UxX4tXIccPO
         oKMDOTvBERghPev+LEq+5UlYv75KZC3C0bARozsGDukQCUl+Vqm6nUwDZQ51DZbbqp3t
         jA2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758646312; x=1759251112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ttBHw83mBBKei73n8M/BNwMGiua/BJVn53tHa2ocQk=;
        b=itLmWKsJE8ruRT5Os0zjwfiGvrmVHP1m/Mr7zWw0Smhtz890l3PF9KO+LKWIW7999K
         njqX8bFXXA5XQ5YA1Q4/1cDclZjZcK6iq/ZFumaLt3GBKSNDYJ6VWf7XwnFi4VdeJ700
         7I6s8EBl/OwI8sr6rwxlWWfjzyMZwAiLwyW91kVWFvrH/qVioZMIsC6QznaodvUP+GF7
         hFhAXX8QsW+JNhQ796xGKtmq6guJODi2qwLF4lOE3dAzz47sxPcHX/Iv2FAc5zssOasP
         1mdpfqKMSRX4unJSRO2hDKGmgL1k367xwb2KVhYEhM0JpwstKeaIddQACScVaeKWuCA5
         Ac8g==
X-Forwarded-Encrypted: i=1; AJvYcCUeNrdHUwwiXqi9K5DboLJJ36zr8nO8KNzcefjRZZsAigvvF4kiZglhyFaFGpPmWhzYfjU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXKe1k26oc5eHiQD0A9TBtNFUq/HgmTKVDGW58oeSYR/6fNSb3
	1VnBcq/fFIpJ7xj6SK6ktPYecZzeV9wwFoGkcdtag+T2zkuRByp2GWLiW4Woi4M2u5/P7+JIZnL
	SaKhcSg==
X-Google-Smtp-Source: AGHT+IErnPS2OUnE/M9s+uEMA4ws/sYHBVcLuOlMX+nidzjdFfhtmVnknKhA38KDZ5Q4wlGtCqW08/b9loo=
X-Received: from pjp3.prod.google.com ([2002:a17:90b:55c3:b0:327:dc48:1406])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2c04:b0:266:57f7:25f5
 with SMTP id d9443c01a7336-27cd6c9dec5mr45739465ad.7.1758646312450; Tue, 23
 Sep 2025 09:51:52 -0700 (PDT)
Date: Tue, 23 Sep 2025 09:51:50 -0700
In-Reply-To: <aNJUPjdRoqtiXYp+@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com> <20250919223258.1604852-46-seanjc@google.com>
 <aNJUPjdRoqtiXYp+@intel.com>
Message-ID: <aNLQJu-1YZ7GYybw@google.com>
Subject: Re: [PATCH v16 45/51] KVM: selftests: Add an MSR test to exercise
 guest/host and read/write
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 23, 2025, Chao Gao wrote:
> On Fri, Sep 19, 2025 at 03:32:52PM -0700, Sean Christopherson wrote:
> >+		/*
> >+		 * TSC_AUX is supported if RDTSCP *or* RDPID is supported.  Add
> >+		 * entries for each features so that TSC_AUX doesn't exists for
> >+		 * the "unsupported" vCPU, and obviously to test both cases.
> >+		 */
> >+		MSR_TEST2(MSR_TSC_AUX, 0x12345678, canonical_val, RDTSCP, RDPID),
> >+		MSR_TEST2(MSR_TSC_AUX, 0x12345678, canonical_val, RDPID, RDTSCP),
> 
> At first glance, it's unclear to me why canonical_val is invalid for
> MSR_TSC_AUX, especially since it is valid for a few other MSRs in this
> test. Should we add a note to the above comment? e.g.,
> 
> canonical_val is invalid for MSR_TSC_AUX because its high 32 bits must be 0.

Yeah, I was being lazy.  To-be-tested, but I'll squash this:

diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
index 9285cf51ef75..345a39030a0a 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -48,6 +48,13 @@ struct kvm_msr {
  */
 static const u64 canonical_val = 0x123456789000ull;
 
+/*
+ * Arbitrary value with bits set in every byte, but not all bits set.  This is
+ * also a non-canonical value, but that's coincidental (any 64-bit value with
+ * an alternating 0s/1s pattern will be non-canonical).
+ */
+static const u64 u64_val = 0xaaaa5555aaaa5555ull;
+
 #define MSR_TEST_CANONICAL(msr, feat)                                  \
        __MSR_TEST(msr, #msr, canonical_val, NONCANONICAL, 0, feat)
 
@@ -247,8 +254,8 @@ static void test_msrs(void)
                 * entries for each features so that TSC_AUX doesn't exists for
                 * the "unsupported" vCPU, and obviously to test both cases.
                 */
-               MSR_TEST2(MSR_TSC_AUX, 0x12345678, canonical_val, RDTSCP, RDPID),
-               MSR_TEST2(MSR_TSC_AUX, 0x12345678, canonical_val, RDPID, RDTSCP),
+               MSR_TEST2(MSR_TSC_AUX, 0x12345678, u64_val, RDTSCP, RDPID),
+               MSR_TEST2(MSR_TSC_AUX, 0x12345678, u64_val, RDPID, RDTSCP),
 
                MSR_TEST(MSR_IA32_SYSENTER_CS, 0x1234, 0, NONE),
                /*

