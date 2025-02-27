Return-Path: <kvm+bounces-39644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E9D6A48C10
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 23:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 487C71889DF2
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 22:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CD7923E32F;
	Thu, 27 Feb 2025 22:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U6oxeb6C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C67227EB0
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 22:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740696895; cv=none; b=Ii5W2ye33dBMoSfNyRKrW+e7RKfVkZ5mlMOpMNZz/8vEvWyHqfXFei3L9FCICm60Huwa5y7CxbgPlmH17EiTwEqPMZ4b5GLE4cQM9/EFTctv9JnCbnX3bLiAtsG2w12LFOK12HxK2q6vo3rzLTYOJEBRyaE+1FBzrRhpmQg49xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740696895; c=relaxed/simple;
	bh=isM+P0D8Ztc3w8ml7L7wN08/KrinT+zgzJxFJaJXlW0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KXzwnmza4vrZelG1Xmm7saS63pzCj+uoMTJd3kfI2117Rhym2LZ071bFa2TXqeoQA4+s3Rnu9fpuASyQDIWN+3nyvkgHXts1V+TFVI096KRmnwoGZag+xiMMvutWm3JJ2xP/5PKCrwDYEW56JV8DavPhd38dosI8X8u/Toas3po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U6oxeb6C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740696892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UiESKZ4FebR2Yq0NgbIsVEH+VbxoyO9otVYB7Wuhmsc=;
	b=U6oxeb6Cz/SFreyo8qqymdnHNl9uHkytxdd7z8F6K2Hbh4egWx+d9+tEvyFQgDrO/2BMox
	15DWmJrUi7KA64Uz56h9wJjQJsrNWqJJvuYkp3zV4S8RQ67BJC26PhfKDRL2Z5zEjtZ9pK
	gG9zRl4f92DBDHciVY3vvzeMWKn3lWk=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-kzC3wGh9M7mKR1Add5cKkw-1; Thu, 27 Feb 2025 17:54:48 -0500
X-MC-Unique: kzC3wGh9M7mKR1Add5cKkw-1
X-Mimecast-MFC-AGG-ID: kzC3wGh9M7mKR1Add5cKkw_1740696888
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-855fc58b9b9so21699039f.3
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 14:54:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740696888; x=1741301688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UiESKZ4FebR2Yq0NgbIsVEH+VbxoyO9otVYB7Wuhmsc=;
        b=geBwU+O3xW7EB/n22+tVfRZFWwmsQh0epeqx36P/EfTOgqKEDHIQDMROhcU+NYteqS
         FR0bzlH4hQucsns3kpvlXJbVTU8w1XBsIPLeE7f/7bZ+TbucWmWna7ejzxF61cAEWHir
         CqBSdXMnkB9ytXJpi7IzK4p+JpmIuC9fhHyArCFZugzhomdzuFmlIkOun+isxqbhJe3D
         Rj417eliLlO+bup2W2xD3UaPvt2aORihQ5/yulEC8vRdJ8Z44XsSPBCL9TVm3qR1tUTw
         vJ/hNnUDIDo+IyoIZNyYzsVzKaYGVLLlvyI4E9mSHhsttAF8wgT//SVnN+5GrdIlqW0V
         V0mw==
X-Forwarded-Encrypted: i=1; AJvYcCU//7xxElYjhEzh8Gvg0qWVzu24Ne7t+M3JvuTGykA5TAbgKUzN+hdVc6q1hmIP1+Z79wY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb7qCVMQo4Ipj5J+r4ibMWzCHs7hPs/UGgY2PyjIXiMr+XwLW9
	Kx8kblzyFmqtP7CanLBdFaPYO09dT9koPQa6UfEwXJWNRyQzZXelHQPjVJiUCRzbu8PmagDualN
	+tCMq4iPz0aKBsAIm1Wr4WvjMYG4aJDbAXejcUpeLPVA2ogtzng==
X-Gm-Gg: ASbGncsgNnd3+Veofto/uMtuPVQNZ4yfT39oIKZLv7P7NOlu9TZ4YPKF+EI/E40dgut
	YvUaekuuSL39S/pRO8GypImSerO1tZfIqVPySieMsAXpVdp0MWDYX7KV7UUM5i25h2U0WigjBS3
	buqZr/Pfdk7kEmCLH+1Ycx4jWLdali6zQ1p1XYW168oUN3ibiA2KoWM37nsrcve+7jC+Mz2aV8Z
	Q+Mt79bgia82W7V1qHMlnCPdl/4HnZ07ZU8fS+/mJCTmrklfXf7kEBf2ivX2ZD7Oybq3kDWofmX
	x7WHOHz0ju6urcHrmU0=
X-Received: by 2002:a05:6e02:2181:b0:3d3:d187:7481 with SMTP id e9e14a558f8ab-3d3e6e223d7mr2253975ab.1.1740696888003;
        Thu, 27 Feb 2025 14:54:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHMedaVsEJTf4lzwnFUptrvda9SdGFu/7wKMkjX+d6rglnbylRnyVhU4TwwaXtmWb5hV8iFGg==
X-Received: by 2002:a05:6e02:2181:b0:3d3:d187:7481 with SMTP id e9e14a558f8ab-3d3e6e223d7mr2253945ab.1.1740696887715;
        Thu, 27 Feb 2025 14:54:47 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d3dee70dd3sm5227205ab.38.2025.02.27.14.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 14:54:46 -0800 (PST)
Date: Thu, 27 Feb 2025 15:54:44 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "mst@redhat.com" <mst@redhat.com>, "jasowang@redhat.com"
 <jasowang@redhat.com>, "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>, "parav@nvidia.com"
 <parav@nvidia.com>, "israelr@nvidia.com" <israelr@nvidia.com>,
 "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, "maorg@nvidia.com"
 <maorg@nvidia.com>
Subject: Re: [PATCH vfio] vfio/virtio: Enable support for virtio-block live
 migration
Message-ID: <20250227155444.57354e74.alex.williamson@redhat.com>
In-Reply-To: <8adbe43a-49f8-470c-be67-d343853b17f5@nvidia.com>
References: <20250224121830.229905-1-yishaih@nvidia.com>
	<BN9PR11MB527605EBEB4D6E35994EB8068CC22@BN9PR11MB5276.namprd11.prod.outlook.com>
	<8adbe43a-49f8-470c-be67-d343853b17f5@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Feb 2025 13:51:17 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 26/02/2025 10:06, Tian, Kevin wrote:
> >> From: Yishai Hadas <yishaih@nvidia.com>
> >> Sent: Monday, February 24, 2025 8:19 PM
> >>
> >>   config VIRTIO_VFIO_PCI
> >> -	tristate "VFIO support for VIRTIO NET PCI VF devices"
> >> +	tristate "VFIO support for VIRTIO NET,BLOCK PCI VF devices"
> >>   	depends on VIRTIO_PCI
> >>   	select VFIO_PCI_CORE
> >>   	help
> >> -	  This provides migration support for VIRTIO NET PCI VF devices
> >> -	  using the VFIO framework. Migration support requires the
> >> +	  This provides migration support for VIRTIO NET,BLOCK PCI VF
> >> +	  devices using the VFIO framework. Migration support requires the
> >>   	  SR-IOV PF device to support specific VIRTIO extensions,
> >>   	  otherwise this driver provides no additional functionality
> >>   	  beyond vfio-pci.  
> > 
> > Probably just describe it as "VFIO support for VIRTIO PCI VF devices"?
> > Anyway one needs to check out the specific id table in the driver for
> > which devices are supported. and the config option is called as
> > VIRTIO_VFIO_PCI  
> 
> I'm OK with that as well, both can work.
> 
> Alex,
> Any preference here ?

What's actually the proposal?  It's fine with me if we want to make the
tristate summary more generic, but I'd keep the mention of the specific
devices in the help text.  I don't know many users that preemptively
look at the id table.

I might replace "NET,BLOCK" with "NET and BLOCK" for readability though.
Thanks,

Alex


