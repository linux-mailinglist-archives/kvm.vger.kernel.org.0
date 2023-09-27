Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C7A7B0E33
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 23:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjI0Vjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 17:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjI0Vjp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 17:39:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED39CD6
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 14:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695850743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TeQmh1TPxqqmIxxq+JQLJxEowOzljS/niMYQZ8guqHI=;
        b=J+MlzvwaWeokwv8dJant096xhV3+Wfldvp9fzG34pDBSSWMf7noUTBGyrW8UtxBpjbFpX5
        hWM3TnvC7XODqXUX7VC6eFD5Nvn/nD1u/wyUpDhu9gkGxpdb2Rr+CKI8/l/thc/CmbYCsy
        jG1h7I/ObmIYT7S6LYiDlz4sCclVl8E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-o2ufElesM-OgeX5VX_5a0Q-1; Wed, 27 Sep 2023 17:39:02 -0400
X-MC-Unique: o2ufElesM-OgeX5VX_5a0Q-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3231d7d4ac4so7110932f8f.0
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 14:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695850740; x=1696455540;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TeQmh1TPxqqmIxxq+JQLJxEowOzljS/niMYQZ8guqHI=;
        b=WQC/H0u8AtfK41V/T0I+8EsqLDcdNXIhY+hLF71z57NTM2BBR25PbyZXS1hT+bytR/
         vqNxCXXwylYUwucJ5jHgZLtMJok0+SZJOwDj4OaqpDCfba2POU98ILIjTBfAZX8RmR/s
         cebtLhwGFSDVm9QyChiS+l9PZ3DSrLLsCWOnuRyWZXbH76HtfktvIkh60q2JgKvs1zz+
         fin6Vpw0CpEBzQUv2csM90Ed8PkJ8Z7Ju23UUVHYSUp+Ex3h5mm2C2z/TYnHWgAvlaFd
         eAYZufaMK8ceoLFfh2zeD/SU6ga5sBOJNcZFmup3wscNXtEZ21TaN0l5W2vSRu3wqoth
         grhQ==
X-Gm-Message-State: AOJu0YyE8ZL/KCEZ5d50TZiwvzP40HmCIQ4RBvsom2auJlWJpPYOpJfz
        K1RFpjOU3Nx83bDi5+ACJjwpMyoln4eSrRw6pKz5U7wJ5Hhqf7Zgvh17XR2QDaO+6fkfiSxgMLl
        JzxP/DzjAlex4w+Rq+Rn0
X-Received: by 2002:a05:6000:1378:b0:317:6fff:c32b with SMTP id q24-20020a056000137800b003176fffc32bmr2744986wrz.53.1695850740498;
        Wed, 27 Sep 2023 14:39:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8Tvll3jDgau/XxrTFtu96/pFlsjFV1jgG7sTH056j2F5OzR7W6vwud805oRB7Yim04PiBCw==
X-Received: by 2002:a05:6000:1378:b0:317:6fff:c32b with SMTP id q24-20020a056000137800b003176fffc32bmr2744966wrz.53.1695850740180;
        Wed, 27 Sep 2023 14:39:00 -0700 (PDT)
Received: from redhat.com ([2.52.19.249])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d400e000000b00321773bb933sm18000857wrp.77.2023.09.27.14.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 14:38:59 -0700 (PDT)
Date:   Wed, 27 Sep 2023 17:38:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230927173221-mutt-send-email-mst@kernel.org>
References: <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com>
 <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
 <20230922121132.GK13733@nvidia.com>
 <CACGkMEsxgYERbyOPU33jTQuPDLUur5jv033CQgK9oJLW+ueG8w@mail.gmail.com>
 <20230925122607.GW13733@nvidia.com>
 <20230925143708-mutt-send-email-mst@kernel.org>
 <20230926004059.GM13733@nvidia.com>
 <20230926014005-mutt-send-email-mst@kernel.org>
 <20230926135057.GO13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926135057.GO13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 10:50:57AM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 26, 2023 at 01:42:52AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Sep 25, 2023 at 09:40:59PM -0300, Jason Gunthorpe wrote:
> > > On Mon, Sep 25, 2023 at 03:44:11PM -0400, Michael S. Tsirkin wrote:
> > > > > VDPA is very different from this. You might call them both mediation,
> > > > > sure, but then you need another word to describe the additional
> > > > > changes VPDA is doing.
> > > > 
> > > > Sorry about hijacking the thread a little bit, but could you
> > > > call out some of the changes that are the most problematic
> > > > for you?
> > > 
> > > I don't really know these details.
> > 
> > Maybe, you then should desist from saying things like "It entirely fails
> > to achieve the most important thing it needs to do!" You are not making
> > any new friends with saying this about a piece of software without
> > knowing the details.
> 
> I can't tell you what cloud operators are doing, but I can say with
> confidence that it is not the same as VDPA. As I said, if you want to
> know more details you need to ask a cloud operator.
> 
> Jason

So it's not the changes that are problematic, it's that you have
customers who are not using vdpa. The "most important thing" that vdpa
fails at is simply converting your customers from vfio to vdpa.

-- 
MST

