Return-Path: <kvm+bounces-25725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDB09696B0
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 10:14:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B70A1C238F1
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 08:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9539215573A;
	Tue,  3 Sep 2024 08:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fIkpiwrs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4666201248;
	Tue,  3 Sep 2024 08:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725351276; cv=none; b=IpgYxetj+Ppd5b9W0DoLXyvSNUO1wONWCPX+sNGWyhqXpdwSOXQt4kgq9898tizaQD6DTc6PPQa/gdaLRdU7kBQ9rq5jT8tmfzh4M3PJqBjcn6yyAXw+EG3u+UN7gTFowKCoPYn6eusSJQrS5m64FoiI2xwn4V0hE4tMJhnmyIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725351276; c=relaxed/simple;
	bh=3DDraNTAYfSy5dcsAD8q2KdN/7krhd3xEZQb+wQ3cI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P9Pn5WA/XvgRexYcmOZ0kNIyXuurcViLBF9wCGHp4smRkGlWH95xlVobw+uId+pER7C8rspM6VqlH0VxnBH7zE2eIG1/TuwcGisb/kHbVNjJThZ4TVrCENLsa4ZBAnl0qD4F/oGQhOWsdLQ2WPovaqoLv/S4mX+TZi73M5XCv+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fIkpiwrs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5968AC4CEC5;
	Tue,  3 Sep 2024 08:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725351276;
	bh=3DDraNTAYfSy5dcsAD8q2KdN/7krhd3xEZQb+wQ3cI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fIkpiwrs8GKR8Ejk0AM0/lW0+6w8/vsKc5e06UoL0zU3JQAkKbH6QTYvaALZ8pIyk
	 h6vyXP576Fc5NPEX5oG8SbIrZKjuBJWUpYNfuPe6rWlMcM1IB7mh9uoLYMFe85hJFr
	 2NMWOhJfi4MJmubprsx3owsN2V+AhgCW9CPmkrTpB8hvO6jTKErgHCOgSGoH4Q8d6H
	 ZdOwUeQUkFHZADwEMiWsOX7NxA8PXQxXachZ9pP0L541nNNKNy7YOHQbVfUiUKosMi
	 rH11Xj2LDLnNOSl/HB+t1V+m0QiMaFXqpZASREW3ebMZQwchvQsXgCKrYe8vzUBght
	 VjflRrA9zVRPg==
Date: Tue, 3 Sep 2024 09:14:27 +0100
From: Will Deacon <will@kernel.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com,
	vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org,
	peterz@infradead.org, arnd@arndb.de, lenb@kernel.org,
	mark.rutland@arm.com, harisokn@amazon.com, mtosatti@redhat.com,
	sudeep.holla@arm.com, cl@gentwo.org, misono.tomohiro@fujitsu.com,
	maobibo@loongson.cn, joao.m.martins@oracle.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v7 08/10] arm64: idle: export arch_cpu_idle
Message-ID: <20240903081427.GC12270@willie-the-truck>
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
 <20240830222844.1601170-9-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830222844.1601170-9-ankur.a.arora@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Aug 30, 2024 at 03:28:42PM -0700, Ankur Arora wrote:
> Needed for cpuidle-haltpoll.
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>  arch/arm64/kernel/idle.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kernel/idle.c b/arch/arm64/kernel/idle.c
> index 05cfb347ec26..b85ba0df9b02 100644
> --- a/arch/arm64/kernel/idle.c
> +++ b/arch/arm64/kernel/idle.c
> @@ -43,3 +43,4 @@ void __cpuidle arch_cpu_idle(void)
>  	 */
>  	cpu_do_idle();
>  }
> +EXPORT_SYMBOL_GPL(arch_cpu_idle);
> -- 
> 2.43.5

Acked-by: Will Deacon <will@kernel.org>

Will

