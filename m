Return-Path: <kvm+bounces-58042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B89C6B86646
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 20:12:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 372404E3265
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 18:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF6062D24B2;
	Thu, 18 Sep 2025 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Vkm+kIAv";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="3hyIwmIB"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7072A20B22;
	Thu, 18 Sep 2025 18:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758219111; cv=none; b=I7scrJCk2VN1Q5UjYvcPdeHAYuE4e6EfhARJFGS/OXjwYTz4eyriUCyOd2xBi6N+3oGLrBvpthW8ddbywATO/68SDu7+1vMtPcBQYwN9jJwwiG7DcsrDAfm2JSNGAFgT5O08dKaJhfjAHYHGm1FazD/JvIr7NIU/l7ky8lHXEXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758219111; c=relaxed/simple;
	bh=FDj0o4uvGmvVWSbb4/BTil/cWx+IZKPSGgi0hq+daHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axph9NRgkjeQ4G69mZaTD/j8yQQiP5/m4jR9TEUjtcy/fUtOh91cFRhx88/feAh/mnXzDuvIjdWqPje25ucw3+0LuHbw8PsG/j/TMhZoIcyuqvWacBd65rvVZxrmoCpdce3Qxq5ZVK/T2+8/5I4G56znhjlwFHqOg4hmGGJv79Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Vkm+kIAv; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=3hyIwmIB; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Thu, 18 Sep 2025 20:11:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1758219106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WylLr81+eOUPKIEZ98NrrKbcMLPx3p4b8pKON1aZeSU=;
	b=Vkm+kIAvqYLsuPDTVjneg0VmIxPizaPJECAdq+snDUxnq0OF1vVxS2DAgEQriq9OKLoLOU
	DNM6klCbIcD5Vvn2GyqXM4EaKL+wpRTW54/H2FSZIvBtgQWTeY1XR6vkBf2ayFz+Lg6SVw
	nQ7aK5XufuVOZfOrPbeUhwoZzBUb20r/RKSPIRZZmDOWMRU7veZmi9L+VbHAHf8ijgsuHD
	0ilRIWMNrGo2Iv62DtHPaxdIhpvCrnXNQFisb+3oW8GUA9vxhdoDToELmEaLXj6r+xb5Nv
	LQhxTbs8+6ceBh1hUx03XLJb/6jio+kPPfY5e7d7HoICdQZQwMJV5C2SKhi4mw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1758219106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WylLr81+eOUPKIEZ98NrrKbcMLPx3p4b8pKON1aZeSU=;
	b=3hyIwmIBAnIpY8l7Z3ElWrWZYqYGI6KvKJ1KIj+Uc4TUCDH1jjHKj5M8WqUR2h3Cboynbs
	RFV6WdaP53YjcFCQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vhost: Take a reference on the task that is reference in
 struct vhost_task.
Message-ID: <20250918181144.Ygo8BZ-R@linutronix.de>
References: <20250827194107.4142164-1-seanjc@google.com>
 <20250827201059.EmmdDFB_@linutronix.de>
 <20250918110828-mutt-send-email-mst@kernel.org>
 <20250918154826.oUc0cW0Y@linutronix.de>
 <20250918120607-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250918120607-mutt-send-email-mst@kernel.org>

vhost_task_create() creates a task and keeps a reference to its
task_struct. That task may exit early via a signal and its task_struct
will be released.
A pending vhost_task_wake() will then attempt to wake the task and
access a task_struct which is no longer there.

Acquire a reference on the task_struct while creating the thread and
release the reference while the struct vhost_task itself is removed.
If the task exits early due to a signal, then the vhost_task_wake() will
still access a valid task_struct. The wake is safe and will be skipped
in this case.

Fixes: f9010dbdce911 ("fork, vhost: Use CLONE_THREAD to fix freezer/ps regression")
Reported-by: Sean Christopherson <seanjc@google.com>
Closes: https://lore.kernel.org/all/aKkLEtoDXKxAAWju@google.com/
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/vhost_task.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index bc738fa90c1d6..27107dcc1cbfe 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -100,6 +100,7 @@ void vhost_task_stop(struct vhost_task *vtsk)
 	 * freeing it below.
 	 */
 	wait_for_completion(&vtsk->exited);
+	put_task_struct(vtsk->task);
 	kfree(vtsk);
 }
 EXPORT_SYMBOL_GPL(vhost_task_stop);
@@ -148,7 +149,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
 		return ERR_CAST(tsk);
 	}
 
-	vtsk->task = tsk;
+	vtsk->task = get_task_struct(tsk);
 	return vtsk;
 }
 EXPORT_SYMBOL_GPL(vhost_task_create);
-- 
2.51.0


