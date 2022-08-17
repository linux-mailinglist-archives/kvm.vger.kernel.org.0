Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C9A596BBB
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 10:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiHQIzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 04:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbiHQIzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 04:55:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5B87F27A
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 01:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660726541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kxXD+nXe69utb78dojqgzjisp1/GKHU9/l3M8qyZRmc=;
        b=E0HWELluDiboUHnUpv8RCJyrGyu+UYRtSxx2BuFjTSUeQ0ntplx8i0OC9LAIXplB7zAk00
        YW2tnf5LxETkKEQm737UnJVXS3+3jJ5ATc39LZkJ7GG/2INK5kVJBPtSGPJZ8Mo1zIbH+c
        vPLghqysyXEU1dOnHjK9yntEzh1PyRA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-613-czHtOIACNxu7NHXA4v9_YQ-1; Wed, 17 Aug 2022 04:55:40 -0400
X-MC-Unique: czHtOIACNxu7NHXA4v9_YQ-1
Received: by mail-wr1-f71.google.com with SMTP id i24-20020adfaad8000000b002251cb5e812so697405wrc.14
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 01:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=kxXD+nXe69utb78dojqgzjisp1/GKHU9/l3M8qyZRmc=;
        b=E6qMn3bXO5uC/AQJzf24lb/SOMvKeQHlQmfoJ1pjMgzUdUzstPLSDdN7foGYVUD0LQ
         RZ3qUg5MHXZ5rqZ48KGqh6X7B/nfulWo+JVk1wbYbnrgEYjrAW9L7E1pvB52oAOufJwz
         t8fxA3uH6lpLWt0O0m87BxfFCOO/q9QJ1tTxgbuEUInPKJyvDQdZz4ShMQw1t+Thp6fv
         nTHY7fwZcW6A2BnqRhWOSgSNs/YC4Cjqpn+6YMjE08PvzzqJC/JpUvrymX75S8I7dqTu
         lHtZhgh5x0UdniKtsthsqj8X+NQCDWD15EWoyWEZRsSX0Keq9rGArG4CgXwkSKvZ8o74
         SDuw==
X-Gm-Message-State: ACgBeo0NyB8MbpwTxYe3iGsL9SEFyjT0/TEGqbpQpaJV8zJ1Iz5Ie9FR
        zJkQht8VXMxi9xad0HFOiqHYSqmYwBxJP98VUXFmrse5VMNake6NVs9CGdqGpccleid66LDjcOM
        bYA/q5q9jVx6T
X-Received: by 2002:a05:600c:1d9b:b0:3a5:d66e:6370 with SMTP id p27-20020a05600c1d9b00b003a5d66e6370mr1433272wms.73.1660726539048;
        Wed, 17 Aug 2022 01:55:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6joZazkqh/7hPdngPGw0ZOIMJpCoIUyVh/yzbAhFI1ASubyybt/XwdZKSVEcy82NUPWtkj5Q==
X-Received: by 2002:a05:600c:1d9b:b0:3a5:d66e:6370 with SMTP id p27-20020a05600c1d9b00b003a5d66e6370mr1433257wms.73.1660726538821;
        Wed, 17 Aug 2022 01:55:38 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id bn21-20020a056000061500b0021e43b4edf0sm12352740wrb.20.2022.08.17.01.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 01:55:37 -0700 (PDT)
Date:   Wed, 17 Aug 2022 04:55:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Message-ID: <20220817045406-mutt-send-email-mst@kernel.org>
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
 <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com>
 <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
 <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com>
 <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
 <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
> Yes it is a little messy, and we can not check _F_VERSION_1 because of
> transitional devices, so maybe this is the best we can do for now

I think vhost generally needs an API to declare config space endian-ness
to kernel. vdpa can reuse that too then.

-- 
MST

