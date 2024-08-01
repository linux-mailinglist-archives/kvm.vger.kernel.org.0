Return-Path: <kvm+bounces-22903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95CCD944751
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:02:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FC1E1F22FF4
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F389170A03;
	Thu,  1 Aug 2024 09:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0S+nV2l3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10408170A08
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722502892; cv=none; b=lz2ikuRtmWWaerO+YUTMSPJFEgFkNd9S+RMOllrp2hJdOISnn4rK733XQNCt2CuFcWtFRG6VlDFNzvmQ3dFh0akpl+LHKNSC7+uE1Ifa7Jj+XmXbkMZX0vRSkm18WKAHl0AVAaXnNgi+V3XV4mHIiurpU/zXQekFGGI2590hgvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722502892; c=relaxed/simple;
	bh=C7bksynIBlDmKWzYneQQmkbLTeJZkrmT11xDMld4peA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WqNNFDTl7wbWVv+T80Qn9PiLTmR4fD6jO8hzLCpLXNVpNkK/67M72dEFL1VeZ63yl9/cgwv3c/kZJjjP2AXIdciId5APIqBmcQk5NCb0X20E3WIjhg9JdNYKxTqNrWlcx8wIrMUJju7fqM7KCkbewycTEbhbYB99TZCV8wyc9ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0S+nV2l3; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-672bea19dd3so140831077b3.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722502890; x=1723107690; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LPYjxi2NpHlLCCCycghuduPbRm3K8NiftdQ2Nx+A00o=;
        b=0S+nV2l3KdXtNu6yLURPlbFskle7e+h8Mt1Wd2CbWLEsIIPRfrH9nVyMGYmqiVmdCL
         R8pNhcB37YFYWzDA+QMYFDFRHSk72VgLTg5malYbMqiuOWsPiAq2nhhID4zJBM4EpqvY
         qgq0A+c7wHcmT5q36PkG1T95Km4EpZwRRwbsllsccZigeIeUnfbctHzlPcghKX8rQY/1
         PdLW5TuzxUFnam6Nu9KB6qTvKQgMx1Cyv4u4AzkBzE3AADO2jOh7dy5Eo9Ho8zJcXyZc
         og3IuxcDi1haYsz+VlLuF/du9Z0ngih15K9sd77ZkBAm5/ZmDsZxgq+0UpFP/cfZlCN8
         os4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722502890; x=1723107690;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LPYjxi2NpHlLCCCycghuduPbRm3K8NiftdQ2Nx+A00o=;
        b=VDwS5zSvtbLfwou75jBivs6kOVYXFudedUVcR/7X28FmlLs3OMnAGPdBYWUIx5UmxZ
         U6IbYs5YC6Ksw0DUpd0RmuLOyyR+HnLhtdPa169J4GfvmZRlMO4AAt4wjXHCpdmibNvI
         qCHp9rrkRToGzG9esCArAOemprYrY1Utb3DOWmkrcHLi2nnpzKPsHtB7jP1Ayb/0R39j
         zLTsnW8s14VjitJDlW956qCMGokfsPMlK9wHYueGz/YuxCKtfXT47ElNG6L7ym7TZxpY
         5qemNhl3nlOA7B8fXJYKt8u9aTPvz9W9pyVV4r2wRGFzUzGbBjC7egiiMkSrD/WDET74
         9soQ==
X-Gm-Message-State: AOJu0YxqPYb1ebW2BX56LD4Kx24Rdk6BmOslIlmXNzkbIC9AV/mnHJMF
	gVdfHzU0etEma/0Sg7syCEfLUYuxawfRFEXI8ILcyL6qUiS+opq30phS3UTp3xj940QJFmxJ2nX
	9FhwMhOAfFctkqK4w+BuKLu9dQCnztZFXDFP6jRUKLs+CJ1y7+sWuIp7wOo0ofQOZu4mhKqMdDJ
	k0J7wm7ryGyiVEyAEYha0mSpk=
X-Google-Smtp-Source: AGHT+IEWXtT3G1kPV2U5ozw0QmNThPZWLC3X0cJFXxT6qwOkPcf9RWWDopByOJxRGSqLytT/Up6QyZXMSQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:9e:b0:673:b39a:92ce with SMTP id
 00721157ae682-6874be4e4b8mr30247b3.3.1722502889731; Thu, 01 Aug 2024 02:01:29
 -0700 (PDT)
Date: Thu,  1 Aug 2024 10:01:11 +0100
In-Reply-To: <20240801090117.3841080-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801090117.3841080-1-tabba@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801090117.3841080-5-tabba@google.com>
Subject: [RFC PATCH v2 04/10] KVM: Add KVM capability to check if guest_memfd
 can be mapped by the host
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add the KVM capability KVM_CAP_GUEST_MEMFD_MAPPABLE, which is
true if mapping guest memory is supported by the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/uapi/linux/kvm.h | 3 ++-
 virt/kvm/kvm_main.c      | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d03842abae57..783d0c3f4cb1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -916,7 +916,8 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_FAULT_INFO 232
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
-#define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_GUEST_MEMFD_MAPPABLE 235
+#define KVM_CAP_VM_TYPES 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ec6255c7325e..485c39fc373c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5077,6 +5077,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
+#endif
+#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
+	case KVM_CAP_GUEST_MEMFD_MAPPABLE:
+		return !kvm || kvm_arch_has_private_mem(kvm);
 #endif
 	default:
 		break;
-- 
2.46.0.rc1.232.g9752f9e123-goog


