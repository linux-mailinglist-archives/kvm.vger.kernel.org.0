Return-Path: <kvm+bounces-21380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B289492DCE0
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 01:44:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E488C1C22268
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4E115FCED;
	Wed, 10 Jul 2024 23:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cQ37ehsA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0695815ECC0
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654966; cv=none; b=Hshv5KyQ/cA2BrEzcOPbejnAUBcbiWAGe+WaE9MNZw+SyoSydns0r3rnuuA+AuWwgSvUOjLr1fydumStWzBV9X4HDzgT1Le8dpVqNseK8aj/ZRs+WydSHtTbAsDv+zS3Em4KCxL9Ly5jhJtzIsK6W5xxT43fETGyEg1EbrRD6BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654966; c=relaxed/simple;
	bh=oWnYdn0BgDHSxRNKslgfesdd9yEejwT/yhYAWEJx0EU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nNPMy21RBqXvtMUU4yRCYOv9Elixnw2KaiSoozSfkd6glTLTgJjJAJLT0jIuNBc+aDhRSmUucDI9NCD0Y0ruyeE5Et93BXyyOzCWlI1RQkTVt6OkPXwl+pDe21zmLcBzhM07R+1IBsYOj9xRM9H87Q5jViQHtuDwQybV0lPXqNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cQ37ehsA; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62d054b1ceeso4632767b3.2
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 16:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654964; x=1721259764; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W1e4HHE4z+5Knov3l2/RvFGqy44M6oXcmkh1U5rufQM=;
        b=cQ37ehsAZHZ/fS5YDkSexvaRxXJno5PLOWbF8zdHMICrqwfOM6TRgcGsE89x2vuS72
         qTVVdk4N0P//WDrPT0pDJTlOK+RrwdLAGNlO552d0ONRNWj/YLYAS18nI8inrML6kk1R
         hgYgHZmesf7EtVfrnnZhNCURHJlggTCyyvHELrCfOKc8W7GX1ToTkM3HAoKtfcFQKtRe
         uwoA01PReifS6nRjBcQqOLDYh81N1ussNCyn7BidgbzR3Pdg3TJ87VPyVb35DSw0E5Bp
         uOmuVaKQayhqV+LX2NXp0cof9ZefM2SSQLQNeCQC9y/++tmRAcMQukN5VYYJkCXOcrzR
         /AHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654964; x=1721259764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W1e4HHE4z+5Knov3l2/RvFGqy44M6oXcmkh1U5rufQM=;
        b=NEMQq9f2+jMmPaWFEhVx5hcvpFSwrfNFYAFW31LR12qnwqw77QEoXsJT+/ZSZHA1h9
         BdEkmVOcVVWkaoQtDdI0hZRvg+OMKK/D2HpNoNmOXJ0y9MZNAYtDroH0fNt10+wHovVJ
         +QD0synHi4bHsOtY8IrjBOfEs3dU05sy3xlWuVm91UuOlL8M4ZkB+Kz5rprK0n9sfsCl
         zUryvdjBNm+WZEAGXBqaWGKDjFxH1nlrzkcaC+nfpiZH2ijJP6gObCLmBBfRtIfaJ0nw
         Qv5DjdL5LPMYSU5yHbEu/L6EZ8yuNSkv/EkeioRGcMZLZHP7/v8xeIGZIHdc9Q9AeScg
         ZQKg==
X-Forwarded-Encrypted: i=1; AJvYcCXKN2PO3SEpek4fMgt48U2PIve4UREAAVpulXydgdVJucTcB5LxdrcDJy44xcSFWJQZvrWjDehAaOQF5m9dD+qfmBrA
X-Gm-Message-State: AOJu0Yxk+x/xKO1MJQkygExWrWeFnRizIed/k05yJSuGLuxSQhmRZWx3
	PInmHnPP4fsZTC+tXYM30XKETstFhebocQTKMGTGfFSQH7ALgj634HlGrc0nXW36+Netza8vZoZ
	YWpWozmihXAqEzibhxQ==
X-Google-Smtp-Source: AGHT+IH5NTISR7DBZbSKRJUHRXFWyLuVrVBePrqFfNwytKF1BLIU+MNslDD3lgHeZpjWWwkTnE/TGMGwZ5jaEHpH
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:7244:b0:62f:22cd:7082 with
 SMTP id 00721157ae682-658f01f530bmr1591717b3.5.1720654963909; Wed, 10 Jul
 2024 16:42:43 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:10 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-7-jthoughton@google.com>
Subject: [RFC PATCH 06/18] KVM: Add KVM_MEMORY_EXIT_FLAG_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This is needed to support returning to userspace when a vCPU attempts to
access a userfault gfn.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c84c24a9678e..6aa99b4587c6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -429,6 +429,7 @@ struct kvm_run {
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+#define KVM_MEMORY_EXIT_FLAG_USERFAULT	(1ULL << 4)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
-- 
2.45.2.993.g49e7a77208-goog


