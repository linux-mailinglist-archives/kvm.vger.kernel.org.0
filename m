Return-Path: <kvm+bounces-22909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4BB994475F
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:02:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F2C0286320
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEC18183CAA;
	Thu,  1 Aug 2024 09:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rxlcnSyx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2B9172BD0
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722502909; cv=none; b=JTTcY/3cM1I32G1THkqOFGEqb45CGN4d16kmfDHFv992jOhSLKmJDfjWZrwqYD/9sm90QX3XqGchIRuEAQpgUerZV/HGVnbfWRx+4YhDFoANScGzcTAI3U3mcN/TzJN8Af7d58OrvTxSPatZ6hPVuRVrKda1WOSEztdzIVPO8k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722502909; c=relaxed/simple;
	bh=7g0DlirT/kYCBVr+9dRDXVKvBiF25jbrjn9HL4AfHFU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JSFES54Ct7f2rSccsH0gRJHDDAF+3gltDg5GOof54yMM+iLbV/K+3d8VMDSTgEvALjyHahxFBMjUnXnx8DiqcnFUTiiJOOfaSJKTHOfnWGFLLQjsMtCVpf3flZ0u2+/VCQH8JBXN06uY9RvR59beM28DDGmDUTsiBl0vBPPpKOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rxlcnSyx; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-36832c7023bso3449916f8f.2
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722502906; x=1723107706; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8IHbq3nRTqO2jYrZNiv7GHjdo//AKiTG6CX0+AzFu78=;
        b=rxlcnSyxsmdCm+YTdetdXdPCyqIFVA5gvNxPbX3EfxzQ2i72TC/2P7rfGyoVfIrD+8
         MVY6/peYjqQnUMh7SLLlVxBNd/AyIWH9Y9TPVWX5wqr+PnDD34m7FBCf8COA6+bUJCXg
         ylv9tkA9v6oeesdIBDGLHajdlj8YxPaAjDi1Ts+hkhOnzpHvLeuYouKuYnrFiw4UWeNQ
         9CEWCvCa2hSqURx6/mZN+BpF5UdN+9xGXVxQtMjz/YyNXXf8y41rRrXsdUAn6SIZH8HL
         y4Ffo7d2klzM9xKw0z0SVzLObPwHUEWHVxl2yaxtbGYgA2Wr6NKPo5tvWLwoZjGgkF7N
         iLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722502906; x=1723107706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8IHbq3nRTqO2jYrZNiv7GHjdo//AKiTG6CX0+AzFu78=;
        b=SIVf7T97Q5s19VH5r7YTy0iiww8t3W54D56dX+9ByxpvZu/PAwRHF27BPi7j0aEeH0
         PHJjfJ6UtqfmcDjlC0oZ8kq6f98QBw32PBx5tn4M5SdC04jO7R7z4nWSmxU/wcswTWZY
         /5FYjBLZRvIUHGw848dDX8r37aIyLEEEy03T0maETCVN4f9LHZ/SXiUf+fHUo+tVfTlz
         uVvX3hjkiASVg64XwuH3i8kihmiZmEZHgj00Ph/Kw7Al9tGFw3NFVgvKVBv5x86j9YR8
         4dHFWehpAhO49ZtF7imgeMLE+iKixsXDjgqDz0oPHaE+/ffLVBYKUN6HJRQZU91P8siX
         PDAw==
X-Gm-Message-State: AOJu0YyfAyIwVNULKG7rVoyAyQwCI2k08X8u9m9UeqZHIEN090qfSCjN
	z1FoWAYg//s4aNziPTuckDQv45HhMwhWI5OqUuwRGGbS9BhgpALRxBaiiSy7nsVdL07jmhebGH4
	flySe01uGpKdb/AD9pYXtE4aOiHDWDhiwwAJ2lVR9qf13cQ3Ga1SOtQ6ewczjIjcv5yILsOaaei
	P2rm4GoKuVdpH3j5m4R3kYGVM=
X-Google-Smtp-Source: AGHT+IEYAOIgImAvC/AtXq27Mfc53Y7PA+fVTX3Rlx+IY0/mIU2S6P/V0TnGwu9UoSydDFeidGnaFL2tvg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4569:0:b0:368:5d2:9e5b with SMTP id
 ffacd0b85a97d-36baa9ed838mr3368f8f.0.1722502905208; Thu, 01 Aug 2024 02:01:45
 -0700 (PDT)
Date: Thu,  1 Aug 2024 10:01:17 +0100
In-Reply-To: <20240801090117.3841080-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801090117.3841080-1-tabba@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801090117.3841080-11-tabba@google.com>
Subject: [RFC PATCH v2 10/10] KVM: arm64: Enable private memory kconfig for arm64
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Now that the infrastructure is in place for arm64 to support
guest private memory, enable it in the arm64 kernel
configuration.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 58f09370d17e..8b166c697930 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_PRIVATE_MEM_MAPPABLE
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


