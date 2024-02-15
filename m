Return-Path: <kvm+bounces-8843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5474185720B
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:55:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03DC02867C9
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E6AC145FE7;
	Thu, 15 Feb 2024 23:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2crmDHJK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBFF145B29
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041264; cv=none; b=nnF7odJgGPOdQKYRv7ywysZVbEFcW5U/ytQ3GXrtLhmIjAJNbwJa+47YQgHsFqAX7503jzHsrfxJjBHHzhwXrc2iQaskERod3E3pkMHQmFf2R7erLN94Bbb8b95eVHYyKJTa7M7T4A2meQ/Mh4djwCjV3JxLP94+cLfXggh/rtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041264; c=relaxed/simple;
	bh=LU+P22WMx8+l0j28eDp7TZSAb4K8ddezaIfE2HB5OjY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AnaCtT2hIeG+M7gkeKkQK8fmefysRR+EJcif3pbzCszhvC+RfCCC4qItU+og4wEE3/szqkPb8WgXrfnpyaG+hBO8f6nQHrRETMMxmDznRFXuhLZ2jhCexUnKR758Z1uG+YQL4eD5C83Eu5Q2sB5lA7+VJ8t/8eg79coVc+EDuUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2crmDHJK; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60790eb0f8fso23539767b3.1
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041262; x=1708646062; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wxgMpdjPiqAl5L5CrBln707OMjyjZ2YsrvRZmT9MQFg=;
        b=2crmDHJKWsgNhKgKFHi2ltTJ5HFEOP60o1uHn7f/iTC4o8FtUIHsNVM06IY5/4TklZ
         cp+AWw5+AcVokEHbos5oEGzvt+GBmVhMNSBvynLqxo6yhVPDzUkOhmF3pESphhwvTqUj
         8/05Q9wuBKVTwjoASedOC8t3jLuXD5RTUc4CrRjCLQHyH/pP/aXQZAyWAMGEuah5Uak5
         I4+u3AGUlXy2NPdQnYIqhJTptdOvsJxtEdX5II7vxbJIhS+F3oUjKz9xt//Cw5PQeIDq
         n1e3s/sHpiiY+ixSvJVxFG5wNUbF83nM2Eh0kmL+MozE4aRoZXXKHGsAVWyBWZS4adwT
         2ntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041262; x=1708646062;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wxgMpdjPiqAl5L5CrBln707OMjyjZ2YsrvRZmT9MQFg=;
        b=QfqPtWMOaMHgeSS5eCHULDNjNW6jqsRdWVqVBkwqGSsx0eiKFWVQwBmD5UPoWlO3WY
         qWjO2recUELqFWwI6a2MR/L+by+QarYHCG2Tcv4D2mf+LxrMpcPdSrnG32EsLITcyO0q
         7m4WW20VSqLZCjmUU4U6yyPmize8Fa5LQDbbXQb0wlw+dpBQayC6gM3duxT27wcwPAA9
         NG0pFZa6K8ve+rcRBc9ryVghDdAaCMKX1CPu+oJ0hV7clyR9i28EZvLZ83fkom6ykUjY
         P8TF9FBJ8B1wBXMNEZCtk+fSOG9QBD9lZsrp2fdgJU0NS9yTMzpVMDJrxBL3fEZO5C7K
         jC7A==
X-Forwarded-Encrypted: i=1; AJvYcCXUCuN1+aT30VtxJ4VvxiOHhz0UUEmuPF35jrneXB/1jtiqxsQ0bZ3r6lT4vfzo2Q2GTqEzqEcgG0g+7X2ftkyu6t1+
X-Gm-Message-State: AOJu0YzrqrN7vyOch510P+/0LZ2memFUwYRh1wbRZNC1/IpGKIzYzkEH
	6rZ2BxBuQ4rlsyPaTQZyby6bpMJwFJ9D47duaNxE6U+J90QKLL7S41OZM5MWldDIVrUC2Q9TG2s
	z+Wwt60AaPg==
X-Google-Smtp-Source: AGHT+IGxwZE2D4TMTbojQuxIQsdHxi4CLt7P+BDw6owECL4gA7IpetyfAOdk5HtQUv5KTlzPChmWvxiHs6Ovkg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:4c04:0:b0:607:cd22:1f32 with SMTP id
 z4-20020a814c04000000b00607cd221f32mr774161ywa.0.1708041261933; Thu, 15 Feb
 2024 15:54:21 -0800 (PST)
Date: Thu, 15 Feb 2024 23:54:01 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-11-amoorthy@google.com>
Subject: [PATCH v7 10/14] KVM: selftests: Report per-vcpu demand paging rate
 from demand paging test
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Using the overall demand paging rate to measure performance can be
slightly misleading when vCPU accesses are not overlapped. Adding more
vCPUs will (usually) increase the overall demand paging rate even
if performance remains constant or even degrades on a per-vcpu basis. As
such, it makes sense to report both the total and per-vcpu paging rates.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 09c116a82a84..6dc823fa933a 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -135,6 +135,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec ts_diff;
 	struct kvm_vm *vm;
 	int i;
+	double vcpu_paging_rate;
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type, p->partition_vcpu_memory_access);
@@ -191,11 +192,17 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			uffd_stop_demand_paging(uffd_descs[i]);
 	}
 
-	pr_info("Total guest execution time: %ld.%.9lds\n",
+	pr_info("Total guest execution time:\t%ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
-	pr_info("Overall demand paging rate: %f pgs/sec\n",
-		memstress_args.vcpu_args[0].pages * nr_vcpus /
-		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / NSEC_PER_SEC));
+
+	vcpu_paging_rate =
+		memstress_args.vcpu_args[0].pages
+		/ ((double)ts_diff.tv_sec
+			+ (double)ts_diff.tv_nsec / NSEC_PER_SEC);
+	pr_info("Per-vcpu demand paging rate:\t%f pgs/sec/vcpu\n",
+		vcpu_paging_rate);
+	pr_info("Overall demand paging rate:\t%f pgs/sec\n",
+		vcpu_paging_rate * nr_vcpus);
 
 	memstress_destroy_vm(vm);
 
-- 
2.44.0.rc0.258.g7320e95886-goog


