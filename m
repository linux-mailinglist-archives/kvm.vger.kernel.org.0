Return-Path: <kvm+bounces-27877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E899998FAD1
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 01:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91349B22E16
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 23:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4CB41D0F44;
	Thu,  3 Oct 2024 23:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j/DfmBlF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC221D0B91
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 23:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727999024; cv=none; b=Y1UMgduWfI0Z/Mzev+Q/8zW06HufUYjmcYPJ+KMwI1De3vysxj2sRrz6/H+dkqHCP5d1wV6uA3AXrUusiTDJ2vzH72+I7XkVFrWs9vcY1tm11FB7hRa8BUeGp4HrzM9P/ZBAMQwFR+mldJNZo6wuKeka9bSVZT96dQbK706JI6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727999024; c=relaxed/simple;
	bh=dCT8bXCAqzzFJVCOs7D2QLba2AuX/LxeOumRe2jwP14=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cfNusvtWESDnNzpvUSAdvkkztqRB9EngwmnCqekd38SIu7cU/bNqWnqIQ1YcqzjnQbV04tHVs+cML8itdXsLSM2fiw9/A9BVDOUnrqg6atBXGmROJutZve1h3jgVX6OOmSgo9MWdUuWaTeBrED9Jn3M5P1lAYE0g6lgHZqbOnKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j/DfmBlF; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20b0c92182fso14251535ad.1
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 16:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727999023; x=1728603823; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6V2q4amWCHB6J/4atN9JkqFjKadmMrC6jiYsYmH9GeA=;
        b=j/DfmBlF0XueeTAUmTobLtoKu+JuPt3/lsv58+IYI2kNwnKRXj85Qmei653K0dtRNf
         colbLIEw0mms1FjK9K/MxrF8oeaHfmvxzUWqwNdJsJLyu0Poff5pgEy6RU5cp/LfKwbi
         qQqDqGIdRmLWlB3OmywPAvK1bYQ0ceKcbI+YwL7iXgrkUGfdps7nCQOcygJw17KNqHnm
         zytZ1H6lhiR4zd7F+Y0WJLorGOjAnX/YQ5ZurmyDC2swCdQAiK++iOuIA5I13ZoKi9Sc
         3GiCpmN0aelB2i4OvVb3Gde2mKCsLejr9dYySL+cpe2OdOYs1sAtkJp4Pm7QHrjwirak
         BbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727999023; x=1728603823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6V2q4amWCHB6J/4atN9JkqFjKadmMrC6jiYsYmH9GeA=;
        b=m0ziQMygk9hUL8Yewtw6+HVlnPIAAAYTMIxNQzXDLRiqSSJ8t6OHDfF6xfEzbySThF
         uUg9A/eWFxyk9N5/0piRtddm70EW6g17B9nTAsZBpE1fCs9ta7Qdt8UrdC2g5zl9VdBT
         zzJEhGCM6u3KivJOKRp5EcHHqhoyj11e5DYetwinnce3Z7RNx+6OvtQ4FMQXs2aiL3Sq
         6hWkNHeDduvv2idMSD+oSdyRKcWECRIxhbWkMVLCbwSSSRIr9wiqQunX6Gr8U7YkBCRl
         8PhQ/4YM3m18ftj8mWLghHX3/9veX/XAk1NyCqctu3qPzngHq145gTrmF7KsAm6xnNLd
         FPag==
X-Gm-Message-State: AOJu0Yzc4rdnTDP7VCb8rhRUBbBmjV9iBPBlt1GCzf+71b54/VSx97Hz
	iPNTxRLLibZFLx8NFV8YF3FyspSEW2ClqR/dGzgpH2og+fTF7oE97RlR4OFn174k3+MqihcA74F
	5VQ==
X-Google-Smtp-Source: AGHT+IFaPFq1x4myrDRmgES6KGTmO/IX8Xo50bZDsQhg0x5tM5p7famkM2K8G8qgEWxTrXonLa0y6KUkJmc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e80c:b0:20b:9df1:54a3 with SMTP id
 d9443c01a7336-20bff1dfc9fmr8035ad.8.1727999022648; Thu, 03 Oct 2024 16:43:42
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  3 Oct 2024 16:43:27 -0700
In-Reply-To: <20241003234337.273364-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003234337.273364-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241003234337.273364-2-seanjc@google.com>
Subject: [PATCH 01/11] KVM: selftests: Fix out-of-bounds reads in CPUID test's
 array lookups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When looking for a "mangled", i.e. dynamic, CPUID entry, terminate the
walk based on the number of array _entries_, not the size in bytes of
the array.  Iterating based on the total size of the array can result in
false passes, e.g. if the random data beyond the array happens to match
a CPUID entry's function and index.

Fixes: fb18d053b7f8 ("selftest: kvm: x86: test KVM_GET_CPUID2 and guest visible CPUIDs against KVM_GET_SUPPORTED_CPUID")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/cpuid_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 8c579ce714e9..fec03b11b059 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -60,7 +60,7 @@ static bool is_cpuid_mangled(const struct kvm_cpuid_entry2 *entrie)
 {
 	int i;
 
-	for (i = 0; i < sizeof(mangled_cpuids); i++) {
+	for (i = 0; i < ARRAY_SIZE(mangled_cpuids); i++) {
 		if (mangled_cpuids[i].function == entrie->function &&
 		    mangled_cpuids[i].index == entrie->index)
 			return true;
-- 
2.47.0.rc0.187.ge670bccf7e-goog


