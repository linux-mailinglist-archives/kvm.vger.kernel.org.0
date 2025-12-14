Return-Path: <kvm+bounces-65935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E08ECBB707
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 07:38:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0F078300A1D0
	for <lists+kvm@lfdr.de>; Sun, 14 Dec 2025 06:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86693279907;
	Sun, 14 Dec 2025 06:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QFP4YU7N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F48270EDF
	for <kvm@vger.kernel.org>; Sun, 14 Dec 2025 06:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765694308; cv=none; b=gHDiYaQi2g4aX7tUNFsTzE7gTipWX2fw051yejelsOT1IbYNr9SQceSYloC30FlXJzacwSU071iA0XYDfl37VaRbvsYxl8ZYjCYfFK6niYGNnMHU27knp2XiBNqilw5FH/1kzStVUo/dblPyCquQOOmpIsOMquU+5T+WqvDxH5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765694308; c=relaxed/simple;
	bh=yLpYmY+EhSy4abAWbhr3gJTq77TsZsZuhspXQY+yB4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sPfrnrNjbiNPgFsNJc4QS1G+WjEBzYLwXZ4J63Hb8UpBN4No8PNmn64RvHoE3ha291tP26y4GS5SqSenNrWtGhYShlwGtmsvY8G3UrWCMsWpr9Xp+s6GPHTWeQHXMI0cVUqvPzhsiF+eeVGCR7LZCTT46gfxz+lg4mQtbiRkVk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QFP4YU7N; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47795f6f5c0so16188085e9.1
        for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 22:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765694305; x=1766299105; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=axrQHkzxz0KpEHvUlLXeQIagSIg4MG47QjW3/6LfZU0=;
        b=QFP4YU7NDeW+pSOvykTx/rhizAOcpJsoml9GkQ/AUDpFqIbsgRjnh+bX2toNcLpU3u
         E7YW8JwhvQhhtjuSpRs02nhXNiZRxyuwgzb/LLLGGM8QMcT622R/ag70u1IDJgcx7dYs
         SM/gNWTaPVSkF3/GewINVv8cBxQGQjZYC9Vd1V67qvgWLRyiR3z8W85TN6etroRYHtER
         2aiA1P/Rdhd0GaJ+VCJMVQyAial+GB7m8r0czy3wpGJ1+ujcNA9meT9vuZWrKRWY/KXy
         ANb6vLgIDZACJhra6sw+rzoOmdIzn2P/39q4z0yofWwjIlwXc+6BnYpHQ9FoPqrGubn4
         u94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765694305; x=1766299105;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=axrQHkzxz0KpEHvUlLXeQIagSIg4MG47QjW3/6LfZU0=;
        b=lH5TyL/+YUBTnodfz/rvlptx3CwRF0XU/QsF30eDnL6Jf+ZWwtO3Mik0WODjfJ+Sgv
         OpywVdLHsQDLqzp0s/9Rtcz7/A8VVyeoPjhpqN7ewxecJH9SDfYLS9vJ1fU7wVJ8sb5j
         d1kQIqvUH31fELCy0+Z/Xa0LdQmi0qPNPNGb93baZKODbpTA4AoguLVLtHCv2aCeGxhL
         ZJ8kW+rCyw3mdMaQC66de0S5eC3Du0A23FCl2YxMRD60iigj6aIs0pzNvQ663isfuQ9B
         G9L9pp+dSrIqLABgvl1D9DhX4zjis8+nEPPNrcC4IisIGjfcVUcZXv0XAlxoeuj9YL/0
         BlZg==
X-Forwarded-Encrypted: i=1; AJvYcCU4FRHUnKEWXtPr5VVbe8SgZKHBUTnAT2FIuoarYQhWF+b/4cQv1qvY+dPeybZuqL0Z5ac=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYVgIhUpZHiRFLZ6d8XumFAJkpEu3ectDuphERkFUIZ2ECaHCW
	DLXEC5uUQ2uxU71eCACVGq9QoKQ4HzF6lIdbklbFkWPcW4hLwilb+qpQ
X-Gm-Gg: AY/fxX4Alav6zUVbGXzC7lX2TokRr3JKqXYBudBDqDhUm0DTMu7w+KnjzyVs8QKveIi
	hPV+fWXdsvXqTgsKt7ZA3JBZE74FBqvUKa/8X5aTVeumGFNXcmIy77BUy6px1xWVGqkglM57y/4
	YD1vfq0aF7H8IpDTZgUdlK9JSyTUOFm8LkhxdUnOmQPJ4g3TBuoy0o0XjKOda8+EFQFgA2Qw5Gu
	dcgMfohvmAb76fgYbXcDjnxdQehjg40SrN8tc1EElvim+xy1sydc/KZNx3vj0RHC465rweCMEiL
	ZIOXP0jJRnJqmlPgVaIORqANRV6veL6UhldHj02pDr1SOW92mR2zdTql9QIjqgVMB3miyknedy+
	Gv1gv7wK1izI9uI2UZ3cIybOUrIRSCCQRtjhYsoJ+92oEu6s1pi52qyhBlHrW3+7UL0Can6OZti
	y/1PSYK5m1jBZwqyl8v1jf0sFLnhWgbaDupgRWELLiwI1aTWpCHTGJakmyHtYs7X0nbxE6B7Jks
	5De9G4=
X-Google-Smtp-Source: AGHT+IG9JoSb6msVo1qCxcATC1m0efC94+Z21fe2Smru+QlOODZum3iTG70a6YMjFsBcs3efW3tTXQ==
X-Received: by 2002:a05:600c:6291:b0:479:3a2a:94e7 with SMTP id 5b1f17b1804b1-47a8f8b1449mr72294215e9.10.1765694304770;
        Sat, 13 Dec 2025 22:38:24 -0800 (PST)
Received: from [192.168.0.173] (108.228-30-62.static.virginmediabusiness.co.uk. [62.30.228.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-430f7475895sm2899972f8f.33.2025.12.13.22.38.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Dec 2025 22:38:23 -0800 (PST)
Message-ID: <24b9961d-7e0d-4239-97b3-39799524909f@gmail.com>
Date: Sun, 14 Dec 2025 06:38:22 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3] vsock/virtio: cap TX credit to local buffer size
Content-Language: en-GB
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, stefanha@redhat.com,
 kvm@vger.kernel.org, netdev@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org
References: <20251211125104.375020-1-mlbnkm1@gmail.com>
 <20251211080251-mutt-send-email-mst@kernel.org>
 <zlhixzduyindq24osaedkt2xnukmatwhugfkqmaugvor6wlcol@56jsodxn4rhi>
 <CAMKc4jDpMsk1TtSN-GPLM1M_qp_jpoE1XL1g5qXRUiB-M0BPgQ@mail.gmail.com>
 <CAGxU2F7WOLs7bDJao-7Qd=GOqj_tOmS+EptviMphGqSrgsadqg@mail.gmail.com>
 <CAMKc4jDLdcGsL5_d+4CP6n-57s-R0vzrX2M7Ni=1GeCB1cxVYA@mail.gmail.com>
 <bwmol6raorw233ryb3dleh4meaui5vbe7no53boixckl3wgclz@s6grefw5dqen>
 <deccf66c-dcd3-4187-9fb6-43ddf7d0a905@gmail.com>
 <tandvvk6vas3kgqjuo6w3aagqai246qxejfnzhkbvbxds3w4y6@umqvf7f3m5ie>
From: Melbin K Mathew <mlbnkm1@gmail.com>
In-Reply-To: <tandvvk6vas3kgqjuo6w3aagqai246qxejfnzhkbvbxds3w4y6@umqvf7f3m5ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 12/12/2025 12:26, Stefano Garzarella wrote:
> On Fri, Dec 12, 2025 at 11:40:03AM +0000, Melbin K Mathew wrote:
>>
>>
>> On 12/12/2025 10:40, Stefano Garzarella wrote:
>>> On Fri, Dec 12, 2025 at 09:56:28AM +0000, Melbin Mathew Antony wrote:
>>>> Hi Stefano, Michael,
>>>>
>>>> Thanks for the suggestions and guidance.
>>>
>>> You're welcome, but please avoid top-posting in the future:
>>> https://www.kernel.org/doc/html/latest/process/submitting- 
>>> patches.html#use-trimmed-interleaved-replies-in-email-discussions
>>>
>> Sure. Thanks
>>>>
>>>> I’ve drafted a 4-part series based on the recap. I’ve included the
>>>> four diffs below for discussion. Can wait for comments, iterate, and
>>>> then send the patch series in a few days.
>>>>
>>>> ---
>>>>
>>>> Patch 1/4 — vsock/virtio: make get_credit() s64-safe and clamp 
>>>> negatives
>>>>
>>>> virtio_transport_get_credit() was doing unsigned arithmetic; if the
>>>> peer shrinks its window, the subtraction can underflow and look like
>>>> “lots of credit”. This makes it compute “space” in s64 and clamp < 0
>>>> to 0.
>>>>
>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c
>>>> b/net/vmw_vsock/virtio_transport_common.c
>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>> @@ -494,16 +494,23 @@ 
>>>> EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
>>>> u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 
>>>> credit)
>>>> {
>>>> + s64 bytes;
>>>>  u32 ret;
>>>>
>>>>  if (!credit)
>>>>  return 0;
>>>>
>>>>  spin_lock_bh(&vvs->tx_lock);
>>>> - ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>>>> - if (ret > credit)
>>>> - ret = credit;
>>>> + bytes = (s64)vvs->peer_buf_alloc -
>>>
>>> Why not just calling virtio_transport_has_space()?
>> virtio_transport_has_space() takes struct vsock_sock *, while 
>> virtio_transport_get_credit() takes struct virtio_vsock_sock *, so I 
>> cannot directly call has_space() from get_credit() without changing 
>> signatures.
>>
>> Would you be OK if I factor the common “space” calculation into a 
>> small helper that operates on struct virtio_vsock_sock * and is used 
>> by both paths? Something like:
> 
> Why not just change the signature of virtio_transport_has_space()?
Thanks, that is cleaner.

For Patch 1 i'll change virtio_transport_has_space() to take
struct virtio_vsock_sock * and call it from both
virtio_transport_stream_has_space() and virtio_transport_get_credit().

/*
  * Return available peer buffer space for TX (>= 0).
  *
  * Use s64 arithmetic so that if the peer shrinks peer_buf_alloc while
  * we have bytes in flight (tx_cnt - peer_fwd_cnt), the subtraction does
  * not underflow into a large positive value as it would with u32.
  *
  * Must be called with vvs->tx_lock held.
  */
static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs)
{
	s64 bytes;

	bytes = (s64)vvs->peer_buf_alloc -
		((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
	if (bytes < 0)
		bytes = 0;

	return bytes;
}

s64 virtio_transport_stream_has_space(struct vsock_sock *vsk)
{
	struct virtio_vsock_sock *vvs = vsk->trans;
	s64 bytes;

	spin_lock_bh(&vvs->tx_lock);
	bytes = virtio_transport_has_space(vvs);
	spin_unlock_bh(&vvs->tx_lock);

	return bytes;
}

u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
{
	u32 ret;

	if (!credit)
		return 0;

	spin_lock_bh(&vvs->tx_lock);
	ret = min_t(u32, credit, (u32)virtio_transport_has_space(vvs));
	vvs->tx_cnt += ret;
	vvs->bytes_unsent += ret;
	spin_unlock_bh(&vvs->tx_lock);

	return ret;
}

Does this look right?
> Thanks,
> Stefano
> 
>>
>> /* Must be called with vvs->tx_lock held. Returns >= 0. */
>> static s64 virtio_transport_tx_space(struct virtio_vsock_sock *vvs)
>> {
>>     s64 bytes;
>>
>>     bytes = (s64)vvs->peer_buf_alloc -
>>         ((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
>>     if (bytes < 0)
>>         bytes = 0;
>>
>>     return bytes;
>> }
>>
>> Then:
>>
>> get_credit() would do bytes = virtio_transport_tx_space(vvs); ret = 
>> min_t(u32, credit, (u32)bytes);
>>
>> has_space() would use the same helper after obtaining vvs = vsk->trans;
>>
>> Does that match what you had in mind, or would you prefer a different 
>> factoring?
>>
>>>
>>>> + ((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
>>>> + if (bytes < 0)
>>>> + bytes = 0;
>>>> +
>>>> + ret = min_t(u32, credit, (u32)bytes);
>>>>  vvs->tx_cnt += ret;
>>>>  vvs->bytes_unsent += ret;
>>>>  spin_unlock_bh(&vvs->tx_lock);
>>>>
>>>>  return ret;
>>>> }
>>>>
>>>>
>>>> ---
>>>>
>>>> Patch 2/4 — vsock/virtio: cap TX window by local buffer (helper + use
>>>> everywhere in TX path)
>>>>
>>>> Cap the effective advertised window to min(peer_buf_alloc, buf_alloc)
>>>> and use it consistently in TX paths (get_credit, has_space,
>>>> seqpacket_enqueue).
>>>>
>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c
>>>> b/net/vmw_vsock/virtio_transport_common.c
>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>> @@ -491,6 +491,16 @@ void virtio_transport_consume_skb_sent(struct
>>>> sk_buff *skb, bool consume)
>>>> }
>>>> EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
>>>> +/* Return the effective peer buffer size for TX credit computation.
>>>> + *
>>>> + * The peer advertises its receive buffer via peer_buf_alloc, but 
>>>> we cap it
>>>> + * to our local buf_alloc (derived from SO_VM_SOCKETS_BUFFER_SIZE and
>>>> + * already clamped to buffer_max_size).
>>>> + */
>>>> +static u32 virtio_transport_tx_buf_alloc(struct virtio_vsock_sock 
>>>> *vvs)
>>>> +{
>>>> + return min(vvs->peer_buf_alloc, vvs->buf_alloc);
>>>> +}
>>>>
>>>> u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 
>>>> credit)
>>>> {
>>>>  s64 bytes;
>>>> @@ -502,7 +512,8 @@ u32 virtio_transport_get_credit(struct
>>>> virtio_vsock_sock *vvs, u32 credit)
>>>>  return 0;
>>>>
>>>>  spin_lock_bh(&vvs->tx_lock);
>>>> - bytes = (s64)vvs->peer_buf_alloc -
>>>> + bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
>>>>  ((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
>>>>  if (bytes < 0)
>>>>  bytes = 0;
>>>> @@ -834,7 +845,7 @@ virtio_transport_seqpacket_enqueue(struct 
>>>> vsock_sock *vsk,
>>>>  spin_lock_bh(&vvs->tx_lock);
>>>>
>>>> - if (len > vvs->peer_buf_alloc) {
>>>> + if (len > virtio_transport_tx_buf_alloc(vvs)) {
>>>>  spin_unlock_bh(&vvs->tx_lock);
>>>>  return -EMSGSIZE;
>>>>  }
>>>> @@ -884,7 +895,8 @@ static s64 virtio_transport_has_space(struct
>>>> vsock_sock *vsk)
>>>>  struct virtio_vsock_sock *vvs = vsk->trans;
>>>>  s64 bytes;
>>>>
>>>> - bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>>>> + bytes = (s64)virtio_transport_tx_buf_alloc(vvs) -
>>>> + ((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);
>>>>  if (bytes < 0)
>>>>  bytes = 0;
>>>>
>>>>  return bytes;
>>>> }
>>>>
>>>>
>>>> ---
>>>>
>>>> Patch 3/4 — vsock/test: fix seqpacket msg bounds test (set client 
>>>> buf too)
>>>
>>> Please just include in the series the patch I sent to you.
>>>
>> Thanks. I'll use your vsock_test.c patch as-is for 3/4
>>>>
>>>> After fixing TX credit bounds, the client can fill its TX window and
>>>> block before it wakes the server. Setting the buffer on the client
>>>> makes the test deterministic again.
>>>>
>>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/ 
>>>> vsock_test.c
>>>> --- a/tools/testing/vsock/vsock_test.c
>>>> +++ b/tools/testing/vsock/vsock_test.c
>>>> @@ -353,6 +353,7 @@ static void test_stream_msg_peek_server(const
>>>> struct test_opts *opts)
>>>>
>>>> static void test_seqpacket_msg_bounds_client(const struct test_opts 
>>>> *opts)
>>>> {
>>>> + unsigned long long sock_buf_size;
>>>>  unsigned long curr_hash;
>>>>  size_t max_msg_size;
>>>>  int page_size;
>>>> @@ -366,6 +367,18 @@ static void
>>>> test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>>>>  exit(EXIT_FAILURE);
>>>>  }
>>>>
>>>> + sock_buf_size = SOCK_BUF_SIZE;
>>>> +
>>>> + setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
>>>> +    sock_buf_size,
>>>> +    "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
>>>> +
>>>> + setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
>>>> +    sock_buf_size,
>>>> +    "setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
>>>> +
>>>>  /* Wait, until receiver sets buffer size. */
>>>>  control_expectln("SRVREADY");
>>>>
>>>>
>>>> ---
>>>>
>>>> Patch 4/4 — vsock/test: add stream TX credit bounds regression test
>>>>
>>>> This directly guards the original failure mode for stream sockets: if
>>>> the peer advertises a large window but the sender’s local policy is
>>>> small, the sender must stall quickly (hit EAGAIN in nonblocking mode)
>>>> rather than queueing megabytes.
>>>
>>> Yeah, using nonblocking mode LGTM!
>>>
>>>>
>>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/ 
>>>> vsock_test.c
>>>> --- a/tools/testing/vsock/vsock_test.c
>>>> +++ b/tools/testing/vsock/vsock_test.c
>>>> @@ -349,6 +349,7 @@
>>>> #define SOCK_BUF_SIZE (2 * 1024 * 1024)
>>>> +#define SMALL_SOCK_BUF_SIZE (64 * 1024ULL)
>>>> #define MAX_MSG_PAGES 4
>>>>
>>>> /* Insert new test functions after test_stream_msg_peek_server, before
>>>>  * test_seqpacket_msg_bounds_client (around line 352) */
>>>>
>>>> +static void test_stream_tx_credit_bounds_client(const struct 
>>>> test_opts *opts)
>>>> +{
>>>> + ... /* full function as provided */
>>>> +}
>>>> +
>>>> +static void test_stream_tx_credit_bounds_server(const struct 
>>>> test_opts *opts)
>>>> +{
>>>> + ... /* full function as provided */
>>>> +}
>>>>
>>>> @@ -2224,6 +2305,10 @@
>>>>  .run_client = test_stream_msg_peek_client,
>>>>  .run_server = test_stream_msg_peek_server,
>>>>  },
>>>> + {
>>>> + .name = "SOCK_STREAM TX credit bounds",
>>>> + .run_client = test_stream_tx_credit_bounds_client,
>>>> + .run_server = test_stream_tx_credit_bounds_server,
>>>> + },
>>>
>>> Please put it at the bottom. Tests are skipped by index, so we don't 
>>> want to change index of old tests.
>>>
>>> Please fix your editor, those diffs are hard to read without tabs/ 
>>> spaces.
>> seems like some issue with my email client. Hope it is okay now
>>>
>>> Thanks,
>>> Stefano
>>>
>>
> 


