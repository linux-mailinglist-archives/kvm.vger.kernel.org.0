Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A939076B98B
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 18:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjHAQS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 12:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjHAQSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 12:18:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FFA1727
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 09:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690906655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n67ukYIApZu19qQCBa5il0f/lXkjZfGUU5rcEKxPBys=;
        b=Br375Z9gBXNk7y3v5GW4DvFvA6vTc4nT2XVYTekqbv5mo8oo0YYEipmURs3gafvJ/a+mg/
        TclPpm+Gi/yMaBdi1inSawIqf8te8SzpJd7pstoqW0zpsL8kBzWK86IEHAZCEha1jZmmmB
        Df1JIBJXxsHL9O8Pn2Ozrrh+7ABzsxk=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-apy-LFFJPjeK0O7ZNsxK2g-1; Tue, 01 Aug 2023 12:17:33 -0400
X-MC-Unique: apy-LFFJPjeK0O7ZNsxK2g-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-786d9d4d9a6so651525039f.2
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 09:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690906652; x=1691511452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n67ukYIApZu19qQCBa5il0f/lXkjZfGUU5rcEKxPBys=;
        b=Ofl2QW+eERZddE4h30tsloadk4rQvRBx3gumrpLXmzAMY0qsgy0r/Tw3IajCzj6f1/
         kVZF8htBZufJCm92ethZrxS0MFiKaVUhP/zrvyU0J0QmdDAjE07pG4bcp2iroYi+3hWf
         BQXr6dSJmWCB00haa2nFw0IfT5bcwDGWyWrWcWfa4B7nsXlEmmH9l3QwTJc2UkThaqXR
         kmNl2Dvh8C60pk1ywy2Fd5pc29j2Vh+60fxPfsP8OxMcSRl3bJsF32IucSlA/pp6sdqg
         8n+c9VpdzNYF2tUU8vdULlSAMbPxpix1Qr60S/Y8SPQZT3elLUqrf/bnH+Rfc3uk5n2q
         1+1Q==
X-Gm-Message-State: ABy/qLa4UAMqT5GJr9ukibsCO66C9a3c288GyjxRxJBDNgAgkwtrylY9
        Jdqj0tvGvJ/7pz7UB8Hnn9tutVEOvTdlnVUD6Ed8F2EENa+TfL92kj4o6NjrqAkRr0PMuICGxG1
        7wX3ZITjESHSYoSm6Lssv
X-Received: by 2002:a05:6602:29a5:b0:787:953:514b with SMTP id u5-20020a05660229a500b007870953514bmr13479210ios.3.1690906652429;
        Tue, 01 Aug 2023 09:17:32 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGzSRv4BJCyFuRHcqiwK2y7xTbuS609GANT46v+yTHKnMY0v+/iytZGPee97Y/KPlbpylu+wg==
X-Received: by 2002:a05:6602:29a5:b0:787:953:514b with SMTP id u5-20020a05660229a500b007870953514bmr13479203ios.3.1690906652226;
        Tue, 01 Aug 2023 09:17:32 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id f13-20020a6bdd0d000000b0078337cd3b3csm4053746ioc.54.2023.08.01.09.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 09:17:31 -0700 (PDT)
Date:   Tue, 1 Aug 2023 10:17:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, sgarzare@redhat.com
Subject: Re: VFIO_IOMMU_GET_INFO capability struct alignment
Message-ID: <20230801101730.607d96ab.alex.williamson@redhat.com>
In-Reply-To: <20230801153846.GA1371443@fedora>
References: <20230801153846.GA1371443@fedora>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Aug 2023 11:38:46 -0400
Stefan Hajnoczi <stefanha@redhat.com> wrote:

> Hi,
> It appears that ioctl(VFIO_IOMMU_GET_INFO) can produce misaligned
> capability structures. Userspace workarounds exist but I wanted to ask
> whether the kernel can align capability structures to save all userspace
> programs the trouble?
> 
> The issue is:
> 
>   struct vfio_iommu_type1_info_dma_avail {
>           struct vfio_info_cap_header header;              /*     0     8 */
>           __u32                      avail;                /*     8     4 */
>   
>           /* size: 12, cachelines: 1, members: 2 */
>           /* last cacheline: 12 bytes */
>   };
> 
> Once this capability is added, the next capability will be 4-byte
> aligned but not 8-byte aligned. If there are __u64 fields in the next
> capability, then they will be misaligned.
> 
> This was noticed when investigating a bug in userspace code that uses
> ioctl(VFIO_IOMMU_GET_INFO):
> https://gitlab.com/pci-driver/pci-driver/-/merge_requests/2#note_1495734084
> 
> One possible solution is to modify vfio_info_cap_add() so that
> capability structures are always rounded up to 8 bytes. This does not
> break the uapi because capability structure offsets are described at
> runtime via the cap_offset and header->next fields. Existing userspace
> programs would continue to work and all programs would find that
> capability structures are now aligned.

Yes, I think the helpers should automatically align each added
capability.  Thanks,

Alex

