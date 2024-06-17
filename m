Return-Path: <kvm+bounces-19791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 87DE890B501
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 17:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 737901C21AB9
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 15:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 870A5158D9B;
	Mon, 17 Jun 2024 15:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0Egcz5w"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E511158D77;
	Mon, 17 Jun 2024 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718637604; cv=none; b=cYOIqCmaSwn21GEghdL7yigR8DSpHUb5Ss5QoijOKtK+r+G+5I2UNkD1g51mooJoO5/NXBnwB3XZ1OHor58ztN/Qt0PeygAKNKHwOhqZY4ejbtb+9GedwLEjMqlkgkyZCZCsgczgr8/j+n9UiMG2Kw8WYNg5YHrlKsHTc8rHi4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718637604; c=relaxed/simple;
	bh=9jJLrF/6NbGsgQCvXVBt2x6elX8/EKdyI2Lp4Ov7Puo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gIn9lrgCJpMyiE30euXhcY/7fTawsqaWmFC/0qzYdlhaO95ZpiDfpNnWIanj1tDOCyxzP0Z9gtyQRvoN3e2G6BzhMnSY/xZTV4KjH4S5FKF4Och9/7yD+CjfWcg9qLCRUBMHxTX4QGfLELmCKUVTkSclRpwexlfkjP5JMhcoCgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0Egcz5w; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34F1C2BD10;
	Mon, 17 Jun 2024 15:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718637604;
	bh=9jJLrF/6NbGsgQCvXVBt2x6elX8/EKdyI2Lp4Ov7Puo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=b0Egcz5wY6JJJbRJH2mJFg5nSWE0RQ5nxe5jOaXHpK9HpjJ270esJtCpRCwruMWTW
	 x/4mrJFaVgVt40jkUhq1qLNGp6O8JxSI9UGq0OrBHx1rRZTG6wxvjPOn/ppwm+X3gK
	 KfvHbXLD6U1YdS6Pyv+YwJRI4b9D3g09o9ptfDy3eGr3QZ09ipRA8XBbb3+LasYFhz
	 hawzEYBp85tfKfU+/HYlzhr6LRN0JA7plSXGNpLbX/lsuAiB5QoQ6lQqnzqtPxXT7D
	 2AVgXredJjvRuuaV+5J+6qF05XljQaer6vA0zYiKH5VTXS7OIyLVZ+H8lPlIm/ZBi0
	 uIlvM5Ke9jjyQ==
Date: Mon, 17 Jun 2024 08:20:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Parav Pandit <parav@nvidia.com>, Jason
 Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>, Dragos Tatulea
 <dtatulea@nvidia.com>, "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Message-ID: <20240617082002.3daaf9d4@kernel.org>
In-Reply-To: <20240617094314-mutt-send-email-mst@kernel.org>
References: <20240611053239.516996-1-lulu@redhat.com>
	<20240611185810.14b63d7d@kernel.org>
	<ZmlAYcRHMqCgYBJD@nanopsycho.orion>
	<CACGkMEtKFZwPpzjNBv2j6Y5L=jYTrW4B8FnSLRMWb_AtqqSSDQ@mail.gmail.com>
	<PH0PR12MB5481BAABF5C43F9500D2852CDCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
	<ZnAETXPWG2BvyqSc@nanopsycho.orion>
	<PH0PR12MB5481F6F62D8E47FB6DFAD206DCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
	<ZnAgefA1ge11bbFp@nanopsycho.orion>
	<PH0PR12MB548116966222E720D831AA4CDCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
	<ZnAz8xchRroVOyCY@nanopsycho.orion>
	<20240617094314-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Jun 2024 09:47:21 -0400 Michael S. Tsirkin wrote:
> I don't know what this discussion is about, at this point.
> For better or worse, vdpa gained interfaces for provisioning
> new devices. Yes the solution space was wide but it's been there
> for years so kind of too late to try and make people
> move to another interface for that.
> 
> Having said that, vdpa interfaces are all built around
> virtio spec. Let's try to stick to that.

But the virtio spec doesn't allow setting the MAC...
I'm probably just lost in the conversation but there's hypervisor side
and there is user/VM side, each of them already has an interface to set
the MAC. The MAC doesn't matter, but I want to make sure my mental model
matches reality in case we start duplicating too much..

