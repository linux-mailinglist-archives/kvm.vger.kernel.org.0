Return-Path: <kvm+bounces-45408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F0F4AA8D36
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 09:42:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FAF016CE1C
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 07:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86EC01DDA2D;
	Mon,  5 May 2025 07:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L8+YSsQ8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2476B176AC8
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 07:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746430924; cv=none; b=uRR68uucmJT9b0FZ8/VvtFbFo80FSFmlZoXvh7Uf0aSeySGRL69BIfw+cIx/M4ewg/e2VD12gKUUjroWRV1gVY3opT/zmRyB1Nx7vw87reTAVu26aTbrvwViQfT3xcgraiL8Y+4cJO9zfUVEdk4Q6AII/QLQ2JG4pbMPyj1dGSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746430924; c=relaxed/simple;
	bh=/1L4VXQZnM4TVg9Q0XEcQOC1Z7dwzdgPChSwdWfL7fE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pme6MWaRIx/poEjEaJKb5Mr0qiQeFLX63u8koWGzZwx4DyRlRZeWgRvD5Ngm8zt/VSsb6f4LziTkltvFnoaRhpy5b+Q9Z3JeRxsCeY2upppXSaobeKMEBXzS0uhM/EPb3IAC2Eqe8mY+8+XoLqyaQFAxpv/qEwMkeWur9xkYxtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L8+YSsQ8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746430922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NYutuEk9tS5pMcj+KQxarlK855jenHaF07JshpvJP/c=;
	b=L8+YSsQ8+P9sqJV5cM7/g78b36RtusH7MPiMI+1xBWNKz41Aow/lzebl2t9tq60+6+zTz5
	lppuhypd1xP1ha8uUx4Gwlv/3wkp7w9T7Bfcd27dBDacJFafBBR3+EK+83HAwDh0kfdg66
	zLxU7xA4nnNpEQXy4NT11etjpP7hLgE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-31_kxLGAOwCfXM5R-qId_A-1; Mon, 05 May 2025 03:42:00 -0400
X-MC-Unique: 31_kxLGAOwCfXM5R-qId_A-1
X-Mimecast-MFC-AGG-ID: 31_kxLGAOwCfXM5R-qId_A_1746430919
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5499d4435caso1682950e87.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 00:42:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746430919; x=1747035719;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NYutuEk9tS5pMcj+KQxarlK855jenHaF07JshpvJP/c=;
        b=Pn0+VPAiGMqQw8UK19fafLlAo5vLbBigK2/+tlGwNYagX+4aWChfrvkmCckxJYmJ02
         NHQKWxsQzP/RJY9piVfTqUb5p5BQhaRvC8ZJqdLZ5jBh/hfFX2cQ3If/1vu70knWC1Ob
         fq6R2TqNrL68A1VyFscHFIc8pojiExKJaI8G2q4iO/xPquXYS+cM//5td6Ez9lLfg+l+
         JDt5DXi9c8cqBjcSDbjThDlpTloCO8aYWLNweRm6trFHOFu7pd53fzj35dqCOYpOT307
         9mSfN3spOpY9Mwc/evmuMPTIXDezoxPnoeQjx2FHIPXBHHh6xavXXJN2RKuVMN2EiweV
         8XAg==
X-Forwarded-Encrypted: i=1; AJvYcCVsNU9lgWII9HqxDx0VeUQUlN6N1PJHLlF6FLPLkevj/CbHQPqndJVtq/O+T2Q/DxeGJ3c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMnF6uFXlX3oa6XYMfpeJR/ssWKQ1P/HCUZSaw6kuL44o2BPhg
	ahtFdbSspQ2tS2Xj/KxuKRxFkCnoM9RZXxXN6+qsPTZBIib4EnYFOZnrS4pv8Ajl2Od+z2p9INM
	fnFuv4eaadsSIaFD5cGRDY+MZrX3GVViHXeKvki8j72H8nn5UP8UMOC77XZutdoI=
X-Gm-Gg: ASbGncsr8pBdxa52jGXEcbQdhVclMNxjHk1XhfvqthQtv4SOiTf3xQex+Ho5pDw+1X6
	wqrRAecvLO1LIE0dmH2qJ/8OvKNwBpzcTQjR4LwpSAo5ACMpiREnKMUye0oyrQb5ca6H7KAfCbZ
	WB79mVB7aol1ZJ2nsXcGGKtB0WjqbLGwEBAtqu7uytcmWkor972gpRE/zTt3FLVRT/Tl/G/C2WQ
	mear858CCDblmSCnGVyrE1umiqBkBFApE3lg1dyOsK+mqv1nG7Y7uQCA5zIMyNtx6l2kdq3QxQt
	xGbr1BAJclR+vXbVdcq/874CZDu92A57bbXJOVJqgOim+ZUGqs4MTx73l6I=
X-Received: by 2002:a05:651c:992:b0:30b:bba5:ac18 with SMTP id 38308e7fff4ca-32348658683mr18819971fa.3.1746430918869;
        Mon, 05 May 2025 00:41:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsEsHgZOcmzKyEYKe53zgGMeSaMF3WinuQkv4wSGTWsyP+GpxlPUt85uINmh0HuIcOZYrSLQ==
X-Received: by 2002:a05:600c:1e09:b0:43c:f895:cb4e with SMTP id 5b1f17b1804b1-441cb49494cmr15680615e9.17.1746430567130;
        Mon, 05 May 2025 00:36:07 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2706:e010:b099:aac6:4e70:6198? ([2a0d:3344:2706:e010:b099:aac6:4e70:6198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b391c42bsm162401715e9.39.2025.05.05.00.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 00:36:06 -0700 (PDT)
Message-ID: <8cdf120d-a0f0-4dcc-a8f9-cea967ce6e7b@redhat.com>
Date: Mon, 5 May 2025 09:36:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v13 4/9] net: devmem: Implement TX path
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, io-uring@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Jeroen de Borst <jeroendb@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn
 <willemb@google.com>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>,
 Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>,
 sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>,
 Victor Nogueira <victor@mojatatu.com>, Pedro Tammela
 <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>,
 Kaiyuan Zhang <kaiyuanz@google.com>
References: <20250429032645.363766-1-almasrymina@google.com>
 <20250429032645.363766-5-almasrymina@google.com>
 <53433089-7beb-46cf-ae8a-6c58cd909e31@redhat.com>
 <CAHS8izMefrkHf9WXerrOY4Wo8U2KmxSVkgY+4JB+6iDuoCZ3WQ@mail.gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <CAHS8izMefrkHf9WXerrOY4Wo8U2KmxSVkgY+4JB+6iDuoCZ3WQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/2/25 9:20 PM, Mina Almasry wrote:
> On Fri, May 2, 2025 at 4:47 AM Paolo Abeni <pabeni@redhat.com> wrote:
>>> @@ -1078,7 +1092,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>>                               zc = MSG_ZEROCOPY;
>>>               } else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>>>                       skb = tcp_write_queue_tail(sk);
>>> -                     uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
>>> +                     uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb),
>>> +                                                 sockc_valid && !!sockc.dmabuf_id);
>>
>> If sock_cmsg_send() failed and the user did not provide a dmabuf_id,
>> memory accounting will be incorrect.
> 
> Forgive me but I don't see it. sockc_valid will be false, so
> msg_zerocopy_realloc will do the normal MSG_ZEROCOPY accounting. Then
> below whech check sockc_valid in place of where we did the
> sock_cmsg_send before, and goto err. I assume the goto err should undo
> the memory accounting in the new code as in the old code. Can you
> elaborate on the bug you see?

Uhm, I think I misread the condition used for msg_zerocopy_realloc()
last argument.

Re-reading it now it the problem I see is that if sock_cmsg_send() fails
after correctly setting 'dmabuf_id', msg_zerocopy_realloc() will account
the dmabuf memory, which looks unexpected.

Somewhat related, I don't see any change to the msg_zerocopy/ubuf
complete/cleanup path(s): what will happen to the devmem ubuf memory at
uarg->complete() time? It looks like it will go unexpectedly through
mm_unaccount_pinned_pages()???

Thanks,

Paolo


