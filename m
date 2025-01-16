Return-Path: <kvm+bounces-35678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A07BA13FDC
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 17:52:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE3F53A3E65
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 16:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A21822CBEA;
	Thu, 16 Jan 2025 16:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BPzyMsuU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1729E137932
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737046368; cv=none; b=ctUvk0+AZr9pDC5zOhd7qZTh51HYqAgJ3GRa2/A5MtPe4x48f0MpIVSq86IpbgUfOYWJ86R6VeOl2+T2rul69wg2v6nN/r3z3Z9Sp32MGlohKsvuL90p15cXvjGjJmbkwPVxQcrOYdMUJhQOmaqOge5KqTN5B6cJfq/mtryDHGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737046368; c=relaxed/simple;
	bh=f8hkhT49y5/wWEPL1dn76NoGi1ZCb5GGkMHI0hsOAqA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M9J5PsbWCWQgv5am/d1OWXDJVEjWjuw+iPz7m7mA+SjDeTJEEZ6VNMUgL401VNdspccYxr5MrKPMB15GB1IVHT/afYC3NdGlwaHuDTZDO4H/yepdVpndbjMQXdagCiSfJ03xfRP3uiMPQ/JEFLDc+KL+vSXUb3Fk8t9NHxtmYY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BPzyMsuU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737046366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/lW37XSswNGfSg646NxTRyIT3sFX1n1Ssxcy5pA8P04=;
	b=BPzyMsuU8d8QRHL6zFP1sA3JpptwODtY+J8Ycv8Ik8GL+2NBCalIPACBY1BKY6t9ZhqCWj
	yMHZyzAnhutWSV/RtHqYjTumOmRwYQMoQ+ObkcxIgQ4FAUK2x5Vc77GeWRgwuo/G/CGWj8
	JjBOPDtF3BZ1q5ljx0qFoyiCeyeB1wc=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-ukDBOpVWMdGK2EMRX06n_Q-1; Thu, 16 Jan 2025 11:52:45 -0500
X-MC-Unique: ukDBOpVWMdGK2EMRX06n_Q-1
X-Mimecast-MFC-AGG-ID: ukDBOpVWMdGK2EMRX06n_Q
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-844df5d5edfso13796639f.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 08:52:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737046364; x=1737651164;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/lW37XSswNGfSg646NxTRyIT3sFX1n1Ssxcy5pA8P04=;
        b=MUBSKNINDykvlzZzV27sX2rxc5LZEOrPsv8//7ZSpJuJ9PWX9JqgCB6GrGLno2TXSb
         jH+QwmLEGXqgTdjyZQsN5Z00eZADvnkhyQpOriRB/Liu+TLMoIjo+kM7GeP3qB8zwOfL
         xLyx/gSpz0xKp7Wn23qTwEwPdskiOrSkKcnVdDPiMPGUObpzZVoUJorC5V/1PpGBPiB1
         uF0UpLMtxOhVtnzkQ2NzoEjD/D1j3olrkc7ZZCV6UOKEYGd/UQa18U87kyWKqQTdKTrj
         58IUblId7KzJDIuy6R1cW8ptfhIeW+7lnOCPs5TxUZ2GxUTRIEdr7LHNH036WVibUHI1
         Qeog==
X-Forwarded-Encrypted: i=1; AJvYcCUbJjO0QAzhzXGSbHtxy2NHwvPD1t0GGFJaVyOsqVMPW6cORtwqpM7dySutKcs8LTUhh4g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPk25pJY9EaATF20ABXp2lLVrQMbZ9jBvZZiId9hCQkfz4xIHV
	cpEcWsYeGutRyL44l5YhAHFrARKAZQ4j7n5e0rcAHfWGdCDP8CHyLsnfDPzB32N5ZeIArxj3gZB
	LL+VRYJKztZKfyjJRUXuQVkDRCjX39KgiOpSxLyvbTLvbeyUTu2QxdEnOkQ==
X-Gm-Gg: ASbGnct2dKrcv88RjsGz0rr+L5dpkTW1gy8VG79oYQexexFKAOxr9NC9XI+uE95ANJ8
	04Z7HzLKf6Kjrx1fys/v63iDSJK7wK4QtyNcayOltYB/TtBin6OMMHb+LkNSgykba3g83a5/mmK
	fMq9btGwgSB7N9dqNgSaKMMbD2pfP2o22sTzZAgpu5AlYaQhpNaYFNqPXhBQISjyovxXVMETT3y
	D4SdV8kO5A4JW0KHPjM1nqVaCcoNX3eKvnaozk2B5sRulMpNjseymwwOc6W
X-Received: by 2002:a05:6602:2b01:b0:844:cbd0:65bf with SMTP id ca18e2360f4ac-84ce01add9fmr864783639f.3.1737046364051;
        Thu, 16 Jan 2025 08:52:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHSHrOsX5bS3VLCbMhYfAjZgtNuxvEYnqsKnwrFQ7KCWpUcqoI7irh3qYNBdXOn2gmp3m9nqQ==
X-Received: by 2002:a05:6602:2b01:b0:844:cbd0:65bf with SMTP id ca18e2360f4ac-84ce01add9fmr864782539f.3.1737046363652;
        Thu, 16 Jan 2025 08:52:43 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea75499c59sm112042173.74.2025.01.16.08.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 08:52:43 -0800 (PST)
Date: Thu, 16 Jan 2025 11:52:28 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: Halil Pasic <pasic@linux.ibm.com>, Rorie Reyes <rreyes@linux.ibm.com>,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, hca@linux.ibm.com, borntraeger@de.ibm.com,
 agordeev@linux.ibm.com, gor@linux.ibm.com, jjherne@linux.ibm.com
Subject: Re: [PATCH v1] s390/vfio-ap: Signal eventfd when guest AP
 configuration is changed
Message-ID: <20250116115228.10eeb510.alex.williamson@redhat.com>
In-Reply-To: <89a1a029-172a-407a-aeb4-0b6228da07e5@linux.ibm.com>
References: <20250107183645.90082-1-rreyes@linux.ibm.com>
	<20250114150540.64405f27.alex.williamson@redhat.com>
	<5d6402ce-38bd-4632-927e-2551fdd01dbe@linux.ibm.com>
	<20250116011746.20cf941c.pasic@linux.ibm.com>
	<89a1a029-172a-407a-aeb4-0b6228da07e5@linux.ibm.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jan 2025 10:38:41 -0500
Anthony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 1/15/25 7:17 PM, Halil Pasic wrote:
> > On Wed, 15 Jan 2025 14:35:02 -0500
> > Anthony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >>>> +static int vfio_ap_set_cfg_change_irq(struct ap_matrix_mdev *matrix_mdev, unsigned long arg)
> >>>> +{
> >>>> +	s32 fd;
> >>>> +	void __user *data;
> >>>> +	unsigned long minsz;
> >>>> +	struct eventfd_ctx *cfg_chg_trigger;
> >>>> +
> >>>> +	minsz = offsetofend(struct vfio_irq_set, count);
> >>>> +	data = (void __user *)(arg + minsz);
> >>>> +
> >>>> +	if (get_user(fd, (s32 __user *)data))
> >>>> +		return -EFAULT;
> >>>> +
> >>>> +	if (fd == -1) {
> >>>> +		if (matrix_mdev->cfg_chg_trigger)
> >>>> +			eventfd_ctx_put(matrix_mdev->cfg_chg_trigger);
> >>>> +		matrix_mdev->cfg_chg_trigger = NULL;
> >>>> +	} else if (fd >= 0) {
> >>>> +		cfg_chg_trigger = eventfd_ctx_fdget(fd);
> >>>> +		if (IS_ERR(cfg_chg_trigger))
> >>>> +			return PTR_ERR(cfg_chg_trigger);
> >>>> +
> >>>> +		if (matrix_mdev->cfg_chg_trigger)
> >>>> +			eventfd_ctx_put(matrix_mdev->cfg_chg_trigger);
> >>>> +
> >>>> +		matrix_mdev->cfg_chg_trigger = cfg_chg_trigger;
> >>>> +	} else {
> >>>> +		return -EINVAL;
> >>>> +	}
> >>>> +
> >>>> +	return 0;
> >>>> +}  
> >>> How does this guard against a use after free, such as the eventfd being
> >>> disabled or swapped concurrent to a config change?  Thanks,
> >>>
> >>> Alex  
> >> Hi Alex. I spent a great deal of time today trying to figure out exactly
> >> what
> >> you are asking here; reading about eventfd and digging through code.
> >> I looked at other places where eventfd is used to set up communication
> >> of events targetting a vfio device from KVM to userspace (e.g.,
> >> hw/vfio/ccw.c)
> >> and do not find anything much different than what is done here. In fact,
> >> this code looks identical to the code that sets up an eventfd for the
> >> VFIO_AP_REQ_IRQ_INDEX.
> >>
> >> Maybe you can explain how an eventfd is disabled or swapped, or maybe
> >> explain how we can guard against its use after free. Thanks.  
> > Maybe I will try! The value of matrix_mdev->cfg_chg_trigger is used in:
> > * vfio_ap_set_cfg_change_irq() (rw, with matrix_dev->mdevs_lock)
> > * signal_guest_ap_cfg_changed()(r, takes no locks itself, )
> >    * called by vfio_ap_mdev_update_guest_apcb()
> >      * called at a bunch of places but AFAICT always with
> >        matrix_dev->mdevs_lock held
> >    * called by vfio_ap_mdev_unset_kvm() (with matrix_dev->mdevs_lock held
> >      via get_update_locks_for_kvm())
> > * vfio_ap_mdev_probe() (w, assigns NULL to it)
> >
> > If vfio_ap_set_cfg_change_irq() could change/destroy
> > matrix_mdev->cfg_chg_trigger while another thread of execution
> > is using it e.g. with signal_guest_ap_cfg_changed() that would be a
> > possible UAF and thus BAD.
> >
> > Now AFAICT matrix_mdev->cfg_chg_trigger is protected by
> > matrix_dev->mdevs_lock on each access except for in vfio_ap_mdev_probe()
> > which is AFAIK just an initialization in a safe state where we are
> > guaranteed to have exclusive access.
> >
> > The eventfd is swapped and disabled in vfio_ap_set_cfg_change_irq() with
> > userspace supplying a new valid fd or -1 respectively.
> >
> > Tony does that answer your question to Alex?
> >
> > Alex, does the above answer your question on what guards against UAF (the
> > short answer is: matrix_dev->mdevs_lock)?  

Yes, that answers my question, thanks for untangling it.  We might
consider a lockdep_assert_held() in the new
signal_guest_ap_cfg_changed() since it does get called from a variety
of paths and we need that lock to prevent the UAF.

> I agree that the matrix_dev->mdevs_lock does prevent changes to
> matrix_mdev->cfg_chg_trigger while it is being accessed by the
> vfio_ap device driver. My confusion arises from my interpretation of
> Alex's question; it seemed to me that he was talking its use outside
> of the vfio_ap driver and how to guard against that.

Nope, Halil zeroed in on the UAF possibility that concerned me.  Thanks,

Alex


