Return-Path: <kvm+bounces-17657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC5748C8B52
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:41:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96224282DF1
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7881D140389;
	Fri, 17 May 2024 17:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dvtq8ZQ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5790A13FD81
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967595; cv=none; b=Xgokv5Iuq4YiYbd/3lTJGyQ6Q8gSASteNQQ4gp/EZzhPdoUq2d8+EMnzTtlTyeVptGZLE5hUu+oNxiiXkTGmZNaKo/6wmVYaGaNrjg/gjRGPvOgG6WGm8sqA/33vwvT8QKK2sBU1XEsxBg3C653xVW9/D2E61BGet83g0aGRpLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967595; c=relaxed/simple;
	bh=aCfUY2cwJ9FyZLh6u5tXvW0EbzE1JhXczYPB0CjQxa8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uJRH5Di5ANBuf4TgLKoOB3RXzOx3FgDkYNRYkSUNOmoXQ6zQfNvUJv8D651A8bQMW4zMJfV2S4PfcaZdLvUMtxg9XfsRJfL5HLbBqkXmgIYpbAEHhQcCv6zKXLHBiPAYZPW8qsvf1Vr9lYgHLmpu/mMUE9Yj53QIhBUO8EK/RaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dvtq8ZQ3; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cfc2041cdfso7978695a12.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967594; x=1716572394; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ls63tfw1LENdu/wncAT6gu4iTMBSH9cLRZDJ5lKbc4Y=;
        b=Dvtq8ZQ3kpHuzPty4e3qs4X8FTSrKc88HfCHjFTdKTVEzaQ4bjpinrsxAwDBNRYMdm
         qaJ14V0f1GP0eUhBbWZFd8VZnkGXCvRgbUhUkBdy49MJtJUVgc2wOhHSBXBgciEkHTKm
         Lo/rSVDzqQ7sFbhO2shn00BQmfAfRcL1+VLVgNAR+Tjdy0/p+sJfz5B/WC0xLXNpJMfe
         NA3ednm0kEPTVoiI++wWfiPbemV8yRvGZRJhqWp6seVXtWGCzqlo3TwTCMoeZfpVpRv+
         n6wx+SvVHLkLDy1sYqFvVR3wOy97ZZXDm9PSmRusgJ6CKgGXzxxooW8jT6IFyMX3xGTo
         eLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967594; x=1716572394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ls63tfw1LENdu/wncAT6gu4iTMBSH9cLRZDJ5lKbc4Y=;
        b=CAMR+WfxGWWUP8gDipZoXi1IvjFnnZqswHPbFMzQVO0wL+mb6jnA4666KsWwcX8uzP
         Z0advLJfy5NF6DDpLCCX3p+XCTLtef9IGkD9uYltfcisZ+8E+tj2bH8h59dKA1w4dMbs
         HcYmR/AnU30wCZMu+Nj4ghZk7gHtoELPTgdN3Zr48TualFBSaXvaOwqwblEZD8gWrikT
         9zcV9i9QrgC4KidYwDGprthtPy3agGvy2zcOvccUQUDCf266VVoBioHxNKaX20EtqD+E
         HWWLpkR+wVUbHTOTjxvV6BjUk4ZMw61WQb7lwQoKr14Z9SVU5a4CaAfWFkrKhMe0s7rK
         MRfw==
X-Gm-Message-State: AOJu0Yy5j8DLZa96nZw3fTPacZmD5OHb+bNXmnf++9h1d5o2zHyXftbP
	VePSaIrga41sKIsK+ON2JruNxlV3HOpweKVbKRA8IaR5DQ0MHxF2ZJu25MZGKMmSUkpBFHZke6C
	nTQ==
X-Google-Smtp-Source: AGHT+IGq7mDGV56F7XS81sz2VaOQIp7ARp6TameJrjIbuQMUVk9HZtTB8wUrzqkO40bbaK0aXO9qyCphroM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:b609:0:b0:619:f921:b6e0 with SMTP id
 41be03b00d2f7-6373d2172afmr53642a12.5.1715967593731; Fri, 17 May 2024
 10:39:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:42 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-6-seanjc@google.com>
Subject: [PATCH v2 05/49] KVM: selftests: Assert that the @cpuid passed to
 get_cpuid_entry() is non-NULL
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Add a sanity check in get_cpuid_entry() to provide a friendlier error than
a segfault when a test developer tries to use a vCPU CPUID helper on a
barebones vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index c664e446136b..f0f3434d767e 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1141,6 +1141,8 @@ const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
 {
 	int i;
 
+	TEST_ASSERT(cpuid, "Must do vcpu_init_cpuid() first (or equivalent)");
+
 	for (i = 0; i < cpuid->nent; i++) {
 		if (cpuid->entries[i].function == function &&
 		    cpuid->entries[i].index == index)
-- 
2.45.0.215.g3402c0e53f-goog


