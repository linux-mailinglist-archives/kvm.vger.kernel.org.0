Return-Path: <kvm+bounces-33070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D17699E444D
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 20:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90899286A1C
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECAC01F709D;
	Wed,  4 Dec 2024 19:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k55UV2wp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1E71A8F9A
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 19:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339661; cv=none; b=alB2rI9KDn/AfBjCzRRWcUL7x6DLR4g83rVNbrQR8+oV/Q3ZuYa7/7sqfOCJmWE9Wvtn3TmDelkkxkYV1YsovBKEQ1X8Sl2bf0Sdtg2eZAkZi6FLlNWBixyF6tEXuB9+fHOywMF5EuafCsvsMbkDk/npGlTbMK8izUaIJoZwqeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339661; c=relaxed/simple;
	bh=TpUkUFBOXODTTMhFPZD2lNGB5T081ke6yKBQcgGS+ss=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J0X6yxFhyVvJwH7TYMIhPvyaxyc6OAuh8hCOFEvl9lvH1WkNWhEgpjIuYiW3t2Izihp0tp7tt3ZamX6jqHdxYxQOQMxQnSeq2hmLty0kRixXxS/vcn2KZlovNzs04LhRiMetrktzKV+6l8o4Um/SAOqtprJmJ2o05qxtzcKaSs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k55UV2wp; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-71d5f5ffc2aso126928a34.1
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 11:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339659; x=1733944459; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QAQf3CS/PWwFToEYvErsd8wUXXWpCS3gaH7WeW/jjGQ=;
        b=k55UV2wpB+kQRl+gbfTP1ICVDfPAXkFhbcIMhO4AHNV+DHiAr/Uf9O4Vjak5FnOg/a
         r9eU+1BgxJ9M2obz0NIir5XE5kYm/Rke+Bw2iyV1zIzibuYmbaqWA/5DrnFRGLxk3cKE
         2djkRF+B+rzi3dY5mc7nGolIuY96T4owSbcj+HtqgQZZgA2emkWCTiSHghI3X1BuDkH2
         bsvtt1mJl/NeNbLcJod0vqVc6lyUk520gFbB/pTz3+sGrSD8X7mNtFuqNjpcOfUs9ZRd
         rShKitaZQ2Dt2VMaCQNzSin3NriMtegyVz3tIWmV+gBVicOsMua4maJc1zwVh0V6W4LT
         ShEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339659; x=1733944459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QAQf3CS/PWwFToEYvErsd8wUXXWpCS3gaH7WeW/jjGQ=;
        b=BB7FtvOWKnO7VQR2svNiOobk6yod4GJMb23X5yCyZ0vmhXfKU8oX7sYlfRIGkMM+PP
         mX/koD+tlJPwryy1Tr/VTLZUzl6J3bVG1o373c8MWENbfWNSNb0uDb3GNWwZFCVcXpdz
         vNr4wXpAJNw1+F60RGoFE8CI2hfFx5tm7keTqbsnV2HYKruf+rv/84vdkDDEKWPQE2A7
         ehyg/bbB5R33v86hmR2tmXIS6Z6K/w7Wc+EWUIDZMA3GaC60B7pgW+lSYC4C23gF/2Kj
         f63vTB3ykQHodYjNkeLSD4BRrocHEmU2OUQr29/LzE07lpqZEIS8rh5G0zk+KmejIlmJ
         KWng==
X-Forwarded-Encrypted: i=1; AJvYcCUmin4DFmRJhtj+wotGxUrajJFsu5z4uVQBYtZ8UTy6YEFVseJkZGFuemu8cGpHNw7vdyQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOhHkVojBGQ3phr3KyOhZQNuQa+EKKl/mp/nTKg6CtjFR25NE+
	1WYOAnfG5aoPjpelYhQEUo+ONJ8L6b2jeZeVFepaciCQkPmBU2Zzjtz5IBOs7J4NZQUH2O1X7Yx
	3AVeRjpKw6OEDt+RoIw==
X-Google-Smtp-Source: AGHT+IF4lgVNFWtAABhlVyCvDTypvCqwQE4E76pJaa2ei5llPSfzgOLBadwb4XjVCcPSe7j0KBf+vwviXHvnVJ9Y
X-Received: from vsvj2.prod.google.com ([2002:a05:6102:3e02:b0:4af:5a5c:cdaa])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:348b:b0:71d:4c3b:f464 with SMTP id 46e09a7af769-71dad63c3e4mr7692549a34.13.1733339659221;
 Wed, 04 Dec 2024 11:14:19 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:39 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-5-jthoughton@google.com>
Subject: [PATCH v1 04/13] KVM: Advertise KVM_CAP_USERFAULT in KVM_CHECK_EXTENSION
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Advertise support for KVM_CAP_USERFAULT when kvm_has_userfault() returns
true. Currently this is merely IS_ENABLED(CONFIG_HAVE_KVM_USERFAULT), so
it is somewhat redundant.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/uapi/linux/kvm.h | 1 +
 virt/kvm/kvm_main.c      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 641a2e580441..d9a135c895d7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -936,6 +936,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_USERFAULT 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fa851704db94..b552cdef2850 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4804,6 +4804,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
+#endif
+#ifdef CONFIG_HAVE_KVM_USERFAULT
+	case KVM_CAP_USERFAULT:
+		return kvm_has_userfault(kvm);
 #endif
 	default:
 		break;
-- 
2.47.0.338.g60cca15819-goog


