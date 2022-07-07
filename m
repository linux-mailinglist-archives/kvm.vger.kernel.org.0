Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC656AECC
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 01:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbiGGXBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 19:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiGGXBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 19:01:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18C8F61D56
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 16:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657234902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q1R4YqBu0svZmycrzTEsm+CshT1fviRoeDSNFKgJtmI=;
        b=NtcsMg56U1ZGSM7KaMONk8fsvdyQH4LQztOHCxp6IXdCSJBcRMq5BKBtg5hBDdet8bt4Z7
        SbvrGgyhE5YnamXqnJOKMocy9loifHGZRkLro70l2jLKNwL4eCPBcbMTNw91opZL+hnJfv
        ko8lqKMbZXerFGdqYD/iWrcaXjvzeQA=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-D9IViCkaPuqt8W2iRNMn4g-1; Thu, 07 Jul 2022 19:01:41 -0400
X-MC-Unique: D9IViCkaPuqt8W2iRNMn4g-1
Received: by mail-io1-f70.google.com with SMTP id w12-20020a5d960c000000b00678e4b1197bso1357154iol.2
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 16:01:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Q1R4YqBu0svZmycrzTEsm+CshT1fviRoeDSNFKgJtmI=;
        b=03eEZt521PZWEk0eUFfdNSnpwegX41CKzpjKMW5wDkl1YLS676ZmutnBdL1X42WsU8
         XbwI0p+ojomYBSKG9Tt/7GomH1zFYoSmWZUHy3VtzEtJVxKQNZ5Fn0WFxD35Uujmd0bR
         VhvShmNQj3aY7eOeQg3xu+vf/oGNeUXDuKz/CSBpzZPVzSuXGeREyuCJmXmXaPb/YFBz
         s5FiuSTdcIvN2IDRLz1XVg30RRSYvFlEVMjuGVZX+Jg0KrPREH5FYwtnN2K/W05Miro+
         I18Hch2irmvH/CvGXXoBp1NpgGG3webRw+WEOqqH7p7vkUWLO2oErYFDFFJYJdmS7PyR
         zUUg==
X-Gm-Message-State: AJIora9wSlCxxWzZAaJEAetPCifjwhk4M1C/ocUn1lvvG4uAO9kB6jhB
        IXa9C3gLWCCPm/89++75Cc8iIsmfHTDH168cK6pd35LTPRsO2VU3erSZ2ZNStpkvxTQjCH6v3Ul
        DGEAeHNNt52VW
X-Received: by 2002:a92:dc85:0:b0:2d9:1a4e:67b1 with SMTP id c5-20020a92dc85000000b002d91a4e67b1mr306001iln.282.1657234900873;
        Thu, 07 Jul 2022 16:01:40 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sipTe8IAMIsf4DdtE688PJxdjqLg8FaCbNUHuN/Z4VXumXyfd4opRxKbH9GUMWrG+goEhcVQ==
X-Received: by 2002:a92:dc85:0:b0:2d9:1a4e:67b1 with SMTP id c5-20020a92dc85000000b002d91a4e67b1mr305978iln.282.1657234900651;
        Thu, 07 Jul 2022 16:01:40 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i15-20020a92c94f000000b002dc21dec1d9sm3635833ilq.16.2022.07.07.16.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 16:01:40 -0700 (PDT)
Date:   Thu, 7 Jul 2022 17:01:39 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 15/15] vfio/mdev: remove an extra parent kobject
 reference
Message-ID: <20220707170139.1b2f977e.alex.williamson@redhat.com>
In-Reply-To: <20220707134052.GC19060@lst.de>
References: <20220706074219.3614-1-hch@lst.de>
        <20220706074219.3614-16-hch@lst.de>
        <20220706143833.GD693670@nvidia.com>
        <20220707134052.GC19060@lst.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 Jul 2022 15:40:52 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Wed, Jul 06, 2022 at 11:38:33AM -0300, Jason Gunthorpe wrote:
> > On Wed, Jul 06, 2022 at 09:42:19AM +0200, Christoph Hellwig wrote:  
> > > The mdev_type already holds a reference to the parent through
> > > mdev_types_kset, so drop the extra reference.  
> > 
> > I would drop this patch, but at least the explanation needs tweaking..  
> 
> I'm fine with that.  Alex, any preferences?

Modulo the bogus kobject_put()s, this essentially reverts:

commit 9a302449a58d45d0ef2aab686f64b35919bc604c
Author: Jason Gunthorpe <jgg@ziepe.ca>
Date:   Tue Apr 6 16:40:30 2021 -0300

    vfio/mdev: Add missing reference counting to mdev_type
    
    struct mdev_type holds a pointer to the kref'd object struct mdev_parent,
    but doesn't hold the kref. The lifetime of the parent becomes implicit
    because parent_remove_sysfs_files() is supposed to remove all the access
    before the parent can be freed, but this is very hard to reason about.
    
    Make it obviously correct by adding the missing get.
    
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Kevin Tian <kevin.tian@intel.com>
    Reviewed-by: Cornelia Huck <cohuck@redhat.com>
    Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
    Message-Id: <7-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
    Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Which we all seemed to think was a good thing 15 months ago.  It is
still difficult to reason when the mdev_type_ktype.release function
occurs relative to the parent reference held by the kset, but without
an explanation how we're safe, I'm ok with a little paranoia and
explicit references.  Thanks,

Alex

