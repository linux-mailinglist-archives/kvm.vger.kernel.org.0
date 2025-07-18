Return-Path: <kvm+bounces-52872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FC69B09F24
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 11:20:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FEF71899C50
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 09:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE0E29898C;
	Fri, 18 Jul 2025 09:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MB+1Vng9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7583129616A
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 09:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752830375; cv=none; b=VGzR4mLoiHJNthYJTUrL1hrXjVGdPO0b23iQNqTWbgkFC/HKeqtWx8VwMWCcdjeC3HBnIlPRGn1BiDJOdJodWeYc+MMkIJe/vJiIFJFy37m8NxgY5VZut8HvPVd8XQ6T316DgkA1ylZf9J7nLv5jBZIx6wCCiLx0rsE57oIUfJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752830375; c=relaxed/simple;
	bh=9OGXC+HPAx7wjOFmvBxnXdWUJNWtIqbDCCH7mHqqr6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f4ad/XQXSg8vJGr2rEP+rGi7uuXwP22cD9MMLo8n3HnkPW0hsXfQUAonuLS2Mx8MtInOLh+zYGU+BBaiq2q/Xmz4dLXtfTXTVNyS/z6qnhMb0zAcqQPQiz4savKzYSrLAk8Q6oS1wBsSburjxfELlmpoEH6ilXnjbXQ25exgnwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MB+1Vng9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752830372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rz7VEdzguNgZR75iuoM9tSMqqnHJY/Hj/MLHh0vHLZM=;
	b=MB+1Vng9KPKRYoI5lC2zciEu7Joz+BaGzAnedVXta3Y8BJlGeZaYXdJgF36P2cIXu9ttEd
	SazKHg2N7f1HGgkTGECGvj1IYTRLiIJ/SgoK9MN9xlUgoY9SIW/F8dkdZe3DpZPVEc8rMY
	zhv7QW11fiaJBhEYSdF7wX/e9WJVNUg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-a5GdEurfMFeqkI45RSlh8w-1; Fri, 18 Jul 2025 05:19:30 -0400
X-MC-Unique: a5GdEurfMFeqkI45RSlh8w-1
X-Mimecast-MFC-AGG-ID: a5GdEurfMFeqkI45RSlh8w_1752830369
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4561611dc2aso16496155e9.0
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 02:19:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752830369; x=1753435169;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rz7VEdzguNgZR75iuoM9tSMqqnHJY/Hj/MLHh0vHLZM=;
        b=PCt8TLu+vnbWxFqZfiH5YDfZMp0POmx4B3VVssL5Jc4CSd2XmOEpMPzves1Hxujd+M
         wZwUmQTpkxt+oq9/ghxFpWIqmwc22XoL5DTfpJkxEBnSvMdW3J01NjnuPbHspgjZse5t
         E8ZmSl9ao5Mo9qk5eOAEEs/XPDBNQPwYcBtbpRQqHuwfzcXM7RZw8rSql4ZfzIknCGqv
         rne0LY0VnuZi4xRbL8ej1HSBl4t3xNPwXJTUbw1DDgkUp8pvWtimgraN3JGd+VQ1OrAW
         oKy43TKzqZple6GBr66qKah1PRJN/Vekr24mgghQ51WOKfeYhYY+hrTcdMvghawR/nKC
         h9gg==
X-Forwarded-Encrypted: i=1; AJvYcCUzD4vO1NAk/HqhTqkNDSblTfjqlL1YTHSZ6SZcO0nt73yczOlzz1+KZfkdOWaQUxI2IXE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFcadgcDHhcskcC8MKzMGZED3tpapoepUUsrMH4ijFidHeS9nV
	X+xyJ6ul0pxkG2GNtaQqqymNwagIcFtYcMaC0hBoTXmL/Q3T3DIZXJE3FvdNisAArpxfSBPf3EB
	kz9cwgJMT14KHXvWNP+K+evEYCe27d/jsta5tx4cMTYiL+XvjlIUnsw==
X-Gm-Gg: ASbGncuwdt7Vt0lknDMQiGQVyZw01MpbtRD7ddGn9BrQFH1wdfHSLic6YSBIizM6h/H
	RQ1SOAkmq2UxUeeep187ij9FCLVo8JykKDmfW944kF6UkBQ+UDxhIuMR3Aq9RXRJh00DxUlzzBT
	OPDUzYI7f8h49w9wZyL7zVaGCf1e4HZOneHvVNY17Boxe8uMAlK0ozcIrDbZtJGtKZuoROYkvFy
	Xw4lAsMLr+vp5tyF4wodsDKEsXIaz/xGFUCVrUjq/xD2pSCanIvfGa2HITqzNsy7olpqDGbrien
	+7BuD3/7R6xhtsJugQ/sUuUj5h/3YW1L9u9HTClV/MvMMgdcmkpO3z6yMdYMgZhbstjRiarCXBL
	wc9Hdl2sEr5k=
X-Received: by 2002:a05:6000:440e:b0:3a5:1222:ac64 with SMTP id ffacd0b85a97d-3b60dd7b02dmr5390082f8f.38.1752830368949;
        Fri, 18 Jul 2025 02:19:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTjhEq8p44r045oEYKw5E0umkCtE+yHNEk65pXbCxLQ3y2DbvrtoknVhu/Al+Bpx9xmKqa4Q==
X-Received: by 2002:a05:6000:440e:b0:3a5:1222:ac64 with SMTP id ffacd0b85a97d-3b60dd7b02dmr5390060f8f.38.1752830368389;
        Fri, 18 Jul 2025 02:19:28 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca2dfe0sm1288433f8f.36.2025.07.18.02.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 02:19:27 -0700 (PDT)
Message-ID: <7aeff791-f26c-4ae3-adaa-c25f3b98ba56@redhat.com>
Date: Fri, 18 Jul 2025 11:19:26 +0200
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
 <bea4ea64-f7ec-4508-a75f-7b69d04f743a@redhat.com>
 <CACGkMEv3gZLPgimK6=f0Zrt_SSux8ssA5-UeEv+DHPoeSrNBQQ@mail.gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <CACGkMEv3gZLPgimK6=f0Zrt_SSux8ssA5-UeEv+DHPoeSrNBQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/18/25 4:04 AM, Jason Wang wrote:
> On Thu, Jul 17, 2025 at 9:52 PM Paolo Abeni <pabeni@redhat.com> wrote:
>> On 7/17/25 8:01 AM, Jason Wang wrote:
>>> On Thu, Jul 17, 2025 at 1:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>> On Thu, Jul 17, 2025 at 10:03:00AM +0800, Jason Wang wrote:
>>>>> On Thu, Jul 17, 2025 at 8:04 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>>>
>>>>>> On Mon, 14 Jul 2025 16:47:52 +0800 Jason Wang wrote:
>>>>>>> This series implements VIRTIO_F_IN_ORDER support for vhost-net. This
>>>>>>> feature is designed to improve the performance of the virtio ring by
>>>>>>> optimizing descriptor processing.
>>>>>>>
>>>>>>> Benchmarks show a notable improvement. Please see patch 3 for details.
>>>>>>
>>>>>> You tagged these as net-next but just to be clear -- these don't apply
>>>>>> for us in the current form.
>>>>>>
>>>>>
>>>>> Will rebase and send a new version.
>>>>>
>>>>> Thanks
>>>>
>>>> Indeed these look as if they are for my tree (so I put them in
>>>> linux-next, without noticing the tag).
>>>
>>> I think that's also fine.
>>>
>>> Do you prefer all vhost/vhost-net patches to go via your tree in the future?
>>>
>>> (Note that the reason for the conflict is because net-next gets UDP
>>> GSO feature merged).
>>
>> FTR, I thought that such patches should have been pulled into the vhost
>> tree, too. Did I miss something?
> 
> See: https://www.spinics.net/lists/netdev/msg1108896.html

I'm sorry I likely was not clear in my previous message. My question is:
any special reason to not pull the UDP tunnel GSO series into the vhost
tree, too?

Thanks,

Paolo


