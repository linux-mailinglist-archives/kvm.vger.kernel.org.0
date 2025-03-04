Return-Path: <kvm+bounces-40051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 611F6A4E62D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 17:37:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B378D18848EB
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 16:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB3429C338;
	Tue,  4 Mar 2025 16:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="low0mfZj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F272BF3F8;
	Tue,  4 Mar 2025 16:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741104447; cv=none; b=dMLgKipV0YVB2sq6mHJ/HhUFJrcACqXzqakgUiN4lXUUEM9B9MK14wPNF53EirqNFM1osktMLj5/E0pU3b/TmiBG7SqeDJQTlgFgVb5UPSBZAUkkCazErKaWMqDNamW/RHLLLXnF87r+s1bBkH0KLEojuBkKlGRRX/QjSApM0/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741104447; c=relaxed/simple;
	bh=zz+2QTOiTV+dibCRD/W2dLI9OFzMrQ7krWX/6mFhwnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d0+1TzUJyo5xVM7rVip02C21BBgcMeAOWYBewts+XmZnVcuLjF+M6PdDXCVDvy+eZKL+LL+2ZmblO+zjSje1u7S8WlDuvEgHWgDAId/GsWZmy1AvQBrYnBVAx0xDn2pzmokRsz9CwO9hs/C/xVbWnSFDR/v0I5mWeufM9qeNmgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=low0mfZj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DA2C4CEE5;
	Tue,  4 Mar 2025 16:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741104446;
	bh=zz+2QTOiTV+dibCRD/W2dLI9OFzMrQ7krWX/6mFhwnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=low0mfZjrf91gWK/YVjZeF6fhfxLdK729wEdhkw5gvFT+MR4J5sVu/uNUvqLLPmGr
	 /Uf4DVbzpZ2F9dsZcPx2vGCeWlHRm0ak3lNcT6r5mP0VeghVYx3vfclhQxHp07A9Jb
	 JMHvc7fAej7b12CEE7HJ8sWSSVKkZIQ8B0vex/nVW8POX2Hlosmh0fLmbqt3ha2lm/
	 EH30ZgbiRmlDSbo8IZk+w8IjigZhTWyley8my8sVqj35BuZwZzjEdTZ8Z8QV+LwK+A
	 Lxi11kzJfJKY8a2GuixrQ031/NtU9yu8tCoGU7kRz8rf9qSSF7xQWBhDt3FI5ebc3k
	 UfuuiaZqVzxFA==
Date: Tue, 4 Mar 2025 09:07:23 -0700
From: Keith Busch <kbusch@kernel.org>
To: Simon Horman <horms@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, seanjc@google.com, pbonzini@redhat.com,
	kvm@vger.kernel.org, leiyang@redhat.com,
	virtualization@lists.linux.dev, x86@kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCHv3 2/2] kvm: retry nx_huge_page_recovery_thread creation
Message-ID: <Z8clO24vFqlDdge4@kbusch-mbp.dhcp.thefacebook.com>
References: <20250227230631.303431-1-kbusch@meta.com>
 <20250227230631.303431-3-kbusch@meta.com>
 <20250304155922.GG3666230@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304155922.GG3666230@kernel.org>

On Tue, Mar 04, 2025 at 03:59:22PM +0000, Simon Horman wrote:
> A minor nit from my side:
> 
> As you are changing this line, and it seems like there will be another
> revision of this series anyway, please consider updating the indentation to
> use tabs.

The patch is already applied to upstream and stable, and I think Paolo
must have taken care of the formatting because it looks good in the
commit now:

  https://web.git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=916b7f42b3b3b539a71c204a9b49fdc4ca92cd82

