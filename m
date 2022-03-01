Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218A94C829C
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 05:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbiCAEmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 23:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiCAEl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 23:41:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15D1C6D1A9
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 20:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646109677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jGq8Dmh41qkX8gV/699GWrw+Lo14JacKZ+uwYwx7hDQ=;
        b=Fp6jUlxcBemkWIHFxqze0ca9I+QJrbup0RFz/vbtz56yTPgkcLnnYBJ4nGu1TjAfW8UEtC
        F0ips8Ii4tPmfGKK5mgwV9YH0m4ObIvucTJjC151/0Bmr40NCedgcm1bkfml+jJpJWl3ae
        N0yvOllgD5dmRsQ7S2l/w6O3MUL70u8=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-oa4T9VBUO0KOyBAnJNpCtA-1; Mon, 28 Feb 2022 23:41:15 -0500
X-MC-Unique: oa4T9VBUO0KOyBAnJNpCtA-1
Received: by mail-oi1-f199.google.com with SMTP id v185-20020acaacc2000000b002d471aaaf85so6750384oie.21
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 20:41:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=jGq8Dmh41qkX8gV/699GWrw+Lo14JacKZ+uwYwx7hDQ=;
        b=MQIjmD8Qkf0XYuGyeHDOh97rHgNJk5441IWtbV6g0rwgofuaySpn6K1mB/CoA4S3FY
         1SQ8WJWJaEdTO0djEJ52O5Gz29QfYZhp6w08iTwuQQqDYuQJblyj6qNyq/usiRcmxa2n
         a40SeiBoRUDDAxGAyw4j5szjI2/4JGWvstkXr4s4ZFEB0mf99PmqYanHJNWz10kyRdj4
         xa5LtWUobhO5lwjw3Asw9TQ0iQVyNcKmCjck4gfSFFukR9oCdOKrQivBDscRBLk/o1tk
         X1IP1EwtLfcVUY6n7nvCUBQl9eLhlHYfhOX4AKGt24QvBUfwvdeCtmlpl6Tw/ro6gLtt
         pjTg==
X-Gm-Message-State: AOAM532n7YMtZeRf02wAQspRPp3UKgvmELeb0EyQg9A83GsYK45hGNM3
        AwZFOTDaoZ7gS6b7D7UfAXqfypBQsAJIw/+sVwl6OsPoCSmBifZiVKjgygUCofIbZgxhqAs8FhI
        wfj7tmX7TbVF1
X-Received: by 2002:a05:6870:b48e:b0:d7:4d5:c699 with SMTP id y14-20020a056870b48e00b000d704d5c699mr2773426oap.147.1646109674849;
        Mon, 28 Feb 2022 20:41:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycyJ3iAfaRvwmjO5WhynnB4A7j2A1WmGmdOXzwukRUAQKhXEEotWgp5WXl4fbMFoC7rhHeZw==
X-Received: by 2002:a05:6870:b48e:b0:d7:4d5:c699 with SMTP id y14-20020a056870b48e00b000d704d5c699mr2773417oap.147.1646109674584;
        Mon, 28 Feb 2022 20:41:14 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m7-20020a9d6447000000b005acf7e4c507sm5866303otl.20.2022.02.28.20.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 20:41:14 -0800 (PST)
Date:   Mon, 28 Feb 2022 21:41:10 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220228214110.4deb551f.alex.williamson@redhat.com>
In-Reply-To: <20220228234709.GV219866@nvidia.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
        <20220228090121.1903-10-shameerali.kolothum.thodi@huawei.com>
        <20220228145731.GH219866@nvidia.com>
        <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
        <20220228180520.GO219866@nvidia.com>
        <20220228131614.27ad37dc.alex.williamson@redhat.com>
        <20220228202919.GP219866@nvidia.com>
        <20220228142034.024e7be6.alex.williamson@redhat.com>
        <20220228234709.GV219866@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Feb 2022 19:47:09 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 28, 2022 at 02:20:34PM -0700, Alex Williamson wrote:
> 
> > > Unless you think we should block it.  
> > 
> > What's the meaning of initial_bytes and dirty_bytes while in
> > STOP_COPY?  
> 
> Same as during pre-copy - both numbers are the bytes remaining to be
> read() from the FD in each bucket. They should continue to decline as
> read() progresses regardless of what state the data_fd is in.
> 
> The only special thing about STOP_COPY is that dirty_bytes should not
> increase as the device should not be generating new dirty data.
> 
> How about:
> 
>  * Drivers should attempt to return estimates so that initial_bytes +
>  * dirty_bytes matches the amount of data an immediate transition to STOP_COPY
>  * will require to be streamed. While in STOP_COPY the initial_bytes
>  * and dirty_bytes should continue to be decrease as the data_fd
>  * progresses streaming out the data.
> 
> Remove the 'in the precopy phase' from the first sentance
> 
> Adjust the last paragraph as:
> 
> + * returning readable. ENOMSG may not be returned in STOP_COPY. Support
> + * for this ioctl is required when VFIO_MIGRATION_PRE_COPY is set.

This entire ioctl on the data_fd seems a bit strange given the previous
fuss about how difficult it is for a driver to estimate their migration
data size.  Now drivers are forced to provide those estimates even if
they only intend to use PRE_COPY as an early compatibility test?

Obviously it's trivial for the acc driver that doesn't support dirty
tracking and only has a fixed size migration structure, but it seems to
contradict your earlier statements.  For instance, can mlx5 implement
a PRE_COPY solely for compatibility testing or is it blocked by an
inability to provide data estimates for this ioctl?

Now if we propose that this ioctl is useful during the STOP_COPY phase,
how does a non-PRE_COPY driver opt-in to that beneficial use case?  Do
we later add a different, optional ioctl for non-PRE_COPY and then
require userspace to support two different methods of getting remaining
data estimates for a device in STOP_COPY?

If our primary goal is to simplify the FSM, I'm actually a little
surprised we support the PRE_COPY* -> STOP_COPY transition directly
versus passing through STOP.  It seems this exists due to our policy
that we can only generate one data_fd as a result of any sequence of
state transitions, but I think there might also be an option to achieve
similar if the PRE_COPY* states are skipped if they aren't the ultimate
end state of the arc.  I'm sure that raises questions about how we
correlate a PRE_COPY* session to a STOP_COPY session though, but this
PRE_COPY* specific but ongoing usage in STOP_COPY ioctl seems ad-hoc.
Thanks,

Alex

