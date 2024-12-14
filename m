Return-Path: <kvm+bounces-33800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDCEB9F1BBC
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:10:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46BEE7A041C
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E658318C002;
	Sat, 14 Dec 2024 01:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4qfWwg0N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB9E17C7B1
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138460; cv=none; b=bYQ1oSt+5EyXz/cAkqytFtqGlvcKQ71OJ45hwboqZ3TXB3y5imJmT+sTwFCtY9gJ55pZjP9w8PBwX/eFjUgfENnRMdlwvMHBBZ/8bd8cfrtyVsYsoGs2NGOuy1KEjwPvnfZmHne2pEiyfNQxAPceSLUlBzrnB7W+vhvsNO6Caa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138460; c=relaxed/simple;
	bh=Inh2cv3fTNpaNX1dqJtMDaDtbEiwB1dIP0CX7Q96HQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y177CO5c9JPyBwClor7tM2HV/kfkd/1UrVN5N4hbVxRuTolwt7UnLq7kllNQJUOuBRn7w0qlKS6c4B+tpDCmYE9oDpq+JkF+viuczrcEn2AgIKP7wCUvDWNzEqNRhQNB43U7vJ0g35UkBXmqGWo/K+NTg2Mm0PDnbdwhnzcZ3lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4qfWwg0N; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-725e3c6ad0dso3128921b3a.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138458; x=1734743258; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=m1k/pYfn2qosYE12LM1QCowrsBblB7GzrYsx0S4ECrU=;
        b=4qfWwg0NyRqdpgh/GGpMRn06nadjeILEuy8PEbsD6X8uP9YMVDxz8mDryUeCIfl7oV
         FFB317e7iY9T1a+TgoZc0E08jZQHj5xfFWDtN0qtwAFAksdU/cFCH66vYR+xL820QO7E
         H+7fn4fHJLFpJNs40x7azr90Gy6K5Y4a8OEl2eti9sdrdnR5MkKTze+6EQQaxZHiEwDf
         j4BqD5r+tdpcsvYOHMtzdCSf+QEsOhfexBou8H65fkLkAm2B+wcQsj+OeUhksoCdsRfy
         Q/rpqiDnekNYDM2RB/vv5OGVOZBLLng900FsWvNvl357WwUyfAM9AlBd+EDtGVyButas
         2iWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138458; x=1734743258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m1k/pYfn2qosYE12LM1QCowrsBblB7GzrYsx0S4ECrU=;
        b=JbE7FDAdw8l55RYexZiqqxOYAAeF/rlxUjQrN4Iv4tx9+bFNJU0SKl2uFyNNAJmvCA
         q12K450w7GCPcd9gtKvjrwjAUBIowZAgiI5ToKw1orgkBhi72DEiHqLGCipcvPDPItFj
         q1cfqKjxJa5dAsirzrmB6iVgMqF7bXJgJESUYICQlJAJnhCEvt8gBwjyVg1w77qmcJRF
         P3UrAVbJY0H8xpSke8kyHM9lN5JiEqdOm99JKYwX9EWtCultHX3bNnp2CKCthMJGf4X4
         cS7oUCydmmdtwVOfJEQ6y6yPIxKBaLC2MrzdSfwo4JBzAzFXF+yrf9SBbW1xPtDNGa8i
         fcmw==
X-Gm-Message-State: AOJu0Yxj8VUhaD0OCMxfjl5PjbdPbHHU76BLxjiRZLdGD8sLZkFbRN0J
	MPc+0wyWBo0DfeDE8fRJM1arVzvGdqOWyHAHrP20h4cpRjP122DVGyI/wKbyret/h7uZ7P7CDT6
	aaQ==
X-Google-Smtp-Source: AGHT+IEwXyFPF5Hijf5EmkYKER23oPL4AIpsifDIk3rn9u8VryCKpp9q2+rsJUb/wfR1Com5bqjGGaRhg1Y=
X-Received: from pfbbs2.prod.google.com ([2002:a05:6a00:4442:b0:725:e2fd:dcf9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:cd5:b0:725:9dc7:4f8b
 with SMTP id d2e1a72fcca58-7290c1902fbmr5987759b3a.15.1734138458154; Fri, 13
 Dec 2024 17:07:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:09 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-9-seanjc@google.com>
Subject: [PATCH 08/20] KVM: selftests: Limit dirty_log_test's s390x workaround
 to s390x
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


