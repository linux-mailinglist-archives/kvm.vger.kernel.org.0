Return-Path: <kvm+bounces-35333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FBA3A0C4AA
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 23:28:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEFFE1881711
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 22:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA7A1FA267;
	Mon, 13 Jan 2025 22:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T13yTbse"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2161F9F70
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 22:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736807269; cv=none; b=iDpXg0QjAcenKphlUikRzdBnfAsX5E2HftVXKKCobmfPw7X2pVVchr28wb462oSuFpYaMvfVtt1UegoqDuIfwGqUASILJiThnUGUIJSPEM/hgxvEnD+LBjfQX/rxDsf2+HRoKmwUQP626rVSbZBLqJzpAe1T6647NWJXujq0IR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736807269; c=relaxed/simple;
	bh=5GjPFjMPTzjbvv9jMn0Vu+JcFADgwPVyHZSXDMV12jA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DMJMULwR9D8LueCwj3Zsxv45YhhLQCYaWbgIQAsIkhLYymyCPWJHFSE7MlEhVPs7EPXsjIpI3n5uRN419B6DhPk/DZRkcAD06hE+G5qBC2qqmxQPGplwLlzWahfpzMBDS8kY9oV/CloeNE87tbI2pyKlbm8XbhOvzz4pas6EVY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T13yTbse; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21661949f23so140517735ad.3
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 14:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736807267; x=1737412067; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=39mnKX1L0qcb+XQar8pyjjef/DCqBo7Lr0CV2YNY9CI=;
        b=T13yTbseqeQAH5KEPiugc/exWyyjEyGMweAohAw+s5JWB7yfjYpo9vUZIcEqbpKJKl
         bcbfTbAAzipDmq1blXRBtSeYqAPIh671M7t7WBzQ3ourEkpQlmnHnychm7aXNqOvW4+z
         fA5f9/nU0GQGhlAhU7j4tnEgqL/CbIIPgkNkEVooR7emBvR9wlY9X22gNaa7Zeg36nF4
         +zBLLiVemGOQDNo0tWongkdcDVOAyes3OdnkF+yIYHT0cEj+RoQfBSU3lvVCL7oYd77J
         9MpXjMcN8nsbHzrHY/Jw12mOUVsJ6yUi+Mr2hP70XAZZjOsGnlIztsZwG8zp/Ovz4R7k
         T9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736807267; x=1737412067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=39mnKX1L0qcb+XQar8pyjjef/DCqBo7Lr0CV2YNY9CI=;
        b=GLxW8UUOlbMySX6ytA3e9gOwJxFx9BSc/Ujf4z3K6YF+0/O5vg1e1ziXwyMvTQsPg/
         IHoxl61hDqIS4EQtPdEA26uZ4cnGDM53qqRbtVUDVD5ZXXhvvZgZlGXW3Jgdas9hdpEX
         KRCE5TW7hDnGpm0DYxFdFaiwMPSSRM3dgebyY5FfrhhNyCoU7y+L0RhqLvhaitq0mXPC
         YE2mgLujlKwfNGy93qY+e34EMc+F+GKBHc4qSJUSvB0ere8BySMTzv3FW4apyr/KMJPK
         LCI8Y04g0Xyqh8XDNS5ib+HqBSKbZ4EzanB6PJxFutJ8sK+LC17FRK7FK2c1BzkfqgQL
         59bQ==
X-Gm-Message-State: AOJu0YwtEw9Vb1xkJ+agFUdgknKgkp84cEHGIzIB02jwQb+yA/H7IDu3
	Z2UHTBoDmvlv/4nRhFIpG+xDCNdxXtOL6/3zye0wPFLrTY40HWb9p7cBr03KDxkkFZ+OblbSRcX
	Ptg==
X-Google-Smtp-Source: AGHT+IHpFJQ9BF+w23kswjBN8A1uwfUDYhkyBhOqmPuMktb7ZLvC/8lkvUR8KHuk272+C/dk8xx6cgvyp/g=
X-Received: from plks12.prod.google.com ([2002:a17:903:2cc:b0:211:fb3b:763b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c941:b0:215:a179:14ca
 with SMTP id d9443c01a7336-21a83f3eec9mr341082645ad.2.1736807267148; Mon, 13
 Jan 2025 14:27:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 13 Jan 2025 14:27:38 -0800
In-Reply-To: <20250113222740.1481934-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113222740.1481934-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250113222740.1481934-4-seanjc@google.com>
Subject: [PATCH 3/5] KVM: selftests: Explicitly free CPUID array at end of
 Hyper-V CPUID test
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>, stable@vger.kernel
Content-Type: text/plain; charset="UTF-8"

Explicitly free the array of CPUID entries at the end of the Hyper-V CPUID
test, mainly in anticipation of moving management of the array into the
main test helper.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 9a0fcc713350..09f9874d7705 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -164,6 +164,7 @@ int main(int argc, char *argv[])
 
 	hv_cpuid_entries = kvm_get_supported_hv_cpuid();
 	test_hv_cpuid(hv_cpuid_entries, kvm_cpu_has(X86_FEATURE_VMX));
+	free((void *)hv_cpuid_entries);
 
 out:
 	kvm_vm_free(vm);
-- 
2.47.1.688.g23fc6f90ad-goog


