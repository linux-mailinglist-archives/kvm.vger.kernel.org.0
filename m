Return-Path: <kvm+bounces-32099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20DFD9D2F82
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 21:33:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9DB528386E
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 20:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDAC31DA100;
	Tue, 19 Nov 2024 20:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Ayez7NoG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF351D86C4
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 20:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732048260; cv=none; b=OvnukXanoTYlxq8rTsi5s1RwsBoP7QNXExvTXP2dHjxJJt7LYa4mcofwKPw9snP46EYn4yQgCCRGg5UGXGMLclxt74vadxpwfdE+z7EXFnWztGSSvJN6FPpP93zX0e9YWtmsXBz+kZSBwhFDiRac6NWizibFknaQws0rkk0aUtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732048260; c=relaxed/simple;
	bh=I61ANzW3mMGNw+TsEklnF5HMFHS9Ft60jqTehlaG7hM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Pq43GY1NmFRY9KGKdTjNzyy0MM8BGLnRqrbuiBA6qgWHs7LPSbMwnTbpID6CIXey/UoyHiBWvrbSL5UMFOnvbDpYeSGG2fP3+5DErHrKgJXyXBtS8w/gSXKlGPLkIOFEskcAu4mvxO0YqXRytJ/mIzafAV24PLI75tAxz5arddg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Ayez7NoG; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21200c749bfso32889975ad.1
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 12:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732048258; x=1732653058; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oS1moOcp9ct9rXCWQSjf/GhpQtGR0rWY3wjXVfG0zao=;
        b=Ayez7NoGQMC9UcHgiyewYOdCCbHkBpWpfNnPlD4oJkCVCqo6aySmmHdCUC+kj0dNYv
         IT/9SpjthbtWdrsPnBv1kpHKQeEO1GlcUJlTUY0mRFcLJjE6btuC2l7iQ5F/QxMKAlKv
         o/APu6wZLBpE2CcFYmkWxJ1EIUKEfTV0Dpmx8j5RI+TfkV0Ppd2ff8JdVxnLTAg52pGG
         BThnI/HKmh7yfhWwZdp80HJa5GomB1DcdtWtrhop40ItRulHCA/PMh7rfhq9k/Y4l9CX
         PdcxIX2SgwN1c+wjEgGlqXMKbfX1hyik0ZyBqu/rE51dgQeHOIECbN1dVeMnp/woa7DF
         5aFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732048258; x=1732653058;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oS1moOcp9ct9rXCWQSjf/GhpQtGR0rWY3wjXVfG0zao=;
        b=ZFVXEbvPEqFvyhgCAyqJRjJvAbdpHSJP8sL1Ie+/wz4qxH0BJ6waMWF6lSlxaB3oHu
         0NSEO4pOtX0LT7av5XvG5qOnSFgOI0FVCiCVP6qyCS0UxwfkLJ6aHSDqa3P2vjcUX2/t
         eHAgtoSI9GnSrPr0nx3l3bXcD3VxHI8DN82Zx6pk+3ZN8vAcwt8/ei7NjEBu9iCPnen7
         zJencyuPEu5Ria0H+kSf7xymugwTmLCs6VSxO5v1PUlFP00rnxk19GhCkXXYZeQWjUXl
         AOHUYx1/gMUXD/6HUUnrg2YurGTKxOd4/il99T8iINAVSBrZmGrgm5w/MXaoOYGnEsDP
         C3Pw==
X-Forwarded-Encrypted: i=1; AJvYcCVER39PxAxF7bTjE8icHX3nQPqRUxs/AaOUyoPaeweOLc3UUySw8HDFZoCSJwp5m3v282w=@vger.kernel.org
X-Gm-Message-State: AOJu0YylbgJVEWhEV7OurHAHqRcfd2Z85CGnyQ+tLtAzooE5mVoW8EIC
	X46BMuciDaC0yMy+UDZVNqTA2db1uUUNVwJznFx606QVBk2N2TnFtrtPujKBTzc=
X-Google-Smtp-Source: AGHT+IHJJKUj/G9a1vcUatY4x43+GcKI1AsZDcQ+KjFbu3ubgI0Q6fpviZE7gWtG38yqh7oUq4m8sw==
X-Received: by 2002:a17:902:dad0:b0:20b:7210:5859 with SMTP id d9443c01a7336-2126b07a574mr1668385ad.38.1732048257883;
        Tue, 19 Nov 2024 12:30:57 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f34f2fsm79001315ad.159.2024.11.19.12.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 12:30:57 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 19 Nov 2024 12:29:56 -0800
Subject: [PATCH 8/8] RISC-V: KVM: Upgrade the supported SBI version to 3.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241119-pmu_event_info-v1-8-a4f9691421f8@rivosinc.com>
References: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
In-Reply-To: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

Upgrade the SBI version to v3.0 so that corresponding features
can be enabled in the guest.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index b96705258cf9..239457b864d7 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -11,7 +11,7 @@
 
 #define KVM_SBI_IMPID 3
 
-#define KVM_SBI_VERSION_MAJOR 2
+#define KVM_SBI_VERSION_MAJOR 3
 #define KVM_SBI_VERSION_MINOR 0
 
 enum kvm_riscv_sbi_ext_status {

-- 
2.34.1


