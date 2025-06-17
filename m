Return-Path: <kvm+bounces-49734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C493ADD7EC
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 086B83B281B
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C5A2EA732;
	Tue, 17 Jun 2025 16:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dw4DSvAI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099942F948C
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178039; cv=none; b=tSJKgg/9QWhirt4wfguQmGQWP663nqIdmL95jWy0PB7keq9RTSiXXFeiTKBK35Q1f4S27w28froNm9G0Ungr/7HgGV7Y4Aty5UULf0dwO5h+epULFicLCuYQIolaYpibzon72Wv6fzWD0KE+MGlcV06SmyhaBjmliq3vVmZPQRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178039; c=relaxed/simple;
	bh=M3s1khNI/1FQ3PtHYNh4z/WxhBy2dq5zfoV5BNouff0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fwUDY26jKNXX1rOh1XqRCvuucI14q5ChV7eEo3zDEqaD2w24bRwmLM2MtbNzQugnxI442ak071r16t6852HmDiPJPLv9axW38J6Ehwl1tfPVt9fC6BmlBiGMpCI8yFYubs9ouJ0hRQlc3GoLGs2X1ID9TJ+g5vrIgT+aHnX58Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dw4DSvAI; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a582e09144so1417533f8f.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750178035; x=1750782835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t40bt1183UrSentyz3550cC0V6NSp0ZoskbuhIRXheY=;
        b=dw4DSvAITCi0SR0KJyyyggLWuswbdahrJHqISQLC5+fVgicd9RJIbZ7xe0kuFukqZo
         OWH26bClPf8SgA1aYyrutfkEjKgj2J1MoMBBGatgX1dAmzfZuQCQsKTX+72W5voSE+Eo
         JS0muGAc96AzCpH5SuHdvnSsnQlPL6mZQkgzKMrteB6QoiUJq+tpEb+TzELf8xl3oTVW
         tIAGsxmwUyPTJb0IFvabAIgssye3slh/tt/efJB1Db9/S049lCrxQGeFNw4eXxwV022a
         72JVGAI3JHtEB9VcOO71SWyewMS3taDFKcNzr9dSY+FA4TNe74+xKKrNr74UQNaXVKfP
         7COg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178035; x=1750782835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t40bt1183UrSentyz3550cC0V6NSp0ZoskbuhIRXheY=;
        b=xNgtZB5bjUYSVlatjgVP23Al4mIxL3zka/AIwXhtlZtLEMHrIG3q7xLMzwT7qunf+m
         /KMoOjNadz3VvUeJrrt0W2OX/kjz3Jmjk8qqn867yBhaIlIkbr+xQRImBGXMJHS1Pl8g
         TQ1/+msgKTM4a3CSKisgkh04P9SyUXQIpVD4NZUdjQjaSKaVPapwJ97E3jAPctGoPr0q
         PqY/j5XbECGW10WbMmvVdr6+ozQbNp9qQ3IapbaEtI04VThClT/2N+3Vg6TbB6zbWo4y
         /52uSEViRiDwTWUuo6wiiVXvGI7OGzHmkgT54Dh6jo7tPngUIj6gGJzX1xXr/7nUTGJS
         20Qg==
X-Forwarded-Encrypted: i=1; AJvYcCX76AlxHDl+dGr/J0Qchagj1QoJ3Hd13FhAy+dDZznVlmTWbAMmskR/muz6S4B6Po6iU/o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoBzCQ0H2VuiyVSfJlZ8VMu66l5JxrZ3hNTDcKgPn6KiWcoTge
	3i7qtje/obji4bcydw046rUIYrVm4yUnW8YdtVB4VZCeWmPNOPQjBUa05TsUrzRRTxA=
X-Gm-Gg: ASbGnct2GO5uebHP6vpREdZqKitr9Fr2Fbp0ZyvmLoZz2xdJHq+iH5gEgb4hdRd70JU
	ccs1fZK9GCA6mh39oNT1sh1NBlEuLTxLSOoiXC5FH7WUqLoJkouVxQklAzHBmdTUbJ0Xe4Fv43w
	pw7wZKh8liZVy0xXDTZ1pWRAa9p9TMGrffPeS1G6Q/P9/s3DDvbfHC4tHZl1Dxt111isL3bli4f
	0S3YhSzBErlK+nQwTKqXgq0LfCCDzMpIOaD6GoCo41/HpLIKdMzSxpeG+ecZx3vGNxd+06rhsNZ
	tY8sg8Oh7TJmgdAvojwYX5Lb2bcaUO+Qxxasdiz/lyVwU/wVdZtxGTvX4uJpetQ=
X-Google-Smtp-Source: AGHT+IG4cv90M94Tfw7iEiYjMpdDPcWxYkGMa/ll8ppjhP2edxc6v82sBNSLJWREvyzO/nD4jEsnAg==
X-Received: by 2002:a05:6000:2913:b0:3a4:d4e5:498a with SMTP id ffacd0b85a97d-3a5723af2e8mr12220518f8f.42.1750178035305;
        Tue, 17 Jun 2025 09:33:55 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b48564sm14222655f8f.82.2025.06.17.09.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:33:53 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 434E85F8A6;
	Tue, 17 Jun 2025 17:33:52 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Cornelia Huck <cohuck@redhat.com>,
	qemu-arm@nongnu.org,
	Mark Burton <mburton@qti.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC PATCH 04/11] kvm: expose a trap-harder option to the command line
Date: Tue, 17 Jun 2025 17:33:44 +0100
Message-ID: <20250617163351.2640572-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250617163351.2640572-1-alex.bennee@linaro.org>
References: <20250617163351.2640572-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It would be nice to only have the variable for this is a KVM_ARM_STATE
but currently everything is just held together in the common KVMState.
Only KVM ARM can set the flag though.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/system/kvm_int.h |  4 ++++
 target/arm/kvm.c         | 19 +++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
index 756a3c0a25..a1e306b7b7 100644
--- a/include/system/kvm_int.h
+++ b/include/system/kvm_int.h
@@ -122,6 +122,10 @@ struct KVMState
     OnOffAuto kernel_irqchip_split;
     bool sync_mmu;
     bool guest_state_protected;
+
+    /* currently Arm only, but we have no KVMArmState */
+    bool trap_harder;
+
     uint64_t manual_dirty_log_protect;
     /*
      * Older POSIX says that ioctl numbers are signed int, but in
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 74fda8b809..8b1719bfc1 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1615,6 +1615,18 @@ static void kvm_arch_set_eager_split_size(Object *obj, Visitor *v,
     s->kvm_eager_split_size = value;
 }
 
+static bool kvm_arch_get_trap_harder(Object *obj, Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    return s->trap_harder;
+}
+
+static void kvm_arch_set_trap_harder(Object *obj, bool value, Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    s->trap_harder = value;
+}
+
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
     object_class_property_add(oc, "eager-split-size", "size",
@@ -1623,6 +1635,13 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
 
     object_class_property_set_description(oc, "eager-split-size",
         "Eager Page Split chunk size for hugepages. (default: 0, disabled)");
+
+    object_class_property_add_bool(oc, "trap-harder",
+                                   kvm_arch_get_trap_harder,
+                                   kvm_arch_set_trap_harder);
+
+    object_class_property_set_description(oc, "trap-harder",
+        "Trap harder mode traps almost everything to QEMU (default: off)");
 }
 
 int kvm_arch_insert_hw_breakpoint(vaddr addr, vaddr len, int type)
-- 
2.47.2


