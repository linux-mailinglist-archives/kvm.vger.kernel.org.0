Return-Path: <kvm+bounces-5102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE96481C059
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 22:40:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D7D51C20B72
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 21:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E6677F16;
	Thu, 21 Dec 2023 21:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NYnt3IW5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FF577653
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 21:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d3fde109f2so11525ad.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 13:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703194807; x=1703799607; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UB0ZY+nBxKTPkORzoQ6ZJO9teY19uCFlT+Q333mOXAc=;
        b=NYnt3IW5hHRkfD8SaAK3BwwkgI2mbklrFuDHqiUyR9iTBK47S4nfVjo9F4hMiaBeZ3
         oM80PLh6pvkTDe/KqWfm/H+XpjaS9DhVJx2WGQ70uHfIqlG7Y4N+4wEhpr4rPpRm5Twj
         wZTMagxZ+YtIwGQXqXFMH3HP0AY97SHFYWsQUi7nISit4c/HXnwZV7LmM4G80Sg6BIQi
         zpNHCuk6+p4Xa7GBxNOJqVADfNx5Z6TGi4Nk+U5JzDtU2Xt20juzaSBnxCUsQLpHB5en
         EomjeeWV7tQ5hSDqdi+8k5BoXWXFJ4R1E7U7dsPK2XB/l9MWA6nmQrRCyCZpV4nEWyAc
         Uweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703194807; x=1703799607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UB0ZY+nBxKTPkORzoQ6ZJO9teY19uCFlT+Q333mOXAc=;
        b=EQf/Up5mWaxrtDCTzlAHv26AndC+FntVvDqJl2U7VgcUVgxevkS2qY1wQDi0P+zaTW
         tZ2S3ker75qC5/0Z5qGAWZzNpbvOKn2NuvJbzcoDEMfUby17kvSAckST+maZ8rJwJMKS
         ZkgSrgDgdNHwc5YGyIvQUpPUZH8YIGzGQOnh/LxpcFM93lS4O7U3uXO91q8hjNwnpFEj
         TJTDAf//vyvSpOK18wQf+2k98on6qwnVt4hfjcW2cLE1/YJED0h4h0m9QIJ3y+zrsHxp
         j2wr1zc0vLs5a9FttrrkcNj0Df1CUFkTejVhIBbwNRWnHQcqz0DfQCx7OLyhgVzlgJsq
         CD/w==
X-Gm-Message-State: AOJu0Yyu0myeUTgckLROk52XZUNmXjfiOMRXGLTHyFZ1ffN5qMc0TwqK
	Aojs+n174qYUtW157dXZn6LwNtX7mZ2D4ekI0EhkPp95YHO+
X-Google-Smtp-Source: AGHT+IF80tZmsHPhE6wyckD/RAEBLEIynH1gwHeElMtN5TBkrj7syIFvBO/ajk9EvH4/NsPHbKo1N7hcl3mhL8zriwA=
X-Received: by 2002:a17:902:e84b:b0:1d3:a238:77ad with SMTP id
 t11-20020a170902e84b00b001d3a23877admr40283plg.18.1703194806799; Thu, 21 Dec
 2023 13:40:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231220214505.2303297-1-almasrymina@google.com> <20231220214505.2303297-2-almasrymina@google.com>
In-Reply-To: <20231220214505.2303297-2-almasrymina@google.com>
From: Shakeel Butt <shakeelb@google.com>
Date: Thu, 21 Dec 2023 13:39:55 -0800
Message-ID: <CALvZod6bwWBuRZ8BCjUiyec2wR6hBSwrdcEzEM6d+9UdmCQBGA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/3] vsock/virtio: use skb_frag_*() helpers
To: Mina Almasry <almasrymina@google.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	David Howells <dhowells@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 20, 2023 at 1:45=E2=80=AFPM Mina Almasry <almasrymina@google.co=
m> wrote:
>
> Minor fix for virtio: code wanting to access the fields inside an skb
> frag should use the skb_frag_*() helpers, instead of accessing the
> fields directly. This allows for extensions where the underlying
> memory is not a page.
>
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>

