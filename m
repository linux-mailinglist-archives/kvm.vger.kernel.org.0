Return-Path: <kvm+bounces-28831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6DD099DC2F
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 04:20:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7A131C21810
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 02:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA60515C145;
	Tue, 15 Oct 2024 02:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="UuhaH9Fw"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7289313D291
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 02:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728958847; cv=none; b=kTxqTE/T5CJVup2+HdIoZZntDWy95FIr7Fp8Uv8feVyP2DHKdDc8S7oEvl0oK0LCq19ZVKXnHSId35BA+JTdtS1Yd95hazU9lkUQpqj/1TKMP2jdmJSBESEqEQ2Qqh6/gA59rrrMyXk3u1fCPKwZJ734vYgYCDR5Siuh4yvENiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728958847; c=relaxed/simple;
	bh=rbt8SkxR1iACaDm6wm6SE57BvzP3NPL6AS2wZDrZWAU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=oF7xnL3UHhxfbyrj8SaAWE+R4Gq35xnMEm45u0xHEOK/RcyxVFOHOAThcJVF2L24d57CRBvHK8D1EWLAVpAYJGzTelJi/SVXBMXQt9LfPVjbUAW3xUCQpXruQsCJC9roKV0d38ZLlDel3qXQaJdbrmK5tSlBYbcZyzP3g0edkLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=UuhaH9Fw; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1728946106;
	bh=rbt8SkxR1iACaDm6wm6SE57BvzP3NPL6AS2wZDrZWAU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=UuhaH9Fw3nUVXiIMIAgKTjlfb2XhLnEUkHxGXgASDpBzHEszGqvs5wZozinS0RQjh
	 AryISVdCNgzJXRgheeDhfpJbh3VneEsddjjN3gSHQ/mxFhpyAHcPNI1sM/gbGRQCFr
	 n6mgJa37xWY2mXR3m3PVydVFAYD+aKm7rCZYo3Bo=
Received: by gentwo.org (Postfix, from userid 1003)
	id B804D40262; Mon, 14 Oct 2024 15:48:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id B6C72401C9;
	Mon, 14 Oct 2024 15:48:26 -0700 (PDT)
Date: Mon, 14 Oct 2024 15:48:26 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, 
    Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com, 
    rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org, 
    arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com, 
    mtosatti@redhat.com, sudeep.holla@arm.com, misono.tomohiro@fujitsu.com, 
    maobibo@loongson.cn, joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
    konrad.wilk@oracle.com
Subject: Re: [PATCH v8 09/11] arm64: select ARCH_HAS_OPTIMIZED_POLL
In-Reply-To: <20240925232425.2763385-10-ankur.a.arora@oracle.com>
Message-ID: <5125f975-48d5-3b00-c7d0-3d71554b8dcf@gentwo.org>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com> <20240925232425.2763385-10-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 25 Sep 2024, Ankur Arora wrote:

> poll_idle() uses smp_cond_load*() as its polling mechanism.
> arm64 supports an optimized version of this via LDXR, WFE, with
> LDXR loading a memory region in exclusive state and the WFE
> waiting for any stores to it.
>
> Select ARCH_HAS_OPTIMIZED_POLL so poll_idle() can be used.


Reviewed-by: Christoph Lameter (Ampere) <cl@linux.com>

