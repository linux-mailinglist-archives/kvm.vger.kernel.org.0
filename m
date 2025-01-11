Return-Path: <kvm+bounces-35140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20DC2A09F2B
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B1853A5ED6
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A546024B251;
	Sat, 11 Jan 2025 00:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o0S55dFY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F88137E
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736554826; cv=none; b=SmaNwKuDZxwS5MExiqcr4j6N/w7zdlQyDWDNDTXDGeYssVCk1hdwksBS0LBA5fBW/XmxAEOLBeMqUbLLL2tbDGD9rxeK3qZZGXO/HqBgH59zcYkCQqqHN4/fscdNyZR4ibrn3Sd6JRpgIcsP2aUZQCP7ztwtT7gRy9jTioBC38M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736554826; c=relaxed/simple;
	bh=A5Y4W+H1gu8uevtQGQ03WrHjORd5ZD3rFpa2fC4MEwk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Xy7eg7SPBk9UchJV5DkTbYSmqwmExz+5KltJfhZb6EXTKf7fKJ/xlI6wXEN36FZ2Z5h4diRfq4ifOHUsmkaMiKPi4H631SU4qNNpGvlmIeooyVG9zHXmtUTlfIhDV7/AN2DI4T18+kXHeY8G8/EW6BuhSRIsmaQnwtO/077fG0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o0S55dFY; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9204f898so4588948a91.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736554824; x=1737159624; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K3wBbkFjTfD0PF3+R9DJiAJiHMTzKPa4NFqvYtMwDUM=;
        b=o0S55dFYM4SZ0zLmg6MeCFDtLeWW8EQzL1AVGrr/qLJu/6bnskKzlXOzUgCgYZrXPd
         Tcsp+/4AUMxNWwVBsfnqfdiJ5Qc+1xMtttxTMc7JkQ73hRS7OyOLuVr4w252HeZ4+Q89
         /yAF87BCDNrizCd30Wry+L4MZAH/NldqDAI5tV1Mt9zuBFmMsWu/9ZFbRBqIJqzPotzg
         4wcBDJVQgD9kmdnyHfFNIVZcJk7DXCiKRgVIO9FRVyO4mlc6+hf2SgWAvKrbNVzbwl8s
         BlvurnL3sNggqm+Zm64Y8axCdO9BTAJzjx4naMugkgsOPvJVITRNtybV/XRcVcu3LzAk
         PlBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736554824; x=1737159624;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K3wBbkFjTfD0PF3+R9DJiAJiHMTzKPa4NFqvYtMwDUM=;
        b=auw70aygw2EefWkrav6HErp3B1E8mfZwsqMsLwqn1T6t8i8b+LaMPMvD6HmsNXnVni
         RbVGXPhTZT+Y8gXTMuw65lGZz5+s7H8YNFggxvEDd6k/UEDBMWB4tVSJQMCEL9b3nJW6
         B3Y+xuthn/NnjTpSNh0JMBmxitmmIqIWZKnRgtlUREZm831jn0nKtJT+9x+snLr/UeD0
         NRpi4EeBvsnuBAauj1gm/cJ9g9iCHGMn1GL3pG0aIF8j5J4cdu1c6iOo5O1KM7qFDmVD
         NFnrnl6YzAsfi6ZBdEiXaAu+pH6/0sMuJ15cMeR5zydg9Jo1H4JIA2d8krZlVPh0Denm
         6GrQ==
X-Gm-Message-State: AOJu0YzF59ClfsvvXaciSQ4zMuNxg1/YaXZIWPvXnfnKgctTZt9gWsSG
	CSIjHIofRqDIJIVQoJlw+L663WHzsE+czf+hy8VYY2rfjQjWOktkz4debrGMEOLb2r4j4kzDaO+
	g6Q==
X-Google-Smtp-Source: AGHT+IG7Uz/pDiD7QRuArbJZSu8qtKQBmxt3AdJ3IHilJfXXMXrsHodTYgjoPGDi10fCjT4cUmWTRJJqc0o=
X-Received: from pjbsu14.prod.google.com ([2002:a17:90b:534e:b0:2e2:9f67:1ca3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3bc3:b0:2ee:d024:e4e2
 with SMTP id 98e67ed59e1d1-2f548f0feffmr19500335a91.7.1736554824701; Fri, 10
 Jan 2025 16:20:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:20:17 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111002022.1230573-1-seanjc@google.com>
Subject: [PATCH v2 0/5] KVM: kvm_set_memory_region() cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tao Su <tao1.su@linux.intel.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Cleanups related to kvm_set_memory_region(), salvaged from similar patches
that were flying around when we were sorting out KVM_SET_USER_MEMORY_REGION2.

And, hopefully, the KVM-internal memslots hardening will also be useful for
s390's ucontrol stuff (https://lore.kernel.org/all/Z4FJNJ3UND8LSJZz@google.com).

v2:
 - Keep check_memory_region_flags() where it is. [Xiaoyao]
 - Rework the changelog for the last patch to account for the change in
   motiviation.
 - Fix double spaces goofs. [Tao]
 - Add a lockdep assertion in the x86 code, too. [Tao]

v1: https://lore.kernel.org/all/20240802205003.353672-1-seanjc@google.com

Sean Christopherson (5):
  KVM: Open code kvm_set_memory_region() into its sole caller (ioctl()
    API)
  KVM: Assert slots_lock is held when setting memory regions
  KVM: Add a dedicated API for setting KVM-internal memslots
  KVM: x86: Drop double-underscores from __kvm_set_memory_region()
  KVM: Disallow all flags for KVM-internal memslots

 arch/x86/kvm/x86.c       |  7 ++++---
 include/linux/kvm_host.h |  8 +++-----
 virt/kvm/kvm_main.c      | 33 ++++++++++++++-------------------
 3 files changed, 21 insertions(+), 27 deletions(-)


base-commit: 10b2c8a67c4b8ec15f9d07d177f63b563418e948
-- 
2.47.1.613.gc27f4b7a9f-goog


