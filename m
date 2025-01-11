Return-Path: <kvm+bounces-35151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C980A09F5C
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:31:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A0EC16AD8C
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:31:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A27A133987;
	Sat, 11 Jan 2025 00:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HpU5pn3a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7515624B240
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555418; cv=none; b=tUN4Otkl23L4V6CRgBR+AxckMu8wyN6pA9OI1sFjX1QVJzt2FBT5P1fpE8cy5ADfJ9rlpD7fYK4DmpGGjMw40bAx5Wz2JIogwdWjKcd5BaaQzmIYctv1pMGRCMVMJAo63ny2UVCkPeb8NdsKFcsEtZgOEyhky0pKdEQnGeOWCs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555418; c=relaxed/simple;
	bh=tjFdMjX6lyJjTAWqK8reLPzxs+8rAonFk59izniqoqg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MdU20Qb0eYsWETJr0vIj4hc7tkCoxK5zxCYILUwJ9wstQZzJjNsvMlJ9Nhg58gc2lOYPvqDyxIrmRanHsKhaA5wlinP22nLOgCmiQNl3KRT4M8nSLfGjpAOVqy8+yCNG87Ux3LTcOwjhCHgI7WUdF/yp7rXpdiyiHeRAVtalmWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HpU5pn3a; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2178115051dso47781165ad.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736555416; x=1737160216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=os8abNvX6CFnZNFiWQWTmtZN80dTM1n/70vxr9R8AE8=;
        b=HpU5pn3aq3CgikCbov7EboM8CLqyopxxBWCSS4foGLz8QaxeAyN5TaXOL83UpEsfZV
         4X4sb5Atskb3kI866/S8gWGPDCeu6C7pQ7y1OrTNPWphqABe/RK3aEjmWEw186vwJGt3
         7PW12F/4yiV41ezADDvm4fK6wdnpsOpiZmTp7BL0EPdfEdpOsFUkSNI8R6JrWhHfVH1I
         CMaI4WT4aB7vbliAYSiv8/gdejfqu+RPipN4rXT7Zjqx58XPefsJbW7xSHp0GomKKIgS
         XIvSpTODYwJiH4q+1+slBrtmoTzgOwU3mxrRM5yncwO0TvhG7TbbMIX8+3jubsGQSB/2
         SiJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736555416; x=1737160216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=os8abNvX6CFnZNFiWQWTmtZN80dTM1n/70vxr9R8AE8=;
        b=fMX82K/pnTwRhKFUL6rAB0AwYQ/PYC5xO/ZCIuk40HFajmye1ciKdihFR/C5eAI7nF
         n9QP5Chf4xagmpuQWfUsumidbv9pmWhXXatO+4/uI3mOHsS5mAJKmhPyzUPRJ/W4CqNT
         iSgPbVA67+80SDhYRFeOTJp7BcjyHL6sFr5dqyIpwT8m9NRNPegDyuO8TnfcFah2llTv
         43om7LMkDo1jbn8BSiU24WG3IHcDlh5IRPshahABLcx6xdbNfp2jE3wHbXjmg0ctDSrc
         vjKkKgekiN704oaoLwSIW0D1Z5uVwTjJMcmex+fAESKNl0XsAf9lOHTMf1KGRsZlZUm7
         qJmQ==
X-Gm-Message-State: AOJu0Yx4tcJ33WwSyDKeKGkAY8hyAez4fQbBc8S+QQYFi/pED0CbJPbX
	/ydUMLwezBFIkpNw1/MekRwp4j57Y8MTiJUpjyXYTeS5L9XtF2u/BRoF3xgSQgXy86N/DAg7llf
	DAA==
X-Google-Smtp-Source: AGHT+IF9IWwdflYzR8M2xWZC7N/dYo31gRYsrweOMeidToMTdrclC2+399p202NcxYC9UauowCG/8v7eQkw=
X-Received: from pgmm4.prod.google.com ([2002:a05:6a02:5504:b0:7fd:4497:f282])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3996:b0:1db:d738:f2ff
 with SMTP id adf61e73a8af0-1e88cf7f75dmr21580604637.2.1736555415847; Fri, 10
 Jan 2025 16:30:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:29:48 -0800
In-Reply-To: <20250111003004.1235645-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111003004.1235645-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111003004.1235645-5-seanjc@google.com>
Subject: [PATCH v2 04/20] KVM: selftests: Drop stale srandom() initialization
 from dirty_log_test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop an srandom() initialization that was leftover from the conversion to
use selftests' guest_random_xxx() APIs.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index d9911e20337f..55a744373c80 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -891,8 +891,6 @@ int main(int argc, char *argv[])
 	pr_info("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
 		p.iterations, p.interval);
 
-	srandom(time(0));
-
 	if (host_log_mode_option == LOG_MODE_ALL) {
 		/* Run each log mode */
 		for (i = 0; i < LOG_MODE_NUM; i++) {
-- 
2.47.1.613.gc27f4b7a9f-goog


