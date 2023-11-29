Return-Path: <kvm+bounces-2815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6164F7FE35E
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 23:40:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 037F3B2109E
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 22:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0AA447A5E;
	Wed, 29 Nov 2023 22:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PHKVRTCk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C119131
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 14:40:47 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cfccc9d6bcso4726625ad.2
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 14:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701297647; x=1701902447; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I+v1jFIXf64LmcoETe5BxvZaUtddzr4bC5h258OJRYc=;
        b=PHKVRTCknguXhqDUmvoRRFUu4bSAKjEzdVDF949SKeNHF7yvgSn279Prc1jFx7Df3G
         oDikiZ1EweFDjkDjVUTYQnqZ6T8jCXgaoWtXA5sdDYzOmdBzZaRAAqAWVVrAsvxA4Usv
         /xpYFWXiGj070fds/8A9+g8uy3SMkBpPM8aWbr7cL4ghCTl8pSMj32wPQqHfcZO27bu4
         7rNjtoBVHXkuKp3xuhLAht0bJpI4u7Gr8m1FRBoy0xm8klWuGX8nmsJIFUuP/QJkxVbY
         zEmhyX8NbZz5dC3AaLH6Q5deLoF05Wys23HWYmS8wKoyy/N/Jb2rvhLdHMl0cR+0ZQo9
         7n/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701297647; x=1701902447;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I+v1jFIXf64LmcoETe5BxvZaUtddzr4bC5h258OJRYc=;
        b=Oq2B4GlcerIhgXUAR0pC5Z5Gwq+70QEmwqmPpXQo9EMuPggt9jX3RbJ06Jh9qTzxSy
         Gw1X7s01Tg2NQszVwqelMdE7NPgLe2FFjUmJKazeHkOMohTV1Q7Upbi4dR/3CfNeDYoQ
         ktJMbWcG3J8dq0LSS1IxpmVZxZvkHwa+b9h+piHPfsjVwpdmjDi1ZB99XB25aHlumctX
         MqIUNMrNivw8ZZP5c6b+/6PPw1EeqmXqtP9R8ZVsh6w/+f+LdkqIAfVR63NIVOlDRVbD
         sfddgAvicsBHGm4WRDeU5oPsQRCg8f84ygTpzp01YguDp6bcad9N2v3zIoB9Uve+8Gge
         qZDg==
X-Gm-Message-State: AOJu0YxYZ10yueZAGxRWSlfPXA2iIS21IoUuCWTdvNX3HNBsjy3cE8nb
	g0PZtOFrXnNDqA6NJzaWJuMjPTQ+AvQ=
X-Google-Smtp-Source: AGHT+IE5FIx8aj45AxYw5oGrpfmlhBTeeHtp2XvpoNiWQUQ3HX1upYM4wJ2O05QcEx+FY+pXbc9cnIHteb8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f68e:b0:1ce:5c2d:47e with SMTP id
 l14-20020a170902f68e00b001ce5c2d047emr4791132plg.5.1701297647010; Wed, 29 Nov
 2023 14:40:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 29 Nov 2023 14:40:41 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231129224042.530798-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Reword the NX hugepage test's skip message to
 be more helpful
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Rework the NX hugepage test's skip message regarding the magic token to
provide all of the necessary magic, and to very explicitly recommended
using the wrapper shell script.

Opportunistically remove an overzealous newline; splitting the
recommendation message across two lines of ~45 characters makes it much
harder to read than running out a single line to 98 characters.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index 83e25bccc139..17bbb96fc4df 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -257,9 +257,9 @@ int main(int argc, char **argv)
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES));
 
 	__TEST_REQUIRE(token == MAGIC_TOKEN,
-		       "This test must be run with the magic token %d.\n"
-		       "This is done by nx_huge_pages_test.sh, which\n"
-		       "also handles environment setup for the test.", MAGIC_TOKEN);
+		       "This test must be run with the magic token via '-t %d'.\n"
+		       "Running via nx_huge_pages_test.sh, which also handles "
+		       "environment setup, is strongly recommended.", MAGIC_TOKEN);
 
 	run_test(reclaim_period_ms, false, reboot_permissions);
 	run_test(reclaim_period_ms, true, reboot_permissions);

base-commit: 6803fb00772cc50cd59a66bd8caaee5c84b13fcf
-- 
2.43.0.rc1.413.gea7ed67945-goog


