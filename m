Return-Path: <kvm+bounces-55932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 896C6B38AB1
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 22:11:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47F161C22133
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 20:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4932F2EFDBB;
	Wed, 27 Aug 2025 20:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="jM8ehaLw";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="sZiERzK7"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A9627E1D5;
	Wed, 27 Aug 2025 20:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756325470; cv=none; b=SzaQ1AQwYj0K18I9yADwyxMyNvxEZEubjwTrwlDK/je05RkOci5LiShbFHzIWPI9hIpIDDfcX1sqiZ9aGo6HbvMEzJhgnWwvktGA88X3surknzzMTCIVru/nR4zkfy0XHAOsVw58pRZITDRAtPzP2YPELR2V43S1ajK7sjHE1mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756325470; c=relaxed/simple;
	bh=LZ45DdtI2GHR/bNHTXO18pT+29HkQdFkJCBPK2VwrL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFLSqsIn2E3RC79l77ZeSu0Yv2+RNV7zv1PX+8/cs557JVdkoqZGAEOiGI1EsRDd3hqX3EtfEgIzcaRnLFgOJ6iPbab///sdc98CljcgGr0BD8boyo05DPg0CgryQpYYom+2gww+GoKohufTqRkd714+iKg/Mz2pvSKh+W4fx6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=jM8ehaLw; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=sZiERzK7; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Wed, 27 Aug 2025 22:10:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1756325460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SGw07ZG7T2lSedYqSiQO/eFdzWtQmXmqUlGnClBZxG0=;
	b=jM8ehaLw6Wa/LdnI2CgQe9JfaXaaMY25WsG9Ni/RzhSvKJ2vTqcmuDz5+eYx7eUlveAgoV
	GxXIaQf1eGZaFalJAYSyYXbEuljf8oezq7BjWrE2GDiL9q5Qjc4T+qYl1ovwW5Rko6Z7lV
	kfk4QEwf15bHdsG42rH4ZljzrO2KESN0Kk8u1YYwe5MVHgMKHB3AgZOqyoKVai9k2jGBOJ
	sHZnvP8Cmzo0AhqSrEBYEoRCqgzrbwlmP2UJWmHJcCmKD0i3kjJoh0XFYqkCbNVX+GicgW
	vJjHZuP8tHaj4kUieQInSzDpmNnMwkdTY86o1WLRM+OsMFRCwhbnfrQEAgUlDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1756325460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SGw07ZG7T2lSedYqSiQO/eFdzWtQmXmqUlGnClBZxG0=;
	b=sZiERzK7/t0hkZtKQOC6p5Ol/Pm0iO22GMkhgTxsdx+KTyQmYNWrAyS2DnGKpcgO/cCDXv
	7kxXgEzT4yAiKnBQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vhost_task: Fix a bug where KVM wakes an exited
 task
Message-ID: <20250827201059.EmmdDFB_@linutronix.de>
References: <20250827194107.4142164-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20250827194107.4142164-1-seanjc@google.com>

On 2025-08-27 12:41:04 [-0700], Sean Christopherson wrote:
> Michael,

Sean,

would the bellow work by chance? It is a quick shot but it looks
symmetrical=E2=80=A6

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
=20
-	vtsk->task =3D tsk;
+	vtsk->task =3D get_task_struct(tsk);
 	return vtsk;
 }
 EXPORT_SYMBOL_GPL(vhost_task_create);

Sebastian

