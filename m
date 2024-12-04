Return-Path: <kvm+bounces-33074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AE819E4459
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 20:16:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE9A228804C
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE961F03CD;
	Wed,  4 Dec 2024 19:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Va4w2hA+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A65C202C4A
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 19:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339666; cv=none; b=kCkic69HFBSr9HgT5aQ3+w2padqZddooLDepw/pE+YCyc8EzBYIW+Th8gnVuNPqeR8ejd3sJqmlwxMnqcZH63xXa4eVO9hHLk4CDIHqui1uwml1HiiPfq9+tcfXDyg63yzI6V13qlKCtWoh2Zopj8PB9Mq8IpUhhMb+2o9fTvfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339666; c=relaxed/simple;
	bh=g0rkDGLpu4v+ug31ibm4fJibfbopHH42jmhVi9EOmqs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YgGlcwRjSG6zm5PjrYXmygKfOnIfOTbXoxNYf72q7AKZuUxklt9tCazusuAKemKyA/t8znB7QvMHFQhUJiaTP/9LsRFhIm34wjLU3MBcgFnJA44o4gLx+/Vco5UV18bwKzqo0NFh3LxPuEyURusSqlYzPD9icqxnRe/QYUasvS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Va4w2hA+; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-5f2033c97cfso118425eaf.3
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 11:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339663; x=1733944463; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zFzCtU30qR2oi/Is6fdl592GY3fZRLXfeluJtZi8G84=;
        b=Va4w2hA+uWJh+kB1R8xnR1i0iaMi6BjrdFaDRcbvZyPJGCmNwdYyf7bTwTHdYq0cFi
         j35iNpYKEftFzvCpL8twNGARFLc8Sm/SZ5SiFJoH6207g4BvSdcGqhpxvk6J/qWfTScn
         B5TSb/vi3sPD7axxPeHmH2DCtDXQ33kr0XyJOWnnYn0oN2WNt9PlxBDmH0ofuEVWEL5o
         a2Ji22A9CzQjX3ajlFgf37s0zqJCQo6nQdapFEFMYwdtJNUzkNH3waahXw5H6OPOK//q
         Z80MAY/imeKmrkb7frsWZtW1b4cXuC1/J6AAyOtkaHjBS1nfdVeIW1IWQKcfLrxvIPnp
         AviQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339663; x=1733944463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zFzCtU30qR2oi/Is6fdl592GY3fZRLXfeluJtZi8G84=;
        b=EUJqv1GgpPSbKYrMMfGdz1yBdY2uifFH52G53ZJuz7NGV454MOlBXayUx66sLXGeS/
         28O66Z+SDQ8aAFxmkZRIpZ8bZILywZ94hEIY+wuyslvrbjqUUp/964GmgSAyz5gJlMnT
         qvwv/qQ06VaD9Us369QwMjGKKMpt2h+ZaDlXBHBfaKcZBfSum3jTwzpNEs1X7UXtyEo9
         5jsgEQ20E/b/C/VAbSHnOvmmk7h8y5lciTDVBkJ97w3wEKEAc1UwAAY6IqNxshlHBpiB
         oHi78I3hnO37zgdfHAOPsFYp3Marhjq94ctEpk6w8tOSlbORg6mEhYSvqSrc1qo9eHDp
         wenQ==
X-Forwarded-Encrypted: i=1; AJvYcCURS+wKRa6DhoFz9fVA7jI81wcRzk3Ki40Q8IZYdSnilOKzj0ueOujHM2TYlRGFpeYpMqM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0H3gp9/vbFccbRUvWnLbHTdrEAFse8l6U/Bz40XIfSnJULnCh
	Na51l8cpGROGB+RtWOym0FJHxM1HPHnuQm4LvZjjtkOuBAfuVtImE0YnBt6HG36n53idIVR55fX
	7jmILkCskl+Cl51yRZA==
X-Google-Smtp-Source: AGHT+IE0Bvu2wb5sZ62wPHnkPebE9DLvFVJFuHpqNaMFqI9+9IIU97LvrniH728q/X5uxBPvfLsjs32/EpieLb++
X-Received: from uad11.prod.google.com ([2002:a05:6130:800b:b0:855:e8c8:6d6c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6218:2812:b0:1bc:45bc:81f0 with SMTP id e5c5f4694b2df-1caeaab608amr694161055d.11.1733339663073;
 Wed, 04 Dec 2024 11:14:23 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:43 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-9-jthoughton@google.com>
Subject: [PATCH v1 08/13] KVM: selftests: Fix prefault_mem logic
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

The previous logic didn't handle the case where memory was partitioned
AND we were using a single userfaultfd. It would only prefault the first
vCPU's memory and not the rest.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 0202b78f8680..315f5c9037b4 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -172,11 +172,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	memset(guest_data_prototype, 0xAB, demand_paging_size);
 
 	if (p->uffd_mode == UFFDIO_REGISTER_MODE_MINOR) {
-		num_uffds = p->single_uffd ? 1 : nr_vcpus;
-		for (i = 0; i < num_uffds; i++) {
+		for (i = 0; i < nr_vcpus; i++) {
 			vcpu_args = &memstress_args.vcpu_args[i];
 			prefault_mem(addr_gpa2alias(vm, vcpu_args->gpa),
 				     vcpu_args->pages * memstress_args.guest_page_size);
+			if (!p->partition_vcpu_memory_access)
+				/* We prefaulted everything */
+				break;
 		}
 	}
 
-- 
2.47.0.338.g60cca15819-goog


