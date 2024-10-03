Return-Path: <kvm+bounces-27885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9878998FAEE
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 01:46:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59D23284639
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 23:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371E41D2B2C;
	Thu,  3 Oct 2024 23:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gnj2GkHD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9C91D2B04
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 23:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727999039; cv=none; b=pOJFpwbv7YQDAWFMG24j8u3IYttoKsPZrBbGP46nThavpldVKSv1SbU66qniBbjzKioUadnlO+MJf4pad6mt42FG6n+TOUezbcZf0IPrr/tMduWYH0tHuTqY4JxMVwOBmAh1ikucADhTyJon8iapl7nX4moNsnucOKndENuoKLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727999039; c=relaxed/simple;
	bh=xqBlrWuS6MCxk0gww17oourN4jowUONsWvqCnk9wPn4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T/ydsmNs8wz0B+e7HKa1Raal4Iu5i1P6ZLvbEw/qFVmGdedz3xcT1wuqwYZfLfy2tvRXir6QcZu2JoT4ULYavV51jP4NRD5m3wqb+5PZ19fA5dW+qH1Og2Or9I7V610ozRXzBFElW79x3xWumTyhahgdznvd8xCNKAEI5U2EDQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gnj2GkHD; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7e6cc094c2fso2792232a12.1
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 16:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727999037; x=1728603837; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lHVxAupwVdLj9JS6H09y9gDY/v8cy7swDNQclaU5Fj0=;
        b=gnj2GkHD8H7lDTYPvn9kCqFhDvtxpsIaGjxuYiU9RxwrELTxOjmbGcSLg0lI3OLt5L
         Ul9h+sC8EK9sVF4hA0f1BiHB1Mmy8h7+CeEzHKOkyl1I9Eb7e9E+shTIQoLXZeNSt6l1
         fdOmPQ3mcZfdo5HGiIwbGIeetjrOJnwy9hh1fLlS05YBeGE2dwJFdm3AWQTsmARXlnBq
         Bogd0xGiLGRoFKJIlj7qpHfTOEhD4Eo6YZF3Q3hw5+Ao9tpEmmJpld8iF9KazCwSFiTe
         itkM3KiaX+xjwSzNYci0LcGcIuOK87kgNcraXB4kt60/O9bmXVJfPL0spN8Ei5l7i8Ns
         abNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727999037; x=1728603837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lHVxAupwVdLj9JS6H09y9gDY/v8cy7swDNQclaU5Fj0=;
        b=ZZMiMKRlLFxCxed5/lxy6WTU02Nm3irlUXrUo3AlLqBaCmSrE7ecJWHnmzNebtNkST
         e4jVaLS46Gn7AG+3D3ihsba74QO6Dl9qbsudk8Q/XuNFfoMLdCMu0IlmEC8qmkWY8Uub
         pwnhrMiElyZq1vHsgVbWNlkvFC52Yb0/NQN/iwQ8n0vDeu5Gs79OqmKxyZEyREKayKOf
         9HS9n68E4QCBziEukglbIxos/Vj7ttbhleQiDBIICsIXoV/QloJ9q6j/2ZPVPOWLmZ9k
         syFbVOTaZACPwZnnLhi5oh4Kbiw76qjtX8LJroBtUoHOMu5ly9P7M4eCzcN0tQm2yApc
         mKHQ==
X-Gm-Message-State: AOJu0Yx5huOuOIu/cbhWoCrB7pz8v1krMpDj3/sfGfN3C7CgZTISp3s4
	bUkZT4CJglE1ERuXWEM0AaJnhSrqREFmns8ZWrf7DMUIgn1v+Ds/UnhiXe/iI5xbVnf68YRxecs
	W4Q==
X-Google-Smtp-Source: AGHT+IGKroOpNriNfmU45AkA6nSG4g4BolcTa1/5RFMDjU2V8x+RltKhqqMU4YNPO1VDq4XZodpXpHwhZw0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:17ca:b0:2e0:8e0f:7bfd with SMTP id
 98e67ed59e1d1-2e1b393e2eemr25111a91.2.1727999037305; Thu, 03 Oct 2024
 16:43:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  3 Oct 2024 16:43:35 -0700
In-Reply-To: <20241003234337.273364-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003234337.273364-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241003234337.273364-10-seanjc@google.com>
Subject: [PATCH 09/11] KVM: selftests: Drop manual XCR0 configuration from
 state test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Now that CR4.OSXSAVE and XCR0 are setup by default, drop the manual
enabling from the state test, which is fully redundant with the default
behavior.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/state_test.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 1c756db329e5..141b7fc0c965 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -145,11 +145,6 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
 
 		memset(buffer, 0xcc, sizeof(buffer));
 
-		set_cr4(get_cr4() | X86_CR4_OSXSAVE);
-		GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
-
-		xsetbv(0, xgetbv(0) | supported_xcr0);
-
 		/*
 		 * Modify state for all supported xfeatures to take them out of
 		 * their "init" state, i.e. to make them show up in XSTATE_BV.
-- 
2.47.0.rc0.187.ge670bccf7e-goog


