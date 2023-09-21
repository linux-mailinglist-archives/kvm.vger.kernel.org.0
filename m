Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1AA7A993D
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 20:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjIUSMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 14:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjIUSLT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 14:11:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8951389237
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695318721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ISuC9AVqcaXixUkxtppp8LUjHO6shANtza8stDjTgo8=;
        b=JtcrUUqjxYv2AcFaBpC5hNm8ReXcuZYgNuIsbgFJ9uHMA9hsSPZhkIBHQ3EdgNrzW9hhy2
        38a+IpSJ3MGdSgPckZBBFQmD+uQCKjMk4MS0AQ66H2GmNmHmPlnGHAF0bt4sGXEP+7WjUT
        5csjBH93byiK6aidMlZ+3DvEbzHLmFs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-1tFSs-KlNRKpW9gKxS-I6w-1; Thu, 21 Sep 2023 09:33:17 -0400
X-MC-Unique: 1tFSs-KlNRKpW9gKxS-I6w-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-532c440db89so657520a12.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 06:33:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695303196; x=1695907996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ISuC9AVqcaXixUkxtppp8LUjHO6shANtza8stDjTgo8=;
        b=gjf5I1H324UoSrKFyNYLaH/tkYJLBT8DDBeJjIdmQO+TR9AWbM0yqHCsWYX/BJn78n
         IDi4sph6algxLFsjhOx7NO6pXCnS+zeIda9/tKEs44pbZUAjhIZ24ppOUeXIQgB+BIr5
         zkOjkgbd0rVAXS+Uz9e+atZ1DB75CPH1b21Z+8zC2LLxSLVVUm8J/SLqZyxhWCtQurgg
         DWhCyyojnRnXbL/7cr7RH4S0rJEnUCdhTrqqXi8hXFa9iNUXuumlBrVIG0AYEUmR+/sj
         J6NN4ElYZPyLTHhHXoyIEHTd2+hUwM8l505iME8fosg9oYqU21W0rVu2RnkDqRLVxSkP
         m4tg==
X-Gm-Message-State: AOJu0Yxwq+iZiZxRUT+0PSwwkp+vmzKx0frjD9z+Ay13nJA+oAVksJSt
        zzonZ13M+X8QDTVyTAECGzNCxHptOsm0cEkW2EhXrX+myl1gy6XkothyetSX6tnDrcmkm/Ue/Kb
        AhJQ2JEF///cl
X-Received: by 2002:a05:6402:b36:b0:530:9fbc:8df6 with SMTP id bo22-20020a0564020b3600b005309fbc8df6mr4896866edb.2.1695303196383;
        Thu, 21 Sep 2023 06:33:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWkySiLdgAdNKnLNCgYei8zh/ZPXT0tiKpgirtwwvkw7Ye5tlhji3W9LqtB9azmo8hjNyCeQ==
X-Received: by 2002:a05:6402:b36:b0:530:9fbc:8df6 with SMTP id bo22-20020a0564020b3600b005309fbc8df6mr4896841edb.2.1695303196047;
        Thu, 21 Sep 2023 06:33:16 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id u25-20020aa7d0d9000000b0051e1660a34esm843110edo.51.2023.09.21.06.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 06:33:15 -0700 (PDT)
Date:   Thu, 21 Sep 2023 09:33:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921091756-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921124040.145386-12-yishaih@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 03:40:40PM +0300, Yishai Hadas wrote:
> +#define VIRTIO_LEGACY_IO_BAR_HEADER_LEN 20
> +#define VIRTIO_LEGACY_IO_BAR_MSIX_HEADER_LEN 4

This is exactly part of VIRTIO_PCI_CONFIG_OFF duplicated.

-- 
MST

