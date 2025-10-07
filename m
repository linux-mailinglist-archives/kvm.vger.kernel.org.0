Return-Path: <kvm+bounces-59563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D09E5BC096A
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 10:16:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3EE5189DE83
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 08:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D3727F006;
	Tue,  7 Oct 2025 08:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OPwV7+ZA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1F4284885
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 08:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759824988; cv=none; b=nm0vPuR3/FWAVAOxuG5xdrMZlzykQXyJpibDBmAHEK/xKOC953cXFx36XvJPNk8Zfr4jqm7zjlOoGvxa7suAvQtqkxrWp8f/t2CnFviiprbh2J6Uyv9zDiG8/U48xF8a55a2uocF0eT7D6NNRv/qqIGcdAKtJMm/rZTSRjG655I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759824988; c=relaxed/simple;
	bh=Bxl2e0Le5gxgcSqh4jlH7hk9qjSBEMIJ7XkY90jQ9O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IJbBck/ko8yXSbCJ0sszxz5eZFLixdKtquevtqWVvdXi0NvFqZDggfDKG9TpeO9bjr9YvYoukSrZ2avCkKRORicdaxzLssAJxFtlfHAQptkPxNjlTCVcblQNrtWcoDpShgs5BodD4eqY//YS99rvMg/ZmgiWJORQyUwd4bwGfWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OPwV7+ZA; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e3a50bc0fso48089215e9.3
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 01:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759824984; x=1760429784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cD5B6th7c1TeoiHWNXDK88lPUBnBW5SZJ2RDNW2CK3g=;
        b=OPwV7+ZAWREEIcqtzn1DggjCGgEQ33KrjOnqWRzdYFEFSXTI2kUx9UKIaAD4zVMcaS
         4ldIiccRIabki2oGdPCGfB3yVwPadYLTumCXai/mAjGXBfIeUF/ltqJihdrWJfBpPnJn
         p8u2fZocywxlphnaWZ+cdFeFTaLu7SvAthBrmrnX++PxDN66U1XNaErnzt+DtokmtXjD
         +PVBrbKuCqc5VN/E9EkASx5SmnLDdmeL5di4okRQRZNPy5Xv/QJmMN6vucKY6f4+gUwi
         QJyHFDNgJyGJBruYJqwCMJ10awpz3GtiDje7kZ885UhekWeEEAkjMre81Z55c2WLKSLU
         Qy8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759824984; x=1760429784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cD5B6th7c1TeoiHWNXDK88lPUBnBW5SZJ2RDNW2CK3g=;
        b=pnz0y6wDYdIcmgafn51mpPuVp4yvD2RvZZ/lUJv2uGOQUl3/JnbDf1A9ufEJz4AJWs
         6I0937zrstc5sfE+3yOdxkHf9LHbcB2q2X+38dJlIjwD9nybYAimP7MXtNiKXoDGDKJ+
         GG8Tf1bLimuiEJ1FvXCDaZigCcTIzkb59UIEJsJ9zqyrqDamM5fosRNMISIp+92M+bY9
         g6g3RCzNXhYOa9FXpR3ngwvclx/IntHsp1qTfAuL+tZ58lTd5iI4NIugr074tc7/TMKl
         0SjoIunuYQz+xlENmNvWUiDrCxh3UJ0Xlpa5voR8m3EmOhdwDlVnVKh44ILYjJhB32aa
         oVFA==
X-Forwarded-Encrypted: i=1; AJvYcCVi1dDWFNkZFRpnkJU9sGW/QpbOktXGNHL6Z3apJ8E8JrhHBBPo2Le18QzJe4CXianO8Vc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyyh+STtYBPMjEtsl5EQPw3EnaqtI3juZhpc954rZH0lcaYe/gF
	WNO3U7nsYwk1bWLAtUI66ud8Db2rg4MgTsAuXVv5KuoleoAWogJcdwmXN1xsX5JhYNE=
X-Gm-Gg: ASbGncvgFnnOviW7JPjEboMm/riBwbAtpbIvjyBhy35VA0AmIZU7UCW0zp1OTHIwGpe
	4xcf3Sp81R6Io0p94YJhbIxrzhjykm5/7MLnJaTWCTrPHaMZuSiyHWQZxslfuyJMA2uK5hnqk2u
	SJ52Oc+/ztZ8+JLNOZgqVZUlhMV4ys0OPHyycwJtZxoU/Pt8UgFyZu0dUulkKcTAGPh/9+66hwJ
	M1gn3iVbs+gzDsL8x8mB4xYu77TWO37V0vg8xDjFdWZ+ozLzSAyPTCBr7sGCB4lK13d6eaEOohP
	7kQiB7NDT1LEg/3GlMuMNP8exIWQfWZnxrYhR3e0qOBAHyTwRmOKlxL2MsNoQpQcDKB4rwO+QFg
	Jpe5rsLZWkei2ib2us6hFbUgrrFvha+YGIOsCGTPV/xc9yQo4VNZzth2RSdYdlvgpUorCwNBvzE
	G6tpfueCUfQtkJrTsrfriQldiG
X-Google-Smtp-Source: AGHT+IHqJitJWd85EjVa6wBFl1HVhO0dJ2xXoZpIa4bEQDcdZ0MzcJ4BX+zr8XLtbIecHxBNFaDD4g==
X-Received: by 2002:a05:600c:c4a8:b0:45c:b53f:ad9 with SMTP id 5b1f17b1804b1-46e71151aedmr107360115e9.33.1759824984354;
        Tue, 07 Oct 2025 01:16:24 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa2cfa2dcsm13204885e9.0.2025.10.07.01.16.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Oct 2025 01:16:23 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Weiwei Li <liwei1518@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	qemu-s390x@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	Aurelien Jarno <aurelien@aurel32.net>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	qemu-riscv@nongnu.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 1/3] accel/kvm: Do not expect more then KVM_PUT_FULL_STATE
Date: Tue,  7 Oct 2025 10:16:14 +0200
Message-ID: <20251007081616.68442-2-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251007081616.68442-1-philmd@linaro.org>
References: <20251007081616.68442-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

KVM_PUT_FULL_STATE is the higher level defined so far in
"system/kvm.h"; do not check for more.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/loongarch/kvm/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
index e5ea2dba9da..45292edcb1c 100644
--- a/target/loongarch/kvm/kvm.c
+++ b/target/loongarch/kvm/kvm.c
@@ -397,7 +397,7 @@ static int kvm_loongarch_put_csr(CPUState *cs, int level)
                            &env->CSR_RVACFG);
 
     /* CPUID is constant after poweron, it should be set only once */
-    if (level >= KVM_PUT_FULL_STATE) {
+    if (level == KVM_PUT_FULL_STATE) {
         ret |= kvm_set_one_reg(cs, KVM_IOC_CSRID(LOONGARCH_CSR_CPUID),
                            &env->CSR_CPUID);
     }
@@ -801,7 +801,7 @@ int kvm_arch_put_registers(CPUState *cs, int level, Error **errp)
         once = 1;
     }
 
-    if (level >= KVM_PUT_FULL_STATE) {
+    if (level == KVM_PUT_FULL_STATE) {
         /*
          * only KVM_PUT_FULL_STATE is required, kvm kernel will clear
          * guest_addr for KVM_PUT_RESET_STATE
-- 
2.51.0


