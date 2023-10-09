Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF0A7BEAB7
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 21:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378397AbjJIThM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 15:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346671AbjJIThL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 15:37:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE46593
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 12:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696880183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TVDFHMjJ/ycKLdZo/7Qo28nzsm1D+pqkl3FWIOZKqxE=;
        b=DDd5LU86nLTGy7dFRnCWzXq07OTJmSbvwLv61Rafnxuc2EuNCVYq21jVMTE4FrmIdKZ7Fr
        sqSN5r1vdBJM/ES+98GENckODWVtwfgOpjwf9FkPv+oUVxTep5Egcbql+uvFYzs76H26FG
        8K6mfL95SQuVAifT7aDjulfaWaLTGSs=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-xyJE_MLYN9qTGPuTtoXiiA-1; Mon, 09 Oct 2023 15:36:15 -0400
X-MC-Unique: xyJE_MLYN9qTGPuTtoXiiA-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-780addd7382so413734039f.1
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 12:36:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696880175; x=1697484975;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TVDFHMjJ/ycKLdZo/7Qo28nzsm1D+pqkl3FWIOZKqxE=;
        b=r9k8a4BniwHv5MIeNU8ZaohRYrzLpL45rlrOnhp0KFjfdwXhIFrycAtp1Q2IAcxv92
         UpFMRXFetFdTjo6grmkVITwiIhV5bEHpkrgLPBv7KCb9RU0125cStx/50ciAMH1lvGXn
         2vwqct+k6mmLNwfecaX3zJlTcSj5fuYkoFfjLKRlQRKDH7QHGG0EbJqI+VrB/9ROLaXY
         qVoQaXYHlu3x74gcF/8aONRKxeYESNm40RjhCPR8VYIBJrP0xvybJQjxAidt30s1ysRK
         snwQN0EKi3dUZCeRU5xPEKOWg17pPlqbgKnItstD8VWzE3RdK/fMf/iwYo7m/7OLOqXu
         fD1w==
X-Gm-Message-State: AOJu0YzilPvd5Tv52GGfu5F2zZl5VOlUUD+Phsw75rjs3+E/lN02SToO
        lKBwpwBEBn+cG07cRdCMRzvniy7h4EK7Fv5FxzTCoQsQ4VADsLLDkDHx/LyQJm+3DNqQ5l8sJd7
        SojJhApaGh636
X-Received: by 2002:a05:6e02:1a0e:b0:352:6f88:9818 with SMTP id s14-20020a056e021a0e00b003526f889818mr19798125ild.11.1696880174980;
        Mon, 09 Oct 2023 12:36:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZrmoohFj1abftp9cjL5O3tHcNh5viE77dWrcuBTn9TZna5ISvd95pVTk16QjIDbjIm0ia6Q==
X-Received: by 2002:a05:6e02:1a0e:b0:352:6f88:9818 with SMTP id s14-20020a056e021a0e00b003526f889818mr19798109ild.11.1696880174711;
        Mon, 09 Oct 2023 12:36:14 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id t2-20020a056e02010200b003513535c69dsm3154672ilm.5.2023.10.09.12.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 12:36:14 -0700 (PDT)
Date:   Mon, 9 Oct 2023 13:36:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     <ankita@nvidia.com>, <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <anuaggarwal@nvidia.com>, <dnigam@nvidia.com>, <udhoke@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20231009133612.3fdd86a9.alex.williamson@redhat.com>
In-Reply-To: <ZSHykZ2GgSn0fE_x@debian.me>
References: <20231007202254.30385-1-ankita@nvidia.com>
        <ZSHykZ2GgSn0fE_x@debian.me>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 8 Oct 2023 07:06:41 +0700
Bagas Sanjaya <bagasdotme@gmail.com> wrote:

> On Sun, Oct 08, 2023 at 01:52:54AM +0530, ankita@nvidia.com wrote:
> > PCI BAR are aligned to the power-of-2, but the actual memory on the
> > device may not. A read or write access to the physical address from the
> > last device PFN up to the next power-of-2 aligned physical address
> > results in reading ~0 and dropped writes.
> >   
> 
> Reading garbage or padding in that case?
> 
> Confused...

The coherent memory size is rounded to a power-of-2 to be compliant with
PCI BAR semantics, but reading beyond the implemented size fills the
return buffer with -1 data, as is common on many platforms when reading
from an unimplemented section of the address space.  Thanks,

Alex

