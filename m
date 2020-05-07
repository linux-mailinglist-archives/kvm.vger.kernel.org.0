Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A811C9E64
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 00:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgEGWWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 18:22:31 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34877 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726792AbgEGWWa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 18:22:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588890148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VrCaRnveWzqCUdGFPO9163Kj4SQtWQk9E23zb+Vye0g=;
        b=PX02cvA9y1BTZbf4ZCvfLRfPrA/SQN0Q6ILbyJsfYfVo6p1nuHX33L4Zg3XSSgGbHFDbvf
        D0FnfO1sa628grwcl4wgfOmrfPQouI5sfYxDt9MDenYLoH6YmfiQshQZcdKc6fczmGX7Nk
        k/HWuNUXa/tnDMlyWGvIl8/wA1K1m8A=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-P_RqwC4WNLKRbRsdgcuj9A-1; Thu, 07 May 2020 18:22:27 -0400
X-MC-Unique: P_RqwC4WNLKRbRsdgcuj9A-1
Received: by mail-qv1-f72.google.com with SMTP id dh14so7411606qvb.4
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 15:22:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VrCaRnveWzqCUdGFPO9163Kj4SQtWQk9E23zb+Vye0g=;
        b=Os7lPUVFEs59f+i+XnpGcsv1ZSNQbpiWKcZxMhxO52XC+ejsBKq0yfoqxXQe7H1DNl
         tNri8KtvG9YJaX8NieC4VaMQ47YyVOjKb9sybfXAq6a6E0doX9HGbElKPSqXoUaHobII
         Chr38xskNxX2E0wShczk69L4j1xlGhwgpaJeTpNdjwKsWhDwVik43Z/4S65VlR+MMjQv
         hSsHDIbM8+Qy0UgAmsAU8cEg5YWc82Z9fvIuqooQ5Nu0nT+1Cl/oOFlq4Lf5sOSsc39h
         Lq2FoEwH3Ttyl6tKoZ5q9Bqo0Zkt/GBqRFV3tduFF1y1HwSJ44QMfVTcNcw0xt2KCYaf
         5J1Q==
X-Gm-Message-State: AGi0PubScFW0ETmkKCE0yKpgPn3NuLqijTx5pquB6dP50UkzUr+rFPFT
        gw7hWgUHi/+mczD6N6cydsH2BUCVVOxVwBu7YWhxicrHirgtn0kBicRN6RTrcaPm93LsXj0daEV
        K5G8YWpHPM0Rj
X-Received: by 2002:a37:6506:: with SMTP id z6mr17528011qkb.246.1588890146290;
        Thu, 07 May 2020 15:22:26 -0700 (PDT)
X-Google-Smtp-Source: APiQypJTQTsmMRai3gKYHqoSOSsZvO38PckI9bGxFINKOwTWsdXRocbOFie6ARImAo10Fpzu1f/nJQ==
X-Received: by 2002:a37:6506:: with SMTP id z6mr17527990qkb.246.1588890145939;
        Thu, 07 May 2020 15:22:25 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id q130sm5202185qke.80.2020.05.07.15.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 15:22:25 -0700 (PDT)
Date:   Thu, 7 May 2020 18:22:23 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca
Subject: Re: [PATCH v2 2/3] vfio-pci: Fault mmaps to enable vma tracking
Message-ID: <20200507222223.GR228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871569380.15589.16950418949340311053.stgit@gimli.home>
 <20200507214744.GP228260@xz-x1>
 <20200507160334.4c029518@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200507160334.4c029518@x1.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 04:03:34PM -0600, Alex Williamson wrote:
> On Thu, 7 May 2020 17:47:44 -0400
> Peter Xu <peterx@redhat.com> wrote:
> 
> > Hi, Alex,
> > 
> > On Tue, May 05, 2020 at 03:54:53PM -0600, Alex Williamson wrote:
> > > +/*
> > > + * Zap mmaps on open so that we can fault them in on access and therefore
> > > + * our vma_list only tracks mappings accessed since last zap.
> > > + */
> > > +static void vfio_pci_mmap_open(struct vm_area_struct *vma)
> > > +{
> > > +	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);  
> > 
> > A pure question: is this only a safety-belt or it is required in some known
> > scenarios?
> 
> It's not required.  I originally did this so that I'm not allocating a
> vma_list entry in a path where I can't return error, but as Jason
> suggested I could zap here only in the case that I do encounter that
> allocation fault.  However I still like consolidating the vma_list
> handling to the vm_ops .fault and .close callbacks and potentially we
> reduce the zap latency by keeping the vma_list to actual users, which
> we'll get to eventually anyway in the VM case as memory BARs are sized
> and assigned addresses.

Yes, I don't see much problem either on doing the vma_list maintainance only in
.fault() and .close().  My understandingg is that the worst case is the perf
critical applications (e.g. DPDK) could pre-fault these MMIO region easily
during setup if they want.  My question was majorly about whether the vma
should be guaranteed to have no mapping at all when .open() is called.  But I
agree with you that it's always good to have that as safety-belt anyways.

Thanks!

-- 
Peter Xu

