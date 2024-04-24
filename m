Return-Path: <kvm+bounces-15849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 002208B10DB
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 19:23:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16000B2AC72
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D5816D4C3;
	Wed, 24 Apr 2024 17:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="VDJ1ZkhP";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="6ivm7y17"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35B815E7E9;
	Wed, 24 Apr 2024 17:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713979308; cv=none; b=RKicyyrbbIai1k3toMXi26hMp8f1x/Iq++jodRf+ybFxuCtGXjIUHP1nMBiNR0Gdj1QU+C9kV/c8Yoz4XIJbMBIaEaPIEpJ4OTQhZ08SVUTPRiWq2ghYXiZh7ae7FiE7jOfgpYI1uxkOB0ZqSprftsxad5gzms+wXZ9SKVacY4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713979308; c=relaxed/simple;
	bh=yWhj0o+HpJVDI3YWH2WAC02pq8ek+737Xwj6ZX/cwIk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kUKQduk3TpCjY5x6zavPc+ypkmsFShAQXxnVa4JlmAT+xOk7dzb0z2d/BS0oogWUvz4AdL9SiA+FTLrPqJZwI8Abymwr2piNCA5TPY37RFtKY3dk81I9VO4cTPiBehzeXZ7jmZzWeURZ/pj7jX45oFpf5TX/QiqyOi7uF2srjN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=VDJ1ZkhP; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=6ivm7y17; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1713979304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GxtJ8OShK36uXTc4XHgLpeP8rPXbYQataNV1BNHE+3U=;
	b=VDJ1ZkhPCbolPa6U0BU7/iQfGsvWyWHQTFALWjSUIRFAhDjYdt7++U3sy1e2tzXlzTqd3h
	xoHq0AOfcOrCOqp/hiVhnK8NKJpWezD7EgZzG/h7XxmrPt7gBFTsCKsZaLo3jmz1GU4u39
	X+PEh0h41PyAlwVSnzYxICLEBTd0ltJXPSXm+SxoVLFw+d+8L7Oxqwim62lKY0/QGapWaz
	gp94+cJts2jGJGEF5a83gL5fspWe732POGUBzc+IuXWv7O8AAiyEqZ0hsT9x0XSbnW1mjz
	RT2bodwaKz29Po54qnuLdxqM8Y5NavCYY+m7O/kcTzmGaLasjF4Skv5mnPC8tg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1713979304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GxtJ8OShK36uXTc4XHgLpeP8rPXbYQataNV1BNHE+3U=;
	b=6ivm7y17CYzedN6WQ/3cjqsWR3bQhEbybD9eoP/9H813uVV+BZ5tdLljKX3+nrHf+8kSVq
	1IDi4EGo59BBVpCw==
To: Alex Williamson <alex.williamson@redhat.com>, Nipun Gupta
 <nipun.gupta@amd.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, maz@kernel.org, git@amd.com, harpreet.anand@amd.com,
 pieter.jansen-van-vuuren@amd.com, nikhil.agarwal@amd.com,
 michal.simek@amd.com, abhijit.gangurde@amd.com, srivatsa@csail.mit.edu
Subject: Re: [PATCH v6 1/2] genirq/msi: add wrapper msi allocation API and
 export msi functions
In-Reply-To: <20240423150920.12fe4a3e.alex.williamson@redhat.com>
References: <20240423111021.1686144-1-nipun.gupta@amd.com>
 <20240423150920.12fe4a3e.alex.williamson@redhat.com>
Date: Wed, 24 Apr 2024 19:21:23 +0200
Message-ID: <87jzkmu164.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 23 2024 at 15:09, Alex Williamson wrote:
> I see in https://lore.kernel.org/all/87edbyfj0d.ffs@tglx/ that Thomas
> also suggested a new subject:
>
>     genirq/msi: Add MSI allocation helper and export MSI functions
>
> I'll address both of these on commit if there are no objections or
> further comments.  Patch 2/ looks ok to me now as well.  Thanks,

No objections from my side.

