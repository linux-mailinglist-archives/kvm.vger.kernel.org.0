Return-Path: <kvm+bounces-32636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA789DB06E
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:56:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92D8C2820A9
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E88C3BBF2;
	Thu, 28 Nov 2024 00:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UgCmZ9iZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FB71CA8D
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755357; cv=none; b=LGXE4qP3XNJcyxaBG+dbbP3mVIAFBqSL4C8udyiQWsc/uMOgJtZ7ZX7kAJX86976dE46iyXU3EdEDelhTVFwRS8ojPVOx7W2ALJg6ZSv/vvKPWYTyrdHEmSFCICLolfEzwAXAybA83BctWtnWisg/wRybycSn/n0J84Sch0YYjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755357; c=relaxed/simple;
	bh=/I1QDhTu7A4uX6aQjK9uL6OFtLwJ4Jmbm1md8fy4gPw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oSXWecEIBh/Y2AxJJlxPuSvb+sJrxBROb2qXGsTeGPEszAFiez7WhdY//CQWRUxHmbbTVBdvBd2NFX4YXDnyDLbgPCtEF9dN9B/oE2sqT9afMgZH0jl3W0zflq7ALai4j+GdkSbWSGq39nNc1gCeY43aRiJTbK4lmRJz/1ticww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UgCmZ9iZ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea2dc1a51fso327619a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755355; x=1733360155; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qVBMujG2OTqdwJQgPPGju5b8tNjOmRcixGV2iZuWWwY=;
        b=UgCmZ9iZ4JA7nZC57i4q8YFvqd4pfMTFRWrZY5Smb0SfHVQOWhfGZHmJ8pxTdfmbmZ
         qIr6bKBWxZiaz8iNZblUSLnJvOw88WQD6DSJG4mWkYlTIVQ35f5wMIakY0yclU1VTdkL
         si3YDnSQ1C6qeDFTaS2vtiK7S45VaaJmVZUaJzEjdPytg7SP/l1mxYQUj1oxmC+UQsmh
         jHr3bBkLC2akZbDN7w4uKKf5xvvHdC9AnZzrLYsNydKAXWlBpaySbstWwhAkn/s5yYRe
         z6nPSQu4R012rvR/P8ICe2CLzXDc9LAhk61YMrwR4VYrWimvF623jQmG6mD5oSsDRXX2
         W4Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755355; x=1733360155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qVBMujG2OTqdwJQgPPGju5b8tNjOmRcixGV2iZuWWwY=;
        b=ki2hlY4fTr5PbdqjGinnUsA1OuvP115k6tgh5idnqoFQjvzsqYP+W05wATRN1CPdeJ
         7+D8ZYAkxHvbyAaJ4lZ8YiwNVbCwc7/Rxp96ersIZKadILdBI27onrShjOECcbO9ZmrC
         0TcB/qq1qQTlui5LTac8Ytc4yRV9FjTDzvgdm89QsUKwoHLHONB6iWli9ScvTP+jrL3E
         CJPslNVwE73MinSUWhS05+G/9T6W4nw1ZcMDeNppz0wVV9m+MjYlk2uoI+tm4gFO2URT
         9rgiaYWkns74ktW9RupM1Kp5zNLMa4Hy9Qg0RBnqMLGqfg/6kTzJVR71AmH0PDPnifWl
         EfmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEKlmKngkLJZiVuAH8IWncEsnH33pDcXQ0XatXy0rLymeC1OmwdDGF+3iPXji3I6ofQ84=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya7xaCJIMYyNXtQQEknF8PLdePnC1sOLgzIM8JAFONwXTYWzTd
	ycBFXCd2sB6KjiSFpKJP8WY6pkLdOLCkLtiL/Lgltrz2nxDzcauqO8e8D0F2O1AlECQ0D45T4a9
	BuA==
X-Google-Smtp-Source: AGHT+IH+xlYFxzyyjYgkHwbv9v8SXpOlp7wHMGVgiCiV61K5VskA6YHcas7fec5b54n5jx+SjDlTSzyBffA=
X-Received: from pjbmf12.prod.google.com ([2002:a17:90b:184c:b0:2d8:8d32:2ea3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:388b:b0:2ea:7329:4d
 with SMTP id 98e67ed59e1d1-2ee097ca9damr5929096a91.34.1732755355263; Wed, 27
 Nov 2024 16:55:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:34 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-4-seanjc@google.com>
Subject: [PATCH v4 03/16] KVM: selftests: Assert that vcpu_{g,s}et_reg() won't truncate
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Assert that the register being read/written by vcpu_{g,s}et_reg() is no
larger than a uint64_t, i.e. that a selftest isn't unintentionally
truncating the value being read/written.

Ideally, the assert would be done at compile-time, but that would limit
the checks to hardcoded accesses and/or require fancier compile-time
assertion infrastructure to filter out dynamic usage.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 287a3ec06df4..4c4e5a847f67 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -707,6 +707,8 @@ static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id)
 	uint64_t val;
 	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
 
+	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
+
 	vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
 	return val;
 }
@@ -714,6 +716,8 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val
 {
 	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
 
+	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
+
 	vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
 }
 
-- 
2.47.0.338.g60cca15819-goog


