Return-Path: <kvm+bounces-24353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4060E954261
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FCFD28D9FD
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 07:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DFA28615A;
	Fri, 16 Aug 2024 07:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="VsVdHxex"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9023F7F460
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 07:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723792125; cv=none; b=cL2YWq+DucIdP9IQX/5aOfXq5YAxbHYfnylhSW1UYnyR7gnWl+qGDIwJFHsmAPuCSrRz9Vi+ienZQ38OJ0Mbqw6cOmDZa/2DUMQ3kfXNYJTDyDHsZ93leX//UK1I+2OlTQ/R8o6ABO7TgeBJWrYhAeKBpkeaNqdZ7l48LXL0/Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723792125; c=relaxed/simple;
	bh=+cgzoNrTHcsPJhyV3oUxmRMuDGlYCJuvoKOnicaOo1g=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=drvurfRRrZZZubTrcsQzKTnSV1UAFlZb0wZStN0vKo4NmCG/bwDE0a1bUOTj3ph6nI+1xfIhVljJT69FFba0uIYurL2i6LFaD6vTrRe0eMa5G6URL046FAM6GHbtnt64LLZDe/a+hESOm/15ZaiIOmhwSmpxTtp9U9y/Wy9wvuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=VsVdHxex; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-70d316f0060so1975926b3a.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 00:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1723792123; x=1724396923; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6Vqa4H3pvrihbzfusj/3lrV2Ez3LbOAxuSneAwjr3tQ=;
        b=VsVdHxexiJfKZrY/6SE34bejBNM7O+8N1evY10Lg6ID4FUm6lI71YaDVr4OFuTY3Uk
         CG8PGcosPhCM7jbhVZHthJ0fRapGllnDwTDgUJBxP+A9zc8mmEIUF91ejkKtnw9mgP1x
         MaBBrnqkFz0e5JS77jLfArMVrvNVw1fRoOwy6ILcpjXXFqRKDK7ui0D1aLgQgYBgWRfs
         EmS5iGa6ooOs+kegvHIEcnpEVeEhtiKkK2AYgsM7nF6oHnsA6Oy9XilhfEyZ22HSeOzg
         q9t/hXx6kZJc9no6HJY+MkTouJVr7lVFOkPniJgUzsBKfawyIJcud61/RuA/uajLVQit
         2h7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723792123; x=1724396923;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Vqa4H3pvrihbzfusj/3lrV2Ez3LbOAxuSneAwjr3tQ=;
        b=ezg37uD9TfLXSU4OEl8zpjSTvXc8aW7o8rQqoJ5ilBIhIKRcnv3bb5pv8nkWrXLf1t
         nI+CDRqFtIXyyJLbfBTM8oRlCcvDn27ouWy3076Ix/9o8ptfDn4ahmsr59dPDtJaKWOC
         WLhDGVK/Zj5wV6iz/uFVXBkz1BBY7OFXNV818Mby5lKuAKYO6m8LyUYSi6E2foPcoHj1
         JL27MOhG8/O/Y8bUbQzdjnwmaFRQenrUQNoyXMcpy93vfX2otAreHvP+IH7VF+54s0Db
         vmxKAJssYLvV//XBJPB1IXzirxMYu8hJsGutnjCuLePX6mO6Cgcz0nY8XMRki02HYMzE
         U+3Q==
X-Gm-Message-State: AOJu0YwCSWviEvlnIFT3Uqzq+1LUKWs39HPryowpaBu8O2vRu8d8+/lk
	BDkhVW4sUQK03CEvPGmyVZqEZDU9iPd15POg7eLlO1H32LikbmfQZWiSa9I6Ir8=
X-Google-Smtp-Source: AGHT+IHuF3rytZSdgjc6a/3GK/MB0ehKK5Zvbzf8Akserc/e1RWHlzoIrY6wFrSMS6kbKYCi1UimYg==
X-Received: by 2002:a05:6a21:9996:b0:1c6:b0cc:c44b with SMTP id adf61e73a8af0-1c8f86dff79mr7925906637.19.1723792122792;
        Fri, 16 Aug 2024 00:08:42 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b636bcabsm2293792a12.90.2024.08.16.00.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:08:42 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH 0/2] Fixes for KVM PMU trap/emulation
Date: Fri, 16 Aug 2024 00:08:07 -0700
Message-Id: <20240816-kvm_pmu_fixes-v1-0-cdfce386dd93@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANf6vmYC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDcyNL3eyy3PiC3NL4tMyK1GJdIzNzU5MUo0QDc/MUJaCegqJUsARQS3R
 sbS0A5sIugl8AAAA=
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

This series contains two small fixes to improve the KVM PMU trap/emulation
code. The issue can be observed if SBI PMU is disabled or forced the kvm
to use hpmcounter31.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
Atish Patra (2):
      RISC-V: KVM: Allow legacy PMU access from guest
      RISC-V: KVM: Fix to allow hpmcounter31 from the guest

 arch/riscv/include/asm/kvm_vcpu_pmu.h | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)
---
base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
change-id: 20240729-kvm_pmu_fixes-26754d2a077d
--
Regards,
Atish patra


