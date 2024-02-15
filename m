Return-Path: <kvm+bounces-8837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C96E1857205
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:54:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 807EC1F23E83
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45C011468EE;
	Thu, 15 Feb 2024 23:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yt89FVTw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADBD146008
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041257; cv=none; b=tRPAqRuYKhFfgCrTH0HsRMRKumpqRbGs183Hdn8A6l6s5YItIM5B5+eEHS988vB3tkhfUX+eZxkcyHu2I2UgxUKuUIjJrd3EdJJ+a+bSHnD2Wn6IT6im7DI1gIxxz1g4WrR+lAGYTxVDYjj6gVPO0cB9ZdVkBTY6l5nbnvtaiy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041257; c=relaxed/simple;
	bh=r2pWpzfAVdKs83bkb8yysRyBcLlfdbbrpFtdK+fTshk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C8elLeEsO9oEFqAkUPihMojC7ReOPOX28lg/p/Y2Yi3GadUfjEc79m6PBjuRkjPtEKdjPz4DTQHdoYtpoJpMWfuOS6QZotS64VTJHKbi7F5v4NjhgQgR7haB3RwEKR4jfIEqNX0C/mj4vKSf6Mc79iU4/ITQE3xokwnCD/fkYLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yt89FVTw; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-607cef709dcso23359147b3.1
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041255; x=1708646055; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eziXXvGnuzc3MNfe8KeDVfyFrpM4nmh4XdH42oDvVIQ=;
        b=yt89FVTwUvQxwNVebGn9kHQ/At44GHZpQWEZZYV0F4YeTEGeqBmUTgRUp/E0yK3wkD
         iudEnUPa+GRm3yrnotFNXqrEtYMGWroQHhLe866AdcNK4QyF4KL8zfoMHt3vQOO0oL9d
         LnNGf7Gxxw3ILVHi3N9NCssLd1SZwUIdK9jqhYR5oVla4dCnGwFjTzFCwbqoYXAgzYe2
         sTxo9k0PwhjZZTOoV7F8Xi03+fiYcLUf8v/W4t8bSBPdKPouVK5amqn5J+vuRRjhv6Kf
         rMbDkS9Imu0NxxGiGi3Y/wVovQuKzNOpePq/+JBREurNO+il3YecaVKunWU3tvGTgevp
         FYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041255; x=1708646055;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eziXXvGnuzc3MNfe8KeDVfyFrpM4nmh4XdH42oDvVIQ=;
        b=CQga99FOPYA+onBMbsELBq/G+/F812QLwQcvD2czGld6BhY6kq2gv+QAinUWaUNI2g
         A3DA/gOgD1TLMszG9efFv6Oexp8ALK04vqTEBY3S1F6qXEU6zLa1kl8MQu4NpSEJ2i0q
         5kHfR6JgsROIoK0HkPVxOntbla/VYcp8YyIzsAaMs2nA4X1gZ09vVJ2O1tox07N1Oi3Z
         +Eqw42cYwSfJAUtFV77OSgYfnDMzXNT1podnErwQVoG4QiG9TWJukm7S/9wP+0btv/FP
         NE4dQSXdrmggKxgAHHlQEDZn/HhfPcrvInL9bDIfm0wztDAPtR9APyXi1EFLKlaGzVCz
         PYig==
X-Forwarded-Encrypted: i=1; AJvYcCXlG90D2VeI4g10U3GU63z1SY5fLXDeF8G+Xu4m/ebgvOB67xN2jAkTSBjjvKapNoivVrHqbHtkN/Z9zXniF5Jhn70a
X-Gm-Message-State: AOJu0YzHdMNncJ+5t+3QE2hofd9XroHD1ojhsn5Vh7u9Nlz62IW417vP
	9L8hJ63J/JiXTqxV2cFdQHPHfF9NEeZjOdy7oml9u8xTDnuhCfsAwd+3pclq+eMC8N8B2EYCu/k
	N3YCQpi28tA==
X-Google-Smtp-Source: AGHT+IFww/v3CM+5seP7lyS6W1rnjeJciBbkYTG1sl3efm7OgTZ/7wSq8CJehcHQjIKBWPkZH378Co78DdrMgg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:705:b0:dc7:53a0:83ad with SMTP
 id k5-20020a056902070500b00dc753a083admr787010ybt.5.1708041255003; Thu, 15
 Feb 2024 15:54:15 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:55 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-5-amoorthy@google.com>
Subject: [PATCH v7 04/14] KVM: Simplify error handling in __gfn_to_pfn_memslot()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

KVM_HVA_ERR_RO_BAD satisfies kvm_is_error_hva(), so there's no need to
duplicate the "if (writable)" block. Fix this by bringing all
kvm_is_error_hva() cases under one conditional.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7186d301d617..67ca580a18c5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3031,15 +3031,13 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 	if (hva)
 		*hva = addr;
 
-	if (addr == KVM_HVA_ERR_RO_BAD) {
-		if (writable)
-			*writable = false;
-		return KVM_PFN_ERR_RO_FAULT;
-	}
-
 	if (kvm_is_error_hva(addr)) {
 		if (writable)
 			*writable = false;
+
+		if (addr == KVM_HVA_ERR_RO_BAD)
+			return KVM_PFN_ERR_RO_FAULT;
+
 		return KVM_PFN_NOSLOT;
 	}
 
-- 
2.44.0.rc0.258.g7320e95886-goog


