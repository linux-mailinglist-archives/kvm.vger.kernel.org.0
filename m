Return-Path: <kvm+bounces-44171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 905DBA9B0A9
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0C074A485E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D04E9293B58;
	Thu, 24 Apr 2025 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rQRWxIZ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D1529116D
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504064; cv=none; b=PHP4qvteHimaQJNlSQaHcKn1mwvQhUrP4KKtgpud6Z1qtKvHvF02i0t+Q3w+j8WhuNeCUEO83c6lfVpjPLuS6A22DqxZWZkkFi7RcQkl5N10j9+4EY4SD6FOY8yTSIl57opnXfvW3Q9SClKYTTogQyn2K9h55SfcnwbgiCQxI0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504064; c=relaxed/simple;
	bh=l8MXGFGw31uuwPrLVCURxj+dBhiUP5Eq/JDGE+Ioyyo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aTchR76HhnFxPEQVix0P4olVbiBY6+BI7eyruJd5ShmPt5Gq3a+SfVFL1gDBt3kYQU1ZQ8gYCTb5JSHhMdO7L5CouEgSKps8gpqacU7giDkXZEyFtDCrLg15WX9rThNJRk15h8e+X/DMwHV3Cz/afmp+TqdeFG5eudjdK6/q0a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rQRWxIZ8; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43ede096d73so8247205e9.2
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504060; x=1746108860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULK/WgQrAoOKgv7yTbnqoplbgLc/ybTV2ol4z7wD4V8=;
        b=rQRWxIZ8fpXO6y7A7UEoBuCu58ZSGVRY0fjpUvj5yf8BrVkOihzZTjogYnJHmrD9OG
         5bBkzKMlKMuW7rijJvKvn5tzGE4ax3rinG5VQMmuwWDDuQieJiCbQmPJDAMonyD/KNBe
         cfZbIYruffocTqvtlrq7tyjPuoXof+RxuzdU2huHJcpAqTA1ujaVCIQRTZKoTztXvzwh
         qZMS1XOZsce0KykvQTP+oDgnnDxzTkiBHhsH6l3NUVVKKeZ39mJEAUhN2/65eho8OO4X
         IHXSFmu5YI3FeaFhWrHR1akw5UVoAhlIobKVnFlNNIkIfax5YE5OOBHoU4//QWZhg5DI
         vofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504060; x=1746108860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ULK/WgQrAoOKgv7yTbnqoplbgLc/ybTV2ol4z7wD4V8=;
        b=XqKZeGQfIpERA3GN56Kmi+fQeubSHFCnNJnVj0Uz8GakqXm79aFV0fp8zmn6m0lAmX
         Fr2eDnWtEVd4wdl6e6GA+S7R34YbuqC3yucvX6fJ7a1XTIsuN4a4N/Gxg5URuQMn+hbe
         osIdu3yJvMS3z+/x3lsJm3e7xEY+mMYh4iQczc6jQ/hHdi/G3GswCdcwHAl7FJIGX2Aa
         YV0VfY9nzhEMoaOCOi8t5pcNSTmZsvVKgDqmTCzoGa/hPiEuLnVCQuw9ucBJaH8pg0yH
         jcEAgV71Xb7I6s1de1u4KgkWRBNc1s1rD8wYpVCjBA76CV6/B+VHZJi3IzwEcd+lTfMo
         Bkwg==
X-Forwarded-Encrypted: i=1; AJvYcCUpyov1nXo0rScHtx4/Bf5MwihuLymfF+RW38DW04+xhrut+tLuqghnkCKR+N4enCybr0s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyK6gHt2jANQQHZXh+mAauwgeJbEkMl40rPJ5IVjMGQTXH5hXBf
	FaCBdYX2EysjkLCqeaTMF/Bj/oWqoT43JIZppuxbrCWcq9UthewQJZsmdnusnWc=
X-Gm-Gg: ASbGncu1wUYmEWpELNNHmt6uBX5urPFSL8sNZTyyRPNpw3cyjRKf+3LkDgH1ZCwSOGl
	6uqC/QyreMfsmC9dFoW/qFVNd+ykCcP6kU0CXq2YpCWS3EGzHK55MBLSU9p+ZQzCQzOTHNDaNwS
	VyQOzwAsT/Sd5wkfEQEz0C5u/f+lr79L9LJtc1zUEX6vLoJCwYvdPXuUnQ3DxOoBZsawZcaAPo0
	VhA/ola14IB/7uPHgChhVmDVfUTj8VyouSrWqNaLf9JdLzg9oEybM6r+FUWh2L5Pr0QzoYUP2Tc
	uCwWW8FgxPHGwndlbKtVv5mq4wh0MqtNiCyR6PbCddm9K9A+dxZV6EdFbm6W1N6guM3CDst+ClS
	/FVZt9Ki5sI7/w65T
X-Google-Smtp-Source: AGHT+IFE5/vk9/X0Lu9aLCAdTyRnF+oi4a9Eo+hij9nbvfLjJtzlSBwWD4MqvNxQh/Fi8Qjri674AQ==
X-Received: by 2002:a05:6000:220c:b0:3a0:65bc:3543 with SMTP id ffacd0b85a97d-3a06cf65a2bmr2283431f8f.35.1745504059899;
        Thu, 24 Apr 2025 07:14:19 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:19 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 26/34] gunyah: Share memory parcels
Date: Thu, 24 Apr 2025 15:13:33 +0100
Message-Id: <20250424141341.841734-27-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Gunyah Resource Manager sets up a virtual machine based on a device
tree which lives in guest memory. Resource manager requires this memory
to be provided as a memory parcel for it to read and manipulate.
Implement a function to construct a memory parcel from the guest's
pinned memory pages.

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/kvm/gunyah.c | 80 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index 7216db642174..ef0971146b56 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -634,6 +634,86 @@ static int gunyah_memory_reclaim_folio(struct gunyah_vm *ghvm,
 	return ret;
 }
 
+static int gunyah_share_memory_parcel(struct gunyah_vm *ghvm,
+		struct gunyah_rm_mem_parcel *parcel, gfn_t gfn, u64 nr)
+{
+	struct kvm *kvm = &ghvm->kvm;
+	struct kvm_memory_slot *memslot;
+	struct page **pages;
+	int ret;
+	u64 i;
+
+	if (!nr)
+		return -EINVAL;
+
+	memslot = gfn_to_memslot(kvm, gfn);
+	if (!memslot)
+		return -ENOENT;
+
+	parcel->mem_entries = kcalloc(nr, sizeof(*parcel->mem_entries), GFP_KERNEL);
+	if (!parcel->mem_entries)
+		return -ENOMEM;
+	parcel->n_mem_entries = nr;
+
+	pages = memslot->arch.pages + (gfn - memslot->base_gfn);
+
+	for (i = 0; i < nr; i++) {
+		parcel->mem_entries[i].size = cpu_to_le64(PAGE_SIZE);
+		parcel->mem_entries[i].phys_addr = cpu_to_le64(page_to_phys(pages[i]));
+	}
+
+	parcel->n_acl_entries = 1;
+	parcel->acl_entries = kcalloc(parcel->n_acl_entries,
+				      sizeof(*parcel->acl_entries), GFP_KERNEL);
+	if (!parcel->n_acl_entries) {
+		ret = -ENOMEM;
+		goto free_entries;
+	}
+	parcel->acl_entries[0].vmid = cpu_to_le16(ghvm->vmid);
+	parcel->acl_entries[0].perms |= GUNYAH_RM_ACL_R;
+	parcel->acl_entries[0].perms |= GUNYAH_RM_ACL_W;
+	parcel->acl_entries[0].perms |= GUNYAH_RM_ACL_X;
+	parcel->mem_handle = GUNYAH_MEM_HANDLE_INVAL;
+
+	ret = gunyah_rm_mem_share(ghvm->rm, parcel);
+	if (ret)
+		goto free_acl;
+
+	return ret;
+free_acl:
+	kfree(parcel->acl_entries);
+	parcel->acl_entries = NULL;
+free_entries:
+	kfree(parcel->mem_entries);
+	parcel->mem_entries = NULL;
+	parcel->n_mem_entries = 0;
+
+	return ret;
+}
+
+static int gunyah_reclaim_memory_parcel(struct gunyah_vm *ghvm,
+		struct gunyah_rm_mem_parcel *parcel, gfn_t gfn, u64 nr)
+{
+	int ret;
+
+	if (parcel->mem_handle != GUNYAH_MEM_HANDLE_INVAL) {
+		ret = gunyah_rm_mem_reclaim(ghvm->rm, parcel);
+		if (ret) {
+			dev_err(ghvm->parent, "Failed to reclaim parcel: %d\n",
+				ret);
+			/* We can't reclaim the pages -- hold onto the pages
+			 * forever because we don't know what state the memory
+			 * is in
+			 */
+			return ret;
+		}
+		parcel->mem_handle = GUNYAH_MEM_HANDLE_INVAL;
+		kfree(parcel->mem_entries);
+		kfree(parcel->acl_entries);
+	}
+	return 0;
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
-- 
2.39.5


