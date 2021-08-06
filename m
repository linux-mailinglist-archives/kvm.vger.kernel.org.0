Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6ED83E303F
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 22:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244895AbhHFUSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 16:18:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244840AbhHFUSG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 16:18:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628281069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AKEtsVz7WfVjpfJzqxqaNsm5zdfVw1TUqK/dikMgDyg=;
        b=OQqYZhFczGH6MYKOP8lN3nl3oacMiUftAEXLuro3l4wA0olmI5letaJw9qhkJJjVjUMby4
        RHHF8qwq2uFZLtmp1puQb/zR+hwt2j0yHAfmYZHD1ppk5PdruJLxOXu4S0ipczUENDLsQ/
        DeoMBhbaBGz3FCc5QQxtpZKCAetTu70=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-s1iCbYzqMVWLuEw3DSKwrg-1; Fri, 06 Aug 2021 16:17:48 -0400
X-MC-Unique: s1iCbYzqMVWLuEw3DSKwrg-1
Received: by mail-oi1-f197.google.com with SMTP id c6-20020aca35060000b029025c5504f461so4691891oia.22
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 13:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AKEtsVz7WfVjpfJzqxqaNsm5zdfVw1TUqK/dikMgDyg=;
        b=VDDPWO4R4urjWFjHp0c+vaHiX7LXmA78ls+2KKdsiqptZKjn3bYiEO6uUKRpCYiM3f
         VIAh8KJdc4mQNRufSTcDUKvE0+FkpyX5lzvboPAYcKaDvRQk2vjWM2vt3v/9QcESVOVa
         owIQmP2hb9zsCRmzgcCtdZt1kGL/CuK4/YJ3r+Wpv+DeT82RQ6yGRNcR+Lxs2ooAHTPo
         SAyCjVSoNQ5gtkDRffZzKgiLA9j4cj35WLHdNLu3WuhKsPlZdLN16TGTYw59Yt286BDL
         vhox8UXs8w+LkuHsCaV6G8aBwpCfn4kC4SWOqtF08Vn0rOyDjjKuZiBcynA8GhfYxRjk
         H3SA==
X-Gm-Message-State: AOAM5302bHmO5aBqdIh1FrAywYfFFr3hYiPCaTG8aW77VMGQngVVPGrF
        Brbkx5ov4AxShODErkyxA1wX7HC402WdZf2eeOeFUj+VGYFqJztEG1niZFDktPgpdH+u2vIGZ6n
        RCXAHaw/5h52F
X-Received: by 2002:a05:6808:b3c:: with SMTP id t28mr8529923oij.138.1628281067381;
        Fri, 06 Aug 2021 13:17:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwE/+radWlM0jhMSuigAQ6bd02/LEk6hSW+AqhKdTvsnB5GbjLi4CMMD+utdEDRsQXhnxTuVg==
X-Received: by 2002:a05:6808:b3c:: with SMTP id t28mr8529912oij.138.1628281067157;
        Fri, 06 Aug 2021 13:17:47 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id 7sm164527oth.69.2021.08.06.13.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 13:17:46 -0700 (PDT)
Date:   Fri, 6 Aug 2021 14:17:45 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterx@redhat.com
Subject: Re: [PATCH 3/7] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <20210806141745.1d8c3e0a.alex.williamson@redhat.com>
In-Reply-To: <20210806010418.GF1672295@nvidia.com>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
        <162818325518.1511194.1243290800645603609.stgit@omen>
        <20210806010418.GF1672295@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 Aug 2021 22:04:18 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Aug 05, 2021 at 11:07:35AM -0600, Alex Williamson wrote:
> > @@ -2281,15 +2143,13 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
> >  
> >  	vdev = container_of(device, struct vfio_pci_device, vdev);
> >  
> > -	/*
> > -	 * Locking multiple devices is prone to deadlock, runaway and
> > -	 * unwind if we hit contention.
> > -	 */
> > -	if (!vfio_pci_zap_and_vma_lock(vdev, true)) {
> > +	if (!down_write_trylock(&vdev->memory_lock)) {
> >  		vfio_device_put(device);
> >  		return -EBUSY;
> >  	}  
> 
> Now that this is simplified so much, I wonder if we can drop the
> memory_lock and just use the dev_set->lock?
> 
> That avoids the whole down_write_trylock thing and makes it much more
> understandable?

Hmm, that would make this case a lot easier, but using a mutex,
potentially shared across multiple devices, taken on every non-mmap
read/write doesn't really feel like a good trade-off when we're
currently using a per device rwsem to retain concurrency here.  Thanks,

Alex

