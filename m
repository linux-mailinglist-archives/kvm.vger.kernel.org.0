Return-Path: <kvm+bounces-73356-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mESpKfggr2neOAIAu9opvQ
	(envelope-from <kvm+bounces-73356-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:35:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 555DF2401C6
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 425AC30396BC
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 19:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5236440FDA2;
	Mon,  9 Mar 2026 19:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="usO9sazn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA5D345745
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 19:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084674; cv=none; b=uNbMEO9A0RqDzvyNm1iom2e8dtyPwGfzaXeqgSNBIF/Tw8GMSrze8GMm0Oe9nhG/C+kA+GOOkwayhx6ErOS1Ed6vdlJmfgH7xihLTVcgK8nS9DVZO/rGkYlT7V+Nzf+1+Z0bRhhxaMWnqMFxBoGh4jnUKX/+FJlEMtAX90iLAk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084674; c=relaxed/simple;
	bh=iW/ovbydh6oe8AnccpxkXTU0eghC5tS6m7BQI/qh4ik=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=VL344KxyXNX8vYFBur4FIG4cxhOwWquHbQIbkDvIclgLI+/LyJakRJJylvJLCQPP6YKDt5O/xaiH8iLWv5nDdvq6TOiDS/wbD4hSFp8LsuO0+iMvZmtTIZF4Lcq4wIW1xHS//Jb4CN+i+aA9CqKR79HrPLQeQYJnjef7kYqbCEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=usO9sazn; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-829b7ed8964so1322278b3a.2
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 12:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773084672; x=1773689472; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s7IWN2tD4stFfXobSZdPZ2dyLMJvR8FtsJ70ojQYFj0=;
        b=usO9saznJYUdXgvFh0wddzDKO4/XLuQKVqibQfEnkhy79eL2IvRO7tBdRYpf+N44Ej
         JyEk4Qxx+Dk8UBtjnS50nHBh5VmxfpdoVogaQYsS2g/K6sLlX4Iokr65vM2ZZVv05FDD
         we2EYtuKmeJAVr6Q3kblV1VXYnYRI8phZwrpJmQOA4v05eOZ8bkRfVsgi3Q8SqoYb65G
         t2JQ1vCOs/Y+49OfNR3OrBd+GD2HOyrtPcKNqh+O1Zx5OyjiZUbRMR8LnhoFXjgqD7Yr
         0qX/83pcLWSTmo3kV7/lHCXWuFlYEMF/IFyJQWLpcKBe4gOak9Ip+Z2W+YzNShzn3ir8
         lKiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773084672; x=1773689472;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s7IWN2tD4stFfXobSZdPZ2dyLMJvR8FtsJ70ojQYFj0=;
        b=MEBXPf+kN7Fir6NMCWktO4jb5JWyFwt2Bpki2ZqSoSRW79v3bgh+4MkrcJyCkwjF3u
         qxPqg/5UPD01pJoP3xtCE3jVacd7rN5TifjjBQv06EbOgCwAZSuYG6es1gEVffdoFrxR
         K/bXp93GivAUGVSVg4NbtebGD9RCL+mC4W94xB1HUu9TR9yipPr2p+nc+UFPpplec2Eu
         2zSCNy7bKibrc5/1n+a+w03v7z7fIRKMiCgbqrUM/UoNDTSnguzh7ESUwfghNJbQ7Q3O
         H1CytVLfK+eZSkfN8HXCwA94Cpak3VFFtb8A1CEAW0RwWeGM8qlDf/HW2aj2xx2RJQkk
         X2FQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8KM8S2ifQaIWDC0TxA3mTDLq6JUn2e1BKHV4tJLSJd8LxkVYnsFkdQP8AuoRCXrwFJCQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjZaVGVSfoA5aSmybLVV6WxoZE54vAYut3YJzb/MADq5WzWTBG
	ZqcHusmn6ZGm1v8JlYOtfdy1iK5NiQ0sFJuMbh7eqQAW2szfBr5iraHuvZEGROkpow/OCx5yNT9
	5/fwHIA==
X-Received: from pfbjc7.prod.google.com ([2002:a05:6a00:6c87:b0:829:7d34:ff91])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e23:b0:81f:48d4:a979
 with SMTP id d2e1a72fcca58-829a30a6273mr10762158b3a.49.1773084672132; Mon, 09
 Mar 2026 12:31:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  9 Mar 2026 12:30:56 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309193059.2244645-1-seanjc@google.com>
Subject: [RFC PATCH 0/3] srcu: KVM: Add, export and use call_srcu_expedited()
From: Sean Christopherson <seanjc@google.com>
To: Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Josh Triplett <josh@joshtriplett.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: rcu@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 555DF2401C6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73356-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org,joshtriplett.org,redhat.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

We've got a conundrum in KVM where we have multiple use cases that generally
want the same thing (eliminate waiting on guest configuration changes whenever
possible), but use KVM uAPIs in slightly different ways and effectively create
competing requirements.

The crux of the problem is that one use case wants KVM to free an object via
call_srcu() so that the task doesn't risk getting stalled waiting for a grace
period.  But for the other use case, using call_srcu() can trigger a
non-expedited grace period and cause a synchronize_srcu_expedited() in a
different ioctl (that must do a full sync, i.e. can't use call_srcu()) to stall
waiting for the non-expedited grace period.

Tagged RFC because while having the call_srcu() request do an expedited grace
period eliminates the unwanted synchronize_srcu_expedited() stalls, this feels
like a very crude fix.   That said, I'm definitely not opposed to this being a
final solution if it's the best option available.

Sean Christopherson (3):
  srcu: Declare exported symbols before including srcu{tiny,tree}.h
  srcu: Add and export call_srcu_expedited() to avoid transferring grace
    periods
  KVM: Expedite SRCU callbacks when freeing objects during I/O bus
    registration

 include/linux/srcu.h     | 10 +++++-----
 include/linux/srcutiny.h |  8 ++++++--
 include/linux/srcutree.h |  2 ++
 kernel/rcu/srcutree.c    |  7 +++++++
 virt/kvm/kvm_main.c      |  2 +-
 5 files changed, 21 insertions(+), 8 deletions(-)


base-commit: 5128b972fb2801ad9aca54d990a75611ab5283a9
-- 
2.53.0.473.g4a7958ca14-goog


