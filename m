Return-Path: <kvm+bounces-28456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90957998BE9
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 17:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0C4D1C24992
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 15:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6186E1CBEAF;
	Thu, 10 Oct 2024 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QoscK3Vg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285E01CB521
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 15:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728574787; cv=none; b=lpU40Md7qT5mr5MlZpsX9QSYmpIvrCkgCEA+q2gOEQm9nIVkPdaqLxMpA+Jk25rQPOBI5WLKRhmOiEtB9VTy0a9dmfo9t9oRi0ID01ks2IFoHQ7ac/7eWtEbZDegtDMMqxIQPO1rK4+10IGhvm1Ce2ngvUoJlzPbHZIFlfIMAQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728574787; c=relaxed/simple;
	bh=MB+x1a9U6nlX5cGHyay7Cw5A6HrDfiYR8Zc6v4dtMg4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=UHUAJLRKzJ0V4PrNcz8U7kkG7Ncbh2G0zEJZ9bqXqRoOpLB0Vlq8h4oaNIqdLdvqhRga3fROBffO0NVnH7ezRuhkMkyn2tboKi6a2BH6js1UPcUQf6IR3ACcQPN280y0fInB4SGxyJ3Y0+LUGodxSNqZ6nptZNPBqwVWHOYe9bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QoscK3Vg; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e290a9a294fso1587919276.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 08:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728574785; x=1729179585; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GtndKFxSkiIMNXcqajS67o+UVXAMLMwQ9qYaza5W5vo=;
        b=QoscK3Vguhejvi5bKiqFQqD4nW/gz5IRKsim6uD+QeO6swXwuPHsvsb9jjDBixiJjX
         iwMjtbUUu8iFxOyfDrU3mQHz+FIUud9JoEJwN3HbYOVrkRWr+vJNRiDRqmwDsASSnSHI
         ZBabaJtm4kW1VJ6XXe8APng/HOvBzszKwg13WQhXqiPIzOSC8gs/vCA1g8ImGeQvg3ve
         ll5NTEpk+n0Aq7m58wbKmneO/YeKGWed+ayAA54AUFAme7PHSoGOR+SnYwmUWDjOcwWB
         vpSe2pDh55L5wrgq66fWTePocwNycFV3Fe/am28iR0MacOF+MIQPdTnaFh1y/o2B2wCL
         X8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728574785; x=1729179585;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GtndKFxSkiIMNXcqajS67o+UVXAMLMwQ9qYaza5W5vo=;
        b=NnAa0adOJZdIZ59byu1vH03rTYtEhq69+XEYGPA/xo6qKDi/YdxjLQiWHiamJuE64c
         XcV3PQadlVvKcY81VqXJS1NdsTy+H1kvrKlFS7tZY4MvazfIwlcrirKRAZNT4bjfJjV8
         Hl2o8C+MMzFEO0iq5NLXujrRGdZ7T52JtcF2WV8OFwyMgGnZImjqU55LYJMlajvxV/uB
         OItwjMRPZZvBfnIvAj6s9QhzyxfLPud+DmO37Y0+fo2paMEbHVqWUYNQK76DP/QReCOC
         DrdPNlBmCu9vZYI+sd4eXEdlU2pgmVtTBsr9sinsk/9DF9Qf5GE8dfs9jr4ewdrugPFN
         Wb8A==
X-Gm-Message-State: AOJu0YzsMMwj+lt7gkpTCinSGupSnbIEKg9IwsCtNDpJwEBMURVVEcO7
	2ROWqQ/ZfDl+fScCfmXL4hb33+3vJwF1FzRXpmKqt+pWHygexFHQ/kpSmDe6QqNS9LWPjy40vXg
	NMpiO4msTUTUgP5z3xx7aDJhnW6h5+Z/cvpceHClChDIo8gHNueJFGCAZIpFWs0V6Z9AEe2vVbR
	vPx9WALvU4guSDjGyMNUClG+eKi/oHvfzekosmNUG0Gv/WhmcV8g==
X-Google-Smtp-Source: AGHT+IFehwsQ5KwJNwckG2ZzPDyKejuuXE+2IlGRf/4FMaQ3nHUyWS90A7iMq3IIbR4OG1mYPVlp5flRvM7EDbeI
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:59:977b:ac1c:39ea])
 (user=aaronlewis job=sendgmr) by 2002:a5b:b86:0:b0:e0e:8b26:484e with SMTP id
 3f1490d57ef6-e28fe516b5amr4820276.8.1728574784735; Thu, 10 Oct 2024 08:39:44
 -0700 (PDT)
Date: Thu, 10 Oct 2024 15:39:23 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241010153922.1049039-2-aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH v2] x86: Increase the timeout for the test "vmx_apicv_test"
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This test can take over 10 seconds to run on IvyBridge in debug.
Increase the timeout to give this test the time it needs to complete.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 7c1691a988621..5f3fa9301b15b 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -349,7 +349,7 @@ file = vmx.flat
 extra_params = -cpu max,+vmx -append "apic_reg_virt_test virt_x2apic_mode_test vmx_basic_vid_test vmx_eoi_virt_test"
 arch = x86_64
 groups = vmx
-timeout = 10
+timeout = 30
 
 [vmx_posted_intr_test]
 file = vmx.flat
-- 
2.47.0.rc0.187.ge670bccf7e-goog


