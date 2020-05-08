Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351FA1CB1C7
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 16:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgEHO0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 10:26:50 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60478 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHO0u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 10:26:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588948007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DuO0vNtsS3Ai6Iu/sm9N0Q4cXHWfwDw3fR4P2VfxXP0=;
        b=ChwwQ4Rb4sqrA1whAL1+biPNNvryqv53ZhlKxtDCihv8Gpx5B5syBr4vBrRnQdLm9aigEc
        dA3dk6ysQN9FfUdabovt240brbzbn8fV33cHcUk9UXjgoymrkioYcB3V1rHOZohFo2SXd3
        d+SornP0Xyq4ftERTT+iRalig+svavg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-HscAEk_9PrSjLAW0DC2QTQ-1; Fri, 08 May 2020 10:26:46 -0400
X-MC-Unique: HscAEk_9PrSjLAW0DC2QTQ-1
Received: by mail-qv1-f69.google.com with SMTP id d4so1912093qva.16
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 07:26:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DuO0vNtsS3Ai6Iu/sm9N0Q4cXHWfwDw3fR4P2VfxXP0=;
        b=YjP2i7gTGpUIOQkSnhOTpCgijPyuybAZivF1dy+EgPox/kMcM9zFBDVkQCkCFeIkHC
         DRiEOMYvhMnXuVVcL6AeXq0PnVMvx3tXPQZUQD4iQdqMDbsv3mLA/Ajs9yDa99QQ99VC
         verUr+LpEoAopY5uaSc6QK8TOcYAfaqZxVw5ICFv23I5tIy7HUno6Af+FVZI0YABh6pH
         Zomg0CgBq+ukb5WiuQGZDlKpaHYtMbYWkgU1m9Rb2QduZ3mZchnmvhu/up0ojVgGY2eV
         vHz0jZOJ2IIF9jVR11ArtyXnYstP5Gf2AyACiW6kYS65KsMUy48HM2y9ScKvLidtusOv
         ZxyA==
X-Gm-Message-State: AGi0PuYiD1He1sq8vJuC3awMOVyWkin5NZwPsp6Q0tzCK+skThvDytqk
        L+HY9kW7tJMZsCs06vqTliNp5e6qpEzPBuxc6KCtad5JNAR7OpkJCEKxb/P01p90jtlpH36WvVw
        vWTR/a/wNpOmx
X-Received: by 2002:a05:620a:1521:: with SMTP id n1mr3118618qkk.430.1588948005719;
        Fri, 08 May 2020 07:26:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypJSgyng3KtsyB/udDtwqpd1ed/4L8gs4yt5YFrDL3RVW6ECZZYePDmip08rhqgqqwJKH7MNxw==
X-Received: by 2002:a05:620a:1521:: with SMTP id n1mr3118588qkk.430.1588948005360;
        Fri, 08 May 2020 07:26:45 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 19sm1288639qks.8.2020.05.08.07.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 07:26:43 -0700 (PDT)
Date:   Fri, 8 May 2020 10:26:42 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH v2 2/3] vfio-pci: Fault mmaps to enable vma tracking
Message-ID: <20200508142642.GW228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871569380.15589.16950418949340311053.stgit@gimli.home>
 <20200507214744.GP228260@xz-x1>
 <20200507160334.4c029518@x1.home>
 <20200507222223.GR228260@xz-x1>
 <20200507235633.GL26002@ziepe.ca>
 <20200508021656.GS228260@xz-x1>
 <20200508120801.GN26002@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200508120801.GN26002@ziepe.ca>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 08, 2020 at 09:08:01AM -0300, Jason Gunthorpe wrote:
> On Thu, May 07, 2020 at 10:16:56PM -0400, Peter Xu wrote:
> > On Thu, May 07, 2020 at 08:56:33PM -0300, Jason Gunthorpe wrote:
> > > On Thu, May 07, 2020 at 06:22:23PM -0400, Peter Xu wrote:
> > > > On Thu, May 07, 2020 at 04:03:34PM -0600, Alex Williamson wrote:
> > > > > On Thu, 7 May 2020 17:47:44 -0400
> > > > > Peter Xu <peterx@redhat.com> wrote:
> > > > > 
> > > > > > Hi, Alex,
> > > > > > 
> > > > > > On Tue, May 05, 2020 at 03:54:53PM -0600, Alex Williamson wrote:
> > > > > > > +/*
> > > > > > > + * Zap mmaps on open so that we can fault them in on access and therefore
> > > > > > > + * our vma_list only tracks mappings accessed since last zap.
> > > > > > > + */
> > > > > > > +static void vfio_pci_mmap_open(struct vm_area_struct *vma)
> > > > > > > +{
> > > > > > > +	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);  
> > > > > > 
> > > > > > A pure question: is this only a safety-belt or it is required in some known
> > > > > > scenarios?
> > > > > 
> > > > > It's not required.  I originally did this so that I'm not allocating a
> > > > > vma_list entry in a path where I can't return error, but as Jason
> > > > > suggested I could zap here only in the case that I do encounter that
> > > > > allocation fault.  However I still like consolidating the vma_list
> > > > > handling to the vm_ops .fault and .close callbacks and potentially we
> > > > > reduce the zap latency by keeping the vma_list to actual users, which
> > > > > we'll get to eventually anyway in the VM case as memory BARs are sized
> > > > > and assigned addresses.
> > > > 
> > > > Yes, I don't see much problem either on doing the vma_list maintainance only in
> > > > .fault() and .close().  My understandingg is that the worst case is the perf
> > > > critical applications (e.g. DPDK) could pre-fault these MMIO region easily
> > > > during setup if they want.  My question was majorly about whether the vma
> > > > should be guaranteed to have no mapping at all when .open() is called.  But I
> > > > agree with you that it's always good to have that as safety-belt anyways.
> > > 
> > > If the VMA has a mapping then that specific VMA has to be in the
> > > linked list.
> > > 
> > > So if the zap is skipped then the you have to allocate something and
> > > add to the linked list to track the VMA with mapping.
> > > 
> > > It is not a 'safety belt'
> > 
> > But shouldn't open() only be called when the VMA is created for a memory range?
> > If so, does it also mean that the address range must have not been mapped yet?
> 
> open is called whenever a VMA is copied, I don't think it is called
> when the VMA is first created?

Ah I think you're right. I misunderstood open() which I thought should be
always pairing with close(), but it seems not.  Thanks,

-- 
Peter Xu

