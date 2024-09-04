Return-Path: <kvm+bounces-25881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4006896BC5C
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 14:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F22D4282CAF
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 12:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF0B41D86F0;
	Wed,  4 Sep 2024 12:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TQIYEK3G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E4A170A0E
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 12:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725453110; cv=none; b=dg6Nq5jHk/op/VPSoAHn8vxxJxE0xy6ZhX4g647MjVDsB4XwIDXxaz3cyUuwpPYut9jaiSEfWZsBa6xI8xhCCCur8IHtqT65ZEOXbh3EuXyFcaKavuBqXrhnUY9DwCNgGM+GS8BbNGg7cBZUNV6sD66+HPM/8aeiGLEUsnm53bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725453110; c=relaxed/simple;
	bh=9HClfNILOmz4Q1vvE4t6Kw/WdUd0Y4wmLxU7RzDRjLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8bxM25KNoVPXJ6QpLZaZYDTlwEGP/CUd1U6MSuM0fP6ww5cVFjhgwGYoojcgWqizNbGqBcsme9uhtJ1fE+nWCFeJ7zQk4CQjY704owR6lIKtnzfWi9HKDljzxuNNO2490obbVjcnplDQHOhghDR6lYfq+tjEhPFT9yEZOubyKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TQIYEK3G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725453108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yKSONi3vI+EyxTRnoLWJtndqI+DlOE7zGSX1EXcbBoQ=;
	b=TQIYEK3GbNBJOyGpYOP1t3tD/Jv/1jlcHF1NCCuWLQzZ9WjRGy01z/5v0JriSX2wKKSnKE
	WMbtwA90ByANVl52qIlTF0YRui4Xzuzdtjfg1RPl9ejskWjbtbkPs/A0wXbQMSTxsjUOnf
	y54M+xhiLLEAeOuH5aKEAtVbTBF2UTE=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-bQV-7F9vN2mFFXAYvXARIA-1; Wed, 04 Sep 2024 08:31:47 -0400
X-MC-Unique: bQV-7F9vN2mFFXAYvXARIA-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2f4f3e7b75bso53653391fa.3
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 05:31:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725453105; x=1726057905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yKSONi3vI+EyxTRnoLWJtndqI+DlOE7zGSX1EXcbBoQ=;
        b=Agmx20IGcxkVGX34JOFTiHrLGDTDC7z8CrR7F3a6VXqJ+OPsO18mWZv0wdcVeBIGEA
         X3lOYgBWDdN9+zwSsAESXzK4iYqJ70WdSaD3KQQ92QKpB55E7OtKzMsWHzRYqZK00PDS
         i8euGkQDHsd7rr5+w39GsXAN0UztoP+Lyp0EFdZiDvQkbst92GyBSjrUMBrXU7lTjej8
         0AJO35bFRnaweCvjbnJVmK+ttymzIrfWUCiDB23ENBDDtWktgCyzX8r4R6bzii4ZCPa0
         ROdb201OC6HakG7PVs0BxOUlpVMCtmeBN4AimHk5zpqqgfWi0I5BIezZCK+MyKAWp87Z
         FvHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDz3jELzaNnpgzy76E4BphRUhsFD0pjaf8VJlILxQqaaAWNAlRvjKjVpLKktVInqyQ6ME=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/eRX/Uq9sikPL5tTkPNwBTdmId4yk0QL1t13PZoOGOeJa8PG9
	MQxFDbso+YH6TdZva/nhkCNMAmnCYY7m/STbYcruWIJ5WgL6LTOKd+C/JvTWG3moyGOOrwrnlyj
	EcSG0lYVUUjnqf7OlSKnXqinQvBpXLVppUFSgyRg7cyzDa4ujxg==
X-Received: by 2002:a2e:a781:0:b0:2f6:4714:57dd with SMTP id 38308e7fff4ca-2f64714583amr32257381fa.45.1725453105428;
        Wed, 04 Sep 2024 05:31:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0smD1eUJx37hW7rbvoqK7zffKD3Cj33fZ2j7ocbgD/cSOiD8S8Pv1dJVrdmPm0sK5x1RPqg==
X-Received: by 2002:a2e:a781:0:b0:2f6:4714:57dd with SMTP id 38308e7fff4ca-2f64714583amr32257161fa.45.1725453104861;
        Wed, 04 Sep 2024 05:31:44 -0700 (PDT)
Received: from avogadro.local ([151.95.101.29])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c226ccf2a0sm7497106a12.64.2024.09.04.05.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 05:31:44 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH 0/2] kvm/i386: Some code refactoring and cleanups for kvm_arch_init
Date: Wed,  4 Sep 2024 14:31:06 +0200
Message-ID: <20240904123105.283268-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240903124143.39345-1-anisinha@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Queued patch 1 with just a small change:

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 599faf0ac6e..023af31ba3e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3064,10 +3064,9 @@ static int kvm_vm_set_nr_mmu_pages(KVMState *s)
     return ret;
 }

-static int kvm_vm_set_tss_addr(KVMState *s, uint64_t identity_base)
+static int kvm_vm_set_tss_addr(KVMState *s, uint64_t tss_base)
 {
-    /* Set TSS base one page after EPT identity map. */
-    return kvm_vm_ioctl(s, KVM_SET_TSS_ADDR, identity_base);
+    return kvm_vm_ioctl(s, KVM_SET_TSS_ADDR, tss_base);
 }

 static int kvm_vm_enable_disable_exits(KVMState *s)
@@ -3268,6 +3267,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         return ret;
     }

+    /* Set TSS base one page after EPT identity map. */
     ret = kvm_vm_set_tss_addr(s, identity_base + 0x1000);
     if (ret < 0) {
         return ret;


For patch 2, it's better to remove the variable completely and make
it a constant.  I'll send a patch.

Paolo


