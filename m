Return-Path: <kvm+bounces-10423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 394E986C167
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:53:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AB641C212D4
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61DCD44C7B;
	Thu, 29 Feb 2024 06:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QM2UdW9a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C1744C60;
	Thu, 29 Feb 2024 06:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709189625; cv=none; b=S4KJkNfBrBDVuYMkDEEGTswaQFEZ3NQwKnhBtNRXxLOVDod8MEGs1Nia6LAuyrz9nIJy2jopOy5H1Db3F1N4GqdteTwdtIh3QMXMA6btkpEM/MjdJ0EdreOdg9mKHlFalysFGmMrtSoP/6wZicqfLR+qkez11eb9+ZKI3uXrqIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709189625; c=relaxed/simple;
	bh=8X2WTLGoGhrnpWFa7Ve7NOVThu3WxcK6QPPqfZoY8vw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tNlmXFKHxwMm4Emgq6p0zm5Ydw/zhE6ynIPbkdYM4WMkZt432FJ/AwkNJmQLA8cbh+aoJvv55LktV7ui9bdy80frSkH1pnVJmq4Cv4FxDZy3kOUfk/X63fCLfnRIb70rF0je00HTkopfc8PiUNBdTuTIrS3/CAayQKHlMWPnI4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QM2UdW9a; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5ce942efda5so461080a12.2;
        Wed, 28 Feb 2024 22:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709189623; x=1709794423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PNs3sQhbdaqVv8ZPP5u2A+gIkdtehaTFBl7mfeYhS0E=;
        b=QM2UdW9af72sLQdaTYIjEYy7LpSsH0n0q3x+WaCG6lY/S7Jz2kEuzoGAg+/TClSywE
         Y4O40Vh7n2wkwDgd6jOjrQvuC8I5AZuB+cjLNX4KZ0Hq5G9bT5l340GrciXV2av4LMac
         wfTw4vLEWRc2l4x8vmr9IoTa6zeTa1FzxlLyUa5Ddi43u4hHkuIFBeQvl/3z/D9Nbeqo
         lW2FmVAKpcJ8F2GfoVDbOQzIjOw/5mUstqY3hPrhfEGAF6LkZPdqP+pybaVXPX5DEzW+
         BdTJqj0sNcPlNDdfwbltomN5YMIx/5y4XlAJzN1AaBS1TQdSCfkHhuAuWRGtrRTPlvEC
         Mezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709189623; x=1709794423;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PNs3sQhbdaqVv8ZPP5u2A+gIkdtehaTFBl7mfeYhS0E=;
        b=kK1Wcb3cav1/0a9J5unk5YwD3xPkfxDjp8z0KF/cQGwufvLFumWRmNqrHp4NH869FF
         gS6SBGNojZw/qovKWzd9WoSYroJFcg7HMYCcyFJgFP479GMok3eV8X2j8jqAo7VoL7fc
         ydadZgO4PVb16l8c6Tz0zeeGfC4YyezDA+NFuKULbs7/rWJJmhPBJ768QMuWz7J0mJ0L
         rfaQRswneiIY+grdrWGbdUo7gUlygqXcJK+bI0KXoZcY9592AYCy2r/lMDliySYktlm6
         oww7uQ9nkJenh1e+Ef7a3tmsRDvJNmQ3U/SJlIml8MLMnS0L3XggFKqqvYdfXgDjm9pE
         k3Sg==
X-Forwarded-Encrypted: i=1; AJvYcCUVNQY9sJhmGYLme3hgC5RfpFiTRnbbAZ6DvOrsTm8tbFU40foGZaKxGEVav+H6ldsiTjE2T9P42Tp+j4Hb/DetPi28hOro/hhVBbcXA/mNT30fMT/Fkr+kN7r7UNyMGpia
X-Gm-Message-State: AOJu0YyTg/2VF3TbQrXoYJBu5optgZGxy5V9VpQiawehKEaj+uahCS3W
	aNdUmjFAYzikY4rYKlDqQ/DL7hhqq+BVcnJuYyk4BTzFhON5rQVQ
X-Google-Smtp-Source: AGHT+IGR3AeUgX6Ckm/1EeUr7zSEu/FraIT4qP05sNIOuFJOR8o5ydulL1i+Vji1KWHyAW8VbG38jg==
X-Received: by 2002:a05:6a20:3b28:b0:1a0:e66f:e46 with SMTP id c40-20020a056a203b2800b001a0e66f0e46mr1368140pzh.24.1709189623239;
        Wed, 28 Feb 2024 22:53:43 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001dc0d1fb3b1sm610509plh.58.2024.02.28.22.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 22:53:42 -0800 (PST)
From: Yi Wang <up2wing@gmail.com>
X-Google-Original-From: Yi Wang <foxywang@tencent.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wanpengli@tencent.com,
	foxywang@tencent.com,
	oliver.upton@linux.dev,
	maz@kernel.org,
	anup@brainfault.org,
	atishp@atishpatra.org,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com
Cc: up2wing@gmail.com
Subject: [RESEND v3 0/3] KVM: irqchip: synchronize srcu only if needed
Date: Thu, 29 Feb 2024 14:53:10 +0800
Message-Id: <20240229065313.1871095-1-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yi Wang <foxywang@tencent.com>

We found that it may cost more than 20 milliseconds very accidentally
to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
already.

The reason is that when vmm(qemu/CloudHypervisor) invokes
KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
might_sleep and kworker of srcu may cost some delay during this period.
One way makes sence is setup empty irq routing when creating vm and
so that x86/s390 don't need to setup empty/dummy irq routing.

Note: I have no s390 machine so this patch has not been tested
thoroughly on s390 platform. Thanks to Christian for a quick test on
s390 and it still seems to work[1].

Changelog:
----------
v3:
  - squash setup empty routing function and use of that into one commit
  - drop the comment in s390 part

v2:
  - setup empty irq routing in kvm_create_vm
  - don't setup irq routing in x86 KVM_CAP_SPLIT_IRQCHIP
  - don't setup irq routing in s390 KVM_CREATE_IRQCHIP

v1: https://lore.kernel.org/kvm/20240112091128.3868059-1-foxywang@tencent.com/

1. https://lore.kernel.org/lkml/f898e36f-ba02-4c52-a3be-06caac13323e@linux.ibm.com/

Yi Wang (3):
  KVM: setup empty irq routing when create vm
  KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
  KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP

 arch/s390/kvm/kvm-s390.c |  9 +--------
 arch/x86/kvm/irq.h       |  1 -
 arch/x86/kvm/irq_comm.c  |  5 -----
 arch/x86/kvm/x86.c       |  3 ---
 include/linux/kvm_host.h |  1 +
 virt/kvm/irqchip.c       | 19 +++++++++++++++++++
 virt/kvm/kvm_main.c      |  4 ++++
 7 files changed, 25 insertions(+), 17 deletions(-)

-- 
2.39.3


