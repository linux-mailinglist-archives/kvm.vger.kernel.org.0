Return-Path: <kvm+bounces-48932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E684AD4755
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:12:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C9123A11F1
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8CBB17A2EE;
	Wed, 11 Jun 2025 00:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UONvifDn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1A013CA97
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 00:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749600657; cv=none; b=kdLdKtHGwXgehtKwqVoXoA7KwqQ/Xw+IxDmCvStABHOChwhAWHC8QNADotvf54HbigJxTIo2YwFRWEY90mxoUn+f7ehmoh7eDZP0JIYQvcAFB0e+tr3145WF/CiDOZcUXcMqdhIboEXt2EEvImySAtkMDOH1sOzzwhe/rrfXrHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749600657; c=relaxed/simple;
	bh=tIVAjv0R6pUZqeCBUMOqA6Hwa6RH3vUVAalxmKoMGQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L9rDn1bNT44nBJDPevYF7PavbmN6CzxjYGFdupwoEN8B0OLAIj9Wm9ZJ1JFygIjIj8WvgCOC7nVTUDxdi8e+YHzn/FXr9zSHl3rofp/yZnWoiCQPr6+E3D7oWMUAQyLaP4lHKyYeqgCLwySwyojn0z+8WsotsrovxWgvxh6pu9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UONvifDn; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311f4f2e761so6420384a91.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 17:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749600655; x=1750205455; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zss/ktKZQOB/zxYHcr8l4OJbiGy6+R3+c8NDOsBeWew=;
        b=UONvifDnMtjMIaxMJh9oZe3DF6FlKFGr4F//EyCbLN7vQx4FcCJF4Qlri85UcuhXvN
         tnSFwmKBPwrC59Fb1j9s4s/w/YhzzG8XaSVUoFlNDxt/uFuDTD0J2ZR8t9Ka2xm7HouS
         NgjNwqiW06s3RHXtO8LaH2264N0zMv1Cb2Tmk6Z1Z4o/uei3djKB0nbb0DuunwHlOmDn
         GZaGChPglu3v/ihuijZJgDZbX80b69xDeWWakRHKiXFWfE/PYgQq0v0QWTja6ldPEdBD
         6I9n94e2xFImzSz8U085n3rggC0q/anXrqiGvsWEEJXtTd0vtnCh1jObNFz85PO3t4Vh
         7FDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749600655; x=1750205455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zss/ktKZQOB/zxYHcr8l4OJbiGy6+R3+c8NDOsBeWew=;
        b=hoLlPF39dRsVrDTBB38CekEYFpCcCTAUxS9MpU1nhi4hWqXS9F1vJMJIViqS/dG6SU
         cc23XClaylGl4c06hE/s0ZAxp4h+L76OFLIyVD3qrEPO7qf+MGgGYeaL3sUxcjG0ehud
         hY8yHv6atv2rOzsqBoA1P+jS4trNQgUPuTQ9EXwgstxNYNMgbSkROphyVC77ByIdUJ9O
         loTMgIY0Q9KpyMoFeXCkFxE51KZMVFKvAppvtzazlxuy+6wx2DU6C7j8FTkqyMRlAZIW
         vp0XuVx4Fe9UPmv7FkNr9kePN9Jr7VFH14kQCkox+haYza8P8G1QEfg6lmCYYCo+1/UU
         orIA==
X-Forwarded-Encrypted: i=1; AJvYcCWYxQECYmcFbJ/IOFyl/1A5ObKDys5DBFc43RX+SEEzDt6hpeBZElwMq/Ntd0I+Kbm2muo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ8rJQljuuj6G7ydVBoXJ0W8xTU5HlfqtDack2r2nM9Y4nVZbV
	e7zuqkLC2uUGdVzLq7z/k1wIESwq+gKJGNHVmtC3Rp/iDE05snedY6DFG5fiBmyuKzsAR5m5L1u
	mx7wsBA==
X-Google-Smtp-Source: AGHT+IFPf4zAcxMmKYyJF/0q0QWOeyyNBeEfAEV8gqM1cGbYGy338sgO6izo7nZMoEiNEzX0yDZpDSCyFlg=
X-Received: from pjbpx2.prod.google.com ([2002:a17:90b:2702:b0:313:230:89ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384d:b0:311:f30b:c21
 with SMTP id 98e67ed59e1d1-313af243a50mr1534626a91.26.1749600655513; Tue, 10
 Jun 2025 17:10:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 17:10:40 -0700
In-Reply-To: <20250611001042.170501-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611001042.170501-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611001042.170501-7-seanjc@google.com>
Subject: [PATCH 6/8] KVM: PPC: Stop adding virt/kvm to the arch include path
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Don't add virt/kvm to KVM PPC's include path, the headers in virt/kvm are
intended to be used only by other code in virt/kvm, i.e. are "private" to
the core KVM code.  It's not clear that PPC *ever* included a header from
virt/kvm, i.e. odds are good the "-Ivirt/kvm" was copied from a different
architecture's Makefile when PPC support was first added.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 4bd9d1230869..1a575db2666e 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -3,7 +3,7 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-ccflags-y := -Ivirt/kvm -Iarch/powerpc/kvm
+ccflags-y := -Iarch/powerpc/kvm
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


