Return-Path: <kvm+bounces-18591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 880208D7A4E
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 05:01:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BF5E280AAB
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 03:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 660FEF4FA;
	Mon,  3 Jun 2024 03:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RJls2ndJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC70EAC2
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 03:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717383659; cv=none; b=GWxkkyeIlBgRjLZT7WewtdcsJ/3Dq989P9FV1T/jiMzqufeOn0Zzg00DlFMioTaEL+hJBw5VJomp5WD87vHVwpEh4CQFlh8ooC5Nx6wYV39+w2MH6VAaxHZ51xTEWzeCjVbbnRsrZlErc2Jvv3qHY2VjUddoZrH/ltsvgQhaZbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717383659; c=relaxed/simple;
	bh=MjhqgTMKhF9fLZXkh9mt8pF1G2ao5qC52AhxiRQjj5w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SaCVx5s+V+pjalxX5j1Mn1SvIuC7pa8jPq56sJKufpdUjENCXvmhjryd23FrB69VmqctKcUtEs/mlJHXh8CI9i6wXI4S7Hj8Xv4GuEXx44FbKOAUn3q70VZxYe5ivxBXowwk7kEX9g0trI9yFUpiN35J1EDuj5TzadkoGHJKigE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RJls2ndJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717383656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=unZCWVLw6WeMHeWyR9das59U+NwZwsFneJsvRAc5Z/M=;
	b=RJls2ndJDOajaaei15iXsalD6GGMCCRNI0+Ntm3ucN/SxzR/R/0IAk62vMfT5i/4vXP0c+
	UmYhRFdV8v5BxYGBsci/L0RPKdLxsliw5E14DWXBKAqgA5Tw3laSQeq+wnKObpZAhFpvcw
	qYDfGoOnSmPNtCuQrQZfouF6jpWFv2g=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-UIqdDNlsOtK-44kZDEqkiw-1; Sun, 02 Jun 2024 23:00:55 -0400
X-MC-Unique: UIqdDNlsOtK-44kZDEqkiw-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3d1e9338051so1660140b6e.0
        for <kvm@vger.kernel.org>; Sun, 02 Jun 2024 20:00:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717383655; x=1717988455;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=unZCWVLw6WeMHeWyR9das59U+NwZwsFneJsvRAc5Z/M=;
        b=GsYtaKM7Eq+cP3/A9vfA1JHm8jwz8UFvihbmorLCjtHWl54GDn7U5mmbIXIeHs2MzU
         1ONoBsmqONZ3r05TC7Og6KMzLJWBiXhwevjqJ/x9eRhJlOeQ7xsQsYtgYdRiDdnuBpvT
         5pCIigsxlk+79VoEwrw3GE1jYo+LMDkpMn7kVwKzenMmbRbVzMDfSVGj54AbsHFFu+RP
         H9YwRvh03xggH0CqkS378w2qzPG1L6PzpC9/e/5iVkT3+n/oH3AZtlKHgXmeTn6O7XB9
         Us3WAWM6ggFxjRSKytRF0gFJ8BWMWraQIDWlYvIF5TjgjWQouhFacXlJt3u7R1u9Q6KB
         6PIg==
X-Gm-Message-State: AOJu0YwLGIznCGziEZ3lLFkVUczFUNlONNUl2j5+qcNQ8L64F48f0MvU
	zYAEZcC7NnG9vCDQrN+aCB8rDTxa1jtTpEg1jprs7307Cqo4Yyl6gK6+cZEpxw/Zf2vFJ152QHy
	p5UoQ8p2W+oGAjw9zY2EIIAl0dMfMG2VY+oY9sAqfAzvQ521hrA==
X-Received: by 2002:aca:902:0:b0:3c9:bcf1:96a6 with SMTP id 5614622812f47-3d1e348fffbmr8852660b6e.22.1717383654490;
        Sun, 02 Jun 2024 20:00:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcXNHWVuxtfOzHrQPXq4H7P/knZYyDVzu8YxcAP7J+ra7mKR6SJ1/k9qaEYYaOH6kCrmiQ/w==
X-Received: by 2002:aca:902:0:b0:3c9:bcf1:96a6 with SMTP id 5614622812f47-3d1e348fffbmr8852649b6e.22.1717383654155;
        Sun, 02 Jun 2024 20:00:54 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ae4b42be51sm26623166d6.144.2024.06.02.20.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 20:00:53 -0700 (PDT)
Date: Sun, 2 Jun 2024 21:00:40 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: <kvm@vger.kernel.org>, <ajones@ventanamicro.com>,
 <kevin.tian@intel.com>, <jgg@nvidia.com>, <peterx@redhat.com>
Subject: Re: [PATCH v2 1/2] vfio: Create vfio_fs_type with inode per device
Message-ID: <20240602210040.2c5c487a.alex.williamson@redhat.com>
In-Reply-To: <ZlpgG4vA+2yScHE/@yzhao56-desk.sh.intel.com>
References: <20240530045236.1005864-1-alex.williamson@redhat.com>
	<20240530045236.1005864-2-alex.williamson@redhat.com>
	<ZlpgG4vA+2yScHE/@yzhao56-desk.sh.intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 1 Jun 2024 07:41:15 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Wed, May 29, 2024 at 10:52:30PM -0600, Alex Williamson wrote:
> ...
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index 610a429c6191..ded364588d29 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -286,6 +286,13 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
> >  	 */
> >  	filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
> >    
> Instead of using anon_inode_getfile(), is it possible to get the filep like
> filep = alloc_file_pseudo_noaccount(device->inode,
> get_vfs_mount(),"[vfio-device]", O_RDWR, &vfio_device_fops);
> 
> > +	/*
> > +	 * Use the pseudo fs inode on the device to link all mmaps
> > +	 * to the same address space, allowing us to unmap all vmas
> > +	 * associated to this device using unmap_mapping_range().
> > +	 */
> > +	filep->f_mapping = device->inode->i_mapping;  
> Then this is not necessary here. 

Maybe?  The code paths are not obviously equivalent to me, so I think
this adds risk to a series being proposed for the rc cycle.  Would you
like to propose this as a change on top of this series for v6.11?
Thanks,

Alex


