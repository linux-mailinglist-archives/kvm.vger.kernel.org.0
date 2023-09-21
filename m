Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50877A9F11
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjIUURM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjIUUQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:16:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25E3100E39
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 12:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695323853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M4F18HtJIvSpDrNeybXoV/nJvscTALrB3uUN04vezK4=;
        b=QswvVca7QsTH3I6rOK4VQ0KIx87Qo8xM9dBfN6xx12LfrtSmIGEooZfxNmhEYjYDMfYeEX
        H/eAbHx371fQhILYeezR3r6XnDx2S7/RTSbl7/spdPM8pUfAxAq/YS3fcZZ2U6zzfaRc7i
        4ZAdwALwChtFjIah0Nz2n1I3N06C3kk=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56--ZUWTkr9OtGMoH5QG94USA-1; Thu, 21 Sep 2023 15:17:32 -0400
X-MC-Unique: -ZUWTkr9OtGMoH5QG94USA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2bff8e92054so19150141fa.2
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 12:17:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695323851; x=1695928651;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M4F18HtJIvSpDrNeybXoV/nJvscTALrB3uUN04vezK4=;
        b=UaL/ORWoTb9iB4pNGoyx6zzccXv4qniL3DvWAX+GAPhlp5AsLedEMjYu3m4Q1YfHzC
         geNgXC6yKg6P/wL3wAqhpsohoO7+LrJjvXTdwTN7W2QeJ5U+Ujn48OKjt5Kcn9tQhHT4
         3/MAgMuVaF1B9jI1Zk8e1YntT4sUtXVaWRGUn58HurHZZICoqDDVsaSPr8k7XlrU4H66
         3wMrOaQ/fVktuNoNnHClphhUJZWfmbtFxsRKlDHjOzoBJuZpklgpACehOCWMfpA0cKCD
         RFYKOvRMOr/n/5EXmbdweavU9F+DBu9D6522AP9m3OqH3D+pcPNa8KoNwm3cb5Ym43Gs
         Z9rQ==
X-Gm-Message-State: AOJu0YzyE0r2Nq2IT7HpJhbScHKwMQ/hX44KsvVSfqmGiDTXERj3Z39q
        eWGpYN7z1UC7YQRgv09T3Vbtv4dlhoIhPBioPve/tzLZvfTUPjGyubDyxLNprGFnntNUTe31tow
        eHEVsN3dRVGwd
X-Received: by 2002:a05:6512:34c9:b0:503:333e:b387 with SMTP id w9-20020a05651234c900b00503333eb387mr5157541lfr.41.1695323850808;
        Thu, 21 Sep 2023 12:17:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLO6U0t/NII2ddctv8iFsd2bsjD4CmnkBmvFzO3e8EHefAPfb77ysHKgmXf03wCOOWJP3JWg==
X-Received: by 2002:a05:6512:34c9:b0:503:333e:b387 with SMTP id w9-20020a05651234c900b00503333eb387mr5157528lfr.41.1695323850453;
        Thu, 21 Sep 2023 12:17:30 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id e23-20020a056402089700b00530bc7cf377sm1218240edy.12.2023.09.21.12.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 12:17:29 -0700 (PDT)
Date:   Thu, 21 Sep 2023 15:17:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921151325-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921183926.GV13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 03:39:26PM -0300, Jason Gunthorpe wrote:
> > What is the huge amount of work am I asking to do?
> 
> You are asking us to invest in the complexity of VDPA through out
> (keep it working, keep it secure, invest time in deploying and
> debugging in the field)

I'm asking you to do nothing of the kind - I am saying that this code
will have to be duplicated in vdpa, and so I am asking what exactly is
missing to just keep it all there. So far you said iommufd and
note I didn't ask you to add iommufd to vdpa though that would be nice ;)
I just said I'll look into it in the next several days.

-- 
MST

