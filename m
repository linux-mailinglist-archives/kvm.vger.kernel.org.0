Return-Path: <kvm+bounces-20807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ACB9291EA12
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 23:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5769E1F20F33
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 21:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF7D84037;
	Mon,  1 Jul 2024 21:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hcMOeT9E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C60876EEA
	for <kvm@vger.kernel.org>; Mon,  1 Jul 2024 21:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719868514; cv=none; b=Ia+FoF9mVUm75p2X7dtVebsu7VyTJaYPhKFm34wwGU4yjKJWL0D5Q0p0aTsQQmZaLcPsMJzRWU+ZC/piJ0/MVRm7kJUdwEJOWXCY9E2kimGGOWk4udXvdIUYotpQnkw5KVvVC3D6DRvma6+30P3Z1e9U4N8s1f+DYOOPiBfqlGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719868514; c=relaxed/simple;
	bh=Zvou/rs/A22KcJR4oWhqJacltYL5Uyd7TtwYulYm3PI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OdmbMcas9igmFxSs23cNbCiD56F6Rf2SzoM+9mvid/r3b2eecEOIaH0wpbpyqwTzVeibnMH+cksYYYuuujmGHdGhAa9zIdKO40L5quq3LNJAzieZX2Kehh1hOR3k6gGfYUJtsScEaJydLdd2V9PUyV3Q2rp5a7GKZF8AbtDFv3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hcMOeT9E; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7065df788f6so3169109b3a.3
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2024 14:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719868512; x=1720473312; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=M6ZoakALf8hnfOmvU6jlNPN5k8V/F2CNUHzo9ytQ3kI=;
        b=hcMOeT9ErbpqZu0t6jMD/T3utkNKfQS+0QAVa/gEaGT+aU/DMjLKCkynJEqLGAbiFC
         2cZFoK2vFrd0K+uV3+wxZ6Wvg2yX+bSqOc4fwTNJkzVhrxwBG8FTg64pnNGYVZJwcIFK
         CuSmdOPImedYmJQoUqhRAu1Jg4af2h3BvU/mKncFK7zDDNcHnhEf6jn7Mqupw3lttT7l
         XvYFLiPHeREVLJsU+5onlvr7oJPMqJwz0+x0R0W9lLbAt0OewIE9KY3ZOmTG9tG+JSmb
         v9FiLvAFnvbQqd58rVXRaA5ubtmvn7+V2roi91W+91RPIUfUYYOZqgFrvy2Dtk9C2DjI
         S1AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719868512; x=1720473312;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M6ZoakALf8hnfOmvU6jlNPN5k8V/F2CNUHzo9ytQ3kI=;
        b=YLZLHP5Cm+zYxlJTgyM0YAo5qmlYqja8QK4ikD9x+LMFlJ+DyF4+oAO29KOsgnERlx
         VdGHY12zr13AD2zHD069WTLqMlN1Ce1GkAdXl9ve+qyomBofrxUwT0NkW1UycvtJ4bGX
         YfYdnwpZncFOy0yW7t/EOA29zlA1XaPkcLJRQyhV9yOyVa/t/7ioe25gBw0zgxadGqfr
         p0B0f7Ib9rVfJ1SrjZBncFxjNMApvMdHN54u1kPciQP3jKh9oixiUc3XuhmZvO0HGhqq
         iR2GRYl88ZASbfdyd6T0dlVwr8pVWcEfWJ68alehXWaz4VRJpslyxcJ5nN8C5pz4f5MF
         Z0XQ==
X-Gm-Message-State: AOJu0Yzvs2TpKJhDSmIoGEirrMKAjg8FeF/VqkfpNX+iLrBiTfMB2xOT
	/rlwusUE3VbucpJHL4Ns2glhxgs6JqVyGq07/EFPxpgX6Riz7oeWLpgApy2Csx/QHDHnWoWr9Lb
	t94Oa7nMOh3dHnk1QhSSKB3fPkQdPzFfXAB0W0QSbM02bRKHIFBKqTLuh7pkrRVjM91nuGX5QaZ
	imbnZbz12sIwx8JY/JHXf8LjEpxivpVyGAAZK1ewi9IMnzfrAEFw==
X-Google-Smtp-Source: AGHT+IH0vVUEBvpLHfeFqtSI8ZlzeE4N/pWyp+RT/j874Dh13Wu76r20VigKDTdaYqMMLftrC3xUPwwbkts/KKsB
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:7f50])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:2395:b0:706:3f17:ca6 with SMTP
 id d2e1a72fcca58-70aaaf16e04mr540618b3a.3.1719868512468; Mon, 01 Jul 2024
 14:15:12 -0700 (PDT)
Date: Mon,  1 Jul 2024 21:14:46 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
Message-ID: <20240701211445.2870218-2-aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH] x86: Increase the timeout for the test "vmx_apicv_test"
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This test can take over 10 seconds to run on IvyBridge in debug.
Increase the timeout to give this test the time it needs to complete.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 7c1691a988621..51c063d248e19 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -349,7 +349,7 @@ file = vmx.flat
 extra_params = -cpu max,+vmx -append "apic_reg_virt_test virt_x2apic_mode_test vmx_basic_vid_test vmx_eoi_virt_test"
 arch = x86_64
 groups = vmx
-timeout = 10
+timeout = 100
 
 [vmx_posted_intr_test]
 file = vmx.flat
-- 
2.45.2.803.g4e1b14247a-goog


