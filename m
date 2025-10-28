Return-Path: <kvm+bounces-61343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1F21C16F82
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:26:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B4C33A450B
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5007935971D;
	Tue, 28 Oct 2025 21:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RBgOfSXk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C648350D62
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 21:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686476; cv=none; b=tYEWAG7abDPmD6zlKE0TgXGwSA+WxgIG+o57c4q0vIz7GbiQCixuhmaEtuyX1/0YvVCrd8blZsM8ScRcIxgvq+OwdyJRGdBKKjfOQtQqeyrmAOrx4oBv+qs5wdds3CR4ZsVh1AxDyqHxB1zPq1D4CI08Bh1AHg5+jT7arnvve/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686476; c=relaxed/simple;
	bh=Z4cEH/EyFJtC+7YubXLF9stWj6X2tJBOoSAojvblL2I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S3k7xvBj+zaF3FVb0r9azdv0fghopwPqD8b+tPvrZm3FKK5xWqTyGy/D4HTY7SyH/DK3fajkMsF8ntp5P5cTsAuK8joW0IC3GDXB7LzVH3NaEDVnsKk9+DLx70SQGdpLyFHeYqvqA6UYFOc6P/mI1eovUOHI9s4tOeazcsWsLVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RBgOfSXk; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7c5311ee244so2154779a34.0
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 14:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686473; x=1762291273; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tG66zI1+tyqk2y+i/GC8wCSgfETT28ZitF9FwVU9vh4=;
        b=RBgOfSXknObZks+7DWFnq7bbTk1tHiWSXMyvz62RxHxcmGnkY/FFM7JQogFf4JVWMT
         Dy8ko3kpnLlLw0wtKv6Q/23ZqYHAmQWqE1lIddp6VZ1lzposKCEy+j/7bK352AuplSzi
         Xv5mMpOP2VnFlTIeP0H8qRQz6v0inh5NkJm9dv9Hz4hmhTMwt1cJ+Ondm7RoOyX6g+23
         qZc7SQdxuJyeYm577Ryv+cnectIa6Zu8tcT+67bQOWYU2jmuYKGplYdpfsrAf2ggp2ot
         KV3N43Npc1m5WhmCGw4XcWL6pUhqEldDPIcuWoU5AbuqPFkbHD+wOt3CgHBfxdS/PtCG
         WpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686473; x=1762291273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tG66zI1+tyqk2y+i/GC8wCSgfETT28ZitF9FwVU9vh4=;
        b=qCFs0BmubDEP7Qkkj72FV7DWHu003yOf+jpavlnms7IddWVdHrh4ud2oCTs/7v+rxN
         naaHbqJy+YBpEnS9uN9HJdTuP+4zylu9ugk6MTKf/MbhRuQU/isBQiTNTd9OJGUqMv67
         u4I98aEJGkeeDDO4i6rKubpVM4dVdJNo8OocI6Z98brp1FqM0j1nmDfOrD58FZXg1sIQ
         vQ8IevDH8zFSZ3PFCxpOdxyiHww+JaloQaIzJ4j59z/Yl55G2IIt7brkFP3jyI5apXZH
         dKbDdY09pGyIS1tY1DSyIeqoZK3lIHuOTJhZU4HxrarUST2167EwpKRPRBsI62KhMBuH
         BYng==
X-Forwarded-Encrypted: i=1; AJvYcCWCyLH1I/0y5wlVh0/hYea/Uzx6vIdREWq1nJZMzZsnd83KtwZ5EgKIRIpNocV+HpYpZ6s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBUP8Cz4KZaJ1tJMVp5JbBMabVhnBMeBXMKpfKNgXBtP/CmU8J
	zM34WGdZdzTfq1AkGinMYuzNGwLeEjIIbSdoIyNRpQ+GRpMgf6dtkZrqKpV2VXMNI72MG7dMFGS
	dXA==
X-Google-Smtp-Source: AGHT+IEfjTcwiq0iGyeXz+L4N8OFRtJMWuG/A0eLPmPx9/8CzxaM1HhxaEpsbWAoy+R/iYIcBip4gWY4ZQ==
X-Received: from oibfc3.prod.google.com ([2002:a05:6808:2a83:b0:443:a4fe:d05c])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:2f1b:b0:44d:ad7e:384b
 with SMTP id 5614622812f47-44f7a458e56mr434238b6e.22.1761686473114; Tue, 28
 Oct 2025 14:21:13 -0700 (PDT)
Date: Tue, 28 Oct 2025 21:20:45 +0000
In-Reply-To: <20251028212052.200523-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212052.200523-20-sagis@google.com>
Subject: [PATCH v12 19/23] KVM: selftests: Finalize TD memory as part of kvm_arch_vm_finalize_vcpus
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Call vm_tdx_finalize() as part of kvm_arch_vm_finalize_vcpus if this is
a TDX vm

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/lib/x86/processor.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 17f5a381fe43..09cc75ae8d26 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1360,3 +1360,9 @@ bool kvm_arch_has_default_irqchip(void)
 {
 	return true;
 }
+
+void kvm_arch_vm_finalize_vcpus(struct kvm_vm *vm)
+{
+	if (is_tdx_vm(vm))
+		vm_tdx_finalize(vm);
+}
-- 
2.51.1.851.g4ebd6896fd-goog


