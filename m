Return-Path: <kvm+bounces-36307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E333FA19BBC
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 01:24:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AF8E16851F
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 00:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C591DAD31;
	Thu, 23 Jan 2025 00:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4mZ5GGi0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BC18F7D
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 00:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737591867; cv=none; b=DAxsVQi/1p43VxhhbyD4Kqd6AXYumFkkH+eE8d6KtwOxcfs3nsF/xqd2eGlv/Mw8cNBr7vYHgH9MXeV64Q4mB7Pwoy44GLTLqoOfO55zylMYKtYXydH4ZEVHOVjvfy0fohdjYTQDIRZwqOJF9sUu2m/RrGeuxkhQDTVbeY2ZWQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737591867; c=relaxed/simple;
	bh=VT8C7PphbWnEcRfBB2XLiIvR3tpz8zuHlpSE+6chUPQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oq+Wq88YWqRnKaq4zf+nZzfRkM/mOqMoO+8cNcqbXfvWz8bdgBslbF1DogoKyoUMLw2zwIOZEfZKtzzWLCQmSzyZ/3uSfbSZMPBjGG152Wk1BLnm7KOfB7c01e1Z7223JyiUQp4IE1kDsQeGGQNIK8woiG9SzuBnvvkFpQoI/fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4mZ5GGi0; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-84cb445557aso58397339f.3
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 16:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737591864; x=1738196664; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g3OuxUMXEzIiWdsgLhqOhmpVue2ZPAQkgWQJUbhZIiA=;
        b=4mZ5GGi0yt1tZlavYhSQNq13JX9Cw1T55QJSSjVJK21aIieoOjk/J1sEr8xBj7P8ad
         DQrhX8Rsh0KsqQ9EKDNjnHihcM1riSzvfLxLnq+kLLUsrbiKpBcGG7FPqOPgPyDgNgzC
         nBbFFSHIIaC87Mx9CTSeep7YSoKriUrbgVB6WX9WX5OrTxzMJCQlXZzvIDgL5euarlez
         z/RvTQEzrWi0WMqPZkaWa8jGxYprC+aMQr7e1uc78lm6+boK7LcRtF3qP655A7AE6S41
         6SBkVs6lv6tOknux4Fcs01Rvr7C2vOJbSHqpTiWXRFWoht45LMBJVSoihSHvuHOk/fzY
         xxrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737591864; x=1738196664;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g3OuxUMXEzIiWdsgLhqOhmpVue2ZPAQkgWQJUbhZIiA=;
        b=MbZbZcbh9gpCKlwW08FiXAwA/813sSmYOT9vzkAUm1NnP7ecprBj96GYZ8diMiPyOV
         AvlrbwmLg8luAv3sbGFDuCdh77hYWspQ2jTV0DvAbmkeTrVgRFoPyp82TTzsQMF1AlbU
         Hkxgqz7fU0qY2syVCNFMSGKjLmVNDdrnc7q2XhH5Lg0E8rACymNDoVvf5/dGj44eiKAE
         CLyOmbOKj09Ck0Mc9a3jzh66+uxtSMoXMxy1NViwYSKvMDlbhq4MZpodQ0/ug/BOu8av
         oZWBy7vCUA9vXFBdNcEyFAWapOUxO0PDnrn9k/rS8JX9tQStgmKt5CvbZwkdDUz3UIYK
         w3FA==
X-Forwarded-Encrypted: i=1; AJvYcCUlkBTyEJLD2imm7/5X3XYb2nyoDlLsRCyg0+XG2N7KMPLmtuFUxl5p4pYWnQYW9CIkW+0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4KU2eBRQnpG+URBlbLnkJaJHW/CVLCiqBeIAuWLzA5UWllp6o
	3EpdYy+br+sGWWP15j9VSTXabXCRiQdS7ZhN34nhUphKWoiAJvRXZLQiZzUd2RbRj29GA92IVxh
	/lsYVKKdhtnT17pU62wS5O1tol6Xutg==
X-Google-Smtp-Source: AGHT+IFfXBnog1I2SWOCfYfuCxWbWOI/cpXb9p3JcHzA+HOORWd3gLwmCECgbUkNCHK58ShrzbfNdDZRV3kTYHJTerZ/
X-Received: from iobgn22.prod.google.com ([2002:a05:6602:6416:b0:844:bc5a:b2d])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:6d8d:b0:841:8d66:8aea with SMTP id ca18e2360f4ac-851b617219bmr1900478539f.2.1737591864649;
 Wed, 22 Jan 2025 16:24:24 -0800 (PST)
Date: Thu, 23 Jan 2025 00:24:20 +0000
In-Reply-To: <20250122013438.731416-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122013438.731416-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250123002422.1632517-1-kevinloughlin@google.com>
Subject: [PATCH v5 0/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
From: Kevin Loughlin <kevinloughlin@google.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, kevinloughlin@google.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, ubizjak@gmail.com, 
	jgross@suse.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	pgonda@google.com, sidtelang@google.com, mizhang@google.com, 
	rientjes@google.com, manalinandan@google.com, szy0127@sjtu.edu.cn
Content-Type: text/plain; charset="UTF-8"

AMD CPUs currently execute WBINVD in the host when unregistering SEV
guest memory or when deactivating SEV guests. Such cache maintenance is
performed to prevent data corruption, wherein the encrypted (C=1)
version of a dirty cache line might otherwise only be written back
after the memory is written in a different context (ex: C=0), yielding
corruption. However, WBINVD is performance-costly, especially because
it invalidates processor caches.

Strictly-speaking, unless the SEV ASID is being recycled (meaning all
existing cache lines with the recycled ASID must be flushed), the
cache invalidation triggered by WBINVD is unnecessary; only the
writeback is needed to prevent data corruption in remaining scenarios.

To improve performance in these scenarios, use WBNOINVD when available
instead of WBINVD. WBNOINVD still writes back all dirty lines
(preventing host data corruption by SEV guests) but does *not*
invalidate processor caches.

First, provide helper functions to use WBNOINVD similar to how WBINVD
is invoked. Second, check for WBNOINVD support and execute WBNOINVD if
possible in lieu of WBINVD to avoid cache invalidations.

Note that I have *not* rebased this series atop proposed targeted
flushing optimizations [0], since the optimizations do not yet appear
to be finalized. However, I'm happy to do a rebase if that would be
helpful.

[0] https://lore.kernel.org/kvm/85frlcvjyo.fsf@amd.com/T/

Changelog
---
v5:
- explicitly encode wbnoinvd as 0xf3 0x0f 0x09 for binutils backwards compatibility
v4:
- add comments to wbnoinvd() for clarity on when to use and behavior
v3:
- rebase to tip @ e6609f8bea4a
- use WBINVD in wbnoinvd() if X86_FEATURE_WBNOINVD is not present
- provide sev_writeback_caches() wrapper function in anticipation of
  aforementioned [0] targeted flushing optimizations
- add Reviewed-by from Mingwei
- reword commits/comments
v2:
- rebase to tip @ dffeaed35cef
- drop unnecessary Xen changes
- reword commits/comments
---
Kevin Loughlin (2):
  x86, lib: Add WBNOINVD helper functions
  KVM: SEV: Prefer WBNOINVD over WBINVD for cache maintenance efficiency

 arch/x86/include/asm/smp.h           |  7 +++++
 arch/x86/include/asm/special_insns.h | 20 +++++++++++++-
 arch/x86/kvm/svm/sev.c               | 41 ++++++++++++++--------------
 arch/x86/lib/cache-smp.c             | 12 ++++++++
 4 files changed, 59 insertions(+), 21 deletions(-)

-- 
2.48.1.262.g85cc9f2d1e-goog


