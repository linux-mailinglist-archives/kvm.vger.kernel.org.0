Return-Path: <kvm+bounces-37828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EF6DA3067C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 09:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 634411618FC
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E691A1F0E55;
	Tue, 11 Feb 2025 08:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GZq3/7Bu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2891F03EE
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 08:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739264085; cv=none; b=gz7ZhazDlL2nzG9DPztXdtWW4KMNI6+gYYawitTUehS29tqMSUCR7TKwPBDc+ZdBBBUHTvTVuYWXbLwj+N/Vddh2/RBETIhHVHY3krXVI4BIkQUyVEwU3XJ9wdOaWrdXK5Gyxl3Up4abtcuPLquwsMX7JSnjbyemfVml4ZmUuWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739264085; c=relaxed/simple;
	bh=A9OGoTsHrjtvyBc5Q07ZgbbmAyoBumXm7SUvVbyvJc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5uPcFdHkOMjLxAMPlT80NPA0jv9jHFDlCNGWH9pLfpkobj1XVZmh1/LCOXcpXSuGWS/urjuIlCp/6UAxzia3h+KdjqaoI9umPHlBQWp9W5/m6jqETntlMiRXYuUM7WWNnGnPdBNk3ZdlCALRtcnFvQZndSlQAS8zQzxWm3bObE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GZq3/7Bu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739264081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+JLq8TzMXCM9fnXbwXAYKIjuUWhuJvIj9pOn4Osk/Hg=;
	b=GZq3/7Buua4e4xWI7jRkfUghkVpbsyf2KBHk/uEQi+KHCIoljcmDDc5URwia7Lu9PQ6SZJ
	BsdOpyrXh5EjxB04vUZ2/9ZSd2KkzXwv2yQstrmQNd1WEVv4+MQrtkavCNOYrU5H5ytqjZ
	QNfLPxm0kKqIWYOi3Vdu2t8j+iyVmZc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-TM5KZ3hxPcqRDeZWRrehWw-1; Tue, 11 Feb 2025 03:54:40 -0500
X-MC-Unique: TM5KZ3hxPcqRDeZWRrehWw-1
X-Mimecast-MFC-AGG-ID: TM5KZ3hxPcqRDeZWRrehWw
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38dc88ed7caso2374777f8f.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 00:54:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739264079; x=1739868879;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+JLq8TzMXCM9fnXbwXAYKIjuUWhuJvIj9pOn4Osk/Hg=;
        b=migNhsZrxk00k783CrcD8HAD30d8LTLQJLd3n1Rnl+f+Lv5EVRaBPsLJof/DBPSP2i
         hT4bj+Ke89tl154nI5esDCgSmbd9W05cTFpkw7Gr5fuFgmWIGEYuZhNirxlnBt8iiB4+
         kNn86xfcCPpnS4F6NG8xH5f6AVpVkTi14cI/dBt+YPCytZA8s/t7qo9dokH3f88N5Nv6
         6skUJc6T0R2lq4iNapc4iHI029i+KQ4aT5I5yeIJVept4ZQ5tKuQw4qd51y9eCwG9JSB
         5BatxRqMaPyHg/Dvi5SyhX8oo09nTvexxqCugSpTD/DI6wCm7+kJWs2NuVdJpQ7RBpiG
         05NA==
X-Forwarded-Encrypted: i=1; AJvYcCX3diFo8ElokCZBgPguey91Ge6dGfwm6CZ9qIg9ADoaRCp/ZF4jVYQTwnPgiGntgPfUrc4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyqig6t04owoPhot9ShQRAybYuSIdjZ5GCVtyh2EOPHrmwczhsR
	G8o5yrnwtpcKkRpk8qpTp82+eolphKPuX0W3nDedetG9MnfhNvKHjqjLkb3b/jdyZ/VecCyzL2E
	9xxgOu32rXQ1hNkUIpOFAw0UEo5MCD20XmBa4tj3gx0Wl4CuvFEWtI3/I3Q==
X-Gm-Gg: ASbGncvZN7t01utp0Z+udh4stoK8HhJKhg6Rn89GnRvKijC70TvyGkGbeZyaSNBFhmg
	HvlhpDqP+FNVDcuudvyCvOI8PXnxvF8wipq3+5zkUZVaiC28Omh9D6JycOBCjlFOmh8DcIOjmeD
	KEuQBJ1dQ+DY7ovfWzf88pOJ5q5gakqga5Vl9ntKkCOGikOsMjVYjVnMXetDGv9WPWYLV5mj0B6
	2GTaC76dGE/YD0jBeQufMQrbAFs2VvgFHXW6fY9CbOSW+OF/KfwAdpprQ1NHc6g9rli7UTBwDMg
	qJ6xAXxfxIt9LAeUiGkdRekqdn9fbSeBhHeMJ8uzc2PQ1L3A78Aniw==
X-Received: by 2002:a05:6000:1a85:b0:38d:d906:dbb0 with SMTP id ffacd0b85a97d-38dd906dcbcmr7731139f8f.7.1739264079248;
        Tue, 11 Feb 2025 00:54:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+FXQlM4sVQQqQ6bfC1MLrVyaITtJSDcEgeRD57O/EtV7ZEKzfLqyRzc94bzpSoemBGMAbgw==
X-Received: by 2002:a05:6000:1a85:b0:38d:d906:dbb0 with SMTP id ffacd0b85a97d-38dd906dcbcmr7731090f8f.7.1739264078600;
        Tue, 11 Feb 2025 00:54:38 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-29.retail.telecomitalia.it. [79.46.200.29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4394df55f51sm12596505e9.0.2025.02.11.00.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 00:54:37 -0800 (PST)
Date: Tue, 11 Feb 2025 09:54:32 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Junnan Wu <junnan01.wu@samsung.com>
Cc: stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	xuanzhuo@linux.alibaba.com, eperezma@redhat.com, horms@kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	q1.huang@samsung.com, ying01.gao@samsung.com, ying123.xu@samsung.com, 
	lei19.wang@samsung.com
Subject: Re: [Patch net 0/2] vsock suspend/resume fix
Message-ID: <jeqyqnuqklvk4ozyfhi4x4zadb5wxjvnefmk7w4ktvjna4psix@fc244relosif>
References: <CGME20250211071930epcas5p2dbb3a4171fbe04574c0fa7b3a6f1a0c2@epcas5p2.samsung.com>
 <20250211071922.2311873-1-junnan01.wu@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250211071922.2311873-1-junnan01.wu@samsung.com>

For the third time, please READ this link:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html

This is a v2, so you should put it in the tags [PATCH net v2 ...]

And also include a changelog and a link to the v1:

v1: https://lore.kernel.org/virtualization/20250207052033.2222629-1-junnan01.wu@samsung.com/

On Tue, Feb 11, 2025 at 03:19:20PM +0800, Junnan Wu wrote:
>CC all maintainers and reviews.
>Modify commits accroding to reviewers' comments.
>Re-organize the patches, cover letter, tag, Signed-Off, Co-worker etc.
>
>Junnan Wu (2):
>  vsock/virtio: initialize rx_buf_nr and rx_buf_max_nr when resuming
>  vsock/virtio: Don't reset the created SOCKET during suspend to ram
>
> net/vmw_vsock/virtio_transport.c | 28 +++++++++++++++++++---------
> 1 file changed, 19 insertions(+), 9 deletions(-)
>
>
>base-commit: a64dcfb451e254085a7daee5fe51bf22959d52d3
>-- 
>2.34.1
>


