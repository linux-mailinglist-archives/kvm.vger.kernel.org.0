Return-Path: <kvm+bounces-63574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D9F4C6B156
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 19:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1458435FF51
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 261FB35FF4E;
	Tue, 18 Nov 2025 17:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SB17xKKq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="NYUqT5Yw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7CD35BDD5
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 17:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763488708; cv=none; b=OByos4uLvteVJiFLJ0yMPQTiMSYbN7YjrNKWT/7a/Aq19QcwtubZ8REMIMke2Y7lALITajtF7RXY/lEK/oy6z8D8rbclm9KTPu8vNtG/g0WAhNSP9cgvgtlSf7nuGIuv3jvgibhcag6nLBulal9BU4s2VnSiJvDt7ZT0tjI3ZRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763488708; c=relaxed/simple;
	bh=WxkPzQsQSoq7Uj+x1m31448EOJRTw8uf2NMKe0LX6OY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JmkgTCba3QVnFe+E9uYH/+Rx6aiJGJJqwV6X8/0m8dIoU5ke+glPqYjmZtdrPz9nn8Nshb2Z4XbdgJ0Ni6zYEnbqb0QeC3FIWDeSKzJr0sNRvOItwBswBrnm4fzG+r9RaChqrwiMsa+iAy+NxKAaoSkTpeqzPc+aQ4WMqXcmAvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SB17xKKq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=NYUqT5Yw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763488705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hzyzvu73/m6eTg1srAQJTkNP1uyX7SvLQD0U9HRqTNc=;
	b=SB17xKKqrbpoCiYqpduoHdjJSagrUDEDzMtTdQ19sJXIT8K3n9b3OetPvjtl2+6YXbIpnX
	C5cupuBvEk/ipuYKmThT3FPbHbv+b5GirHrLqPwiYnUMT7eivB0JpB6Ivz3TLXJ3dEPr/e
	6zzKgKMwRe6Z82kcaZcZuhZhdd2hdiQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-66epImvpOqattzoLVDcaKA-1; Tue, 18 Nov 2025 12:58:24 -0500
X-MC-Unique: 66epImvpOqattzoLVDcaKA-1
X-Mimecast-MFC-AGG-ID: 66epImvpOqattzoLVDcaKA_1763488702
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4779da35d27so25539325e9.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 09:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763488701; x=1764093501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hzyzvu73/m6eTg1srAQJTkNP1uyX7SvLQD0U9HRqTNc=;
        b=NYUqT5YwHsQ6KE1y1O8fRTwtJACsZDByRVEwKrv1ZKRd3rG6ywDBudDnzd2XIKykyC
         Zmm1qd5/jTfDP3IcfAkEhQWhqy/+LzS80fU7kDDIfdWmLPLsw4FOBMtJSmp9vdPjPS3g
         u0ATO4P9kBKA3W4RtmhN5TPLRaklVdDIKwz73TxOJz4peEzTIoyVx/cdzpBrCv0vv1tk
         GomejyYxiTOTBkvrCOTiNTmKTEXmXJGyBBTUzNPuZrD9oyRHcE9IB9o3jc9Qh5rnyYd1
         6lMmPKcEyR1i93dWiymoT+wOvsZqJ7nGz9RH+bFm5yq4c2Gnt2HXI2GFTKae+dQm+UWa
         X7rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763488701; x=1764093501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hzyzvu73/m6eTg1srAQJTkNP1uyX7SvLQD0U9HRqTNc=;
        b=saWVK1ox3i72o0EciA8QNI5banVIdVk5/CKEzoCnEx5GFRzm0pRuw79kzQVGxe/xGA
         l+BCTXcw/h/2I0lgRSqjSyJnFWGjpsffkIUtUIqLLJ88x1YF653wQon00GqtHDLzfO1A
         xlPSsFo71n6s/pQWUdgSpn23WUvFMoHu1i9MoN9hFbWyyXmpHwiQ4DFuzmk6QMvBGQvu
         qmZPrha5zlahYN3syhF+5JYcEs+LS2bqNigWmOh1oVoH8hBZd8iaqiqHfgx48Hh2QA3K
         2QRyclbj75nl9yk5Ufzj/Y3Yfq5Ru+VmUBn7os67do5GBLwFgnFPn3RpmHxmd/uYwh5+
         OGdg==
X-Forwarded-Encrypted: i=1; AJvYcCUpqKgCrl9yYfE61MxuR+CIiAPgs1pMNQdmCaM0hqJ2t+9A4EwAGLvokOTyQiLrITDWxUs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyipCsdNIJZ32fsBZgaLKwupeGvSrLLcNK3nynZgLHFPeJjQPE+
	9fSqDPz6+YChqHpQ+Z1Qi2mcQ2NwXnMBoSPSEtG3Ie1ae568utivz6xfl4mr/k/qX8Bm/eSMI/O
	imv3vVzoE/VrvMSj6axEbSTNhhyIhFya8MMUpScTiKC712F6wd6ASx83bDYG+5Q==
X-Gm-Gg: ASbGnctLbFXAxHtaAGSfXTHBH16+dShViDrzCMVk7zY6NWvp4J9gTsrV7iyGHPGXABw
	T5LLywgcEtpRinJFH7pvIxix7+YAHQOAqHj/TLFz+lBcRAcO63QhRlVSdcZhA6SpjMMGshYdIHB
	Qp0+WUyVJEE/tLuDh/NAWs4fW85BC89UXzx02u+8iy1YPD92VhC0v4KQFwPZQku6BW4oQ8/Iirf
	f5l/jquH95Q9Zkm9yl+hbdSrljOikxKh8FF1nmLSOQq3LdnvF3KOivxt0eB0QEMCKG1cIWkD1cJ
	yWLicAB+jpTkhGwQTWQ7wO8fiSvwduiov8dBx/XyOY/yMbNKyqtUUeAKzLDjROC69Zti/N1iMXA
	Z2yxvci3f9EyjzlhwiUXmKpbLz+Ktc07x8KPoEI6F1ygghqqoBEjYS0wX0/R44dSNEHjwqRz3z7
	/5yt03U11Bz4CNHXM=
X-Received: by 2002:a05:600c:1c16:b0:476:4efc:8ed4 with SMTP id 5b1f17b1804b1-4778fe49c3bmr179878365e9.11.1763488701628;
        Tue, 18 Nov 2025 09:58:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHhBrzwIK+KtOfTXnhU29hmlg7vhFmivXM85PC/h0VRHzgkjtn8LJ3IGpoiBjV1iaaVDWC8fQ==
X-Received: by 2002:a05:600c:1c16:b0:476:4efc:8ed4 with SMTP id 5b1f17b1804b1-4778fe49c3bmr179878185e9.11.1763488701257;
        Tue, 18 Nov 2025 09:58:21 -0800 (PST)
Received: from [192.168.10.48] ([176.206.119.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e7ae98sm32924202f8f.2.2025.11.18.09.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:58:20 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.18-rc7
Date: Tue, 18 Nov 2025 18:58:19 +0100
Message-ID: <20251118175819.753688-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus,

The following changes since commit 6a23ae0a96a600d1d12557add110e0bb6e32730c:

  Linux 6.18-rc6 (2025-11-16 14:25:38 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 3fa05f96fc08dff5e846c2cc283a249c1bf029a1:

  KVM: SVM: Fix redundant updates of LBR MSR intercepts (2025-11-18 17:52:20 +0100)

----------------------------------------------------------------
Arm:

- Only adjust the ID registers when no irqchip has been created once
  per VM run, instead of doing it once per vcpu, as this otherwise
  triggers a pretty bad conbsistency check failure in the sysreg code.

- Make sure the per-vcpu Fine Grain Traps are computed before we load
  the system registers on the HW, as we otherwise start running without
  anything set until the first preemption of the vcpu.

x86:

- Fix selftests failure on AMD, checking for an optimization that was not
  happening anymore.

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm64: VHE: Compute fgt traps before activating them

Marc Zyngier (1):
      KVM: arm64: Finalize ID registers only once per VM

Paolo Bonzini (1):
      Merge tag 'kvmarm-fixes-6.18-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Yosry Ahmed (1):
      KVM: SVM: Fix redundant updates of LBR MSR intercepts

 arch/arm64/kvm/arm.c      | 2 +-
 arch/arm64/kvm/sys_regs.c | 6 +++++-
 arch/x86/kvm/svm/svm.c    | 9 ++++++++-
 arch/x86/kvm/svm/svm.h    | 1 +
 4 files changed, 15 insertions(+), 3 deletions(-)


