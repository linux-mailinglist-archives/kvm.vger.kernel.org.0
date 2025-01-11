Return-Path: <kvm+bounces-35155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B3BEA09F66
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:32:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AD4C164FEE
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B53183CA6;
	Sat, 11 Jan 2025 00:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1e8Odm9u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4CA15B102
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555424; cv=none; b=klPfbX30oPKsHfi5pbLbcqA+2vdFqhN1gAGgaDKiggxaiXRJHJvTrwV9UiJVF65MNicOp/gUq7y2j4TQZpgzBguo65Pw1dLxiEqftapjnyTZNJ9WhqHgTMdIsbAmokPAtaWHDCTcWRLKgIw7l2jM3Aod77RXQHAK9V//ifzHCZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555424; c=relaxed/simple;
	bh=Inh2cv3fTNpaNX1dqJtMDaDtbEiwB1dIP0CX7Q96HQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=luodEEG4TNVCBjyx7HUviR4FlssJcXNwb+7gMJj1iD2pY7nBx+DN5LDFMR9le6PMrH7S85znouJLGcCRl07VaghFVnke9ZLAX6BAHJ8T38Y+zGlEbf/vnp6ipF4OEljLIhYw39zSvYbfF3Gq6Y9bj2VkdIP5JzmZ6V7JHS7Ro5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1e8Odm9u; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9e38b0cfso4628516a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555422; x=1737160222; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=m1k/pYfn2qosYE12LM1QCowrsBblB7GzrYsx0S4ECrU=;
        b=1e8Odm9uetRkAYbkeTWrXO6P3FPGtAUW8/5mie0MDxz7syerKqvcc8XA5ZlqFoPXAw
         xYDlB5E95U3gGZLJ31moU+6D939g0bf5Q3dnJQfoKf2tqeV8XJfGr6mZAYcymI/qPSic
         Sz7oDFgAVGC5yn9rSX+BGBs3nqEKpLkQ2DsCzItRhVYVfx/Mg/13TgccBG/13sPE3pb1
         NCxv52r7LzuM35to+NtSByICQao3rUD95mm7e8WpufRy0wR7V4mmZfPik3IVZTECSXaH
         oknHQ12X0fuSGsZcS2nI9PQ/zv65Wb8gzcr6zr8BBL4pAClPlPQJ37w67vdR23xgA0mu
         7/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555422; x=1737160222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m1k/pYfn2qosYE12LM1QCowrsBblB7GzrYsx0S4ECrU=;
        b=roYYSuPuVhR6L8XxMkxL2Ot5H1aRorV8o0NIYViJEM0xB/BAyf/zpQSVJ9rnwDzh5w
         rNxOOxmUmXJoFs4FoZRKhI2XkzBcIt42YHG6DCG5KgBHYBDYKqnVTL7zNuWGW/pDvyMR
         zVbbaVvbD+X1WbReeDTLdSKvygasGw0BAN2v/wHArBrWGO6XFMw3tl05ZxXEVY++l2f2
         rvMZFUXmDk8JAe8kj7GQxruJDphZW5NnPUP+9ljEx3Gjds0Ddu5t2P6R+jJYCbqtj1+r
         O7flbHkpbeUUWt3ArD9VJk8XEQo9mrlUBxa/fLJaFe24L2RPlsVn+emOSEofjJdHjMrg
         jATA==
X-Gm-Message-State: AOJu0YzyxvAoYq/zC9UWP5g0uCYt6yQcUBW5ElH6Qt59mVBgXawfC8LG
	ojQmznykNTHHDXQR+rgbYCfTTt7nyfT8iM/Kowrn0xVwbAFr4AOo/TCgqvttNP4VPDUsruXpfqI
	Zzg==
X-Google-Smtp-Source: AGHT+IF17Z0yrpB50va3qb6t7bXW3sn+V7nb0UF93emvB4u3L4QeaKeeehS2VrfQSdjxuguRho8Bqf6SeSw=
X-Received: from pjx13.prod.google.com ([2002:a17:90b:568d:b0:2ee:4a90:3d06])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc8:b0:2ee:d024:e4f7
 with SMTP id 98e67ed59e1d1-2f548db6c4dmr21639527a91.0.1736555422269; Fri, 10
 Jan 2025 16:30:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:52 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-9-seanjc@google.com>
Subject: [PATCH v2 08/20] KVM: selftests: Limit dirty_log_test's s390x
 workaround to s390x
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

s390 specific workaround causes the dirty-log mode of the test to dirty
all guest memory on the first iteration, which is very slow when the test
is run in a nested VM.

Limit this workaround to s390x.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 2aee047b8b1c..55a385499434 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -98,6 +98,7 @@ static void guest_code(void)
 	uint64_t addr;
 	int i;
 
+#ifdef __s390x__
 	/*
 	 * On s390x, all pages of a 1M segment are initially marked as dirty
 	 * when a page of the segment is written to for the very first time.
@@ -108,6 +109,7 @@ static void guest_code(void)
 		addr = guest_test_virt_mem + i * guest_page_size;
 		vcpu_arch_put_guest(*(uint64_t *)addr, READ_ONCE(iteration));
 	}
+#endif
 
 	while (true) {
 		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
-- 
2.47.1.613.gc27f4b7a9f-goog


