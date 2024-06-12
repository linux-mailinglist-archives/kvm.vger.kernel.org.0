Return-Path: <kvm+bounces-19412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8D2904B9E
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 08:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 562EFB22C39
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 06:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED2A16936B;
	Wed, 12 Jun 2024 06:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b="0hYGDPhT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF374CDF9
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 06:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718173801; cv=none; b=uu5x4lw2j+nZPxy+G/UbLdb/PUt8iQSURmz3vgxBq6HdtKLaFS29vNei2NC88+l5CIiaYPOeDw7aaOd11j3jBKdSKyL1LnDLDhV13Lwq/VeKsDS3mNmEiV88L6kqOacawFRAa/GTlrFcUnMNeRb1HGACBhw4gg18ut7HPSonYU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718173801; c=relaxed/simple;
	bh=Dw8KIMMn+F28OFpTAhQjzDCM2P9ytOTncCAHmd6nIHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PO3tWgsvI1eEKhdYDC/9EbT4UPn6aKTxhkKzv1yB93vFcBjXxvcMRxNRGoeiLavGLJ62JdFrA9tKsBf5nzNcdYrxiV4PB/UPluJyh2T/4izf/wZ1jpJhGihezfSs4xZTWwouCGYjHr5bXwPWNAFKsVSL88hjz8kmFGeZQQ2jjRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b=0hYGDPhT; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52bc1261f45so5010843e87.0
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 23:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20230601.gappssmtp.com; s=20230601; t=1718173798; x=1718778598; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5LH8e3qpcjluJss2hNPudK/MPhEV4gW+gLGQ/ZThC0k=;
        b=0hYGDPhTrP5DabeRqTvEnFuUoZWnORKBU8CLTKH0A0qO0Ih0BcoPlOczkFx2/EGhLk
         iO6lpFy/tSpQ/FuiRlomrdjp84kvZbiEiMVifwfvCwNjKCZesboHLSNzJcZXdietSsiO
         8sHKS/1DkGxaIr3F4fAu2pmNrgUd5t6bDHPC/itLJ66ic43hvsgu8HsEuJGsS9RYLN+R
         +1d67dHVs/HdTq2EODGcogUJK5j/i9EqCVWcsjbXwvMO4hbuwBOsnokLIZXVHNjk5BJD
         oX5xppbcuN6Dw7RWcryH3SPhqk4hMTz7+Pz4l2pJdYRlhYL24xx14pSpQnt/ZqOUAvIT
         IkZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718173798; x=1718778598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5LH8e3qpcjluJss2hNPudK/MPhEV4gW+gLGQ/ZThC0k=;
        b=Q6+lcaGBo8/IaA0zxf2ma8dbr0yJKZGr7uatPzoGNk/vXEdBYnnXlphJTTVXuG1PPf
         AyoYWZ1O/bEEV4y/lBCCUhDbVyhVvCLf6NYDBj6STij5LLtvJZ90/QY3X9zhUy6LaZSg
         UjUEImL1OJTeHWdEVe92Gla/hVkancuTMxoalNaL/pAEb4sDnWimrGgN+fxBWZFoE/bz
         Vr9A4GfdKhtalPP8aQGfZyTQdObmKUYOGwM0s0U2YczLVQtJe+n2j6k1TEawx8t6VLvX
         rOWNlYn0wcXuKkhuy0HMIJZDTu1XuxfmE98VHSbBldfs8unCVkFhxtWsQArYgJ/6/jEJ
         vspw==
X-Forwarded-Encrypted: i=1; AJvYcCX3yVfMJre+C6UtkCQV78KVp9htjJjP41dntqeEn6cjsHFtwAsdl5N9kjJsm66bW+66PGbKm1m34etRIF9hIrBRwbvF
X-Gm-Message-State: AOJu0YzD1VkDfX5C++bn4rfhYcovHodvqhmuFCTH6ClDjm43oNH3m7wX
	v46XYOQjMEgS/hsyUH6oCGQkl5fO/tdZJRm70RIOVelLuCwga4xqREZgCur4gTY=
X-Google-Smtp-Source: AGHT+IFp/68HMGdtt+tnnGcItdNkBhSFo46K5V4Iw0bDMZtwLsT4wVHxdkIyBopwMlohpTWvO6o3cQ==
X-Received: by 2002:a05:6512:1313:b0:52c:8abe:5204 with SMTP id 2adb3069b0e04-52c9a3dbeffmr624591e87.32.1718173797669;
        Tue, 11 Jun 2024 23:29:57 -0700 (PDT)
Received: from localhost ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42286fe75ebsm12495135e9.9.2024.06.11.23.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 23:29:56 -0700 (PDT)
Date: Wed, 12 Jun 2024 08:29:53 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Cindy Lu <lulu@redhat.com>, dtatulea@nvidia.com, mst@redhat.com,
	jasowang@redhat.com, virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Message-ID: <ZmlAYcRHMqCgYBJD@nanopsycho.orion>
References: <20240611053239.516996-1-lulu@redhat.com>
 <20240611185810.14b63d7d@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611185810.14b63d7d@kernel.org>

Wed, Jun 12, 2024 at 03:58:10AM CEST, kuba@kernel.org wrote:
>On Tue, 11 Jun 2024 13:32:32 +0800 Cindy Lu wrote:
>> Add new UAPI to support the mac address from vdpa tool
>> Function vdpa_nl_cmd_dev_config_set_doit() will get the
>> MAC address from the vdpa tool and then set it to the device.
>> 
>> The usage is: vdpa dev set name vdpa_name mac **:**:**:**:**:**
>
>Why don't you use devlink?

Fair question. Why does vdpa-specific uapi even exist? To have
driver-specific uapi Does not make any sense to me :/

