Return-Path: <kvm+bounces-64251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F2BC7BAE1
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 21:51:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E25033615CB
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA236306487;
	Fri, 21 Nov 2025 20:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mwxqhy/J"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00241302748
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 20:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763758115; cv=none; b=TR0kR1Yx0kvpeMWswZVXO8a9MwAZYyyPD4cKMK83tsLO1WsWucAnbAthhXl3r5c9nL+bFi7WrXVun9D99NH9k3x47eHwDUF9mFNcxjllqpSTayb0uGnrUYgW8t3yfhBUE/qhjQqxeG8lLcwquPxFm1S4JR8bhlIYK+Aewq7m+HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763758115; c=relaxed/simple;
	bh=E/pbZsTNV6EVLhqEcJiIuP7sCTobRfFdyjCdk23ENsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffudKV/8PhGEW+xJRLPU3bMWHY2jqC0BlAX8ZYmgxF1hEAviMFhNaiNPebTlPt+zYSL+6qXpEMzkuqAoYJFTHeCPstto/CYUCvOv8zUNRmBAMhV95rl1BMo69Kn3F5rEoUd5Q/eLCysjkIIzsB4yQ+Etbcc2URj1eD7I0m1V44w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mwxqhy/J; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763758112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NR1mAOfD6GGa4N4aOKbQBGg1YiLNhhyOF6jSLT9XhW4=;
	b=mwxqhy/J61ry8TwgHWNDaa75iZSuL/ksmRUUBWTRe+M8BcmCuL8QxrCTPKbJN/olO4e2N9
	hosUxiVkSfJhoHTNsgh2aOpMdl3H92ZChh5MmubZpALjsMZVjp+A/p7gcOHcQ7843dRFaz
	etrAKlsvpeh2IpthzuwtOaMGPGjIV30=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 3/4] KVM: selftests: Use TEST_ASSERT_EQ() in test_vmx_nested_state()
Date: Fri, 21 Nov 2025 20:48:02 +0000
Message-ID: <20251121204803.991707-4-yosry.ahmed@linux.dev>
In-Reply-To: <20251121204803.991707-1-yosry.ahmed@linux.dev>
References: <20251121204803.991707-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The assert messages do not add much value, so use TEST_ASSERT_EQ(),
which also nicely displays the addresses in hex. While at it, also
assert the values of state->flags.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
index 67a62a5a8895..b59a8a17084d 100644
--- a/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_set_nested_state_test.c
@@ -241,8 +241,10 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
 	TEST_ASSERT(state->size >= sizeof(*state) && state->size <= state_sz,
 		    "Size must be between %ld and %d.  The size returned was %d.",
 		    sizeof(*state), state_sz, state->size);
-	TEST_ASSERT(state->hdr.vmx.vmxon_pa == -1ull, "vmxon_pa must be -1ull.");
-	TEST_ASSERT(state->hdr.vmx.vmcs12_pa == -1ull, "vmcs_pa must be -1ull.");
+
+	TEST_ASSERT_EQ(state->hdr.vmx.vmxon_pa, -1ull);
+	TEST_ASSERT_EQ(state->hdr.vmx.vmcs12_pa, -1ull);
+	TEST_ASSERT_EQ(state->flags, 0);
 
 	free(state);
 }
-- 
2.52.0.rc2.455.g230fcf2819-goog


