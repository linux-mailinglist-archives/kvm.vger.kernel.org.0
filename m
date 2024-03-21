Return-Path: <kvm+bounces-12358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E216E88560B
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 09:51:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FC6B1C20E47
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 08:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D5B2C86A;
	Thu, 21 Mar 2024 08:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="erGSs0tJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C1AC2E6
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 08:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711011057; cv=none; b=Gxmqs+5TsKI8Ebu/Ahp4vByUL2s5gEfqoYF9HMlupFQrsLLfEONiEHKjlUSkN8OC3jpfSxPVWO9S88ob972OVspPmsuXxgQlUVb6OYrVITSEwMMY+7smxhPNZ9WvhrSv59QDyZ9Ryfwa+QrOQdIb61WsUBgf8/3BmYa6rNcd8sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711011057; c=relaxed/simple;
	bh=T9tH2WkqXIqAB3/EZYidnvaVwq80SxS0zPzjIGHGoVg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=fl46pIg1s0lKN8O98glcbJRf31UD1z50uMWiibUEy9kG4YLRuFXEHMUCqmDrUZqlVWz0pRYvPy2eszLj50bOKAGTmHT0Nw+8AXmCfw1tOIMxdNO5I0A4ojV4K62SDzdOXjIANmYq/AxsikHev3d54wvds41/zo82K6dJsKe0ebQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=erGSs0tJ; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3c37d50adecso536621b6e.0
        for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 01:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711011055; x=1711615855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cPjyd+yjOktFr1xsuYU5FVU17C6f3y//ZruUY/LClBQ=;
        b=erGSs0tJtIB4NsS/lHDe7kUu3PS4rU3nRiW774UpuNFH6IGIcg6xQd/s90abKDVCCb
         xrxvmb7ME5IOC80b99A6Mzuelp9TyKK5lRYSLjZ/1e7RUvOX4w/OAkNGWuWKbJOWW/eq
         9OsC+Q5MIegQRUg5oLbWbGSH2Z5ZE0fNtTuMxyoL3hDmJVgsL7rCEZpEEkn30sEKka14
         tE6nPma/Vd5gVmyMOo2WEf+YhuZHm4U94F8CgnXYbgVuBxOF2zjRrbsLDYWCWLa1Ge2y
         Ey4PjwAGN9NlgdfJ8JujBqAFRtzfm3BZxlOryC8zrFx2jldjXkUgqWk68FgtRIyycBXZ
         acQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711011055; x=1711615855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cPjyd+yjOktFr1xsuYU5FVU17C6f3y//ZruUY/LClBQ=;
        b=rB3h1CEheLXhA8y1yB/LKCk7CGzkcoICCAX+YUUsLN3PBe+tmE0G9GuLLjfEWiyNn7
         lPOOa4gx+afMFc/nYwvO6Kd4v0jDSAmAjgvo3EhOBHaPYDIRTQg2UWaxku7ndi4a03d5
         Nxyv02Gidys6CVT63JTujH2Xip3X/dZtA2FvebI3IjPoGRA+2J88hCaWaCu4RzsTXnOD
         q4ob9hUbkFZZCK0V3jpiADnPcwv/4jJDxUg1Ng8pn191msMfu9/hhl8mniPNtNO961FE
         zdumDFBgtmWc77bxFLV76pkhGH3h5esj7v/ktVhj4YiX9xZjj/tpxIGNzX4KPJ3HfieF
         nUGw==
X-Forwarded-Encrypted: i=1; AJvYcCU/Shu8amtXn1vdHTEeeAfEHYV3xnt1ppeTt3YnkNDj2T5trf5ktfBtv3jA6wM2wdOEMyAx7FLamfxZm/CUxm26lYdA
X-Gm-Message-State: AOJu0YydWVAwAe9I4x4gaVQ8qEdVQyE2QSD16c8CGPL64PMTSpnOkF9e
	DsW6nsi1XpO6J9jnueWxBN6c4mFFp4T3/XcgXwjF5gU9jEpYQODxxGFhvR4Wx7s=
X-Google-Smtp-Source: AGHT+IEvqwLm9D/zQrn6jO0supoJFFZJFv0l42kjY6Gp2Frdf15Yh9kjKVuHL7HqdWGlqp+r164FJg==
X-Received: by 2002:a05:6808:1a28:b0:3c3:896f:8817 with SMTP id bk40-20020a0568081a2800b003c3896f8817mr5503819oib.2.1711011055018;
        Thu, 21 Mar 2024 01:50:55 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id x3-20020a544003000000b003c3753dd869sm2275409oie.58.2024.03.21.01.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 01:50:54 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 0/2] KVM RISC-V APLIC fixes
Date: Thu, 21 Mar 2024 14:20:39 +0530
Message-Id: <20240321085041.1955293-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Few fixes for KVM RISC-V in-kernel APLIC emulation which were discovered
during Linux AIA driver patch reviews.

These patches can also be found in the riscv_kvm_aplic_fixes_v1
branch at: https://github.com/avpatel/linux.git

Anup Patel (2):
  RISC-V: KVM: Fix APLIC setipnum_le/be write emulation
  RISC-V: KVM: Fix APLIC in_clrip[x] read emulation

 arch/riscv/kvm/aia_aplic.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

-- 
2.34.1


