Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A917A9DBF
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjIUTrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjIUTqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:46:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66948115FA0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 12:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695324851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AaaqDZJL021384uafe4l1Ly4iUujziU7vTMCEb1hokc=;
        b=cNbfZzqJFeAfyqlyVKBM19Qi8zxUFmu8b9Rk5cnupFpDgZN0RSU6Mz5B94SzSeK+4wVUsO
        yQPp80LCVR0/N7TIt5UOuE9UqYw114WXVhpSTVQA+i7BQTZ9YV01zuJz88NVHD+3/ZtW+0
        xwjZcE2u+Y6kIXkleNeFg+DgWHB1eUE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-UwcjAdcFNjyC2Y_OLsBZAQ-1; Thu, 21 Sep 2023 15:34:10 -0400
X-MC-Unique: UwcjAdcFNjyC2Y_OLsBZAQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-99bebfada8cso105272266b.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 12:34:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695324848; x=1695929648;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AaaqDZJL021384uafe4l1Ly4iUujziU7vTMCEb1hokc=;
        b=VYbJCjJUsJ2tgvZBiUYb7Ssf0hIxPg90RN/jy5yAY43GCr+cK8IWSA+9hi8V3iJg1t
         jpSs2qH1KygxhW+rUfxSJbXiSukKSVU5JhFKwHopVWy9Kv4wMVWkrvg+Vl/r7JYhtD3i
         NwXKVql67mXX7l4ztI42bDIxkB3QmEh4DidtXWgRwrIkzZdJozQxYMZAGcWMk1E7HVz6
         6eq1EOoyH68StIaFeqxCVLSpzHYUWU0yj1GAFHXfIWGAKJ2uNKltQ+//4GtUP43jxRCV
         EPIQOEjEJYq2hTqk5ff63TNthasECjEzN8K+g2KcsvRglvSNMHRu3pingaNm/To7dmkT
         6N/Q==
X-Gm-Message-State: AOJu0YyY/bznj3TqCxFPyS6yAinFfVZw8BVThDVgkXoRdTu5ktizO9m4
        CYU+hc/Qz1TJTDbMLhVHrNr+J0WO1TZ6tkSyV57uix43SltC8AghKXiEVKUe+8PcV+QDWG+u4og
        cXL24pH0aFa7aVMiM2VOv
X-Received: by 2002:a17:906:5385:b0:9a5:c9a4:ba1b with SMTP id g5-20020a170906538500b009a5c9a4ba1bmr5252290ejo.8.1695324848645;
        Thu, 21 Sep 2023 12:34:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6S+HUO5/kka0lpaeZ0v+bDS8T9qfxs2Z/38Jcf9wrPi/YGWshdqAvzXLHy4LubK85IYUcsQ==
X-Received: by 2002:a17:906:5385:b0:9a5:c9a4:ba1b with SMTP id g5-20020a170906538500b009a5c9a4ba1bmr5252281ejo.8.1695324848363;
        Thu, 21 Sep 2023 12:34:08 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id oq19-20020a170906cc9300b0098f99048053sm1497148ejb.148.2023.09.21.12.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 12:34:07 -0700 (PDT)
Date:   Thu, 21 Sep 2023 15:34:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921152802-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921104350.6bb003ff.alex.williamson@redhat.com>
 <20230921165224.GR13733@nvidia.com>
 <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921181637.GU13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 03:16:37PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 01:55:42PM -0400, Michael S. Tsirkin wrote:
> 
> > That's not what I'm asking about though - not what shadow vq does,
> > shadow vq is a vdpa feature.
> 
> That's just VDPA then. We already talked about why VDPA is not a
> replacement for VFIO.

It does however work universally, by software, without any special
hardware support. Which is kind of why I am curious - if VDPA needs this
proxy code because shadow vq is slower then that's an argument for not
having it in two places, and trying to improve vdpa to use iommufd if
that's easy/practical.  If instead VDPA gives the same speed with just
shadow vq then keeping this hack in vfio seems like less of a problem.
Finally if VDPA is faster then maybe you will reconsider using it ;)

-- 
MST

