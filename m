Return-Path: <kvm+bounces-8941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99AA6858CC4
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:34:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1D7D1C21E4D
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E64B1773D;
	Sat, 17 Feb 2024 01:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wAkhB+tE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0434E149E08
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 01:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708133677; cv=none; b=JY3Hn2bD95i9TTAIbP7IHOxTicnWh8b7lLJFSP8hlXVK7Web9PSvC+yk9Y65wzMwTVhiCH3RWbQUR0y3SMYBMoy3KpRSthfLV5r/GEv0Lb9SLXDVIM6IEKjPDJuckcrWzvpcfcfGMYQelFfeCjuz6Vn5HjHQToQ9zCh2uZMtXv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708133677; c=relaxed/simple;
	bh=CCqhL6OxPySMxyCsemMfR4OsGPip9sZrMtAildgv/eo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=t/dITGZZAhv/HzTPdI9AqD1f8RZGVd2LEb5Ot4euNSb0MtFY6GEEYcSesoDlM+Ju9/IlppWBqj+85YXhCE1nkZjMk/tTcL7rtLF6MpEpJ6s50mxtkYhkKeHePhoBsxlDJ3CmgqWzj/zE7bOYXdRXbn1kaNzQ71+yV/APSnfxVKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wAkhB+tE; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-607c9677a91so47986747b3.2
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 17:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708133675; x=1708738475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8V5hHcKHjHM46B61QGfRSvoByqou28ucJRHIA1LXfY4=;
        b=wAkhB+tEONLD159y9q1s+Zosg36Ov8TCx7tHzZi1AR4jTAAeNBujBvtR2UZZWYw0Ai
         DzMxSjjASzRXaM8yILTkC7ZJ6SswyIaOi+/QRvWoOc4qXUCANQeFvdlMnDppze3sLRUt
         vltV2m9mSIR0o2oRa9wXeRixwo7t0PcbG2TpcvkxA8U+nSzspj0CVhiVW4FSHPwxFXqF
         IQOhlaBc1eXJVWsaplRo1xARbBpzMQZTMJy3NM/Ste8iCR45wa5FWR2Kzmrxou9UHWcG
         kKRDj+X1Yx2iaE2yly9WijygJtYW9rj3K1eGleCyigJSKehOY/vg/aTAKX1vIqSdWzcJ
         LkUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708133675; x=1708738475;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8V5hHcKHjHM46B61QGfRSvoByqou28ucJRHIA1LXfY4=;
        b=JDLShS6+0e0AiFV7XQDBTTZ/It/YGI4klb98tonFodcqUmQq4DahgUE+tZFo42+zYX
         Cg64VWDPGaKzE676G1AdP6B1L/osmGe62Q5JQTPqMOA0CnmwGFC+FjNIHc3kLkUWpA2o
         WEc41AZdY9H9h17gaEnA2ovAe8EQBl3/S4HnuMcWBYcIeRNqj4TrfN6SiqbBhLU0g5tu
         3VzbAHIb8vSZ/VAProdXu2RkMCjS1H7dx52+8BFWtwn3qaZoQsKePqr/T1orxHlrtAo4
         nT7kKg8D75ziI8O6lGt/Jz0arrPsoLaRve+EZdbaNf7qGGhFvS5hPWmTosaMwuVzkjKr
         4Pig==
X-Gm-Message-State: AOJu0YzcYg3N5SAN5b2LqwgaQQ0nFU3IcsCNQG4Y1ksDSmTYFjioDpA4
	2v5NF4gCxwpaJaJltB8M4k3VvwTYojBI1C1wep8sGlBHd6bSNYzrJ4H5tOXTnIiptA+vWQzb1Ry
	3aQ==
X-Google-Smtp-Source: AGHT+IG0DHiqUTZsUTS2w3YWIcyHBEsYUAn1JoY6wCyJEjknjPqwSUtfcLN8FjWW2R1v791xocVrgyeJfXY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d496:0:b0:608:d1d:d8d6 with SMTP id
 w144-20020a0dd496000000b006080d1dd8d6mr181981ywd.7.1708133674935; Fri, 16 Feb
 2024 17:34:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 Feb 2024 17:34:30 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240217013430.2079561-1-seanjc@google.com>
Subject: [PATCH] KVM: SVM: Flush pages under kvm->lock to fix UAF in svm_register_enc_region()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Gabe Kirkpatrick <gkirkpatrick@google.com>, Josh Eads <josheads@google.com>, 
	Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

Do the cache flush of converted pages in svm_register_enc_region() before
dropping kvm->lock to fix use-after-free issues where region and/or its
array of pages could be freed by a different task, e.g. if userspace has
__unregister_enc_region_locked() already queued up for the region.

Note, the "obvious" alternative of using local variables doesn't fully
resolve the bug, as region->pages is also dynamically allocated.  I.e. the
region structure itself would be fine, but region->pages could be freed.

Flushing multiple pages under kvm->lock is unfortunate, but the entire
flow is a rare slow path, and the manual flush is only needed on CPUs that
lack coherency for encrypted memory.

Fixes: 19a23da53932 ("Fix unsynchronized access to sev members through svm_register_enc_region")
Reported-by: Gabe Kirkpatrick <gkirkpatrick@google.com>
Cc: Josh Eads <josheads@google.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f06f9e51ad9d..cbc626dc8795 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1981,20 +1981,22 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 		goto e_free;
 	}
 
-	region->uaddr = range->addr;
-	region->size = range->size;
-
-	list_add_tail(&region->list, &sev->regions_list);
-	mutex_unlock(&kvm->lock);
-
 	/*
 	 * The guest may change the memory encryption attribute from C=0 -> C=1
 	 * or vice versa for this memory range. Lets make sure caches are
 	 * flushed to ensure that guest data gets written into memory with
-	 * correct C-bit.
+	 * correct C-bit.  Note, this must be done before dropping kvm->lock,
+	 * as region and its array of pages can be freed by a different task
+	 * once kvm->lock is released.
 	 */
 	sev_clflush_pages(region->pages, region->npages);
 
+	region->uaddr = range->addr;
+	region->size = range->size;
+
+	list_add_tail(&region->list, &sev->regions_list);
+	mutex_unlock(&kvm->lock);
+
 	return ret;
 
 e_free:

base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4
-- 
2.44.0.rc0.258.g7320e95886-goog


