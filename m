Return-Path: <kvm+bounces-62220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD42C3C74F
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:33:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55ED6189A85B
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B86634F246;
	Thu,  6 Nov 2025 16:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KBi6CCRn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="t8icFj3q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4CF34EEFA
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762446250; cv=none; b=aoIYDnlKXdJVkaX9u4kUjiIO0HsAk4wTDn6s72qBR+pxK2XwzytAfzMniEPc19M7CoPKlKfSXRmTUNhAtTpLuZTRUOvPKJDU0wOpbNIdxNtjTcv5xiJWlq+Sv9ZSkLxtEO8D5e9dmBlyqj+xmMAb2I2wsk4Iwe6KMjRTlmYwZ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762446250; c=relaxed/simple;
	bh=0vKjDbLZ5uIsJA1uwTP3kzZUDanfSCuXi6/Z1HKwKG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NFRvyk0JjnG+37VGlpzcIGmf+Tjzk3ka3BTTBMaWh4ygjA/+8B+TDOrCaYDDDVYOQrkU6gmQGNRbEOvhjcx4F2KcbdUXZmCVbjc+I35J0mYMhBah2jsEzJrrfEsnvnGJXBv1MeL9zUhIJpmHLWJUvjpfnZXFQ7ZSxtwarDiVYFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KBi6CCRn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=t8icFj3q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762446247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N1DG4kG92g8zznE2M/rfvvdgAVk3otj7VoXSOREQcnM=;
	b=KBi6CCRnkBQYux57mT9fYKyyVuxOOWgHrd6L4GGlCo9ZQIBCqrsCZCmpYESrFzU41gihza
	DTUes5j7dSO7QPesoKqxtCLi1q4CiYTtNJ59gi929cxei9WiVPhMT3TFbSJrkVKGucN+fi
	XN2DOjTXbt8VqqgbYSSrAlz2yF31cJU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-fnPidB7KOiytoCB6i6XfrA-1; Thu, 06 Nov 2025 11:24:06 -0500
X-MC-Unique: fnPidB7KOiytoCB6i6XfrA-1
X-Mimecast-MFC-AGG-ID: fnPidB7KOiytoCB6i6XfrA_1762446245
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4710d174c31so9920905e9.0
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 08:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762446245; x=1763051045; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N1DG4kG92g8zznE2M/rfvvdgAVk3otj7VoXSOREQcnM=;
        b=t8icFj3qcK2oUVcdV1K/+09UzGEZx9vO11ghuK8XhkNBhOGU9+2JMp2DYrP0X1IXGa
         f5qOqFxXxly4Dmuet1jPE0cgz/ebUT4Y5EHqFKAxwRjlwdhmUSwVzcX/LTXEkJKCoL2G
         1bYomD1hwC7aEpdmW0VqNAVz7CUiZARrCqhrx1PcbRhquB6nPBNtBEjMI8Vh20NU8/AY
         Q5GMDUufIAgL6IMxoVgsjq/8t3MWai7PBRW6VsThpAi5LFcYns0JYUloxoedv3vFz5wY
         4kvQsYELA846+ONvrH6Gvh7iLba63EZ+rD5rwJswv3cLgN25QSwTUotV7XPkBugu94a/
         uqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762446245; x=1763051045;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N1DG4kG92g8zznE2M/rfvvdgAVk3otj7VoXSOREQcnM=;
        b=OCQwIPNwv/Yb2GIKMky9trWSDYaj2sGyOoKqOE8yk5wMii8YiK0lz9TkgvJaJeuQXI
         0zFsS+5JbRyREmnfNe4Q53SJ30oMu8Pf6/vJUQjy3GMdNN7NjllhbqXO7L5sbfTUq9Nz
         VEr0BMuty+KfpIRUfH1ZsmSLNaC4g8e+Gm9/NJQTBZswQeNsN5SMYCltpvzT589nIq8b
         iw+hJhBxRQgzsFgN6q97ZGWp8gwDtEP6nQSPfd56ftNkLLs3DsKBdjsIydMRCgG+qmU/
         i88Mo9YJxGMNsHM2rEnuGOxS2agZkWqcQLLK/0TmB/U3DqczWZNzxTtvuFLZitEnFLDi
         CLnw==
X-Forwarded-Encrypted: i=1; AJvYcCWOqPsP+IaGqwZlumF7TAFsZ93G/Ab44mYN+p9mXYmXF6Qe53ia5RIjnavKXfKhT0g0snA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ+NtNazvDiZKwrZOqo3N99kHNvLKbgjJ40pgKfo68YSSVX6h9
	YfJqPbtwL8EZPpJ5pwhtocxEIpDacV5wEIYWJmQkngf8/g9K+E94nzT6WogZrgkkAqDpUxhIcar
	vi16tgsLThBu8fbcdktkDdK8OncRqqG1sPXvu9OAOOK+O7vxtcpkBpQ==
X-Gm-Gg: ASbGncsbH+KkHKTcjWfFU5W1YdUv6+AvZ5oFOemFOWctz5AVefscXN7d31Q1cVfUHBv
	mOUErvcg4MM6VG/Fs8U49fCQYOzADZO/ePfOMUHJgntsTLn8jDwshCwVteh64akODIhef4ju1Nt
	2fmkzbxco2QB7ZawWBkiFl9ZCGfzYoRDiaI38aQsyJ6akJv+sa4SL/AwnXEFsAp6/eCh477ULl6
	lnk53CxX4pCJ7czqlXwSw7aIQ+6sLICARvsc30Oep471Tf5ygH9AMr61Cz/D4CY0QY/YQgfhQHH
	IbEXZNRLtM0gWWrw6AdMzSlSEF4a8xnBv1PrC0BUw/koFf4SJmeLSESd/wV0YWDuQcI1UWG91Q0
	arQ==
X-Received: by 2002:a05:600c:5486:b0:477:5a30:1c37 with SMTP id 5b1f17b1804b1-4775ce9de52mr66234015e9.41.1762446245372;
        Thu, 06 Nov 2025 08:24:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0G1GMRMF16+MzLwvDgk0DmYYlo1r00tXQsnMrr1muBaVhluzHBbanGO0G1csDS3yewZ8H4g==
X-Received: by 2002:a05:600c:5486:b0:477:5a30:1c37 with SMTP id 5b1f17b1804b1-4775ce9de52mr66233365e9.41.1762446243795;
        Thu, 06 Nov 2025 08:24:03 -0800 (PST)
Received: from sgarzare-redhat ([78.209.9.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477625c2f77sm56342755e9.9.2025.11.06.08.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:24:03 -0800 (PST)
Date: Thu, 6 Nov 2025 17:23:53 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, berrange@redhat.com, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v8 00/14] vsock: add namespace support to
 vhost-vsock
Message-ID: <4vleifija3dfkvhvqixov5d6cefsr5wnwae74xwc5wz55wi6ic@su3h4ffnp3et>
References: <20251023-vsock-vmtest-v8-0-dea984d02bb0@meta.com>
 <k4tqyp7wlnbmcntmvzp7oawacfofnnzdi5cjwlj6djxtlo6xai@44ivtv4kgjz2>
 <aP+rCQih4YMm1OAp@devvm11784.nha0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aP+rCQih4YMm1OAp@devvm11784.nha0.facebook.com>

On Mon, Oct 27, 2025 at 10:25:29AM -0700, Bobby Eshleman wrote:
>On Mon, Oct 27, 2025 at 02:28:31PM +0100, Stefano Garzarella wrote:
>> Hi Bobby,
>>
>> >
>> > Changes in v8:
>> > - Break generic cleanup/refactoring patches into standalone series,
>> >  remove those from this series
>>
>> Yep, thanks for splitting the series. I'll review it ASAP since it's a
>> dependency.
>>
>> I was at GSoC mentor summit last week, so I'm bit busy with the backlog, but
>> I'll do my best to review both series this week.
>>
>> Thanks,
>> Stefano
>>
>
>Thanks for the heads up!

I just reviewed the code changes. I skipped the selftest, since we are 
still discussing the other series (indeed I can't apply this anymore on 
top of that), so I'll check the rest later.

Thanks for the great work!

Stefano


