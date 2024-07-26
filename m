Return-Path: <kvm+bounces-22306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1E193CFE2
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 10:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF8631C20DFD
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 08:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E5E17A582;
	Fri, 26 Jul 2024 08:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="Q3/hIAmQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79551179953
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 08:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721983805; cv=none; b=dQvX7k2ZDCn07h7f0QV1ScWWx18UGqeOnb2580dXh4yzOynJoYLRbLhh3YtLa+Iv9tDArVbBGbEM4f4/xjfNZLxdwld4yr3gOdP1UOzLO1spEigqvJ4hvBAsBKDouZVe6m850Xkr4mIErQceXdrks5pu57w1GptVscoG6E5k8M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721983805; c=relaxed/simple;
	bh=4H9XgVVG6KE+T4f63WGdvgt8zwDFpGPootH+0VeKvxw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Zs1E6H5oZjn8i0vW9UZulPGnFLexwfWv7XdaSKX+bPhS1RlwLszePwOvDTxFB6k0g8mF94wQrPcYeR0Y429/oaDGiqK0mkBU5dkWv9deu4RgbPVUW6TF8t7kkMNWEbgShAT0mZD3TEhZ1SdZvxcQpAZkkr4EQHGRZb/QwSI5Ip8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=Q3/hIAmQ; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-39728bbf949so6905975ab.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 01:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1721983802; x=1722588602; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Bh0dPmnNd790JEXkCnnwPZ9r1VDA3UO+2QohszDGqoo=;
        b=Q3/hIAmQz/zvQzH3s1WqdNS14iCVqdMF8j/tC5PtxrTMQRj5i+FZG8r3opLZ6iKaMY
         InWuFpxE6X1qRNN2x5N4RBPfzkhHnycZtCwQusBeH0F1iBBKMA2kDatZUoTtpDAcwoi1
         PJ5q+Qu/Tto7Q4OCHpctMSbstZezDL/+oXe+muKS1fK8rty58A6heU/Vajxt394BKaZ2
         Kj+TXKTzr/A10TiydzZiVyx6dojtH5CVCmg7jGgRiWgFW/Duq3hKg7OZwMcwM8CdfOEH
         AN4qW3AKY+ccvHa7wlgV74ZpidduLBmETLAC7aZHkcaYHPZ0Aj9/4EXCgUa6q0WQ3j7p
         C8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721983803; x=1722588603;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bh0dPmnNd790JEXkCnnwPZ9r1VDA3UO+2QohszDGqoo=;
        b=Z/blOuuhQ4Xrx5gJ1AAtOEvJRke49Rt6ozViJB1rtOyzPNKaFTJSQbHUhw7Jq9+SfO
         vlsAYT86PFtpAMAzzeiPpYmoW37oJce3BDgoU9nxXM587SN/a9CwZ/aMH6iDX6wQdjix
         ZMOfdky/PaxA5TWjJin61BJd1rCFxbH0rsz3e0dJLasLx11LDdN8qdeo547iWsl0w5HR
         FZSuSKIgxzjMfIVF0qDPHv1PaYRm+TqNejCDpWgESxlP8GdTJT23+GJaeCTqalLAfA2h
         GLhYnkjsBxhvmX2wl0MyDwDgKC6YudHEBVn0hO4uySLbk56SQh/xO0yDMk7abkHkCwqJ
         du6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUO4jgDZUK+cma+vy/eSomHhYcmkyhFL77ENRRh/YOJZec1atK4opXz911s1c8bH6DGI6bu++UkeciMuy7qEQl8bYng
X-Gm-Message-State: AOJu0YyHUPVFSVqImn/MHZwlyB/xxxfhhGY7fJ0BMHcJMUPC4ia2iTON
	ahkphPylQXj4qjkAcfBWIRjxEseXEEFImk6KboM3vWEZ8npMPVch8d1q1cLzgBQ=
X-Google-Smtp-Source: AGHT+IEC0sacpJpGdjediwFUkg9JGJyg+dOU1D2hf0SgxjyukSNI0E33M4o24q3PFduqql67IyeZjQ==
X-Received: by 2002:a05:6e02:2162:b0:374:9c67:1df6 with SMTP id e9e14a558f8ab-39a21814055mr55639775ab.22.1721983802742;
        Fri, 26 Jul 2024 01:50:02 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a9f816db18sm2049645a12.33.2024.07.26.01.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 01:50:02 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v8 5/5] KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list test
Date: Fri, 26 Jul 2024 16:49:30 +0800
Message-Id: <20240726084931.28924-6-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240726084931.28924-1-yongxuan.wang@sifive.com>
References: <20240726084931.28924-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Update the get-reg-list test to test the Svade and Svadu Extensions are
available for guest OS.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 8e34f7fa44e9..aac40652e181 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -45,6 +45,8 @@ bool filter_reg(__u64 reg)
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSAIA:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSCOFPMF:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SSTC:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVADE:
+	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVADU:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVINVAL:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVNAPOT:
 	case KVM_REG_RISCV_ISA_EXT | KVM_REG_RISCV_ISA_SINGLE | KVM_RISCV_ISA_EXT_SVPBMT:
@@ -418,6 +420,8 @@ static const char *isa_ext_single_id_to_str(__u64 reg_off)
 		KVM_ISA_EXT_ARR(SSAIA),
 		KVM_ISA_EXT_ARR(SSCOFPMF),
 		KVM_ISA_EXT_ARR(SSTC),
+		KVM_ISA_EXT_ARR(SVADE),
+		KVM_ISA_EXT_ARR(SVADU),
 		KVM_ISA_EXT_ARR(SVINVAL),
 		KVM_ISA_EXT_ARR(SVNAPOT),
 		KVM_ISA_EXT_ARR(SVPBMT),
@@ -949,6 +953,8 @@ KVM_ISA_EXT_SIMPLE_CONFIG(h, H);
 KVM_ISA_EXT_SUBLIST_CONFIG(smstateen, SMSTATEEN);
 KVM_ISA_EXT_SIMPLE_CONFIG(sscofpmf, SSCOFPMF);
 KVM_ISA_EXT_SIMPLE_CONFIG(sstc, SSTC);
+KVM_ISA_EXT_SIMPLE_CONFIG(svade, SVADE);
+KVM_ISA_EXT_SIMPLE_CONFIG(svadu, SVADU);
 KVM_ISA_EXT_SIMPLE_CONFIG(svinval, SVINVAL);
 KVM_ISA_EXT_SIMPLE_CONFIG(svnapot, SVNAPOT);
 KVM_ISA_EXT_SIMPLE_CONFIG(svpbmt, SVPBMT);
@@ -1012,6 +1018,8 @@ struct vcpu_reg_list *vcpu_configs[] = {
 	&config_smstateen,
 	&config_sscofpmf,
 	&config_sstc,
+	&config_svade,
+	&config_svadu,
 	&config_svinval,
 	&config_svnapot,
 	&config_svpbmt,
-- 
2.17.1


