Return-Path: <kvm+bounces-28989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 04ECB9A07EC
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 12:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 92909B2444A
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 10:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0CE207209;
	Wed, 16 Oct 2024 10:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IIAgUAMh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E0320697A
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 10:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729076339; cv=none; b=VnXdq28BHT6+L+W5mCl+84APbbXQ2CyH8MS7wE3bY+b+IxR78AwaHTXr/q+3CFGnLlbqq/SDsNiF3p7QR7A4ERh5+WtLXG5vCa0Fb/MPbJdGAcasDjUPGxt67KhVcmJzHSmFlW0XjQvQLdv2JuRzVa70xG2e8J0KmnbOowUDeDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729076339; c=relaxed/simple;
	bh=A5V6aEG08OAVBkRfDXL9NsCZdJWuEA5Tozd8ZfbAiaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kDyEPk3ksRiRNS+jq3QZ+GifX5igzyQ2fl5xkSnW7Da5Q/ZNHOBkSJCzr+QeHLPhZsOnLiviV2yKVPADPWiMDYmGOxDpZyb5qilR+yDPHntktv1PUHkvWWOQq4YHy5uz7iTCbuIA5IbYDfynzeVWqnM/To5ELTQ85tleFB5E5ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IIAgUAMh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729076336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+prFWOtzPfzYxu14nAB4ULfwRc+W83wDfax9tJHNQOw=;
	b=IIAgUAMhcR72RH8oCA7uf3XRe73+Ihv/O5kt0JJ9OSfLljmdXCBIRU+SLvgsau7FJgzgzI
	2tvhM8M/rhMeLh2Mlx/oUTOHpSmoSKCaq3lQgAWfJAJc8UPpVQ2DJED8kzVugQA95Q5PYS
	btKym9a9PYaLC/eVZqi4Rhuki6kZ81Y=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-ktg3aXg3OhaOAwmHVhwzNg-1; Wed, 16 Oct 2024 06:58:55 -0400
X-MC-Unique: ktg3aXg3OhaOAwmHVhwzNg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-20c77c8352dso55758305ad.1
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 03:58:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729076334; x=1729681134;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+prFWOtzPfzYxu14nAB4ULfwRc+W83wDfax9tJHNQOw=;
        b=NFZMdtqnRdkcj5NM7dD9hJM7v2hqo0PY4S/ar+sDbpifHAfX3HoNyuhXg1lU1IDD0c
         VCmriTA6e9SuYLHGKr7mY4gxdBBGV6MA383ZlCY5rufN4+W23KIcrSwlPOJmjyUFTm7B
         zYQA+G1o3agOF3yljBqnRexYkM+vAxUg4NVTNhULAFv54uHSDKnMHkqLRMeVxWuhIuDG
         b/TbQNQ/wzeG7UJi66vUD6H9/oB35sEdKzxXx2KpxkiHsRdA23ecLWLWObvtQA1bWv7I
         hiiFJF9CUKYQpi0SWQa/9Vtwzcg5Ipy7IoRO0rvOAEbp3cvxKMaBLgMFISXhiFgf2gpi
         VDAw==
X-Forwarded-Encrypted: i=1; AJvYcCUC4NWhHVPXMHpvrHwRo4h5HL3d0mH64XVCjRX1pBOQWE1RXXpFGiQFGEL5ym683Vmq8xk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfbMCt8g44qmvVYPJfChr5dgbe3DBp9ypptnODN6F4j4YsEOHg
	/eHuQcd4pFV2VR68aSKspPpu5rnJL9r9hz2eZzJdHdCcA+NMTw+0XhFd8G0eNtGBfNh4JFbprK1
	RNVg7qSxKXqb+ihcFMOz7S3iDKHTS3CgarM99hA2Pk+KR0sg7mQ==
X-Received: by 2002:a17:903:244b:b0:20c:eb89:4881 with SMTP id d9443c01a7336-20d27f1cbc0mr49812845ad.37.1729076332756;
        Wed, 16 Oct 2024 03:58:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFN0Q90qqaZTjLPJzy4m2e1J4rfB6qzguYWzXNk+l+VQnEKQ3OlLdyODDHdnurpwXJHGrolfQ==
X-Received: by 2002:a17:903:244b:b0:20c:eb89:4881 with SMTP id d9443c01a7336-20d27f1cbc0mr49811785ad.37.1729076330948;
        Wed, 16 Oct 2024 03:58:50 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d1805b005sm26213155ad.240.2024.10.16.03.58.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2024 03:58:49 -0700 (PDT)
Message-ID: <7e4febb3-1fab-4c2d-8c85-b25fa3c94765@redhat.com>
Date: Wed, 16 Oct 2024 20:58:46 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
To: David Hildenbrand <david@redhat.com>, linux-coco@lists.linux.dev,
 KVM <kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi David,

On 10/10/24 11:39 PM, David Hildenbrand wrote:
> Ahoihoi,
> 
> while talking to a bunch of folks at LPC about guest_memfd, it was raised that there isn't really a place for people to discuss the development of guest_memfd on a regular basis.
> 
> There is a KVM upstream call, but guest_memfd is on its way of not being guest_memfd specific ("library") and there is the bi-weekly MM alignment call, but we're not going to hijack that meeting completely + a lot of guest_memfd stuff doesn't need all the MM experts ;)
> 
> So my proposal would be to have a bi-weekly meeting, to discuss ongoing development of guest_memfd, in particular:
> 
> (1) Organize development: (do we need 3 different implementation
>      of mmap() support ? ;) )
> (2) Discuss current progress and challenges
> (3) Cover future ideas and directions
> (4) Whatever else makes sense
> 
> Topic-wise it's relatively clear: guest_memfd extensions were one of the hot topics at LPC ;)
> 
> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7), starting Thursday next week (2024-10-17).
> 
> We would be using Google Meet.
> 
> 
> Thoughts?
> 

Thanks for organizing it. I'm intrested and please include me if there
is a invite.

Thanks,
Gavin


