Return-Path: <kvm+bounces-41220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15811A64C5E
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 12:24:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B877816592D
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E747A2376FE;
	Mon, 17 Mar 2025 11:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="n7DIt1V4";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="EkB5Bh0m"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A51236436;
	Mon, 17 Mar 2025 11:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742210615; cv=none; b=DcqYP41ZYzaAeNgyXPSW55y8XMKIjpZs+tPmXqeqaBRZl7Dg/vMnmErwO0JiDkLHAmSz6mJr4sDQYJ/TQ6DTpi3DZnUw/+9M+SWK+uJUDVf+JiKXo13lyGxOmRURH/OU4tlt/op1laeDszXwFcsuhmhy5eQ4j3J8Wv94q6ousyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742210615; c=relaxed/simple;
	bh=BskqoZk8kx31z3F+TjpC+yrdOnJ7xrtLK30hCHvlTVM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HmKJS5wUegKH93bJfI+k/tM8lpfhISlrdv37grPTigrQ3sx28BZrj+LJ1vmxDDXxV8gXTThYF0CQwjZgTg3siQ7X9WUeS31BKO4LDY+X8lpnKT0niasqaBJMzAqf2wtS7krS15jPQR3JcQDZh4OYrnf3REjfYqrJ7AxAUULBEe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=n7DIt1V4; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=EkB5Bh0m; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742210612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mR5w7dv6V2tvP4+g4T5l4E8xnyxdxPy5bDWWgB5XAtw=;
	b=n7DIt1V4xqRaUde/afopwCyonOy8midwc1h1yy0Gn+tpyMx0MTJ9Py6imCiaXqo7nHybvK
	wmRMznZopeIOR6+gJL9tsSkxUPM/On0fdapAeDKxqHJc/ZJNaBt/Z1iWqqmYtbyk5y4C1A
	fwacVbjNc+Wc47IUDzZi18kiybYgUZPBBOI5p7nVGRmgYBsNNxXqcM12ql1EJY3Gu3HtM7
	xnGMaufKlLhPBttaqW1pB5C8Qrh0jg+8F1l5bbAf/Ys6KjQWTbsBbcDRPHKntDVKUVyDU7
	NzaklEtytAjQDmLODneUalIFEhoWqS6qs0dwWX90iO5OBInIoRqSL5HfKQoxlg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742210612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mR5w7dv6V2tvP4+g4T5l4E8xnyxdxPy5bDWWgB5XAtw=;
	b=EkB5Bh0mPncGFsUQu+TjaCGDwf5DQTiUMPytAersokCLfWeFDiAzIon/xhqeLhxriiYaGf
	gll2Pc9NQYM1mOAQ==
To: Sean Christopherson <seanjc@google.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Jacob Pan
 <jacob.jun.pan@linux.intel.com>, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 1/8] x86/irq: Ensure initial PIR loads are performed
 exactly once
In-Reply-To: <20250315030630.2371712-2-seanjc@google.com>
References: <20250315030630.2371712-1-seanjc@google.com>
 <20250315030630.2371712-2-seanjc@google.com>
Date: Mon, 17 Mar 2025 12:23:31 +0100
Message-ID: <871puv6guk.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Mar 14 2025 at 20:06, Sean Christopherson wrote:
> Ensure the PIR is read exactly once at the start of handle_pending_pir(),
> to guarantee that checking for an outstanding posted interrupt in a given
> chuck doesn't reload the chunk from the "real" PIR.  Functionally, a reload
> is benign, but it would defeat the purpose of pre-loading into a copy.
>
> Fixes: 1b03d82ba15e ("x86/irq: Install posted MSI notification handler")
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

