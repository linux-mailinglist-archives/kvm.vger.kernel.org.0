Return-Path: <kvm+bounces-9434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E522586023D
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 20:07:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 152E71C26D86
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 19:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55DBF6E60C;
	Thu, 22 Feb 2024 19:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZLljWQbj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60116548E1
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 19:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708628799; cv=none; b=cKrrsWmXna7XGizBtuXQjLK1JxuY97EhUxxat6b1H3r8UMLQ58hXtcEpTug1HDF65HN67ZOjEq5yMRfV9TR7Tjr9RbW/6Fs6+9w64PKtzqS8Vd6lI5nCAcZjyT9qSJ/oWUTGz96qeWJB7otB36xO0MMejajJkb2I54dAZnMVaHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708628799; c=relaxed/simple;
	bh=cIWRw/ciFRHors/2oYNTTCOVc0HlamGjl6dwJRVdN1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VnB3h6GmEzwaVsBCRyJLW4yK7Rxw/0LugL//YyC4Mo7l0BOOYnGWpbb0fqVdeX0egkqnPgDpLNrKi/gQHlLgoA5VtslC13NRNW9Lv2a5zDtuvudEUp9l5n/WpyDM/B8V6hoJ1EXldhmyNQ+CF1HqwONoE1ZIoz1hXQsA++NKE8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZLljWQbj; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-608749ea095so2109047b3.0
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 11:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708628784; x=1709233584; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=riJ7HRTQ7IsaxxoiPw34+GvPTL1t25LYSZ+Y64H+IpU=;
        b=ZLljWQbjVNJupQi4T7YcKqIFlPrh0x02R8ZFdng1L4U7qgPX5tTi/GPKxJ9C0LoR2f
         83g0utNm9hSd1Wup7EYKEOEpGJaF3BeVw2h7Hy5988W6GPYsEBG6UVvBhNMQaUsZO/BP
         luOqsxWQh3v0SAmJRuGPOK2SWqb7Z2LKXu/6/W+ncXDQpZUg7TofywmfOym86q4Yghox
         HT3lvegL5RwwidfHxf0vDstfrVg5WQosaDsG3k+wiuRip5bHaDEL9qLl+dLpvr2mPWHT
         7LwN1s24y+0eezpMWFFzjmNiJF+UtIHR68fDYFPHvZ0axoWkBScqnMbToTeSAwW8FqOv
         pCCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708628784; x=1709233584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=riJ7HRTQ7IsaxxoiPw34+GvPTL1t25LYSZ+Y64H+IpU=;
        b=eY3ynNB+1nzP+KsQiFxRfj7Pdz4uJiHR7sHMQgrfgoTb74dhwMJm8j/NppnEOtzdg6
         hRA+q13UcYGDtThYtA/KL6J8Qy6EXjKgUDF3oGewr1sYX24/07lOu7odhX0YOhsISI7P
         M+kNIK+AXcXX23Kqxhw+3TOwgS7UlG++OG3aByhQyGU99uTeScwzS6TDgN9EYETvuj2i
         lAZj51UbDUOiC9277m7+nVEZrXMdFIND14c3uzM/pYlzQ3z9FX5BjJPlzQ0DvOSOmRM8
         xdF8gFfzHy48/S/2eWbEnjLHrmrFajamcIv7ve+QcqM4m3Q5yS3rcQdshS93r/YMQQP+
         hvOw==
X-Gm-Message-State: AOJu0YxRLMfnzMTg3//J+ROF2ed1cqrwlaf2DVELqSpkqwRHbwomU2PG
	5ds+fGdugFtf4AVJ9Z9lbkP+JejwyhiB3jUg8drT2F6uH9kJmy8d2iUFVOaFIJDmipK47pviI6J
	3QQ==
X-Google-Smtp-Source: AGHT+IHK+000I6aYNhYwLooXEmohmYz3fy083+ikkdIHowbT0ZCvhybvYWO5SGzJhGJoTQp8dbEOocVxQ4A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2846:b0:607:f42f:70e1 with SMTP id
 ed6-20020a05690c284600b00607f42f70e1mr737848ywb.4.1708628784418; Thu, 22 Feb
 2024 11:06:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 11:06:12 -0800
In-Reply-To: <20240222190612.2942589-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222190612.2942589-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240222190612.2942589-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: selftests: Add a testcase to verify GUEST_MEMFD and
 READONLY are exclusive
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Fuad Tabba <tabba@google.com>, Michael Roth <michael.roth@amd.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Extend set_memory_region_test's invalid flags subtest to verify that
GUEST_MEMFD is incompatible with READONLY.  GUEST_MEMFD doesn't currently
support writes from userspace and KVM doesn't support emulated MMIO on
private accesses, and so KVM is supposed to reject the GUEST_MEMFD+READONLY
in order to avoid configuration that KVM can't support.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 9df4b61116bc..06b43ed23580 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -375,6 +375,12 @@ static void test_invalid_memory_region_flags(void)
 		TEST_ASSERT(r && errno == EINVAL,
 			    "KVM_SET_USER_MEMORY_REGION2 should have failed, dirty logging private memory is unsupported");
 
+		r = __vm_set_user_memory_region2(vm, 0,
+						 KVM_MEM_READONLY | KVM_MEM_GUEST_MEMFD,
+						 0, MEM_REGION_SIZE, NULL, guest_memfd, 0);
+		TEST_ASSERT(r && errno == EINVAL,
+			    "KVM_SET_USER_MEMORY_REGION2 should have failed, read-only GUEST_MEMFD memslots are unsupported");
+
 		close(guest_memfd);
 	}
 }
-- 
2.44.0.rc0.258.g7320e95886-goog


