Return-Path: <kvm+bounces-10840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 643A987116A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 01:09:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 884FC1C22FB1
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 00:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FDD17FD;
	Tue,  5 Mar 2024 00:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vkrjjk7R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD2210E4
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 00:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709597340; cv=none; b=GfFhbHpPgdmRdup6BTRz+pA4WD+DlNr9Awp0GC0FkaWemzTP1I1eHtqEpkwhEzUTQyWYKeL7Vb7RUd9rtJ2P3o0VI+BhyfWeBPu37WoRvJepPZCXxBmpL4/WMSaLV+dPV0VySc1dLlZIR2GTO5RYb9QPBwZsAuSIcPhOb8q95E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709597340; c=relaxed/simple;
	bh=hLlEB6KPvYzFTo5bPOzsZI0L7Glb6pFBf19h9JUQe+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RVSkfrddZkzDA00nvkfKLgRrpIwNVSSYbNx9ur6ms48DAVOJUMGz61HYJTZcYfi3YVw0OsZZ3Us4kMkzsxBKCqvQQbA36oaxmH6QP6EzPuMrzA1bo+nM35ByRkdn0T8NUdtqMwJPT0iBIMfzPDPoq/u0jSGyYhHx+U/PsaX21rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vkrjjk7R; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6092bf785d7so94869337b3.0
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 16:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709597338; x=1710202138; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xSp8Et5GJTzv76rwgKZxeeyM05xpYAC56UXsTz8Ea0k=;
        b=vkrjjk7ROzc4x986/ie4KQffymwgWBN/qQyHwNjgK6ufMW9W4isvxHe2X9j/qP+5Fq
         6nEGFBXtbZDva4MOUi7pHy7+Sz+LPG4uTxqDeBvVWbCHgw2ck1qnL/yFTbFNlUSDkHKH
         OLKwQOPjg5Lr4rIOdxgzAZF79hnOY/t5Fy+2iZKUZOzhuyxW5WXgfLb/xyiTDEu3MiuU
         xA1hFQSqRINQAui3Q8ckhN8qbQIQLkUkSRbVMl5Wi2mEMSM80oXOmOhyXlE5/ZaltIrQ
         6JjUpEOOUQGHRJUuS3KW5L/unTK5UFU502acBnHIyCswFqXK1ZHvt8R4RoFP0HpUym6e
         l6bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709597338; x=1710202138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xSp8Et5GJTzv76rwgKZxeeyM05xpYAC56UXsTz8Ea0k=;
        b=cvQwqnWVTPgOeGdUIn9t9qKH10uynEc5u1PRrf/sKPphPoRkZ0DBs5qFhfqrPcw1Hb
         EORMnl28lXgHiyy0pOHnd12dpxc8HzTwCedhN3vDgwU6jKwZIOp+oza+NH5VwoEGuwQc
         oh3FjnL/UBKrO3CpoyUBUQM3UR1mm5m968Pz2iXxz9QgHP86Kv5wuhJKQaWYLmyL2e8K
         i7cSW4QTRS82K4X/JoBnY6raK1Bx4q5Lykcw6RXeiM5UctpLTuxXfjrBJJ44WBsP9OI3
         Uvy+dqtXbqz8RyKbG4rtK9CV13emnM4b8cGPFWGEcwjbu456aJpvzVWVye5bVVGoXt8T
         TW9g==
X-Gm-Message-State: AOJu0Ywu3B988x6r7T5KyVVME77jg/ln+3/KuKDV5TpRMedZ2CFc7VhA
	mueuuMFsIzUaxCMqJXWP4ZqNC+oL8W9Ol1yW7lJWiSlVp/fRQx1A95KLWEBytK95KrXMbBe5MFe
	GAg==
X-Google-Smtp-Source: AGHT+IEv1IxEQTRzg1UiwW/Hh3EZGyWJGJsS1zSJd2vyAyVElPewAQBpfTKqZug/BO60b/g0xj22AINScPA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3385:b0:609:25d1:ea9a with SMTP id
 fl5-20020a05690c338500b0060925d1ea9amr3257427ywb.9.1709597337948; Mon, 04 Mar
 2024 16:08:57 -0800 (PST)
Date: Mon, 4 Mar 2024 16:08:56 -0800
In-Reply-To: <20240227115648.3104-5-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227115648.3104-1-dwmw2@infradead.org> <20240227115648.3104-5-dwmw2@infradead.org>
Message-ID: <ZeZimEcn7DuOrEcN@google.com>
Subject: Re: [PATCH v2 4/8] KVM: pfncache: simplify locking and make more self-contained
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Michal Luczaj <mhal@rbox.co>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 27, 2024, David Woodhouse wrote:
>  static int __kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long uhva,
>  			      unsigned long len)
>  {
>  	struct kvm *kvm = gpc->kvm;
> +	int ret;
> +
> +	mutex_lock(&gpc->refresh_lock);
>  
>  	if (!gpc->active) {
>  		if (KVM_BUG_ON(gpc->valid, kvm))

Heh, it's _just_ out of sight in this diff, but this has an error path that misses
the unlock.  The full context is:

	if (!gpc->active) {
		if (KVM_BUG_ON(gpc->valid, kvm))
			return -EIO;

At the risk of doing too much when applying, I think this is the perfect patch to
start introducing use of guard(mutex) in common KVM.  As a bonus, it's a noticeably
smaller diff.  Testing this now...

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Link: https://lore.kernel.org/r/20240227115648.3104-5-dwmw2@infradead.org
[sean: use guard(mutex) to fix a missed unlock]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 9ac8c9da4eda..4e07112a24c2 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -256,12 +256,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	if (page_offset + len > PAGE_SIZE)
 		return -EINVAL;
 
-	/*
-	 * If another task is refreshing the cache, wait for it to complete.
-	 * There is no guarantee that concurrent refreshes will see the same
-	 * gpa, memslots generation, etc..., so they must be fully serialized.
-	 */
-	mutex_lock(&gpc->refresh_lock);
+	lockdep_assert_held(&gpc->refresh_lock);
 
 	write_lock_irq(&gpc->lock);
 
@@ -347,8 +342,6 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 out_unlock:
 	write_unlock_irq(&gpc->lock);
 
-	mutex_unlock(&gpc->refresh_lock);
-
 	if (unmap_old)
 		gpc_unmap(old_pfn, old_khva);
 
@@ -357,13 +350,16 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 
 int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len)
 {
+	unsigned long uhva;
+
+	guard(mutex)(&gpc->refresh_lock);
+
 	/*
 	 * If the GPA is valid then ignore the HVA, as a cache can be GPA-based
 	 * or HVA-based, not both.  For GPA-based caches, the HVA will be
 	 * recomputed during refresh if necessary.
 	 */
-	unsigned long uhva = kvm_is_error_gpa(gpc->gpa) ? gpc->uhva :
-							  KVM_HVA_ERR_BAD;
+	uhva = kvm_is_error_gpa(gpc->gpa) ? gpc->uhva : KVM_HVA_ERR_BAD;
 
 	return __kvm_gpc_refresh(gpc, gpc->gpa, uhva, len);
 }
@@ -377,6 +373,7 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm)
 	gpc->pfn = KVM_PFN_ERR_FAULT;
 	gpc->gpa = INVALID_GPA;
 	gpc->uhva = KVM_HVA_ERR_BAD;
+	gpc->active = gpc->valid = false;
 }
 
 static int __kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long uhva,
@@ -384,6 +381,8 @@ static int __kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned
 {
 	struct kvm *kvm = gpc->kvm;
 
+	guard(mutex)(&gpc->refresh_lock);
+
 	if (!gpc->active) {
 		if (KVM_BUG_ON(gpc->valid, kvm))
 			return -EIO;
@@ -420,6 +419,8 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 	kvm_pfn_t old_pfn;
 	void *old_khva;
 
+	guard(mutex)(&gpc->refresh_lock);
+
 	if (gpc->active) {
 		/*
 		 * Deactivate the cache before removing it from the list, KVM

base-commit: 6d6f106db109251010423d8728d76a0260db5814
-- 


