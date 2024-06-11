Return-Path: <kvm+bounces-19368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 725F0904775
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:05:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E29FB22C69
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 23:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724C9156225;
	Tue, 11 Jun 2024 23:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RixpK+cy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9495BAFC
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 23:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718147086; cv=none; b=qKTpy3VptsWm3/nYtOf5X+Y6+2+DMACft1YC0tlOApbwsbKPYCfFpOcIveouV2jyB3VmQX5Gu3ENC2UGZty44PUX38P39HxyM5o5mdm1Slpse4oDSweFcyljRfb1pEHe1bnhaKqdRiwNObXWZD6SJtBoHAZkbn4Srx0I9ffAn2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718147086; c=relaxed/simple;
	bh=WgQTsjhgFTPo5g3swBUHYLB5cTMjLhRB5VKwujox9LI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T3bLSfMm1Nvr91VeRNrZnmOi3kuhnnoagVZF45bZjYcuOdd7RVBG4r7NvBrHYlBGNIR8dr/Lw4jmMNm9/ENgDdFkwYZslaiMOtwpO+C/PFFv9iVIbDhwf0AxnEaYi1NzQvLKG27Wijgi5Mk11IZ7GGGRk6PYTokmTMmd9oMv2ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RixpK+cy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718147083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FDzDu+45eFDjY4XI9ncsaJcxp9S5zkG6Iy9Nqh5PCDc=;
	b=RixpK+cyO4XTNfQmHs6fa96qO4ecChRCLVGV/+V7t6Zp85beJaHTpNrJ2G3FBgudCeBbS9
	P+jUGfsGLi181KQH/oLOCdDGmJmibFu3dZW0x9ODWI+9JYumfjF3gWCtJGWLvRrskZFOnX
	DWGbtLroKr495mJLFsKygJOb35D4B0k=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-AAysXWWhNSOG6GisBtodDQ-1; Tue, 11 Jun 2024 19:04:42 -0400
X-MC-Unique: AAysXWWhNSOG6GisBtodDQ-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-25475e2dd2dso4905691fac.2
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 16:04:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718147082; x=1718751882;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FDzDu+45eFDjY4XI9ncsaJcxp9S5zkG6Iy9Nqh5PCDc=;
        b=UT+F2KEgnJvC65KfPaaeNZyDFTziYOe19efaOwiBp+22cLx+3az40JXz888Sjt2KFG
         trlIhBVZ/sEXitfjMezgkWp4ndONyona91aXC3wLokwDEABPm3IdjbbqAqQiCY9mppRx
         CG3hg85KtwXEbm/p2V+LbjGehTKHSuBHElHqY1tKC3mKreEJpuR4QszvPpj0TzOVjErr
         BnNZeo80YJa3nIXtPEq/I5HY6rSimGcAKw2ylzzW7jqA9LN2snbD7me2OP+PfMe2oc52
         P6Xy2DEp/Kabu36qbeKs0DSSdncTiQX+mpkPt5F1TyncvyJvEfqpQzsd6Qrqjec3lN3W
         yImA==
X-Forwarded-Encrypted: i=1; AJvYcCXadQnVdJ0+qiCJxC11LCv7gKdSXdGJOc2xdVjp6J89OIBPGPlcIgZ2bHPK8dHwaDaWmufx+hrI8QdD+Jo4fnDVN/Iw
X-Gm-Message-State: AOJu0YxDAec4VaMUJVJhAQEGgGOR4xtY3opv8tB1iDBozGbbCS7vMIXY
	/QnRgVFu7A6JRta9SGfOdTJy4sbJQZk0gauwQLDGgwoQOtNPz3Wkx0mRlq5Zg2uKU0lritgVWCf
	0MqV+UoDs8RpKSsKHCgV+vnrKmsd7a9T7jGndHKLwj3qqAECP6w==
X-Received: by 2002:a05:6871:588d:b0:254:d4e3:bdd6 with SMTP id 586e51a60fabf-25514feac95mr198511fac.56.1718147081678;
        Tue, 11 Jun 2024 16:04:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+DcQwiV3pGkiKFHbIDKxUzbnnLgfKf0YMRMgmxgySBftfspyxgrkYZBI8AWfucEMkV5fD4w==
X-Received: by 2002:a05:6871:588d:b0:254:d4e3:bdd6 with SMTP id 586e51a60fabf-25514feac95mr198477fac.56.1718147081153;
        Tue, 11 Jun 2024 16:04:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-25447ecc81dsm3053041fac.32.2024.06.11.16.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 16:04:40 -0700 (PDT)
Date: Tue, 11 Jun 2024 17:04:38 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Fei Li <fei1.li@intel.com>, kvm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] UAF in acrn_irqfd_assign() and vfio_virqfd_enable()
Message-ID: <20240611170438.508a2612.alex.williamson@redhat.com>
In-Reply-To: <20240610205305.GE1629371@ZenIV>
References: <20240607015656.GX1629371@ZenIV>
	<20240607015957.2372428-1-viro@zeniv.linux.org.uk>
	<20240607015957.2372428-11-viro@zeniv.linux.org.uk>
	<20240607-gelacht-enkel-06a7c9b31d4e@brauner>
	<20240607161043.GZ1629371@ZenIV>
	<20240607210814.GC1629371@ZenIV>
	<20240610051206.GD1629371@ZenIV>
	<20240610140906.2876b6f6.alex.williamson@redhat.com>
	<20240610205305.GE1629371@ZenIV>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Jun 2024 21:53:05 +0100
Al Viro <viro@zeniv.linux.org.uk> wrote:

> On Mon, Jun 10, 2024 at 02:09:06PM -0600, Alex Williamson wrote:
> > > 
> > > We could move vfs_poll() under vm->irqfds_lock, but that smells
> > > like asking for deadlocks ;-/
> > > 
> > > vfio_virqfd_enable() has the same problem, except that there we
> > > definitely can't move vfs_poll() under the lock - it's a spinlock.  
> > 
> > vfio_virqfd_enable() and vfio_virqfd_disable() are serialized by their
> > callers, I don't see that they have a UAF problem.  Thanks,
> > 
> > Alex  
> 
> Umm...  I agree that there's no UAF on vfio side; acrn and xen/privcmd
> counterparts, OTOH, look like they do have that...
> 
> OK, so the memory safety in there depends upon
> 	* external exclusion wrt vfio_virqfd_disable() on caller-specific
> locks (vfio_pci_core_device::ioeventfds_lock for vfio_pci_rdwr.c,
> vfio_pci_core_device::igate for the rest?  What about the path via
> vfio_pci_core_disable()?)

This is only called when the device is closed, therefore there's no
userspace access to generate a race.

> 	* no EPOLLHUP on eventfd while the file is pinned.  That's what
>         /*
>          * Do not drop the file until the irqfd is fully initialized,
>          * otherwise we might race against the EPOLLHUP.
>          */
> in there (that "irqfd" is a typo for "kirqfd", right?) refers to.

Sorry, I'm not fully grasping your comment.  "irqfd" is not a typo
here, "kirqfd" seems to be a Xen thing.  I believe the comment is
referring to holding a reference to the fd until everything is in place
to cleanup correctly if the user process is killed mid-setup.  Thanks,

Alex


