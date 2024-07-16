Return-Path: <kvm+bounces-21726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9768932C7C
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 17:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A39832853A6
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 15:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B41E619E81D;
	Tue, 16 Jul 2024 15:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F4i9A1D5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8046C19E7F7
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 15:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145323; cv=none; b=fHc3uHwUWrxRxv/AKGlEb3fjv1vezPa5BGhJMct/719JsZRjs4SARMsyVHEZRS4YUhCzsV/xSefKU74tj+9z6Z/yrWBxIOgq1FjUVXfN6DduMq2own03pVUkTbt61zoXjVCHxtdVISZD2mKxJoQHd5JLL2mM3h0jhYSfan+IEVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145323; c=relaxed/simple;
	bh=tdtgldsaF/+mVcySq07MM+0QKRZwCNCIky3jLeqq+yU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nrz7nDd3ngiHI+L0/LNl1RKGds2WsYNKpOFYzBjc9DH8czKai2W907u6P/YaXmFRdE98/htb7OqjdpNLZTkGj73Xz6cVC1zLRprSMheERtcwn91gQ/dLwQXzjrRzhCdB7SZfy9X23VQ2o7SHh5iLactG2nDReI0EEt7AUI6f+5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F4i9A1D5; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721145323; x=1752681323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tdtgldsaF/+mVcySq07MM+0QKRZwCNCIky3jLeqq+yU=;
  b=F4i9A1D5zlc/TRFdpNTnSmy9zmXrG1JZ5E8iTiteotWrbo6y8LZ0fyXF
   PDBwOoavY2uvrOR4xtZygLQZXXmDUodDhbuBn1L84BR2MvmabA2sp/gRW
   LEKFtVSIBLLTEsHys4D6EKkwdWMW2crvBNcVwc35Z4sdU05Uza0+N1iYK
   4xH9rk1gioXHu9tR12DcOe8riW7b3inozpOtRvC6YD0nUvZbJ1XCX5kbf
   aDaHRo88kOIkp9VsDmQOLi18U8mDAuXRh0DjMjsR6ox2niaych3NnFOzO
   kifvZTT+nzuJI3Xy3QGSAzfrqAsmWQqn1OSZxtvYmS04qV7zI5y3YWJ9E
   g==;
X-CSE-ConnectionGUID: spqkkoy2Rfy1i92HuBJ0fQ==
X-CSE-MsgGUID: E82Rq7hIRP2jg4eRE95LUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18743840"
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="18743840"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 08:55:22 -0700
X-CSE-ConnectionGUID: VMJ6NDNcQHG83f2ZFWlZ7Q==
X-CSE-MsgGUID: 6r8tifxbTPWlPASAB/PxKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,212,1716274800"; 
   d="scan'208";a="50788551"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 16 Jul 2024 08:55:10 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 9/9] target/i386/kvm: Replace ARRAY_SIZE(msr_handlers) with KVM_MSR_FILTER_MAX_RANGES
Date: Wed, 17 Jul 2024 00:10:15 +0800
Message-Id: <20240716161015.263031-10-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240716161015.263031-1-zhao1.liu@intel.com>
References: <20240716161015.263031-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_install_msr_filters() uses KVM_MSR_FILTER_MAX_RANGES as the bound
when traversing msr_handlers[], while other places still compute the
size by ARRAY_SIZE(msr_handlers).

In fact, msr_handlers[] is an array with the fixed size
KVM_MSR_FILTER_MAX_RANGES, so there is no difference between the two
ways.

For the code consistency and to avoid additional computational overhead,
use KVM_MSR_FILTER_MAX_RANGES instead of ARRAY_SIZE(msr_handlers).

Suggested-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
v4: new commit.
---
 target/i386/kvm/kvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index d47476e96813..43b2ea63d584 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5314,7 +5314,7 @@ int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
 {
     int i, ret;
 
-    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
+    for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
         if (!msr_handlers[i].msr) {
             msr_handlers[i] = (KVMMSRHandlers) {
                 .msr = msr,
@@ -5340,7 +5340,7 @@ static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
     int i;
     bool r;
 
-    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
+    for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
         KVMMSRHandlers *handler = &msr_handlers[i];
         if (run->msr.index == handler->msr) {
             if (handler->rdmsr) {
@@ -5360,7 +5360,7 @@ static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
     int i;
     bool r;
 
-    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
+    for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
         KVMMSRHandlers *handler = &msr_handlers[i];
         if (run->msr.index == handler->msr) {
             if (handler->wrmsr) {
-- 
2.34.1


