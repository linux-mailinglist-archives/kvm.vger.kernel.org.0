Return-Path: <kvm+bounces-13850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0963B89B89A
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 09:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 332CAB222F9
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 07:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE9802CCA3;
	Mon,  8 Apr 2024 07:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a3yzc0hf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3B32BAF6
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 07:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712562005; cv=none; b=KSAcNU6L82cLcQyLGSrRF60rcIFlJtkCxB5lPA9nyZREy0N+RaaKeuEtLyp5D80c4VGXyijS057hScqk9poirXPhkjB7HiRNeu/jRA5MtSi7wQw2bEh2096UemU9C04KArffqVzEq9gtIzfIu0WthTEvr6Zd+FrSAgUDfZN/+lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712562005; c=relaxed/simple;
	bh=rNOqKr343ZSMxime79iGUap0wNoYZSF/QDcsqxpgorI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K7QZnlFa1cQPmfxTahd6pRIuVEUE0ok6s5p3Ujnh0BFr2K4QYy0RNmkW5/c5mH3Kkw1NmXxRHtPQR5RA4QsRzwwN5xN+Pjc8HycDuD2F/kzU3gio0ON25CCH12uNxz5eqiofylD2i60Przt8jnFMyMKv/VeCqcS9Tp80yy1IX6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a3yzc0hf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712562002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U6c8NxRj9cq6OvbALtg2Roh5bDMfOSXXjT3FSUcwbEE=;
	b=a3yzc0hfnQblN1RQ9xPlpKqER/Y507NphLSGZooTZe+CsiHlfa5GhpTPxcnOHMju3kWh3u
	AsdIPLnHXjqJmiPRo54muE220MfneTb3Q0U3Y2pSdFhLMNcCODcWUkElNj66KWl5VZE5Ts
	cHWztf70VreBSzqREQdWDNQh0QVechA=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-VP8Hf33PMuupCq4ZGC3YVQ-1; Mon, 08 Apr 2024 03:40:00 -0400
X-MC-Unique: VP8Hf33PMuupCq4ZGC3YVQ-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-516ef3189e9so510771e87.3
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 00:40:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712561999; x=1713166799;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6c8NxRj9cq6OvbALtg2Roh5bDMfOSXXjT3FSUcwbEE=;
        b=PLy4iEJNwtBy4LQ9DkSEowv+/+A0Wf/Zg6sBy/dGPZ4GZ4iJ1+IpzPF9TcYoRXO/yL
         +J2Xxs9mTW17L+ejpfEnBBCoH0rt4FJGyxY68qd+rqQ7vhlqvES6ahtqvKnv6clrBVUG
         lDd55eBgJ4jDCvjuNJMonMswfVhW0WOLFfBcNlLoWALyhuo0Ns48LU+orbek2sjWSwx0
         KJnftdyX3iWyV+B8tz9/qyLuzMYA2n4BXL84ayWWN3KwWKHHPMWCI9m2+r/RkM+NT7S2
         Q22SDggI1jz+zCOG09WBGtlFlexADPKOdPf9G5zuUmmALY5KGQVbcB2HevQPDxE8RkZH
         c/dA==
X-Forwarded-Encrypted: i=1; AJvYcCURv7lL/8W0TKAGzSpJ8MPdCAwtXQorkPXpoBhGQtz70cnjcSI1EyQja4JA7oKYIJTD7xpjo8X3kmx2a31vu6GP7FoW
X-Gm-Message-State: AOJu0Yw3QS42vJQGFP2JOXQaw6+TavbOUP/lzQBThNROw6VP2hJQ3zdz
	C8BCevh92S8+Kzi6M4ypdCriwd7vAyRu0jCvZuavWXcsdLEzXgeTiH9vX5/IRyfHVl20iPjEJWO
	ELeeI4O1KgM/npQYoxK41auSUb4Qv1PJTNaqEnhXYn7zS8840Ew==
X-Received: by 2002:a05:6512:6c9:b0:516:c8e5:db35 with SMTP id u9-20020a05651206c900b00516c8e5db35mr6894127lff.18.1712561999182;
        Mon, 08 Apr 2024 00:39:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYDBkJjgbRSv4emXcuf1/HTD8JQtEuPSUD5eeQ3QrlOhXQrKMs2KEWRXNbHyZBPzEseuHvbQ==
X-Received: by 2002:a05:6512:6c9:b0:516:c8e5:db35 with SMTP id u9-20020a05651206c900b00516c8e5db35mr6894089lff.18.1712561998195;
        Mon, 08 Apr 2024 00:39:58 -0700 (PDT)
Received: from redhat.com ([2.52.152.188])
        by smtp.gmail.com with ESMTPSA id n8-20020a5d4c48000000b0033e7b05edf3sm8276904wrt.44.2024.04.08.00.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 00:39:57 -0700 (PDT)
Date: Mon, 8 Apr 2024 03:39:54 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cindy Lu <lulu@redhat.com>
Cc: jasowang@redhat.com, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Documentation: Add reconnect process for VDUSE
Message-ID: <20240408033804-mutt-send-email-mst@kernel.org>
References: <20240404055635.316259-1-lulu@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240404055635.316259-1-lulu@redhat.com>

On Thu, Apr 04, 2024 at 01:56:31PM +0800, Cindy Lu wrote:
> Add a document explaining the reconnect process, including what the
> Userspace App needs to do and how it works with the kernel.
> 
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  Documentation/userspace-api/vduse.rst | 41 +++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/Documentation/userspace-api/vduse.rst b/Documentation/userspace-api/vduse.rst
> index bdb880e01132..7faa83462e78 100644
> --- a/Documentation/userspace-api/vduse.rst
> +++ b/Documentation/userspace-api/vduse.rst
> @@ -231,3 +231,44 @@ able to start the dataplane processing as follows:
>     after the used ring is filled.
>  
>  For more details on the uAPI, please see include/uapi/linux/vduse.h.
> +
> +HOW VDUSE devices reconnection works
> +------------------------------------
> +1. What is reconnection?
> +
> +   When the userspace application loads, it should establish a connection
> +   to the vduse kernel device. Sometimes,the userspace application exists,
> +   and we want to support its restart and connect to the kernel device again
> +
> +2. How can I support reconnection in a userspace application?
> +
> +2.1 During initialization, the userspace application should first verify the
> +    existence of the device "/dev/vduse/vduse_name".
> +    If it doesn't exist, it means this is the first-time for connection. goto step 2.2
> +    If it exists, it means this is a reconnection, and we should goto step 2.3
> +
> +2.2 Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
> +    /dev/vduse/control.
> +    When ioctl(VDUSE_CREATE_DEV) is called, kernel allocates memory for
> +    the reconnect information. The total memory size is PAGE_SIZE*vq_mumber.

Confused. Where is that allocation, in code?

Thanks!

> +2.3 Check if the information is suitable for reconnect
> +    If this is reconnection :
> +    Before attempting to reconnect, The userspace application needs to use the
> +    ioctl(VDUSE_DEV_GET_CONFIG, VDUSE_DEV_GET_STATUS, VDUSE_DEV_GET_FEATURES...)
> +    to get the information from kernel.
> +    Please review the information and confirm if it is suitable to reconnect.
> +
> +2.4 Userspace application needs to mmap the memory to userspace
> +    The userspace application requires mapping one page for every vq. These pages
> +    should be used to save vq-related information during system running. Additionally,
> +    the application must define its own structure to store information for reconnection.
> +
> +2.5 Completed the initialization and running the application.
> +    While the application is running, it is important to store relevant information
> +    about reconnections in mapped pages. When calling the ioctl VDUSE_VQ_GET_INFO to
> +    get vq information, it's necessary to check whether it's a reconnection. If it is
> +    a reconnection, the vq-related information must be get from the mapped pages.
> +
> +2.6 When the Userspace application exits, it is necessary to unmap all the
> +    pages for reconnection
> -- 
> 2.43.0


