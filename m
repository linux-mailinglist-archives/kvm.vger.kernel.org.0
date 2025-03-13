Return-Path: <kvm+bounces-40915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F036A5F13E
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 11:48:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97F8019C1B44
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 10:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088B9265CAF;
	Thu, 13 Mar 2025 10:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J82pn6a9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883981F0E2A
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 10:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741862873; cv=none; b=IMAYg4VpX6zbO6eDUsHMWz3gFMgKYVALp1ESeUyXwAMA1NuZVpNx0hiHtAs4fPAymgKRIKS+8BDIipIFG5plhR61GhRUFrtDnBQWOvdg+Dx3nhTZdag4pFooTr0/JaIinT6VwGb0DVr52zOAjs7nWOgvVQ9ogDOikFa7DLjuNDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741862873; c=relaxed/simple;
	bh=flFI4F9iJbigAdLeH1msK0WPNSRRKGt+NPtx2Z0lY7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PlIrFjfWnLkz+8s8wf759x+Lh7yjGQylNUDLbvwHYH6K8KksJt+HMJrArbgNfa+fOf/VpEDro/dq/chF2nbM/gead1eY/nJQuz396zpDXXhoAIG75udCvUBMFdOJu6vcBXzJCeyj2gsOR5kyLqpUtkp9XunFIRLr/fThavbfwUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J82pn6a9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741862870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mKlH8svYGZq8nS9wIHoOZaP2tIWMcEGLEEAOkrVCTz8=;
	b=J82pn6a9BqLAFjIB07wt6XutQpavmvmdhT1GYoD1EsY6/V2YBy054F2CC35+Fpp9sFQhAP
	YjcW7mJUeGbeCNUs2nqLInIJbfgq5U9+c/itscgRhfpsa7StOn5g+DEkT9zrbGLs/Y0OyV
	onGN+fMkBqI9gsHWi+9yBPM55yr+Ipw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-2M2QSvPhMmqb_NCBaVnUZw-1; Thu, 13 Mar 2025 06:47:49 -0400
X-MC-Unique: 2M2QSvPhMmqb_NCBaVnUZw-1
X-Mimecast-MFC-AGG-ID: 2M2QSvPhMmqb_NCBaVnUZw_1741862868
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43d025a52c2so4119855e9.0
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 03:47:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741862868; x=1742467668;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mKlH8svYGZq8nS9wIHoOZaP2tIWMcEGLEEAOkrVCTz8=;
        b=FfXIAXwI88csAlQcsouexAhcPXmeV/KbRq9mhjPXCmrimTu2jNJL2VXWn/2v3cthFq
         /e/y+2kTGGkXPdzZ+zvCyU8wv68jHtDwPS4JsGoEJn+OnKVemr32yjAcSw+Vl3YeW3O8
         iDPvRYjMX1qZNMBmObjApTNH6PoGPj/++ZeqPfZUr9lUr5NlB4a09cv1Ng0qOkHwdMRh
         U6UM9OaFh9iy3Gqa3u7PxjQgd2fyOlzgzVCUcBziHwxR9ffB7q4i2mPgAb6JWQqPPYqB
         mnBa+9iuyIwNINzzrxTHB9fpWAdGjcMjknzhtqK1HYTurhSmCwii1otXVxbJH7UaQ9jn
         1RsA==
X-Forwarded-Encrypted: i=1; AJvYcCVhazNDL8sPgQyREYghsHLC1cY1zQSp4HTqKPRuCobn5CSYmLVEg8jlAORrM1LflEvIBOM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbVsXMDI5syxV0QD1ZAiQolSqLQbXwmC73Xo+sWEDqmVARlHPF
	W6E/xnhvzQ148FpVTLUQ5Ig2T4lw2k42TFIZElQlwgmXcI7i6DJmkZQxkrwwA66nwUyD/6+P6cb
	W/+LgxNqq4sNF5SyrKXNtvIHXssW3Hsa40JAwApCPHUtVAcskxw==
X-Gm-Gg: ASbGncuxKzaM4XioN/eRG/ZgOvl0zVRy4mISuPoUMdCXtZl5FJyGVNvH4KArGiNgHXS
	UNzz47RPrYgQqnM8gnT6X86TZ7b+OMHP0AfCgvpyd0OA/HBINL1RcPvX4sulT/D3mrfxLvf39XQ
	hVlIlPOJC+cxLATLSs0AckFhlB2wd3BMoRgiv7Z2qGpTUsh33D/sf8PoLoQNGkn73QkOvTzBqzW
	B0fkLkNV2KTHCNLLBSZCcotRGDB1o/zHPV2JO0BofJ9CCXxBJO4gKWjIC72HxJ7uFUX4HLAGGEx
	l21kJNHrMydxuEy5DFgM0+iOBPLPl/llIbpDWTbt
X-Received: by 2002:a05:600c:524c:b0:43d:563:6fef with SMTP id 5b1f17b1804b1-43d05637140mr66351255e9.21.1741862868062;
        Thu, 13 Mar 2025 03:47:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuof90DCs7eJ3JwItRCIRpwATmH/3XNmF4IhoW7PyjbpLbTIbp4p7z1rZXGN+i2daYNGVW0g==
X-Received: by 2002:a05:600c:524c:b0:43d:563:6fef with SMTP id 5b1f17b1804b1-43d05637140mr66350925e9.21.1741862867674;
        Thu, 13 Mar 2025 03:47:47 -0700 (PDT)
Received: from [192.168.88.253] (146-241-6-87.dyn.eolo.it. [146.241.6.87])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d04004240sm38333535e9.3.2025.03.13.03.47.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 03:47:47 -0700 (PDT)
Message-ID: <87e8bde7-b05e-4a1b-bcef-f6bb3a12315a@redhat.com>
Date: Thu, 13 Mar 2025 11:47:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 2/9] net: add get_netmem/put_netmem support
To: Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kselftest@vger.kernel.org
Cc: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Jeroen de Borst <jeroendb@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn
 <willemb@google.com>, David Ahern <dsahern@kernel.org>,
 Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me,
 asml.silence@gmail.com, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>,
 Victor Nogueira <victor@mojatatu.com>, Pedro Tammela
 <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
References: <20250308214045.1160445-1-almasrymina@google.com>
 <20250308214045.1160445-3-almasrymina@google.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250308214045.1160445-3-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/8/25 10:40 PM, Mina Almasry wrote:
> Currently net_iovs support only pp ref counts, and do not support a
> page ref equivalent.
> 
> This is fine for the RX path as net_iovs are used exclusively with the
> pp and only pp refcounting is needed there. The TX path however does not
> use pp ref counts, thus, support for get_page/put_page equivalent is
> needed for netmem.
> 
> Support get_netmem/put_netmem. Check the type of the netmem before
> passing it to page or net_iov specific code to obtain a page ref
> equivalent.
> 
> For dmabuf net_iovs, we obtain a ref on the underlying binding. This
> ensures the entire binding doesn't disappear until all the net_iovs have
> been put_netmem'ed. We do not need to track the refcount of individual
> dmabuf net_iovs as we don't allocate/free them from a pool similar to
> what the buddy allocator does for pages.
> 
> This code is written to be extensible by other net_iov implementers.
> get_netmem/put_netmem will check the type of the netmem and route it to
> the correct helper:
> 
> pages -> [get|put]_page()
> dmabuf net_iovs -> net_devmem_[get|put]_net_iov()
> new net_iovs ->	new helpers
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> Acked-by: Stanislav Fomichev <sdf@fomichev.me>
> 
> ---
> 
> v5: https://lore.kernel.org/netdev/20250227041209.2031104-2-almasrymina@google.com/
> 
> - Updated to check that the net_iov is devmem before calling
>   net_devmem_put_net_iov().
> 
> - Jakub requested that callers of __skb_frag_ref()/skb_page_unref be
>   inspected to make sure that they generate / anticipate skbs with the
>   correct pp_recycle and unreadable setting:
> 
> skb_page_unref
> ==============
> 
> - callers that are unreachable for unreadable skbs:
> 
> gro_pull_from_frag0, skb_copy_ubufs, __pskb_pull_tail

Why `__pskb_pull_tail` is not reachable? it's called by __pskb_trim(),
via skb_condense().

/P


