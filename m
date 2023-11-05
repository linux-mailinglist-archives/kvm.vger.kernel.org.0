Return-Path: <kvm+bounces-612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C13B7E14F8
	for <lists+kvm@lfdr.de>; Sun,  5 Nov 2023 17:36:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D6E8B20E23
	for <lists+kvm@lfdr.de>; Sun,  5 Nov 2023 16:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6CF1D55E;
	Sun,  5 Nov 2023 16:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JG+fKf22"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29A01C6A3
	for <kvm@vger.kernel.org>; Sun,  5 Nov 2023 16:33:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EED6D75
	for <kvm@vger.kernel.org>; Sun,  5 Nov 2023 08:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699202003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qfeiaA9Zm3lDYCkoTrnfofIiBFTO8MQOwDWpndcpgFA=;
	b=JG+fKf22/nhvycaEaRMymhcSGxFBqKxJBvx+n5Xx/HLhP2uiQrQO9AUdIIKWXuSFKB6Us+
	rNotmPDAPIVSqBnSPYpn+S3L+UDkncNpE3Plh4MhaiJ+e/eoxiln0Ibqc6ynr205i8WpAr
	w0Ka7MaasF7/ruZhsFKstXK65UxzM4k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-2hs99GbVMSuoqusTkGwtCA-1; Sun, 05 Nov 2023 11:33:20 -0500
X-MC-Unique: 2hs99GbVMSuoqusTkGwtCA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD00180B642;
	Sun,  5 Nov 2023 16:33:18 +0000 (UTC)
Received: from avogadro.redhat.com (unknown [10.39.192.93])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 387F52166B26;
	Sun,  5 Nov 2023 16:33:10 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Sean Christopherson <seanjc@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Anish Moorthy <amoorthy@google.com>,
	David Matlack <dmatlack@google.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Maciej Szmigiero <mail@maciej.szmigiero.name>,
	David Hildenbrand <david@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Michael Roth <michael.roth@amd.com>,
	Wang <wei.w.wang@intel.com>,
	Liam Merwick <liam.merwick@oracle.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 19/34] KVM: Drop superfluous __KVM_VCPU_MULTIPLE_ADDRESS_SPACE macro
Date: Sun,  5 Nov 2023 17:30:22 +0100
Message-ID: <20231105163040.14904-20-pbonzini@redhat.com>
In-Reply-To: <20231105163040.14904-1-pbonzini@redhat.com>
References: <20231105163040.14904-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Sean Christopherson <seanjc@google.com>

Drop __KVM_VCPU_MULTIPLE_ADDRESS_SPACE and instead check the value of
KVM_ADDRESS_SPACE_NUM.

No functional change intended.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Message-Id: <20231027182217.3615211-22-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 include/linux/kvm_host.h        | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fa0d42202405..061eec231299 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2136,7 +2136,6 @@ enum {
 #define HF_SMM_MASK		(1 << 1)
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
 
-# define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
 # define KVM_ADDRESS_SPACE_NUM 2
 # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 67dfd4d79529..db423ea9e3a4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -690,7 +690,7 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm);
 #define KVM_MEM_SLOTS_NUM SHRT_MAX
 #define KVM_USER_MEM_SLOTS (KVM_MEM_SLOTS_NUM - KVM_INTERNAL_MEM_SLOTS)
 
-#ifndef __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
+#if KVM_ADDRESS_SPACE_NUM == 1
 static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 {
 	return 0;
-- 
2.39.1



