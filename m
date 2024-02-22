Return-Path: <kvm+bounces-9401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9EFF85FDB8
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:11:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24018B2A52D
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E219415351B;
	Thu, 22 Feb 2024 16:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iIl0y3FK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B615C152DF4
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618267; cv=none; b=H2QAw/R8zCOMbn+MdpmVz+LceXfvR1BZ86LCnu+5t5sJZ4Gn2RUxp88NUQ37z/r8X2MkqvuP+/WdoWnwcR1AMYJyHZY5m0fvh59czzHF61YmhyAUoB3bVyeoHrgNmYCU49RMK3u2Q3yXRYA2+GXkBzNDbtttjrkT2kAB3MMmI/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618267; c=relaxed/simple;
	bh=34CFzZBAcfeTUUnSxZLLwRxztPMpGbF0RaaQznrO7WE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mThOhuCyargHXlrgKNT4E60MUZzkOIHmw3kDr6yY4XFUBi/Bn5AqdQgKTDEq7S9UldKSeWu6hL6YId7LyQy5YOsC9kGbSfFpBon/n7y3TjHJfdmGXd5/hbgM7PQk8AtVoR6ldgsoy1uAc+0AIFRUdDuGCNkrY3C9C6k1khE82Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iIl0y3FK; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-40e53200380so9902245e9.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618263; x=1709223063; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ps0B2uWSs1/RQhbKakYOYB3FB0WNj1ejEuJDeJil1+8=;
        b=iIl0y3FKiwiLinLVYb/yCh/PxbQM824NYC9VJUkjpra7dUHVPvjlkB1JkvIjOBLpny
         mCgcdfiVSRwi0Om80HiB9A58Uvt9Q0ZdHPGsrnXbNu0VfjBU2y7wEOZ0/6mwzTVQL9ON
         rmiYE0BJnrXTsUBycB+1BcsxmdQem2MEaH1UGpIBEGLsdGy/Ike8qnGUbulpHanMfEPa
         b/cO5N41HpeWDTd8DQF8AtnVvOoh+NRWOkBVEnENPJRZZOh2fyGEZR3x4uMWy49be9h7
         PYyuQRS8lMlk+yPZQlvG7Vrhht39zrPDqlJxWI464+0fapGFx/okEDoVqHtpbHxkjREi
         F4mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618263; x=1709223063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ps0B2uWSs1/RQhbKakYOYB3FB0WNj1ejEuJDeJil1+8=;
        b=AkOXpOYPI3jNHeN/nIfVW2jrK7bkcNT98FZlQiea3tHCSj2y3hhNBKsqb68qyjx22d
         ZkT4dUMurL78s8P0PYY17l3L0UlCDCfWZKHQ4Jtl/V2jyMNtnc/nXVOG1ETTxkrcWXAH
         RxQaaY4qd4DOhZe1G/DTinLtZI47MHawuJcTDruCBRCIqi086GCh4GJK2trSo+lr9xYZ
         1c/fF26KGjk8DAwPxIX71L17CFT7ifDzVtMXw74cvLUytKC/puql7WviWpqJts3aqXVt
         d2PpjJNbotq24pUm+ltkxtY4TeyHOWczIpe4asAKvF5x9SI/VrNYdJZfX8P/9A9L9Xik
         CUYA==
X-Gm-Message-State: AOJu0YwaKtf9RQ+IIFLjB8aLgmizfrK29MrM+OlQlQ+adm6BvEc2gkMW
	9pjRXbJpsFqHcZqR+fs/aTo1muPUK7Y2l9KXkcdIyJp5Wdv6uPU67DFdLwP+DYmmkuZ7OHIggm9
	Wcb3kh83ACBzpyLyxXN35nx46yMIXVwJJsWySwjJxL7vs6dRckoQk3CDpxAUoiuAntppQ1bReFd
	Re7N6sba6Gk3n91+gVUKw4Jw0=
X-Google-Smtp-Source: AGHT+IHx3V/mRqxPnXGsf4wttfDhhzBtQLJct5h8U32Pa1DCbngXj0qYKMXJICyFPSYG82DXJTE7ZZxBNg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:5187:b0:412:8887:2946 with SMTP id
 fa7-20020a05600c518700b0041288872946mr4674wmb.3.1708618262659; Thu, 22 Feb
 2024 08:11:02 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:26 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-6-tabba@google.com>
Subject: [RFC PATCH v1 05/26] KVM: Don't allow private attribute to be removed
 for unmappable memory
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Unmappable memory cannot be shared with the host. Ensure that the
private attribute cannot be removed from unmappable memory.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 virt/kvm/kvm_main.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9f6ff314bda3..adfee6592f6c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,6 +52,7 @@
 #include <linux/lockdep.h>
 #include <linux/kthread.h>
 #include <linux/suspend.h>
+#include <linux/rcupdate_wait.h>
 
 #include <asm/processor.h>
 #include <asm/ioctl.h>
@@ -2464,6 +2465,40 @@ bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	return has_attrs;
 }
 
+/*
+ * Returns true if _any_ gfn in the range [@start, @end) has _any_ attribute
+ * matching @attr.
+ */
+static bool kvm_any_range_has_memory_attribute(struct kvm *kvm, gfn_t start,
+					       gfn_t end, unsigned long attr)
+{
+	XA_STATE(xas, &kvm->mem_attr_array, start);
+	bool has_attr = false;
+	void *entry;
+
+	rcu_read_lock();
+	xas_for_each(&xas, entry, end - 1) {
+		if (xas_retry(&xas, entry))
+			continue;
+
+		if (!xa_is_value(entry))
+			continue;
+
+		if ((xa_to_value(entry) & attr) == attr) {
+			has_attr = true;
+			break;
+		}
+
+		if (need_resched()) {
+			xas_pause(&xas);
+			cond_resched_rcu();
+		}
+	}
+	rcu_read_unlock();
+
+	return has_attr;
+}
+
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
 	if (!kvm || kvm_arch_has_private_mem(kvm))
@@ -2614,6 +2649,14 @@ static int __kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 			r = -EPERM;
 			goto out_unlock;
 		}
+
+		/* Unmappable memory cannot be shared. */
+		if (!(attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE) &&
+		     kvm_any_range_has_memory_attribute(kvm, start, end,
+				KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE)) {
+			r = -EPERM;
+			goto out_unlock;
+		}
 	}
 
 	/*
-- 
2.44.0.rc1.240.g4c46232300-goog


