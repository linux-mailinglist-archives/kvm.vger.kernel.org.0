Return-Path: <kvm+bounces-52739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B06B08E8B
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 15:52:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5175C1C23629
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 13:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A412F6F88;
	Thu, 17 Jul 2025 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VhxaB/k1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9D0298CD5
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 13:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752760354; cv=none; b=J2HQ25H9cYnezOglVcHxJOojZGCYoj2V30vyCkEJSl3F5OM17CWlOZMit7aq6JiouCSycZRD7alkRbKFyYehPMhDZYPJJPfZ+raXHq3o5p8WlGX6U/7qznJmgike0U72SpSt6LOpREMYgWkDWifLoeq8gYTlqjv/OdRPPz0oUro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752760354; c=relaxed/simple;
	bh=FOknZPaa0ET0wOU5En/aokMYWIKU8p4UDlNpWqYvkSo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F6p9QaFgObp+BVI5XOWpLpZL9j3ISyDsd9DoxgKQ94eH/nFBTqXYX6/xdQeB+W7KSVt59HdNw1xmfdcyxUiUKmBgE+NCOETfMnXukiPlcOl8onoanivt5J9+c0rcgf8NPFrN0zOiyyvSYTz94uEFCufihgytoap0zt44n8twBK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VhxaB/k1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752760352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hGvAbY32RFgpjRdN6+3XL6T/YF5F5zsdWuL3mzQK87Y=;
	b=VhxaB/k1tkzsvJ4im3oxGdWOFzDtVcwd+T0I7PD/MimspYFT6y+RMgTolT0rbYJhlVqxip
	+9dqLz7iouxzCBILBHqOT7lhOAQhyyXQtqIxDulCwKpCHbrGYoYfNT13i5l/0VeCEKhptY
	S6ah3ur24HZXA5E9Z8nJ9PUuLICBFTw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-lqUGZZi5PKyxbJBr96jHyw-1; Thu, 17 Jul 2025 09:52:31 -0400
X-MC-Unique: lqUGZZi5PKyxbJBr96jHyw-1
X-Mimecast-MFC-AGG-ID: lqUGZZi5PKyxbJBr96jHyw_1752760349
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a50816ccc6so617115f8f.1
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 06:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752760349; x=1753365149;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hGvAbY32RFgpjRdN6+3XL6T/YF5F5zsdWuL3mzQK87Y=;
        b=q5G/LSNqpndyb3hGlFr3/9TK1hnGwyFU/9EdQMp2OgmYPC+44lyTjW+G61DA+wTLPo
         IwdxOdwCp92pQpFb1eIO8rKN6SnicAnQKJsqWiVFrsWbVaqaWpylcxb2xRRGyTZhS4ud
         MxB3edZ0EWmjRGWVgBMI9bvMzJBwwGlLlNYbffaga+olBk/k+EEF86lkUWakKxEBdTW/
         VEKgvc4cS7WLiV4/xz3FzdTtpX8Kfvoaipcz3aiXUmtVveUv6YGIQcp0hx4Rn1qpUz9c
         pOK2a0LYFDaYtWgm++9KEtA6vi5tfG1da3Tv8Vl/lhYA9TdRLzWwt7X/7De4A9Iqm3Zj
         ZKLw==
X-Forwarded-Encrypted: i=1; AJvYcCU168Wz9vuQ5WBQxvxdKW+VZrunnZEfZ0/1gKqbhHqokmbec/gBYd5lbPne4MYEdim/1AA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx02MYnKJMnPQlIs7Pwd6O+J3t3JQir/k/W5FHUU//iVZmrH5TA
	Hwot+rTK5ddL9AVEtnna7npGs3ZHpuSZNc8888zBkQrd0kL7ejPnunT9Xe0VZ+TA7DcooZ+GXcR
	yfajxLqm2o5HZy+MjO0Qxk54AKvbDs4X01N9IYLoJBOSLIVQWIlmKjg==
X-Gm-Gg: ASbGncuXJmLhnAQ7PuaFHBanNwpLnlvE2Z4acTmATMzNxq6QTkQX/aWRC9BHpaSDu8j
	ruLCS6bPkU/flCtTXuTrVuwFI2KlQvhH4kUPAYU6ghlkHkyEWnA76fJyZ1q118FNwax+z+Z8ONb
	1OTcQnyMKxm2BdrQJ2U9a1fNldQru20gxTRRiz2fMyCfCABbmjxPQTaFkJwMYWgCVdWdIId9DGr
	gdNW8nhRBgHc3QtDardgZpCaoOmuJaBDLKwOWHkTFZwQrAv+VTAPcDU81We1AEDIiX07lAsurNx
	CP4RwwxbpIMlhd2KSvY4EalXyykWArWXzG8zAuHqE+FQhFpE1vgV7MIorbGs2uN8NIMrtcXkCX1
	G21aO01SJjEo=
X-Received: by 2002:a05:6000:2006:b0:3b3:9c94:eff8 with SMTP id ffacd0b85a97d-3b60e51c895mr5115045f8f.27.1752760348649;
        Thu, 17 Jul 2025 06:52:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFe2UZsHx0A1qd64C0wPihrY+x7o7vx2ATqKIuSJI84BF2RqSh+4TT6WPjrhFeuw06hYTdARg==
X-Received: by 2002:a05:6000:2006:b0:3b3:9c94:eff8 with SMTP id ffacd0b85a97d-3b60e51c895mr5115019f8f.27.1752760348124;
        Thu, 17 Jul 2025 06:52:28 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e0d4b5sm21113467f8f.53.2025.07.17.06.52.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 06:52:27 -0700 (PDT)
Message-ID: <bea4ea64-f7ec-4508-a75f-7b69d04f743a@redhat.com>
Date: Thu, 17 Jul 2025 15:52:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 0/3] in order support for vhost-net
To: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, eperezma@redhat.com,
 kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, jonah.palmer@oracle.com
References: <20250714084755.11921-1-jasowang@redhat.com>
 <20250716170406.637e01f5@kernel.org>
 <CACGkMEvj0W98Jc=AB-g8G0J0u5pGAM4mBVCrp3uPLCkc6CK7Ng@mail.gmail.com>
 <20250717015341-mutt-send-email-mst@kernel.org>
 <CACGkMEvX==TSK=0gH5WaFecMY1E+o7mbQ6EqJF+iaBx6DyMiJg@mail.gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <CACGkMEvX==TSK=0gH5WaFecMY1E+o7mbQ6EqJF+iaBx6DyMiJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/17/25 8:01 AM, Jason Wang wrote:
> On Thu, Jul 17, 2025 at 1:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>> On Thu, Jul 17, 2025 at 10:03:00AM +0800, Jason Wang wrote:
>>> On Thu, Jul 17, 2025 at 8:04 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>
>>>> On Mon, 14 Jul 2025 16:47:52 +0800 Jason Wang wrote:
>>>>> This series implements VIRTIO_F_IN_ORDER support for vhost-net. This
>>>>> feature is designed to improve the performance of the virtio ring by
>>>>> optimizing descriptor processing.
>>>>>
>>>>> Benchmarks show a notable improvement. Please see patch 3 for details.
>>>>
>>>> You tagged these as net-next but just to be clear -- these don't apply
>>>> for us in the current form.
>>>>
>>>
>>> Will rebase and send a new version.
>>>
>>> Thanks
>>
>> Indeed these look as if they are for my tree (so I put them in
>> linux-next, without noticing the tag).
> 
> I think that's also fine.
> 
> Do you prefer all vhost/vhost-net patches to go via your tree in the future?
> 
> (Note that the reason for the conflict is because net-next gets UDP
> GSO feature merged).

FTR, I thought that such patches should have been pulled into the vhost
tree, too. Did I miss something?

Thanks,

Paolo


