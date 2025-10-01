Return-Path: <kvm+bounces-59294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32786BB0982
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 16:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3AE73B7F0F
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 14:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B433F30215A;
	Wed,  1 Oct 2025 14:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="enmNegtf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC26230171A;
	Wed,  1 Oct 2025 14:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759327249; cv=none; b=F9wQIH1kE+Yk6MnbQU3/ge5ZQD1WxlDNRby+goa5xx6JDniLqB+NmFlm0IKTRts9oljzZSOqiZALB6iabuIGjUii0i/7hHCtFLwxxj26V01u7RdJlb+BiU/Xl6UQuyUuEgnKqv3iRm+LUHOdLhM3e/fMSw1PtOD2ncgLUaRy8yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759327249; c=relaxed/simple;
	bh=pOd1BvnuzhfzaFifmVUeHSLOXMN8uAeuiuOhBxWEacA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fUokCtwR7qTEF4aql8EVxuUXdfnJXgi5xVHKF5BHt7eeK3eabGNywvorpTJYCoIRVCjp0dpvrm5xo565uJs3JNozQXqYkoZMY0Et6Xriy5mv4VCSzTRYFRoZ6rxga3mxgqpueEc7VrbIdyoEiDnWcbQxLwmary0+4LmtO2rN3t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=enmNegtf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E72C4CEF5;
	Wed,  1 Oct 2025 14:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759327249;
	bh=pOd1BvnuzhfzaFifmVUeHSLOXMN8uAeuiuOhBxWEacA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=enmNegtfjCmxv7B0haPoSP+16jl1bWZm1STOzUMfW1Ww1EBmr+33tqzjZvfswIjvB
	 RX8rXA/izNUsxyDxPaTFa8+zWUXDEOMS75bXznnSdzRtfikgd6LPV7a7tZSVuWf8N0
	 ZRkXgcMPZMxnZVA1FHzLCDHmnxzKR/77iw6m80R6aiEduzS1rHFSWEhAYvS+BDAIy6
	 DLuKj06+iPOIIVfwsdR6btAWve4ltyHunBUJirBi0srkvML73h+SJo5R3d2gBVqp8q
	 Agf5busOQ8M8EINAbS11fDZ2UsfBoaIN+lbao+Mf1mJx1ZS/pae1IKdqGoDHmkK4uJ
	 ym840VENb1coA==
Date: Wed, 1 Oct 2025 07:00:48 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: patchwork-bot+netdevbpf@kernel.org, linux-kernel@vger.kernel.org,
 zhangjiao2@cmss.chinamobile.com, jasowang@redhat.com, eperezma@redhat.com,
 kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH net] vhost: vringh: Fix copy_to_iter return value check
Message-ID: <20251001070048.29d71d65@kernel.org>
In-Reply-To: <20251001071456-mutt-send-email-mst@kernel.org>
References: <cd637504a6e3967954a9e80fc1b75e8c0978087b.1758723310.git.mst@redhat.com>
	<175893420700.108864.10199269230355246073.git-patchwork-notify@kernel.org>
	<20251001071456-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 1 Oct 2025 07:22:00 -0400 Michael S. Tsirkin wrote:
> It's probably stable material. Does netdev still have a separate
> stable process? I'm not sure I remember.

Not any more. FWIW Paolo posted our -next PR earlier today, so the fix
should reach Linus within the next couple of days.

