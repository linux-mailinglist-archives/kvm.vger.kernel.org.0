Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E42B532EA1
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 18:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239584AbiEXQIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 12:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239715AbiEXQH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 12:07:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1480D77F38
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 09:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653408470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AjP5JPsp4sTeptQO7etKphezL1GL7XatlC7yllc+qq4=;
        b=R0JjKqf6JfnwWgVFr+xbicGmTarFfaa1RRRWEXVrWATEstZdkJq+3h5QKSZqBcYCyl8MAr
        mQbP7klx3ZE+Fdc52S09toukoJ5cOHHYhOyt2/ykWw5ARAcHr/hx6l1dcC7rXBJ3QJ96kI
        9j4MMs0n9qOmuNIoCtLsnaNnMsgCyHY=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-ZiczhSSVPZmivVrTdGbP_g-1; Tue, 24 May 2022 12:07:48 -0400
X-MC-Unique: ZiczhSSVPZmivVrTdGbP_g-1
Received: by mail-il1-f198.google.com with SMTP id l8-20020a056e021aa800b002cf778c63caso11013575ilv.10
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 09:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AjP5JPsp4sTeptQO7etKphezL1GL7XatlC7yllc+qq4=;
        b=mJZ4gk7pLvdOk9c7aOt6YqUpW79VcCmOdw/YTnW+bJKRWxufgPsIOYl8zTffAC1wxe
         Lx+jFhpiz/39vnJBjz5W5GOwJ8NAU+oVTaKqKVy7mW6xNGD7ZO2RGUE1vTnpqVSgksWB
         XH7tmgtY6sOuz8zpTCw2oVGIy0/1rYZfxXFfQoze9Wj/gd1oLOF5pPhX7mGSkE4qQrsB
         Qe5sean1SK0+MWnVoJUObiuJ8I1ppa2Jg8z7U/z6E9TMkOidAtb3HW9DQkWalf2cGUVT
         JhPgc51IdW3hEdoygEAVinL3VOdE3gbXpl34JygO9Y7aktJSIkIiNIEEqgQAvegw33fy
         hMdg==
X-Gm-Message-State: AOAM532vQ0wKwxF+riwyv0RekJsNWWLDf66n6NqNnXmF7vrUUEq013YS
        rYaciVwtVCaFBig/Hdakz/jkdsCUZ8Z1XDWcn4fDbKGEzaKGmLbSzpjN05+f1kV+d8e1um9VPjd
        yXL7M0wLVKZaB
X-Received: by 2002:a05:6e02:170a:b0:2d1:3f8b:ad75 with SMTP id u10-20020a056e02170a00b002d13f8bad75mr13606325ill.135.1653408467259;
        Tue, 24 May 2022 09:07:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDXCFqahhgZhF13j/01JuWAI9TkKwryMIBDz+Ojod8ivP2jLD7vfDSwtL6uq0vKB4eb0olaw==
X-Received: by 2002:a05:6e02:170a:b0:2d1:3f8b:ad75 with SMTP id u10-20020a056e02170a00b002d13f8bad75mr13606312ill.135.1653408467062;
        Tue, 24 May 2022 09:07:47 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m15-20020a056e021c2f00b002cde6e352d5sm4628333ilh.31.2022.05.24.09.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 09:07:46 -0700 (PDT)
Date:   Tue, 24 May 2022 10:07:45 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     jgg@nvidia.com, cohuck@redhat.com, borntraeger@linux.ibm.com,
        jjherne@linux.ibm.com, akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <20220524100745.006a3635.alex.williamson@redhat.com>
In-Reply-To: <20220519183311.582380-1-mjrosato@linux.ibm.com>
References: <20220519183311.582380-1-mjrosato@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 May 2022 14:33:10 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> As discussed in this thread:
> 
> https://lore.kernel.org/kvm/20220516172734.GE1343366@nvidia.com/
> 
> Let's remove VFIO_GROUP_NOTIFY_SET_KVM and instead assume the association
> has already been established prior to device_open.  For the types today
> that need a KVM (GVT, vfio-ap) these will fail if a KVM is not found.
> Looking ahead, vfio-pci-zdev will optionally want the KVM association
> (enable hardware assists) but it will not be a hard requirement (still
> want to allow other, non-KVM userspace usage). 
> 
> This is built on top of vfio-next and tested with s390x-pci
> (zdev-kvm series) and vfio-ap (GVT changes are compile-tested only)
> 
> Changes for v3:
> - merge branches under if (device->open_count == 1) (Kevin)
> - move device->open_count-- out from group_rwsem (Kevin)
> - drop null KVM check (Christoph)
> - remove extra kvm_{get,put}_kvm from vfio_ap_ops, it was already getting
>   a reference (Jason)
> - Add comment about kvm reference in vfio.h (Jason)
> - Return -EINVAL if !kvm for vfio-ap (Tony)
> 
> Changes for v2:
> - gvt no longer needs release_work, get rid of it (Christoph)
> - a few compile fixes for gvt
> - update commit to mention fixes gvt oops (Jason)
> - s/down_write/down_read/ in a few spots (Jason)
> - avoid kvm build dependency by holding group read lock over device
>   open/close and put the onus on the driver to obtain a reference if
>   it will actually use the kvm pointer.  Document the requirement,
>   use lockdep_assert to ensure lock is held during register_notifer;
>   today all callers are from driver open_device. 
> 
> Matthew Rosato (1):
>   vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
> 
>  drivers/gpu/drm/i915/gvt/gtt.c        |  4 +-
>  drivers/gpu/drm/i915/gvt/gvt.h        |  3 -
>  drivers/gpu/drm/i915/gvt/kvmgt.c      | 82 ++++++--------------------
>  drivers/s390/crypto/vfio_ap_ops.c     | 35 ++---------
>  drivers/s390/crypto/vfio_ap_private.h |  3 -
>  drivers/vfio/vfio.c                   | 83 ++++++++++-----------------
>  include/linux/vfio.h                  |  6 +-
>  7 files changed, 57 insertions(+), 159 deletions(-)

Applied to vfio next branch for v5.19.  Thanks,

Alex

