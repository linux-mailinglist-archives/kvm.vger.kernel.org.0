Return-Path: <kvm+bounces-32784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA459DF297
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2024 19:37:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 751711626DC
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2024 18:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C831AA1E9;
	Sat, 30 Nov 2024 18:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+XmOBBn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FD6158D87;
	Sat, 30 Nov 2024 18:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732991826; cv=none; b=m9iZuUx40qrzaCOcTn3orIXcsDxij4qxIYVJccglf10BwvvKwTUqxIV/rDhyu9cEMO/vBFb3FAnqRZGtB0F5moUczAAhij9c0q4fefP2EK/g1SP3JlUYiRSuR+naiNTReTKy+S6xiQXdJ+8Y++l+kg5QRffUn6ajdCV/7B3pWw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732991826; c=relaxed/simple;
	bh=5CGTaXv3qcM8izuf0G3IuTtdL47UzEnEwiMt4SQGzng=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uCNEOCdgPlvwHXM5ppffZOM0TJJHAIg8EeuZS+kpJ93c/2drN80aZLhCIJi1fjIHvUi8I3wlSJCzfixH1j8AlmODN+4yNML7NT0KvmuYj8KN/JEd+bBz4Sf2haO3Xj0c/Rk8Genli6pxfL+zeEOXczfIwoQA6W8yXeT/cnLBKmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+XmOBBn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DB7C4CECC;
	Sat, 30 Nov 2024 18:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732991826;
	bh=5CGTaXv3qcM8izuf0G3IuTtdL47UzEnEwiMt4SQGzng=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=d+XmOBBnXCHc8xl+sEgI9y+sZ5RaJrGt+nMaEjJkVWI+Ty3E8L09wNPJyfoLgOBoH
	 26b4kVnQqfA+A1HDsTVdRTYoZPRt6Rm+hv0DAXA67CBbmA3GoQ7gOXmlFLMTov5fbN
	 mXNWl6FDYESyMi/HCbpiwBmDgHqZY26Txb9raGcxAnmrWh/SEtndPr39io9ouRqmy4
	 oJmcTYJungsIFblLM5Vq+xtlGIdT4ZJkCA0U/ottWVndfKk2KLsEBLndE1pVY0g8NE
	 xLGN/rGljtqhJkbi9C7Y/3O1wdEPGm+3gTp2mYeEtTgLl7sK7Bw8tE4EVi9B5k7ugM
	 ogPHQGCdM26hg==
Date: Sat, 30 Nov 2024 10:37:04 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Yury Norov <yury.norov@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>, Maxim Levitsky
 <mlevitsk@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Shradha
 Gupta <shradhagupta@linux.microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Haiyang Zhang <haiyangz@microsoft.com>, Konstantin Taranov
 <kotaranov@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Eric
 Dumazet <edumazet@google.com>, "linux-hyperv@vger.kernel.org"
 <linux-hyperv@vger.kernel.org>, Long Li <longli@microsoft.com>, "David S.
 Miller" <davem@davemloft.net>, Leon Romanovsky <leon@kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Souradeep
 Chakrabarti <schakrabarti@linux.microsoft.com>, Dexuan Cui
 <decui@microsoft.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: mana: Fix memory leak in mana_gd_setup_irqs
Message-ID: <20241130103704.7129538f@kernel.org>
In-Reply-To: <Z0kjRcX1hXYQhw2Q@yury-ThinkPad>
References: <20241128194300.87605-1-mlevitsk@redhat.com>
	<SN6PR02MB4157DBBACA455AC00A24EA08D4292@SN6PR02MB4157.namprd02.prod.outlook.com>
	<Z0kjRcX1hXYQhw2Q@yury-ThinkPad>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 28 Nov 2024 18:13:25 -0800 Yury Norov wrote:
> > FWIW, there's a related error path leak. If the kcalloc() to populate
> > gc->irq_contexts fails, the irqs array is not freed. Probably could
> > extend this patch to fix that leak as well.
> > 
> > Michael  
> 
> That's why we've got a __free() macro in include/linux/cleanup.h

Quoting documentation:

  Using device-managed and cleanup.h constructs
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  Netdev remains skeptical about promises of all "auto-cleanup" APIs,
  including even ``devm_`` helpers, historically. They are not the preferred
  style of implementation, merely an acceptable one.
  
  Use of ``guard()`` is discouraged within any function longer than 20 lines,
  ``scoped_guard()`` is considered more readable. Using normal lock/unlock is
  still (weakly) preferred.
  
  Low level cleanup constructs (such as ``__free()``) can be used when building
  APIs and helpers, especially scoped iterators. However, direct use of
  ``__free()`` within networking core and drivers is discouraged.
  Similar guidance applies to declaring variables mid-function.
  
See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#using-device-managed-and-cleanup-h-constructs

