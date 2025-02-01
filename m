Return-Path: <kvm+bounces-37009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31BC7A245C6
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:03:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA0573A7B8D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 00:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA0D8F7D;
	Sat,  1 Feb 2025 00:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dyEg4M1Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC032EC5
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 00:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738368187; cv=none; b=HSAg2AtvnCJdquSTN6TWiQe2X2qh0tA8e/aGbk3gU81hzAPMv8AkwwAmEDxrPqLAG728avBJyfTi3+Du7lPcs41xQYI9rOIWLZFeKfFehRe5zolXboLoH5GgA4poD7B7wGN4t13FRjuwyFS15pIegHGqkt0/my3Dg7RyV+Xl2sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738368187; c=relaxed/simple;
	bh=nZJVlCdmRP0lAKJJVm5PX7j7R6Vcdtc62Zz995WQx2s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q6ftPgvKSbiaJfAImUNacZRJSyZ5YRHsXOEArtiq4ZKO8Sa3QV2/JrLMDZ6uXlx0B0Lsun+WHuzFbwWRwNm/3K/Itj/4brr77mZSRWutB3mePvdX+MXsykziAT0xogViCV4DPa9/RJ9vWQQe94g37MKJm2GmR+PwRK1Yqev2VwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dyEg4M1Z; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3cfba1ca53bso17002855ab.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 16:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738368185; x=1738972985; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F1JcHKbseBSQb8NG0r+gxq95OxIlLZEymmmAoL2/PY4=;
        b=dyEg4M1Z7uoTj/Daz7L0m2PsroZZg3b7NO9v0VstKqLuPJdAWqdZltn+C8E/J1/l66
         EBaDYxn4JO2YpR3jojTkkSJhO2pHLbyLePct3/JfBTHngwuo8pS3uDor3uaWMINqSJyE
         oa7hAzdEQfBK+83LCMmUufgUSVuIjfNKfCvTn6+m/etEI7Jex+bUzIFKpsxL/EoPQz0e
         BAXlCjMyAV+be5uRtZpW2TXIgK7rulzfty39gx2mbCKUzLsIob0zS38rI/UpOXSLanoI
         +AYZYH7TODDzEceX6hLYdWFRptkFVzaF+woBa4xbmceufcNcxFt4cRbewW/P0qgHvXz2
         MVaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738368185; x=1738972985;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F1JcHKbseBSQb8NG0r+gxq95OxIlLZEymmmAoL2/PY4=;
        b=WddzHRuCDLGq33gXkI8ZqIexc0e2S1PMZngclgXZ46TKl92gLjQ5JCkymfszhBURfy
         HPBpT7gbu5fKUZsGv/JHnXlKTyC28u4Tile6Mfl//LsPc500SOcZYhvZ9HTqsIlOPsQW
         5t8FnHRflP3yRFuNfg9d/oSv1dYBf63Dmo315l5Vt9pBU89t88R1iy2j1dI/rV+goMZb
         mliKwfrR/gUiP8lm+/BSMh6zd2BWjO1DiiyPnfHq+oi4Pp7kkuweHfnKULOM1Ys9iOt3
         muVY/8Ri1LksZP9oJ9tms7g1aZLUsrAR2j16uxXNs8uzPsvNaBPVyas0nqEfAn5iLdMR
         VPQg==
X-Forwarded-Encrypted: i=1; AJvYcCWP85+DNwykg7RVk/HEDxjHiWRfOH7d/ZUiGLf1inaYixjshjHZ9u40e4cAdZH2mI9XITI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnUwVrOEy1kZg5zg0+0FnfHV57PJ6f0GnPJcW5T3SwblakOmBr
	WdW7P8cFvKXQRNFnF09rE+/aXpOGsRdvGLeXrUiZOALxVcA4ovAO1Kvm76IVSx/qkoO9/CK/OOS
	NuYDJDwqouShG1+HCfEeBpPXzRWQqvw==
X-Google-Smtp-Source: AGHT+IEqx3z+EHeDd3bWlItkM252Uw1JAvLH2WqXjgvlBL2XRhtrS0+yAASZ8fwiKIB88OJvaThmSDkrYspM0tlZMEwv
X-Received: from ilbdz12-n2.prod.google.com ([2002:a05:6e02:440c:20b0:3d0:1cfb:32de])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1c8a:b0:3cf:cb2b:bb8d with SMTP id e9e14a558f8ab-3cffe3e5e34mr114213175ab.10.1738368184746;
 Fri, 31 Jan 2025 16:03:04 -0800 (PST)
Date: Sat,  1 Feb 2025 00:02:57 +0000
In-Reply-To: <20250123002422.1632517-1-kevinloughlin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250123002422.1632517-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201000259.3289143-1-kevinloughlin@google.com>
Subject: [PATCH v6 0/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
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
v6:
- hoist WBNONINVD encoding into macro for readability; shorten comment
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
 arch/x86/include/asm/special_insns.h | 19 ++++++++++++-
 arch/x86/kvm/svm/sev.c               | 41 ++++++++++++++--------------
 arch/x86/lib/cache-smp.c             | 12 ++++++++
 4 files changed, 58 insertions(+), 21 deletions(-)

-- 
2.48.1.362.g079036d154-goog


