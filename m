Return-Path: <kvm+bounces-67882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB03D160DA
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:36:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C95A6309F756
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 762A71AE877;
	Tue, 13 Jan 2026 00:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xFIYAMjO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5054F258CCC
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264319; cv=none; b=OOmd9DotB0DsbSQFRuLl0k5rixZVEfssb6fXZkg8b0dp4hTyGrAsnjsiVOLetmwcdcFeoNzXpMTbdqax5eiF2/xHCZ+qL9KNpiiUPparL1VJDRCWO5kNXR4S+SbwG1bwWh7w0qiKcziFX9aP8bXhDxAsEjCxZeoPA7DOHXUSvA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264319; c=relaxed/simple;
	bh=l7pUcHj3JtKuCovI6QlGWC+6I84CJ+JsJsrLvviwIYE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VMtNU0j3YB3FuZTjZ2GAnmuJ1Z5G4jRYgPxtkIMKBIszVuGqJi3pIYN1ktk/oUEtuUV07YP2wqXrc8WT6RJPG16/IjiI+EJZhE6eHSCWzBJ3Re7Hgadl/61zJOEsPnvbGq2L98SZDD1Otb2yDr22gJl0jQSBjbqs+oiN3QEHVHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xFIYAMjO; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0e952f153so180876055ad.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264317; x=1768869117; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1cwyhiZCM4DoTczOq/02jfKDa+oLIkgQ8T2Ln5iEcgQ=;
        b=xFIYAMjOkeSmumOeNYwUq3po4PeJwE+03diMosUdJOeLFMCxi8uMt6T/DXX35FNCgO
         +OoNvy1Se4F0Ux1iVPsSsOPoF157gm05KLCbiwdWDLn0uxhvCYYtwAjb96cbTXft/EEo
         RLMiJ6T+mhx7oAMfh9DqKAm90u5VK9IhkXXPhH14ETLQpou+IfGaFGwCD17B/kZn0Iwd
         kpn/ppKYtMVHuI10GEic04kgvDnL4CUf3a9jQ0fmBPtZsbD6nMT3XgNOkGNhxDSoeu77
         7kP0xqFs5pHC0RRr7Ny2JGPQh0OOgjakF7crVce4EpatTdUn7v0NRY7K0A0j5z6dxjkq
         KNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264317; x=1768869117;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1cwyhiZCM4DoTczOq/02jfKDa+oLIkgQ8T2Ln5iEcgQ=;
        b=BzA4DDW6xkUiis7Lu62zxfBtOkoYOxmyYwagIXqKtita26gxGu6opj5t34Ed56CgqB
         LccF3agd+QMXIMqOZ4BftrlJogkv9QQsPVJfTdPcYKPgCFCYyhlJLUxhP4JjkBjctR9W
         QJpT7LrWTGC18qAAgxa7Wnvrh6kCks8CwJA9pt2VCu7pcELzR7PhcOlmp352IxxyToR5
         Vj+OuLZwkMl7xBNkm3s/35FwJPVLsIIssV7/GgGinS1BAJvWdvLOi3XAJX4S8Yq2x6rZ
         M/+EVufkLra+O/upv9Ex23GKSpo0Usj4Y/LT4j21jiWVRjMO16tcLDoPKOdRbtC7gRZv
         7pEA==
X-Gm-Message-State: AOJu0Yx5FUmbY8mc08b0T48o+48jg8j1Q9X9kp2lMOKxUopV7xgecPd/
	V2J5f2tKOigBYvAEBhEfihm9Cw21ljTP+tZPDF839F9cAxknygFIsm9GEuCUsrvzQKUljKTaq9b
	icT8bstxmu26dQVZs1NH65COMyuL97KTIc/+uRD7aqri5vXEOnOWdtc311x9Mc955ep2Q1Zysho
	Qad6YVKbWUSzZ7OH4gVf6S2YebsEUnrXzLDsMAsRgnXTg=
X-Google-Smtp-Source: AGHT+IFNFvqXERLOcbZQ4P1ue8DJOSeRY1yclfKryCk/slRq/beKvhB9GE3g5b8nwh97WwTLerjfSe2nSa6qIQ==
X-Received: from pldu19.prod.google.com ([2002:a17:903:1093:b0:29f:b21:b1c3])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:9cf:b0:2a0:c1ed:d0d9 with SMTP id d9443c01a7336-2a3ee49b022mr177188725ad.46.1768264317538;
 Mon, 12 Jan 2026 16:31:57 -0800 (PST)
Date: Tue, 13 Jan 2026 00:31:43 +0000
In-Reply-To: <20260113003153.3344500-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003153.3344500-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003153.3344500-2-chengkev@google.com>
Subject: [kvm-unit-tests PATCH V2 01/10] x86/svm: Fix virq_inject SVM test failure
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, the virq_inject test advances guest RIP regardless of what
instruction caused the nested VM exit. This is an issue when
INTERCEPT_VINTR is set and the sti_nop_cli() is called in L2 with a
pending interrupt. The vmcb save rip will point to the nop instruction
on exit due to a one instruction interrupt shadow. The unconditional
advance of the guest rip will move it three bytes, which is past the
entire sti_nop_cli() call. This produces some unintended/inconsitent
behavior including test failures.

Only advance the guest rip if the exiting instruction was vmmcall().

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 x86/svm_tests.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 3761647642542..11d0e3d39f5ba 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1790,7 +1790,9 @@ static void virq_inject_test(struct svm_test *test)
 
 static bool virq_inject_finished(struct svm_test *test)
 {
-	vmcb->save.rip += 3;
+	/* Only jump over VMMCALL instruction */
+	if (vmcb->control.exit_code == SVM_EXIT_VMMCALL)
+		vmcb->save.rip += 3;
 
 	switch (get_test_stage(test)) {
 	case 0:
-- 
2.52.0.457.g6b5491de43-goog


