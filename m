Return-Path: <kvm+bounces-23449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F78949BB4
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 00:59:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 133A5B27C87
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 22:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E623175D28;
	Tue,  6 Aug 2024 22:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t9OqXWrr"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8275516EB7C
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 22:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722985174; cv=none; b=qdKU1Hr0dBDDkMrHtxK34eyQ5VtoSYOfQV5GttldhSv6tEC0ecDuRgwVYmHsCLw0c+dRLSgSSsbHTFJHxDD117xt65/gbb2WLOO26b3CBYF2XnLkE2Ui4Gm8L2ZUvkqx7qce6gNrErfx7k82YYQv2SwsUtdoKOSyVWY9Su2fYVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722985174; c=relaxed/simple;
	bh=ds9pqJh7H9fMOWP6se75ivaqlkU29QAObaWXCWyWx9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N8vRzIt3lDneEhySfFDbzKWCxa6k2VcDRAu7Brhf6Zv0AbeIlIIndRSCPpPZig0dXGVrcDG5iw1qnuvjv5aRk9pjTG+gbpTqY7SVQxWL86+bTZz5/eId7ptqJT25/mPiHpjBW8kXUCJy+P7RfJ70w9Ff27zhmY1/OQqiNCwGmxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t9OqXWrr; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 6 Aug 2024 15:59:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722985170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=czRgRDeRzLrqBrQivBvizwUbT0h+w1TNXUGWQtXg8MQ=;
	b=t9OqXWrr8NixYPqY6nc80jW99/6NeLrV2HCWr6yUBunDx7UPLELnjrVzzN4qoVfPhsxF6V
	L6OSjGitosA6JNlL/hEacVd+VrB9M1fL3dtNs6ZO646Z7Wh8G5DUU5Z+ZEnbcF90hyMc3C
	hjA1wKcVQKSff/vgqIJ2ORksr/t65Uc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve Rutherford <srutherford@google.com>
Subject: Re: [PATCH 0/2] KVM: Protect vCPU's PID with a rwlock
Message-ID: <ZrKqzrPF_y4momna@linux.dev>
References: <20240802200136.329973-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802200136.329973-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 02, 2024 at 01:01:34PM -0700, Sean Christopherson wrote:
> Protect vcpu->pid with a rwlock instead of RCU, so that running a vCPU
> with a different task doesn't require a full RCU synchronization, which
> can introduce a non-trivial amount of jitter, especially on large systems.
> 
> I've had this mini-series sitting around for ~2 years, pretty much as-is.
> I could have sworn past me thought there was a flaw in using a rwlock, and
> so I never posted it, but for the life of me I can't think of any issues.
> 
> Extra eyeballs would be much appreciated.

Besides the nitpicks:

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

