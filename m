Return-Path: <kvm+bounces-63247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A5DDBC5EF6D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:06:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 955724F6698
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 18:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD682E0915;
	Fri, 14 Nov 2025 18:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aEL+6eZl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9B12DF12C
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 18:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763146469; cv=none; b=przX7X6l1C1aPmGWgaO8VKp1waZIw9cW3V/mVYXcLoURLlaRIEnPoJugFfPYRPpvdHISeuX0lnHyjdrcYFjfqmoFcnfTd/U4T2aMMLdRDkxKtkr7xek2UCokSUnn7f+tO3DI3VlVyulKGCutDmUDVuMK4Nt/lMgF1mlGoJtSt84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763146469; c=relaxed/simple;
	bh=WupAXsUwOqm9N8aItz9IuraBGtbt6+1ogwOCXXBfEo8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j3wVb/FcGCDX3mw+nIrXF9AM/QJ9GsecJ3sZUiJR4iI34ErSV0RmKNaYIT9Fki0tZ8T8sq7S3yd//di8yxbsTw2g97TCxqPExS6iIm45zGtHiUILicgwV4FObYIK8FvDrl41WRmijHSHc2TmfAnf+d+wuXBRCI8sGhu0zzPgVAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aEL+6eZl; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-477563e28a3so15924685e9.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 10:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763146466; x=1763751266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=su/3DTeyEOfiuZEhYMJ4B5Ixwohi82QW36MCAtfZ6Mw=;
        b=aEL+6eZlK4ykBqffMe3TD/VnapzlEsaQbb0yxH2J1mLnTVjO5d8Hc6pBR4rbiXLHmH
         PPQBKL54zRgwtoBoIz1mFkZhb/TdhlpVMctKC1YKQahnWZR2RAStF2MtBXtO63ztfOqt
         tu9QFdgEJ4gaZ8lDw3xeiatveZhFEEdrpOo2duE7o7Ybwz9EjXRGzU1UOz0UYExB0Qfo
         BSlR8vWJKbNFxIE3Vzw6dRL6W5YwM3iRo9IGH3aWWWzvD9QUJ1PRgXexri4LHBp7jANG
         QbRqJ2KmE0zMMjtnGGgQtz1UsCMZlcaiUOMzGUb5/pBbvpkYuxpWPycoOfySc5MxHoHE
         8L5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146466; x=1763751266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=su/3DTeyEOfiuZEhYMJ4B5Ixwohi82QW36MCAtfZ6Mw=;
        b=I6XR/GJdubSB/7RfwyR3UTARhEUyLZR/i2H7kpjNbKaj5hEttNtCiFjODq7/i3S/F7
         9sCI5SjMdRxWuQDnTOmpa8qPknJixlAbUGBnauTZM4O/jS0rouerDmPj8c0f3Ca6ygkX
         mNBGuje7fRW39t3nQUPNCXSBQDQ5SLB+Tboc/OS+1OLHL8sPdCXR16yDdZvU/yQTj/x/
         CiedGZA9XIbkEfYaYTRF7OgRjfdhc+i3viNul2Mfqt4dS5aY5bZtjUzR1/hmHzFCG9HJ
         GGZnkzp1aTjDP4LL49go+lTNO4cnR6MVzoPwTTRthhAlVmU453LvR3N/HOrtD3uuSIhl
         /vVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXd+MPsaQVmpK9/wIF3vwLCzS3/mZylP9QCTyCWYIAhOEzeX1ZjWmSbp91e6iHvEhoHIGs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWKPld8IUWXsvcegUxM9Py2Yj5OcUopOMegqgaFA0JAHRmKlj9
	9c8nwRv9S9PB5zJuyDojggzBed7psNQK8XoSClh8qSKrTH60hjv3eZcC
X-Gm-Gg: ASbGncv5/v9AW3dHftXD/1qb4Yxjdmp30LpjCM+t4+720XitkNXzgEabWIFcic5+2TH
	3HqojFyAC5lD1K6vUe5rD+J7SLBBHOdGJv/hq/UIfRqSuojd5mAIe6zk5L52R9v/Wuz7CBc9o+a
	HTwtS32BDu3ezDrEbHGuuAMqud70iDgCDIlM04soJE+KOIDVIxra7cjagSGrFHfLlptx4ydYjST
	+Podx2hq5DD2PJt8x/OrwDVkNbwvXRu5OlMmiV7ONUA7GzxjYNvrKRCHp6v7dbyi/TBDV/dKiLK
	RE6mht+GN1UDRP4niElMYd1Pn9W3zJQX/F/awkUXghf5i8WNtNGHa7gFoX4zeXno5WWsHz1YYIj
	wWrTTyGt3Mff70rQcbnPu7ZKZboY+cTvKKkx4LZMmxOkgUkou7pWEJrFx3lpf5WuMJC5vttIPqW
	mtkudAReYpwvEqn4eaUWfP6OjIF9xyLAwaehUyQ5+QyUpfBdWeY76PceAZRGXL5fQ=
X-Google-Smtp-Source: AGHT+IEZk9USqhXcykeqQxv6BBqPJ+Ckp0QcbH6DW0s45+kWxw1D0bAUF1znH554QTmUBF8i4qIoUw==
X-Received: by 2002:a05:600c:6002:b0:477:8895:303c with SMTP id 5b1f17b1804b1-4778fd807f3mr32662695e9.3.1763146466154;
        Fri, 14 Nov 2025 10:54:26 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787ea39ccsm156460775e9.15.2025.11.14.10.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 10:54:25 -0800 (PST)
Date: Fri, 14 Nov 2025 18:54:24 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Jon Kohler <jon@nutanix.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Eugenio =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Sean
 Christopherson <seanjc@google.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user()
 and put_user()
Message-ID: <20251114185424.354133ae@pumpkin>
In-Reply-To: <20251113005529.2494066-1-jon@nutanix.com>
References: <20251113005529.2494066-1-jon@nutanix.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Nov 2025 17:55:28 -0700
Jon Kohler <jon@nutanix.com> wrote:

> vhost_get_user and vhost_put_user leverage __get_user and __put_user,
> respectively, which were both added in 2016 by commit 6b1e6cc7855b
> ("vhost: new device IOTLB API"). In a heavy UDP transmit workload on a
> vhost-net backed tap device, these functions showed up as ~11.6% of
> samples in a flamegraph of the underlying vhost worker thread.
> 
> Quoting Linus from [1]:
>     Anyway, every single __get_user() call I looked at looked like
>     historical garbage. [...] End result: I get the feeling that we
>     should just do a global search-and-replace of the __get_user/
>     __put_user users, replace them with plain get_user/put_user instead,
>     and then fix up any fallout (eg the coco code).
> 
> Switch to plain get_user/put_user in vhost, which results in a slight
> throughput speedup. get_user now about ~8.4% of samples in flamegraph.
> 
> Basic iperf3 test on a Intel 5416S CPU with Ubuntu 25.10 guest:
> TX: taskset -c 2 iperf3 -c <rx_ip> -t 60 -p 5200 -b 0 -u -i 5
> RX: taskset -c 2 iperf3 -s -p 5200 -D
> Before: 6.08 Gbits/sec
> After:  6.32 Gbits/sec
> 
> As to what drives the speedup, Sean's patch [2] explains:
> 	Use the normal, checked versions for get_user() and put_user() instead of
> 	the double-underscore versions that omit range checks, as the checked
> 	versions are actually measurably faster on modern CPUs (12%+ on Intel,
> 	25%+ on AMD).

Is there an associated access_ok() that can also be removed?

	David

