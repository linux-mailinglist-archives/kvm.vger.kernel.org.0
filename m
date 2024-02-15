Return-Path: <kvm+bounces-8835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CD4D857202
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:54:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5E3A285E56
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6127414600C;
	Thu, 15 Feb 2024 23:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ziL+fp5V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3203145B15
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041255; cv=none; b=m8qAEjDG6j0syCkrR3cniWZei0gYyzNf0SyAOry5hw7aDaMkpO8JrjvyDM/t747xKME5FSG0m43u3PawjhD+7lYHIGjKd5mJolf1yTNUw5VLtJvAbOJN4g0BN0VKsl3UaC0tVAcDTdElkU8GaWffn3CpKar6xEqZGHR+t1bQX3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041255; c=relaxed/simple;
	bh=hE7An6neuPVvOGcFnrnVMg3xQPxzurJcj0TyW5C9ZWo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t7q9ZaPcYCY2nA3HE7WjtWOTpavt46H6A2eucC//NVFOr845rQomvHoaFqmvCmyxoBEyfwLjPeb7QrBIUvUzZLzdmVqwzGkmrQuuHLrIA0/YdxoqrRx0BWUuwVwvVqlKz+gRO7+mGdf+90nY5oYSR/hhHu2Lou1nZiRvf0dxKNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ziL+fp5V; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64e0fc7c8so1969245276.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041253; x=1708646053; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yo/o9LY2I9nX5aBe59uiruEUtYqrrYJs95LrQhRBOZE=;
        b=ziL+fp5VHJaRoO8k+aNtpQ+lNiGBHzqtLxRID1Ri6s344KY6IwPV0MsolH2kVJplMv
         lLfDNXrvVE3larf0F9J0RX80uL2GhpcvuQVXtu+T2Z7hHt3DqYCnGgGgQVsk1x7CxDHn
         j3riqpvPXvKpTUOzKmPOD4XVYVEDsikbAIAo2aOZoWwfCqDPPn+cz60xIp0CTMIxl4UR
         13VrYSudnuiHOKJ1jpCYO3LAXiFizwDYYXlbJSD4d40CW0UQfiXeNCF8m6k0iCSS+qm7
         /hmJIlCbWGZ8DrXwGWClCQh8Gx7CZlWT9tP9m4ZYyxO3dXc/gUiEaopA4V4+XG2Jop77
         GReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041253; x=1708646053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yo/o9LY2I9nX5aBe59uiruEUtYqrrYJs95LrQhRBOZE=;
        b=ag8vLmOwXPYa1di6PDysqjIK29dbrIY8TOD0w2VkB0zu5GorjWM/LVNGOQKKL6Gr35
         Ry3hRCRGVHyeIMpS4RU31MYNcGaF/j38gBxqMgWw8CMryTf0pUtxKXlMsC/nTR4Nkr6Z
         ZJHW0upK/w/w9ZEjcmkEQYcFxovU4HHLFWM7pcM9g36L8ojwGiLUlsZ2Kr0wvFs0nEgA
         /vBab4zwyaxzEBFLHj48ygp5bNfIE2TWMCFnfROABLAw7UZ0fwxY+kWjQxfGauabJTu1
         QOvRjRhU9SvuFkfL9JSXPHD3vmQTj2spQ2/x1ot6+Ih7qobJwqiIAm6aX82aEtRCraKk
         7IvA==
X-Forwarded-Encrypted: i=1; AJvYcCWV15W0mGyM7pIKwCR9cjMKfgfQA+NrEFShUrIRUHvsaofD1fyv/Ze+uMX0U3cXuVptJNuDF0MZ1lw5T7pkpiNF2pKx
X-Gm-Message-State: AOJu0Yws0W4t8Haf5JI97kRWKqsYYgnc5JFKnXzy2GK+FqP23op/J1G3
	/j5xAsHzzDkQNWbVPSgX2Xmmn/IeGmRNWuHDU2qBVxr5LsTkdJybnUH0aBr5quBrlhse1ny5Ggh
	YIav4vp3MAw==
X-Google-Smtp-Source: AGHT+IEKdbXqNVReTvl5F0UombK5sQ0Ti7UMHJ2sVJ221GtcNLTwHyT9qTykKRnqFVP6BOtF0+Av1SRu6Gg7sw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1001:b0:dcc:79ab:e522 with SMTP
 id w1-20020a056902100100b00dcc79abe522mr129806ybt.11.1708041253060; Thu, 15
 Feb 2024 15:54:13 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:53 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-3-amoorthy@google.com>
Subject: [PATCH v7 02/14] KVM: Add function comments for __kvm_read/write_guest_page()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The (gfn, data, offset, len) order of parameters is a little strange
since "offset" applies to "gfn" rather than to "data". Add function
comments to make things perfectly clear.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 46e7b8dbb3d8..7186d301d617 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3304,6 +3304,7 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+/* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
 {
@@ -3405,6 +3406,7 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
+/* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
-- 
2.44.0.rc0.258.g7320e95886-goog


