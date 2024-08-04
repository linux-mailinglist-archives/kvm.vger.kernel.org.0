Return-Path: <kvm+bounces-23173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12CCE946CD6
	for <lists+kvm@lfdr.de>; Sun,  4 Aug 2024 08:45:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0CA01F222CD
	for <lists+kvm@lfdr.de>; Sun,  4 Aug 2024 06:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93FEA17C64;
	Sun,  4 Aug 2024 06:44:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2CDB67E;
	Sun,  4 Aug 2024 06:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722753883; cv=none; b=sBm/DjUEvsQ7F3vAVsqSHkKQPNrrTHvBmHUaQUXwjK/+hQ2XhsQQ2hK6QWH/vgq1EQRHvuCbXW1rwv6sn7TV0ZxeWoDBzcg7o0XaBrH+6QWkpdlon8Ni5LiKeNSEyEIcDkGbho4BtXYqj0yGaHz8qpu+noi3fjU00CRd6MYBfbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722753883; c=relaxed/simple;
	bh=sM563CEGX+iYVBrLjeDfGXla4ALwff+kdJMmGjR+TG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CiNCzm6roATHJrWVjv3vOSYYi+58U6bzsQI/Vluo8/D77dCIwKoCQZQ+D4pFx7aYcA/1PZw0/9MEAi+8V/M9fan9/y94WVEtL4SSDtlx2OrqWd+HIYMjbZvqT4SNkRBvQlVim8J3gTeUNEOPw1gtJiSck4hWZ8kedQDdjwd3Iqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-36841f56cf6so1199520f8f.3;
        Sat, 03 Aug 2024 23:44:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722753880; x=1723358680;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sM563CEGX+iYVBrLjeDfGXla4ALwff+kdJMmGjR+TG8=;
        b=GM2ikA/O08cPyWwYu+2fZM0wj972RkpYPhklVYJJzLYp0wnO1MKCe98whXzP3ELUbc
         m8b4Hxtlg1HcjiEXkZKz24JViyz3qnmuUYCdV/kOgNizT6rGDKd++KSb3kYJFpUv4S4z
         q5k1mlVxAGbosw8fxEe2rvNnXA9LZcc09+ZlrvuGVTOTa3ZbB9NIaCrqi5ynHPjhAF0q
         d6doObb/w0TS+uUJRSA5N4utWrDoM54z+e3nIlr1SPO3Zbtjo0OrvfSutvIiJQiwIJNk
         hSw6MrIUIeK6gEh6xa4cngY90I/qcpDIjKFhovcPitGNgItXCiv4l2sBh/rAX6+vDd6O
         yfkw==
X-Forwarded-Encrypted: i=1; AJvYcCUJNVELJXigKNfYeESPDcupSvTLISLEuMNeDt/LdZej8Ej3E5hEKr3BQHgK5JU9QuI6xpYH9WifrzoX@vger.kernel.org, AJvYcCUkkP829RGxU5FAS9Glf7lSlcJ0a6JYQ1wuiMhYwExEaEGZrvaAygJtOICutouDh16VXnY=@vger.kernel.org, AJvYcCV56d+0N4UMCs6CDjfwbMKYS+njyxLu5TWxQrmLoTbpNZ1N/gfU9sHb94QTJBPv+CYdxRN9MMnEdDpdPQGp@vger.kernel.org, AJvYcCVGizSPx6jV89AJAU6w6sr4O1SW4M/zs4KZmU6PXwV7e0WXNREzMTdcBEqQTMulPmktYnyT@vger.kernel.org
X-Gm-Message-State: AOJu0YyvMGPEbM/gzkf6MvBbQKpYmqFTZQTVVsp3VMwY/QfNVCi/lifR
	62ISNbi19wAgXa9FqzDCkl0wMTHUS3E2K5AmWhSDsr3aoeos2VLJ
X-Google-Smtp-Source: AGHT+IF+HIEN3u4KbARF8SJvOwd5zbIiuHalh5c4I/D6/TshZm+RxUSfK1q1kRjeS4JttPgnFZS+0w==
X-Received: by 2002:a5d:648d:0:b0:368:aa2:2b4e with SMTP id ffacd0b85a97d-36bbc0c8bbemr3329655f8f.4.1722753879500;
        Sat, 03 Aug 2024 23:44:39 -0700 (PDT)
Received: from [10.50.4.202] (bzq-84-110-32-226.static-ip.bezeqint.net. [84.110.32.226])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36bbd06e0f5sm5973058f8f.104.2024.08.03.23.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Aug 2024 23:44:39 -0700 (PDT)
Message-ID: <ddf1824f-c60a-4908-a67b-ebe7546be870@grimberg.me>
Date: Sun, 4 Aug 2024 09:44:33 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v12 04/14] mm: page_frag: add '_va' suffix to
 page_frag API
To: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Alexander Duyck <alexander.duyck@gmail.com>,
 Subbaraya Sundeep <sbhatta@marvell.com>,
 Jeroen de Borst <jeroendb@google.com>,
 Praveen Kaligineedi <pkaligineedi@google.com>,
 Shailend Chand <shailend@google.com>, Eric Dumazet <edumazet@google.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Sunil Goutham <sgoutham@marvell.com>, Geetha sowjanya <gakula@marvell.com>,
 hariprasad <hkelam@marvell.com>, Felix Fietkau <nbd@nbd.name>,
 Sean Wang <sean.wang@mediatek.com>, Mark Lee <Mark-MC.Lee@mediatek.com>,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Chaitanya Kulkarni <kch@nvidia.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
 KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Neil Brown <neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>,
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 intel-wired-lan@lists.osuosl.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev, linux-mm@kvack.org,
 bpf@vger.kernel.org, linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org
References: <20240731124505.2903877-1-linyunsheng@huawei.com>
 <20240731124505.2903877-5-linyunsheng@huawei.com>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20240731124505.2903877-5-linyunsheng@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Regardless of the API discussion,

The nvme-tcp bits look straight-forward:
Acked-by: Sagi Grimberg <sagi@grimberg.me>

