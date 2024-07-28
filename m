Return-Path: <kvm+bounces-22476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEBBF93E9EF
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 00:10:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65CD1B216B5
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 22:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BBB7BAFF;
	Sun, 28 Jul 2024 22:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AA1UCaBW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5D55914C;
	Sun, 28 Jul 2024 22:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722204631; cv=none; b=nCYUbBEp/oDtr0ttX281uSqJcoimmKiy8vFyzWXblXb5YUYm9wboXdWJiCmrS0JxPql+S3cJ3yjt9Ql3NXlOKA39aq02Rg2/SRVNdm7aF7/Y05pLHaLEUMfT0vil+gJLo0/fJ5/SIp9EzqMaH3O8G7U4cHZ/GmKc3MjQRbR88iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722204631; c=relaxed/simple;
	bh=C0yaa1HeosGSTqketDfd4qkVnRf7BT0xSouoh4lDdU0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qBMC9M9+QaPcXZLslZ8JKjlcaEjbwfFA+kVrRNrhhJ+SYk+gzcO44amLNJq95PxVZrKXWumXlMyJLxTTko2xlgZi1ZYlaw24xvWmyCOX0jdUmYzOKxTs+fbLG35fc6+ha0fG/28i4SP8HJkp/AF3GeYR7ESyp4Buja7zBgy0dxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AA1UCaBW; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3db19caec60so2123231b6e.1;
        Sun, 28 Jul 2024 15:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722204629; x=1722809429; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8WFV5A19fkh+7kPhwlaDnoT0oehdraQfB5oPegY2HlQ=;
        b=AA1UCaBWEGFQ7PdbJM0FoNdQc2fSFryKQ+UojCPJTpPLm0YM2sMGiRrimW2385ydyy
         q+EndZVLl4JsF7mxysEMAJk7TURmBLpH56khwUJhd6sagZf4gzGIZe5yJRbebPDA5UlZ
         OYQGug1lpyDxJGGb906byop6Rt8aAiNKUV529hOalyhpcT9W9OMH8+c9GWkgIew9CJHw
         FYisErZoU2p05AKr7fJsWA3tpYwy0tXYE+pDAzuSTvX0r9huUGpHrkKi3ext8PMBiiyk
         3DYtLpHUGbwsJaXQqX2djfq+LvmZwCduyQ2UQjfoh6YlhOtaZcnONEcAHGCsWmtrU+vY
         mBPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722204629; x=1722809429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8WFV5A19fkh+7kPhwlaDnoT0oehdraQfB5oPegY2HlQ=;
        b=jHgA0DWvwYGOaoSSKtyXHyfSe08XK6It+iW+otZ1HqJo+oDnxf0ByM2STntGn57pyA
         79ZUDlzxb9fO8J5LPq0YrlentFLCSQEFYavSYA0wbD/i559s/vPwp/ZpDudWs/px8MgY
         PgHQMY9j5y7X2Q3r8jBr6nzL1s2QwN+xI8uPQhi+uQzQNagqtBHWmlMYWAh308o+bqy5
         zIytYO6BOcsr0vAXSXwBfoHQ6ewxKnGlqnUUwP/9BhWAdOJoFS5EpGPfoX8ljk7BKH8F
         99D4BpJb0xieUFNH5OBDCYX35y9jLfGuG0DX9jcRRI7i/ELBjWMsU2y5KkMaAENTqzz8
         LYDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVc42BPnVFxnX4kKkut76LbgqxNbOOaUcegHeU+gaD1emzaZA6co6bt3hO9KZJ9otHhjLNMR7glwA10fGMMv64bf348r9lCXghVjPshX1hDS0d3Kuza4Y/UyXDO/LXY8n8L5ZTybmf1fCeWjRA/zOxw3l4YfKSy71EUy75Lc9lAbMg5XhAM6YhJrY82Xr0NENrNf6X0kpHAvN9FYhxzMpcaZCBrdjQ8ff2Aj50M
X-Gm-Message-State: AOJu0YwsbNgsevqFQ/YVrhKyhAeUVxyDGGH0oQV3ZbhJYlk4GmH8/dlJ
	dPGYSbjYSKg0Vpkbc2YoioAgrXSsmDNCIL5ExVUaj77/+45+2k57Ey5YdBHEe/c+slyFwJff8nF
	6Y9Mvb63ITbk2hyu5zTxb4uGPQpw=
X-Google-Smtp-Source: AGHT+IEw3+98/dkX5bsc3y2qs7kudwyMQ2dCtR9MHudb1vAPFedzvStonePBepA4fNU+r5zlDt7zwcHjsI0akqPOZ5U=
X-Received: by 2002:a05:6870:169c:b0:261:52d:1aef with SMTP id
 586e51a60fabf-267d4f5b2f5mr8312222fac.49.1722204629420; Sun, 28 Jul 2024
 15:10:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710212555.1617795-3-amery.hung@bytedance.com> <8d7dc8cb-0211-8e20-2391-c16d266b8be6@salutedevices.com>
In-Reply-To: <8d7dc8cb-0211-8e20-2391-c16d266b8be6@salutedevices.com>
From: Amery Hung <ameryhung@gmail.com>
Date: Sun, 28 Jul 2024 15:10:18 -0700
Message-ID: <CAMB2axPA6hEHJ_xm-aperc3kb221kK4RpL848pgY_sL+8RBFHA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 02/14] af_vsock: refactor transport lookup code
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, mst@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, kys@microsoft.com, 
	haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com, 
	bryantan@vmware.com, vdasa@vmware.com, pv-drivers@vmware.com, 
	dan.carpenter@linaro.org, simon.horman@corigine.com, oxffffaa@gmail.com, 
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, bpf@vger.kernel.org, 
	bobby.eshleman@bytedance.com, jiang.wang@bytedance.com, 
	amery.hung@bytedance.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 24, 2024 at 11:41=E2=80=AFPM Arseniy Krasnov
<avkrasnov@salutedevices.com> wrote:
>
> Hi
>
> +static const struct vsock_transport *
> +vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
>                                                       ^^^ may be just 'u8=
' ?
> +{
> +       const struct vsock_transport *transport;
>                                        ^^^ do we really need this variabl=
e now?
>                                        May be shorter like:
>                                        if (A)
>                                            return transport_local;
>                                        else if (B)
>                                            return transport_g2h;
>                                        else
>                                            return transport_h2g;

Looks good to me. Will change it in the next version.

Thanks,
Amery

> +
> +       if (vsock_use_local_transport(cid))
> +               transport =3D transport_local;
> +       else if (cid <=3D VMADDR_CID_HOST || !transport_h2g ||
> +                (flags & VMADDR_FLAG_TO_HOST))
> +               transport =3D transport_g2h;
> +       else
> +               transport =3D transport_h2g;
> +
> +       return transport;
> +}
> +
>
> Thanks

