Return-Path: <kvm+bounces-48247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CDD8ACBED0
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 05:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 575431717CB
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 03:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50A018E377;
	Tue,  3 Jun 2025 03:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d7If9sb6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAA54C92
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 03:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748920825; cv=none; b=rBh7/G9SEpMs4Fx+GwmABSTR13/Va2mBgHylp93cMpJ4uphLMyvBlzGFPDNsySzzDILXy3LzicJpEQ9E62MVr2BDga2D/mgTKrwKoYzPNBeBmUcdOcd4J7RbyJm5yauJsnot8TSn8J4gybEskDwaLhnq7IbGY+KQRmXS5jPa/Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748920825; c=relaxed/simple;
	bh=SuUuFxKyZLAGBzKOOo1OIiQNWaS91RBjDVMCFq+b1Ug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XtawHN72mudkc9OJkiw3LqKD5VnWFTHR6LqJwm4ARIpQp8EVAgTozZSKYYTDXDgO3+a/GT1opKK/2QJhJ0uHEZHYHLu4J8+AwN6sx7D42L4bA6MNnzboBE/0rULCzz9WWJGXsuHSkUm0Myba1VhHrjjf3UvygE0FUHEPi8R7SeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d7If9sb6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748920821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuUuFxKyZLAGBzKOOo1OIiQNWaS91RBjDVMCFq+b1Ug=;
	b=d7If9sb6+afNWKzYLjDqKRyT+eg0w37wWOnN+DhKxz/P6qcCVPtGFL6Bu3JopkjLeS4ne2
	TFAN+cq6Dw3Qrly28qASP0MDsJPKkmvFAzfAlTGpk48hq+zdws1ti9bM48BQ+EspJfrzd+
	O1FmfsX+mMzN1BF8+94uY/yc48sWaNM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-F8FBSQc8OvShyt3SezuTZA-1; Mon, 02 Jun 2025 23:20:20 -0400
X-MC-Unique: F8FBSQc8OvShyt3SezuTZA-1
X-Mimecast-MFC-AGG-ID: F8FBSQc8OvShyt3SezuTZA_1748920819
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-310a0668968so4942268a91.0
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 20:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748920819; x=1749525619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SuUuFxKyZLAGBzKOOo1OIiQNWaS91RBjDVMCFq+b1Ug=;
        b=vK90Swh5JYG+Q+xePrXJbrV7FLwv/yJbmU3Gw37iDYUET6rXsqOcYVW0M1pPrY9biy
         IBAC/2t6DGpg0kjHbWFYqIPQ2830xKwVlWyEekJ5MkocsQ8YWgWmfrKPda5Gn9N9U82/
         vK7ErCbZepzxxZYjgnQsgcSfyGvr2zJ9ZFhJc9YNS8G7MQdmfOz39+GnvKYEKUKfZftU
         azx35J3Kdwa3UfhAFXuos2WEELGjFOckYYAydAGbLu1J4F0U98q68Y8Yi3EAtQPIySmI
         ZzP2/dQoH8I4s8SseBvQdUHRy3fv920gRSN0aXZBR7ImlvEH1CNUkKs2phJaeUhPDXhi
         3qLA==
X-Forwarded-Encrypted: i=1; AJvYcCXL7qCjyPjKRzAVNS+InuC4UEZMQaVpBQ28zMDmHM8Q6N+njMqEHe1AILnkfob9ZvZwxag=@vger.kernel.org
X-Gm-Message-State: AOJu0YwU8dEBHrZhIR9WnPjWqjBlOAMTG0O7IhYmg4sd1VDsu8B/E5Wm
	52Wrl8mnB7wYojYhlAtPQI5QvSn8k02I5tCMH0oiFf553AnXvY8J+/KBs2taLv2BdFQVRwg9jDv
	B/krrfe9xIC+ph6aP/BJUZPWQC4kBKpGFzQzUdSFuInTvjQJAlEVBHPaxiIe5xw7JBfZGId5rXA
	TopP+JYPQcsyyMKopxdbo5ehzokmRl
X-Gm-Gg: ASbGncuf4asT9ENk54uLcLElLeN/Dcy3LJwvwUroCetEwtWlv2hLIpwC/lEsiQr0c0X
	RNNnJOVqxZjLiIE6FsgAkPGlLNv5+djqG8/KAG1dbyLL9zfQDcSXks0+rpnh0Uxn0rPcuiA==
X-Received: by 2002:a17:90b:2e45:b0:311:ea13:2e6a with SMTP id 98e67ed59e1d1-3124150cd29mr24182669a91.13.1748920819225;
        Mon, 02 Jun 2025 20:20:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMKoDoVhANJXhkEH8PMyc1LxUezj6sEzlWUU8w4Uyd+7t0SdHYB02l6iAUnHMY64ChUWPuoGBpUpLK5iNRSqc=
X-Received: by 2002:a17:90b:2e45:b0:311:ea13:2e6a with SMTP id
 98e67ed59e1d1-3124150cd29mr24182639a91.13.1748920818809; Mon, 02 Jun 2025
 20:20:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250530-rss-v12-0-95d8b348de91@daynix.com> <20250530-rss-v12-2-95d8b348de91@daynix.com>
In-Reply-To: <20250530-rss-v12-2-95d8b348de91@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 3 Jun 2025 11:20:06 +0800
X-Gm-Features: AX0GCFvi3ezIBQa7yKxnmidSOgr8eNk-oM266seJU5yCRwglxX_y22dfD-57w2A
Message-ID: <CACGkMEuwb+EcT=W5OwbZ=HOf=d56cZFKF5aYPx0iCLOZ630qNQ@mail.gmail.com>
Subject: Re: [PATCH net-next v12 02/10] net: flow_dissector: Export flow_keys_dissector_symmetric
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, 
	Lei Yang <leiyang@redhat.com>, Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2025 at 12:50=E2=80=AFPM Akihiko Odaki <akihiko.odaki@dayni=
x.com> wrote:
>
> flow_keys_dissector_symmetric is useful to derive a symmetric hash
> and to know its source such as IPv4, IPv6, TCP, and UDP.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> Tested-by: Lei Yang <leiyang@redhat.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


