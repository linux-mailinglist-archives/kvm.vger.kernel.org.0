Return-Path: <kvm+bounces-55752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6271AB369F9
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 16:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFDC91C41691
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 14:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B6035A2AC;
	Tue, 26 Aug 2025 14:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="LwzQTsWT";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="A6j3O2ty"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778D535083D;
	Tue, 26 Aug 2025 14:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217722; cv=none; b=o1ZnJSOgsaQjcvzEPUVSMITNW1zkFVs5r5yXdkPnoWgjIshBfWuslF/rpIEpJ534ftMXmxXRJznYTj5KNxD1xgsO3AbHdjAyCcHGrGJkaxt7FFj60fdCn63Evx6DU7rFLVQR8s442smQ+KX29Q5PwW6IMbA21HkHXUrCP2lWfQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217722; c=relaxed/simple;
	bh=EOBColXHYti+tdwPYRTPX55zWbuLqPbuLsls/+AgNT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFEBJNx4aeoBtWl9oFBHVgjtvc5vwMYONKVyaQFUABsaug6tUBV24eHPNxJi6+k5KYl8D40kazfgw1EVRURWm+4e5r+1ekE/z7bSmWqqYvrJ5m70vKDLbXz3lB2Czq7+Wj6zSb07zf0BfbkZPc3fIJOLlh+fE38P4gPCXD2KyuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=LwzQTsWT; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=A6j3O2ty; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Tue, 26 Aug 2025 16:15:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1756217718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JD9Mbivfzta1IsMjGhVlMntp+L8qXG49mI8iNfMcMUs=;
	b=LwzQTsWTBoWDx37sRi3tb0PU3Ajs+jz/IKfgLiKgj3SNBo81PY9cpOHKLYzAL7M7X9vCRs
	FZGI/1VLSRkZcuHln0iZ5qfz+SM1eDSijuB/Vi9uZjAVk0Y33yZKTr4FE/s74aZGZmT4h/
	O8TAdexVcIbJJkCKyG75v1S+xn56WRN7XgJP0e8vXbA5qQEJ3ucKNNv6VZFFd5o9Oo9v/o
	XWmC0xk9Js+MZ8isbL1alwMkXPg0W1s3qGoXJrBsrCiu8+nevAS+W5Bu69sGuokDrvlDCp
	xgZQVQkjEkXrLyta5s3CeLOfEagrmQej97s3+K1uhaWYNuITz22ijE4mbjqPmg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1756217718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JD9Mbivfzta1IsMjGhVlMntp+L8qXG49mI8iNfMcMUs=;
	b=A6j3O2tyCWBZzBRinhAyFlVtysNem2GxcBdeDD2YKoHgxzqgkyMt4mGki+3QnNz32c7ZgL
	BbCCPDifu1NpmFBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sean Christopherson <seanjc@google.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] vhost_task: KVM: Don't wake KVM x86's recovery
 thread if vhost task was killed
Message-ID: <20250826141516.f_jWThaV@linutronix.de>
References: <20250826004012.3835150-1-seanjc@google.com>
 <20250826004012.3835150-2-seanjc@google.com>
 <20250826034937-mutt-send-email-mst@kernel.org>
 <aK2-tQLL-WN7Mqpb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aK2-tQLL-WN7Mqpb@google.com>

On 2025-08-26 07:03:33 [-0700], Sean Christopherson wrote:
> And the call from __vhost_worker_flush() is done while holding a vhost_worker.mutex.
> That's probably ok?  But there are many paths that lead to __vhost_worker_flush(),
> which makes it difficult to audit all flows.  So even if there is an easy change
> for the RCU conflict, I wouldn't be comfortable adding a mutex_lock() to so many
> flows in a patch that needs to go to stable@.

If I may throw something else into the mix: If you do "early"
get_task_struct() on the thread (within the thread), then you could wake
it even after its do_exit() since the task_struct would remain valid.
Once you remove it from all structs where it can be found, you would do
the final put_task_struct().

Sebastian

