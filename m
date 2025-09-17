Return-Path: <kvm+bounces-57842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B617B7CD92
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:11:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 337831BC731A
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 12:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4465F30CB36;
	Wed, 17 Sep 2025 12:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwMnEeaD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6995432BBE7
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 12:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758110935; cv=none; b=VoLC01XCnQrhEZvYy9LYRfJiWKPGIFuyCRIypUlD74xZyPwsawWs00n/beDwmw1LBRlBwJSR2MT0wOXU0vIKt+XSh6Dos4ZJ2gZW9mrbZA3TztS/2QhSrME/AOUare+dLAX7aUmm8H7cjKWfh/+mIkLoWqFLSMtdxQQoauNiRSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758110935; c=relaxed/simple;
	bh=0Vdd8/heToxawVfVMzRAJgHZ3pZ6X8uXVdFACJti+l4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksAMT771B++UMqtqeJGyRlVvpG6HcvGWHifAXu44uIZ0dB4pk74VVaeVnZebMk/fz55y4LR1/XSwtsVBQKGm5bahXbgOgT8KcOODM4QRhde6hcoq9Z/Ru5ULo1qpojdYbqBMBxXtKqt/72kx7S6Ga38j716OrR/OxCyjcT9s/lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwMnEeaD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A0AC4CEF0;
	Wed, 17 Sep 2025 12:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758110934;
	bh=0Vdd8/heToxawVfVMzRAJgHZ3pZ6X8uXVdFACJti+l4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fwMnEeaDMCdnj6p/qFUu3Rx+lkwedjxy/ouF2icKOVb4TnGmhwq+FIS2YM+nD7u1k
	 7HPbyi22RxwRbDIV9+8Em/BU0cipM9hwXqwSui+P5PNVdf5/UmFL71w+54Vg+EKsMk
	 9QAITe1AaF1iyiiYwSlMyts/Jw6KKmT5dep0PdDP38rHvTrll87FEEh/dLp4dF++QK
	 ivN7GPAj6M7eonNIgKCPWF6tfAGfyu7GiXhraXuQWJ4MqbaeLOTj4bMfmEpZ3tcGvb
	 nB51p+XyTtNePhaal06Q+cxo/Na9Y5iBogr282Z2saHQfjVt5lPdm61P3QQWkWkCmz
	 ht6A2Pj6/BqXw==
Date: Wed, 17 Sep 2025 13:08:50 +0100
From: Will Deacon <will@kernel.org>
To: Steven Price <steven.price@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>, kvm@vger.kernel.org,
	Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH kvmtool] net/uip: Avoid deadlock in uip_tcp_socket_free()
Message-ID: <aMqk0rMpUgexhZY5@willie-the-truck>
References: <20250912073357.43316-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912073357.43316-1-steven.price@arm.com>

On Fri, Sep 12, 2025 at 08:33:57AM +0100, Steven Price wrote:
> The function uip_tcp_socket_free() is called with the sk lock held, but
> then goes on to call uip_tcp_socket_close() which attempts to aquire the
> lock a second time, triggering a deadlock if there are outstanding TCP
> connections.
> 
> Rather than call uip_tcp_socket_close(), just do the cleanup directly in
> uip_tcp_socket_free().
> 
> Fixes: d87b503f4d6e ("net/uip: Add exit function")
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  net/uip/tcp.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/uip/tcp.c b/net/uip/tcp.c
> index 8e0ad5235240..2a6a8f5265d9 100644
> --- a/net/uip/tcp.c
> +++ b/net/uip/tcp.c
> @@ -109,8 +109,12 @@ static void uip_tcp_socket_free(struct uip_tcp_socket *sk)
>  		pthread_join(sk->thread, NULL);
>  	}
>  
> -	sk->write_done = sk->read_done = 1;
> -	uip_tcp_socket_close(sk, SHUT_RDWR);
> +	shutdown(sk->fd, SHUT_RDWR);
> +	close(sk->fd);
> +	list_del(&sk->list);
> +
> +	free(sk->buf);
> +	free(sk);
>  }
>  

Cheers, Steven.

Rather than duplicate the guts of uip_tcp_socket_close() here, how about
introducing uip_tcp_socket_close_locked() which doesn't take the mutex
and then making uip_tcp_socket_close() a wrapper around that:

static int uip_tcp_socket_close(struct uip_tcp_socket *sk, int how)
{
	int ret;

	mutex_lock(sk->lock);
	ret = uip_tcp_socket_close_locked(sk, how);
	mutex_unlock(sk->lock);

	return ret;
}

then uip_tcp_socket_free() can just call the _locked() flavour directly.

Will

