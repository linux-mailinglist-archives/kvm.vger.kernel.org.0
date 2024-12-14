Return-Path: <kvm+bounces-33794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1631E9F1BB0
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:08:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39F0B162D0D
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 561571799F;
	Sat, 14 Dec 2024 01:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rXAWyY8S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB0518622
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138450; cv=none; b=iY+6a/esZKywHAahQ1739rRhEIUM84MOfMvMkeKCBqCD8shTEm74aJYyCziGKvP1iP2iBkkykgqvtZTMMXPnEdoL4OyNvj3FuRySz/Gzx3b8BnvNnRyeptLXYIF1RAIIDJ+7dGYpsMh9pCXb0ilA9DDhz8J9PlBQLqAvBBbfv7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138450; c=relaxed/simple;
	bh=IZGgI2DCqaJpVpnMfmrHDxlduEJifpBvSH6SMCXlxBM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FVD9zR6rT+OSLaIRlAV/C0DYBxf3cvgQCL9fUxKl/SF/+xgfvJvRBf/CNwmYYZSe4KWjAbCdV+vuqRhLBbM4cB/tDGH3c06Wrl5FqJOkgeJ1Hf5BcGu//P07rp5lPF3eZgqkK97b/mE9/v+wpsPvQsAduVDupCvG4LCXGpvdYhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rXAWyY8S; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-20d15285c87so27169495ad.3
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138447; x=1734743247; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eu7VheiDTVKr2LqSu+n9QlVxflc27k4rZOjnfcC28j8=;
        b=rXAWyY8Sv0RCMfhCPz0UHONPsRI8+dz3TY3YzDcfICwkJdhamKOW7JAAVFvhE112Yi
         PiR8SZ43QDsYJj8VN3VK6+Q2JOqUJOcTiliEyUI5awEwok8/9U+VL+zfhdqvlQkbPM7S
         5DY4Yj0oBVTL//7D9OGDFcL7yV5zUz8weOn/PnjCPjX/34UiiMNeeA1ajouVcBc/Lsru
         LlhUdMxwkqGSaQBc5AlNFhwC6DAg6ypWonAAztJkhschxDMG8/NJzMbh5nXBrJHWUPBR
         j6Ffhm4Vw+QS4vSrAQpDJ6J/zp+8zEhHH0sV+yEu3wqNFS46Ay25xVUy2+QT1wdyhKLS
         NDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138447; x=1734743247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eu7VheiDTVKr2LqSu+n9QlVxflc27k4rZOjnfcC28j8=;
        b=OCwhLgrf5tlgcgqVWPm1z2T6i/9rpyuplVKqMSlF8LGLKX6FoVWEcK5C6mAei7jBQs
         w86M5QAlq/6PKTy4HpSZkWZJotXCIWeVmavRB46nhqGxEcXbC2mil8l/xv6vhGddcAfX
         p9Bch4FHke/BLwBihAYRCpkZH3nVthKc40ZKQGURCcwMRJgWia+NFRKFr2G1GsBfnj0Z
         aRrCFbdqXy5VukijKFW8KY/ToqSqHdrhReYOFPTOw/fRnXtWhLbRYoY/jMM3uvdEi4UA
         jyWIbGl6sEUJ8NQSSVLZEBpadp2EKRpvjFQDk9Ys294nU3nKHuW9aO9DUDKAszdk/mPC
         /qmA==
X-Gm-Message-State: AOJu0YztHZGBM9ENVaArCiWYEgun2srCBL0vH+1srt1O2sKkdGQ5fvwn
	SHHovLvk2PBE4CicC3U20ElxQT1Fkw7+fQymz68yhvhyVk/GepqfkayAO0mc91fn5X8bmDPrIT2
	BRA==
X-Google-Smtp-Source: AGHT+IHo1lFfCdYYSF7/JbyGHm3sFAr7BgyjSeNg7ivUxMiio3zLw8UbtxvqO5CTt5MTe7jJoiLSR2DQHRk=
X-Received: from pjtd5.prod.google.com ([2002:a17:90b:45:b0:2ef:9b30:69d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f54d:b0:215:e98c:c5d9
 with SMTP id d9443c01a7336-218929a21c6mr49455455ad.18.1734138447390; Fri, 13
 Dec 2024 17:07:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:03 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-3-seanjc@google.com>
Subject: [PATCH 02/20] KVM: selftests: Sync dirty_log_test iteration to guest
 *before* resuming
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Sync the new iteration to the guest prior to restarting the vCPU, otherwise
it's possible for the vCPU to dirty memory for the next iteration using the
current iteration's value.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index cdae103314fc..41c158cf5444 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -859,9 +859,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		 */
 		if (++iteration == p->iterations)
 			WRITE_ONCE(host_quit, true);
-
-		sem_post(&sem_vcpu_cont);
 		sync_global_to_guest(vm, iteration);
+
+		sem_post(&sem_vcpu_cont);
 	}
 
 	pthread_join(vcpu_thread, NULL);
-- 
2.47.1.613.gc27f4b7a9f-goog


