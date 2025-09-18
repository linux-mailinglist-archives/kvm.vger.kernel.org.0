Return-Path: <kvm+bounces-58025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8409DB85C67
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 17:51:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5438B56375C
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 15:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 591C6313D6D;
	Thu, 18 Sep 2025 15:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="YSn6dRHQ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="kJ55i08D"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E490D313D43;
	Thu, 18 Sep 2025 15:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758210511; cv=none; b=gzNGLdsV4hLW/cLOL9dj3oZpOy2KisnNaCdDIcBAmLqc3hUT2ekgGF30spcHlDFYI/2GBrKzFvveCyWupHNYQe08NrvFBEWFuwgpLcGUus8D2widXxOdFBbKVnlSFIYdseOHUo+nqOJoxCj+0tN98kWvpvOvSU5IQp95/5Vkwe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758210511; c=relaxed/simple;
	bh=YgBNR6Vxlftl1RN2hSfit2dxOkVAxDFkoZ3/7oCA18o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H40qU0GktOAocSDxjFWThnfL/eBTLVQhA1LbIwaH3jkDsAEkGw98Q1CfjBqkxJhpti0rVeTl8L02n0j1AXE3Qya7pSISQYDXXs3o/onUJNFe7oo3EAYwfDSXvhAIc1BWoUc9Orzk/x+GSztDgNL827yY327iQTj10ilsixAHjdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=YSn6dRHQ; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=kJ55i08D; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Thu, 18 Sep 2025 17:48:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1758210507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YgBNR6Vxlftl1RN2hSfit2dxOkVAxDFkoZ3/7oCA18o=;
	b=YSn6dRHQnZevXJaqhbqYbjuVda7CJgcl3dect5etouquUECjSS8ppQwfNnMI3H+EBqv0M6
	0mClkw5ATV6+izHyir+7OZvceWW2HKMVkXOQ814NDwbeMBwQsjVStpIBYaUGzaJJbWealf
	W80MpS0ihubRP+WYtEs1vJmIZW1aruy2RVTuj8+AVVrAWVOF+zKtwjSrHxg+t5sSdvcSeq
	L2GPnbj8qFIN6L62Pq/NsOXLwpUxN6Gsdq4DomKjSN1dswi6gcel1b9ln2hjIER/mafSWG
	VaEiIDLxAebOc3CgRuSaUR6Eu3kat7O58y9cyFW22QCRFOn/1LJebrjfMc2c4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1758210507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YgBNR6Vxlftl1RN2hSfit2dxOkVAxDFkoZ3/7oCA18o=;
	b=kJ55i08D5AVx1RtbPHbOmckzP5yOYzMbd3KVWTiteiBocYNiCYSh8BrJIxIBkdJ+DbeQah
	IgNaJJUktCluTGAA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vhost_task: Fix a bug where KVM wakes an exited
 task
Message-ID: <20250918154826.oUc0cW0Y@linutronix.de>
References: <20250827194107.4142164-1-seanjc@google.com>
 <20250827201059.EmmdDFB_@linutronix.de>
 <20250918110828-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250918110828-mutt-send-email-mst@kernel.org>

On 2025-09-18 11:09:05 [-0400], Michael S. Tsirkin wrote:
> So how about switching to this approach then?
> Instead of piling up fixes like we seem to do now ...
> Sean?

Since I am in To: here. You want me to resent my diff as a proper patch?

Sebastian

