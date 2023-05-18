Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E612870888A
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 21:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjERTo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 15:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjERToZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 15:44:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75368E6E
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684439025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PA8QlisVvQUIBeB7cAo5RqDhEmfbmuvIuFemkqkHNmY=;
        b=SG0KXQZH+iTbfzvk5mPOQOAxaiiFBHPnSXFGFiwj97pufkShBB/tk3JgU1OTxxmFgNij2B
        JhGXEDAH12MMWnmiPRMO+fZrVM93mL8RgLrjte01aJlkAWzNrgQUfMQ4Lny9p8pL6VvoIb
        DM05Dmcu04kFoNxyVs+tOBuQE3KdwBY=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-YyMeod1MPUCHnC6Lc7ObPA-1; Thu, 18 May 2023 15:43:43 -0400
X-MC-Unique: YyMeod1MPUCHnC6Lc7ObPA-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7636c775952so199596739f.2
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:43:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684439023; x=1687031023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PA8QlisVvQUIBeB7cAo5RqDhEmfbmuvIuFemkqkHNmY=;
        b=Qw3/Zi6FEc4F2vDNm89/RYyyBcWVM8oONvNeOPewmCs248jAGzDeer/Lq/+KCUy+FY
         9JxEH3lVi1QtdKRafTgEyYY2lNNdVDLwSSvQDlEO7N39o+PKGtuZBhc2pbNI3RCGg5vL
         xOFCai6N7MRsrCG5SitPEW+NRNE3iM79nBocxRQ8xUtmjOmWUviZXqu2aRfffquG4VXZ
         XZsKHHr68b+R+42mFUCDb9pgi06GoI/tc9aJQgrJq3xaiiEC5kES7ASl+bxcL1KMXWKf
         oUZziVNsX8qPccnv694NsZQfY8wZIVp5qi1rcScVVMu5ODPkxHImuOV2rwPVGJuK7MGY
         D3xQ==
X-Gm-Message-State: AC+VfDx+f2wuypRJ9zgDGF5uMmZzM/nowv4yDVD5QCuWwkBp6mGlue3w
        pS5xN/nSjdCrZjDW9hIeAwdXruBE2ENm+cBTVI8tLec4n/lsNshBqwMy3FPNUWNYgBKzbKR3WEe
        /RE53/CYce4H1
X-Received: by 2002:a5d:94cd:0:b0:76c:8a8f:edc2 with SMTP id y13-20020a5d94cd000000b0076c8a8fedc2mr7297128ior.12.1684439023153;
        Thu, 18 May 2023 12:43:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4rw6SJnwSqjfCyaFRoKbONMXxWejcCpLIQx2vrAykC+soNBYYP2BWJo0LZ1SBw5bDgbglmXQ==
X-Received: by 2002:a5d:94cd:0:b0:76c:8a8f:edc2 with SMTP id y13-20020a5d94cd000000b0076c8a8fedc2mr7297117ior.12.1684439022870;
        Thu, 18 May 2023 12:43:42 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w31-20020a056638379f00b00405f36ed05asm636935jal.55.2023.05.18.12.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 12:43:41 -0700 (PDT)
Date:   Thu, 18 May 2023 13:43:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v5 01/10] vfio-iommufd: Create iommufd_access for
 noiommu devices
Message-ID: <20230518134340.0a39629b.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529AD3369CE1F296086A607C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
        <20230513132136.15021-2-yi.l.liu@intel.com>
        <20230517112609.78a3e916.alex.williamson@redhat.com>
        <ZGUbAzl985p5kX1Z@nvidia.com>
        <DS0PR11MB7529AD3369CE1F296086A607C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 May 2023 12:23:29 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, May 18, 2023 2:21 AM
> > 
> > On Wed, May 17, 2023 at 11:26:09AM -0600, Alex Williamson wrote:
> >   
> > > It's not clear to me why we need a separate iommufd_access for
> > > noiommu.  
> > 
> > The point was to allocate an ID for the device so we can use that ID
> > with the other interfaces in all cases.  
> 
> I guess Alex's question is why adding a new pointer named noiommu_access
> while there is already the iommufd_access pointer named iommufd_access.

Yes, precisely.  Sorry that was confusing, we need the access for
noiommu but it's not clear why that access needs to be stored in a
separate pointer when we can already differentiate noiommu devices
otherwise.  Thanks,

Alex

