Return-Path: <kvm+bounces-58801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04211BA0DEE
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 19:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F16DF3AA807
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 17:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA31F31DD90;
	Thu, 25 Sep 2025 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="phqyScAG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E540A3191DC
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 17:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758821362; cv=none; b=UiGAlekc7IiLoM2P1pdQEsBmASXkDjaolz1fRJCefJZbB7wBQMeWL2ht1TOreRMdmUqP+P4+fFUffTlMGVeCkO0jP8lXXQBi9JARBxwbdrRbqB1OIi023eGCaULOk+WiLRukbMFd2iN0yG9FmFzJOApoIn8J5nOXpT3mkOglZsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758821362; c=relaxed/simple;
	bh=kyNUo03VHcUtqgem5Ure2zDndq9TR63HAvb7v0MESQ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bbs1blpqvliTCz9PDy5aPd+87Tr8cweE2jCLu79jgj0ut3GCzybnFY0GxCTo7ufktvaTr+e7DH7hNH0cygYajmBC0O3xxjwFXljgE1u8bKFnbhJ2FGYVhmWgOCUQ9PqVbPZ02SUQlWFuSj0X1vLrgn9hmdlJQAyzMY3TY9zqKVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=phqyScAG; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-781044c8791so880670b3a.3
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758821359; x=1759426159; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3MAW67C+26Du9WD+afvdTUdsrfWFPaXzJwetR1H+pT8=;
        b=phqyScAGkUBL9wXzNie4OEXIrmTcV42jIoB6IEB0Sq1H+T0wUvuThPoMB6GJYM5Tab
         x+dvPcOT7vIGFdraHA2cylqsnLeCORas9YDvcC57qDiSVl/WXRFfky5yup6rT4vAmuzD
         u23tLucbiGZQKi9e+eDw2tjKh1BCzxHU754xw6Fr9Cmv20LAFlMCh76mu+VxA30USd4n
         PXx1PtblsY2rHhVGKkjRUyf7w81o9/j05AWMXQZltuxd65DuJQ8z/aG27SLBVA0zgMSx
         Mizz/VALe6ZbjB1WxImhRP8QJ/E3J0ay86Indn/NGTov7RgoSi9UgNdWe6jELyRY0yXu
         cHdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758821359; x=1759426159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3MAW67C+26Du9WD+afvdTUdsrfWFPaXzJwetR1H+pT8=;
        b=wSa9s8diTQefPWYStSOUwkyoQNT9VQoI+8O8WNLM5hWTq6EGAq++U0Ji+7idF8gK2M
         aGcdyV+niR/9yCQ/V/kejtBR0At0KVxu0HHZfSzE80xK6wBtalUoIJ+EljL4TIGy1sa1
         PSU9XZ+3WVP/a1v0muOjylVI+52Qi97wFFSFvv0F1oGQ5szuENySlYG47lpxozDhT6ue
         NszEFR5/4cuyCbNnwmhN/hJBM8RHSwFi2Ge2Qg4nzgVFJkv+nJhR+r25jbu9g79vcNrj
         9qrfkLed//OEO8LzRiKYRx7n75h0o57FCjU9hAe6okCVCbQvvgt7L2tE5BYH6A6t/Gz3
         Sn/g==
X-Forwarded-Encrypted: i=1; AJvYcCXrsD7j/SQOZok7Z0fAuy6ILYkAY9veJm+SwufDk7bXR0GaO/SdHHce4mtcMrpMgOXr1ss=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/lSOewlR9S88shFKCwDcjds8/ACDAdeTUN1VcFhSJbKd+FayT
	Um/VTCVssPeA3QqcuyPn+z+EMWHELa2rYESWLB2lPjd9vRY+CmhfiQBRCcgoFgvEDm7+nLZuCbV
	mSg==
X-Google-Smtp-Source: AGHT+IGwUeh3R66fQdhA9+GehJSHKHpxVELu+AiwXNl9uAO8pVVzXP1LD+WHAVUHsIgABaveFX8UT5GZaw==
X-Received: from pfbk26.prod.google.com ([2002:a05:6a00:b01a:b0:77f:5efe:2d71])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:8895:0:b0:77f:449f:66b0
 with SMTP id d2e1a72fcca58-780fcee0494mr5488295b3a.32.1758821359006; Thu, 25
 Sep 2025 10:29:19 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:28:40 -0700
In-Reply-To: <20250925172851.606193-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250925172851.606193-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250925172851.606193-13-sagis@google.com>
Subject: [PATCH v11 12/21] KVM: selftests: TDX: Use KVM_TDX_CAPABILITIES to
 validate TDs' attribute configuration
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Make sure that all the attributes enabled by the test are reported as
supported by the TDX module.

This also exercises the KVM_TDX_CAPABILITIES ioctl.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
index 7a622b4810b1..2551b3eac8f8 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -231,6 +231,18 @@ static void vm_tdx_filter_cpuid(struct kvm_vm *vm,
 	free(tdx_cap);
 }
 
+static void tdx_check_attributes(struct kvm_vm *vm, uint64_t attributes)
+{
+	struct kvm_tdx_capabilities *tdx_cap;
+
+	tdx_cap = tdx_read_capabilities(vm);
+
+	/* Make sure all the attributes are reported as supported */
+	TEST_ASSERT_EQ(attributes & tdx_cap->supported_attrs, attributes);
+
+	free(tdx_cap);
+}
+
 void vm_tdx_init_vm(struct kvm_vm *vm, uint64_t attributes)
 {
 	struct kvm_tdx_init_vm *init_vm;
@@ -250,6 +262,8 @@ void vm_tdx_init_vm(struct kvm_vm *vm, uint64_t attributes)
 	memcpy(&init_vm->cpuid, cpuid, kvm_cpuid2_size(cpuid->nent));
 	free(cpuid);
 
+	tdx_check_attributes(vm, attributes);
+
 	init_vm->attributes = attributes;
 
 	vm_tdx_vm_ioctl(vm, KVM_TDX_INIT_VM, 0, init_vm);
-- 
2.51.0.536.g15c5d4f767-goog


