Return-Path: <kvm+bounces-31041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F2FA9BF898
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 22:41:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D781A283A6C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 21:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE32F20CCF2;
	Wed,  6 Nov 2024 21:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="df3HFfEv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343A2204958
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 21:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730929260; cv=none; b=eWkHTo49aEmJoDyMHujJsA4Hz8K1xwDZNQnPWhPzo4qGPglSwE+sA9kVyEubbbeb5plQBMzH5GhJ0OlWVoLle6Z018hir0ERPi64YJGxmFDR9qnaLaUjX2rvSMEmLThfP3hwsUMLATzAEHLoyTyFGvDXN3+g7mwpJejbs7ZYcAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730929260; c=relaxed/simple;
	bh=9Y+RRzsvAYCa/G23SNNKkBP82ujzZCoCFSvTIEULxsk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z2rnhHBlFRtGBSgC7w4OD9Wk+3suyXtegvNw58nb4LQ5UIsifJlBkWlrZ2r3hqwrB7s/UWRKaFYHo7nGz9SKe1S2UI+JiAD10eqPWmTG5JqDLw3ZraRYI8wzc8xFy/mNQIzJiLgpP4/GHoURg/ra5/FJnKXscWeAuoMDjD6CGCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=df3HFfEv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730929257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LkAv1xv3L+lLwsH5N6TnynV2mpC7hr2h9WvHLXOozvM=;
	b=df3HFfEvRirEm4HXBlo3qwtxbV9FjpzM8PrR4qAO4yyGeJkeXbb3WOn6AMq8JCjbpgPGZ/
	62mSGG+wsWYfbiZ2T8whtUiDe0mnx1ZDvKbziONCymxsr3ujk6w0Ln/mtehwZpBmC6oSw/
	8XnGU/n60nYt95bQnXEp2HHUO99u4qc=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-aBemTmTpN4aLyc_DrAiu7w-1; Wed, 06 Nov 2024 16:40:55 -0500
X-MC-Unique: aBemTmTpN4aLyc_DrAiu7w-1
X-Mimecast-MFC-AGG-ID: aBemTmTpN4aLyc_DrAiu7w
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a6cabd39e9so701835ab.0
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 13:40:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730929255; x=1731534055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LkAv1xv3L+lLwsH5N6TnynV2mpC7hr2h9WvHLXOozvM=;
        b=iMqXHQuMFr9gqiApVMCIgjg1T4YM1iTXrZh1TgiO9j48FaouKk6L0SVFupCSBtqERa
         oas8o+bItwA+DjINZhQelrAzNFSXQRw0al3e4YK7QIjZ3+eWv1EcwFAkzuJ71P72PArV
         XpA9BHeZvuopNRofTQC2zM10YskLpiSNzZI1NUyLT9gGZoc0Ly8qSYNRORBj+DdcmE21
         nJpQN4n2WFUIBYWeD0wr3pHESR2XTER8YxprfsEZJbbLkPehGci5FvvHc96HXfCfZT7R
         pmuNS/DCees+ZS0yRf+VnKro73ttojB2DbHemrQsx9nhl+5zBHjwWGK832N/grF3kjip
         zjpg==
X-Forwarded-Encrypted: i=1; AJvYcCX8FiFMWxCAfc+AbCEzQxhxTWfdabAqAJwI3qFRxUii4N85wan440E+k9JWrtNf9xHZjYE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuGr3ydXUT6MdW7ZAoS55MpifxvpDt7gSLdnHQdyJuIOYsafoi
	FWLzxWfW4bbrKOsb997roZiCBwcMsqgKYonLWxT/NDQ9S2KGIRI2pUlFUbXq00tFqPAALY5+QSF
	8neGZlIIU3YHWzJ0FtiZJosMuY/4vbxeU66zQzTCP+8shUwvylw==
X-Received: by 2002:a05:6602:6423:b0:83a:abd1:6af2 with SMTP id ca18e2360f4ac-83df2442e08mr31343239f.3.1730929255178;
        Wed, 06 Nov 2024 13:40:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmaJCa6K1T+N21UQP7q5cHuDh9w/YU3TsQUPNVu6zTjgnwEmuBfGqqe4PZwEt0qklkr+LM9A==
X-Received: by 2002:a05:6602:6423:b0:83a:abd1:6af2 with SMTP id ca18e2360f4ac-83df2442e08mr31341339f.3.1730929254742;
        Wed, 06 Nov 2024 13:40:54 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de048e4f56sm3023903173.78.2024.11.06.13.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 13:40:54 -0800 (PST)
Date: Wed, 6 Nov 2024 14:40:53 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio 6/7] vfio/virtio: Add PRE_COPY support for live
 migration
Message-ID: <20241106144053.2f365e22.alex.williamson@redhat.com>
In-Reply-To: <977be8e4-e52c-41bc-8a43-31ae906e6665@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
	<20241104102131.184193-7-yishaih@nvidia.com>
	<20241105161845.734e777e.alex.williamson@redhat.com>
	<977be8e4-e52c-41bc-8a43-31ae906e6665@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 6 Nov 2024 13:16:34 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 06/11/2024 1:18, Alex Williamson wrote:
> > On Mon, 4 Nov 2024 12:21:30 +0200
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >   
> >> Add PRE_COPY support for live migration.
> >>
> >> This functionality may reduce the downtime upon STOP_COPY as of letting
> >> the target machine to get some 'initial data' from the source once the
> >> machine is still in its RUNNING state and let it prepares itself
> >> pre-ahead to get the final STOP_COPY data.
> >>
> >> As the Virtio specification does not support reading partial or
> >> incremental device contexts. This means that during the PRE_COPY state,
> >> the vfio-virtio driver reads the full device state.
> >>
> >> As the device state can be changed and the benefit is highest when the
> >> pre copy data closely matches the final data we read it in a rate
> >> limiter mode and reporting no data available for some time interval
> >> after the previous call.
> >>
> >> With PRE_COPY enabled, we observed a downtime reduction of approximately
> >> 70-75% in various scenarios compared to when PRE_COPY was disabled,
> >> while keeping the total migration time nearly the same.
> >>
> >> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> >> ---
> >>   drivers/vfio/pci/virtio/common.h  |   4 +
> >>   drivers/vfio/pci/virtio/migrate.c | 233 +++++++++++++++++++++++++++++-
> >>   2 files changed, 229 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/drivers/vfio/pci/virtio/common.h b/drivers/vfio/pci/virtio/common.h
> >> index 3bdfb3ea1174..5704603f0f9d 100644
> >> --- a/drivers/vfio/pci/virtio/common.h
> >> +++ b/drivers/vfio/pci/virtio/common.h
> >> @@ -10,6 +10,8 @@
> >>   
> >>   enum virtiovf_migf_state {
> >>   	VIRTIOVF_MIGF_STATE_ERROR = 1,
> >> +	VIRTIOVF_MIGF_STATE_PRECOPY = 2,
> >> +	VIRTIOVF_MIGF_STATE_COMPLETE = 3,
> >>   };
> >>   
> >>   enum virtiovf_load_state {
> >> @@ -57,6 +59,8 @@ struct virtiovf_migration_file {
> >>   	/* synchronize access to the file state */
> >>   	struct mutex lock;
> >>   	loff_t max_pos;
> >> +	u64 pre_copy_initial_bytes;
> >> +	struct ratelimit_state pre_copy_rl_state;
> >>   	u64 record_size;
> >>   	u32 record_tag;
> >>   	u8 has_obj_id:1;
> >> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
> >> index 2a9614c2ef07..cdb252f6fd80 100644
> >> --- a/drivers/vfio/pci/virtio/migrate.c
> >> +++ b/drivers/vfio/pci/virtio/migrate.c  
> > ...  
> >> @@ -379,9 +432,104 @@ static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t le
> >>   	return done;
> >>   }
> >>   
> >> +static long virtiovf_precopy_ioctl(struct file *filp, unsigned int cmd,
> >> +				   unsigned long arg)
> >> +{
> >> +	struct virtiovf_migration_file *migf = filp->private_data;
> >> +	struct virtiovf_pci_core_device *virtvdev = migf->virtvdev;
> >> +	struct vfio_precopy_info info = {};
> >> +	loff_t *pos = &filp->f_pos;
> >> +	bool end_of_data = false;
> >> +	unsigned long minsz;
> >> +	u32 ctx_size;
> >> +	int ret;
> >> +
> >> +	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
> >> +		return -ENOTTY;
> >> +
> >> +	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
> >> +	if (copy_from_user(&info, (void __user *)arg, minsz))
> >> +		return -EFAULT;
> >> +
> >> +	if (info.argsz < minsz)
> >> +		return -EINVAL;
> >> +
> >> +	mutex_lock(&virtvdev->state_mutex);
> >> +	if (virtvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY &&
> >> +	    virtvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY_P2P) {
> >> +		ret = -EINVAL;
> >> +		goto err_state_unlock;
> >> +	}
> >> +
> >> +	/*
> >> +	 * The virtio specification does not include a PRE_COPY concept.
> >> +	 * Since we can expect the data to remain the same for a certain period,
> >> +	 * we use a rate limiter mechanism before making a call to the device.
> >> +	 */
> >> +	if (!__ratelimit(&migf->pre_copy_rl_state)) {
> >> +		/* Reporting no data available */
> >> +		ret = 0;
> >> +		goto done;  
> > 
> > @ret is not used by the done: goto target.  Don't we need to zero dirty
> > bytes, or account for initial bytes not being fully read yet?  
> 
> The 'dirty bytes' are actually zero as we used the below line [1] of 
> code above.
> 
> [1] struct vfio_precopy_info info = {};

Ah, missed that.
 
> However, I agree, we may better account for the 'initial bytes' which 
> potentially might not being fully read yet.
> Same can be true for returning the actual 'dirty bytes' that we may have 
> from the previous call.
> 
> So, in V2 I'll change the logic to initially set:
> u32 ctx_size = 0;
> 
> Then, will call the device to get its 'ctx_size' only if time has passed 
> according to the rate limiter.
> 
> Something as of the below.
> 
> if (__ratelimit(&migf->pre_copy_rl_state)) {
> 	ret = virtio_pci_admin_dev_parts_metadata_get(.., &ctx_size);
> 	if (ret)
> 		goto err_state_unlock;
> }
> 
>  From that point the function will proceed with its V1 flow to return 
> the actual 'initial bytes' and 'dirty_bytes' while considering the extra 
> context size from the device to be 0.

That appears correct to me.  Thanks,

Alex


