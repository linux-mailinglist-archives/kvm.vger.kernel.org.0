Return-Path: <kvm+bounces-61548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A78FCC2230F
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1EDF44F1C45
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85B2329E6B;
	Thu, 30 Oct 2025 20:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VmRawTbN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B683393DE9
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 20:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855050; cv=none; b=KJmzxiPNwBwX/AI/NGO8BDCM64+voMe3QMAfue9zXGe4SvuZaIjBB7dcDgeaB+74jDb0/bKxJEdjDMEV42w2jkJIUAAdizpyENKRRpIofLl3zYkkxkFB8TxcIbFZ0HPMNhfP30ZgntwFv344KvzRtcdU1FF+Huj8cdkIks9iGSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855050; c=relaxed/simple;
	bh=4WxHGoE93VOocFQ5wN0AUJ/80sFNRiS2hdmgOFi4y/A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ftg/wYif5ZkjWZ9vAQuHjy/4rNV4681LeCXef3eZJgn9efDiZ9i9FYR5H/0r5Um5s9cNc5xiVdAXNCkt9IZtOhuRfkE1I8rwq2rGJ59sMRvWmChH/o0ig275sx6PNfPafleiT07bAGKZgVj0/AsWWfaN65/xleiRzqh55RqBl9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VmRawTbN; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b57cf8dba28so1198545a12.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 13:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855048; x=1762459848; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=q3vUMZT0yYe1EXEiRgC8c4U03xvX09k6brWY3B4yx5I=;
        b=VmRawTbNAViiJiQpj/T71gWATAeSlhmr7dzX5KPAUeTJpZ1tsTsuufgapB047yQAmP
         J8yRP2yThpvFvFlSDMqdfD0g4SKcP7WpHKZQciWcQn/SkCPXVumuPE9P0dPM00sqE7xM
         fke0EbpU7W5Ri39dFAj1nL7srVlmwNY7oj4Go39PIUqs54a1+J9hEZ6bi/09u/jIrDLa
         VSl44p1XarJ51KQK7Zuv8dJPYoCDJince6wGoV7Sz06tB0rHw2ntJh0kgCXkfCfmJUHH
         Fq/p1+EMBMiFqSWiV4HuOol/v6nxdgVqVKn5uPzIBkGwdWKCanB+pgkYeZ7Al8XEN9mA
         AK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855048; x=1762459848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q3vUMZT0yYe1EXEiRgC8c4U03xvX09k6brWY3B4yx5I=;
        b=Fsdm/BczatquxbgyJi8muTD86qwrJIY1Zjoj0V1I8d4TrCuMHRVC5aPRlYhNSycF5S
         UKWkxlsH139t/4W86BK+U3zzCIPz/elxL5eSdSlflPFiVgXhd4WgHmwElIcf/6mnQaMC
         ti1f17zvRjhkpGJov6WZuCq7n9wKXMWDHrYP8wNwhpT8UI+JnpcI9JFGrmRg0hEA0puH
         rQ/a8TJ4cWrloiKHANZHfdX1/dBrwHz9t1lBbjqAXEHTyrgN9Q2OPmcA+BU1mGy0GAq4
         LvMFeUKrT3VwR+qU2htfzTsQ4Dm+Y/IyrD+edguSamw97HJ4t6u+9IhRFbKnOoidzSGW
         qndQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnC+7f0JMf7MEKOXnXD7iU5XTwDObxIfA8FOdrXSA9KSMqDVXWqJa/QOSOgWvyAk2Dv64=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxoo82JpSzy9jqa+Zhlj9Em0qxjPFjYXCqm7wNvsw1xoHhKEw64
	d/Q9F6Z+vdNXAYRyG+yJggvJPplcGPuGxBRrbrjh5naKlWYP4NayKsLDm2dTVpk85gDJUrlf10U
	vYHS/qA==
X-Google-Smtp-Source: AGHT+IGMIUiQfnFXRwKgU4xakuBoSsZwl0KV10BIrj34ojpFyNKXcMvJLG+bxMBFJqWMl0yCEf0bmf3P3I0=
X-Received: from pltj3.prod.google.com ([2002:a17:902:76c3:b0:294:8e58:7348])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2348:b0:295:1a63:57b0
 with SMTP id d9443c01a7336-2951a635c07mr12598385ad.23.1761855047670; Thu, 30
 Oct 2025 13:10:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:42 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-20-seanjc@google.com>
Subject: [PATCH v4 19/28] KVM: TDX: Derive error argument names from the local
 variable names
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

When printing SEAMCALL errors, use the name of the variable holding an
error parameter instead of the register from whence it came, so that flows
which use descriptive variable names will similarly print descriptive
error messages.

Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5e6f2d8b6014..63d4609cc3bc 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -41,14 +41,15 @@
 #define TDX_BUG_ON(__err, __fn, __kvm)				\
 	__TDX_BUG_ON(__err, #__fn, __kvm, "%s", "")
 
-#define TDX_BUG_ON_1(__err, __fn, __rcx, __kvm)			\
-	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx", __rcx)
+#define TDX_BUG_ON_1(__err, __fn, a1, __kvm)			\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx", a1)
 
-#define TDX_BUG_ON_2(__err, __fn, __rcx, __rdx, __kvm)		\
-	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx", __rcx, __rdx)
+#define TDX_BUG_ON_2(__err, __fn, a1, a2, __kvm)	\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx, " #a2 " 0x%llx", a1, a2)
 
-#define TDX_BUG_ON_3(__err, __fn, __rcx, __rdx, __r8, __kvm)	\
-	__TDX_BUG_ON(__err, #__fn, __kvm, ", rcx 0x%llx, rdx 0x%llx, r8 0x%llx", __rcx, __rdx, __r8)
+#define TDX_BUG_ON_3(__err, __fn, a1, a2, a3, __kvm)	\
+	__TDX_BUG_ON(__err, #__fn, __kvm, ", " #a1 " 0x%llx, " #a2 ", 0x%llx, " #a3 " 0x%llx", \
+		     a1, a2, a3)
 
 
 bool enable_tdx __ro_after_init;
-- 
2.51.1.930.gacf6e81ea2-goog


