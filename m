Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4A91CA094
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 04:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgEHCRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 22:17:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32519 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726616AbgEHCRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 22:17:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588904221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WtjazxlEuskMF4wPNnQP3Ty5Cta06wXamFiE9VjuwNg=;
        b=Cf0mh8piFkUCVgISaaruR0DviQQ3W3E2VxzoT3X61m0+5lWjgtPqdN9bsrRGPyeYcvPpGy
        3d51BgyF0Si3Y6zU032Tb+BfMYthKVB/MRpvrHzU7ZxvJLuCoxntCJkrbjIGzpR0Z2wrzO
        o6yMIPt8lUG3b+23ce+6FhUq3eTLcpM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-YGOK0f52PsWUDGaw0c4zrg-1; Thu, 07 May 2020 22:16:59 -0400
X-MC-Unique: YGOK0f52PsWUDGaw0c4zrg-1
Received: by mail-qk1-f198.google.com with SMTP id v6so394678qkd.9
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 19:16:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WtjazxlEuskMF4wPNnQP3Ty5Cta06wXamFiE9VjuwNg=;
        b=QaHY81hpLP3sIQLOv7LtoRw9XiZJnwH6omgXdiSz9QyUdDi66OU/a5qYvYKkPr9KxK
         C3p21Qm8HWHGfvMsIwK0RxB0KmQeNVvT6+zrKK7KD1KppNoJ5ejuG3Ka0tvhG/GhiBZt
         G3Af1NMYuxdhGcCCqZ+MwL2Z8lIZRwfdQdA7LO/b6ZqUkANKGedDI8W5McoXTRZYkkxS
         m3JHLt/PfMYJJfEuiwVFloViYsa4EibuF3zzf4c8QsjUbIZlJbmxQkCPY+tdZa8YuMOO
         aKr0lzAeKPSgkcZNt6fB5gXtV9uPqv+pEXhsL/YmYVJ92yo7XmVTX7qrECmGTKlQegSG
         uB5g==
X-Gm-Message-State: AGi0PuaTofkx7Wn33BDeqh9OCyFbraUxhwPSd6jgGpw4Wx4H63k5RsD8
        3dIzAHEHg2YU53gMDi37GfJ4D2/feyRJ6RkA9wL0gnQKddcE7gO+oCX1nSj1j4f8Yuc/nYe5bfa
        Mtx5UsSdIC8J3
X-Received: by 2002:ac8:1e91:: with SMTP id c17mr513579qtm.237.1588904218796;
        Thu, 07 May 2020 19:16:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypKMCJLQFlz4Jrv1e8UQwTefpV+CtILqg45Ii+fu35tC1S+zdxR7Le6TrpKICh1tIWhWqh9sEQ==
X-Received: by 2002:ac8:1e91:: with SMTP id c17mr513566qtm.237.1588904218488;
        Thu, 07 May 2020 19:16:58 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id p68sm45146qka.56.2020.05.07.19.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 19:16:57 -0700 (PDT)
Date:   Thu, 7 May 2020 22:16:56 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH v2 2/3] vfio-pci: Fault mmaps to enable vma tracking
Message-ID: <20200508021656.GS228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871569380.15589.16950418949340311053.stgit@gimli.home>
 <20200507214744.GP228260@xz-x1>
 <20200507160334.4c029518@x1.home>
 <20200507222223.GR228260@xz-x1>
 <20200507235633.GL26002@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200507235633.GL26002@ziepe.ca>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 08:56:33PM -0300, Jason Gunthorpe wrote:
> On Thu, May 07, 2020 at 06:22:23PM -0400, Peter Xu wrote:
> > On Thu, May 07, 2020 at 04:03:34PM -0600, Alex Williamson wrote:
> > > On Thu, 7 May 2020 17:47:44 -0400
> > > Peter Xu <peterx@redhat.com> wrote:
> > > 
> > > > Hi, Alex,
> > > > 
> > > > On Tue, May 05, 2020 at 03:54:53PM -0600, Alex Williamson wrote:
> > > > > +/*
> > > > > + * Zap mmaps on open so that we can fault them in on access and therefore
> > > > > + * our vma_list only tracks mappings accessed since last zap.
> > > > > + */
> > > > > +static void vfio_pci_mmap_open(struct vm_area_struct *vma)
> > > > > +{
> > > > > +	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);  
> > > > 
> > > > A pure question: is this only a safety-belt or it is required in some known
> > > > scenarios?
> > > 
> > > It's not required.  I originally did this so that I'm not allocating a
> > > vma_list entry in a path where I can't return error, but as Jason
> > > suggested I could zap here only in the case that I do encounter that
> > > allocation fault.  However I still like consolidating the vma_list
> > > handling to the vm_ops .fault and .close callbacks and potentially we
> > > reduce the zap latency by keeping the vma_list to actual users, which
> > > we'll get to eventually anyway in the VM case as memory BARs are sized
> > > and assigned addresses.
> > 
> > Yes, I don't see much problem either on doing the vma_list maintainance only in
> > .fault() and .close().  My understandingg is that the worst case is the perf
> > critical applications (e.g. DPDK) could pre-fault these MMIO region easily
> > during setup if they want.  My question was majorly about whether the vma
> > should be guaranteed to have no mapping at all when .open() is called.  But I
> > agree with you that it's always good to have that as safety-belt anyways.
> 
> If the VMA has a mapping then that specific VMA has to be in the
> linked list.
> 
> So if the zap is skipped then the you have to allocate something and
> add to the linked list to track the VMA with mapping.
> 
> It is not a 'safety belt'

But shouldn't open() only be called when the VMA is created for a memory range?
If so, does it also mean that the address range must have not been mapped yet?

Thanks,

-- 
Peter Xu

