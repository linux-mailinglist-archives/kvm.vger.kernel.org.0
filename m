Return-Path: <kvm+bounces-68603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF2BD3C474
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 11:03:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 48C0A560701
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2663D1CDB;
	Tue, 20 Jan 2026 09:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K8+JF6mM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="clDBS6kH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A2935FF66
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 09:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768901862; cv=none; b=Vt+7lADSbZwBI0QOD4D+JVbzisF9My2aXVAEfy2alEqLriisRk4BtkXVB/FxG7gLPkCQJyBN6Xu4/k6uMy9sxoapAtbdf0Lbv/qT3UPWG1a4gTsn7rp9BzOxkxYdXUqDp49Z0uLoUSBLAZDtXiRpiA9pa8gNimdCO0gpwASGQaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768901862; c=relaxed/simple;
	bh=gJ8LRdePpGdfZIJ/xvuV9faBPChp54PHBmUoMXirzAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l2ynJQaU4zvwbHSiuWZeA+bKQAgo4Neuo2A0GtC0P8OuCROte7pW2he34FrASW/CoFbyVhXe7pqYsGeR6AQQE8W1AhA+fbgJj5HQh7qOh2eXJQCcQNrukKrqZywIUAfBjlxon+GOH10+yWiHhA3ykXkHr8MyBEUPAmpJqRNOIdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K8+JF6mM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=clDBS6kH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768901859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1riUelQkHubbog4Pig/nehvQm9nmVpndQsv6Cs1UVao=;
	b=K8+JF6mMHL76bZxS+ci6CY7KEnR5jdjxJGutZ+fuCfQlF0fbr47SzwJjAOKJRQ0ugF1xb0
	2Y71nRwmVtTchM1c6Un9PoE5UDZrtlTG8co6aH7HiMY+vimmGji2SprwxZjyjaG8yEzvWS
	uC2gzmgydR7cJT0JMc9UHzoDT7IdtXQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-iu5cgXQ3O8Cexy2sk6E8hQ-1; Tue, 20 Jan 2026 04:37:37 -0500
X-MC-Unique: iu5cgXQ3O8Cexy2sk6E8hQ-1
X-Mimecast-MFC-AGG-ID: iu5cgXQ3O8Cexy2sk6E8hQ_1768901856
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430f57cd2caso4293341f8f.0
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 01:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768901856; x=1769506656; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1riUelQkHubbog4Pig/nehvQm9nmVpndQsv6Cs1UVao=;
        b=clDBS6kHuU02e+svmRR7saf/d/7sXPtTCBrZqdainfUer3Ca8mC7vbq2mu+aFLdw3Q
         I8aR/8hdlZSmln8sl3WNdIz6E+GzjWZGfvs9g7rMcQj1tic2Lr9Y+iJ9JE/ydbWCuKp5
         gbADY0103aGNyrfR/uFtF7+cZsOAaT0Q4eUlF3cIawQK/LLEZVlDzsdJMwO5niDelrC/
         iBthyFfxBDJdzuBix0iny0V/TJ0PUXFbcQrRrVd6BC4ZaN9b0lw9iOlovBcjTklRd0pp
         93gLowV0g6E+Oiz9wnlUStpTnPpaVnj7b5r1xJWDeDWXtdwk7hkGkVwDtRJo5oapXJHG
         4HhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768901856; x=1769506656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1riUelQkHubbog4Pig/nehvQm9nmVpndQsv6Cs1UVao=;
        b=EX/gjbEgv1h9sEzzG7JuL8xboiSwBh4C4q1vyVifETqaAxQ+28nVh6gnY6d+TrHNQ2
         IhmWC/IZZSDUx1YFZGOXzgNsqsBlmemfnmnunM7x3xGd+nWIsiQVnmnNjN316xBIIb6L
         5EWTkAtgJiLiKjQoBIaPHfjJsKLXow73ZSaKfihxyjvuYHm26W/H4Gmyp3+KFzHzgxXY
         tahK5EeljWrxPMqZJc47qa25EtsptSPZn/rguShnj1YqrbG1FqjYs2urcvksgOf2Y/IQ
         nwibs6+APABNHiRzPrxiy1UhBL0WFcgtEwuSUHe1cZNG4UZ3OSmaCtRiBaoCWBmgefU/
         GmNg==
X-Forwarded-Encrypted: i=1; AJvYcCVdYaAb+c6WPFN9uAbVzuwrbk1krorISt65oS1+11M25CCH7v7qxCO/0qWW//x7VzI6XXo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/bn8lQLiEkxiLYhhErDKCAUcL8S1v+hCvvD0YBFm5giDuZDOX
	D6BDcy8QPk0762L7072OgCe5lh36uVWLiflZxuBSANfdABugoMPlvJvnu+rBoj7YwBoTaiVCgC7
	A9nVV0oImKmj4Q6YyP1ODUoeVuAUKD/MyHk8AtQcHBhaXwHh0nc7amQ==
X-Gm-Gg: AZuq6aLdKzviTmOFIHOdI67/umEu1VLbVejBOWsCv17lDnubIdRsobZxOg/7e0LexFY
	yC40gUr6+ARDPBdU0EUGG6zzYRFX4Hwp34/4/DP1OtevkcKAfAucARmiX17bvFp5Lu4U46E4kWr
	bzdQg0ulT1Nbd2njygVkAELk1ZlKgP8PoH6P+pUzE4kjPN+7b8gly8sL4QnZ+x4nuDAujvX6T4o
	hvXNiSOsUr3XLNxE9xmcfYMxReD2k7ygNgJcxdiP8U9/HbPyLLOHBQVAVADRorxvxewTi7IaD0k
	xZakAoisNF6Q2sCmhTCINteJMjPMwXqk0tqPS1t3/lL3JzGT/QcrXyga/HTrzFynjp8uiDoNqus
	sJttgXD4taLbZ0fOGL0veIfxxGt6sHGX7J1UMFzQ+YDwkBojhL9z0VVPMBjc=
X-Received: by 2002:a05:6000:2f83:b0:432:5b81:480 with SMTP id ffacd0b85a97d-4356a03d2demr19167506f8f.24.1768901855982;
        Tue, 20 Jan 2026 01:37:35 -0800 (PST)
X-Received: by 2002:a05:6000:2f83:b0:432:5b81:480 with SMTP id ffacd0b85a97d-4356a03d2demr19167470f8f.24.1768901855514;
        Tue, 20 Jan 2026 01:37:35 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996cefdsm27663754f8f.24.2026.01.20.01.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 01:37:34 -0800 (PST)
Date: Tue, 20 Jan 2026 10:37:12 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, virtualization@lists.linux.dev, 
	"Michael S. Tsirkin" <mst@redhat.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>, 
	Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>, Simon Horman <horms@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Arseniy Krasnov <AVKrasnov@sberdevices.ru>, 
	Asias He <asias@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH RESEND net v5 0/4] vsock/virtio: fix TX credit handling
Message-ID: <aW9L0xiwotBnRMw2@sgarzare-redhat>
References: <20260116201517.273302-1-sgarzare@redhat.com>
 <20260119101734.01cbe934@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260119101734.01cbe934@kernel.org>

On Mon, Jan 19, 2026 at 10:17:34AM -0800, Jakub Kicinski wrote:
>On Fri, 16 Jan 2026 21:15:13 +0100 Stefano Garzarella wrote:
>> Resend with the right cc (sorry, a mistake on my env)
>
>Please don't resend within 24h unless asked to:
>https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#tl-dr

Sorry for that, I'll avoid in the future.

>
>> The original series was posted by Melbin K Mathew <mlbnkm1@gmail.com> till
>> v4: https://lore.kernel.org/netdev/20251217181206.3681159-1-mlbnkm1@gmail.com/
>>
>> Since it's a real issue and the original author seems busy, I'm sending
>> the v5 fixing my comments but keeping the authorship (and restoring mine
>> on patch 2 as reported on v4).
>
>Does not apply to net:
>
>Switched to a new branch 'vsock-virtio-fix-tx-credit-handling'
>Applying: vsock/virtio: fix potential underflow in virtio_transport_get_credit()
>Applying: vsock/test: fix seqpacket message bounds test
>Applying: vsock/virtio: cap TX credit to local buffer size
>Applying: vsock/test: add stream TX credit bounds test
>error: patch failed: tools/testing/vsock/vsock_test.c:2414
>error: tools/testing/vsock/vsock_test.c: patch does not apply
>Patch failed at 0004 vsock/test: add stream TX credit bounds test
>hint: Use 'git am --show-current-patch=diff' to see the failed patch
>hint: When you have resolved this problem, run "git am --continue".
>hint: If you prefer to skip this patch, run "git am --skip" instead.
>hint: To restore the original branch and stop patching, run "git am --abort".
>hint: Disable this message with "git config set advice.mergeConflict false"
>
>Did you generate against net-next or there's some mid-air collision?
>(if the former please share the resolution for the resulting conflict;))

Ooops, a new test landed in net, this should be the resolution:

diff --cc tools/testing/vsock/vsock_test.c
index 668fbe9eb3cc,6933f986ef2a..000000000000
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@@ -2414,11 -2510,11 +2510,16 @@@ static struct test_case test_cases[] =
                 .run_client = test_stream_accepted_setsockopt_client,
                 .run_server = test_stream_accepted_setsockopt_server,
         },
  +      {
  +              .name = "SOCK_STREAM virtio MSG_ZEROCOPY coalescence corruption",
  +              .run_client = test_stream_msgzcopy_mangle_client,
  +              .run_server = test_stream_msgzcopy_mangle_server,
  +      },
+       {
+               .name = "SOCK_STREAM TX credit bounds",
+               .run_client = test_stream_tx_credit_bounds_client,
+               .run_server = test_stream_tx_credit_bounds_server,
+       },
         {},
   };


If you prefer I can send a v6. In the mean time I pushed the branch 
here: 
https://github.com/stefano-garzarella/linux/tree/vsock_virtio_fix_tx_credit

Thanks,
Stefano


