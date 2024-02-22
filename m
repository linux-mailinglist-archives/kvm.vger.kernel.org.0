Return-Path: <kvm+bounces-9426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6945A860052
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 19:04:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D27C91F2702F
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 18:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4018715697D;
	Thu, 22 Feb 2024 18:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VHXwExeS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28D14776E
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 18:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708625053; cv=none; b=sAqEQrCGtm9XnsnenEYenoDyf654zlr9E0svYXg0Gcn9fpTzp48zcAdYr6KTNPr61DMjzsFV0IPoUMTHMnQ4fk0EFlqfabOj0n0bb88wMUOmAObd0UPv1fK2fHgNvS8y0UVfBvpYyiaOoSuNNTMWGg5IotrG/7m0devesMJsEqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708625053; c=relaxed/simple;
	bh=5JM51lAyTKNNT8747SUelX8YF8GWYoh+Aq4eyoy7oHw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lAyi52rhlG4djllfd8mZbQ2jKd7kRqGMFsojHx8vSNEQtaQvnZbHHU2hAA2q/wQeHsYOnxt/4mCeLBK0ycOvMQZBPZFtiJ6scj+nH1eSgyRMC5W1xjnVO5ri0aGZcxRjQb/f+Q6ZsYj3GV0EWtrZClPZSB+yAW3CC1kRF51g7JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VHXwExeS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708625050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DzRuqJN84+wxPErDVkI1xf9yBbIoQD9FUTVkULwvLxs=;
	b=VHXwExeSkl/+cAc4EKXGKyAE/CpCBNwxm4ZJMxmRW1kF5ptncYuC8tAMv+g82whG1aCYYc
	zr0cmagYQiHHHFXMW0yldEwDPOCtt6DD60Ll4twfAFRGk7gxc2nmTcoqdvXEIA1N8bJ2+Z
	fpD6cMFD/wgesiOVadiAEPit3H6ap+o=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-gFBIKpZGN4S8-uKLSbsTlw-1; Thu, 22 Feb 2024 13:04:08 -0500
X-MC-Unique: gFBIKpZGN4S8-uKLSbsTlw-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3c03aefc499so1987562b6e.1
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 10:04:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708625048; x=1709229848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DzRuqJN84+wxPErDVkI1xf9yBbIoQD9FUTVkULwvLxs=;
        b=P8C72ymzBY3Pcn4jj+06A5t4AacTcGhCBh/YDhz1cOZ3Jj6RpedxRihQtXS8K56Ie6
         VQAFVSZfcpeI9mfU2oK10bxN9XuagsmN7uphFsCHUNn296HGYHBnGv9Fy2Gbm1FFqRyJ
         UPxkIkwwys0SbD7vq1Wciq6H9vdXdxc1w5g7LrSqj+Qt5LjAR4uT1zultYlAN0yIU6E+
         iVC4dIwZMqdgVZFB9VrNOjNt220V/4vxchuOt+Tx/XQo7Rvmbt1/kFL/NMSd1PR14GIh
         Gs5Fem7t0+vhBLqDnUhXQvjzR48zUKJOAkLR4JEFJr+J8ixrbZkttWGNWPHlcq33yyl5
         +noA==
X-Forwarded-Encrypted: i=1; AJvYcCUUpaaepwDj7GBykro1jZk+43rhG4bYAtedpPY2HQzp/xt0BcRChPLZoyJOuDYbOykyL1efDMQW3uaCXQkvc7D6YKn2
X-Gm-Message-State: AOJu0YxYG8nGTX6wDsJRSyYsl67LOVGzvXhMnijRqbrRKs6UV997/8Rd
	9qPMuf5QKYn3RmbG7Kemzn9zzoECHSo3jYEr+/hr0Jx8ferU2juKzwUSW7gc9leW/H7yCCQ5zSY
	YUYFsHFAUxbmrZz738L85C0IiTOk33BKOipV5u8siAWe6YyzCPQ==
X-Received: by 2002:a05:6808:f8b:b0:3c1:7eac:a8a1 with SMTP id o11-20020a0568080f8b00b003c17eaca8a1mr2076341oiw.49.1708625048056;
        Thu, 22 Feb 2024 10:04:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG/IWshRDtx/YpRYAWYsI9yk4t00sLhVrrVNyM2cwM2FGEyWfuhDHq8KZQdfgPcOJUpPwSp+g==
X-Received: by 2002:a05:6808:f8b:b0:3c1:7eac:a8a1 with SMTP id o11-20020a0568080f8b00b003c17eaca8a1mr2076325oiw.49.1708625047781;
        Thu, 22 Feb 2024 10:04:07 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id n16-20020a0568080a1000b003c03f08d619sm2047241oij.42.2024.02.22.10.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 10:04:07 -0800 (PST)
Date: Thu, 22 Feb 2024 11:04:05 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: "jgg@nvidia.com" <jgg@nvidia.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
 <joao.m.martins@oracle.com>, "leonro@nvidia.com" <leonro@nvidia.com>,
 "maorg@nvidia.com" <maorg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH V1 vfio 0/5] Improve mlx5 driver to better handle some
 error cases
Message-ID: <20240222110405.759b8971.alex.williamson@redhat.com>
In-Reply-To: <bdb66db6-cd41-4d0d-bc69-33390953f385@nvidia.com>
References: <20240205124828.232701-1-yishaih@nvidia.com>
	<BN9PR11MB527688453C0D5D4789ADDF968C462@BN9PR11MB5276.namprd11.prod.outlook.com>
	<1175d7ed-45f3-42d0-a3cb-90ef2df40dbb@nvidia.com>
	<244923bb-7732-4a9b-b5da-6a778ba4dd60@nvidia.com>
	<bdb66db6-cd41-4d0d-bc69-33390953f385@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 21 Feb 2024 09:45:14 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 08/02/2024 10:16, Yishai Hadas wrote:
> > On 06/02/2024 10:06, Yishai Hadas wrote:  
> >> On 06/02/2024 9:35, Tian, Kevin wrote:  
> >>>> From: Yishai Hadas <yishaih@nvidia.com>
> >>>> Sent: Monday, February 5, 2024 8:48 PM
> >>>>
> >>>> This series improves the mlx5 driver to better handle some error cases
> >>>> as of below.
> >>>>
> >>>> The first two patches let the driver recognize whether the firmware
> >>>> moved the tracker object to an error state. In that case, the driver
> >>>> will skip/block any usage of that object.
> >>>>
> >>>> The next two patches (#3, #4), improve the driver to better include the
> >>>> proper firmware syndrome in dmesg upon a failure in some firmware
> >>>> commands.
> >>>>
> >>>> The last patch follows the device specification to let the firmware 
> >>>> know
> >>>> upon leaving PRE_COPY back to RUNNING. (e.g. error in the target,
> >>>> migration cancellation, etc.).
> >>>>
> >>>> This will let the firmware clean its internal resources that were 
> >>>> turned
> >>>> on upon PRE_COPY.
> >>>>
> >>>> Note:
> >>>> As the first patch should go to net/mlx5, we may need to send it as a
> >>>> pull request format to vfio before acceptance of the series, to avoid
> >>>> conflicts.
> >>>>
> >>>> Changes from V0: https://lore.kernel.org/kvm/20240130170227.153464-1-
> >>>> yishaih@nvidia.com/
> >>>> Patch #2:
> >>>> - Rename to use 'object changed' in some places to make it clearer.
> >>>> - Enhance the commit log to better clarify the usage/use case.
> >>>>
> >>>> The above was suggested by Tian, Kevin <kevin.tian@intel.com>.
> >>>>  
> >>>
> >>> this series looks good to me except a small remark on patch2:  
> >>
> >> We should be fine there, see my answer on V0.
> >>  
> >>>
> >>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>  
> >>
> >> Thanks Kevin, for your reviewed-by.
> >>
> >> Yishai
> >>  
> > 
> > Alex
> > 
> > Are we OK here to continue with a PR for the first patch ?
> > 
> > It seems that we should be fine here.
> > 
> > Thanks,
> > Yishai
> >   
> 
> Hi Alex,
> Any update here ?

Sure, if Leon wants to do a PR for struct
mlx5_ifc_query_page_track_obj_out_bits, that's fine.  The series looks
ok to me.  The struct definition is small enough to go through the vfio
tree with Leon's ack, but I'll leave it to you to do the right thing
relative to potential conflicts.  Thanks,

Alex


