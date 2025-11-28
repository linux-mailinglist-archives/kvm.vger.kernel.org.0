Return-Path: <kvm+bounces-64942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E4FAC92D0C
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 18:40:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A89623AA5A0
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 17:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 871C3333445;
	Fri, 28 Nov 2025 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rgijs0N7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBEE1FC8;
	Fri, 28 Nov 2025 17:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764351588; cv=none; b=fHeEp2NCpMjgmtbwbgxgnwA0BE+oTTd4QQKRAgJufe5GlF3hEbxqKQht9ZUiYPjIUfgnIWl2+Gc2taEB9nRkWpZFJ1MHQX0q+rl8YDLNTuMr86aGDIwQVsk+8vjsfroeVrm9DnZEXAhUaSUId+NkySpFnPdbNvUcN3RO0t+sr44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764351588; c=relaxed/simple;
	bh=Sl2ZB6ngAeYwY4PKbLRZUWPfoexO5jWd1fAwC4TtqHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gNkWO3a/kk/XqU3RWgW7VmIFy4MI3wO6imYOuma8yrqUTcKm+372GbtVCRSZmdUH7qCJjoNwHqRn0ygjCvPYlZNQFQuldGIDzcPVvCxMwW/lHmHavqamLBzgAO97K+Q8TfcT4HgcFT5eBrSdjiLOiBw8rYrUIAvxn4XViffn/nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rgijs0N7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C556C4CEF1;
	Fri, 28 Nov 2025 17:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764351588;
	bh=Sl2ZB6ngAeYwY4PKbLRZUWPfoexO5jWd1fAwC4TtqHQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Rgijs0N76h3qbP6mc/JcNyd5GH2trTUQMbQRCSETL7wE8da1JE4MgvkgO9178eg5m
	 Wngaztmj5lkVbch3WdMXJeqZbm2bo94T/K4i5myuxVqX3MlzFGN36ZNuEXBAjM/DGQ
	 PuaCtd5AFm6jgu6/fwaW2v58W5eEAeQ6reERHY4pVcwkuffQZbXhnLrM63Sf+VKwZi
	 JIrmh95RzdMJ5rSAmlCSf9EnxXadQoAuUIk+m6wfymLXz2yqyIKZGJq3LzmSSOQXcm
	 8/F+47lBhkArPL6pELjabBcbDq9Uz48Cv9doLL2sx+M2YnUSemYiRc4IlQ2X3wyqip
	 dmETyxvFdnPlQ==
Date: Fri, 28 Nov 2025 09:39:46 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+ci3edb9412aeb2e703@syzkaller.appspotmail.com,
 davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
 horms@kernel.org, jasowang@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
 pabeni@redhat.com, sgarzare@redhat.com, stefanha@redhat.com,
 syzbot@lists.linux.dev, syzbot@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev,
 xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH Next V2] net: restore the iterator to its original state
 when an error occurs
Message-ID: <20251128093946.18c645c6@kernel.org>
In-Reply-To: <tencent_BA768766163C533724966E36344AAE754709@qq.com>
References: <69299e25.a70a0220.d98e3.013e.GAE@google.com>
	<tencent_BA768766163C533724966E36344AAE754709@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 28 Nov 2025 21:35:57 +0800 Edward Adam Davis wrote:
> In zerocopy_fill_skb_from_iter(), if two copy operations are performed
> and the first one succeeds while the second one fails, it returns a
> failure but the count in iterator has already been decremented due to
> the first successful copy. This ultimately affects the local variable
> rest_len in virtio_transport_send_pkt_info(), causing the remaining
> count in rest_len to be greater than the actual iterator count. As a
> result, packet sending operations continue even when the iterator count
> is zero, which further leads to skb->len being 0 and triggers the warning
> reported by syzbot [1].

Please follow the subsystem guidelines for posting patches:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
Your patch breaks zerocopy tests.

