Return-Path: <kvm+bounces-20738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7B9291D4AB
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 00:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9695D2812E2
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2024 22:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67FAF7BB17;
	Sun, 30 Jun 2024 22:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JsKmgDkC"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E7274047;
	Sun, 30 Jun 2024 22:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719787679; cv=none; b=Y51dJPvlF9qUV2vYEhCN/gM6N1+PHV4ZAhM007cDeJvN2ncEHyaqZ4fhc4izO9MkFfma2LNnYPkWs06I/qtCebltztIGX5NDMxODaX3HmnuCT/Kkqkb3X1r4yCtjfjt8+CenSFp54OLcoBLjlo6imJyB1Zt06/V93lsfa6HH3is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719787679; c=relaxed/simple;
	bh=RIC6lDHSzZtXB+D7SloinnSD1l7Tk7yMuJN2fdG+AnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOZzmkLXbvTgcVRjnWkEw+yLNYxivTNPsc076NFOBobFFS3tZjrtjCu48/z6y1pZvvdqnCAefQyGcGKCMYrN7sqoXgvyiRBp+Ex0gg7o0Z1dcfcIq4Shao61sYv/lvSXqUauutwdJBvrCGUvBz6Zc4iwktyQMp8kLkiz6DdlRl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JsKmgDkC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0MRFLh85YS1Qw0yjRTcIq2eP7WQdtKPZJO85E9hAJFU=; b=JsKmgDkC4v+xIpHl23pfRrlpDC
	XbqGJq50HJ3xZM8acYsae1kKCm33ZxdSYY14zp7MuflWzTatkujKKBEQI/rqNun8F+I8BQB4dF2S8
	yzBVFbojyt79DaL6oCG1zHEqnuf3DJmCn5k1v+vRkmreWT7cyPSzw0NXdYw5Nm/eP22QKwWq0Fhxn
	FTCTjWgJDHlOPtz91CGrQ4+mQbAJAgq+ecnmWPUHXtbow1Nw8Cj/LRVHUVLMhKw/DHlIzDoq5xNof
	RnqQ1roqlJO5++uTFnow0erNz60YMR9EggQYfJAv2tvOmcB3qkf1otkB+MeswnjcOnfsW9jdXbeA5
	HNumMMPA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sO3Kv-00000001B8l-2Lok;
	Sun, 30 Jun 2024 22:47:57 +0000
Date: Sun, 30 Jun 2024 15:47:57 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org, kdevops@lists.linux.dev,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: [Bug 218980] New: [VM boot] Guest Kernel hit BUG: kernel NULL
 pointer dereference, address: 0000000000000010 and WARNING: CPU: 0 PID: 218
 at arch/x86/kernel/fpu/core.c:57 x86_task_fpu+0x17/0x20
Message-ID: <ZoHgnfJpBekFoCkF@bombadil.infradead.org>
References: <bug-218980-28872@https.bugzilla.kernel.org/>
 <ZoHaVmNbFGcejSjK@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoHaVmNbFGcejSjK@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Sun, Jun 30, 2024 at 03:21:10PM -0700, Luis Chamberlain wrote:
>   [   16.785424]  ? fpstate_free+0x5/0x30

Bisecting leads so far to next-20240619 as good and next-20240624 as bad.

  Luis

