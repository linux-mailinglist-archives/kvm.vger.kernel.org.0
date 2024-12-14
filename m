Return-Path: <kvm+bounces-33824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B68F09F2053
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 19:39:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA88A167103
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 18:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A318D1A8F7F;
	Sat, 14 Dec 2024 18:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oBA5WTgl"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1585F3D96A;
	Sat, 14 Dec 2024 18:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734201570; cv=none; b=VoPurDihiSsNUDO2MzPzFtto3rTZZdd8RQ3dXeVC7G8DT6iGJqKH6xoufuN67C3/hm42gKDSBs7at0v/N2PGgoAr4tyU3rNr6jFHe9/o9G5M8gCBeiYQKthmN9c78ha6E+MQ8De7fvoWzNT9TkOFQzzweg8c0AQdyjZT44oBGuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734201570; c=relaxed/simple;
	bh=690nWsXz4Lf8yy+mzkl2dnwSFpMN1lTj0VULWgijlAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mggyI7yRoAADiRLCcDrmXV/F6m7HUC45gU/f+EWyi7eRwEw3HA/RoxV67Jy50us8bF3rZH8l8QTjXEWKc9QW+SPGnNbyAFT4tZy/6z1CaAR0WZmgJLd5dF93Z5GZhd9Yt1dl9C0TYir6KrpwkqsdWo3wJ6IpR5UIw761p/PNwwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oBA5WTgl; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uEzDBKUgWX6jFkMv5xG4qzSLHSlbdmivdkGAeIJ/mE8=; b=oBA5WTglzbT94FzYbKTyyMZT8O
	T84h7fLYg9ZWCKUlaCIQX66FGXqejGTz0echBNFiJY8ksiLRqqQ2HUIhzVqRDYQxbkwEZebpQOKdK
	D04mdZ0KZ2FX7PUpaRlvdifIvv09KnhEJCaE9MOGg/LVdTLmb5JRzGF4CDR1TSDPF2/MtC4v+VFLw
	emX/qE/CMjVIHztj0rUl9p7qa5HbEvVqq2TKx2SIOEoIKwUdexyDEJEGMPBP0A4RGbMIlIcixTTWm
	PyP2rf+OeRz2CtbIKzRySrc9c+1xwWLHbMQospqim7cZPdI404VCuwU+W9NPk0jUiiL6OwT5fzDNx
	JoV7BeIA==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tMX2z-00000004OWx-2QfO;
	Sat, 14 Dec 2024 18:39:26 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CF0E930035F; Sat, 14 Dec 2024 19:39:24 +0100 (CET)
Date: Sat, 14 Dec 2024 19:39:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ranguvar <ranguvar@ranguvar.io>
Cc: "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
	"regressions@leemhuis.info" <regressions@leemhuis.info>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [REGRESSION][BISECTED] from bd9bbc96e835: cannot boot Win11 KVM
 guest
Message-ID: <20241214183924.GC10560@noisy.programming.kicks-ass.net>
References: <nscDY8Zl-c9zxKZ0qGQX8eqpyHf-84yh3mPJWUUWkaNsx5A06rvv6tBOQSXXFjZzXeQl_ZVUbgGvK9yjH6avpoOwmZZkm3FSILtaz2AHgLk=@ranguvar.io>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nscDY8Zl-c9zxKZ0qGQX8eqpyHf-84yh3mPJWUUWkaNsx5A06rvv6tBOQSXXFjZzXeQl_ZVUbgGvK9yjH6avpoOwmZZkm3FSILtaz2AHgLk=@ranguvar.io>

On Sat, Dec 14, 2024 at 06:30:11AM +0000, Ranguvar wrote:
> Hello, all,
> 
> Any assistance with proper format and process is appreciated as I am
> new to these lists.  After the commit bd9bbc96e835 "sched: Rework
> dl_server" I am no longer able to boot my Windows 11 23H2 guest using
> pinned/exclusive CPU cores and passing a PCIe graphics card.  This
> setup worked for me since at least 5.10, likely earlier, with minimal
> changes.
> 
> Most or all cores assigned to guest VM report 100% usage, and many
> tasks on the host hang indefinitely (10min+) until the guest is
> forcibly stopped.  This happens only once the Windows kernel begins
> loading - its spinner appears and freezes.

Do the patches here:

  https://lkml.kernel.org/r/20241213032244.877029-1-vineeth@bitbyteword.org

help?

I'm not really skilled with the whole virt thing, and I definitely do
not have Windows guests at hand. If the above patches do not work; would
it be possible to share an image or something?

