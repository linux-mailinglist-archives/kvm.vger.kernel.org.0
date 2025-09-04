Return-Path: <kvm+bounces-56759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BECCB43317
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:59:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 521893BFD85
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2BC829BD9C;
	Thu,  4 Sep 2025 06:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4VbrBfsf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D0F29AB15
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 06:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756968927; cv=none; b=O1R8LpOPEwN+6/6Ja9WrTkJ/LFxdRC0kKbZbqp/4bfBwfDhIA+TYHUq3HExB4zqcsQrbE1TtP4IvkA1HxBJ5VLQyjeQpt3/dkje0N3asZZt2fxauVmMGcDrqb/kTJKiDC2858b2aMftnMyJeu/KQ2KP86UQQav6poYjkObmkw5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756968927; c=relaxed/simple;
	bh=kdmXN70NkCarKlPiM7rjh7lKLuyNoeGTY57Ar9pmI1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WChUbXVqIHIZ17cTV3PrauLRb2BpBAItF8lcsiwgqFu9FosWuXjBQ93ckubX2gk13341GJla4olmps9VwN/iIkbXaEMTaVrFhP1wCQq5Q2xBoLN3oY5uxkp/xt0Ba0Igb8qfFsx4kIfhLYM+3w/DRsIyfvLZCiclNlrrNYVfZ24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4VbrBfsf; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4f93fe3831so893881a12.0
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 23:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756968924; x=1757573724; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YqMpdEsUV2fviIjFSLurfARDNWwMLyzNa0D38zVRRV4=;
        b=4VbrBfsfq5xdoOu8ahuhN3hs+2zXZGA4GvqWDS/m5v1HVqPzy0pEi6axeQfI5LtcrA
         KcxVnumuBgba7LpP/4ZyhkD2Y7tqQLWwV+3s+c/gx5SwBQ0J7SCzzACF0gt/jbiqQfbR
         ToPPRWMVNy4fkOWLFLdJ8Bh7k1jxM9e4Krd3TdjLs/Ngvxea/gqnWfoNzXHoLrEIaXs/
         FmWxb/+K9hHHTW2fN35jOm08UyZt4N2WsA0FvhiBbSctFV1obVMuRsq0uEnGfmVV9Jd2
         MeY0lRTCrU+aaChWyHcfltIAmF3yoxZmB/5ea/M6bQwDu7nrGCtDJUyywy6Zr3DAP2Za
         uz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756968924; x=1757573724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YqMpdEsUV2fviIjFSLurfARDNWwMLyzNa0D38zVRRV4=;
        b=o7U49sLINirDk468Cfn+1MIRo1YPdY0RgfbdWUUxPTxL1NwsfJJZjrcKpIYKqfm1W+
         US1UFwBYy0S6rHKAUuK68YO3U1YLmAIBl48oMoNwTJDQ2Z3MbQCqCNU6sl9+6wx69z4E
         fRJtbyyNUn1cP8kfXlZBS85KBBSb16c1felkK8M3zkcz6U7gQkesCQeQUqpxzu/91GKR
         /8ucIluGy8pbAgs8XYu+bAISQQDzhBliiiwtNh+672Z9i94xp3IHkmvbC+zxIm1/7xvU
         7mAEyO5Z5TA/dnUBp2yjmw3yvroPOIN/mRxSmcC2aXiRzO1bCAejNUcShhYHjC5jvEia
         qykQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUNIGZZ/wJMIpSAAlsy94X64XelhP9Uk1kDRHlYbwq4MwyH745uky71Pt1W5YcyLEUpxU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdDBegmLZzOONINAIu6F/zSHRSe6HffQKEeRdn6ITN69x86T/t
	I/1JeZ+7wZDowzNIAd2rk14Hhtuf6MG9p0KOtX/jW6MeumpXOt6y8uEDnuRZOjkbacfVtghiEFQ
	1WQ==
X-Google-Smtp-Source: AGHT+IHU8aE69lKsl42MpOIXvrUGk5nPmd3Q6iw3H5xSke4+EKRTEKinRjrjK+lfCvuFoVBO6ts+bPx8dA==
X-Received: from pfch21.prod.google.com ([2002:a05:6a00:1715:b0:76e:396a:e2dd])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9997:b0:243:c76d:ac8c
 with SMTP id adf61e73a8af0-243d6f051cdmr28758575637.32.1756968924573; Wed, 03
 Sep 2025 23:55:24 -0700 (PDT)
Date: Wed,  3 Sep 2025 23:54:44 -0700
In-Reply-To: <20250904065453.639610-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250904065453.639610-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250904065453.639610-15-sagis@google.com>
Subject: [PATCH v10 14/21] KVM: selftests: Call TDX init when creating a new
 TDX vm
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

TDX VMs need to issue the KVM_TDX_INIT_VM ioctl after VM creation to
initialize the TD. This ioctl also sets the cpuids and attributes for
the VM.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/lib/x86/processor.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 623168ea9a44..c255fe1951be 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -641,6 +641,9 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm)
 		vm_sev_ioctl(vm, KVM_SEV_INIT2, &init);
 	}
 
+	if (is_tdx_vm(vm))
+		vm_tdx_init_vm(vm, 0);
+
 	r = __vm_ioctl(vm, KVM_GET_TSC_KHZ, NULL);
 	TEST_ASSERT(r > 0, "KVM_GET_TSC_KHZ did not provide a valid TSC frequency.");
 	guest_tsc_khz = r;
-- 
2.51.0.338.gd7d06c2dae-goog


