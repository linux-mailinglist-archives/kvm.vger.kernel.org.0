Return-Path: <kvm+bounces-68855-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mIpdEV7AcWl+LwAAu9opvQ
	(envelope-from <kvm+bounces-68855-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 07:14:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EA74C62304
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 07:14:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 361554E278A
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1314A47D934;
	Thu, 22 Jan 2026 06:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iy75tLp1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A0E32E690
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 06:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769062478; cv=none; b=aF66/h8rQb7flWQ7GbNw4hzt4w/L8a8mIA96Zthh3FPkgmvL5NHt+k7a4y4NIbRkkDF7JE43R4S+2FPwZiGrj13CLf12sVQfIkHiBggMfcO8Yinaab14kw9+SBZNCR6F6mXBL92jQZ7wCX4j2Ka38InGL7kvQiB9cx0VjNa/cd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769062478; c=relaxed/simple;
	bh=nQVBvMHuljtX2xB4yfQiA5xv6fNGoHeJDz1JEMTQMnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ng2nT8+cKLrTo7ac0Juh+MadRrYNAz1BSKbqlZbdN9rfmGr6/C5K9aBRT6DlJTi9Ib3NOjxIDaRF1cB5RRauFIV8w2JCGUPZ9Ica//K12Rgv1Q1NnvMuTjI34zkIYYSz0jbKjG5K9BRhjfaVYEcEyMwKGxrLaOAMushOmGXKZ3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iy75tLp1; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a76b39587aso29975ad.0
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 22:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769062476; x=1769667276; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3G4lHNqBolWBEs1VWBwMzRnnAhuwEdr1C7HQPPvGpZ8=;
        b=iy75tLp1bP32slZSKeR3uNQDcO93TtWIYrhxuAWZRY8jURlcotKEMpTRzRcI0+GVxD
         l/lrQPNE+VvLsXdqr9TyCrIBXodAKkgLCC0zVbbyObzIKGgpV/FtcDa3hSdLT3OJb1TV
         +k76c0QtPg+ktJwkxqiXTVakP+AkIh+imUsN3yK+pppcJI1au5ejYK9kMCpRzP7guqVy
         E0hZufqIj4TA7qD3Xb6lmT8wAvZTvdEr9tTYOkuwn+2Y3T3DY0kOGJafuxK3AEOlZCAx
         BptYIzJbFcAhPzenRqjnnmrfDfBi8AjbiC2PhpSFK67sm1Hfzbl/+DlElpJwy2DJ1maE
         4tqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769062476; x=1769667276;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3G4lHNqBolWBEs1VWBwMzRnnAhuwEdr1C7HQPPvGpZ8=;
        b=OZd6Ta2B6Lqa4LLxraVFoSf667nWkAMysBw8dP02gFBO9qrm9W4QbJJrzbY0fupD98
         /oP8j1iyiUMWxlKwwqwAS91K7kkwR+TIy0WhXs7pCEVbRBclwE//cWqkh3KdwVbfelnt
         MKZ19vUKAR9qGpKQTFza/zNMjv1dPurf5PLztV9/FkFVdVoVujp7IF0nVsVsWAho6FrK
         bht8GftgVqzzIEtnGrRBymQI9gjLroMyW2T2bNbOlO+cisUhwHuEC8rr8qlMMMxgqXh/
         crhyFGeTTS+yJs8upM/rG/LlHvqXayQmfuLIGGQuK8GedloLlFslX83rTPJqJGbnh+ac
         c+Gg==
X-Forwarded-Encrypted: i=1; AJvYcCVwNV0hsMn7DPe8peSRK0Omyuk9hR1qA+yuK/4ejQrOBR6t/2gCfhvQaLMAaJ1mMWTZeCM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo3eVczvhfVe9HhWRxHfXPf2vitxgYcXKyEJ0hnLMFpcdheVnj
	E+SM/9jb5vXu4u7m+eNnd/mEFVcpvw5uBHNxeUHvpbzzjgqvKTsyw9DpdYTeSaprOA==
X-Gm-Gg: AZuq6aLbqn5/3FFKqdHg4QSFfRu65XhlzP+q4G/XG9Hfo75uhpiwUqVuVjF9xh6nQ0Q
	9McWV6fv4m5OkAGJzxoYpO4KZkzcILeseW/a26yPzP5B+yFehORAPaqhA82eKd8+vmY9hOiNhOX
	NU6Mb5ciu/RL9NK15MfFB9mfPlGaH9A0SAaJU5Sv9vPv7EEXoQ+HzJ/+yBQNsoik1Sa7ARGlKCW
	UHEE7Z26L5edbaOBoOntnXw48aooZp9AcH0PttWY0MOt5PR0xzvLtchzgZDJl/r8y2Tl+wNaZgX
	VRsSEODPN/cKH/Z/2u/THDUVAIv+h3a6lo62MYlN3rFvBtX9Ln7xBPt3o2hYzOhCSPuV2cvo1R8
	DTW9hZvPX2Ajda63eRoX9YO+EYx1ZZbGWFmeZRRbPNlYplDNpxT9emu3AeOePBbZwyEFjl6AE1e
	D3g8IaypZOlJMMlLKDRb5kt00tcQHmIsD8I6NgBLe4KxkqisHj
X-Received: by 2002:a17:903:190:b0:297:f2a0:e564 with SMTP id d9443c01a7336-2a7d673e47fmr1307235ad.11.1769062475657;
        Wed, 21 Jan 2026 22:14:35 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa10e8059sm16855579b3a.30.2026.01.21.22.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 22:14:34 -0800 (PST)
Date: Thu, 22 Jan 2026 06:14:29 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex@shazbot.org>, Ankit Agrawal <ankita@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfio-rc] vfio: Prevent from pinned DMABUF importers to
 attach to VFIO DMABUF
Message-ID: <aXHARbpAM9lRuwTN@google.com>
References: <20260121-vfio-add-pin-v1-1-4e04916b17f1@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121-vfio-add-pin-v1-1-4e04916b17f1@nvidia.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[google.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-68855-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[praan@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,nvidia.com:email]
X-Rspamd-Queue-Id: EA74C62304
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 05:45:02PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Some pinned importers, such as non-ODP RDMA ones, cannot invalidate their
> mappings and therefore must be prevented from attaching to this exporter.
> 
> Fixes: 5d74781ebc86 ("vfio/pci: Add dma-buf export support for MMIO regions")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> This is an outcome of this discussion about revoke functionality.
> https://lore.kernel.org/all/20260121134712.GZ961572@ziepe.ca
> 
> Thanks
> ---
>  drivers/vfio/pci/vfio_pci_dmabuf.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks

