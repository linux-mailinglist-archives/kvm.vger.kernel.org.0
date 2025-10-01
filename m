Return-Path: <kvm+bounces-59302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BCDECBB0E9B
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:02:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDBE62A7E84
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E30C307AD8;
	Wed,  1 Oct 2025 14:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fl1Vne7R"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36705304BC7
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 14:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759330724; cv=none; b=hZU3K63jcAgucsDYsEa6w1ynJMHp6DvYZzQATSEscjloY/k0jL5Crh5XpYUeTkTa1Uh2DTpQhfsSVZHplACUBw7RucNj8U5Fg8xePqtIDbExAHcqVxIjqdxRYmdouecNuZhGTAuiGbUr0c6IWtH96KOkEZqu3tfpYVQMePevP5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759330724; c=relaxed/simple;
	bh=imkiUoz4g7AHZ4k9B6g4aWyy2WAIjiLuKFQB7Ec6R+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gE0ukE9NLH+15SnrljIAuJ9GLwy9WuyhNFIz6SKyU+/Oy0T7AcE9XJguJVqfrOZdiHE9BxV32uFBmsogeHRRxOIiXqwFtYkfKVMS4I8g/V89LjYFTnILBBylpdMJL4Yss/21bOGLNOSCPAe3dq/P98nrc2Nxley3ZjKLM4azyH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fl1Vne7R; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759330719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZiG7uEL/pYERdGHD4GxrFZAThJNX66jF2OETI45KlPk=;
	b=Fl1Vne7RufEndIrp4NkcLeBvYi4kY9q4ac36GwxzPmG2t8xTJlm8ERzRxPv/0fW4VNhSbF
	9+r/8C6Au7CgzOecVy49ryT+90ER7TsEnqR8KwjnW5EBUyX3D9sVeVBjW7nnEv8LnB7xmx
	qIWey+M/xudePDn6g0moJhffgNudiSM=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 01/12] KVM: selftests: Minor improvements to asserts in test_vmx_nested_state()
Date: Wed,  1 Oct 2025 14:58:05 +0000
Message-ID: <20251001145816.1414855-2-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Yosry Ahmed <yosryahmed@google.com>

Display the address as hex if the asserts for the vmxon_pa and vmcs12_pa
fail, and assert that the flags are 0 as expected.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 .../selftests/kvm/x86/vmx_set_nested_state_test.c      | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
index 67a62a5a88951..c4c400d2824c1 100644
--- a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
@@ -241,8 +241,14 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
 	TEST_ASSERT(state->size >= sizeof(*state) && state->size <= state_sz,
 		    "Size must be between %ld and %d.  The size returned was %d.",
 		    sizeof(*state), state_sz, state->size);
-	TEST_ASSERT(state->hdr.vmx.vmxon_pa == -1ull, "vmxon_pa must be -1ull.");
-	TEST_ASSERT(state->hdr.vmx.vmcs12_pa == -1ull, "vmcs_pa must be -1ull.");
+	TEST_ASSERT(state->hdr.vmx.vmxon_pa == -1ull,
+		    "vmxon_pa must be 0x%llx, but was 0x%llx",
+		    -1ull, state->hdr.vmx.vmxon_pa);
+	TEST_ASSERT(state->hdr.vmx.vmcs12_pa == -1ull,
+		    "vmcs12_pa must be 0x%llx, but was 0x%llx",
+		    -1llu, state->hdr.vmx.vmcs12_pa);
+	TEST_ASSERT(state->flags == 0,
+		    "Flags must be equal to 0, but was 0x%hx", state->flags);
 
 	free(state);
 }
-- 
2.51.0.618.g983fd99d29-goog


