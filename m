Return-Path: <kvm+bounces-50982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B1DEAEB5A5
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 13:02:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B737056011C
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 11:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714442BEFF2;
	Fri, 27 Jun 2025 11:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TKqZgje8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBD129DB79
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 11:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751022083; cv=none; b=AsH8dc9U7e4zlU5nVigaJJ/sF/h4bjFFLPcpu2vON3WWu43QxXkOonD3QxEVOotfetAhKr8VJ9XM1HhjLTpsvpSG/8BraG/x4eP4qnCLuSIu6ISEEWH1P+V5yv39j2w7dzhVbzfonoja1aPaRwmZb6fnXwhC1xWgBfkMD2ZQmn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751022083; c=relaxed/simple;
	bh=ZbJdgOIbkGwBeQnmkTbzv066EyMDgSE02LiXwxp50sQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOGWBjm8KbPSICwX/K1Qb1Htgj74fAFQBpvVp5swrcjDnuN4ySn+G1GSOgXKGdPB+/YU+/haWUFidmCoykCr/mMwUx6osaoVEM9QNrEQiL6rWvzxCNEZU8rBOOuvGf7mjLrI/k63KE4O2wE+kzC4+uUErqhIoahgv3Sr8UH3PjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TKqZgje8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751022080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZbJdgOIbkGwBeQnmkTbzv066EyMDgSE02LiXwxp50sQ=;
	b=TKqZgje8KhQLU5b96QpgR1JV+9QlDSK9f4Ll2yfFUGo/wRMUsfT/PbXRPLetlYHs+8jxHi
	fd/r4G8PWArA0dPQOcqK5wcCLhsrPF9gJ2W1hV8nyfIZXrg9cbJFaG8phnkzUH16JYiZRm
	IDZNtjcacxKa9ImtNtFi3bBCVZUVwJw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-me2RSYyYOLSmDxypL-qXHQ-1; Fri, 27 Jun 2025 07:01:19 -0400
X-MC-Unique: me2RSYyYOLSmDxypL-qXHQ-1
X-Mimecast-MFC-AGG-ID: me2RSYyYOLSmDxypL-qXHQ_1751022079
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6ff810877aaso25082846d6.3
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 04:01:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751022079; x=1751626879;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZbJdgOIbkGwBeQnmkTbzv066EyMDgSE02LiXwxp50sQ=;
        b=Lba6WPUw/XUd1tDNOqHdPpbDjSOiKIBHVMi4UAPFipyOwTCLsDtItyOBCMGtoqXjvM
         Y9afpCpu9K5xEWsk+6bSoLkU+kBZekct/IGr9pcF78QiExNm3sEQAQc4ymhw1sVsIWES
         w2hcwR2++vKI3zNhhGdTBPgdJ9Wrs9hVcIYN1EdJABXkue5CkSgEIJxphS5SPn1J2oe4
         FZ3cI1SnJewBE4XAEQ2QeP4wRvO3JGhLI6sarUA7L6iTOyjsH7Q3jYdaEZETjkCAA8I7
         6OgtRcEpjOw+Xtcm8pCPD2o86a3Z/GhlEUcUAszt++QM9upv6yEZSoqZ8oqTtCL3FwoO
         Mxbg==
X-Forwarded-Encrypted: i=1; AJvYcCUun9hb7mVEcF8ieoUA/JQ1aaM8/BBUn+DOCLOhlTQHAZe5q4Acvi1xueDxDOHLDNcGplw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJkSzeHvT8eEt3KHRVzlpJzDPT3y03XcYAdoOKDYff7j3Rphkb
	QjqqZ7gY8rqVwWNRgPrCj7vngy/l25hWg18SYj0eVYqV837nuhu3O2Y4VC7zpTYofcZu43ahrKB
	pBChtWk9z9YP2zN2qIHfaUuFIo53VmKaNy1yC6V7s/0OQ/7SF4jOTzw==
X-Gm-Gg: ASbGncu8EJiDHXghZOffk2uUATB0JaAhn9PZG1hhhPVeXMkrXik2BR9ECL2LeI/Q8Gv
	TZcU0+fcIXfs+TSlIjj6C74eNjmyRgxPoqmv7QzIAVpC8Apk7jyZN/+Qvue0aTzfsZJuGk1sPlt
	z/9LF8/V9qAAsSkIhhJ+QN5DWA7OFfdOnJpLIXaFWEtgy0zikzOxkT+kOBqwLpqfFI0F0RJIr6X
	I6NY6C/t4OWwjNw3KUJnbwKNV++rzx8L5CMzRQ8sOQkv4qf/kzXjFTSw7CvxT3GHCB+SGYxHFwc
	Uj5/HC2seGC6l/PB1xbCgzaA5umm
X-Received: by 2002:a05:6214:76b:b0:6fd:d33:bf30 with SMTP id 6a1803df08f44-700033b6fcamr44380066d6.44.1751022078525;
        Fri, 27 Jun 2025 04:01:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEI8TS4H6eRA0UouWBKDumbd4mbbqZxeye6OCeaKrfLx9sLYI9IeIKljRoNoP6GNozp6MQ7gA==
X-Received: by 2002:a05:6214:76b:b0:6fd:d33:bf30 with SMTP id 6a1803df08f44-700033b6fcamr44378836d6.44.1751022077610;
        Fri, 27 Jun 2025 04:01:17 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.181.237])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fd772e3f2dsm17994826d6.78.2025.06.27.04.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 04:01:17 -0700 (PDT)
Date: Fri, 27 Jun 2025 13:01:10 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: Xuewei Niu <niuxuewei97@gmail.com>, 
	"davem@davemloft.net" <davem@davemloft.net>, "fupan.lfp@antgroup.com" <fupan.lfp@antgroup.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, "jasowang@redhat.com" <jasowang@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, KY Srinivasan <kys@microsoft.com>, 
	"leonardi@redhat.com" <leonardi@redhat.com>, "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mst@redhat.com" <mst@redhat.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "niuxuewei.nxw@antgroup.com" <niuxuewei.nxw@antgroup.com>, 
	"pabeni@redhat.com" <pabeni@redhat.com>, "stefanha@redhat.com" <stefanha@redhat.com>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, "wei.liu@kernel.org" <wei.liu@kernel.org>, 
	"xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>
Subject: Re: [EXTERNAL] Re: [PATCH net-next v3 1/3] vsock: Add support for
 SIOCINQ ioctl
Message-ID: <ubgfre6nd4543iu5yybkmnd2ihbzfb6257u7jjfz4xqk4nhfdu@43yfocr4z4st>
References: <wgyxcpcsnpsta65q4n7pekw2hbedrbzqgtevkzqaqkjrqfjlyo@6jod5pw75lyf>
 <20250626050219.1847316-1-niuxuewei.nxw@antgroup.com>
 <BL1PR21MB3115D30477067C46F5AC86C3BF45A@BL1PR21MB3115.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <BL1PR21MB3115D30477067C46F5AC86C3BF45A@BL1PR21MB3115.namprd21.prod.outlook.com>

On Fri, Jun 27, 2025 at 08:50:46AM +0000, Dexuan Cui wrote:
>> From: Xuewei Niu <niuxuewei97@gmail.com>
>> Sent: Wednesday, June 25, 2025 10:02 PM
>> > ...
>> > Maybe when you have it tested, post it here as proper patch, and Xuewei
>> > can include it in the next version of this series (of course with you as
>> > author, etc.). In this way will be easy to test/merge, since they are
>> > related.
>> >
>> > @Xuewei @Dexuan Is it okay for you?
>>
>> Yeah, sounds good to me!
>>
>> Thanks,
>> Xuewei
>
>Hi Xuewei, Stefano, I posted the patch here:
>https://lore.kernel.org/virtualization/1751013889-4951-1-git-send-email-decui@microsoft.com/T/#u

Great, thanks!

>
>Xuewei, please help to re-post this patch with the next version of your patchset.
>Feel free to add your Signed-off-by, if you need.
>
>Thanks,
>Dexuan
>


