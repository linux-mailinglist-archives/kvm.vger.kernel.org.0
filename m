Return-Path: <kvm+bounces-66530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B18CD79E8
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 02:17:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6A327301CE53
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 01:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3658C21FF3F;
	Tue, 23 Dec 2025 01:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="frAnAsCj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fF6rbvVi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B839513777E
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 01:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766452617; cv=none; b=F5n4EOZ2RMsUSufzSpeaaPSCaqO/UfVgG043p1YbwmeAnQrp/qb0gFRALjaaOwOkzrL7d+YncnMXV0LnUSBgGMAC5yY2vXWWQJZLOAcxvRl//VXebCgJLh1qqK7e+GrR+aENK3OOfWqDvyS1Eg0mbxdzwJtu+eo8yqNmB6y73TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766452617; c=relaxed/simple;
	bh=8kavS/IpGbpS8t4JnXK8FZtjo5KbcXSe8SCEx6230Fc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ak8/VGvacooQkEdKyU5d8cBq7qOB9WSCWTNeuKmWyCzz13GjSRM7++bBqH2ZEstqICJvK8dOan3aWvZbYqClAZOfEgPmb2VnrK2iUEqhYnHifKY2IerYJ7wqpP2YFz2uerL91eKYkQVTEY1HJW+/W4sKeFcjbV2mR7QPs3AtAbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=frAnAsCj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fF6rbvVi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766452614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8kavS/IpGbpS8t4JnXK8FZtjo5KbcXSe8SCEx6230Fc=;
	b=frAnAsCjAovivn13rds7bBcd40kD879BTTJWEyFhnv7/y74ims7X8GxxNTy5Qye6we4LdZ
	FxydmCpotdPHn7HnfyXOgphv2Csa2WLEtVf4RWz2zjnzeNfbNjA4WVQnEHiawaTh25iiac
	ctT/wLuvMQt/uzVlXazGet6L/d+gfOg=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-ljTvAzcJN6OswqIcEbb3Fg-1; Mon, 22 Dec 2025 20:16:53 -0500
X-MC-Unique: ljTvAzcJN6OswqIcEbb3Fg-1
X-Mimecast-MFC-AGG-ID: ljTvAzcJN6OswqIcEbb3Fg_1766452612
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34c64cd48a8so10291404a91.0
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 17:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766452612; x=1767057412; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8kavS/IpGbpS8t4JnXK8FZtjo5KbcXSe8SCEx6230Fc=;
        b=fF6rbvViBcbUC1Kb084n1eTXLxM+ThYB0fcrdBY3Eth6zFSinpfJdnJ7+5IAwK3PNA
         5AU9Sk7IQwbi2CEZLo8sgS/SDgjyPlLrk/Blt4bqxoEFDDPc5rPaiha0EQB5IeXY+oWA
         emdGqo3S47GPD5H8YKovWyp6/to6gnMvEy74TxuvEUqC+etnpsJRPQ2z4X7F1ruKoFwB
         UFjjNIfyzIAbULBWZROegtlF07ByUGaGSOv1G1fEdXVLX2Oaqb55gJmfmlYe2P8kxOTN
         qSsFeB0e/Cbr4liQNB37bovzoUznEpPL+apcDeU0ymOv0EjA5ApfLdrhLlwf2iDZzqP+
         3fDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766452612; x=1767057412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8kavS/IpGbpS8t4JnXK8FZtjo5KbcXSe8SCEx6230Fc=;
        b=eAg9+fi4L2w0owhcD0uqZQ/QhEoqOgIYjJ1KJZwWHkajJX36lidC8lt/cJrZ1lGScc
         59Mbv8L3rDgHNH6xiayZaDG8sf3ZIRY99rKxeO1N6EQnB5Kn6/Nv9sGEPERjkJbt/zTx
         KLSwME3KELUKTbhZh47aFBVxMSz3zZJvzA7jgf7qYRmq3lEQZPxt+USBx9FKm/9lfBeM
         oTUAbx7iJ/NfBYRvRt3ZNXmKNv51hDbIvGKzG0f9AHVstYtiFPSjxopaM9jxTDGxDj33
         EAhm7wj6yNaGylseNUd8J30CtI3tQl1xMeZTpMt+uZ9UFnRQlltmhrgeghvWrqudQfsz
         puBg==
X-Forwarded-Encrypted: i=1; AJvYcCXstyhW+Q2gFp0MxQE7KJ0cNHDj9rTr5bliqlleCVVDw8AGMUICqw/9T4zfiyUUYvkyZn0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtdLFWmT+YlAF+ojiRB0gj8BSvHjQdTnuF6ZFsTIHDWFzksZRT
	UtmClnayg1xQp7Diid6AEMKiaiWNVLo6yXFZlCCdaengSSsDxYOXxO9K3ulISSbo8jRD6rSDUu5
	D+iHG3GMNSpGd5aUD8JLCksquuTO7O70BBUQIuL38Jl7N253Dkgjc7Pmaq1AZsOEnvbP3P3+9vP
	Dy27vkNu6N8NjD8hUReTrlMA0//CKH
X-Gm-Gg: AY/fxX580QLks2gZc0Wm1dWOgkXeMQEMTkYDykqa3WFCuZO/MLnzG1gcW63aKRLlxlk
	w5ePlln0PWeNaiaDpMO4p1xdd4ClT/A5mEZ5BHG7G82Tle5G+0edWhEOIczEwyDuiDxRbJEuwB9
	5gyQhkXXmwoBfsg5x8WRk9x/XNpc8aUV55dGRy4m9JcFDbQbELHiF6fVgodBXXUjTPfEY=
X-Received: by 2002:a17:90b:278d:b0:32e:3c57:8a9e with SMTP id 98e67ed59e1d1-34e921f0439mr10789718a91.35.1766452612375;
        Mon, 22 Dec 2025 17:16:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHn7x/SBWzm7wQBhQmpSlijwdbERX85H67QKAbR4g2R9+j0TmYDnQ/NNpfbhl0rxAVecwANEG5GhCi8Yj5MAis=
X-Received: by 2002:a17:90b:278d:b0:32e:3c57:8a9e with SMTP id
 98e67ed59e1d1-34e921f0439mr10789709a91.35.1766452611983; Mon, 22 Dec 2025
 17:16:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218091050.55047-1-15927021679@163.com>
In-Reply-To: <20251218091050.55047-1-15927021679@163.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 23 Dec 2025 09:16:40 +0800
X-Gm-Features: AQt7F2qZ13vyIVUk_vjRbH6oyWkePM18LxZIXnO-FMhdbQs8hi0QxoGynHxgcT8
Message-ID: <CACGkMEvbrF=g0_yedXKsccVN6vmfm+oQVbRkR1PGtQgFHH+v3g@mail.gmail.com>
Subject: Re: Implement initial driver for virtio-RDMA device(kernel)
To: Xiong Weimin <15927021679@163.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, David Hildenbrand <david@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Thomas Monjalon <thomas@monjalon.net>, 
	David Marchand <david.marchand@redhat.com>, Luca Boccassi <bluca@debian.org>, 
	Kevin Traynor <ktraynor@redhat.com>, Christian Ehrhardt <christian.ehrhardt@canonical.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xueming Li <xuemingl@nvidia.com>, Maxime Coquelin <maxime.coquelin@redhat.com>, 
	Chenbo Xia <chenbox@nvidia.com>, Bruce Richardson <bruce.richardson@intel.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 5:11=E2=80=AFPM Xiong Weimin <15927021679@163.com> =
wrote:
>
> Hi all,
>
> This testing instructions aims to introduce an emulating a soft ROCE
> device with normal NIC(no RDMA), we have finished a vhost-user RDMA
> device demo, which can work with RDMA features such as CM, QP type of
> UC/UD and so on.
>

I think we need

1) to know the difference between this and [1]
2) the spec patch

Thanks

[1] https://yhbt.net/lore/virtio-dev/CACycT3sShxOR41Kk1znxC7Mpw73N0LAP66cC3=
-iqeS_jp8trvw@mail.gmail.com/T/#m0602ee71de0fe389671cbd81242b5f3ceeab0101


