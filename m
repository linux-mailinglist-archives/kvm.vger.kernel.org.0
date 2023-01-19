Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1920674344
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjASUFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjASUFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:05:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859C490B15
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674158683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qbMNk0OQQ6DY2bltYqaTonrcREUgE+YK86MmYj+HNc4=;
        b=HySppI2nGU0wRmKqU7QnOQB6LaQ9NNj3JIieayfk/yflOOnTKFCEP0ogOpGB/V3NtSQ00l
        oFMiYn7I0eIB9LErt4TDZkBrDvVh1nPbVqpo86axiUrgWDqr115jI+dCktnvvu7TV9zzmE
        IVx17QqJZvOiOakgmQjJF50qrTOyqvw=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-126-ZAp93eEANVmUh5Yr8Nk-wg-1; Thu, 19 Jan 2023 15:04:41 -0500
X-MC-Unique: ZAp93eEANVmUh5Yr8Nk-wg-1
Received: by mail-il1-f200.google.com with SMTP id l14-20020a056e02066e00b0030bff7a1841so2352872ilt.23
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:04:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qbMNk0OQQ6DY2bltYqaTonrcREUgE+YK86MmYj+HNc4=;
        b=0PK+eIE52AW4QzyzYdT5HVc0NmFknIy3cTrQCo1Xo1buUmDGZBySQBLq3UWO22g2iT
         TdfLWi4F12Tsbdd7BvjB8k1mzx6Ei3bli0P9KHyvQqefZs5asI92YlYMlRsgEir+G9tV
         ze84VZV56ONWI7beuUYv2NM/1JQL+5IJ4rFl+h4eBmu8h7/fuBVhqU0MRhV8bfl21dU8
         Y3BFTzdoP/IINsFofUYNk2ZP3JBGuWM5wXkoM823RLVE998OizpeaiqthZvKo0TPYEF4
         53gJYetu+OyH9UmqEzCwahHFCxRu1zwB9pzcuiFjnmbD3Cy36NoGZvBZm/eewEJzHJ8Y
         dVnQ==
X-Gm-Message-State: AFqh2komnp/dYDTcrtI2BzrwGWxMjk72nxBjHVs+gmkiarajlRmT3f7t
        2ahQka3N2A40AWHsiHQEHZ5IQKZeZ0nf9b7X6bgKBL6bLlc92+EfHY7Hx8h18FssGJ/x837WVSX
        awsMZdfxdBib/
X-Received: by 2002:a5d:9c8a:0:b0:704:5940:203e with SMTP id p10-20020a5d9c8a000000b007045940203emr7351522iop.7.1674158681149;
        Thu, 19 Jan 2023 12:04:41 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvClnfakOoqDzlc62adXEtdq2YGv8TqwWgy79MDE6/GjCHaEFqKln1QfC3513xHbfixr/OpTQ==
X-Received: by 2002:a5d:9c8a:0:b0:704:5940:203e with SMTP id p10-20020a5d9c8a000000b007045940203emr7351515iop.7.1674158680883;
        Thu, 19 Jan 2023 12:04:40 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l18-20020a02ccf2000000b003a5f25b1888sm2466422jaq.35.2023.01.19.12.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 12:04:40 -0800 (PST)
Date:   Thu, 19 Jan 2023 13:04:38 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, kevin.tian@intel.com,
        cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: Re: [PATCH 05/13] kvm/vfio: Provide struct
 kvm_device_ops::release() insted of ::destroy()
Message-ID: <20230119130438.25387127.alex.williamson@redhat.com>
In-Reply-To: <Y8mU1R0lPl1T5koj@nvidia.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
        <20230117134942.101112-6-yi.l.liu@intel.com>
        <Y8mU1R0lPl1T5koj@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Jan 2023 15:07:01 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jan 17, 2023 at 05:49:34AM -0800, Yi Liu wrote:
> > This is to avoid a circular refcount problem between the kvm struct and
> > the device file. KVM modules holds device/group file reference when the
> > device/group is added and releases it per removal or the last kvm reference
> > is released. This reference model is ok for the group since there is no
> > kvm reference in the group paths.
> > 
> > But it is a problem for device file since the vfio devices may get kvm
> > reference in the device open path and put it in the device file release.
> > e.g. Intel kvmgt. This would result in a circular issue since the kvm
> > side won't put the device file reference if kvm reference is not 0, while
> > the vfio device side needs to put kvm reference in the release callback.
> > 
> > To solve this problem for device file, let vfio provide release() which
> > would be called once kvm file is closed, it won't depend on the last kvm
> > reference. Hence avoid circular refcount problem.
> > 
> > Suggested-by: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  virt/kvm/vfio.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)  
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> From Alex's remarks please revise the commit message and add a Fixes
> line of some kind that this solves the deadlock Matthew was working
> on, and send it stand alone right away

Also revise the commit log since we'll be taking a reference in the
group model as well.  The function and comments should also be updated
s/destroy/release/.  Thanks,

Alex

