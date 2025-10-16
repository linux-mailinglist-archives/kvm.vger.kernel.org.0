Return-Path: <kvm+bounces-60232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D84AABE5AD8
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 84A3D353D87
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 22:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BDB2629F;
	Thu, 16 Oct 2025 22:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sz2ZNN+u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1562DE1FA
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 22:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760653701; cv=none; b=sALG+6dHbXCDIKkFeOV39zwCoIP+8FNsszAjTruiLgsDuuDPtyGQwf/fLotqSPEWsU7mNWw27YN9bt/aTlSUEuMiyHy8ZNxMm99SOhPzzxigLsHGzMXuOy7CFHeD80s2F99ismKB1imJpJjGr8QHVvmV8PqV5boja0uJA+pH5hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760653701; c=relaxed/simple;
	bh=bawSMseT0CqNbdyIWWkFAuACxkZoXEqOQliCkUUeOWE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NneTMHmON8hN09CLeNddyG8APCU1A6r+FK43wDq0/GItww4R4gd9aTh9Rn7qoCQqNc6slk5bX/m2UBy1bGBhUEmNT6H5+dLF6HDYtoX7KHZZ2M4eJDj0zLGG0bbiS6T67RSOAtTGgqVReaucOnFYMS/FEUjtGqHV85wz5xacbIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sz2ZNN+u; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b5516e33800so1802345a12.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 15:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760653698; x=1761258498; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ohe5whqaVI6MNw62Ja9bMHiL/FYf6oWYICNGFV1EN3Y=;
        b=sz2ZNN+ueNY884xvq5mFUbzfwyCcaK2dBMqNdvBlfNxzgkf/Z6sN9Z9wawRIwGxa5R
         BTfV40YRLgMFRQFhtOA29q/xxqMzUCn3/Y2YP94emUI/5M/Q5ddfVheOFFstzn7BhPWJ
         E5wXQOIX4n9o7M4oVMn6WXRxvUEybyhb6a7XGxody6dvCDui1HTGL0obMnFUH7Cz0sv8
         Rne/s/swHuabJZmez+SfJpjPhxjUh+aXtd0Ac6ZhKJqAG2r2wQ0IsUi9Xu9ZHCb83oLG
         mCb3z2eE/CVAgzGlfw7kVbhQGRgr6/+2VQcVkuwCdttm7EaJT9DRFo22QBIIvO9NaNY7
         niCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760653698; x=1761258498;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ohe5whqaVI6MNw62Ja9bMHiL/FYf6oWYICNGFV1EN3Y=;
        b=J44IJufb+KTMCgfqmUslDCMvgmN2VB71jhOrvaHBolctnVNkumt6mM65EKBqXurg+l
         1mRs7FU5nBvi1n2emNSu92XUtWZji/Dr2a1kZ3iZaP001/iQfSk4k1uRk8zdRB+R5FJr
         q+NO6EGI7+j19W1o+PixHfM2/BNT7O6DbA/L/W/dy3dvBAf7hFf3ENYRDY5KUWk9HZj+
         W096C0CjPSv+XqUo4sYQshd/o3Q9zydIUH+OhE9FTcdSkKLoZuwbBI1GEp1Jgi/PXOby
         DaOzzqF2fsqXfL39k7WOgaRIVJMFsClVRThHN0VFsRS/Yrgv/MqZ3l+dpBvuOawMF1F+
         pd7w==
X-Gm-Message-State: AOJu0YxdMVzxqVKLscqH6S16D7+V4B2620hvOf9+Ckcnop8XLNYz0M7b
	De/7ASpj3Lw/aSBSVeYG8KxqBMQ5nmqVsvvyj483TAXmKqqXs8tPpU7bthI4WojzeYRUiTN2DFl
	6bahPRw==
X-Google-Smtp-Source: AGHT+IHEsNMvTZlam2jisTHrsVJg/i/9Fu9TLaM2OcVaUKqK6KMKAv8tlmP6fh1nAXeNkUWB5CqnY8FjWds=
X-Received: from pjsc4.prod.google.com ([2002:a17:90a:bf04:b0:33b:9fa3:a535])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:244b:b0:334:7bce:8391
 with SMTP id adf61e73a8af0-334a86500d6mr1818085637.56.1760653698581; Thu, 16
 Oct 2025 15:28:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 15:28:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016222816.141523-1-seanjc@google.com>
Subject: [PATCH v4 0/4] KVM: x86: User-return MSR cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

This is a combo of Hou's series to clean up the "IRQs disabled" mess(es), and
my one-off patch to drop "cache" from a few names that escalated.  I tagged it
v4 since Hou's last posting was v3, and this is much closer to Hou's series
than anything else.

v4:
 - Tweak changelog regarding the "cache" rename to try and better capture
   the details of how .curr is used. [Yan]
 - Synchronize the cache immediately after TD-Exit to minimize the window
   where the cache is stale (even with the reboot change, it's still nice to
   minimize the window). [Yan]
 - Leave the user-return notifier registered on reboot/shutdown so that the
   common code doesn't have to be paranoid about being interrupted.

v3: https://lore.kernel.org/all/15fa59ba7f6f849082fb36735e784071539d5ad2.1758002303.git.houwenlong.hwl@antgroup.com

v1 (cache): https://lore.kernel.org/all/20250919214259.1584273-1-seanjc@google.com

Hou Wenlong (1):
  KVM: x86: Don't disable IRQs when unregistering user-return notifier

Sean Christopherson (3):
  KVM: TDX: Synchronize user-return MSRs immediately after VP.ENTER
  KVM: x86: Leave user-return notifier registered on reboot/shutdown
  KVM: x86: Drop "cache" from user return MSR setter that skips WRMSR

 arch/x86/include/asm/kvm_host.h |  4 +--
 arch/x86/kvm/vmx/tdx.c          | 28 ++++++++++-------
 arch/x86/kvm/vmx/tdx.h          |  2 +-
 arch/x86/kvm/x86.c              | 56 +++++++++++++++++++--------------
 4 files changed, 53 insertions(+), 37 deletions(-)


base-commit: f222788458c8a7753d43befef2769cd282dc008e
-- 
2.51.0.858.gf9c4a03a3a-goog


