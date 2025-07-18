Return-Path: <kvm+bounces-52891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C1BEB0A519
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D73F75A18A3
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 13:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFC72DCBF1;
	Fri, 18 Jul 2025 13:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="QXi7FKZJ"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866E329824B;
	Fri, 18 Jul 2025 13:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752845162; cv=none; b=dkfYMPnWOWPVqwy0qfdxxr5S90yU7SPo1WLJb2n+SXi17xFJx3CF987oLK58OPrETW0L3pPhAWSDetVf5kbZ1/5gKDhVTvo0+WFKSXj62fhyM3sQK/qHWCZhzxMbunOqVx1BBeqKVEz73dxJnEYkvwobcRcPAKE/GhmQm64F3EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752845162; c=relaxed/simple;
	bh=yPn3Ujsrz1O6i/sbCiSIVoSWdNDDE0vK/MdFMfUAV9s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GQT9toVhMZbl3WwXxXI2DFQWi5wT+GAI8Sd0/9HkaONFyeOxoIriEkKqJlMlLM5Lh21FUTZJp+GxSA9so9E9SKD3k9oPCa/RvZcEo3OxsTgFdBo8lXit/izcupiSb4lIFtQaoMKur/JlhP97ZRaHFnh8nNtg9OjQE8Rw6egSixM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=QXi7FKZJ; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:110d:0:640:50bc:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id A7D99806E8;
	Fri, 18 Jul 2025 16:24:31 +0300 (MSK)
Received: from kniv-nix.yandex-team.ru (unknown [2a02:6bf:8080:56e::1:20])
	by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id EOO4ZJ2GxuQ0-lvAz1N9s;
	Fri, 18 Jul 2025 16:24:31 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1752845071;
	bh=yPn3Ujsrz1O6i/sbCiSIVoSWdNDDE0vK/MdFMfUAV9s=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=QXi7FKZJFFS2RQWnQp6iO4PlRDaMgFXCXteAVzxKTPzetrSUmafAzyHgK/406mUqz
	 +u/VvstxDeKVgbHN6nKXuY205yzMsHwO1N5rpUzX4TD2u6WYmnNz0SokP5PmzCkYwg
	 Ou/lETf5QNUgGXYDBB4yLzTJujHP5uNOf8kKl1Mo=
Authentication-Results: mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Nikolay Kuratov <kniv@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Hillf Danton <hdanton@sina.com>,
	kniv@yandex-team.ru
Subject: Re: [PATCH] vhost/net: Replace wait_queue with completion in ubufs reference
Date: Fri, 18 Jul 2025 16:24:14 +0300
Message-Id: <20250718132414.1572292-1-kniv@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250718124657.2394-1-hdanton@sina.com>
References: <20250718124657.2394-1-hdanton@sina.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> reinit after wait, so the chance for missing wakeup still exists.

Can you please provide more details on this? Yes, it is reinit after wait,
but wait should not be concurrent. I checked multiple code pathes towards
vhost_net_flush(), they're all protected by device mutex, except
vhost_net_release(). In case of vhost_net_release() - it would be a
problem itself if it was called in parallel with some ioctl on a device?

Also rationale for this is that put_and_wait() is waiting for zero
refcount condition. Zero refcount means that after put_and_wait() calling
thread is the only owner of an ubufs structure. If multiple threads got
ubufs structure with zero refcount - how either thread can be sure that
another one is not free'ing it?


