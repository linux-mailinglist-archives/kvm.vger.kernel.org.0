Return-Path: <kvm+bounces-2887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C20E7FED35
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 11:45:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC0AC1C20DFB
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E846C3C073;
	Thu, 30 Nov 2023 10:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OLcrGJmL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F4D10D1
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 02:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701341150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B+/fVsomVnX5cZm/evhOjmLgbPyA21ZG8SCMHLJVHq4=;
	b=OLcrGJmL/BCTFoqTyrKR1P70GeaUaIYDgLLrCf4okIqeAwJO7hR6OlGHVbO61ufVTGXkwz
	hql6mf01yDzVLpNsuqA3C2m1aBDKvi9air1q2MW4aOz2CiA1TL400xwc60nqiRAH8BM5U6
	6U0gkoGhAbYhC0/C0OTVL0Gy1k1NvH0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-xShiwIXaOzu0ZhMLZPNNrg-1; Thu, 30 Nov 2023 05:45:48 -0500
X-MC-Unique: xShiwIXaOzu0ZhMLZPNNrg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-332e82bb756so529478f8f.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 02:45:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701341147; x=1701945947;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B+/fVsomVnX5cZm/evhOjmLgbPyA21ZG8SCMHLJVHq4=;
        b=m3xqrQt24/ny2SFS5fJ+AepdW9wvj1kCNKGsqSkd/UOQ4aw2llyPLPGDKtZ+tkmDiS
         HWiT915HluMd1D5BwmDkYKW0CIeT7ljWGYIuGP+ZUZIkfSCsl+gRTZIXZG7LIfqagkf7
         oxqIWtiQcnFWo3g3d3j+4ntoD3CcK90Oyeq2IpejkCKlFgEfm6yK7jPNRPy8zVKVpcyH
         0/WxeDmcKu8uNd2NwqiHnLzhFsAmaSqqMafnLcDm5LuWIeHGxxyUAkI3nK94Ntm2BL9l
         WQNPvCnoZZ2KPRdy982IQGA7C3bPp30vTRu2VoR1u9Pr9/U8kwwp67wixqTe6gLzWK5H
         ZU0A==
X-Gm-Message-State: AOJu0YzDMIxldwuAlnB4B90iqQQWftzEZoWKOBEJQmmfiJROxf8TE0zZ
	iK8d43isu0+ri0/coWbnJvpo+0H+azL04U08UI1zYfSEh+FW3SfTLy9qZw1GxxjXrlmI5XVyhVT
	ENGRbHVSGW2fLUIlsTEux
X-Received: by 2002:adf:e847:0:b0:333:a20:f824 with SMTP id d7-20020adfe847000000b003330a20f824mr6187508wrn.17.1701341146992;
        Thu, 30 Nov 2023 02:45:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECV7SLySk5Xo4ac8CHxyIpb+No3gMIcORmfV3LcmSIsbK8lAAd+6tPhREEsDfpfWv2FoUlIg==
X-Received: by 2002:adf:e847:0:b0:333:a20:f824 with SMTP id d7-20020adfe847000000b003330a20f824mr6187483wrn.17.1701341146606;
        Thu, 30 Nov 2023 02:45:46 -0800 (PST)
Received: from redhat.com ([2.55.10.128])
        by smtp.gmail.com with ESMTPSA id x4-20020a5d60c4000000b00332cbd59f8bsm1185570wrt.25.2023.11.30.02.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 02:45:45 -0800 (PST)
Date: Thu, 30 Nov 2023 05:45:42 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
	kevin.tian@intel.com, joao.m.martins@oracle.com,
	si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V4 vfio 4/9] virtio-pci: Introduce admin commands
Message-ID: <20231130054453-mutt-send-email-mst@kernel.org>
References: <20231129143746.6153-1-yishaih@nvidia.com>
 <20231129143746.6153-5-yishaih@nvidia.com>
 <20231130044910-mutt-send-email-mst@kernel.org>
 <aaa83d6a-779d-44cb-a72e-83ba9c8db76b@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaa83d6a-779d-44cb-a72e-83ba9c8db76b@nvidia.com>

On Thu, Nov 30, 2023 at 12:35:09PM +0200, Yishai Hadas wrote:
> On 30/11/2023 11:52, Michael S. Tsirkin wrote:
> > On Wed, Nov 29, 2023 at 04:37:41PM +0200, Yishai Hadas wrote:
> > > +/* Transitional device admin command. */
> > > +#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE	0x2
> > > +#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ		0x3
> > > +#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE		0x4
> > > +#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
> > > +#define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
> > > +
> > > +/* Increment MAX_OPCODE to next value when new opcode is added */
> > > +#define VIRTIO_ADMIN_MAX_CMD_OPCODE			0x6
> > 
> > Does anything need VIRTIO_ADMIN_MAX_CMD_OPCODE? Not in this
> > patchset...
> > 
> 
> Right, once you suggested to move to 'u64 supported_cmds' it's not any more
> in use.
> 
> It still can be used in the future, however I can drop it if it's worth a V5
> sending.
> 
> Yishai

If you don't need it then yea, we need to be careful about what we put in uapi headers.
wait with v5 until others can review v4 though.

-- 
MST


