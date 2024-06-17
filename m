Return-Path: <kvm+bounces-19802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5B290B6CA
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 18:44:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1F901C23648
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 16:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D28C1662FB;
	Mon, 17 Jun 2024 16:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a8Sl0b7q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251B315F411;
	Mon, 17 Jun 2024 16:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718642663; cv=none; b=uWnxja0/k8ldy2vLEbW144hvyXsLZSwy8TEwFGnN9r1YfcsfEbHlaxopJBTtr+pgUzrVdCMgSKA2+gwOXT1RwDhEyfE6I432wBACeqLxo2L2n6KN5e55c8vzvtvF5ZEXRhLHHkyiLbHsUNyHmXu8dEzKX8nhBWchyXiC2h+Jcd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718642663; c=relaxed/simple;
	bh=bAwok2w5sDP9uSS8/aitt6u/za/o92q1BPRXfbSXSF4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PPElgbs/DHLKO5u+nxBTeVN6jeSPj2U1qVvj5BFlRShzfdfetIHDOnYaLhEEDuPa7U+h25aSHuWZtAqW2WueFghmwRg7SpnSit0yMh0Up13cg6yO6uOKbcNOoyhZV5n5dKGcnrO82B1zD7XQimJrXzhTFjBVrY1rJbwWOj6b7Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a8Sl0b7q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C045C4AF49;
	Mon, 17 Jun 2024 16:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718642662;
	bh=bAwok2w5sDP9uSS8/aitt6u/za/o92q1BPRXfbSXSF4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a8Sl0b7qpaha1QMp71OCXfr2vSE/3r1mHkBm3sV9wzCTAvWuz+r9jaKzuLAw1R9qd
	 ml/1W7WPnNouDIUN6XFg6c/Wrn6v8E/Z8YLKWcB6TJQwbaoOCTgbirmifO5tCbqDGc
	 bBm0c7TBMnKDom1KH6MiloCvC/dGCJp2H7VsfV5x8tYLPEbxVQzXNIA9eAVqB5t8c/
	 KGc6QIIOazLIm6TOMebtFp8IKjE+AQdWCa31uEv/GHIWgaFP286EZcGgR+5pjyav52
	 Cr7l63Iz11hPxGtu0iYBGyaYFiwRkuXU2EUXy9KCEZGn+thaGZSWrxanV0h/Fx+l3L
	 VPAtHMOncmY6Q==
Date: Mon, 17 Jun 2024 09:44:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Parav Pandit <parav@nvidia.com>, Jason
 Wang <jasowang@redhat.com>, Cindy Lu <lulu@redhat.com>, Dragos Tatulea
 <dtatulea@nvidia.com>, "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Message-ID: <20240617094421.4ae387d7@kernel.org>
In-Reply-To: <20240617121929-mutt-send-email-mst@kernel.org>
References: <ZmlAYcRHMqCgYBJD@nanopsycho.orion>
	<CACGkMEtKFZwPpzjNBv2j6Y5L=jYTrW4B8FnSLRMWb_AtqqSSDQ@mail.gmail.com>
	<PH0PR12MB5481BAABF5C43F9500D2852CDCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
	<ZnAETXPWG2BvyqSc@nanopsycho.orion>
	<PH0PR12MB5481F6F62D8E47FB6DFAD206DCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
	<ZnAgefA1ge11bbFp@nanopsycho.orion>
	<PH0PR12MB548116966222E720D831AA4CDCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
	<ZnAz8xchRroVOyCY@nanopsycho.orion>
	<20240617094314-mutt-send-email-mst@kernel.org>
	<20240617082002.3daaf9d4@kernel.org>
	<20240617121929-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Jun 2024 12:20:19 -0400 Michael S. Tsirkin wrote:
> > But the virtio spec doesn't allow setting the MAC...
> > I'm probably just lost in the conversation but there's hypervisor side
> > and there is user/VM side, each of them already has an interface to set
> > the MAC. The MAC doesn't matter, but I want to make sure my mental model
> > matches reality in case we start duplicating too much..  
> 
> An obvious part of provisioning is specifying the config space
> of the device.

Agreed, that part is obvious.
Please go ahead, I don't really care and you clearly don't have time
to explain.

