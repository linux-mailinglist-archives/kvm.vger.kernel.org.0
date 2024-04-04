Return-Path: <kvm+bounces-13611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD6E898F68
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 22:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F62C1C22C6F
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D131350D6;
	Thu,  4 Apr 2024 20:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LupWakxJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1927D138482
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 20:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712261276; cv=none; b=Wu31MFk5rHr/TrCEROj8/MNdpt61unfV70XdxcMa3kfHC4YHC8dEzVUxe4aBcWeb12235FVJw9IqtWEV6NbQGDk5GXLb5lgkVT40xUIoWWw0KanPfrlt0renSDrWTAkJJipYtwQC/IX/HksZbERsqQwJAWhrCCar+NyDT1qlTiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712261276; c=relaxed/simple;
	bh=F7nFkAVtXzPGjLTO3whVH6ckeO/jZuAKYHBc+06D804=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dc/3SS3s6REhgmr1Bn3K8BoJU9NsHeWM2W/UuuH+5ab0y+1CpIDhi1IPmlYUnZi1ChqTKM0qDswWaJ8XPk2FSNeVLlIV7G+MffkbZma3SCqt+FrJvTAQlPWSYmuFohd6r6r97sQCGyRbZ0vdhgP5S8ETDFsNCzn8HYx19KrZuRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LupWakxJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712261273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dBwnpmoXZkQWB3sRlzQjNLqJlL/NUB2ApA0wBpLvaEw=;
	b=LupWakxJjM4vrDHlgSPqaXQZx93bMjs+HkT6OAPPdmAOqlzD0Is8YsSxWazi4ZvJdKEwCH
	d8BC010MAg9dfB3FAQwynVX08x1JTEwBJQAAXMPBCYYXLqqRMdvXHq+2dPTv0hCpIO4YCw
	PAVSdta5IIGYgPzFRV2HM76gunvuaOE=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-3JMG_ECLPPebaQDdHBYFhg-1; Thu, 04 Apr 2024 16:07:52 -0400
X-MC-Unique: 3JMG_ECLPPebaQDdHBYFhg-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7cbfd4781fcso139929839f.3
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 13:07:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712261272; x=1712866072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dBwnpmoXZkQWB3sRlzQjNLqJlL/NUB2ApA0wBpLvaEw=;
        b=MKm9nZTQt8y0BieFf5pN83HT+DIGD1HgmSwb4B1dQ5gzlYTlotjumkljdP66oXmwTt
         ReNWy4w7tCv351Ptcye7faMq3gsDgFuaSaxPF6BBstheY2ZqFUk85kx7RhU8iWj1uML/
         ygYJpuHCkKow3keov1wypyPoGFoNJSF2UyW/0qeYDfRy/Em6ftuJT8ekddWs6oPhzaEY
         1LZdthqYcH9v6TncFIHsYzfX6FKaV2c+TXKeu64G1HnndHHuFwiFLm7vpDkWfgrYYZFC
         Ems/I5y0lUM46Wa/gNJxHaPCgabXZk2XLTnVPWtU8mqk1JsLfuUtw8m1jnvxZMfmd0uu
         6LmA==
X-Forwarded-Encrypted: i=1; AJvYcCXDqugQ7/U5oB/PGYa0mixGx87HaPx3eRCLtUagpmSGWBmtzKx+2rHgG8lUWvVHebRZZpJqjaZi8SDYXedJHfV2gppL
X-Gm-Message-State: AOJu0Yw+/URrfhmaT/0+50yKYXO6sFiJTYb0BzAx3RTdgcA4CmNoy9BX
	5etxAWBjy+KzyHq2U8PVMXBT8Hgwa6q8Il0NIChCDcngB9RLXN+pu62gN/j3eEFlgw4JwcAwnSI
	HN57/C7ud+HhR97mWssw+wBEi+plwLfQ71dnqehKG8QjrDqdbRw==
X-Received: by 2002:a05:6e02:1fee:b0:368:a446:bdc8 with SMTP id dt14-20020a056e021fee00b00368a446bdc8mr460984ilb.22.1712261271929;
        Thu, 04 Apr 2024 13:07:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaqoDO/+tFcCqum8TqiKc+I/+p4CsQH6hcDf+tNsGOSm5B9KajL+oD63U+eSt4FNzehJDYhQ==
X-Received: by 2002:a05:6e02:1fee:b0:368:a446:bdc8 with SMTP id dt14-20020a056e021fee00b00368a446bdc8mr460961ilb.22.1712261271612;
        Thu, 04 Apr 2024 13:07:51 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id p5-20020a92da45000000b003686160b165sm5848ilq.75.2024.04.04.13.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 13:07:51 -0700 (PDT)
Date: Thu, 4 Apr 2024 14:07:50 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v4 4/4] Documentation: add debugfs description for hisi
 migration
Message-ID: <20240404140750.78549701.alex.williamson@redhat.com>
In-Reply-To: <20240402032432.41004-5-liulongfang@huawei.com>
References: <20240402032432.41004-1-liulongfang@huawei.com>
	<20240402032432.41004-5-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 2 Apr 2024 11:24:32 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> Add a debugfs document description file to help users understand
> how to use the hisilicon accelerator live migration driver's
> debugfs.
> 
> Update the file paths that need to be maintained in MAINTAINERS
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../ABI/testing/debugfs-hisi-migration        | 34 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 35 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration
> 
> diff --git a/Documentation/ABI/testing/debugfs-hisi-migration b/Documentation/ABI/testing/debugfs-hisi-migration
> new file mode 100644
> index 000000000000..3d7339276e6f
> --- /dev/null
> +++ b/Documentation/ABI/testing/debugfs-hisi-migration
> @@ -0,0 +1,34 @@
> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/data
> +Date:		Apr 2024
> +KernelVersion:  6.9

At best 6.10 with a merge window in May.

> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Read the live migration data of the vfio device.
> +		These data include device status data, queue configuration
> +		data and some task configuration data.
> +		The output format of the data is defined by the live
> +		migration driver.

"Dumps the device debug migration buffer, state must first be saved
using the 'save' attribute."

> +
> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/attr
> +Date:		Apr 2024
> +KernelVersion:  6.9
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Read the live migration attributes of the vfio device.
> +		it include device status attributes and data length attributes
> +		The output format of the attributes is defined by the live
> +		migration driver.

AFAICT from the previous patch, this attribute is useless.

> +
> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
> +Date:		Apr 2024
> +KernelVersion:  6.9
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Used to obtain the device command sending and receiving
> +		channel status. If successful, returns the command value.
> +		If failed, return error log.
> +

Seems like it statically returns "OK" plus the actual value.


> +What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/save
> +Date:		Apr 2024
> +KernelVersion:  6.9
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Trigger the Hisilicon accelerator device to perform
> +		the state saving operation of live migration through the read
> +		operation, and output the operation log results.

These interfaces are confusing, attr and data only work if there has
either been a previous save OR the user migration process closed saving
or resuming fds in the interim, and the user doesn't know which one
they get.  Note that debug_migf isn't even discarded between
open/close, only cmd and save require the device to be opened by a
user, data and attr might continue to return data from some previous
user save, resume, or debugfs save.



> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7625911ec2f1..8c2d13b13273 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23072,6 +23072,7 @@ M:	Longfang Liu <liulongfang@huawei.com>
>  M:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>  L:	kvm@vger.kernel.org
>  S:	Maintained
> +F:	Documentation/ABI/testing/debugfs-hisi-migration
>  F:	drivers/vfio/pci/hisilicon/
>  
>  VFIO MEDIATED DEVICE DRIVERS


