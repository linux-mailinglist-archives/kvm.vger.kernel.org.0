Return-Path: <kvm+bounces-33812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A832B9F1BD4
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:14:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B3DE188EE3B
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C8A31E517;
	Sat, 14 Dec 2024 01:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BmKUmjeR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC37B1AE863
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138480; cv=none; b=EIf+6pzuOUdxKa+iCMiNjG6/l2onBhXVAYG0EJG/fW2wPqbzgsRToH3oUySys7D+pYODtY5L6nBtywpbvxnTu/rgtdGP8w0kWwHy364X+H51aeGsG7xa/VjzIyRUsiIgCslz0JoRZxBvU67P94gJmaJse78TD1nj/hfI3eXHcNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138480; c=relaxed/simple;
	bh=Ceumk1Ttpyk4h+LMc7F3vGAe0OUH9kkpzA38uyhTPLo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ypwp3XcPIz5jnQyTQnxwNujb/Rn4p6472k55vQNlwqdkOSDqzjewZmsbsedXK8rsKPWgfcp+j3rWTB3dgrnp+9r12b3G++irHtZ84UWUnFzVJfKK26YpJMfoH/uVAQWFNIsgNYJLPu6Au6UUQABBynRNWL96YLWi7scmtpmt1QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BmKUmjeR; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-72467cd273dso2863526b3a.1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138478; x=1734743278; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9M8UqaW8Gm4S/67GPRyVYas3GRYQeNLXsPFj+ckb7wg=;
        b=BmKUmjeRJtm6INrLzmWGeOLn3IWx2Hdnf5+iFOYj9EdPipFPx5MqsT4iBbiBWvW1CR
         gVqoxgAtTBSOMN7J3vPjsGAICDCBDZmFc9Q7jVpVCR3r6M+c63CWnvb6ypGV3LaaBgg6
         0g4xRB6APM9mX2vTddmGCkkFxKfAUozZ1LZC5jvX5WO9mtziBHHGY37pOW589yrSTInu
         ZEtUH7AJ+uUBypLcDNLlF4A2ceXN3Vd8eMCVB92bJxmUiWcracKY9LTCoPY+dQTwXqKg
         KEscnAYmXnNvpw5WErgGqZDNen9223B8f83hdh3tlPDFIvGawiFl+FFa9T6FHRlvjFCY
         A4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138478; x=1734743278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9M8UqaW8Gm4S/67GPRyVYas3GRYQeNLXsPFj+ckb7wg=;
        b=F5r5Rwktk/cuZp9ervS2x6G7Pcpee3t34tBFjduGgepjSlJiX76+4Ng1D3D2et/8DS
         yjMmM+czt9mOn+L152qSejrQBEeNDMPzJYwQtMCcVJzJezEvcjpV6/75k30bb52WZs4x
         k/SamKTff8+5v13OL9rHZltNmE6k3c7FH0+CktLfYC4D2Kjk0u8nhrowWr5powYcOISi
         5mQEGsYFOS5COuApmEWMBVkd7sewGmsNUZ5sJrMmoIO0+jtMeSEYg/IGailbaElB4x8J
         S7HZoqc4sNUlXjZICkJt08AabDhAV3LmSHdXO5R590JB8OZPq+FFTBrzmAFhVUwlpZyW
         vTSg==
X-Gm-Message-State: AOJu0YzJ8Ftyj8B1lYOJ3qg6jsA8VzZrCzU4AqYgnAUWiHfZzlKlm3iU
	4hkM92aYH9JDJs9IC4BABFnDF9GMDNptUOmCqIwgyWpz1Y0IqhR8B1ZRY5w1oL4+O4ZZaGiNGCn
	AvA==
X-Google-Smtp-Source: AGHT+IE0D0ZgxVI141VOT2+yGr3JOUwPdzWtmGseuD8KjVBk4OygIKGBmnd0d+BjrhKNBNRpBSMJYgZYLo8=
X-Received: from pgcp7.prod.google.com ([2002:a63:7407:0:b0:801:9858:ef95])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9189:b0:1e1:a434:296f
 with SMTP id adf61e73a8af0-1e1dabe1a2dmr8727195637.10.1734138478053; Fri, 13
 Dec 2024 17:07:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:21 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-21-seanjc@google.com>
Subject: [PATCH 20/20] KVM: selftests: Allow running a single iteration of dirty_log_test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that dirty_log_test doesn't require running multiple iterations to
verify dirty pages, and actually runs the requested number of iterations,
drop the requirement that the test run at least "3" (which was really "2"
at the time the test was written) iterations.

Opportunistically use atoi_positive() to do the heavy lifting.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index ccc5d9800bbf..05b06476bea4 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -880,7 +880,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	TEST_ASSERT(p.iterations > 2, "Iterations must be greater than two");
+	TEST_ASSERT(p.iterations > 0, "Iterations must be greater than two");
 	TEST_ASSERT(p.interval > 0, "Interval must be greater than zero");
 
 	pr_info("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
-- 
2.47.1.613.gc27f4b7a9f-goog


