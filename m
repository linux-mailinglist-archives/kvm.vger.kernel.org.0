Return-Path: <kvm+bounces-37025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6404DA24643
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0985B1885F3B
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D4B1369AE;
	Sat,  1 Feb 2025 01:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JxXM7Nvc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3F47081F
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738373918; cv=none; b=gWSixbQfa3K5m6wdcaJFK6mAawbVaAgvoH6PIdUiEGgTsiXB3IoFps9sYtwFj1agW+fGarJmVVEEFPZdQOYnKmL6Idx7/1bq5kIYE7e/Y45fj58sCmMaQ7mXeqXcFRiYYQe8JYwX9N9UkGCi25EN+jT/kXIIHYb/J7YuN1KaDhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738373918; c=relaxed/simple;
	bh=BjTGMZAujz8V7PRymU0MtCLYLhiR76QtteHhEUWAMN8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r8b8LCAOF2o1tKCzoRECk3zBlJIUED4zDZaxP7pidp9P7lLD/gNEfKP2q46/1yC5Af3N65uEwFGM+5T8Sy9iK2hv3NShyvLZ98DTN7qJ7EieLzC0jugY7ycPWYNdg+WoTV6n7FWUNKvjxwj9OT95JxcVrIpmA7jUt6oGX5yMjTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JxXM7Nvc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef909597d9so7215260a91.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738373916; x=1738978716; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8ZYyjd0W1TCp6raZa192Hjs1JgLUz/3Q7DTTNkVwjg=;
        b=JxXM7Nvcsj0TbIJgo08OkvhM5lc4edmBDdUGSsglfLVtL+mtzpDuJJjjNd2m5MpI4j
         AkzPqIkssvzesk1TgDd5ErtAfqtZu/9G+t7vPMtC6NYGIeU7qyxqF2RLJ0cI+pfynu/Y
         1sS8ffwF/gw/zWTWuHOQrIDncnA0DgAHD+P+uekE3gkl5Szx05rCx/KRhQezMRFwUdlz
         cmZnnAqKFjhBN5IQYczb9SvP7FFA8vPpGVm2+QQA5uANm/JnGObxsqJBdhSROdx3T1Pf
         o5rqh6rX5LhDU+y3liZVhNrFX53up5ub0k+K9VFdwjOfaByGXTcEzma5BYCZI34BXDWB
         Eafg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738373916; x=1738978716;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y8ZYyjd0W1TCp6raZa192Hjs1JgLUz/3Q7DTTNkVwjg=;
        b=H7+uCjMnNAGi6FYxqBdhRfRIXk1AZ9mzQViFROnwC8zD1zhyvgb2SBGbm7IT7CE/sQ
         WMoE528VhgpTZ5ZB+cERXTHtncQYav1wiO0fp0iJrNfemkitZElYUzMVJ4qvqdYS7XLq
         K/qiZ5SDiNg7Cdl5l0hd6F+00nwwQPERL/NMDr5k6oEQqqlG5a+/+ecbe0vR/RHUeVYO
         M4kdRrephNn/8NzgktkHRA4o42ndws/CiSQHjBT4h35pdxD/jqGrLyYmnto37zP9ZKRK
         lc9FhafXkDF4umBtXW4SN+kXidFr5tHeTjqPu6RhvsLk09+5YYocK/5+cY2ruMcc7zic
         xPvA==
X-Gm-Message-State: AOJu0Yx9+Qf3Y/6nZ2rTeguA7Ywf+U4aCg1aumk34SE4EWoP+rQ4h4FH
	4VGdRR4sp7pej324l9DBVY/IDJHhphACE1HqRk5WTFDq2Nt3c5EMF/xs9MQys8qiRpsBvLXFawc
	qQQ==
X-Google-Smtp-Source: AGHT+IEUww6H9B/218pN1bGykGPB3qoRx0Sbh+RYhN1f/Suxq4iXH/h2uszLxk4L9NNFXl1LU+sQF2Wfaho=
X-Received: from pjbsw13.prod.google.com ([2002:a17:90b:2c8d:b0:2ef:78ff:bc3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2250:b0:2ee:5bc9:75c3
 with SMTP id 98e67ed59e1d1-2f83abaf3e7mr18367670a91.5.1738373915941; Fri, 31
 Jan 2025 17:38:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:38:19 -0800
In-Reply-To: <20250201013827.680235-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201013827.680235-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201013827.680235-4-seanjc@google.com>
Subject: [PATCH v2 03/11] KVM: x86: Drop local pvclock_flags variable in kvm_guest_time_update()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Drop the local pvclock_flags in kvm_guest_time_update(), the local variable
is immediately shoved into the per-vCPU "cache", i.e. the local variable
serves no purpose.

No functional change intended.

Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ef21158ec6b2..d8ee37dd2b57 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3178,7 +3178,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	struct kvm_arch *ka = &v->kvm->arch;
 	s64 kernel_ns;
 	u64 tsc_timestamp, host_tsc;
-	u8 pvclock_flags;
 	bool use_master_clock;
 #ifdef CONFIG_KVM_XEN
 	/*
@@ -3261,11 +3260,9 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	vcpu->last_guest_tsc = tsc_timestamp;
 
 	/* If the host uses TSC clocksource, then it is stable */
-	pvclock_flags = 0;
+	vcpu->hv_clock.flags = 0;
 	if (use_master_clock)
-		pvclock_flags |= PVCLOCK_TSC_STABLE_BIT;
-
-	vcpu->hv_clock.flags = pvclock_flags;
+		vcpu->hv_clock.flags |= PVCLOCK_TSC_STABLE_BIT;
 
 	if (vcpu->pv_time.active)
 		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
-- 
2.48.1.362.g079036d154-goog


