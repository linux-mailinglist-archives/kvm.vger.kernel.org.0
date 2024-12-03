Return-Path: <kvm+bounces-32865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 700879E108D
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEBC0B21997
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 01:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FDC22D613;
	Tue,  3 Dec 2024 01:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a1F80d6I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE658288DA
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 01:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733187609; cv=none; b=hxhM3+WbkVub4ylTHWLevlbGFPVmmYO1KkQFcoLgJ3Cu+3U7Jnss264HvUWQL99jGCzJ/YTZq/KpEsGIXiu9Pf2NUABPVafX1Gnqc2KsHW92LcqwBTLmjRdQLfgrRtZjwr/XxnrMVwsfT6fkfh7bhJBUzZF78JmKW2OVlwmn9rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733187609; c=relaxed/simple;
	bh=tt1n7+zJzjSkuUlJGp2Vz5ZrLaY83PHy98RvVR/1bSU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=D3vaXS5yq3moGkTywB0wJfuzVYhkHKoCqdUuMlmNPHx7Ofr2tHki9yGaSowE/QiKMTvmADRB2Z5pEHREwELWHGM77tbERTC2IHgM7lRkIrqc46cfAPKA2DtuiS3lIPVCLlq82iezUYwbAPuDmpbX9M4zWNEpTs5G2Z7ul08czgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a1F80d6I; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-843faa97bf9so466279039f.3
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 17:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733187607; x=1733792407; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gPDpv/chkg5p0fi43rAQfMRL2kKLevnRZ1FyVaa7akc=;
        b=a1F80d6IosIzBRDYlQ6UzkJVB/Em3nazPeHGjmLlECodPis5+Muy1lpjUcinbg3jZr
         YNcRt8BrLaIlBXsE8Im0SpB+gwi/ReiG6jDQEDrFNI0XP32AZlFEspmaFYz0iV8T2mC3
         6JdBRBI0MvoaaH1qUu97PeFeKev7cUGBJ0tzIvBm82vmpEcKRh3YIyhevEs81nPfdCRA
         c9yjFsRgclzdsM+/QXd0iJbqPGmQ+Fmk+pKr0K9rtGeEgymGyfqYLxXJyM1Cd1UwnxbW
         k7532RuXmuxis3sLcSIKtG2sbK3bt9F8m8TjK3fvDGzidZAbaOWHMzvDTixUqafqME4E
         DRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733187607; x=1733792407;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gPDpv/chkg5p0fi43rAQfMRL2kKLevnRZ1FyVaa7akc=;
        b=mMHtq+6NMzD7/YlrTNPfR6TKvGqi0KJM0vXSJe6UGqlNIEnI1nOtYHntomF0LvQOSd
         CKswfwN3tsz9w4VEmqywHwKbV4Gc3DNLOk3koQNKZ/kx30N4PaE980MSaWWFkaphA6ll
         UAFZwbEgTF67AhG5IX9GAKWNZSnUYkEM6RsDhcr+prYH9kb00CFwcD9rm7fYOwMaU609
         84L9lWVNUj1pxb+YQCP6KxERwLnK3vU48kJ2muXnZyRIyp1wg6469cVCudbcHAIMEdyR
         8ZsTivsdHwuBLxPhzisoXLzj0GyBtvl1dHcrE7uSPsow63Q40zOwfqDEYNfU6dcNPh07
         vr0w==
X-Forwarded-Encrypted: i=1; AJvYcCWL3I/mJsa9cAAHNR+eUtmBMLrI/NBhi25z+Q+yiK8RZIlE9hQbA17RgDaRNMAayeydv3M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEawhmrlQr1wmk6zo9uwimPsca0N9dNqzeNzJyXKSTsQaF7y1/
	+BeEHO5Z7j1izxfgD39bRTTJIQJkNr62OS+mY4mKpNAJJWwMgxzQTa4sfPDwtX6OvYlagcRDrIR
	WLV6puBu7NmwmaBNN/iNrllVBEd6M5A==
X-Google-Smtp-Source: AGHT+IHqJwhD7dDrPHnnwi0nKSyWpAXx88t8MplXy6qAA9f67EUD1JW80naumNLzsou5U5ZEc/gbCz70e8AwEIt7ij7T
X-Received: from ioay19.prod.google.com ([2002:a6b:c413:0:b0:841:802b:8e24])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:1546:b0:82a:2a67:9429 with SMTP id ca18e2360f4ac-8445b554fbbmr110164539f.5.1733187606796;
 Mon, 02 Dec 2024 17:00:06 -0800 (PST)
Date: Tue,  3 Dec 2024 00:59:19 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203005921.1119116-1-kevinloughlin@google.com>
Subject: [RFC PATCH 0/2] KVM: SEV: Prefer WBNOINVD over WBINVD for cache
 maintenance efficiency
From: Kevin Loughlin <kevinloughlin@google.com>
To: linux-kernel@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	pgonda@google.com, sidtelang@google.com, mizhang@google.com, 
	virtualization@lists.linux.dev, xen-devel@lists.xenproject.org, 
	bcm-kernel-feedback-list@broadcom.com, 
	Kevin Loughlin <kevinloughlin@google.com>
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

First, provide helper functions to use WBINVD similar to how WBINVD is
invoked. Second, check for WBNOINVD support and execute WBNOINVD if
possible in lieu of WBINVD to avoid cache invalidations

Kevin Loughlin (2):
  x86, lib, xenpv: Add WBNOINVD helper functions
  KVM: SEV: Prefer WBNOINVD over WBINVD for cache maintenance efficiency

 arch/x86/include/asm/paravirt.h       |  7 ++++++
 arch/x86/include/asm/paravirt_types.h |  1 +
 arch/x86/include/asm/smp.h            |  7 ++++++
 arch/x86/include/asm/special_insns.h  | 12 ++++++++-
 arch/x86/kernel/paravirt.c            |  6 +++++
 arch/x86/kvm/svm/sev.c                | 35 +++++++++++++++++----------
 arch/x86/lib/cache-smp.c              | 12 +++++++++
 arch/x86/xen/enlighten_pv.c           |  1 +
 8 files changed, 67 insertions(+), 14 deletions(-)

-- 
2.47.0.338.g60cca15819-goog


