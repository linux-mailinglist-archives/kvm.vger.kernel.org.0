Return-Path: <kvm+bounces-42784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B09BA7CEC5
	for <lists+kvm@lfdr.de>; Sun,  6 Apr 2025 17:40:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00C8F16885A
	for <lists+kvm@lfdr.de>; Sun,  6 Apr 2025 15:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0BE221542;
	Sun,  6 Apr 2025 15:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H2hhBRMn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1557C22068F
	for <kvm@vger.kernel.org>; Sun,  6 Apr 2025 15:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743954045; cv=none; b=c2smi9tuWUTsd51O7hX5j6/I5eBDVZeqHi+AXW2pgfGrUavPIOhCBkRMrYTdD5tyZivSVAc+jKgZXpuwfpPpYdpMy+h09TSMAudM1T9ofICtWuScAiAylFuKrN5/JSSxhkoA9e0aOHjfoENdSCGs6M5ro47OpQlsv6xJg6efHHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743954045; c=relaxed/simple;
	bh=QPQgC7kvXKpnKQQ0zZIdhCNfWb/+UL0O59Sg480zvCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FjiN3quVdQkKtXS+fwR3EFg8v2/JophoXmOilrxRhU/XkWldZeU+31P9xiICaVxv+Xijle1FNVcOVRRaCBgxl1fcnHQ+/Xl8YTpOwnTrqgPssdaWQEnOorSRmd0aEMtoRk+mqgu6Pww/IIAATisH/JOyggUcqKSPfl4dodm7y0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H2hhBRMn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743954041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vB1cPTM6kQM0IccundSU9yqiAslJfta8o011pO2Z12I=;
	b=H2hhBRMn0xHNCWxqXR0nIdyRw7Co466K6daqZ7pjuPejbyjnsrPKooMtYO5mlElEIcAIa/
	cuEWeu16Pj+lk/mQaMQ6gKfjktvDLi8Bcfx4b/Kz4hOmwR6H2Jinn7WyuM1ZbMF8aZCT/T
	LjYQclC68d66WBvFpYCqn2duRpjx0KI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-X5T7CIMVO0CA7-nUIo3EWw-1; Sun, 06 Apr 2025 11:40:40 -0400
X-MC-Unique: X5T7CIMVO0CA7-nUIo3EWw-1
X-Mimecast-MFC-AGG-ID: X5T7CIMVO0CA7-nUIo3EWw_1743954039
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43e9a3d2977so27817795e9.1
        for <kvm@vger.kernel.org>; Sun, 06 Apr 2025 08:40:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743954039; x=1744558839;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vB1cPTM6kQM0IccundSU9yqiAslJfta8o011pO2Z12I=;
        b=waHflJHJtUy3sW/k8CeBI5WSu/EtWZhuq7adBOyTlCjDWeLxNvIq8k3SX9GsnPfa1c
         UxSX16/fRhH5dyWkph+smf+wipr8bACdx/XgUxF0x+HUkoQHSegOuoCefEXRu7czf5yv
         SHwzH71+GB/kBAX49BMtziloS6HGCFBhchOM5N8WZBWxEBKxy5StNmdPIG+GsJjqrOk+
         PFGOfSAZCa2OJ+sH/WDTzI7w371MLuDO02NyxUuHJQp+gsCiDOjZU3m9WZ01NnSLdoXQ
         KHxdMtwb1TEIrGaxtRctCiojkJ76JugTfQipuJ/FO+xUGQnRWOQXZutyNCEhzEZsaa97
         6/sw==
X-Forwarded-Encrypted: i=1; AJvYcCVZTM1jplJ8CWy+Neh0ZnVrFlBLnOcWAGKTxYRBW/7lx9SsF2H9q0/0POG0Ir/5AsfEo7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5j9B/ULbYlSO8Ic7FROH52PjCZQL0V7yHt01W34lsXRkXW1tL
	YYwfHx4/+EcOps5RY2Zwk9t0CAxtywfMXPKfDf1Q27m9WnnTaPDc6vB4QJN7WzIMgJAw+Jr9+aK
	ZZKJUjXIn0vUAj/ihgl2WteYJaDaI6MJp5kXstXqMzqep8n4v8K0FF9HQOA==
X-Gm-Gg: ASbGnctS5+FE2Og7EO5Lw34WAG0Pd6hy2g8Yaeb3EggXL6pmWSfybt5f1sn8GYuZ6VL
	xRUHtTGxKVaQDj/I+HI/8SdA640tP12+O7PjCgX5qg8syECsMmoJ1Pr9qRLREtfvycDGQTl4dmg
	5p2SsgCgzwvaz472n5NkQioueSeohtBgnNgOgkM7hJqUi7ylgtAJ19rwl82CvZKjE08JzdbbjI3
	5h16oFcvnRwZCiDgeXm+s8kSnfDwHzJ4sP+r4iEKVkcwHvjk79ItlWOr4uQuq04Ksy7QalmT3NW
	SOE9sRKTSA==
X-Received: by 2002:a05:600c:3596:b0:43c:fe5e:f03b with SMTP id 5b1f17b1804b1-43ed0db35d6mr95618285e9.30.1743954038949;
        Sun, 06 Apr 2025 08:40:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFN/IYHI1ly9zqzd/yipZ2IxNmlWWEkP3lQh8Sl8IvCxIbI13KHnpOGc/44mG1AnIZVtDsnLw==
X-Received: by 2002:a05:600c:3596:b0:43c:fe5e:f03b with SMTP id 5b1f17b1804b1-43ed0db35d6mr95618065e9.30.1743954038489;
        Sun, 06 Apr 2025 08:40:38 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec163107csm108121185e9.3.2025.04.06.08.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Apr 2025 08:40:36 -0700 (PDT)
Date: Sun, 6 Apr 2025 11:40:33 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Halil Pasic <pasic@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
	Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
	Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250406113926-mutt-send-email-mst@kernel.org>
References: <20250402203621.940090-1-david@redhat.com>
 <20250403161836.7fe9fea5.pasic@linux.ibm.com>
 <e2936e2f-022c-44ee-bb04-f07045ee2114@redhat.com>
 <20250404063619.0fa60a41.pasic@linux.ibm.com>
 <4a33daa3-7415-411e-a491-07635e3cfdc4@redhat.com>
 <d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>

On Fri, Apr 04, 2025 at 12:55:09PM +0200, David Hildenbrand wrote:
> On 04.04.25 12:00, David Hildenbrand wrote:
> > On 04.04.25 06:36, Halil Pasic wrote:
> > > On Thu, 3 Apr 2025 16:28:31 +0200
> > > David Hildenbrand <david@redhat.com> wrote:
> > > 
> > > > > Sorry I have to have a look at that discussion. Maybe it will answer
> > > > > some my questions.
> > > > 
> > > > Yes, I think so.
> > > > 
> > > > > > Let's fix it without affecting existing setups for now by properly
> > > > > > ignoring the non-existing queues, so the indicator bits will match
> > > > > > the queue indexes.
> > > > > 
> > > > > Just one question. My understanding is that the crux is that Linux
> > > > > and QEMU (or the driver and the device) disagree at which index
> > > > > reporting_vq is actually sitting. Is that right?
> > > > 
> > > > I thought I made it clear: this is only about the airq indicator bit.
> > > > That's where both disagree.
> > > > 
> > > > Not the actual queue index (see above).
> > > 
> > > I did some more research including having a look at that discussion. Let
> > > me try to sum up how did we end up here.
> > 
> > Let me add some more details after digging as well:
> > 
> > > 
> > > Before commit a229989d975e ("virtio: don't allocate vqs when names[i] =
> > > NULL") the kernel behavior used to be in spec, but QEMU and possibly
> > > other hypervisor were out of spec and things did not work.
> > 
> > It all started with VIRTIO_BALLOON_F_FREE_PAGE_HINT. Before that,
> > we only had the single optional VIRTIO_BALLOON_F_STATS_VQ queue at the very
> > end. So there was no possibility for holes "in-between".
> > 
> > In the Linux driver, we created the stats queue only if the feature bit
> > VIRTIO_BALLOON_F_STATS_VQ was actually around:
> > 
> > 	nvqs = virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ) ? 3 : 2;
> > 	err = virtio_find_vqs(vb->vdev, nvqs, vqs, callbacks, names, NULL);
> > 
> > That changed with VIRTIO_BALLOON_F_FREE_PAGE_HINT, because we would
> > unconditionally create 4 queues. QEMU always supported the first 3 queues
> > unconditionally, but old QEMU did obviously not support the (new)
> > VIRTIO_BALLOON_F_FREE_PAGE_HINT queue.
> > 
> > 390x didn't particularly like getting queried for non-existing
> > queues. [1] So the fix was not for a hypervisor that was out of spec, but
> > because quering non-existing queues didn't work.
> > 
> > The fix implied that if VIRTIO_BALLOON_F_STATS_VQ is missing, suddenly the queue
> > index of VIRTIO_BALLOON_F_FREE_PAGE_HINT changed as well.
> > 
> > Again, as QEMU always implemented the 3 first queues unconditionally, this was
> > not a problem.
> > 
> > [1] https://lore.kernel.org/all/c6746307-fae5-7652-af8d-19f560fc31d9@de.ibm.com/#t
> > 
> > > 
> > > Possibly because of the complexity of fixing the hypervisor(s) commit
> > > a229989d975e ("virtio: don't allocate vqs when names[i] = NULL") opted
> > > for changing the guest side so that it does not fit the spec but fits
> > > the hypervisor(s). It unfortunately also broke notifiers (for the with
> > > holes) scenario for virtio-ccw only.
> > 
> > Yes, it broke the notifiers.
> > 
> > But note that everything was in spec at that point, because we only documented
> > "free_page_vq == 3" in the spec *2 years later*, in 2020:
> > 
> > commit 38448268eba0c105200d131c3f7f660129a4d673
> > Author: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > Date:   Tue Aug 25 07:45:02 2020 -0700
> > 
> >       content: Document balloon feature free page hints
> >       Free page hints allow the balloon driver to provide information on what
> >       pages are not currently in use so that we can avoid the cost of copying
> >       them in migration scenarios. Add a feature description for free page hints
> >       describing basic functioning and requirements.
> > At that point, what we documented in the spec *did not match reality* in
> > Linux. QEMU was fully compatible, because VIRTIO_BALLOON_F_STATS_VQ is
> > unconditionally set.
> > 
> > 
> > QEMU and Linux kept using that queue index assignment model, and the spec
> > was wrong (out of sync?) at that point. The spec got more wrong with
> > 
> > commit d917d4a8d552c003e046b0e3b1b529d98f7e695b
> > Author: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > Date:   Tue Aug 25 07:45:17 2020 -0700
> > 
> >       content: Document balloon feature free page reporting
> >       Free page reporting is a feature that allows the guest to proactively
> >       report unused pages to the host. By making use of this feature is is
> >       possible to reduce the overall memory footprint of the guest in cases where
> >       some significant portion of the memory is idle. Add documentation for the
> >       free page reporting feature describing the functionality and requirements.
> > 
> > Where we documented VIRTIO_BALLOON_F_REPORTING after the changes were added to
> > QEMU+Linux implementation, so the spec did not reflect reality.
> > 
> > I'll note also cloud-hypervisor [2] today follows that model.
> > 
> > In particular, it *only* supports VIRTIO_BALLOON_F_REPORTING, turning
> > the queue index of VIRTIO_BALLOON_F_REPORTING into *2* instead of documented
> > in the spec to be *4*.
> > 
> > So in reality, we can see VIRTIO_BALLOON_F_REPORTING to be either 2/3/4, depending
> > on the availability of the other two features/queues.
> > 
> > [2] https://github.com/cloud-hypervisor/cloud-hypervisor/blob/main/virtio-devices/src/balloon.rs
> > 
> > 
> > > 
> > > Now we had another look at this, and have concluded that fixing the
> > > hypervisor(s) and fixing the kernel, and making sure that the fixed
> > > kernel can tolerate the old broken hypervisor(s) is way to complicated
> > > if possible at all. So we decided to give the spec a reality check and
> > > fix the notifier bit assignment for virtio-ccw which is broken beyond
> > > doubt if we accept that the correct virtqueue index is the one that the
> > > hypervisor(s) use and not the one that the spec says they should use.
> > 
> > In case of virtio-balloon, it's unfortunate that it went that way, but the
> > spec simply did not / does not reflect reality when it was added to the spec.
> > 
> > > 
> > > With the spec fixed, the whole notion of "holes" will be something that
> > > does not make sense any more. With that the merit of the kernel interface
> > > virtio_find_vqs() supporting "holes" is quite questionable. Now we need
> > > it because the drivers within the Linux kernel still think of the queues
> > > in terms of the current spec, i.e. they try to have the "holes" as
> > > mandated by the spec, and the duty of making it work with the broken
> > > device implementations falls to the transports.
> > > 
> > 
> > Right, the "holes" only exist in the input array.
> > 
> > > Under the assumption that the spec is indeed going to be fixed:
> 
> For virito-balloon, we should probably do the following:
> 
> From 38e340c2bb53c2a7cc7c675f5dfdd44ecf7701d9 Mon Sep 17 00:00:00 2001
> From: David Hildenbrand <david@redhat.com>
> Date: Fri, 4 Apr 2025 12:53:16 +0200
> Subject: [PATCH] virtio-balloon: Fix queue index assignment for
>  non-existing queues
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  device-types/balloon/description.tex | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/device-types/balloon/description.tex b/device-types/balloon/description.tex
> index a1d9603..a7396ff 100644
> --- a/device-types/balloon/description.tex
> +++ b/device-types/balloon/description.tex
> @@ -16,6 +16,21 @@ \subsection{Device ID}\label{sec:Device Types / Memory Balloon Device / Device I
>    5
>  \subsection{Virtqueues}\label{sec:Device Types / Memory Balloon Device / Virtqueues}
> +
> +\begin{description}
> +\item[inflateq] Exists unconditionally.
> +\item[deflateq] Exists unconditionally.
> +\item[statsq] Only exists if VIRTIO_BALLOON_F_STATS_VQ is set.
> +\item[free_page_vq] Only exists if VIRTIO_BALLOON_F_FREE_PAGE_HINT is set.
> +\item[reporting_vq] Only exists if VIRTIO_BALLOON_F_PAGE_REPORTING is set.
> +\end{description}
> +
> +\begin{note}
> +Virtqueue indexes are assigned sequentially for existing queues, starting
> +with index 0; consequently, if a virtqueue does not exist, it does not get
> +an index assigned. Assuming all virtqueues exist for a device, the indexes
> +are:
> +
>  \begin{description}
>  \item[0] inflateq
>  \item[1] deflateq
> @@ -23,12 +38,7 @@ \subsection{Virtqueues}\label{sec:Device Types / Memory Balloon Device / Virtque
>  \item[3] free_page_vq
>  \item[4] reporting_vq
>  \end{description}
> -
> -  statsq only exists if VIRTIO_BALLOON_F_STATS_VQ is set.
> -
> -  free_page_vq only exists if VIRTIO_BALLOON_F_FREE_PAGE_HINT is set.
> -
> -  reporting_vq only exists if VIRTIO_BALLOON_F_PAGE_REPORTING is set.
> +\end{note}
>  \subsection{Feature bits}\label{sec:Device Types / Memory Balloon Device / Feature bits}
>  \begin{description}
> -- 
> 2.48.1
> 
> 
> If something along these lines sounds reasonable, I can send a proper patch to the
> proper audience.


Indeed, but do we want to add a note about previous spec versions
saying something different? Maybe, with a hint how devices following
old spec can be detected?



> -- 
> Cheers,
> 
> David / dhildenb


