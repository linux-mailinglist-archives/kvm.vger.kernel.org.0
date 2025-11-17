Return-Path: <kvm+bounces-63329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8C1DC6253C
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 05:34:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4421C3AFE12
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 04:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B19330E0D5;
	Mon, 17 Nov 2025 04:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="avIrSb9n";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="l1ZbbjTv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93E030C610
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 04:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763353963; cv=none; b=SYp3jTnBdR1YkflYLma45gCSNjmlVLes7tmiXwEvQDdMg5AMx0YU3x7pp39cbC0itXldHLTiG3ajnTNEWkAttbJtENRXnnQxBx8XJQpJi+H5CJW2Y7wEuCTaLx6Z2ualKSsTcHbx0PEFz7Ula1DX9ZorvScJY/52rT3mhEJB1ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763353963; c=relaxed/simple;
	bh=J5vSilRzoZFuz0Leuc5DFfPJlb/Y30/AvuhtXQq3ZlQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n0ha+Q+GikkUwsHWzsbvGxVSUVxJefutFSW3WWyyAckHyOc0WjKAuS3W1rarmr9Uyx0FCysLN4CcC0ULBpXoCfXfUll8iE6DO69+FkjpPprc4/W1e1lSZytuE31Sb1s1A9uYUTwX2XsMRk4AgQ2xjq+2ot3mVBP6MrhQFcQXNMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=avIrSb9n; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=l1ZbbjTv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763353960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PSNhFmpZIayhIMAREUUJiVdpe4HGYG1VRWTSSJUjCFU=;
	b=avIrSb9nmc9HIOFRoEqjACLUFQTRMi/Q7RQ2Nz2Q1UXHFLPV1YSz90AtRK0thSz7fzOPH2
	X1lRgEgdjZRXJehZY918wemjK0pCB66FrRmf/dhj5foILwsuymck7A2ZYK9QwLttt94pLb
	o0iR28GWUH4g432KkTMWfMDE3LwPbMc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-vElw_VN7OsKRRx71MWMF3g-1; Sun, 16 Nov 2025 23:32:39 -0500
X-MC-Unique: vElw_VN7OsKRRx71MWMF3g-1
X-Mimecast-MFC-AGG-ID: vElw_VN7OsKRRx71MWMF3g_1763353958
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3438744f11bso6630352a91.2
        for <kvm@vger.kernel.org>; Sun, 16 Nov 2025 20:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763353958; x=1763958758; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PSNhFmpZIayhIMAREUUJiVdpe4HGYG1VRWTSSJUjCFU=;
        b=l1ZbbjTv3uDxVuehRqqz1PEhOd5gSoQDm0lzRZKWOtfKryw96OfTksqH3gWFGYtNnG
         WFmJDH8nSlxSPblEWVhH0NTNRbf1+utL5V+XalqIDwUERLPX8xF+YVXDs7HUmGh4qvpl
         WXVTNQaAz2AQQoNZ8MD3MLfFGcLArAKse6TFF0JxR9dBpztEpxJ78c3fvv6ds9y3n9/+
         FHwi3/oA9klPYYJl+GxKVc9IMeYGwHR5tTkDTwocbabfyIspjKswaMEJ6xH4bK/bpR7g
         9yWPqSTnxsy/WFkK63STowA1ydyqfB0lEqsSm+Md3LLlVgDnb/GMof39z/uWsQ0g6C94
         1ACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763353958; x=1763958758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PSNhFmpZIayhIMAREUUJiVdpe4HGYG1VRWTSSJUjCFU=;
        b=ZdGHftsdrHI2OrIcb7ipCRyOQUnoEfA29riUP/MxLs5uJQZoGrGcvc/1YnrsAQRatI
         xViQF0ScL3mjGgo5+EOTMsJUQTW3cn28G6elpWUJvmO8NQs7nsl7exLcNuta9pUFTfgG
         NSsdvVNELcEXFrJXSNkSOoGQtnTgZQLI6SjBxsyDWsRvZZEehArsrl9xtzQmie/5tGuz
         W/1aoZif4al4zfuBp/tX+WwytXG/4X3Zr/T/0bWc6b8EWkgK4ZXdTq09QEH/NNdY5ZEJ
         qzhf2xOo6AX3yWUYCm/Zje2SjYwTm29aOB8wgpPj6Jz7kvpmrc7KwenaPOrsXaHGWuaY
         4/lw==
X-Forwarded-Encrypted: i=1; AJvYcCVM/NsLyZS35moTH+B/zibMQNpdomI0JD4sHYIfVa8syCUv65bSNAWa+FKdkD3kfNDKpcs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/oe3MpCISurI/ev5IYzCL5r8UqTXZqnIBhppftcSWDy5MvmTf
	h4NMu5Cyo3iaqAHZmbWlhGJYi0l+zj/JeKDFDWpAnpXDPTzLvbNMCAHGjS+gVG6a2IZa/27BaSt
	rOKNB1MCciE3G3KulnNpo7WsR7ExV1EhfjArSjbDi5M4pRqXnyLp2IXckTJnwm/CaaAOJ3Mmze7
	DLnqixilKy5/y7yhqiS8SE2F1JjFYC
X-Gm-Gg: ASbGnculObq33zqvYpG8Gj+a65QN9f5V/W2KRvxMH3l3wL0wPWcXpoFDMMchPO9nHJS
	3Agpfkfq9VMlCZfM4+ESPcgm7WcG5h0jJRetbAg9F75jGtYX+H7fjFoADNItuEi87BKYqLvQA8W
	13Tnn2+TlAxVc/ZCQ9ldExi7CnH16yVOdx9N9dYv4Xlx12Uz0Sv0YhfMELyTWkulBGzzY=
X-Received: by 2002:a17:90b:17cc:b0:330:6d2f:1b5d with SMTP id 98e67ed59e1d1-343fa746bb1mr11596129a91.26.1763353958259;
        Sun, 16 Nov 2025 20:32:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHV/CXg+2Vp41Uxj1ipRGPfCEHzBTb0qkxrfYbNf6nESBnGQRPNBjl3xkLuDzxOomcKItMBq22OwlAlxuNxCgg=
X-Received: by 2002:a17:90b:17cc:b0:330:6d2f:1b5d with SMTP id
 98e67ed59e1d1-343fa746bb1mr11596111a91.26.1763353957756; Sun, 16 Nov 2025
 20:32:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113005529.2494066-1-jon@nutanix.com> <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
 <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
In-Reply-To: <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 17 Nov 2025 12:32:25 +0800
X-Gm-Features: AWmQ_bmmS7p123oc35P2Z4K1bi2qA-5GyIOKkN9ecGPR6mCexnHaHFp0vKfQcx0
Message-ID: <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and put_user()
To: Jon Kohler <jon@nutanix.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 10:53=E2=80=AFPM Jon Kohler <jon@nutanix.com> wrote=
:
>
>
>
> > On Nov 12, 2025, at 8:09=E2=80=AFPM, Jason Wang <jasowang@redhat.com> w=
rote:
> >
> > !-------------------------------------------------------------------|
> >  CAUTION: External Email
> >
> > |-------------------------------------------------------------------!
> >
> > On Thu, Nov 13, 2025 at 8:14=E2=80=AFAM Jon Kohler <jon@nutanix.com> wr=
ote:
> >>
> >> vhost_get_user and vhost_put_user leverage __get_user and __put_user,
> >> respectively, which were both added in 2016 by commit 6b1e6cc7855b
> >> ("vhost: new device IOTLB API").
> >
> > It has been used even before this commit.
>
> Ah, thanks for the pointer. I=E2=80=99d have to go dig to find its genesi=
s, but
> its more to say, this existed prior to the LFENCE commit.
>
> >
> >> In a heavy UDP transmit workload on a
> >> vhost-net backed tap device, these functions showed up as ~11.6% of
> >> samples in a flamegraph of the underlying vhost worker thread.
> >>
> >> Quoting Linus from [1]:
> >>    Anyway, every single __get_user() call I looked at looked like
> >>    historical garbage. [...] End result: I get the feeling that we
> >>    should just do a global search-and-replace of the __get_user/
> >>    __put_user users, replace them with plain get_user/put_user instead=
,
> >>    and then fix up any fallout (eg the coco code).
> >>
> >> Switch to plain get_user/put_user in vhost, which results in a slight
> >> throughput speedup. get_user now about ~8.4% of samples in flamegraph.
> >>
> >> Basic iperf3 test on a Intel 5416S CPU with Ubuntu 25.10 guest:
> >> TX: taskset -c 2 iperf3 -c <rx_ip> -t 60 -p 5200 -b 0 -u -i 5
> >> RX: taskset -c 2 iperf3 -s -p 5200 -D
> >> Before: 6.08 Gbits/sec
> >> After:  6.32 Gbits/sec
> >
> > I wonder if we need to test on archs like ARM.
>
> Are you thinking from a performance perspective? Or a correctness one?

Performance, I think the patch is correct.

Thanks


