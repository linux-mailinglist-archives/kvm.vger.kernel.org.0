Return-Path: <kvm+bounces-61342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E89BFC16F97
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:27:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE8311C266D4
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F523596EA;
	Tue, 28 Oct 2025 21:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Il+8Y5gG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340EC358D02
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 21:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686475; cv=none; b=rsn43nKh9j96MU93ENh4qMQUpVo33t1SJ1nRNInRcfMyiKCXlwZkwJNcL1F8UNUQu5rlngO41x5BJ/ILxE1ddfppWoXNFvpQKwbsXVZctBE8eNqYHwroL/TzWJVeLN8Yp02wMe+wguW8baclihmQnBq3LMHJMebFIv+/AcWqFsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686475; c=relaxed/simple;
	bh=XHCbxfrzoGdDsdrcY2rTVu1R1r7Is2Kmr5rE68Lc/fc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L7Y7L23bpWwOh3c3UIbvUqyFgvgX8k84bv65T1FL/tsRrDs/Vp9vBAdHs3JN4tzbJPDh/5s1fhh9O88GP1wZ9hoEf+ERG37tNSO6iDR8TiX4kiS0T9LZ8RgPlFaRW0vQ5A/gjPT7zQzpNRXJAvrK7xp4j+GHiuMT875k8A9hg2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Il+8Y5gG; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-940f9efd090so2079357139f.3
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 14:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686472; x=1762291272; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t2hQEt8uzmZFMchmgXgqAe6OBZ69jvpk9KGj1/+J4M4=;
        b=Il+8Y5gG/63HMieFE4hhar35qiZkm375xu95AStbjxnRwj20fpdwMmbq2i+rTmhwf5
         yg8dMG3fCxj+wV4OvuJGF15mTnKHmNO48F7OFNp9y0BmMuRJI1Enhpn2kvdCpvg3vuFD
         xLRAXSSy6AogyiAE4f3cVt1OdJoKlPs8fhqv3fAjnsqTvvH7JBBiKKMYH98/N3nFDfdB
         ws0MsBpmZjJo3ZqlxL1QQAPTWL8lmZv/wsjoJSOzkKDv0TuTV0yxn+9aLI96FD5F9lwd
         3x3EWYD2AXUQ/kgsHjRBo3nF41Zotsb5p0NJPvFx3za2C09ncIOD7Xr1kA0yY9PclyYI
         OsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686472; x=1762291272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t2hQEt8uzmZFMchmgXgqAe6OBZ69jvpk9KGj1/+J4M4=;
        b=B6M00cuwJ2qzp1P/RHdH2MBu4asEwyUhmUwrjsFR9d4NvARcWJhOSi/9h8NICm6Tzd
         8r5je1ozRMagbSpEEei1UtgVS82Leqe7f92wZYLgkfe3sPOcPRw/+cIfmZRldVXfpc4x
         z5AOIoNEh4YUz3fweakbnJY7DKIqfd//rr33xSNAuBVu4Tpupr225WskGm0LJTBwcWeT
         mdghSTxCXwQs8wkpkopSpEFQ5gJU5O7j1/oYxgJaPx6ZZCnIsoXVSIUhW/gwGly2a0oZ
         bN6YOYJrdM2wHZh4m0ILY7PfWQtShsC0eZax/aRgzIVZjxKRZkutf1k2pZRRVu0L0kjI
         KJ+g==
X-Forwarded-Encrypted: i=1; AJvYcCXHzhcdO4uq6xdNWKXljqKJ0bBjZB7uHXsGgELQu5DbjFQ6psznNnYTVFTrns3AaWy5ib0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSJApT0WTb+ZtSJICwtVHR27nPqFrQZ5FCITV8N3VXoMBloMkL
	mWo93SWcDlZbqVUrqWL9aLmCgj1Lq23HweGrD8+qZvRnDLtdVUqKlcgoSeIY67Nag4aktPpKnIa
	cRQ==
X-Google-Smtp-Source: AGHT+IEOzmUxUr4Uek5ji2MKUZMUl92l7uF6agNUuaj4Psn+yNrqz6lfoiUMCy7WVJje2ATcgzv8NsTpag==
X-Received: from ios4.prod.google.com ([2002:a05:6602:7404:b0:945:a5b1:e0e6])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:621a:b0:93e:7d6d:e0d0
 with SMTP id ca18e2360f4ac-945c9764ec3mr137130539f.6.1761686472375; Tue, 28
 Oct 2025 14:21:12 -0700 (PDT)
Date: Tue, 28 Oct 2025 21:20:44 +0000
In-Reply-To: <20251028212052.200523-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212052.200523-19-sagis@google.com>
Subject: [PATCH v12 18/23] KVM: selftests: Set entry point for TDX guest code
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Since the rip register is inaccessible for TDX VMs, we need a different
way to set the guest entry point for TDX VMs. This is done by writing
the guest code address to a predefined location in the guest memory and
loading it into rip as part of the TDX boot code.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kvm/lib/x86/processor.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 036875fe140f..17f5a381fe43 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -691,9 +691,13 @@ void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
 {
 	struct kvm_regs regs;
 
-	vcpu_regs_get(vcpu, &regs);
-	regs.rip = (unsigned long) guest_code;
-	vcpu_regs_set(vcpu, &regs);
+	if (is_tdx_vm(vcpu->vm))
+		vm_tdx_set_vcpu_entry_point(vcpu, guest_code);
+	else {
+		vcpu_regs_get(vcpu, &regs);
+		regs.rip = (unsigned long) guest_code;
+		vcpu_regs_set(vcpu, &regs);
+	}
 }
 
 vm_vaddr_t kvm_allocate_vcpu_stack(struct kvm_vm *vm)
-- 
2.51.1.851.g4ebd6896fd-goog


