Return-Path: <kvm+bounces-67941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E5725D198AD
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 15:40:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A48B53062CEF
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 14:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B62231858;
	Tue, 13 Jan 2026 14:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fr7MxQBj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="s2E2NNak"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C633422F16E
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 14:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768315080; cv=none; b=RKNXl+fc1SyTcwM9cTvMKqIor2muanDCE8bNtx6O1FU/hPII8bBo/LGqVXVav8ytIgtI9CnysuyqWIdT6+iDhUzL5LSrsAwI+RBM/GHqYA24uzwtBR9WRczkQnofPAGhubCY2zvVDJWMZRgMZcB7pIvtL1PRUew2xfbmZ6afa8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768315080; c=relaxed/simple;
	bh=E5/n+gp4oJScjwiNqhRtlKeTPug5EnnZg1wflCdJ81E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g6PLNxyeg0CnrzMPjCGhGA0LB/BgcZoIhiCzHn0Q5KrOB+Ly0iK8zSjfTsq/8eqxZneIkqtRd9MYA4Woh38BvJIaYmFH8Fd5TU3LyLVj69NKQdKKGMEOP5FUZSvlh6YdNBDxAgAf/ME4f4jqDkzOLrtWskhY0l7AEVhe44L1fL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fr7MxQBj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=s2E2NNak; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768315077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9LgnqaJM+XpiwDFJ8HhQp/PFSeMXCj9ObUTssbWH+C8=;
	b=fr7MxQBjWUI4oclKG/Dt3rMpmCxIRqHpk5lilGSwTcqer7ZytXA4v7Sk1ab1aAmR8Y5d1N
	0x0bAzPXJ2RodPv1N49erED2XSMHN8RKScFH216wL0FhULKP7J2F8MZU7lOIzVTYzLeGUF
	21QVw5k75k58VCttEDDGDsuiTICNAzk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-E_eTGFQvNgOUxeT2MIDMvQ-1; Tue, 13 Jan 2026 09:37:55 -0500
X-MC-Unique: E_eTGFQvNgOUxeT2MIDMvQ-1
X-Mimecast-MFC-AGG-ID: E_eTGFQvNgOUxeT2MIDMvQ_1768315074
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-430fdc1fff8so4523821f8f.3
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 06:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768315074; x=1768919874; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9LgnqaJM+XpiwDFJ8HhQp/PFSeMXCj9ObUTssbWH+C8=;
        b=s2E2NNakzQc7podiTgkDwSS5JrrpBYsAzaBHukJI9cqCG7upriReWrViXdTo2VMN0z
         LotNkZzHizyLR6li7dHoBMGiiQktpC9CIZB4UiXf2olFdiLvJEc0pXtYNTFWgKr88uMC
         zsoEMY9hDitlVZlhniO4dU6uiBM2o4qVMrz4pKwXfK8mbOGW8K0kye5K4gxlFkfeGNyP
         G34PO3NqjWoj1l/j4KV6sy1YTr17HPyKQnGPTRmTjH+7oFmeyDjJ9EGQIpjGdJEq5REf
         0aFvAal+JDajv63n8AotnK7fETt5wITk/BS0xsHAwCUBMsxEQ/fm100YlBmnLWlbTYDP
         MElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768315074; x=1768919874;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9LgnqaJM+XpiwDFJ8HhQp/PFSeMXCj9ObUTssbWH+C8=;
        b=kU6XpbevNjX+BftLVkVW5MlRchz58fWv36uffnuarhomUjF6bGsJPHDfSzKjvpftsw
         Di4chUfDEgkr0lo6AR7tZYw4mQMd5rqKf8Gnhi0sIAgzDhg6LYUMKZc1aRci1o0ZLmlq
         VEsrkBzF/DLRqpvaDx3Q23XtMEskDrGom5zBRgT3NCbBOwuaO4y5n3X752AFAN21E8Kn
         HmU5+NeBA/HvuLYiGqZTiyGj79+zBOxfa9FQAGyd69NMtelIPjXXevLLFEmSeXS9akwt
         aUSK0cnUDz5vKcjYLMxhGOdwddnBmy/SV5zo2wQDyWpu6BEF6e/NOul0DPGCrjlSFP4V
         s5IA==
X-Forwarded-Encrypted: i=1; AJvYcCWSY36V0YgZAb7TslEuaRBAC1NM/pgmBwUeshW9Q43tGYTzV1vzj9PCPNHxkD2cANDXxj4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOYg7HrI6OFVDH+GFsGuUMiFuAllGDW9AdUOZJym8NgIg0keqR
	YC5Kt27pGuIoMP57TuMG1FquOXK6gtz1W7YD8eQBQlBikSvC4ib/6rmB8Io4T5NKxDIOWZq1TuR
	zvUiKTdDy2xXDjuItFdudqWQVhQpzjZqchdtJYuwMcRdXQRbCmnVJ+A==
X-Gm-Gg: AY/fxX5l2tbEx5vgn+Lci4nVwLSXClrw1eH9FDpOR7vDsEtNFdqSc49jkarqgi2FJrs
	hRm3CnSOv1AOrKJHBcEqZBHCdr0BcxWRjmr0wpGwJigBhcBECjKgSmn2UhC+vjumgc0GaonTPLL
	fYuB/eURAJuqIx5khHpnt1bXXBh/JjE1Os86agQaSNQ0C5jmAOR0DTSjj4UrDk916qQObYD9F6m
	dQkMRf3kbG8EiGEVvi76jgDmQRLFG9t+PbQuGFOq1gEB1oD6W0S75fm0xBvPRJVlJKxYXlaspFE
	O/Cx+Wjrp5m6bu3nuoVk7QJ26bo2nFCjqsPyTXSAPlX1VbN7guYPMbD0Ngf/ujCIBTE1ZcEu5wG
	dTDdPIl2GSQnnybNo7LkTXYalHfeBRn1spK0RJvpTotVBkX+U2no88ZqeG4mB5w==
X-Received: by 2002:a05:6000:2512:b0:430:f58d:40e5 with SMTP id ffacd0b85a97d-432c374ff28mr26117968f8f.30.1768315074291;
        Tue, 13 Jan 2026 06:37:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEaDijBjyQACs7Ec+s3xS5LP+GgM+l6sMs4Twqit+l71cMf1frrOWuoQfHaWNAhM1zfLnP+kg==
X-Received: by 2002:a05:6000:2512:b0:430:f58d:40e5 with SMTP id ffacd0b85a97d-432c374ff28mr26117921f8f.30.1768315073807;
        Tue, 13 Jan 2026 06:37:53 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-25-233.business.telecomitalia.it. [87.12.25.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e17aasm45089151f8f.15.2026.01.13.06.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 06:37:53 -0800 (PST)
Date: Tue, 13 Jan 2026 15:37:50 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	berrange@redhat.com, Sargun Dhillon <sargun@sargun.me>, 
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v14 03/12] vsock: add netns support to virtio
 transports
Message-ID: <aWZSeBAdiVs89wz7@sgarzare-redhat>
References: <20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com>
 <20260112-vsock-vmtest-v14-3-a5c332db3e2b@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260112-vsock-vmtest-v14-3-a5c332db3e2b@meta.com>

On Mon, Jan 12, 2026 at 07:11:12PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add netns support to loopback and vhost. Keep netns disabled for
>virtio-vsock, but add necessary changes to comply with common API
>updates.
>
>This is the patch in the series when vhost-vsock namespaces actually
>come online.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v14:
>- fixed merge conflicts in drivers/vhost/vsock.c
>
>Changes in v13:
>- do not store or pass the mode around now that net->vsock.mode is
>  immutable
>- move virtio_transport_stream_allow() into virtio_transport.c
>  because virtio is the only caller now
>
>Changes in v12:
>- change seqpacket_allow() and stream_allow() to return true for
>  loopback and vhost (Stefano)
>
>Changes in v11:
>- reorder with the skb ownership patch for loopback (Stefano)
>- toggle vhost_transport_supports_local_mode() to true
>
>Changes in v10:
>- Splitting patches complicates the series with meaningless placeholder
>  values that eventually get replaced anyway, so to avoid that this
>  patch combines into one. Links to previous patches here:
>  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-3-852787a37bed@meta.com/
>  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-6-852787a37bed@meta.com/
>  - Link: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-7-852787a37bed@meta.com/
>- remove placeholder values (Stefano)
>- update comment describe net/net_mode for
>  virtio_transport_reset_no_sock()
>---
> drivers/vhost/vsock.c                   | 38 ++++++++++++++++-------
> include/linux/virtio_vsock.h            |  5 +--
> net/vmw_vsock/virtio_transport.c        | 13 ++++++--
> net/vmw_vsock/virtio_transport_common.c | 54 +++++++++++++++++++--------------
> net/vmw_vsock/vsock_loopback.c          | 14 +++++++--
> 5 files changed, 84 insertions(+), 40 deletions(-)

LGTM!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


