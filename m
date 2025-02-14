Return-Path: <kvm+bounces-38179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D19AFA362B5
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 17:07:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C1C47A3925
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 16:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7642676ED;
	Fri, 14 Feb 2025 16:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z4hD2UeC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCF42676CD
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739549204; cv=none; b=bUYXA548ONVdBiX7bb8nMjL/hOGknf+3gH4fzAAgCPLZZktRELvkuoP1uwCIpNDB7mQLKvN/jy3O9fDw0ATy5/mdPYO9JhYBZHd7unOuSinNF81JF9lrDg/gnRulP45CExtTkyQTy8AOGOTdRH/hukyTk5uyik0eHfFARaxVPe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739549204; c=relaxed/simple;
	bh=gNf68b2lO7aZBsZq1rdz+TjDp5DSF6RsXJMMuo+sK2Q=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Cp7ErlRO9rQZ9Y9AwH9mlCpXve2Yo2C+5PoLdSD53D82FODeBnxSi68WwhZATQgHEN7RQ1OEw753eusaMPpF2JWq9hjyWeGBXyRDqgI+rj3cl61E5ajO8LtcnRQ1llWX51VIR0EoNnp5IgEzZxBvnO7jXL4JOyL9dX2JJPDi4zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z4hD2UeC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f83e54432dso7351573a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 08:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739549202; x=1740154002; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gVmYHvwcYpnrtIiPiSYgCQmN9Gobg80dgdoYY0XghFE=;
        b=z4hD2UeCS1diXJNyGNdYHU93yJE79AsvaGKjciPBGnaTyU5Ba+CWC8qex2oAn1LxWd
         DvleqUDEJ1l0VGbldMgKk3FPxDACne642qeKt00k/XqqUIDpQ21K6NAhl92kiFFPGBx7
         el/g5sytSi1ilNycV0jL3FgQHRaFz2gEf0UYq+lOJKCLuBE7I03lPBulNjs7uwXw8siK
         dWQYLH6cePUQlZM6CKp28jSf7QmeTzlKQok1s8Buz+4c4wOkGYbmevIjEpZEmPlggnyE
         7l1iTtqUJJzbqT5Wsc4AAjDB9WOni90FjeljwQ2mU1/RD96lUhyH+i87uc+B6ZqYUVkB
         SA1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739549202; x=1740154002;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gVmYHvwcYpnrtIiPiSYgCQmN9Gobg80dgdoYY0XghFE=;
        b=MFXHg+uD3MoqSo34ghZ9+jz5xXdq3UKau7ngpr840+p/BC1haYfgOYBazHEXqY9I7T
         pWMmpTgc76qwBc+SuD7dYxjfSAywCHmKiFVhf2fyY18pWhln/eEiSCD/wVxAN0U8BpQB
         qak8mZJVZjxzkdf/zrYcVH1r7lhJUqA6r4C/IwGEo2cjjpeMD6DCaDMFORLT80zvdXKe
         bTQg2JX/8vTGeEcVmBFAmK8nbKHd8Gr5V9RuxRvLGvG4UWPA4fTtcoH+8DmYmKkW3drn
         YexlvvxwUv7M5qqoOMgQ8n7cLVj7UP11e8OwKASc85eOJpLADiycVH0JAQ95wQFC1TF+
         gBkQ==
X-Gm-Message-State: AOJu0YyIXAlR5JfL/aPEG+9FTOvc2iJRaLTKIjP0uhkkdXWGn77ozBHr
	9RhIlpMt/Mx2VYSb/CPezMdrQb74Ml4+111Ppw+ZChP7GgOstn7KBDYDqMB8FHUlFo0+CGlPEcj
	o+w==
X-Google-Smtp-Source: AGHT+IHAZtWLxQztW7anY6+QmYXHxsw0aHFKfiBgzGOByFQM5kV8YxD0W8q1BO+lVI/GxvADoi4NR7GMD+Y=
X-Received: from pjbqn13.prod.google.com ([2002:a17:90b:3d4d:b0:2ee:4b69:50e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ea98:b0:2fc:3264:3657
 with SMTP id 98e67ed59e1d1-2fc326436aemr4399178a91.0.1739549202060; Fri, 14
 Feb 2025 08:06:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 08:06:39 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250214160639.981517-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] nVMX: Clear A/D enable bit in EPTP after
 negative testcase on non-A/D host
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Clear the Access/Dirty enable flag in EPTP after the negative testcase
that verifies enabling A/D bits results in failed VM-Entry if A/D bits
aren't supported.  Leaving the A/D bit set causes the subsequent tests to
fail on A/D-disabled hosts.

Fixes: 1d70eb82 ("nVMX x86: Check EPTP on vmentry of L2 guests")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ffe7064c..160b50fb 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4750,6 +4750,8 @@ static void test_ept_eptp(void)
 
 		eptp |= EPTP_AD_FLAG;
 		test_eptp_ad_bit(eptp, false);
+
+		eptp &= ~EPTP_AD_FLAG;
 	}
 
 	/*

base-commit: f77fb696cfd0e4a5562cdca189be557946bf522f
-- 
2.48.1.601.g30ceb7b040-goog


