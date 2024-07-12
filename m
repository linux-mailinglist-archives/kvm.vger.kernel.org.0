Return-Path: <kvm+bounces-21560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D364492FF0A
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 118F21C22A4C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7BAE17DA16;
	Fri, 12 Jul 2024 17:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IO7lm+24"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3595B17DA07
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803720; cv=none; b=twSMn5ZSaZ26u++TNQTJi4EoiAkXxadYAJDf8zYsxC8pKEdBELZu+yRIOiQk1I0aOXu64Z69X8O9DBIWVI3gKKw8s4wdLqLcQ9s0+O+42SyuZ1PAov7pKiAMubalCYH2t1nctmJ44ET5EQFU1IqWDtcoY0hh1Wy4sBGUXyvaplY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803720; c=relaxed/simple;
	bh=K0gFt2zCMOORS0kcEjcT2GtcZt7SX3SQZ5OWDNzK2u8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nqMa2eEHfmJc2sghuOjjD2pQR3VT17wWyeDyCHPOGFFRBHxznL6/ZTK1DeISJiu46TqppcUd4Dw3YwqpcRlq7j3gCQd/XA92N4nwXhuHGPL79Q7a6x/Kn9+iRuUeDnNCpLSYE0qTp5OcKgeAmEn0r2VAwejhxOc4KDiAXxr1tHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IO7lm+24; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-367960f4673so1771699f8f.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803718; x=1721408518; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LtvK59wkpmv96YBPTwdu+UmQnFP5VkAZYiTxY4Mh4uQ=;
        b=IO7lm+24kv5ciuOZ7gHxWNridD11c/tzN06UzKBd9ATr7bK5zPmKZfCQhMyzGUZsVq
         iBaE03MU3Fh6QBzBc1Rlf3bH4WqdIWRi/tN6oB9mIYNwKQrdBFbBfGiS6Rpwx1NvW2mG
         gDVKYRHLFUrJSXXzagckK3VeBAO2Q2edzh2F4qQBGbEPwneKjlVOgxmpvrBRcOvxr97U
         lwu23Cbb6M/m8TQXaRKkew1idX5VdUW7fp7S6aysFp3kCPPLCenULgnZ84z40KyYv02Z
         /yBMGzdNYhIh+plgzmpn+ejjGmCndQ3NpATBfthZMP2mrbMV8VtKGIoTDnqbON5mDie+
         EPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803718; x=1721408518;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LtvK59wkpmv96YBPTwdu+UmQnFP5VkAZYiTxY4Mh4uQ=;
        b=DNHY9H4KL4V47arxT13hK9WQokyV9nt40uW2+4lvwu1s2/udFht3HkuJL+2q9tkg0F
         Ax3gaPDgeeShe68JSCavU86rAJZm7+liJdTY5FcmpFMadSBK0jBtKoQHlQOEMxmPVezq
         vttV8DPJXoCQTuGekRH2zV7ceOj1rvLQvksgcJhauNZ9SmD8Q2mlf6B8TfwIt5dvQgJx
         uRGVzwAJBQVSq23pG4EwZq3PVa1FLg+DIOzPjmJW1/5ZsQp1NiAW9cO1nmx9veW1nA1v
         jr6trjiiNaJijtWf2lM20aPWgClz0tPn0QtGtnEpSkI0fs492T4tHLmQiacBT1VhbP6x
         KWqg==
X-Forwarded-Encrypted: i=1; AJvYcCXue+GyP2eEXL0fX3+B/Wk6hTab39D4tE9UU9GRE2yn8LrX3TqRmCeX0oTuGfzrjBqpjfW7nSJd2+txkLy6Sz1FblMX
X-Gm-Message-State: AOJu0YxvGiAQHF9VId3+eIilINuai6LPFXZ1Q1l1WdGF3lqsNRVmZk8t
	C9n7DP98C/MzfDEFNIgZuPd6Pfw+epxZ+0S1wlbkxJljo7CDWlIJlAzckJCOkgmcCYjNc2siZu6
	3gcoIt8iSkw==
X-Google-Smtp-Source: AGHT+IFpeHjscoHoV+i7b46AZT6D1f9aKe2Nj5oFbdtPCtyqFA2ot3+sTCgSvjfbQ/uIAyhmtnXZfQlaZ6B1Pg==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:6000:2ae:b0:366:df3f:6f98 with SMTP
 id ffacd0b85a97d-367ff696f10mr6916f8f.1.1720803717468; Fri, 12 Jul 2024
 10:01:57 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:40 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-22-144b319a40d8@google.com>
Subject: [PATCH 22/26] KVM: x86: asi: Stabilize CR3 when potentially accessing
 with ASI
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon <liran.alon@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Junaid Shahid <junaids@google.com>, Ofir Weisse <oweisse@google.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, 
	KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

nested_vmx_check_vmentry_hw() does a VM Enter as a "dry run" to check
the VMCS. It's important that we VM Exit back into the correct CR3 in
order to avoid going out of sync with ASI state. Under ASI, CR3 is
unstable even when interrupts are disabled, except
a) during the ASI critical section and
b) when the address space is unrestricted. We can take advantage of case
b) here to make sure the VM Enter is safe.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d05ddf751491..ffca468f8197 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3147,6 +3147,14 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 	 */
 	vmcs_writel(GUEST_RFLAGS, 0);
 
+	/*
+	 * Stabilize CR3 to ensure the VM Exit returns to the correct address
+	 * space. This is costly; at the expense of complexity it could be
+	 * optimized away by instead doing an asi_enter() to create an ASI
+	 * critical section, in the case that we are currently restricted.
+	 */
+	asi_exit();
+
 	cr3 = __get_current_cr3_fast();
 	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
 		vmcs_writel(HOST_CR3, cr3);

-- 
2.45.2.993.g49e7a77208-goog


