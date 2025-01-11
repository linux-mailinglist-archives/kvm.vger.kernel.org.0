Return-Path: <kvm+bounces-35166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F105BA09F7C
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:35:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB37416667D
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 820981A8F63;
	Sat, 11 Jan 2025 00:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eeaGOH+B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4B519CC1C
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555442; cv=none; b=WPIUccvzVGBS2BcfYwOxk1Yhtka1VpkH4lxVV9Xl/yjOr4cLYYUTvIo3HrGjBaBgDJ4Sy5/W16fdKUkv2gB8cWfE78KhfhH9lDL04XVqLDPvZpdsJ86TiWimQvSbk0lXb5sXA/P/uVbhMY3RbO1zBPuoD24B5qKibm96d0r7tGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555442; c=relaxed/simple;
	bh=PsjCgtsdswqiLxYs85wIVANE9O6zvdBrqZFXA8iPzxA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qyxVAV077dtFLyDq2IRaDac+labBU37wVHm1tQI7sH4xv2RN9YRKXnOAvn8mKjiNS1VDBaQoZ3R9CBgw3oK4NJx4emq6XK3XyMbVW+FdZnkdb4phm97xYPQwImrSSh2R1WjVXfMoLKyq9azgyWXycxNkigYaQQMVy1fHviw/iNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eeaGOH+B; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f46b7851fcso7396315a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555440; x=1737160240; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CTB969N3z4oSgV+Wd1f59dXC53zHA3ksCR5erFyv7TI=;
        b=eeaGOH+BFltafHSMS64WFiJUxn04s1sHRWbP4yhnWATCPsNwp4lrpf+eWRutbmoMXv
         zNp7GeFsxC5c2JJOYE/VS5kNNLeO6joMCJOl1S6kjGjqe0xjsvK8Xec2qxJgc816kJCy
         Kfy2x1pCtTfi4CV4gM+mD3jbIQetwHsZMCoB8CQcuAecKtxLjZKoZ3uz3cUIaSAnY5pG
         yA6fZo4B1yYh8Id4jeRckHiPlixZ0H947puWV2CYLx4R8NQ5hi7QOc2LebtCVnt4br/S
         NJVWXjhhnXWH727lT4u4JrwYgUWPSIvNZKDUtLuOeJ9BDnkIkbWYq3DGSpzug78NwgGt
         a6iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555441; x=1737160241;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CTB969N3z4oSgV+Wd1f59dXC53zHA3ksCR5erFyv7TI=;
        b=kspa/58R7B+FPTDIxldfdFRJ+WnsU6/rN5kUB9ngSIOZ9Z3+OCMAFwpmqvPjg878KC
         kkGiG/x+frIGuPAMcWq/TXRIkHZHAd9cMmZfds9746D2iJYg9/I8sAWvbP913utFZ63O
         n/p1LGOE2Bm7tr5r/x721A9N9+J6jxTBPX28wpyCblnCn+mwp78hyszxottjU9KytA0n
         G1wJ5qbcmv/zzctbb1/2/Y10njJR6V9WyawADC8D6kdzyeKFbaHFDontZrKT9cP/baX4
         OpbuBqEhgBgmY2QU6Pfuy2KsjhJMxR5IO15R6F+ge5eZ8OeqTiki6BxwU7gpSqFMuQa2
         VDDg==
X-Gm-Message-State: AOJu0YyGofkDSB0vMva0mkR0hEmyT2OdzT/3nqqXvQbrs02dBQ1PNL9N
	kEX3LgdrVNVeug/sR5cHN9gMtRDlFZ4NvFOxFmqO7ANPucNd/qOQM/puimHLf0nrkCWHubX9Pjq
	3UA==
X-Google-Smtp-Source: AGHT+IGvUD6mfMIH0QjQvbQ1pO3vfOtc0UNk2rtfvTC5l9ZKmUXTAlFim5JHKHRdjCL5vQj+KstFEZdygEk=
X-Received: from pjbso18.prod.google.com ([2002:a17:90b:1f92:b0:2ef:701e:21c1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c88:b0:2ee:5958:828
 with SMTP id 98e67ed59e1d1-2f548f2a01emr19478940a91.9.1736555440704; Fri, 10
 Jan 2025 16:30:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:30:03 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-20-seanjc@google.com>
Subject: [PATCH v2 19/20] KVM: selftests: Fix an off-by-one in the number of
 dirty_log_test iterations
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Actually run all requested iterations, instead of iterations-1 (the count
starts at '1' due to the need to avoid '0' as an in-memory value for a
dirty page).

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 40567257ebea..79a7ee189f28 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -695,7 +695,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
 
-	for (iteration = 1; iteration < p->iterations; iteration++) {
+	for (iteration = 1; iteration <= p->iterations; iteration++) {
 		unsigned long i;
 
 		sync_global_to_guest(vm, iteration);
-- 
2.47.1.613.gc27f4b7a9f-goog


