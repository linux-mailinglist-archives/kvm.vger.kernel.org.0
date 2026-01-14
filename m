Return-Path: <kvm+bounces-68053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B42BD1FFE0
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 16:57:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5D2793020989
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 15:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5FE73A0EB0;
	Wed, 14 Jan 2026 15:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c/PV1btK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HfUYU3I6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7166C3A0EB6
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768406076; cv=none; b=dfjR5XP+/OxoChqgEmIoA6SmKvIZ7Xf3N9IDxJrUdawqkFnE0bRr+VPztCUGl0FtD0TULJwGFGhwu45/Jd3rvfH5oxwiAd7mLvuA4Fg6+8yznHP9beiOFtBoePbTRDrS/k1A0LO2e6VlkYxxXU5eTelzQuhx+MwVUlDo3dsUkW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768406076; c=relaxed/simple;
	bh=vu8wNkY+ONyZ11dQOa1RhYbfZ6CIfKh+CDlvLi9Pphk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cacfGM9wKg9NRTgQcZU0JDkLy1izDuRr5wiAQ8HcTHJxzW6NEsG74/UQJJHNsbijdPppWyeghH5K1sXld3yXSiysc4FvBAa413Y8OeBiUTJNzaOTg2nlQanE4FuknnIMhLcpyxBHh0ZsCNUyq6dBzyLoNb/Z9R5iZsea14gO48A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c/PV1btK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HfUYU3I6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768406073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=45w2Nqp7W5ReZCd4Up6qyFBRnRWCXaqu4990woCkPZ0=;
	b=c/PV1btKQ/VfOJU0jphieKOaHftN0segutoUNUhUg14ArLYeoC8Ud1TVAqJJgOG3/DJ409
	JnLEVUAPWLvI8IhnqR8fe8ZWrXdSFjtoF0Y8uPiVpKAfPkMTMO4ktK5Hy4ivgajF4p0oOb
	vTeDsQGVz8ifwWIFN+MUuZIcTndGvqg=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-se7eW2lBMKGKdp4PX-QxSQ-1; Wed, 14 Jan 2026 10:54:29 -0500
X-MC-Unique: se7eW2lBMKGKdp4PX-QxSQ-1
X-Mimecast-MFC-AGG-ID: se7eW2lBMKGKdp4PX-QxSQ_1768406068
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34abd303b4aso17688275a91.1
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 07:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768406068; x=1769010868; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=45w2Nqp7W5ReZCd4Up6qyFBRnRWCXaqu4990woCkPZ0=;
        b=HfUYU3I67nA80vs1ntunHYhEWVdZpA75QutEdzJDO9yTjYaEF1+7mFCQDghFSlT4cC
         WYrjBmLkCWxH/ice8Q+FsXKECBpBjIbLhuV09EyYLkveJnpuiEiKvw4aYp2xB8V/lit6
         GBakRdXp+8+c78uXoT4w3LRwD9Wdc7qfLHfhx4JJ+4EHGOPKDRqnhA1esGNK17KrwdHN
         VUi7TYB6zLWaU+Jpaja3P6e/260gfdSHJSJ+U1mizjLtw+B4b8UKLzAdjmEFCM3iKl3P
         MxWZhBCQjqFEg8WV5Ek+2wjH2w6lEXB5uQVKtFDL+DowQma0So4LWt4RLcEccmlNs5SO
         RSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768406068; x=1769010868;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45w2Nqp7W5ReZCd4Up6qyFBRnRWCXaqu4990woCkPZ0=;
        b=gIL75h8txHZfK0LBpJIrkPNCCYHMJIEcNdPY2hu6cPnUzGYUqrn83C55QFbETKFosb
         Lj9a9Zrgivv8za4WgexPQUPE6sXixf+X0I/JnJp9+fBs9ybWkZNxKiGqo/+TWM7rZf8e
         Ra3IeRvzdZ2LrPUfKK69IJSmo3uNVkZ1kOdthbO6NzuCuK5EbuTstSmdiCzZTgjFAWIC
         MRcY7qsMsMz+alqbtn9oo96lhd1STwY+p1fM7ounYmCtLpzRNWAg3M3R8dzwRiMLpSwe
         TwGID7aDujDn1oTn6qgVDXa3z6hnQmtXyI1KhJ6P4y9/tvfn3hnAwqHSfjsCB8qwlU8R
         l9zw==
X-Forwarded-Encrypted: i=1; AJvYcCXBztRyT23pV9GgwnBKHc1luifVKfLeBGsc0Lp/f9+yeTGOtnlqy+yAGYxpnF0JjV4zYQs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQV7eaWQkiRyvrJYilhifqX3Ox+UIkMl9taS7n1W8NBL99+gZ5
	wxbe7SrQ/dDyYyW2EOta3KW8jCsI6l10PdGYHjTDKgyNDAuw8MqdZm/jQ4NSdbQhubzRUbHUFYo
	RL7ADdGlA/ecjAnalBLSbJdIeKSBo+IC6koijlKvEM4KCkJ2d+A1aQeMw/vhaBgGSG7yVIABHSJ
	FfC2dYEtbZUYo3QTtw9k2ONTpSpDD2
X-Gm-Gg: AY/fxX7icCRVrxUhKv1DalaGFW8vgi3oFug39FSIbQSSdWYeR2LHPQ+2FHLmgAk+o2i
	kjMeo6CnIHZdkIfhH6kaHMt5dIC34oQ7fX9X7FcoHCWZ5OMdmrvp/ERD/Rbb7KORXE+nGr2C1oY
	hbUhdMulsx0Toy6apGz4Rn5u4yVWHKB1eYtZ5vFTSkmRpgXRubdQneo1AtTvb4tove
X-Received: by 2002:a17:90b:590c:b0:34c:f8e6:5ec1 with SMTP id 98e67ed59e1d1-35109163a89mr3116095a91.35.1768406068132;
        Wed, 14 Jan 2026 07:54:28 -0800 (PST)
X-Received: by 2002:a17:90b:590c:b0:34c:f8e6:5ec1 with SMTP id
 98e67ed59e1d1-35109163a89mr3116054a91.35.1768406067530; Wed, 14 Jan 2026
 07:54:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112-vsock-vmtest-v14-1-a5c332db3e2b@meta.com> <202601140749.5TXm5gpl-lkp@intel.com>
In-Reply-To: <202601140749.5TXm5gpl-lkp@intel.com>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Wed, 14 Jan 2026 16:54:15 +0100
X-Gm-Features: AZwV_Qg5JTJCQi1Wwfd0jbkgP1qN1I8qkJH4vIis9H-XSIO4o_clOB-LFig_dcA
Message-ID: <CAGxU2F45q7CWy3O_QhYj0Y2Bt84vA=eaTeBTu+TvEmFm0_E7Jw@mail.gmail.com>
Subject: Re: [PATCH net-next v14 01/12] vsock: add netns to vsock core
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: kernel test robot <lkp@intel.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
	Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Long Li <longli@microsoft.com>, 
	oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, berrange@redhat.com, 
	Sargun Dhillon <sargun@sargun.me>
Content-Type: text/plain; charset="UTF-8"

On Wed, 14 Jan 2026 at 00:13, kernel test robot <lkp@intel.com> wrote:
>
> Hi Bobby,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on net-next/main]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Bobby-Eshleman/virtio-set-skb-owner-of-virtio_transport_reset_no_sock-reply/20260113-125559
> base:   net-next/main
> patch link:    https://lore.kernel.org/r/20260112-vsock-vmtest-v14-1-a5c332db3e2b%40meta.com
> patch subject: [PATCH net-next v14 01/12] vsock: add netns to vsock core
> config: x86_64-buildonly-randconfig-004-20260113 (https://download.01.org/0day-ci/archive/20260114/202601140749.5TXm5gpl-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601140749.5TXm5gpl-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601140749.5TXm5gpl-lkp@intel.com/
>
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
>
> >> WARNING: modpost: net/vmw_vsock/vsock: section mismatch in reference: vsock_exit+0x25 (section: .exit.text) -> vsock_sysctl_ops (section: .init.data)

Bobby can you check this report?

Could be related to `__net_initdata` annotation of `vsock_sysctl_ops` ?
Why we need that?

Thanks,
Stefano


