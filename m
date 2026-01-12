Return-Path: <kvm+bounces-67757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D4D14D1302A
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 15:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 939653019575
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14F535E558;
	Mon, 12 Jan 2026 14:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NAICmjoH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BwJFCwfJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A12335CBDC
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 14:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768226893; cv=none; b=macCZfnyR7/ALwFO/MBDoml2WazCnHKhWIuWKWzX8TYKPOptV+NJ/H9txzlFcIU0BudHF7K6N6kJ7g1DFrVbRfRkaehXt7BxR+/apommmeQQOQXxQnuem2CDaOpDIomAo5TJiYQPw5e6t92zP1detoyULvhhkOEc6LufCRxtvK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768226893; c=relaxed/simple;
	bh=GKvx/1ooBKBcUVjPLmQrzQL3r3xI5Pp++pamyt5l+xI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+/b39n5Qrek7f3vWoZoyOSkyj9UHCqlB6+lYgzSpI8JRf9Ba5LjKYOqzgOYcaqQLkvUCCHS6+EXi3uoL/LOxfJ/iwHfqPKephF+EKj4VZey5mbliQh5B4Qzi5cbQxtpaa0SAEiOsxDYda5YE4pMdxRmkB0/ODnJDviNavTU8+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NAICmjoH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BwJFCwfJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768226891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d5E7sq9k7DMQGsacG+F/JxI7pmnfHnE90xymu2cg9dU=;
	b=NAICmjoHMeQNm+opLTYEk0mteq+0GDrQCSdJ3Z78YmiNP/0nxhCkTeHw6tBs4EbUzeknib
	u+Dfo82UjDPxc8HHjj4sDea8uHqEdDnhfxSHe41SiL5ic2UaAu7ZUBoH7GRm71o5ntqU6x
	3r87dBYRQK/CR3P+jZ9ORI/O14eLxZg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-nJlrM8SUNFquU6O0oUEf1w-1; Mon, 12 Jan 2026 09:08:10 -0500
X-MC-Unique: nJlrM8SUNFquU6O0oUEf1w-1
X-Mimecast-MFC-AGG-ID: nJlrM8SUNFquU6O0oUEf1w_1768226889
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47d1622509eso41827355e9.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 06:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768226889; x=1768831689; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d5E7sq9k7DMQGsacG+F/JxI7pmnfHnE90xymu2cg9dU=;
        b=BwJFCwfJem6coQD1TwibLTPyES5aolTKDn7+uDR48U2UVSCv0cmH9BTgK8lDLW1PCn
         gWgQx2kNe2daPhqRggid1DK5a52exJJ//p0cUVLU40lzJIzmMh222GwcptcXSkraLNx/
         YvQpXfcrGEeR5f5MFXKYWA6Qomh65uluDBTjWY3gRXJ8FAJA6zaxOrblgXPBUNPbjrAL
         pgWWRxpGkccJAxzVEjoWeAaK0krDY8bDPRmvk2sqzd0ophMSAJGVCK7i7UtPihOVJA9t
         3bgpn91/5q19NhrXDi++vUZCJ+DgQRHiIE9kClFte+I3jkXd0KX+EYXqCKZhol59riyW
         ZmWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768226889; x=1768831689;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d5E7sq9k7DMQGsacG+F/JxI7pmnfHnE90xymu2cg9dU=;
        b=ptb4fsmMDr6kEPeASbcRlAglIyyklkzE1fByDrqMfHor2SvHdSKTRkMwf7pZhabHao
         amlTnl44hAagWRoSkGLmqn5aWMvGs2o1DleLseIL3JgYH6IN4KQhW7uR/k1jfYdyHrY+
         sjBdqH2vtHzl1rOC92APpAG9Th8/MZOwqE2t7KUsZX+qHAjIeRDyrrLLBDyL/xGcA0YY
         tIM+wtHIbItQH6lsStF+Z4gc3Tt93WpK3xIDQQQB9OrwI2c64tjnbrIIr6aufYuhuO9f
         TG3enhNz9gSnxKr8ZoF7TxT6kp7Q1lPpeoUdvXgzOH6dcKU/W2ji54LCHGFxEO3MxGDr
         VPzA==
X-Forwarded-Encrypted: i=1; AJvYcCVlQBLpRTi4iyPj0XSKss5rVYdPqEGYDqIfPC43hOIHtQn3QBeCX5o3rkFSSkmKyZg0ems=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp0xqIYJfeXKxJ7z7+F1yZJZM7qMDqw9incckwlQYQY5azhhKx
	ZakI4Zg0MBFNiumfiAIYpQCQrPKMBUHlXecMSSYHP3ydVxc8cPwVdMruc1KKqbGUSIPZItigNu6
	CWc2dfTFvGN3aVgjZXSXIBjEd49lqAXRaqhJBO+i29ov3/IMyk4uzdQ==
X-Gm-Gg: AY/fxX4ezyRMLTdaAOMkOaBUJniJwcXjf+GRIxTJ3P7gEcRW3VMmrCP163NBGpiw1/r
	0RsmagthBulDwS7NnAD9At1UcWkujOuRhLE+fmLESRz61gwh53XG/YW/VQgBFxVT+FU7X42OxpN
	+d7FlcIHLLXrql3vO+OAEbKprA8ea4wCstnX1Qn/qeCVbyuLaqWKBwt2HUimVVB5KZi+55qr1kM
	KO0P2Irl2PzbLnn0LbFJzIUT23TPCgEJA+qMlYbfF/Zhx97qggD/qIuRYL432sNkdE5WkENVnXr
	72rbvmJPSItzGD3Wlwq8Aoyw1H3x5t018ikQGHyeG7TCPSDZWWb5r3mhOap6668qAi2SJT7JFdL
	3onAnxM2F5gkcehBe69MWoYOf5S1D9fvD9YO1Ug0PoSOeNf0fhvn2BEAZEzI8WQ==
X-Received: by 2002:a05:600c:a10a:b0:47d:92bb:2723 with SMTP id 5b1f17b1804b1-47d92bb28a9mr88376395e9.3.1768226888785;
        Mon, 12 Jan 2026 06:08:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFSA8MeLEwBc5V/8h9ZTRtoroYd4ri8KOUDoLboqzGTL/mHH9z1of/NksaN4ZE17gxAdWjfFQ==
X-Received: by 2002:a05:600c:a10a:b0:47d:92bb:2723 with SMTP id 5b1f17b1804b1-47d92bb28a9mr88375885e9.3.1768226888223;
        Mon, 12 Jan 2026 06:08:08 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-25-233.business.telecomitalia.it. [87.12.25.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0dacd1sm38203341f8f.4.2026.01.12.06.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:08:07 -0800 (PST)
Date: Mon, 12 Jan 2026 15:07:58 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Arseniy Krasnov <avkrasnov@salutedevices.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vsock/virtio: Coalesce only linear skb
Message-ID: <aWT-IkOVbrq1Bhse@sgarzare-redhat>
References: <20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co>
 <20260108-vsock-recv-coalescence-v1-1-26f97bb9a99b@rbox.co>
 <aWEnYm6ePitdHPQe@sgarzare-redhat>
 <ae564ab4-2dd2-4a12-a92c-b613fa430829@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ae564ab4-2dd2-4a12-a92c-b613fa430829@rbox.co>

On Sun, Jan 11, 2026 at 11:59:44AM +0100, Michal Luczaj wrote:
>On 1/9/26 17:18, Stefano Garzarella wrote:
>> On Thu, Jan 08, 2026 at 10:54:54AM +0100, Michal Luczaj wrote:
>...
>>> @@ -1375,7 +1375,8 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>>> 		 * of a new message.
>>> 		 */
>>> 		if (skb->len < skb_tailroom(last_skb) &&
>>> -		    !(le32_to_cpu(last_hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)) {
>>> +		    !(le32_to_cpu(last_hdr->flags) & VIRTIO_VSOCK_SEQ_EOM) &&
>>> +		    !skb_is_nonlinear(skb)) {
>>
>> Why here? I mean we can do the check even early, something like this:
>>
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -1361,7 +1361,8 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>>           * to avoid wasting memory queueing the entire buffer with a small
>>           * payload.
>>           */
>> -       if (len <= GOOD_COPY_LEN && !skb_queue_empty(&vvs->rx_queue)) {
>> +       if (len <= GOOD_COPY_LEN && !skb_queue_empty(&vvs->rx_queue) &&
>> +           !skb_is_nonlinear(skb)) {
>>                  struct virtio_vsock_hdr *last_hdr;
>>                  struct sk_buff *last_skb;
>
>Right, can do. I've assumed skb being non-linear is the least likely in
>this context.

Yeah, but it's a very simple check, so IMHO the code is more readable if 
we put it in the first conditions, where we check if the current packet 
has the requisites, rather than in the nested conditions, where we check 
that the packet already queued can receive the new payload.

>
>> I would also add the reason in the comment before that to make it clear.
>
>OK, sure.
>

Thanks,
Stefano


