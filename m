Return-Path: <kvm+bounces-33077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14FDF9E4466
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 20:17:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3F51289058
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC7F206F3D;
	Wed,  4 Dec 2024 19:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ijNsiXfs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f73.google.com (mail-vs1-f73.google.com [209.85.217.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FCF2066FA
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 19:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339669; cv=none; b=HK5dkWdXuH2ia4l+t4TISBcdK5pjALt9rj6/rw88V2urIieIUj3jlu6IbkVv6EMOBcuoETF0MZ/T9T0bnTPTCAxxEh3gicMj9jrCmlXTroS4bYV5UFs/zk52K1G8WYASXukOC3M3uVwZLTE5G9l4BA7SfLM7nFZPwzRFJnW2e1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339669; c=relaxed/simple;
	bh=DB3D34LMo76wSyQOQTjLpchEbwFt3tbBmtNUE1453so=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cI9ZUD2ZHusiuEVrPzOMhmnXPUSZi1aLgSXrGrC0DxaIMYVjIx0oY5VzqCbdkcUpR4KhneuDwbbhRGA+MWbGZZEhDynlTbvKE4utFCF23dioU66psUQcOLUFGPrZmMszsEjnkiTLBSAPMVS4OJIBYSy3LiXFj2aP7EDb5apsxOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ijNsiXfs; arc=none smtp.client-ip=209.85.217.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f73.google.com with SMTP id ada2fe7eead31-4afa1cfe29dso13294137.0
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 11:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339666; x=1733944466; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s5zlVcABwgcAqDrk/hYCqATZ71WnZcE4eWZqt1Al9mM=;
        b=ijNsiXfsLfCRNzBTKUenbeOgOV2tUuKXfdYd1oOBhqHioD0Qnawgu04ON6s4hsMikI
         T1sRcnx8zWtIS/tWSRdENTKv6znXli6x5xjq0w9r6EfUdkXppkPTcWv+2+MDAjOddhv2
         +kNCLzT0JVklDYJ8WDM8Me75cm0q3FNxkntVQ2HHuMkIjjZmUCpWxuyS3XCyq2xCRoef
         i15paCYU1Rc3AeZiOGDHDel0+3WhfxFT55NFpymO6wEtDYKN/pjfppVvw7Jme8PgWz6X
         BOEv+KWCre4XIIBInE2e/KWSADD4pnOsnv+1/qFP7tPenYZjLcPoPzM5yHVYx2tjTih/
         SiUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339666; x=1733944466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s5zlVcABwgcAqDrk/hYCqATZ71WnZcE4eWZqt1Al9mM=;
        b=atu82NSZqxSmQTK1IygoJEmfzrntJ0/XNQf2xzW3WpHwkpGgyiOZxvRj/E3kM/HdWu
         Ex91VUjUUO+SWDghe5HseDf7fZLG4KZPHWIHwHh0mKAATqRWm+uUNON5PsdniXakTYZE
         jpD/ebO42icFz5kcV5XWb8uY9qFMPOHTteTYYgEXoP5xw7YNOrFcSrPUEXQXvo0lzpog
         nB04x7il4oDLeWXr8VQeUYlqIGQPzFQTAmunslwLN9FPpAg4IO7FmXxtJeZT/qOezkRY
         cgy/Un96eLRef3uDeREu/Anf2bE40EDORZbG028x0A1Y/Uz6rjiLV/O45rEUDNz86qud
         r9LQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfavj9ThTPC09NVpQ0uGV4ChV/HLn94a4uj1HLaN+I6XTPYLgMzIUwhYLmLvfDcHnfO9o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOZxV6W8dLUAR79aVdToTNFsZwU9hioDU8E/wri5NPdEMvoRVT
	4sbVTunsnQTRu+oJGhUA/SccIHRXXUMBohmV9RQXPX4WI965Lj97D2dCPCHDl/1IQ6WABBxHo3y
	4C8RxdcFa31+GiaJn1A==
X-Google-Smtp-Source: AGHT+IF2FEM1OG8guhI8P1BVhXWIFhfslfAcmBKz5oOAxjNRJSTj9A5XfYD8J6BgPkOCk8O5eB0FX2IaOdHwSH+I
X-Received: from vsvj20.prod.google.com ([2002:a05:6102:3e14:b0:4af:5a9b:90bd])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:3ed0:b0:4a3:ab95:9637 with SMTP id ada2fe7eead31-4af97243dc7mr11657456137.12.1733339666111;
 Wed, 04 Dec 2024 11:14:26 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:46 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-12-jthoughton@google.com>
Subject: [PATCH v1 11/13] KVM: selftests: Inform set_memory_region_test of KVM_MEM_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

The KVM_MEM_USERFAULT flag is supported iff KVM_CAP_USERFAULT is
available.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index a8267628e9ed..d233cdfb0241 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -364,6 +364,9 @@ static void test_invalid_memory_region_flags(void)
 	if (kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES) & KVM_MEMORY_ATTRIBUTE_PRIVATE)
 		supported_flags |= KVM_MEM_GUEST_MEMFD;
 
+	if (kvm_check_cap(KVM_CAP_USERFAULT))
+		supported_flags |= KVM_MEM_USERFAULT;
+
 	for (i = 0; i < 32; i++) {
 		if ((supported_flags & BIT(i)) && !(v2_only_flags & BIT(i)))
 			continue;
-- 
2.47.0.338.g60cca15819-goog


