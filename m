Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680911F66EF
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 13:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgFKLlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 07:41:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23583 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726407AbgFKLlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 07:41:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591875679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N+hOhqTQBMwp4AmRlzbOHmDQ8McxlMKMKGqAqlXUfCE=;
        b=CdoDIF+KrNGLpI3MM+KrTsH4w1jjysPL1hgIWrKYkGgqYg0rpc1AfrGoClBWNlU/vza56w
        WgX0J7vgrUeneyOa3oPrYMdY73p1ftRX0ytn/uVwemitHjywqpci6ERPXGeVESL7f8tXi/
        dFBQcG8pIRrFkeJvV3T9cNF0Cl9RAM4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-Y9CrdMwCO-GNyPA93I0Dcw-1; Thu, 11 Jun 2020 07:41:18 -0400
X-MC-Unique: Y9CrdMwCO-GNyPA93I0Dcw-1
Received: by mail-wm1-f70.google.com with SMTP id a18so1021369wmm.3
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 04:41:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N+hOhqTQBMwp4AmRlzbOHmDQ8McxlMKMKGqAqlXUfCE=;
        b=nSerx9RMk/5eS2aFw5OBSXu0pllsh7quSgJUk6x9nIiCStNlDaHfl+iwqk6VfouUYm
         FRBO4SfSYBg2vdAD4kZBJDKKepvvVEU3Fg98Mb/9QSMogiXzvX+p5TIJxk5r36ETgGQd
         ZF79gr9uovAthLfEFikDnjBsMDUzmjECcZ7nuIWJbxGr+43SvcIKXRnNMfBeYjcqi1hD
         dGbzhDL8qg0NOUtaPbrNcYlBrOskiC/ITON1UeIIFwKXcPVa0CfJbO3VIc4BQtGw0ndH
         vklb911Wf1+REJ5uPb+vF99smE/h+KEafsl8h8RH485y/FghcbzFhma00yova668RoIR
         6D2A==
X-Gm-Message-State: AOAM533YamV56MpQMgoxZsV6EjXzeUrcpBku79MPn0k3+MKyfM+3ZhBV
        AxhU2VAzpOIsgwxOGHwQhNsSabqWl/lgSQiIkNnKL4orpntlj4jH0PKtPq6ZbgJjyfR49h6efuZ
        XNkEI97pQ/Ze7
X-Received: by 2002:a7b:c40e:: with SMTP id k14mr8259484wmi.59.1591875676952;
        Thu, 11 Jun 2020 04:41:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkpzm1AHXvvYbOTpCzrh8Us+16Cfza99czVInZxHNWwmzLaKoW7HIE1UmlxalWp27taecVCA==
X-Received: by 2002:a7b:c40e:: with SMTP id k14mr8259469wmi.59.1591875676754;
        Thu, 11 Jun 2020 04:41:16 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id g3sm5069764wrb.46.2020.06.11.04.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:41:16 -0700 (PDT)
Date:   Thu, 11 Jun 2020 07:41:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        teawater <teawaterz@linux.alibaba.com>
Subject: Re: [PATCH v1] virtio-mem: add memory via add_memory_driver_managed()
Message-ID: <20200611073943-mutt-send-email-mst@kernel.org>
References: <20200611071744-mutt-send-email-mst@kernel.org>
 <613382D2-5F4D-4A32-AC8E-E1D03240036F@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <613382D2-5F4D-4A32-AC8E-E1D03240036F@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 01:33:04PM +0200, David Hildenbrand wrote:
> 
> 
>     Am 11.06.2020 um 13:18 schrieb Michael S. Tsirkin <mst@redhat.com>:
> 
> 
>     On Thu, Jun 11, 2020 at 01:00:24PM +0200, David Hildenbrand wrote:
> 
>                 I'd like to have this patch in 5.8, with the initial merge of
>                 virtio-mem
> 
>                 if possible (so the user space representation of virtio-mem
>                 added memory
> 
>                 resources won't change anymore).
> 
>            
> 
>             So my plan is to rebase on top of -rc1 and merge this for rc2 then.
> 
>             I don't like rebase on top of tip as the results are sometimes kind
>             of
> 
>             random.
> 
>        
> 
>         Right, I just wanted to get this out early so we can discuss how to
>         proceed.
> 
>        
> 
>             And let's add a Fixes: tag as well, this way people will remember
>             to
> 
>             pick this.
> 
>             Makes sense?
> 
>        
> 
>         Yes, it's somehow a fix (for kexec). So
> 
>        
> 
>         Fixes: 5f1f79bbc9e26 ("virtio-mem: Paravirtualized memory hotplug")
> 
>        
> 
>         I can respin after -rc1 with the commit id fixed as noted by Pankaj.
> 
>         Just let me know what you prefer.
> 
>        
> 
>         Thanks!
> 
>    
>     Some once this commit is in Linus' tree, please ping me.
> 
> 
> It already is as mentioned, only the id was wrong.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=
> 7b7b27214bba1966772f9213cd2d8e5d67f8487f

OK I pushed this into next based on tip. Let's see what happens.


> 
>    
> 
>         --
> 
>         Thanks,
> 
>        
> 
>         David / dhildenb
> 
>    
> 

