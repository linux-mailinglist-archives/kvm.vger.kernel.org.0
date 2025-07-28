Return-Path: <kvm+bounces-53584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39348B14471
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 00:37:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55D5D189A40D
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 22:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5AD6234984;
	Mon, 28 Jul 2025 22:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZR9lR8Qb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49408488
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 22:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753742237; cv=none; b=u/6H5D9ChPuLaWklD3bR5eqDXzEGC4Bb+L/CqBx8bgvjDwhxmi9jqE4Ec5nS/bB3NAXVFg/nG+38TEJ9LPzMeHVL1rwBmLSjMAl6tlg6YioadY1cDNjTXxV/26x2H2F9wCJ9LJINfgg3wqYZKEg9LJKBrgjSVPkO8sIubHfPpIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753742237; c=relaxed/simple;
	bh=EF+nLZgKrgjhDmWSiOPghhkt5JHqMrkQ8+IPoUCfYaE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=EJtjMdyiqbCV6pn4MsHAoMX5G0O5LIFYvgCaoAVXSMjssRCHEMhBPMqAAT93EXn4x7LDYKYV8RBunvcEHqT4K/HPgWnLf7ybIjTGkVNG6WZyJUX7xTRsALhedRyD5qaFiiGyHipMupHW+0+ciWlY3egUHgMmdqT3izGptmJtisw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZR9lR8Qb; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-300884cb515so5859384fac.1
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 15:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753742234; x=1754347034; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g1ZZrV9iF8dYVdhyBL4d5b4ftcnLDouNaKEg4YWgOvI=;
        b=ZR9lR8Qbh9lKvAhscJ3NG0gEJBF55cLc/hhcUMYM1PFWMfPOJ3eLJrOln4gQaoSBPZ
         KWYuoZ0kLmYabiuJ7k4qCfSc7Qh0EoqlsSPJhXcKr15xNUw0l5oAHhKfVw2NWz/28big
         j0W6PczDu0GLm/qDP2Dl01TtG+y5NsZKD5H5ZS6W8U8vt65/VO+wrMjeTC7CP6hJbJpI
         JR927rrX46c06/I77V92ArnpmjLD2vN4JQoec4USxtXJ5RQsuijKaLFaGN3YPiEP0ilq
         GTr4pvqlL8Iq2LXFCBBEay+0HmkHvfkNJ52jySAbsBURvnNb6pN81yd9shQouCu3o63Z
         cXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753742234; x=1754347034;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g1ZZrV9iF8dYVdhyBL4d5b4ftcnLDouNaKEg4YWgOvI=;
        b=OtpN38jtqGZh90z6Snx+Z3aypF0UhlTRVIXOkhaBEnXo4LbzJkR2xDM3ZSSAEks+Hw
         5vEAuUc/CGhRfR3cZ6IkxbFwGwfvFNc1Tm0HEte0mUKS9Ygz4Ld6lEUybLEWyeLHhAAx
         qa95qsb6rh0Tkmg6/J0sauCaTYg95gLDF3gsZXfUfCFHLwqXjraS2iCd67/aeF9ccOok
         F8O8XdbpUJtI2QBWz37TzKeS9XqspXu4LpoC2r5XAHhQdi12zgsePT2neGPmcupGn6vj
         j3vG5Rtd16s5xVHj03TgSepEhNLyie46Dq8h8EXo0kZKlimqr3Ci14A2GZN8MdI32Bgb
         nNwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWSzL3KEIqgnvcfEzs6LZT38a3CBlS2LluKIFMKxU0hi+aflhLw3mQXYUc+8rJFwbVq20=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPS2o8qtQj+4/S4rc/rnT8AbCIinWxVx3vzAxHbzdNw/aaah/u
	l9UIPBvoN8RIoI71FAfOYxpb3icXi+anT9ANaX4sSau/Z5zHZc5oRuhWTCdIz080fAgRASXiGAE
	9PykC6UM8vg==
X-Google-Smtp-Source: AGHT+IFMRJ908vvsWj70nTjQOvVm1PrziYCGSb3/MxBBTKnv0C5mcFnYcmNsuxDQFYN+4WMHi8+Bkj1Y0O5E
X-Received: from oabld4.prod.google.com ([2002:a05:6870:2b04:b0:2bc:69a2:7ea5])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6870:1b83:b0:306:9f8e:6699
 with SMTP id 586e51a60fabf-30701faa8b5mr8749981fac.30.1753742233877; Mon, 28
 Jul 2025 15:37:13 -0700 (PDT)
Date: Mon, 28 Jul 2025 22:37:10 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Message-ID: <20250728223710.129440-1-rananta@google.com>
Subject: [PATCH] KVM: arm64: Set/unset vGIC v4 forwarding if direct IRQs are supported
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Commit <c652887a9288> ("KVM: arm64: vgic-v3: Allow userspace to write
GICD_TYPER2.nASSGIcap") bundles the vLPIs and vSGIs behind the
GICD_TYPER2.nASSGIcap field. While the vGIC v4 initialization and
teardown is handled correctly, it erroneously left out the cases when
KVM sets/unset vGIC v4 forwarding, which leads to a kernel panic of the
following nature:

 Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a8
 Mem abort info:
   ESR = 0x0000000096000044
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
   FSC = 0x04: level 0 translation fault
 Data abort info:
   ISV = 0, ISS = 0x00000044, ISS2 = 0x00000000
   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
 user pgtable: 4k pages, 48-bit VAs, pgdp=00000073a453b000
 [00000000000000a8] pgd=0000000000000000, p4d=0000000000000000
 Internal error: Oops: 0000000096000044 [#1] SMP
 pstate: 23400009 (nzCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
 pc : its_irq_set_vcpu_affinity+0x58c/0x95c
 lr : its_irq_set_vcpu_affinity+0x1e0/0x95c
 sp : ffff8001029bb9e0
 pmr_save: 00000060
 x29: ffff8001029bba20 x28: ffff0001ca5e28c0 x27: 0000000000000000
 x26: 0000000000000000 x25: ffff00019eee9f80 x24: ffff0001992b3f00
 x23: ffff8001029bbab8 x22: ffff00001159fb80 x21: 00000000000024a7
 x20: 00000000000024a7 x19: ffff00019eee9fb4 x18: 0000000000000494
 x17: 000000000000000e x16: 0000000000000494 x15: 0000000000000002
 x14: ffff0001a7f34600 x13: ffffccaad1203000 x12: 0000000000000018
 x11: ffff000011991000 x10: 0000000000000000 x9 : 00000000000000a2
 x8 : 00000000000020a8 x7 : 0000000000000000 x6 : 000000000000003f
 x5 : 0000000000000040 x4 : 0000000000000000 x3 : 0000000000000004
 x2 : 0000000000000000 x1 : ffff8001029bbab8 x0 : 00000000000000a8
 Call trace:
  its_irq_set_vcpu_affinity+0x58c/0x95c
  irq_set_vcpu_affinity+0x74/0xc8
  its_map_vlpi+0x4c/0x94
  kvm_vgic_v4_set_forwarding+0x134/0x298
  kvm_arch_irq_bypass_add_producer+0x28/0x34
  irq_bypass_register_producer+0xf8/0x1d8
  vfio_msi_set_vector_signal+0x2c8/0x308
  vfio_pci_set_msi_trigger+0x198/0x2d4
  vfio_pci_set_irqs_ioctl+0xf0/0x104
  vfio_pci_core_ioctl+0x6ac/0xc5c
  vfio_device_fops_unl_ioctl+0x128/0x370
  __arm64_sys_ioctl+0x98/0xd0
  el0_svc_common+0xd8/0x1d8
  do_el0_svc+0x28/0x34
  el0_svc+0x40/0xb8
  el0t_64_sync_handler+0x70/0xbc
  el0t_64_sync+0x1a8/0x1ac
 Code: 321f0129 f940094a 8b080148 d1400900 (39000009)
 ---[ end trace 0000000000000000 ]---

Fix this by checking if vgic_supports_direct_irqs() while
setting/unsetting vGIC v4 forwarding as well.

Fixes: c652887a9288 ("KVM: arm64: vgic-v3: Allow userspace to write GICD_TYPER2.nASSGIcap")
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index e7e284d47a77..873a190bcff7 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -433,7 +433,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 	unsigned long flags;
 	int ret = 0;
 
-	if (!vgic_supports_direct_msis(kvm))
+	if (!vgic_supports_direct_irqs(kvm))
 		return 0;
 
 	/*
@@ -533,7 +533,7 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
 	unsigned long flags;
 	int ret = 0;
 
-	if (!vgic_supports_direct_msis(kvm))
+	if (!vgic_supports_direct_irqs(kvm))
 		return 0;
 
 	irq = __vgic_host_irq_get_vlpi(kvm, host_irq);

base-commit: 18ec25dd0e97653cdb576bb1750c31acf2513ea7
-- 
2.50.1.487.gc89ff58d15-goog


