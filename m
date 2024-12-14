Return-Path: <kvm+bounces-33804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FDFA9F1BC4
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE06F188E799
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E399F194A43;
	Sat, 14 Dec 2024 01:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="huFZsV8i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75B71922DC
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138467; cv=none; b=CSBmUJSSFE1Oskual1VtuxFEo2BKXmuiXS42l/SNAkfwe7u85AH/GULzxajwFa/o9e1fSGlcIuF87v2J/WTih0oSjEIEuirleS9l/hLOG+NgZXfndubJEmTw2d3aMu6s4+GvpROpUN+HmcJRl0DfBc3Eiu8WMUhpeFcxx9UEFMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138467; c=relaxed/simple;
	bh=QVWmEN93U4wXoW46HSHclbwWmnJqdA1R3pFC8wdRuNY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oH7x0BCSoij4ImKsnQkv+KdU6BD/T4j3rkfn+6tXNiA5i4ouVAw8z9OkijNtC4AaLUH/9UwREHCKMktsZ+RvB7n/YlKLdB5QRprfDvvLrDImoX8RFyyR2SSNptBbOIJOeewyTHkJxunTkpoTU8cy77NuupqjB24z+gXf2c8mhno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=huFZsV8i; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-725e4bee252so1931133b3a.1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138465; x=1734743265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bHCBDGsUVxz6SdxgZL4telXbGroEPmY7oNy/cAKGEh8=;
        b=huFZsV8ix67y/CtSdBH9UwyPXgzRjw9UA3PvnFvoXjHrzhuc8dFo4pgJIFpJ+jb1O1
         YwdjYTuaYk2b5Zvmg3gQNlTrSjnyfslGRMbNDjesouGEKw0jKDpjfYAmGaKxpux9TTUa
         f/JrBnYADH/mtRGMsBdVcV51gvk9+2ruPl9IoMHMZkwZDq+iy5WKPX4SzPg7mCN59F8V
         j1Xxpafi3uHfdADD35rhHpcTg053zf8PTZEwefBH8FnJkeceXlQ+hn0FsQ3eMaZTDCil
         /j/uA6shixfj/Ve6lGqMYuJVE/fO0xNOFlgoin3xHHshqJlK4DV2I+gKcSvOZ21v7FBs
         iprA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138465; x=1734743265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bHCBDGsUVxz6SdxgZL4telXbGroEPmY7oNy/cAKGEh8=;
        b=qR1iqvDz8+JRIJBySpKLd1sYG+doE6iXMuxUG35GuJN3Au5Ai9PDtdLmPNvqtORN8c
         Jq4VEtjzxApetYQp1iVaMHZWAZW89jZ0uRP+HPIfom1Rx6Vi4pV/ygEXB/vv3vtQ0Abd
         DO6bXrZCy/yREqc8QOhThMDuJSYmfcebbkr5lKTyWNhf/0jVEetaMLiI/vTHhqfybv76
         KdQm/BX3uIuaQ+1EaoNlNNtj7I52ELWNWcetEhZSKyzm5LnYSau0SwMVZ78toCXhT+vT
         eXlt3XeMO2esydceI14bnn3JSj00LqUiLcXOT+DChALh95Y7H8oqePayjcwMgL91LRVe
         1IRg==
X-Gm-Message-State: AOJu0YzpwyksJhiOiLseTsjD2MA3F4stden4+CJZa5gg79EMg/08ejSy
	bBJoBiVDW+9USusrHtQjmlThuoGWgCAfwXXSG8v1yjrqQcZLdDSBlFivTwRmCsNSJwMy67ffVXB
	V/g==
X-Google-Smtp-Source: AGHT+IHI7aNGyUVYAZRaIfM3tqmWl5rQShpzYJGmkFTVL8PahcKsfjqTBmmhSQLHOzhneJg36ly7uAtGOuQ=
X-Received: from pfvf8.prod.google.com ([2002:a05:6a00:1ac8:b0:725:d24b:1b95])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1483:b0:728:e906:e45a
 with SMTP id d2e1a72fcca58-7290c269159mr7557525b3a.24.1734138465060; Fri, 13
 Dec 2024 17:07:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:13 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-13-seanjc@google.com>
Subject: [PATCH 12/20] KVM: selftests: Use continue to handle all "pass"
 scenarios in dirty_log_test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

When verifying pages in dirty_log_test, immediately continue on all "pass"
scenarios to make the logic consistent in how it handles pass vs. fail.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 8544e8425f9c..d7cf1840bd80 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -510,8 +510,6 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 		}
 
 		if (__test_and_clear_bit_le(page, bmap)) {
-			bool matched;
-
 			nr_dirty_pages++;
 
 			/*
@@ -519,9 +517,10 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 			 * the corresponding page should be either the
 			 * previous iteration number or the current one.
 			 */
-			matched = (val == iteration || val == iteration - 1);
+			if (val == iteration || val == iteration - 1)
+				continue;
 
-			if (host_log_mode == LOG_MODE_DIRTY_RING && !matched) {
+			if (host_log_mode == LOG_MODE_DIRTY_RING) {
 				if (val == iteration - 2 && min_iter <= iteration - 2) {
 					/*
 					 * Short answer: this case is special
@@ -567,10 +566,8 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 				}
 			}
 
-			TEST_ASSERT(matched,
-				    "Set page %"PRIu64" value %"PRIu64
-				    " incorrect (iteration=%"PRIu64")",
-				    page, val, iteration);
+			TEST_FAIL("Dirty page %lu value (%lu) != iteration (%lu)",
+				  page, val, iteration);
 		} else {
 			nr_clean_pages++;
 			/*
-- 
2.47.1.613.gc27f4b7a9f-goog


