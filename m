Return-Path: <kvm+bounces-33187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ED459E62E9
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 02:03:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E36F8280F7D
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 01:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B184A13BAE4;
	Fri,  6 Dec 2024 01:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NRA/L3Er"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0207E0E4
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 01:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733446975; cv=none; b=sh2JBQo2i2s6mw/PbXaie2ZUvcYA/1mJ4XzkP/9RXW3owDSs0XZKK5pgEKTulElOZBGL6x5LAfegtWpSUDN2S7X/pSF/5ZKaQB7x4Ntl/IcX1YNMR3UX0XDoeNxxdtrCjut5MvZRSCbE3Cge2zqHcHXjTA/FXmFkJSA73cQZWuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733446975; c=relaxed/simple;
	bh=p3ayRHOyJ37cYdE5ih5cbVRLX2IsH/iMc+NXkzKTL5c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ew0B+sv5Y5C7FYwHY9j+s9wL1wedOVMn+Ygyz+8hqDhn9+Qz7u4qIindMf3TjvoNZWT9FYfyX1bqK9+teJebVISJmHR3Jj5/smYVE9fqUa2oTxe1NnR1rn8S0AXySDz2vBu+nxNcbDttSbr4mmH6FfZFzrd3m6Ku8UHlYqALb54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NRA/L3Er; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee86953aeaso1561251a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2024 17:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733446974; x=1734051774; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=odFeXfqtlca+kvw0AmBBC4wYZf1vb1zFbu4qDCM5v8E=;
        b=NRA/L3Er5i8mGdWywOoxP72zMRsg0DTlEmvuMN4oy35CY2J2kHwKa2zoKyJa/WwhNq
         0J8qrhrk63hhIolLt622xin5AwmOKJuLJ0c81+TrsZMaw2Up9Mfedh8t0JzNvt4mbAbi
         Mske48I8z8EfLpq50VyIYyFYU+7aY0h15qBH0ofYrKayttRz2F7xBNUSNxviP+e3I0tI
         OsLUSe2w4tSK2Xy5MRkWZ5YLpFLYVHYVdqlsdm9cN/Y0jWao9uFr+HqV/CugBI8CJqts
         mGg5u/Q8HG5noOJDB5D/4TLLSEf0l2FVUgsJeJAIVcuTEaVY6bRPN2OE+GE78xuNGj/5
         hA1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733446974; x=1734051774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=odFeXfqtlca+kvw0AmBBC4wYZf1vb1zFbu4qDCM5v8E=;
        b=Qziv9Js/UysNEnhTW58cQjUj0e/1KSv5QknNTC4JJcb2qaRdFFUqk44SsYp9h9SA6x
         0yJC9e/xl4QLGEgOSws/5sf8z/UW7aCsopx/wGHpBvSoikwzWAwg2LSMyTC1Fj8zrLoR
         q2jQquR4Ifw5DZXdpbuiF8LS9016P+c+JAxHxuKpAdn2T3vwhogs9/roM2e+tTYwPE88
         IOcnelfr1XB92JGiIfK1B2k+Mzlvfbr6nPBHNGpkIzJYUBh1KgzMx8OmLiYl+Do2X/sI
         1EHFd+6Oeppn3RvsEv13j9+E/8JCxyLk/GyDUSzSkuM8Nd0n7Ey/iN4ryPqGykpsaJzq
         is2g==
X-Forwarded-Encrypted: i=1; AJvYcCX8crruG5Xh86F8KDQj77cvpmGvlutH+/h5Bp1QEpt6S+IiIPalrJHjPQJ94JgdL/waTvM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzydTMlwlhbH+ZDRp9QwRZwrN9TB6v2ssssyg9YnASfcVZKvtug
	lD/owse+wFO+32Xpu3TlirvE9ubK0E662vlB7Kl/LoUqx4Vj2LgnZnDqZLDeDPebTxHLXrR99Mx
	PmSD2Tgszsw==
X-Google-Smtp-Source: AGHT+IG/xsuehHtVKFEvmGgFIgshQ+B4zAUcgF8mwEzljCVlVfmJ7/hjNhV2sOIJea1Ftx1RfhpzvhzzdrXv8Q==
X-Received: from pjbqo11.prod.google.com ([2002:a17:90b:3dcb:b0:2e2:8d64:6213])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c07:b0:2ee:d024:e4f7 with SMTP id 98e67ed59e1d1-2ef6919952fmr2142759a91.0.1733446973755;
 Thu, 05 Dec 2024 17:02:53 -0800 (PST)
Date: Fri,  6 Dec 2024 01:02:45 +0000
In-Reply-To: <20241206010246.40282-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241206010246.40282-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241206010246.40282-2-jiaqiyan@google.com>
Subject: [RFC PATCH v2 2/3] KVM: arm64: set FnV in vcpu's ESR_ELx when host
 FAR_EL2 is invalid
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, duenwen@google.com, rananta@google.com, 
	jthoughton@google.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Certain microarchitectures (e.g. Neoverse V2) do not keep track of
the faulting address for a memory load that consumes poisoned data
and results in a synchronous external abort (SEA). This means the
poisoned guest physical address is unavailable when KVM handles such
SEA in EL2, and FAR_EL2 just holds a garbage value. KVM sends SIGBUS
to interrupt VMM/vCPU but the si_addr will be zero.

In case VMM later asks KVM to synchronously inject a SEA into the
guest, KVM should set FnV bit
- in vcpu's ESR_EL1 to let guest kernel know that FAR_EL1
- in vcpu's ESR_EL2 to let nested virtualization know that FAR_EL2
is also invalid and holds garbage value.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 arch/arm64/kvm/inject_fault.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a640e839848e6..2b01b331a4879 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -13,6 +13,7 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_nested.h>
+#include <asm/kvm_ras.h>
 #include <asm/esr.h>
 
 static void pend_sync_exception(struct kvm_vcpu *vcpu)
@@ -81,6 +82,9 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	if (!is_iabt)
 		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
+	if (!kvm_vcpu_sea_far_valid(vcpu))
+		esr |= ESR_ELx_FnV;
+
 	esr |= ESR_ELx_FSC_EXTABT;
 
 	if (match_target_el(vcpu, unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC))) {
-- 
2.47.0.338.g60cca15819-goog


