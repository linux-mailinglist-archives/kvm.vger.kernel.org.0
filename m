Return-Path: <kvm+bounces-61597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DD16C22938
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 23:38:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D9413BC468
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 22:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F7DB33BBAE;
	Thu, 30 Oct 2025 22:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TCHxYuhi"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D092C2364
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 22:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761863899; cv=none; b=Y8lscC8HbDl3c1/rc4Cb8TGqVLMCbcqkvo0CljpZCq2Zcgxv+6EX2Osfix5/I1QQ2oC6fZKJpsKGahdij/QOBRqT0R5CI9r7lhX+WUYDpE89JVmsco1SN3g8p3OTI+ScyPRMHTPWhmOOhXWZFSSQXDmxiXgONDLabD5kHkL3KDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761863899; c=relaxed/simple;
	bh=AaD9nqbLaXNbzziZgK8B2iZNJop3x8YFb6YqPU5vNLg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oJa/oxOCcwPNc2aNZI4LBcPcqIQ5+pQYyFtJHH7hyZOd3Nu56qhRwf5pY5Z0leEhZFYwLtNZCarOIgTtRq17VIdp9I4H+ZDtBdiLkXjWdQaJl41H65JOUKdyDRhyGLCcvT6Vt6MIS8GI8XHItESO/L9QPiIS+WK3LJQQtTyQbMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TCHxYuhi; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761863894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=x//1g4ObsvwNdnZ7oPnh7yw9PKf2pZft0QXuT3ZxLjw=;
	b=TCHxYuhiolT6ziBu/NUdfA+tpTwxAeVqtFau/JXWJG6+0YO2e3n3/WPumgVPujP15HiUMj
	HnM/bXQzpDv0K8EBcq8DlkQui6LtrDfI0i7ShH5ZOjq+sEVHnanNlkSQMJt9LhB/PykJ3B
	ggRy3/nrLLpJVMc62E6EEfbdRFyYRh4=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH] KVM: x86: Document a virtualization gap for GIF on AMD CPUs
Date: Thu, 30 Oct 2025 22:37:57 +0000
Message-ID: <20251030223757.2950309-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

According to the APM Volume #2, Section 15.17, Table 15-10 (24593—Rev.
3.42—March 2024), When "GIF==0", an "Debug exception or trap, due to
breakpoint register match" should be "Ignored and discarded".

KVM lacks any handling of this. Even when vGIF is enabled and vGIF==0,
the CPU does not ignore #DBs and relies on the VMM to do so.

Handling this is possible, but the complexity is unjustified given the
rarity of using HW breakpoints when GIF==0 (e.g. near VMRUN). KVM would
need to intercept the #DB, temporarily disable the breakpoint,
singe-step over the instruction (probably reusing NMI singe-stepping),
and re-enable the breakpoint.

Instead, document this as an erratum.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 Documentation/virt/kvm/x86/errata.rst | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/errata.rst b/Documentation/virt/kvm/x86/errata.rst
index 37c79362a48fa..a9cf0e004651a 100644
--- a/Documentation/virt/kvm/x86/errata.rst
+++ b/Documentation/virt/kvm/x86/errata.rst
@@ -48,7 +48,14 @@ versus "has_error_code", i.e. KVM's ABI follows AMD behavior.
 Nested virtualization features
 ------------------------------
 
-TBD
+On AMD CPUs, when GIF is cleared, #DB exceptions or traps due to a breakpoint
+register match are ignored and discarded by the CPU. The CPU relies on the VMM
+to fully virtualize this behavior, even when vGIF is enabled for the guest
+(i.e. vGIF=0 does not cause the CPU to drop #DBs when the guest is running).
+KVM does not virtualize this behavior as the complexity is unjustified given
+the rarity of the use case. One way to handle this would be for KVM to
+intercept the #DB, temporarily disable the breakpoint, single-step over the
+instruction, then re-enable the breakpoint.
 
 x2APIC
 ------
-- 
2.51.1.930.gacf6e81ea2-goog


