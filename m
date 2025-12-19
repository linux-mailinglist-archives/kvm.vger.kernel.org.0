Return-Path: <kvm+bounces-66416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCE5CD226E
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 23:59:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4A8E1301E6C3
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 22:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06AE02E8DEA;
	Fri, 19 Dec 2025 22:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PNTLMGan"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6539A2E7645
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 22:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185158; cv=none; b=b/CfqE2hWaiDKMgSiTgDhZj1DTiHd0mApwQyZ+9nfpQton1TL0bXNV+6wKjlj/PKBOFdTuXyLVVkzgnruK7/PJjeaYOC3DI2q4zKB3qYkjwKCxh6lCA6YhJG/2ZLrLHXAQGEAsflgk52HW7LxYkphqOKFjhgzl1ISSOvmXGQh7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185158; c=relaxed/simple;
	bh=DTFKOE+8xPv8vyh930zQtxWsFrTkUhl5VxaFOJ4doo4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RksIskET/uBKOhx8jp68mW0I0b3Uu8Kbn3o6OhHGjMnq7+YCgXL2j85WoVzxtN39WVplSlluuUssR9CfoSdwNK4dF3uvYN5g6O9wHJXG/lK22sGNg5PR0uNxPhPZW9FjKdin5eKRRXbl/EnFT+0A+otm/b6W2s1v64noAq4j0LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PNTLMGan; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b9208e1976so4283855b3a.1
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 14:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766185156; x=1766789956; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pys+Z7tIBfo+xR5DijVOK0nIcyooz5O/W96w1H9CAtI=;
        b=PNTLMGantl7VUsw+mRYjvGcrRJeTbN+mdZxeLboDQVyBalXUZtqvIMBqCpmn7buPsJ
         FR3fhCMq4zMNp7fFDAXBGn3sxn4/DFRrDlfxhFaOe92OKzYrK3PWF6Sg4L15aDgFmkSh
         zoTB9YTsTN5FeVhdDFHkLV7Go7xcUB2SVPfgj1RBmThJsFfXNF942C5AKJz4t3y7wK7X
         Ji//nVqXTvBFP9lHRm+Z12GYq8DtiuJsu4fgZgrTRzqQipj2y1EMG4uRw9YRq3aK1Atd
         eGzt/lpcFsklI1KIZp1S6IIwFkTRjPFffy4be+iLPo3VmaLVMK3hYbuyCSlLlTwy/9bP
         9wuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766185156; x=1766789956;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pys+Z7tIBfo+xR5DijVOK0nIcyooz5O/W96w1H9CAtI=;
        b=P37TczyIuD3GVj+zDC/XbXUf3QXhbdS22Hnfxe6PEf1Ai7xIxaEBKdKbTG4Sw3p3KO
         OlyyLIHZNDR90QRmZbo3wlbZ1lT+ZXVkgOnlahl4FIn9dYR0ssNRMSkeE36reyOWoG00
         ra3bOUB4GtIpoa5iEpXE6gnNJg+Ugz7WE2DM3xu0WmIXSsc0gtx4Xh6c+URjg1lqrGl4
         Da/a56jIxCxaqOape+5esiRePlflUsBwjApQjym7W4pwWjKNtaYZ7rFJeODG/ee2wbTb
         hnefn9/bCyy6B/6Tmws1pMR/dyyxbmo+oZLK4VCjY6kY+oXuikud3wR3ayhfRf/3TGvX
         iw/Q==
X-Gm-Message-State: AOJu0YyfWfCmDfv5SOcyAJzuY+wUGocxicUMEzDs2EgjljxiTbK3/G91
	e2KwflOYNlApsraYYwaLAlP6zM18pE8/U5qBah9besv8my3YGFfHCbzOFHp3Ovvo7zvCRez+EvC
	jUUOP5quaZ2T74wQT8KpOp9A9B9hhnlN9HimZqA9RFcv69uE6rhmVIcuxXBM7n29Q2HEtv3tw27
	HJBLodWTLt+0XGYBK5R6REf0WA5spGoZ6SjLui/TcRyIM=
X-Google-Smtp-Source: AGHT+IFXw4w34wvhwZb2zg7BlfLFfq6unvJT4LIWX59P8+GeoNcuJGpRj0i/WLCB9cqT9/uP9lZJqGS7VuK9kA==
X-Received: from pjbcu22.prod.google.com ([2002:a17:90a:fa96:b0:34c:2b52:cf75])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:548d:b0:366:14af:9bc0 with SMTP id adf61e73a8af0-376ab2e7e20mr4291969637.74.1766185155631;
 Fri, 19 Dec 2025 14:59:15 -0800 (PST)
Date: Fri, 19 Dec 2025 22:59:00 +0000
In-Reply-To: <20251219225908.334766-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251219225908.334766-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219225908.334766-2-chengkev@google.com>
Subject: [kvm-unit-tests PATCH 1/9] x86/svm: Fix virq_inject SVM test failure
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
2.52.0.322.g1dd061c0dc-goog


