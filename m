Return-Path: <kvm+bounces-30802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D84439BD602
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:39:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DC5B280AB2
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067D4212629;
	Tue,  5 Nov 2024 19:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="ElRTCRTX"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831A91FF7AE;
	Tue,  5 Nov 2024 19:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730835584; cv=none; b=SSi7UF7F3HNh9aeG5KI890jo5/Fr2QDOWje7VJwD39XbWpKqqHrjFqGpTn4nAxwRo+njNmng+2O74SGIx64yTlJXXxDJEm5G7JeEqqOe5kVsBZo9Tv4M8cLNnRZfsCDsr8dk9GgRKu+fAaJDvv/NmVk529zKJGR1qlfo+e9xrTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730835584; c=relaxed/simple;
	bh=ZhBK97FUhcgex1j6IeiZEKWkxD39UOOVk384iRdbxbY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=g5jteVQyEFeX+msqOQXt7lbCwmU3n1x27D1WqwO5oUg2GuxfMgix0Awc32CpCFy2KNOKxlfvP3IBuxBabHvEu4hFSrbgADvxvT0ZE9VbQ7rkIYH1AByoOyLL8d1U1fXlS33szGsFEj7HbnbWyUC1HqR8Y949rVTEMitwuQGm4AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=ElRTCRTX; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1730835581;
	bh=ZhBK97FUhcgex1j6IeiZEKWkxD39UOOVk384iRdbxbY=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=ElRTCRTX2ZOePC1n9rfGgYkfPoKqQmb6yN39B01sF0MEfck2OyHjuFfkV7XnGCCzo
	 IdNdVbimwqeiR7rVECKoechA/ocmsGDAMfJEV7bV0ADjObkr12HAvdmTFsamvuejdp
	 qrWTksmRJTTSC22nWzUctzmnWBBAL6udTuMnfCgk=
Received: by gentwo.org (Postfix, from userid 1003)
	id 7D0DB409C6; Tue,  5 Nov 2024 11:39:41 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 7A3CC4026F;
	Tue,  5 Nov 2024 11:39:41 -0800 (PST)
Date: Tue, 5 Nov 2024 11:39:41 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Haris Okanovic <harisokn@amazon.com>
cc: ankur.a.arora@oracle.com, catalin.marinas@arm.com, 
    linux-pm@vger.kernel.org, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    will@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com, 
    rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org, 
    arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, mtosatti@redhat.com, 
    sudeep.holla@arm.com, misono.tomohiro@fujitsu.com, maobibo@loongson.cn, 
    joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
    konrad.wilk@oracle.com
Subject: Re: [PATCH 2/5] arm64: add __READ_ONCE_EX()
In-Reply-To: <20241105183041.1531976-3-harisokn@amazon.com>
Message-ID: <901a1fff-a747-fc44-31a2-95141c7eb7a6@gentwo.org>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com> <20241105183041.1531976-1-harisokn@amazon.com> <20241105183041.1531976-3-harisokn@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 5 Nov 2024, Haris Okanovic wrote:

> +#define __READ_ONCE_EX(x)						\

This is derived from READ_ONCE and named similarly so maybe it would
better be placed into rwonce.h?



