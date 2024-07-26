Return-Path: <kvm+bounces-22383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC13393DB81
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:00:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 293671C23339
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF84175579;
	Fri, 26 Jul 2024 23:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ocv4GqlC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432361741F1
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038000; cv=none; b=Eo7WqqJaZPY+8sV1lrfw1TKktr23X8W7uNeBPpGTeeTVsvWRS4mFjVpl4BR7l8j20abaUIl8p7fa58vjKz4SvDQSZOxOOrSJ9ZvLAtK546qgko7rgeEczSgg8U/P8IigOzoPWcVEai6G72hcVejLkcJ3chCaBH1o0WV0fRe2huA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038000; c=relaxed/simple;
	bh=QpaOetglmizJZZ+b98sQ2qGQfzOr00nbj07HtFuO9j4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g35Ef+iKoZ0MKThiERE2bZBVAeKlcoV+Ji9VmTRcNFNdX0feFzbmxDHHWkBo95t+0aR9irD2VGeeo/gLTIiB5f4YwAEhD+FizA8B9k85VKRjSSi9V54J1Xq1oGVjKsFMWL7d/iU0kjy3BxJBinSMvZZgARLZEryMleTt5060cZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ocv4GqlC; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0353b731b8so462529276.2
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037998; x=1722642798; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=F7WgJlT5NNtid7p2jwFbPV8b+lTnD+3vJbPsQDaWDdo=;
        b=ocv4GqlCyEvL0Bf07jV+GPZ/KIm5GT+lwAp+t86ocwSVViCHPl1xeNpA2gX7tLvhHZ
         aGaF38hqmPtz6/NS5kj1IGLHLDKa776uIoP2prtC9EOuNNzGZEU6qdMGBmPyGLwStWuv
         fTmzb0GVx8w6YAzPH1TG9+cpMjS+dciHsrcoew3FqAMxhRXidcY7i71fN5f+HbAUwf8I
         nZPt/ramfQFuB0dmv8j5Itq2kb1BhkAz/KcxopoXPUE+qhNnuCtqrPR7KgqnqyezbvjF
         y6mTxDd01NkMkbDeOk5F3WiPrXKYphH5iBw9jQsGXGsxL3bYcW+rTIvWt0T7OydIkrR+
         9pBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037998; x=1722642798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F7WgJlT5NNtid7p2jwFbPV8b+lTnD+3vJbPsQDaWDdo=;
        b=VgMaHfkN+NthHZs7pPyjy8mTGUYxm7K4b3D91ZhyrNVoWSdS3gFI5YPQwxZI00ZoYB
         zjLh2uReg6bRlzg3Yh48R+QBE42iIX1nzCBH0DQ4fAynkRumT3mswDx5eIM/vbDkwuk6
         +9oV4TvJ+boULT421Pm8rZvuLfzh6fA5GBXsa4qzsiX/HJQE2XefpDdys8bw7QPHUCOw
         2O1AiGw2z1nG6SlS9e50N0XnNoyyX342XA8kf7AKV5/80cRgd6tsNmVaBDYT7q+onTKV
         5GSjHtjD7t/hIG52YN9Be1IMb4RyrxuD0fGqi37P5OtUHziYCozLYhA6JZO3KQzzRnDr
         hJcg==
X-Gm-Message-State: AOJu0Yzc65YB7QgO/l+Hq2R/WHF4V+84fOlgrMXFfYE7oYvx/85+Kz9m
	MuCbFVhPMOtSALziSKEw1BV6EKYpaR4qdWVBDGipt++nCH5T58kmICgqk5MhC4JImepRz8UbkRk
	/yw==
X-Google-Smtp-Source: AGHT+IHz6CGF/LJ/2Irg7XXoFs/UlO9MjKavvm7YGPRddocT798mRWwGF7hDBEuQel+TJyAfnYN45In/DfE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:120b:b0:e0b:4dd5:397e with SMTP id
 3f1490d57ef6-e0b5455c058mr1734276.7.1722037998118; Fri, 26 Jul 2024 16:53:18
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:29 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-21-seanjc@google.com>
Subject: [PATCH v12 20/84] KVM: Use NULL for struct page pointer to indicate
 mremapped memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Drop yet another unnecessary magic page value from KVM, as there's zero
reason to use a poisoned pointer to indicate "no page".  If KVM uses a
NULL page pointer, the kernel will explode just as quickly as if KVM uses
a poisoned pointer.  Never mind the fact that such usage would be a
blatant and egregious KVM bug.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 4 ----
 virt/kvm/kvm_main.c      | 4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f42e030f69a4..a5dcb72bab00 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -273,16 +273,12 @@ enum {
 	READING_SHADOW_PAGE_TABLES,
 };
 
-#define KVM_UNMAPPED_PAGE	((void *) 0x500 + POISON_POINTER_DELTA)
-
 struct kvm_host_map {
 	/*
 	 * Only valid if the 'pfn' is managed by the host kernel (i.e. There is
 	 * a 'struct page' for it. When using mem= kernel parameter some memory
 	 * can be used as guest memory but they are not managed by host
 	 * kernel).
-	 * If 'pfn' is not managed by the host kernel, this field is
-	 * initialized to KVM_UNMAPPED_PAGE.
 	 */
 	struct page *page;
 	void *hva;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67a50b87bb87..3d717a131906 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3088,7 +3088,7 @@ void kvm_release_pfn(kvm_pfn_t pfn, bool dirty)
 
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 {
-	map->page = KVM_UNMAPPED_PAGE;
+	map->page = NULL;
 	map->hva = NULL;
 	map->gfn = gfn;
 
@@ -3114,7 +3114,7 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 	if (!map->hva)
 		return;
 
-	if (map->page != KVM_UNMAPPED_PAGE)
+	if (map->page)
 		kunmap(map->page);
 #ifdef CONFIG_HAS_IOMEM
 	else
-- 
2.46.0.rc1.232.g9752f9e123-goog


