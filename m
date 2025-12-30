Return-Path: <kvm+bounces-66864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA23CEAB3D
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 22:17:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D6EA53017EE4
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 21:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4362DC763;
	Tue, 30 Dec 2025 21:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="os5/JEm2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4A6322B80
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 21:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767129244; cv=none; b=tppryw8pFSd/senuIcfpdZzNBZyTfOxbZiGkoP05OVf1sUJddr0mq/MoCgQmNvFfFmGUGblfsRnfQVyNLSFdk1SyDEu/BuE/l6X99V3YTAw2Q1M67Nk5tl6QrXk7LOIQQLFR6DMAHDn0h8VshdwaCaWp2QUo6OuYU0T8QzlZKw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767129244; c=relaxed/simple;
	bh=EoxLt9CGajQHyT0DJbDfFAocT+/8S1HWJ5svkZDig3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=elSIOSUrQiT+EzMTb/et+o9lD3/F9ByFY8KKHCo1LZpmZ7vvLVP1jmRsi7WNXO2plkhamYjcEw7t6+y++4dfDqbanFt0bNro5thkmstUdxBsjXlRypQZoBaYLdo7hJ+tYYW7Jjln7RJztoO/Ulzp4wdTca8PUiCCiKKKqUMj7rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=os5/JEm2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34cc8bf226cso22964533a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 13:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767129242; x=1767734042; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2l8e4mfqS4ac0ofFyg/wkIl0NnSi9zztS3YUrfbABw0=;
        b=os5/JEm2Ul6c6d87T7xL5TwPVMfUfOnhhZbuxICN8a7SyAi5zKvMLFi1QeWhbIMDI+
         p63GLOcB5vhyOqQa1FEbsmQWbtseDJMrf5Ws1efl0pzOVbAoG/TPKE95/Dvxgw0+AwZb
         iw+aCBxa8s5Lg/pglHvOQksKZfdgzPMAzu7tmOqUU+dryF8JZPEP0Z29zVDXbQJRzQaN
         cE0k7c9+uiv3FDszjLozErFt6m1OgyK2w8W/tok7dASOybaBFPdTR1QoO7804Oxv7/QD
         tjOYEtJsahAGJTsUNirKFfsUYQkDY9kL5wCKw+EKGoSE6OngI6f+FbcVLxkeUzB4yGw+
         sxZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767129242; x=1767734042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2l8e4mfqS4ac0ofFyg/wkIl0NnSi9zztS3YUrfbABw0=;
        b=jxJHcOwo+taXyGVkwS/GIizru3Dm5EK7hR8pwZVxODsgOTemP6Scg2sOxbhOLgJQv9
         5BrCk2TD8tBQHhwai8ZlQJNqN3Lq2lU3cJjF9zu9874H/oAwXSuggg5AZkACGdf0fpMa
         HO8sXI7OsTUKxqxw90FHp/YqUSjRwMq8f1VM1ETKyPkRbHQrdx0Wl2D/bwxGTFJvNP1c
         fXd6EVQPtKA3sKNqmjD3ZHgMHTmJmT10/yPeYr/63bFFSWTCZOP2ttikdsIVQGpL5Cgu
         w+7Gwgu/fa3NMarC0U9Gr432bg1DaTWqGAxz4Z0wgJMabVYhZxWczEOrAqLZUuekhRCQ
         bMjQ==
X-Gm-Message-State: AOJu0YwoQry0qxfMk96iBwC9XfFgcwsVUey8HduMXLfeshC73VjAVXwB
	sojKLWoaUQ5I16L01yTkemX2sC6hfj2Kim0nrMxL4hOGwGwmHvei+nIrgGJHoSww2Gsq8GfDt9N
	2J2yEPQ==
X-Google-Smtp-Source: AGHT+IEsJzuAlVbFq5IPl1q5CmU3amILxSyhNqXHiYg4ksn/VgJLbcnzFFETfo0s8qcklc5ptFrdojqRGHw=
X-Received: from pjbot5.prod.google.com ([2002:a17:90b:3b45:b0:34a:a5cf:dcfd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:514b:b0:341:a9e7:e5f9
 with SMTP id 98e67ed59e1d1-34e91f6759emr24551317a91.0.1767129242518; Tue, 30
 Dec 2025 13:14:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 13:13:46 -0800
In-Reply-To: <20251230211347.4099600-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230211347.4099600-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230211347.4099600-8-seanjc@google.com>
Subject: [PATCH v2 7/8] KVM: SVM: Harden exit_code against being used in
 Spectre-like attacks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Explicitly clamp the exit code used to index KVM's exit handlers to guard
against Spectre-like attacks, mainly to provide consistency between VMX
and SVM (VMX was given the same treatment by commit c926f2f7230b ("KVM:
x86: Protect exit_reason from being used in Spectre-v1/L1TF attacks").

For normal VMs, it's _extremely_ unlikely the exit code could be used to
exploit a speculation vulnerability, as the exit code is set by hardware
and unexpected/unknown exit codes should be quite well bounded (as is/was
the case with VMX).  But with SEV-ES+, the exit code is guest-controlled
as it comes from the GHCB, not from hardware, i.e. an attack from the
guest is at least somewhat plausible.

Irrespective of SEV-ES+, hardening KVM is easy and inexpensive, and such
an attack is theoretically possible.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b97e6763839b..a75cd832e194 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3477,6 +3477,7 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 __exit_code)
 	if (exit_code >= ARRAY_SIZE(svm_exit_handlers))
 		goto unexpected_vmexit;
 
+	exit_code = array_index_nospec(exit_code, ARRAY_SIZE(svm_exit_handlers));
 	if (!svm_exit_handlers[exit_code])
 		goto unexpected_vmexit;
 
-- 
2.52.0.351.gbe84eed79e-goog


