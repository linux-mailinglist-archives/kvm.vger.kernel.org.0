Return-Path: <kvm+bounces-28821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F49299DA0E
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 01:20:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C80DB282864
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 23:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D87541D5AA4;
	Mon, 14 Oct 2024 23:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="Zn8y6z+2"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7290A17BD3
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 23:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728948047; cv=none; b=j9fT+XzlpBa7CGbzh2hViCapf+d18cbeHjQBIVqpbAHzwiPih9qWxxjI8nrGkih8WjOS3WQusfx17QENjIbv2HTmhf+Yk5xur88lPYWFyJ+yRGrD8VbyMZDlHrCKLN3netmNpq02CmRBRLklSfv3XIKqXpRn+5aZ5CuQwtoJj20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728948047; c=relaxed/simple;
	bh=3TvgWcON0xdxuFv5aIikMKB2fi9PDo4ngObcLzSu594=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=NtkZpsTZJfAbNqQY+ABqqSnKPm/Jx54ATXVcx3LBcnoYIt1un/T51Iyll4zPFm+Yh1m/QEbS88M1VBZMjungZWlK9adwPmiaHUSaRzbGqALpHMJTndjjZachsFecZbep9TRxhUwShl9HONfD31brUEntWnTpXFLo8QELaDkw+5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=Zn8y6z+2; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1728946195;
	bh=3TvgWcON0xdxuFv5aIikMKB2fi9PDo4ngObcLzSu594=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=Zn8y6z+2mYfJdTZs6NWG3BgXmoQNaVQ4eHfFx1DrFA1tL9sT2sHVfCg98DETO41vS
	 Zux/me9G1Hr1r1zl+fNi7m75ViVuSGc0WILbma/FXg1sH73s/FtBrivdg4maYjwQiL
	 YsnC0Uy/Fz/Gr65/SDr9cifOMfvocG/IDu7qNZtM=
Received: by gentwo.org (Postfix, from userid 1003)
	id DE4D24040C; Mon, 14 Oct 2024 15:49:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id DD5E5401C9;
	Mon, 14 Oct 2024 15:49:55 -0700 (PDT)
Date: Mon, 14 Oct 2024 15:49:55 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
cc: "Okanovic, Haris" <harisokn@amazon.com>, 
    "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
    "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, 
    "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, 
    "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
    "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, 
    "wanpengli@tencent.com" <wanpengli@tencent.com>, 
    "mingo@redhat.com" <mingo@redhat.com>, 
    "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
    "pbonzini@redhat.com" <pbonzini@redhat.com>, 
    "tglx@linutronix.de" <tglx@linutronix.de>, 
    "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, 
    "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>, 
    "arnd@arndb.de" <arnd@arndb.de>, "lenb@kernel.org" <lenb@kernel.org>, 
    "will@kernel.org" <will@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
    "peterz@infradead.org" <peterz@infradead.org>, 
    "maobibo@loongson.cn" <maobibo@loongson.cn>, 
    "vkuznets@redhat.com" <vkuznets@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
    "rafael@kernel.org" <rafael@kernel.org>, 
    "sudeep.holla@arm.com" <sudeep.holla@arm.com>, 
    "mtosatti@redhat.com" <mtosatti@redhat.com>, 
    "x86@kernel.org" <x86@kernel.org>, 
    "mark.rutland@arm.com" <mark.rutland@arm.com>
Subject: Re: [PATCH v8 11/11] arm64: support cpuidle-haltpoll
In-Reply-To: <87cykhg8y7.fsf@oracle.com>
Message-ID: <c026a115-722e-e406-df8a-596b0088df5b@gentwo.org>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com> <20240925232425.2763385-12-ankur.a.arora@oracle.com> <7d76567549f81a42bf8f944dde3528b18cb3b690.camel@amazon.com> <87cykhg8y7.fsf@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII



Reviewed-by: Christoph Lameter (Ampere) <cl@linux.com>

