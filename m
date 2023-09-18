Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F177A563B
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 01:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjIRXho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 19:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjIRXhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 19:37:42 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5755F97
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 16:37:37 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-412137ae07aso31493401cf.2
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 16:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695080256; x=1695685056; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WnuAQjafo4kC6lltDk9NFMHIoXmaRJB2ByVDtL0sp2g=;
        b=AC8RRGIoI88WRFlirO+mRdZr1/Hkw7YoBqdRGjxaYE4TOZ5VCj2yxVVUI8nkGDsnrV
         me3S42dW6uVZDkJtr0sZAgou2QZ2wf9n4vYYpbfqtRU9HLmqjruz76zbmZG8gfTEYx+r
         mvOFczvVon16xQLasFZZ+ae9JW8JcKnCN4pxUkvMToPb9iF+a9qbELk30daNcYAK3WEL
         t81HogPSRUajDAv4wsE19QwlhXg6r3B06+S6gZlSHL80OKa6Dv2PjFZxtrAsERk+qfWC
         /qKJ4SNn5PPJwxAddGEO7uwArYV3F4if2UtyldKmCV5FfBIHXQUnVmKaM6TTrdMjE5F8
         x4Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695080256; x=1695685056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WnuAQjafo4kC6lltDk9NFMHIoXmaRJB2ByVDtL0sp2g=;
        b=QVsS2/pKny4QZ79UP/qOjN9JEsRNhcspwdvbduK5Y1wWnfigh3Sa+IEzoOt8X1C/Fh
         9nFTbiH1uAu8GL6E+1BGDfq2t1NnEUj5SdDjYt+RX0HLDsjZYqXcA3lcH/3DW8JIrq1O
         GLN2/Q3pvdskxhMeScKXZWsGNpE2YX2kSjKcpY0GML4iUzDLuT+XzWuXS8U2QDkaagfw
         MKBx19AYDJ7opvYaaKT1qUmP79gG6kwZkVBaZN/sMm0tlZ7nu4bN0eS5J4VfdoxoWjxh
         gpioUrHj4c37EVWXhcz7Nh1r0jt55Q1GjVHXPZhXvvQD3bQyxTXfkH/2Po26Q7msmUIT
         UZzw==
X-Gm-Message-State: AOJu0YzZSoMCi0rKwBC4ghSUbdrY98WmdLRmYymFhwlKA4DocX0ktUts
        Fgt5uANkzbD1ouCNsV5ZL203Sx053qagQCxBiiw=
X-Google-Smtp-Source: AGHT+IHN5PAtySI8D9ZEaF8ftTUJJfQOxQ3yyfOI0721+PR6BsOgcBNofbOcTAnma9VTZrH8BCprzQ==
X-Received: by 2002:a05:6214:92d:b0:656:2ccf:5aa1 with SMTP id dk13-20020a056214092d00b006562ccf5aa1mr7799072qvb.45.1695080256461;
        Mon, 18 Sep 2023 16:37:36 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id m19-20020a0cf193000000b0064f364f3584sm3823816qvl.97.2023.09.18.16.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 16:37:35 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qiNo7-0007rC-FO;
        Mon, 18 Sep 2023 20:37:35 -0300
Date:   Mon, 18 Sep 2023 20:37:35 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        alex.williamson@redhat.com, kevin.tian@intel.com,
        reinette.chatre@intel.com, kvm@vger.kernel.org,
        brett.creeley@amd.com, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH vfio] vfio/pci: remove msi domain on msi disable
Message-ID: <20230918233735.GP13795@ziepe.ca>
References: <20230914191406.54656-1-shannon.nelson@amd.com>
 <20230918141705.GE13795@ziepe.ca>
 <87led3xqye.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87led3xqye.ffs@tglx>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 08:43:21PM +0200, Thomas Gleixner wrote:
> On Mon, Sep 18 2023 at 11:17, Jason Gunthorpe wrote:
> > On Thu, Sep 14, 2023 at 12:14:06PM -0700, Shannon Nelson wrote:
> >> The new MSI dynamic allocation machinery is great for making the irq
> >> management more flexible.  It includes caching information about the
> >> MSI domain which gets reused on each new open of a VFIO fd.  However,
> >> this causes an issue when the underlying hardware has flexible MSI-x
> >> configurations, as a changed configuration doesn't get seen between
> >> new opens, and is only refreshed between PCI unbind/bind cycles.
> >> 
> >> In our device we can change the per-VF MSI-x resource allocation
> >> without the need for rebooting or function reset.  For example,
> >> 
> >>   1. Initial power up and kernel boot:
> >> 	# lspci -s 2e:00.1 -vv | grep MSI-X
> >> 	        Capabilities: [a0] MSI-X: Enable+ Count=8 Masked-
> >> 
> >>   2. Device VF configuration change happens with no reset
> >
> > Is this an out of tree driver problem?
> >
> > The intree way to alter the MSI configuration is via
> > sriov_set_msix_vec_count, and there is only one in-tree driver that
> > uses it right now.
> 
> Right, but that only addresses the driver specific issues.

Sort of.. sriov_vf_msix_count_store() is intended to be the entry
point for this and if the kernel grows places that cache the value or
something then this function should flush those caches too.

I suppose flushing happens implicitly because Shannon reports that
things work fine if the driver is rebound. Since
sriov_vf_msix_count_store() ensures there is no driver bound before
proceeding it probe/unprobe must be flushing out everything?

Jason
