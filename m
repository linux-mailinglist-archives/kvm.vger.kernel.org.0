Return-Path: <kvm+bounces-52875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F11CAB0A014
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 11:50:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD2D91C43362
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 09:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6182E29B772;
	Fri, 18 Jul 2025 09:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="K57P4x+p"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0B329994E;
	Fri, 18 Jul 2025 09:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752832216; cv=none; b=BeighGT3NxvOUsHRuBUHPo8Vxm6lUJC1Zq1ZHhGZZAmq6tlTFYTMssPb79uPsQ0G/u6lwpmyUnxKf8M0DhCYb9DhbdNQZXjSvq/kvsvYlwAghHAlbLoCwkNybrFW4PNLwIkJ5eAKotkkMJrqxc8HfonuWB7dybi+Nwr6OFA88oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752832216; c=relaxed/simple;
	bh=FSDkz9ufGd6JFNDDBz8LCXm3t9keeU/OAbDamo4Homw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E6Pb1Q1B+6RsZbU7YbRYmMQ4XEH8jwqTPmaZj9mOAuLe495cJis0qWHVPuzO2dBSPVxFmrmwkYJ5VN3k4W5s53QFHH06EU7mnMYkKnYpPs+AB6IAJlFe2GaRxNhckKhblvFi3AYC0VktzobcW/q+DBS0ABp8hyrMlcyw7kggTnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=K57P4x+p; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0f:4291:0:640:5ba1:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id BF8F9C12E5;
	Fri, 18 Jul 2025 12:48:58 +0300 (MSK)
Received: from kniv-nix.yandex-team.ru (unknown [2a02:6bf:8080:56e::1:20])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id amKOpm1GwW20-X0xCTLjP;
	Fri, 18 Jul 2025 12:48:58 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1752832138;
	bh=FSDkz9ufGd6JFNDDBz8LCXm3t9keeU/OAbDamo4Homw=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=K57P4x+p2x0RkZTlbxzz0TZ3i4PfsYj+na/7loFsqMsJWry33+KJ/MdJ6uzE5FhJY
	 LfvAQH/8rPN0i8Xg81PXiRsxWLE4MjFN0yTK1o3OdiL+gHWhhP8wRnlJtkpJwN3eAa
	 fNgLBLzdLPnZ64Ernjib2XJZcp3KEmo6XfKLESu8=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Nikolay Kuratov <kniv@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH] vhost/net: Replace wait_queue with completion in ubufs reference
Date: Fri, 18 Jul 2025 12:48:36 +0300
Message-Id: <20250718094836.1538136-1-kniv@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250718090725.2352-1-hdanton@sina.com>
References: <20250718090725.2352-1-hdanton@sina.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Yes, if multiple waiters call vhost_net_ubuf_put_and_wait() concurrently we
are screwed. Furthermore, it was not the case before this patch. While it
was explicitly mentioned in the commit message, now I changed my mind,
because amount of vhost_net_ubuf_put_and_wait() users may change when this
patch will be backported to older LTSes. In 6.6+ kernels there are
only two put_and_wait() callers, both are ensuring that there
is only one thread calling put_and_wait() at a time.

I think its better to preserve thread-safety of vhost_net_ubuf_put_and_wait()
and move reinit_completion() call to vhost_net_flush(). We don't need
reinit on free'ing path anyway.

I will send v2 with the fix. Thank you for noticing this.

