Return-Path: <kvm+bounces-21392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F9C92DD0F
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 01:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B415928782A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5BE16DC2B;
	Wed, 10 Jul 2024 23:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SiNK7uLO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815FF16D31A
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654979; cv=none; b=ZPSPN+f/AqF1lDnY0+Zb1Zu1SE17NhgZQh1nCLKW4U+vAgxiZGQOfqPGPn7YK3z9DOBGza551K8JQTdXa+4HcZlvyqpUzd4WwnkCXiMPKMqZbSLz/+BZ80WzGxAqpEo5AwgXRDnPgcIXkPfwXZMFn0YWSSovi7QJaoAOj4IP6kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654979; c=relaxed/simple;
	bh=iHtMvGL4vF0q+lVnlkIHLSBIYFMj+gNaWi3Gs2hOk8E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YiEQTOkPfUlMIGPAQ1VbkLJe33ZTHRg0xJ5duk7y2EPLelYz9mS283AwHeCR3rPBRTxPmRme9RXHPrmSxPb+ZtlWQICEFav063Rt4fF7infuOh5VMhLJaqUkdQXxBiAQCRtv576AhLfdqKrwfjXXomiphA0ec+TI+NsHuh8oaLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SiNK7uLO; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6522c6e5ed9so6416417b3.0
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 16:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654975; x=1721259775; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x2NbmmZjpjJMl8d0fx4CDZHX67FcpWijiAzz4EJchKg=;
        b=SiNK7uLOX8sumtAb7yl27cqs0OHIVqIv1p2Id4nqTJufixjPgISkGXCE4yOeXipwJU
         RsM0jTf1Turqukq2i1ej5FjE6ot7dx4aEql2yJdiHShzNbmcO9kwlCTpD/AmRj4FX2u9
         hpsdi86UjiwTTU0lNHJwfqcoDCCr34iupDpGkn7BV+0lG1Wm5ii5YYe2fJ8rzDT1yZgu
         /P0TEKgctg0YDDqIP1C79/0pUKC6FJCr7c0ei/mvVnLXo5xj2XlJ/fWjbkvRjGsTkPEe
         G+Mu6jI3/SUEf0uBAxKpDF2GvWHTv5ARSJhPOPNSL7qoBBjafrDgQTsUm6yYizG6z3h1
         VTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654975; x=1721259775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x2NbmmZjpjJMl8d0fx4CDZHX67FcpWijiAzz4EJchKg=;
        b=Ftkj53gZ7mZrdBJJt3tiMWFMb8GL46hnDzwXns7MTXMDW25Ciue6X59sSYfXpAQdwf
         vfcBl+6qwxoz4aVSkVGQmmj4Ta/YR6D2EKTKR4oW0jAasPV93EavSWaYdUYiZZseHaZS
         kufqgrjn7iQpwDXvqTRyRxAVWjCSc6rzqNed0zFjnW9iaWILX4lHNnndsYZz3KwN1pje
         0srVn5pGzNIN3DuZJGWNnIasFQUYrb8YG3EQ6wshgN7iMo3WxmB8oGogzM+uGiiz4xSQ
         pRIPGYZGNkF74xbW/vaYlM0KYopMAUyKU9OQO3iwwvI9iJgdgv58Q66B9lX3N1JLz0GK
         zjyA==
X-Forwarded-Encrypted: i=1; AJvYcCU25yAnRw83EsfyX6nY0Fk5HqjqSb0icaDtdjP4HUAp4iFiEZEd+q469L8lyA8vxtfpwfYg/HdtYEcjV7MkUa/9vSP7
X-Gm-Message-State: AOJu0Yx46jGXUY0w91Bx974Gughjz93z2513pIB+7Fw9IUNfeVJbPkhe
	Hc483ExtAdzavGvpS0o8Es2ivTsSM/ZIdcWZX8pPKF68UUwK3aLONxMTvRVMpquvRQqI4+FB8dt
	o+LA2/SxK/Eh+JRoVmg==
X-Google-Smtp-Source: AGHT+IHxJ11Jc4Pg7WkmO3SlYHVbY6IW+Wqfxro8+OBFjX0tT/erDtqX8VfrApEznbWBw0W1kCfLjttZO6MW2F1P
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:2604:b0:dfa:8ed1:8f1b with
 SMTP id 3f1490d57ef6-e041b039d25mr256249276.1.1720654975664; Wed, 10 Jul 2024
 16:42:55 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:22 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-19-jthoughton@google.com>
Subject: [RFC PATCH 18/18] KVM: selftests: Remove restriction in vm_set_memory_attributes
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Allow the test to run with a new attribute (USERFAULT). The flows could
very well need changing, but we can at least demonstrate functionality
without further changes.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 63c2aaae51f3..12876268780c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -384,13 +384,6 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 		.flags = 0,
 	};
 
-	/*
-	 * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows
-	 * need significant enhancements to support multiple attributes.
-	 */
-	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,
-		    "Update me to support multiple attributes!");
-
 	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
 }
 
-- 
2.45.2.993.g49e7a77208-goog


