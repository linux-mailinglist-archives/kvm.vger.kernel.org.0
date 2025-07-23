Return-Path: <kvm+bounces-53202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 433E1B0F03A
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 12:47:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D427583E97
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:47:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18A3E2D8DCA;
	Wed, 23 Jul 2025 10:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uoq9HD78"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D52928DB7F
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 10:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267642; cv=none; b=ns5wCq4/XEOwdpQRQi9cJfFTy6XaSFmBv7uOTnRGZWG6QHuSE8j6aQYQVFp9D8H9gerzuG4EfBYftVbwxtmUvi2O0WycMb/H8juVeyRCcWS8rK1klP6XFvExGytooPdoVD7w7LCmRCnO69rgokuUczxcznlAp/ZAmkL9m/xkOHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267642; c=relaxed/simple;
	bh=EH1IJuXG8Ao7tj1busmw6p1cNiHU5gyF41SXMJEr5/k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TbPKJN03sanZPz6XSdQiV/lfmXSjJcuRIQC3+/aJF/aBg44WWA/aw759BTOQVd2awb0t00FMiMt/fu32p1qop9ytv78v9FbvlAolmGdLu+PyRfikGjhwJKWJDc0DG+P53kbj+T2fCqvoFaDKSTuRzydAApIxVThpiUB91QxfNHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uoq9HD78; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4eee2398bso2771745f8f.1
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 03:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267638; x=1753872438; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tzfZi60oZ9UO8raD765xxT1ZFhO1WsdtivBMYCkRGQ0=;
        b=Uoq9HD78OmeqsTTJO+8CBMdpzziyftBq86BrI18slcN9pdMqrqv1muZgaF9jhHe8S+
         jSgqIrIbhJVxgOXgNjI4Rid28AMziDj5fHOyNBewU7nzFQJZaFSSypL4Js1nCokPwgob
         pYLkawYnb+RC3m+5PyIa6ssyr0vUIW07dzZvtY8oofzhyIsNZ5I0ZdGX2rerFs3dtRoO
         LLaUDeljfczXV2KPabRu7v2/Szi4WJH9S6HJUcin3tphT98IrGT8cyXb3dbyZRnX5FIz
         0Nlz8P3EoaPtTQ0MASl/20THIZ+5CGdBtvyCv7/SeKZDBdvzx5O7rLH6LPKfhoTOr4I9
         yJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267638; x=1753872438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tzfZi60oZ9UO8raD765xxT1ZFhO1WsdtivBMYCkRGQ0=;
        b=ou4r1NXyamyIgQFzz/MJ0qJ7iXwdD0l7PoPl3Z8anSjPfuB4LB88RUgRRpNFYlDAlC
         /cNWRcKlW8XdeQ3spQ6xLPHnCo8TNeEePiz7yBeETxqx/GI5LVj+I3SoYDtRIomQO3y0
         76MszTnz/eFaEu03eiqmhtkY8R6ktqjh8dXDf5zWVp7KxHTQKrdeizVzwWOSjPt28YiK
         OXI9m0ei/n/8eSR97rbCQNTq5cCDYjab9emg/NqFx3i5G101GtZw+EYGa1qnri6A7DBA
         iEsjMYoKf3GyhPzOiJcpKME9PhsxmkKE8XVLh1yCz7+z7rjEZ/8ha4+A/Sb8a/ESdykA
         ZKsA==
X-Gm-Message-State: AOJu0Yzbs1IJZS1CfMdsqlBLX3yIgHGiPJayN8WbCY1FkJgYny8eotdi
	dfU1oE7TwoqVRB3OYI46+8gLH4z/aw60ZYZAPK6JZb/hNhliGp9Hd7HqJDNqkEXEWeSdZ4LKm8f
	W5E2X+QNlB/pMe696Tme4E1dgy86NYgItOK/jRDcqHH18LX8ricKMFMC014z2+WwqHD6e/WHsDP
	A2//uJOO6/RiEvpSlQmbX3MxHvijg=
X-Google-Smtp-Source: AGHT+IEo+s/VxPokXQ2vXolGdtsGLlmgFDoyNvmXKyvht3UuZi1/vOjCI4q8w/CILxGvMZbP18VFTQSgFQ==
X-Received: from wmbhc10.prod.google.com ([2002:a05:600c:870a:b0:453:6ee6:e62a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:26c9:b0:3a4:e393:11e2
 with SMTP id ffacd0b85a97d-3b768ef9646mr2055449f8f.34.1753267637872; Wed, 23
 Jul 2025 03:47:17 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:55 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-4-tabba@google.com>
Subject: [PATCH v16 03/22] KVM: x86: Select KVM_GENERIC_PRIVATE_MEM directly
 from KVM_SW_PROTECTED_VM
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Now that KVM_SW_PROTECTED_VM doesn't have a hidden dependency on KVM_X86,
select KVM_GENERIC_PRIVATE_MEM from within KVM_SW_PROTECTED_VM instead of
conditionally selecting it from KVM_X86.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 9895fc3cd901..402ba00fdf45 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -46,7 +46,6 @@ config KVM_X86
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_PRE_FAULT_MEMORY
-	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
 
 config KVM
@@ -84,6 +83,7 @@ config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
 	depends on KVM_X86 && X86_64
+	select KVM_GENERIC_PRIVATE_MEM
 	help
 	  Enable support for KVM software-protected VMs.  Currently, software-
 	  protected VMs are purely a development and testing vehicle for
-- 
2.50.1.470.g6ba607880d-goog


