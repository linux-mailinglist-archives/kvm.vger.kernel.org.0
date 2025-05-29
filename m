Return-Path: <kvm+bounces-47999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E7E0AC836C
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:59:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 543C73BE394
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 20:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 909F3293471;
	Thu, 29 May 2025 20:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Al9sDt8k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AB71DFE22
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 20:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748552348; cv=none; b=OHr5u4pXhIgNIci37egkFwMetKlqH9VQOvkFJbLNuFg1C7E5DO3bLdqIHMBRVgxWuY23g0ZJ1EdiEMRN4rw7N61zDZPVFyl4DgGwXpxxY0q9WGU89srKjdJLk6OTeuvad0bgI1bL4+qDjWEYOPa/xCCzdux9/qgSU8Of4VxdKIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748552348; c=relaxed/simple;
	bh=jTw7zFbCdTDXvmg/2tqvpJKcXjusR+EADYz3lEho4Bs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=fNx0BABIJUEOvOpZYuVB2rCJmfUH8+weSgXhhGGtTfGd69AuxlgoohW6QmQWdjC7PIASEUmunToG/pPIoeAoPzlii2FjxifobUUXE5r1ZPv36+CwIIoJwp+1ttyovD2KKOpa+ER8vY9phFFszzviqeTLIbljkTkNJxhWepQR3sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Al9sDt8k; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7462aff55bfso1011018b3a.2
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 13:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748552346; x=1749157146; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=arnHIcwmBImP6tKtn1yhCMox2AcHNOWeoxwUE/bmYAk=;
        b=Al9sDt8kOtW4s7JBSDZiQeAZOV0+XYYzv6afRd1c4Dy1WlVYkyAcXMZOVuNHH7gvrO
         nWrHXd58H2d4k4T4qBlYaqjkh7GZ6d4E9jf/wxX7ccWsJi6qKpG2c/92MlBeWn9ERDra
         yHai57p74NfQLst2gaScXCRRp0cxSVYAwGigR5j++Upd4YmTmdRlsuCvkMUtNY7H7IPt
         FDFqeVlC3CwI72uQfT7YX44BEbulRBpFO5akxNdIBpTv5pv3xwYjfwt/aE/oIyYH9FNh
         ULJS8Sa6P1h9RNTTFSFaQinBrNlcOcy3jvJ2eXTLT5tUB3kfLgmgfXSVpgNKhjtIWt+k
         ERig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748552346; x=1749157146;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=arnHIcwmBImP6tKtn1yhCMox2AcHNOWeoxwUE/bmYAk=;
        b=RmlExbkSKy7xK7Sw31+WgyL8UJ0AMKjzq6s0dulVkch2kt+VZbsWWofun7DRlSgJ+r
         8dAmRh8jtXe711SW3/4OfCoA7Kf3qXMxvHYJ5cU2qzC0V0HK5KqNUeKezcb6WRzwQ6dE
         wYTZeBCa0gW+MTtzm5QqQRrMvBoRfUOidgFkibfMu5xXvAdUU8YCgxMB0Rj0IAmgwWYN
         ee0BIGpeWqUIc02IrZK1xEEWVemwRUPjkAHMVYb8fZQMEyVO3piZjgsh93EvfL4mk36q
         a9ij7z6Xoemn7lz3drqk1r4pTCMxxi8oLMsAed9Izekd8bpaobHd8fie99fCfx8nlIqN
         +yCw==
X-Gm-Message-State: AOJu0YxOP4YJ8gZCq+DmdZCgS8zC7/59aQ+p78fnVkNMm/UlkouP7lOz
	RLaJoIzNW95kudixyzf/irjU9xMLulXJSGe2XDc6vxKFwGxlCSg+SfOoEkCWkKQ33ulNU5CcqdT
	cuU62tg==
X-Google-Smtp-Source: AGHT+IEDFiIRjJ2QVT/nleWaUTiXv9UeuWyH+eZc2+9m37QtxVXU1+G2DHyXfYM5b7GXwt8hnwXILevY1kQ=
X-Received: from pfld19.prod.google.com ([2002:a05:6a00:1993:b0:746:1fcb:a9cc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6494:b0:1f5:5ca4:2744
 with SMTP id adf61e73a8af0-21ad9572f95mr1456478637.17.1748552346579; Thu, 29
 May 2025 13:59:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 13:59:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529205904.3790571-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86/pks: Actually skip the PKS test if PKS
 isn't support
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Use report_skip() to call out that PKS isn't supported so that the report
is accurate, which is especially important for EFI builds, which report a
FAIL if no tests were run.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pks.c b/x86/pks.c
index bda15efc..f4d6ac83 100644
--- a/x86/pks.c
+++ b/x86/pks.c
@@ -69,7 +69,7 @@ int main(int ac, char **av)
     unsigned int pkrs_wd = 0x20;
 
     if (!this_cpu_has(X86_FEATURE_PKS)) {
-        printf("PKS not enabled\n");
+        report_skip("PKS not enabled\n");
         return report_summary();
     }
 

base-commit: 72d110d8286baf1b355301cc8c8bdb42be2663fb
-- 
2.49.0.1204.g71687c7c1d-goog


