Return-Path: <kvm+bounces-27402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C98985171
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 05:31:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A47C285028
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 03:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC1F14B950;
	Wed, 25 Sep 2024 03:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gSfNEiQr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A498126F0A
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 03:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727235073; cv=none; b=VnHkhrORNcvmV5hzt5hO2a1HnDkbERb/edbZSLmUaV8/xOLqiso+GNHQURsMrhsDV7rE+RXWOWFJ7PFtvN2p0oOUOgsrjF06OTEsJeUoGsqTZ+rX9S4Eetgb/lXML7W9I++XpJ4G185LnGg5fpNHE/Geh/OYAtWPBO4pz2rGky0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727235073; c=relaxed/simple;
	bh=M0Ynl+OetR8GBYZEwi4ht5kW6Ch+UvBVR3yT5ZWcE34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rdt+tZAy4TxrKlscDZvEi0XJhq5penqN100dqCmtYWtRbs1+uW95IhITNnTDIbyjOFnLwq5YwRpJMibwY4Dd3p3AFqJmDgQRxjinpFvZfiB5ye2e/RePf8g4RcxNxCRAR2jjLtUZ34OQW+itP3enCe348/uCYyaMnEhExT8P6/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gSfNEiQr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727235070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M0Ynl+OetR8GBYZEwi4ht5kW6Ch+UvBVR3yT5ZWcE34=;
	b=gSfNEiQryX5Qntgto1tG6oWI8Yteq3asQBw9mV0khYlN/cDkXo1gOithLrHHonTnbrrbCy
	aQL16PWKNa9TQLZJCbQV+YztanCBtx+JWlIorV7USyWzhvFMH5+I1g8ZIE69cRxTKis+wP
	w8Wf+q7zw4l49h9OTQtL6/8dzH890ks=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-aKKnlDdLMYyJlo25JgDDew-1; Tue, 24 Sep 2024 23:31:09 -0400
X-MC-Unique: aKKnlDdLMYyJlo25JgDDew-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-7cd7614d826so600464a12.1
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 20:31:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727235068; x=1727839868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M0Ynl+OetR8GBYZEwi4ht5kW6Ch+UvBVR3yT5ZWcE34=;
        b=n3Ocb34ftZtQ+I45pWLNe6wl01B0m21jzssgKmhnLPiNZLvfE79RlJn5gD+sMxMXH8
         PVK3+IBzWGdH7urGYnW+ecousDHfcu1dSnU9WsCooBzha/ZhUFvPowfNE92Clh9G+cti
         5fG0DO1a0Cer4Jpij9/IdT1IuU05mfm49Yo8a/NY8y6MFWCsjwakhxKBxleHG30tja+o
         mVTmwZX+Lw8+ZTJ65+AQ1sZykJr5QQUYlVDOx/IplSpD5sgZ1ro1UIVnvEw2OiXmDEyL
         35RlsqNNE7/VFa84Wcd86F6x4qXcq9VcCUIDPm9UM2fkOM+EJythOg5sSVR2z+X9vdBw
         9C4w==
X-Forwarded-Encrypted: i=1; AJvYcCW6DWrrp/hVMxNaQcOAEJSzSjQfsqRueiZvoSga//HJKG3cg7279Vwr7CeeFvvf+uXrtgI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7NHPKD20Jra8wk+aWcUBuj4eHEItgk/asGxB7ism+Ej+07vuw
	tGiONLWiQfcjlAai1xv33o0LXlbk8nzcTWIw3hl74PpRsYXM79btlOW7FdchgIWGZeH8F+4AWAX
	e0Pmj6wb2xMKAK1Ksty3ifqStmgo30t+4flo29DMeSt0JICcVsE1doaqbiZZSa5b4GiMehrL8bC
	0RJsm2Q2w+KJsazxyqAG2ujdqk
X-Received: by 2002:a17:90a:d18b:b0:2c9:7343:71f1 with SMTP id 98e67ed59e1d1-2e06ac390c5mr2020775a91.14.1727235068207;
        Tue, 24 Sep 2024 20:31:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHSXnVXH4KJFogFRlAqrxz0oHdsU+wQjcpSOWPpZkunKpdZpa8uVOFkj6NCDsQxAw+PRNHCHqUsGcOkqjm3ok=
X-Received: by 2002:a17:90a:d18b:b0:2c9:7343:71f1 with SMTP id
 98e67ed59e1d1-2e06ac390c5mr2020746a91.14.1727235067738; Tue, 24 Sep 2024
 20:31:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240924-rss-v4-0-84e932ec0e6c@daynix.com> <20240924-rss-v4-7-84e932ec0e6c@daynix.com>
In-Reply-To: <20240924-rss-v4-7-84e932ec0e6c@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 25 Sep 2024 11:30:56 +0800
Message-ID: <CACGkMEvKPXCPi6=1938J-k8JNA+hHqzRSt1gPQtqBvSfcgGZeQ@mail.gmail.com>
Subject: Re: [PATCH RFC v4 7/9] tun: Introduce virtio-net RSS
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 24, 2024 at 5:01=E2=80=AFPM Akihiko Odaki <akihiko.odaki@daynix=
.com> wrote:
>
> RSS is a receive steering algorithm that can be negotiated to use with
> virtio_net. Conventionally the hash calculation was done by the VMM.
> However, computing the hash after the queue was chosen defeats the
> purpose of RSS.
>
> Another approach is to use eBPF steering program. This approach has
> another downside: it cannot report the calculated hash due to the
> restrictive nature of eBPF steering program.
>
> Introduce the code to perform RSS to the kernel in order to overcome
> thse challenges. An alternative solution is to extend the eBPF steering
> program so that it will be able to report to the userspace, but I didn't
> opt for it because extending the current mechanism of eBPF steering
> program as is because it relies on legacy context rewriting, and
> introducing kfunc-based eBPF will result in non-UAPI dependency while
> the other relevant virtualization APIs such as KVM and vhost_net are
> UAPIs.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>

If we decide to go this way, we need to make it reusable for macvtap as wel=
l.

Thanks


