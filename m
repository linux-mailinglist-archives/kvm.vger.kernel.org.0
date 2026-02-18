Return-Path: <kvm+bounces-71295-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YG3OMT1JlmnedQIAu9opvQ
	(envelope-from <kvm+bounces-71295-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:20:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E4E315AE15
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4C9F93031810
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27B4338936;
	Wed, 18 Feb 2026 23:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YmsiCGYm"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FCE33AD92
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456811; cv=none; b=Tmr8HtdxADyg19fJqAw987PXpHeRhGfenuhYYU1+npmVX/vaH1nYX7BUoSnuOwOvLsmWW6CS4t/K9wt51gV12SmxvablaGnbW2ZdfY3mMonpXQy0LjRJS9Ps2EdtydhmFSrIrS4QEgSckToz+spcBwAuHQi4QU1PepqcVROEKkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456811; c=relaxed/simple;
	bh=T2LBunHYDCyyAhnDiLIy6aex5rrQTT0m6VtjkBLduE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GJO/fk9VBfWUgs3fc35ZfxQTjU6CveXr42J1nwabF3seEVf/73KXsbdaOZKzHcmTTe3p/CjbzyaRv/e0sTu0hwPcV1o+VbibuGnXE6j15kPi2lyTY5ZK1Y0ZGDJYzEKQoMJwJKal9vfu4SAuKxYW/XcwJ5Mj57OFcsXSmWEgGnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YmsiCGYm; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 18 Feb 2026 23:19:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771456797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zMQVlWHh9HlDl1Z5Rz8rwZPvBWNM0YIOdiVlh3GaJOg=;
	b=YmsiCGYmgYOXoExyKb5BDxs+AYIN56O3SlEEUyMrBdYuNmwhpnLp7HvksOT/E+L9C84Igg
	mVLaXZRs9dxPCaoEtTlw+fWY+0cM+59fLvZ3sVhpcot5EUeAQaKfKqadhz8RWDauVct2RJ
	inOYV6bgRD6+6mWIKsTNJhxzd7DxpS8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/8] KVM: SVM: Separate recalc_intercepts() into
 nested vs. non-nested parts
Message-ID: <xwe2vpjzsycygihteyz7xawfz4y3psxyoc7t5ugnxfvskyknwo@oztj7jd356tx>
References: <20260218230958.2877682-1-seanjc@google.com>
 <20260218230958.2877682-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218230958.2877682-3-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71295-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 2E4E315AE15
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 03:09:52PM -0800, Sean Christopherson wrote:
> Extract the non-nested aspects of recalc_intercepts() into a separate
> helper, svm_mark_intercepts_dirty(), to make it clear that the call isn't
> *just* recalculating (vmcb02's) intercepts, and to not bury non-nested
> code in nested.c.
> 
> As suggested by Yosry, opportunistically prepend "nested_vmbc02_" to
> recalc_intercepts() so that it's obvious the function specifically deals
> with recomputing intercepts for L2.
> 
> No functional change intended.
> 
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

