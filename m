Return-Path: <kvm+bounces-37022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B1FCCA2463D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:38:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24ABC1884F1A
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:38:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889C520B22;
	Sat,  1 Feb 2025 01:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vTyIB5W8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A1AA926
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738373912; cv=none; b=XAmz6qJfTEVaP/E0EWnXjPx3ntWeJFGn0VPX04Sck9+RQk8xo2MWtx4XaCZk6YDPZFDg/tPlRu1Wpma//6YQ/M03aBrRrOIhaZqG5ccEJnLca6nGcp+Mrru8FwqMIqvwu4eWOHXPtgSBzZmtVVvp1Y8pVzEqphvz36glFfR5q5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738373912; c=relaxed/simple;
	bh=xAhoK4tQkXS+kc4yuFMJQ1yJAcRiGhwUeNLLmvDoml4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jo/54S6J+YiP2U/FPUFtqgElClEIbwNLyZ5CcIhPvbXHErywwPuWp9GnPieSRo+15gNU3ChcizbA/7g8kgWhu+PyEu1+Jxq4ZmUPozzjdvSgkMjx5Mrkk1856p9jpeU+7N2jVVd8gyLMX7sd/gk6dDsHT4piaPcKLjfjIS46Ug4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vTyIB5W8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f780a3d6e5so5182069a91.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738373910; x=1738978710; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QEZ1tdrmXV8x7MsSfaimOR7vlefSdDmdJb6Z9fWIY90=;
        b=vTyIB5W8MVneZodu9gsjaX4b+x4ZXVF+doiY8KAPiYoeRdkeOhi+ffFibJ979geNNt
         SQhylVIwc7OEnSwNITdCn7d9C29JLaQtH/qcUC+vrthThWnmyFhKHLK/NepUP97smsPr
         RrWVdmiGdKvbvilfmwl9A2BBN0l4jWcYrC8RYeN18XxFGqr/CZTNWX1CqQQZqx1ew+8C
         NVOGhpiewTHUd9yTn5oDS804x78eIW9Rf0jXW77GDB7rXIIQzRaJBgarvlysn0LKOTfa
         HOobwMJrP5xC5gr7ImbWl2j4RuJrKxq54jdQKpfBEkKp6cc1sn96XVcd0UcEsPVdGurF
         PPXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738373910; x=1738978710;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QEZ1tdrmXV8x7MsSfaimOR7vlefSdDmdJb6Z9fWIY90=;
        b=KwqO4Rav46kLx/pc2MYDI+U5f1wqcc3joG90LoGGh+T/FwG7Gm/IEoh47hP48XCNmf
         1B2lQxWM/+xgz5lyHLTaqctdpCfTZlIYau2Icjd0AQcJbSzh+X8NnatHEWAaX9B+q5zq
         mWPxJAKD+CdW1MvZ+FmhqgIqCLEw+aAv+ySF9C8bWxXSY0es8UC8tngKQzIx6iq0oRvO
         GqPrLV1I6vLv54zUbmDtlZZ8SARiYWAsQv9vnipRmDhqx0ZUU7d/Idh6anWXojl/dXPt
         mdvA52M8XIglnPcXp6tezOeI0zO8igZrp21CG23YXZh9ItjGUFvBufcQR9bAHkXbSgZQ
         QZuQ==
X-Gm-Message-State: AOJu0Yx9o04UItPhx9ABcRaQWTjoAm3XdMQwBewd+KsYRMZLobZYmfZx
	qdBjGt3jLVxNVwmlbs1rqO8bV+FPZrvqrhpQPWy9cIMNrHaWgAQldCAucKnuAmA6XpaOutjDj9v
	qNw==
X-Google-Smtp-Source: AGHT+IFGaWQO9te1i4XSWln8yI3HRjqFB98VkGJ1+ZqXBaLRcIOvSUrk4GjjoRMSiw9G3Xv2ugjHHG/tHl4=
X-Received: from pjbsg1.prod.google.com ([2002:a17:90b:5201:b0:2ea:4a74:ac2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c887:b0:2ee:c2df:5d30
 with SMTP id 98e67ed59e1d1-2f83ac5e574mr17088984a91.26.1738373910496; Fri, 31
 Jan 2025 17:38:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:38:16 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201013827.680235-1-seanjc@google.com>
Subject: [PATCH v2 00/11] KVM: x86: pvclock fixes and cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Fix a lockdep splat in KVM's suspend notifier by simply removing a spurious
kvm->lock acquisition related to kvmclock, and then try to wrangle KVM's
pvclock handling into something approaching sanity (I made the mistake of
looking at how KVM handled PVCLOCK_GUEST_STOPPED).

The Xen changes are slightly better tested this time around, though given
how many bugs there were in v1, that isn't saying a whole lot.

Case in point, I had to shuffle the scariest patch (at first glance),
"KVM: x86/xen: Use guest's copy of pvclock when starting timer", to land
earlier in the series, because the existing usage of the cache pvclock's
"version" field in kvm_xen_start_timer() relies on the pvclock update to
persist _a_ version number to the cache.  Eww. :-(

v2:
 - Collect reviews. [Paul, Vitaly]
 - Account for the compat offset in xen_get_guest_pvclock().
 - Try both the compat and non-compat clocks in kvm_xen_start_timer().
 - Fix a horrendous uninitialized variable bug. [Paul]
 - Move the kvm_xen_start_timer() change earlier so that it wouldn't be
   transiently broken due to "version" always being '0'.
 - Shuffle patches so that the "set PVCLOCK_GUEST_STOPPED only for
   kvmclock" is fully isolated from "Don't bleed PVCLOCK_GUEST_STOPPED". [Paul]

v1: https://lore.kernel.org/all/20250118005552.2626804-1-seanjc@google.com

Sean Christopherson (11):
  KVM: x86: Don't take kvm->lock when iterating over vCPUs in suspend
    notifier
  KVM: x86: Eliminate "handling" of impossible errors during SUSPEND
  KVM: x86: Drop local pvclock_flags variable in kvm_guest_time_update()
  KVM: x86: Process "guest stopped request" once per guest time update
  KVM: x86/xen: Use guest's copy of pvclock when starting timer
  KVM: x86: Don't bleed PVCLOCK_GUEST_STOPPED across PV clocks
  KVM: x86: Set PVCLOCK_GUEST_STOPPED only for kvmclock, not for Xen PV
    clock
  KVM: x86: Pass reference pvclock as a param to
    kvm_setup_guest_pvclock()
  KVM: x86: Remove per-vCPU "cache" of its reference pvclock
  KVM: x86: Setup Hyper-V TSC page before Xen PV clocks (during clock
    update)
  KVM: x86: Override TSC_STABLE flag for Xen PV clocks in
    kvm_guest_time_update()

 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/x86.c              | 115 ++++++++++++++++----------------
 arch/x86/kvm/xen.c              |  69 +++++++++++++++++--
 3 files changed, 121 insertions(+), 66 deletions(-)


base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0
-- 
2.48.1.362.g079036d154-goog


