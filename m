Return-Path: <kvm+bounces-9435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A63A860240
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 20:07:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDE401F2AC6B
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 19:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88997174B;
	Thu, 22 Feb 2024 19:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qOFvn+gC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89F514B810
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 19:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708628802; cv=none; b=jVGAXfERLM/sjeTV7MAgg2TCxQwnrGqPArCuy7T+meOEbEHbBlRicaa2lRsyMeL7o1EW8j3re+6zw0UaGGOCihGIS3TjXS4AFz8yyMghVbSLM8fvj4+2SBwv4JTytdqpwP+HriRVNEPL+06965WY+88SYbPT85VHiOmu+juM5jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708628802; c=relaxed/simple;
	bh=tb6swG7G3wi3Bnp9LY5vlQD3q2JN5LX1r2DEbuv3v04=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sRY9ovq9nPv9js6TIH08RNkM1UZsW69Enlj7BpVNuSI2qwz/foZHQazJa8E0FanZaJjMnao7iCQ/WW+rEoaZV9n4StQdbyXbMCxaZc6yip0+ZhLqyZo9LBHgMnK5zKIjliinCdBwqo6oOUD/isfGiuJvuE3E/Xnh+EjCH1sFKhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qOFvn+gC; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf216080f5so37340276.1
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 11:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708628782; x=1709233582; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7HiIqZU0XyHT/uY+W4Av8xeySFLdYEVlTDQAMpZzHAk=;
        b=qOFvn+gCgVs5c7zcvBO86Q/trRj74+2+BepDqXj2zgB4OvFOSk5EMDS0OlFNOynVLY
         cP9BSYBsueqjh8X+q7hUf+AT5WLlU9KtKRCB+wd/4m3L6XYsTs8n8vCjLesZnuyef2BW
         VivgP4UtOk/Pz0BoEiFn8xecbpI7sydOb1FqsULlgEI36kuln9wD7dGqqmS09QVXteEh
         X/QXo8iGK3rzO3tqGEfQsYWRyYAb7IeMYn5TDagw+R6YgjgmQeMgY3iT6RrnY3CUospJ
         TCnGngq44ALF8XzTewAFhRJey8F6g4ABqeYkqb3sQAUuOFBS/1mZwBlZ/zGCEeXR/tox
         rOYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708628782; x=1709233582;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7HiIqZU0XyHT/uY+W4Av8xeySFLdYEVlTDQAMpZzHAk=;
        b=YwWviQs1zVjA9fcV31Cwh7kLQrDC3OjefDlWo5sxFHAM7mQ8schBTEXJKsDm/0jCRA
         PnKVgG0gzGFX6S2PYlbY2ab4ooXBVBVYqA3JO5EOsdPG7BAT40ZtApofzMph7XjVd608
         MVqK06C1fCu0DTFxuIolkCFn+q2xseIUOp2xtbpsxmo9R7z1rZKGfqZIwTTSh5NYDXN1
         3KAbpeNl5x8PW88dULBK+Ro42iyghMNQmdHuib4yHek+Uyp4Hrx4o6nBSmfQs+1vU+2S
         HUrUsgzYb2/djgK2sqX4e+wiMTM5HhwYCJvWqY3jqShKrXAiMMwHT6hBwCxrxWW2PoxO
         ItJA==
X-Gm-Message-State: AOJu0Yydaao4HtScRR4ZpbTw32StxooNT2qsjsMbrMGeKCHTt3boLqkz
	g/hvHYnQbZfMvIyX4BDI5oWiNORJANG39kCmDG2xrNodI5Kj4ErOKuM2iSdWGtxz21YtYEcVo4/
	09A==
X-Google-Smtp-Source: AGHT+IGtR+RoDfHwSTIhzXm2i1nKg0wVcYuExVcXUmqMqdjbWwp02581SwhVU/j3/8LtxuOjiirmIuc48vY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:114a:b0:dc8:5e26:f4d7 with SMTP id
 p10-20020a056902114a00b00dc85e26f4d7mr5931ybu.13.1708628782543; Thu, 22 Feb
 2024 11:06:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 11:06:11 -0800
In-Reply-To: <20240222190612.2942589-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222190612.2942589-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240222190612.2942589-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: selftests: Create GUEST_MEMFD for relevant invalid
 flags testcases
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Fuad Tabba <tabba@google.com>, Michael Roth <michael.roth@amd.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Actually create a GUEST_MEMFD instance and pass it to KVM when doing
negative tests for KVM_SET_USER_MEMORY_REGION2 + KVM_MEM_GUEST_MEMFD.
Without a valid GUEST_MEMFD file descriptor, KVM_SET_USER_MEMORY_REGION2
will always fail with -EINVAL, resulting in false passes for any and all
tests of illegal combinations of KVM_MEM_GUEST_MEMFD and other flags.

Fixes: 5d74316466f4 ("KVM: selftests: Add a memory region subtest to validate invalid flags")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 40337f566eeb..9df4b61116bc 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -367,11 +367,15 @@ static void test_invalid_memory_region_flags(void)
 	}
 
 	if (supported_flags & KVM_MEM_GUEST_MEMFD) {
+		int guest_memfd = vm_create_guest_memfd(vm, MEM_REGION_SIZE, 0);
+
 		r = __vm_set_user_memory_region2(vm, 0,
 						 KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_GUEST_MEMFD,
-						 0, MEM_REGION_SIZE, NULL, 0, 0);
+						 0, MEM_REGION_SIZE, NULL, guest_memfd, 0);
 		TEST_ASSERT(r && errno == EINVAL,
 			    "KVM_SET_USER_MEMORY_REGION2 should have failed, dirty logging private memory is unsupported");
+
+		close(guest_memfd);
 	}
 }
 
-- 
2.44.0.rc0.258.g7320e95886-goog


