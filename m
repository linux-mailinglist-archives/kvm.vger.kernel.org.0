Return-Path: <kvm+bounces-48438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D49B1ACE467
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 20:36:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A6BD1896803
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 734B720459A;
	Wed,  4 Jun 2025 18:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="usNegfJz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A11C202961
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 18:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749062190; cv=none; b=sPs9Ab7Vm2f8/4iOZEDOljvY95H577Y/2Ld0D3qtZJSytbw3vi6PK3ezDOnMYJERw4Ab2twfrn9j6gWTN69aekxDeuyZHMFu4yl1Gd7+eo979XBvOAlc/kFvcPbTp6wKEShgdvz3yS16JlB6sfnkGwPHyAZ8k6LTeF/LQ0S3H84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749062190; c=relaxed/simple;
	bh=TyqQYBNnuuEH5ROuLOOzjdKoJcI91zCNgTTdsTCaHlE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DZdKiKiQ40MPCiDuF9zjzjlNLxdFMv9+qfj7yevguKrv+9/UcjJQaM3SWyQk8vrXUdp7EQQCUGUccVxmHRxmfO/QNNYm8VXZm8WHhHMufr7vjC+3+izMOjPUE1HTvj7f191T/YOU6WCO20GnYoCXsNne5XSueB2Dv64wElMfhmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=usNegfJz; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-740270e168aso142912b3a.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 11:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749062188; x=1749666988; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HpheW9+KAUFOS+tSmsqSJMYl2FYTGbJX+/h5ze9LZmw=;
        b=usNegfJzbkFo0vO6MWHetk0pKRCQR40jBy1S+KDkXsIBahUAjmMzDF1JfR6bnE9mo9
         yXhTntSRGlfMh3vxSHaaIxvFNZcVwNGD8feDcn0ZoZNiTm78gSBPvxdZLiaHhR9rVd3+
         Y9VyNV9CYitIL+Rl0azNkhRAPC3Xh7bTN4567pzLgydOMZcuSGfO5CCbCp5KkpxwurpQ
         OD2zrwMviot4j7ttnKGk9i5/YzT19V++4+enAT6M2qJuSlBeNc8PD7TbcdqlLix/FBPf
         2L6gXxbWNZ42terApMZ5ScwZ/vc+SsdP36K6KeVo+hHsI5/K/tmj7oWOa61qUGbMIJgQ
         VVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749062188; x=1749666988;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HpheW9+KAUFOS+tSmsqSJMYl2FYTGbJX+/h5ze9LZmw=;
        b=KqwXiej9OhHHe17ZYzN5G8nYHPHgHwy469Iu0jIK+AIo9hm24aNkDkiTARCjuJQijM
         BSULZuIIvBadt/7DbOQIncnw/XEuzxvhkgz7uIa43xJXN77way19FQvROLwsfGkJljrK
         jixcCbqaGDwLhmQM08I4a1EmbMJTtomvIxyH5grwO+aFCmEoZeIXQv6wKZvVbaqWjNdf
         SFt9EV1Es0srVwrsd43hIAGq7fRbfzas3jihCybHyCL8d+J55vOx0p7NaTteZ2W6CkLV
         39/fLMg08ANwE7YDllCSeX7Q02cpYpZKqDIxZqt0CqTdIeCOVTLv39Tx0Cg2nS7bjCkL
         Iwbg==
X-Gm-Message-State: AOJu0YwzjVTQSOqd2sRYP+f2sA75adjBk3JPbbazTLP90IX6G+dbaHAg
	aV7k1JYu0mTLn5EXnb0Zd2SAkxwNFv7U4b774r4ywi4z6Nf1V1AtkzS9KdyLaHfN2eOz5SswJ60
	77s6Znw==
X-Google-Smtp-Source: AGHT+IHZL1uSi0UuPSSMR3ENWAt80uP+UQVjOARpM4c7p6YP30rCuMAm21DYvzJu3uUm5RCQg81rJUHNPn0=
X-Received: from pfug9.prod.google.com ([2002:a05:6a00:789:b0:746:2414:11ef])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1a89:b0:742:4770:bfbb
 with SMTP id d2e1a72fcca58-7480b4b35a2mr6044579b3a.18.1749062188404; Wed, 04
 Jun 2025 11:36:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  4 Jun 2025 11:36:19 -0700
In-Reply-To: <20250604183623.283300-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250604183623.283300-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250604183623.283300-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/6] x86: Drop protection against setup_idt()
 being called multiple times
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Now that setup_idt() is called exactly one for 32-bit, 64-bit, and EFI,
drop the "do once" protection.

Long, long ago, setup_idt() was called by individual tests, and so the
"do once" protection made a lot more sense.  Now that (most) core setup
has been moved to the BSP's boot path, playing nice with calling
setup_idt() multiple times doesn't make any sense.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index acfada26..bf6c62bc 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -301,12 +301,7 @@ static void *idt_handlers[32] = {
 void setup_idt(void)
 {
 	int i;
-	static bool idt_initialized = false;
 
-	if (idt_initialized)
-		return;
-
-	idt_initialized = true;
 	for (i = 0; i < 32; i++) {
 		if (!idt_handlers[i])
 			continue;
-- 
2.49.0.1266.g31b7d2e469-goog


