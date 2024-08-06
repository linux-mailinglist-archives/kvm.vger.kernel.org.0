Return-Path: <kvm+bounces-23400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A56B949536
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 18:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30DF91F26804
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA3314D6ED;
	Tue,  6 Aug 2024 16:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kA0SOGOH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566115BAF0;
	Tue,  6 Aug 2024 16:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722960179; cv=none; b=KCE28L8bnzXmFBMZujlP5p+KhxH30V9XARNg/5FwYL38JbT2j+a19L8IEgS3aquEhxTYEIdY3eYo/93/OYXKEapgm8ci6pssQ71I1u0/x2ECTUnr+bxa1bXtqL1NraGV0q7cwN6qExrROhbwxlVde4xJd6tko3omVSydGAI6R3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722960179; c=relaxed/simple;
	bh=TzW0RlBqqnf0yvfs+npWBSjNiD/6KUFoSIWrNvneOq8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eMe4nN4XceV+NR9+W5q4VO7t3rhhQOCb74rpCHd5KNYNxaOWRM3gvUyjPnJwAeDEMJp7u2ehokCvrxsEDQUgf3kHaW/rA4JEyzggg1GYuCq8OzXtS/JYdGJVRKMsQbxdU0NhkvqP0D/AvMhFUUamNkbdz4U7mXfICXjtGszLWGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kA0SOGOH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8B5C32786;
	Tue,  6 Aug 2024 16:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722960179;
	bh=TzW0RlBqqnf0yvfs+npWBSjNiD/6KUFoSIWrNvneOq8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kA0SOGOHJ+ykBZ54s0oFiLL2QjUzPYFjGwh9g5jWTi1Cx1t2qO0wO0jqTOxJEFdZl
	 DmZZgOV3nANenJZw2ne1d+sHoIejT5ujqYItHPGw4cXiUuO3EDWEchUxp4StPExu88
	 8eeQqsOAO/qqivGSjgiLdgKZYH6SJfMtWS25G3FQExP1YQK1qr9TTYwrigPcdTV00J
	 CjX/zlyUcT2vvusenuFS5EKo9qIJ83Z8U2Apw07mpIF5TjCCfblYku3sF+6pBk01uQ
	 87oAkQrpYzIA4bovv9hfcmJD/AfxylWJUCogkwHfCoNY7EXDgmbftOBnhjUBfEHDV3
	 PLQSMY90b1B4w==
Date: Tue, 6 Aug 2024 09:02:57 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: luigi.leonardi@outlook.com, mst@redhat.com, Stefan Hajnoczi
 <stefanha@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 kvm@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Marco Pinna
 <marco.pinn95@gmail.com>
Subject: Re: [PATCH net-next v4 0/2] vsock: avoid queuing on intermediate
 queue if possible
Message-ID: <20240806090257.48724974@kernel.org>
In-Reply-To: <tblrar34qivcwsvai7z5fepxhi4irknbyne5xqqoqowwf3nwt5@kyd2nmqghews>
References: <20240730-pinna-v4-0-5c9179164db5@outlook.com>
	<tblrar34qivcwsvai7z5fepxhi4irknbyne5xqqoqowwf3nwt5@kyd2nmqghews>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Aug 2024 10:39:23 +0200 Stefano Garzarella wrote:
> this series is marked as "Not Applicable" for the net-next tree:
> https://patchwork.kernel.org/project/netdevbpf/patch/20240730-pinna-v4-2-5c9179164db5@outlook.com/
> 
> Actually this is more about the virtio-vsock driver, so can you queue 
> this on your tree?

We can revive it in our patchwork, too, if that's easier.
Not entirely sure why it was discarded, seems borderline.

