Return-Path: <kvm+bounces-34197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 348BA9F899E
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 02:40:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 602557A44C0
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 01:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B879D7DA7F;
	Fri, 20 Dec 2024 01:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J3fCUG0+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F60039FF3
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 01:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658755; cv=none; b=HL/QKRgs6JQSNFHluyJDiey0C05hAlRDHz08XdoV0BqB7PZyD7CMrSIYSdMZbXhZ2IyYVC7wECTZ3XMOrYeXBUq+J47ZpJ1pfUrP3gwsc1nXfTzBRv/6cD8sLEwSPSvTSQerWRf7wSEetpgR+20ukWaH1ZtKcj2D1vNDSfK0HL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658755; c=relaxed/simple;
	bh=ngrqdUdgvu+/gBHMswn/cnVSO5lL2tVEodHB9BBNKEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qggdfu4g5G4v7bjRfICz2paLpwosNsLbPhwtKYoWRyDPy+L6tCpJ3dwkKf1GRcbXVRAMfu5leeYe2dt+6IpsTn1Yb/ckRRmSfs3nfTj6kfZYgxx3aNg6FBPO7IdYCKnqiXFFyBsu8zAhWqZlOly3tgdyESxyEMnBeIDKgxUDdLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J3fCUG0+; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-725cf25d47bso1339404b3a.2
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 17:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734658754; x=1735263554; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=C0bgCVLlKE2bsIas/97mE7OWeLqD3b90q0/zRCnz1gQ=;
        b=J3fCUG0+qjA9k190tJaAswaik3zjNOL4+2Sw7CgMQ9H061WzAk0dozVjK7kw2GWCDI
         UuO91ZW+4mu6WqaiSHbV88h/suLD3ewC05NMdSMhoxma1MMc/FDcEtKBswMC7JiS6o+5
         E9ODXmmjk41SSRbO2Kejy475eirN2GcjPwLS6eTYphaQyjmfKDNf0N4J/gXgUeEuZ7oL
         YOwqDValvINzFs7E9F9XUG97JBZyW1WNVu1q9OjIlkTvqN0BZiZ2POWqEOhmW2JPGU+6
         eepQvVpdIEz+VL+pcIzUVYdZlczml3pdY9Upoe2Qo/xWCqQpyMO/sUFrNZU90sLGrV0S
         gv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734658754; x=1735263554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C0bgCVLlKE2bsIas/97mE7OWeLqD3b90q0/zRCnz1gQ=;
        b=Hb4JTmqR7TLL7AjI75qW2NVFmRIjVWIVOU7JPBL0wqyofy6kJwQdXJUefqp3BkqfBv
         c43hbsVuO28cpb5ZpuM+9aI4ofSKTHAj3N8HpRyhrytrqMEzuDzoVvxvdf8UERhlrroq
         /Wadpfh2TvSsjNNoPfphR3brM/96RM57YoQ8ZDeXX+JS1MYbEaw5A7Sl9Q5CfgdgRzpd
         B5jq6tOLhKIsvCS+SISBAPF3N9eqaxAKoyG2bx4pFJU+XI+iiSL3JcD2WBNflV5B61PG
         AoHM15YUb2HP840QniAlD1qPhrpMlK1CKxzeK0nUUyURfEMLpr7ZJ7nHEsq2/mmMwsgz
         0XGA==
X-Forwarded-Encrypted: i=1; AJvYcCXxlXm8nv471+8A+m2M+bEFv9k7dUf9aAJL0qvMj9aDYyt+qKtHCTpM/7EwSypgg9ZaTrk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzX4c9LxYNhWuhUPy+4ULhNwpFOS7tZ27BapQqpUdh0isyDYeyh
	VqGwaQyo+WP7qo+VZccErxdAUqeVu2i9lhdqIxGuGebturfW/JLJLGCEQqku9gKrH5LLk3BTS4k
	7Hw==
X-Google-Smtp-Source: AGHT+IEnCf3mHfBvLfwshZ15Q9EpX1HZcjdF08kZ2lrJwSlTx89Hx0AQSr2Fy6V/QWuDYbh+JhZtgEK5cgY=
X-Received: from pfbbd38.prod.google.com ([2002:a05:6a00:27a6:b0:725:ccfc:fd85])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1942:b0:725:cfa3:bc6b
 with SMTP id d2e1a72fcca58-72abde404b0mr1283201b3a.3.1734658753719; Thu, 19
 Dec 2024 17:39:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:39:01 -0800
In-Reply-To: <20241220013906.3518334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220013906.3518334-4-seanjc@google.com>
Subject: [PATCH 3/8] KVM: selftests: Assert that __vm_get_stat() actually
 finds a stat
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fail the test if it attempts to read a stat that doesn't exist, e.g. due
to a typo, or because the test tried to get a stat for the wrong scope.
As is, there's no indiciation of failure and @data is left untouched,
e.g. holds '0' or random stack data in most cases.

Fixes: 8448ec5993be ("KVM: selftests: Add NX huge pages test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9138801ecb60..21b5a6261106 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2238,9 +2238,10 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 
 		read_stat_data(vm->stats_fd, &vm->stats_header, desc,
 			       data, max_elements);
-
-		break;
+		return;
 	}
+
+	TEST_FAIL("Unabled to find stat '%s'", stat_name);
 }
 
 __weak void kvm_arch_vm_post_create(struct kvm_vm *vm)
-- 
2.47.1.613.gc27f4b7a9f-goog


