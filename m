Return-Path: <kvm+bounces-31186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 539319C1130
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 22:42:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18793285800
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D771E2185BA;
	Thu,  7 Nov 2024 21:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="id/dN6KV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D101218D6F
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 21:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731015706; cv=none; b=Nm8mN6lAmWJojtSXr54DsIxaT8R+GJ+Amfickd7FWTLUdPjE3Sf4Qg8wk6QMZXjbEvBY22L3gi9KrOmofNmtm4JgZpxbu7wca8KFdfoUyyo4GgjeDXg/K83Q+Jgl0Jxfr16hhInYCHA3WJkrsUN2l7hLyhqqABSUVj61j7nRvv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731015706; c=relaxed/simple;
	bh=2pbUMDr5DJLxz76a4PYkqqphNu7dpq8aJ2XhdaDTv9k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FQ7YruYPyq7bKaSUmM3h76olTzCWCYmLfZSOPJRm+k1z87gX4em2xCac4J9n43eWShw2SnLpoW1oKDA+onffvUZxAkeMv6qGiV7ljWsPQiRFRv7MYr5IDRJL/9fq73Nlzh0V+CYzCV9iUIw1XM9We8xCaIfapT+LzOjo8JY6n9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=id/dN6KV; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e59dc7df64so18956097b3.1
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 13:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731015703; x=1731620503; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hiCU49kQ7nM6OEw67YOfyReqqCaE0LkMlzZtaslGJ+8=;
        b=id/dN6KVHt0RNJfVO7to6zkj4vZxIMz2JnaEAi0YZyijLUFGD1zmztKWSkUQZBxmlW
         NPZ1zFq1w6FkPpFdI6hjk35h5I7OZ90AsagrGK9Gq2FjX6ggP4bFnrcA2Iyd4+RjYovy
         HGSlS5DJxm5IRQvuqnUziQA/7QEczKd73p3YefeZz6PCHDxzmbe+h+1scxuWaAfge4XR
         ZYQrD6gIqqamT7Tp9ly1DYqO4RmCcHr8VGW7gqJSXKH4tONfwOOMTUj+O2uykFhNI8fr
         Pm0kYri2Lp2kv7HD4i4DOHK53EGTZrI3bfMCt83V7acWn5wqcVCZF+FRdZ6qWqq1NUq9
         a74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731015703; x=1731620503;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hiCU49kQ7nM6OEw67YOfyReqqCaE0LkMlzZtaslGJ+8=;
        b=PAQQe8Uk4E40RYDv0D612qbe7sUhc5Vch0M77MrXKq84oZxQ3dqcaksPh2W/yzMY3P
         RtHSuzH92MKqYhDzFNgjPf6h/9mYaowGIvrNqP46WH5dx+pFtcEyZYurYK75mBVDRjm6
         twu7lc5GWDBJXZXP46/ahJGRZ7hbyvnki5wETi4hl+OZzIaUtksRmzDCKqQyhWhMqUKn
         ye8srx72EYZ9xyYaez2cSY5rHT4cHAIC/PCESVOzAsjXKjWtu2TYynWZc7CqTI/AK4jW
         UfoDrxabd0JSuUuy5nwmxY3LzxiebYF158wjUdCAKWT0k4N4SefqefduWqQ0y7Flnj+d
         9a3w==
X-Gm-Message-State: AOJu0Yy9bveJJ+ClwpNSOW1rrBWwbEBQLoDgXZAPkKvcDHizGKDDyTlH
	XWZ/9ZfD9WF53II2LYfUt7Sa1Vj/q5t7mlJnH3XQiVYIeYgeBiBDmQOwQk1jAMJJ4f41h1SfMHu
	NZ9fBBAxB2oNcgBscBlRRqz0lOmi24cEMDm2Ls8Ey8/LfmCALj0y3hJMEr4SVWiTpPVkCEJdi/b
	yzHr7aeheJoNTjVxugOt4YU8LOfPoztwrRyBs/Rs3VVQnVJxS2XBIOSKE=
X-Google-Smtp-Source: AGHT+IFmgY5AoHS66JpJ0ifa3vDhWyv/RjJrFb6ac4d0BLBtWrLWqHo8sUtLA5mcEv0UhGNPrlRByVBRLG34IueAkQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a05:690c:7407:b0:68e:8de6:617c with
 SMTP id 00721157ae682-6eade552a04mr73357b3.5.1731015703380; Thu, 07 Nov 2024
 13:41:43 -0800 (PST)
Date: Thu,  7 Nov 2024 13:41:34 -0800
In-Reply-To: <20241107214137.428439-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107214137.428439-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107214137.428439-3-jingzhangos@google.com>
Subject: [PATCH v4 2/5] KVM: arm64: vgic-its: Add read/write helpers on ITS
 table entries.
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Eric Auger <eauger@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

To simplify read/write operations on ITS table entries, two helper
functions have been implemented. These functions incorporate the
necessary entry size validation.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f2486b4d9f95..309295f5e1b0 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -146,6 +146,29 @@ static inline int vgic_write_guest_lock(struct kvm *kvm, gpa_t gpa,
 	return ret;
 }
 
+static inline int vgic_its_read_entry_lock(struct vgic_its *its, gpa_t eaddr,
+					   u64 *eval, unsigned long esize)
+{
+	struct kvm *kvm = its->dev->kvm;
+
+	if (KVM_BUG_ON(esize != sizeof(*eval), kvm))
+		return -EINVAL;
+
+	return kvm_read_guest_lock(kvm, eaddr, eval, esize);
+
+}
+
+static inline int vgic_its_write_entry_lock(struct vgic_its *its, gpa_t eaddr,
+					    u64 eval, unsigned long esize)
+{
+	struct kvm *kvm = its->dev->kvm;
+
+	if (KVM_BUG_ON(esize != sizeof(eval), kvm))
+		return -EINVAL;
+
+	return vgic_write_guest_lock(kvm, eaddr, &eval, esize);
+}
+
 /*
  * This struct provides an intermediate representation of the fields contained
  * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC
-- 
2.47.0.277.g8800431eea-goog


