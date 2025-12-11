Return-Path: <kvm+bounces-65692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2852DCB4C4A
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:31:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 266C1300BEC0
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5179D2BDC3F;
	Thu, 11 Dec 2025 05:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aF20OH89"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A81729B79B;
	Thu, 11 Dec 2025 05:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765430509; cv=none; b=um2DfD2yGGXu9X1Khu7LH/SyO2qIJ7tur22cmdxP+dSybcOqpyw86ijl7mLMfeHg7dsKI/8u62e9VWFd+Imh0X+xpUjbtUUfpG0Oe7zEisPLVyxsrjh+FJjs1pLOrjoAnEWxk6wO13VxTWPGM3t+hJkV6f5n9V9MH46+ablU8HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765430509; c=relaxed/simple;
	bh=OMWsm1iBM7byGpIJdrYg85fUijHjOw33YpJot5aABSc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EFvTugDry2vfqcgnaeM9toG3c+cdxDtslNCGhwSJZGd0/44kGhFKHLYuSpBHt+j0mP5P3HuOE/WqiVTDrAHuK+gTbHFLqVhHMS/1mi2tVxNH7AF6dXZmZA6oeQF8lWmZt1Qy7kBaZTPXlE+l5N6YQ1A2hJpi7EYuUoYy2VL4Hxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aF20OH89; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933F0C4CEFB;
	Thu, 11 Dec 2025 05:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765430508;
	bh=OMWsm1iBM7byGpIJdrYg85fUijHjOw33YpJot5aABSc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aF20OH89Ffbbj7fjscKp8MVFjvoDVbV4Gbz/uHfJ20fwrtG3I1W/yQ0yHzUGmkE5/
	 8sxUFAaYGBUllnti4MugpG5bLPk46TLiyU6YBwqZY3PMZYkDAZXOjsNUhrZMX5ktes
	 uBoZFyWbX/HfYk2nuqAiwBXkDhnACArodGys9LDivdWq9YpMEP9ubdawH8E85pKJyc
	 jJeB6Z3KRywtRYtcJvDrKUZd4Lp9wbiXfSW7Bys7iapkANCYDo/nlYFAMgD2p913IA
	 23vPklcn7anqmZnH/1zJFj16oLsBZ8SN22nlyCFN5XODQLYhXxMWZAZliXWLhbggK2
	 7BBfji3AVMW/g==
Date: Thu, 11 Dec 2025 14:21:42 +0900
From: Jakub Kicinski <kuba@kernel.org>
To: Edward Adam Davis <eadavis@qq.com>
Cc: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
 horms@kernel.org, jasowang@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
 pabeni@redhat.com, sgarzare@redhat.com, stefanha@redhat.com,
 syzbot+ci3edb9412aeb2e703@syzkaller.appspotmail.com,
 syzbot@lists.linux.dev, syzbot@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev,
 xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next V3] net: restore the iterator to its original
 state when an error occurs
Message-ID: <20251211142142.18a4a0b2@kernel.org>
In-Reply-To: <tencent_000364896CA3A544481764D76486C0336005@qq.com>
References: <20251210173125.281dc808@kernel.org>
	<tencent_000364896CA3A544481764D76486C0336005@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 Dec 2025 18:03:14 +0800 Edward Adam Davis wrote:
> > Have you investigated the other callers? Given problems with previous
> > version of this patch I'm worried you have not. If you did please extend
> > the commit message with the appropriate explanation.  
> Are you asking if I investigated other zerocopy tests? NO.

I said callers. You're changing behavior of a function, is it going 
to break any of the callers.

> The test results [T2] for this version of the patch do not show any
> failures related to zerocopy.

