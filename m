Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48AAA780147
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 00:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355861AbjHQWtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 18:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355874AbjHQWt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 18:49:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA5F2723
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 15:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692312521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AXs83oe+jiUngsGC+iU+QF+/YIyq3LUwh3cj5wAqVM8=;
        b=aJcVZnpglKKNibeOQT0RjjKeykymD5em8j5UFIhQi2qVpaiWz0lWaiEfKVZiHVBP0kAxen
        x08hFdqNTfGN1Ra40i2uNzKExu7w1TKZrpPur2x5EOhMndasw8Gvl1Y7X/HTAyIOe/QJue
        9Dm+1eVAyQ2j2dbr3TlHP+41nDD6g+s=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-NeVdI9EiMEKgT9OXa717cw-1; Thu, 17 Aug 2023 18:48:39 -0400
X-MC-Unique: NeVdI9EiMEKgT9OXa717cw-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3a741f4790fso323126b6e.0
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 15:48:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692312519; x=1692917319;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AXs83oe+jiUngsGC+iU+QF+/YIyq3LUwh3cj5wAqVM8=;
        b=NWRTJfLzK/KosVVOFYDoFK5E4B89aiRrs8+69SsGc2+iRFNP3EHSTKJGysWW2BbW7k
         AQ7HlHOEhxWzc6uFxCkp0xmMwxUE1QgjXXbshgyHg2jKV9hG+X+2k6cbppg1kgbK2lb4
         RXF6Mj0BHQCZhxU1N3YBQPWzp8EP7H7uMd0oJeVk/oqoeRG6Tn465R/olauYOu+ar2B9
         q3Y65qtbHKBGhu4y/hhn3Zq6dvNwtCja8EjsjPeJOB1HlN50iQKsFug3R4xSMtb0hafm
         lKR2Kw/nnoUxyWtmFFfvnjSP5R+ZhGjbo6LuMXAXsr9ZeHtfHjY3WelkKNZFVQKflYgX
         OScw==
X-Gm-Message-State: AOJu0YznVKEhLmG6MS1k7sn1YawFk4nLWv7v1D9fecGRDyRLLqJRAIrP
        xIamrsZqw9c4hY9ULm0vUfi+X1Vo3IxOYBeRpMkoBByr2b+KJSW4kjkfUo3dhea7KtG7e9Rf70W
        5cOG51r1lkxMC
X-Received: by 2002:a05:6870:c6a8:b0:1bf:ce5b:436 with SMTP id cv40-20020a056870c6a800b001bfce5b0436mr1043385oab.58.1692312518925;
        Thu, 17 Aug 2023 15:48:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgQU++51ftwhQ+Snud+8ZeqO8TZK2RxDc98dX0vPi5MbvU8WbZ3C+GYYuWCEGXKJRiM1igZQ==
X-Received: by 2002:a05:6870:c6a8:b0:1bf:ce5b:436 with SMTP id cv40-20020a056870c6a800b001bfce5b0436mr1043371oab.58.1692312518692;
        Thu, 17 Aug 2023 15:48:38 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id n7-20020a4a4007000000b0055516447257sm224025ooa.29.2023.08.17.15.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 15:48:38 -0700 (PDT)
Date:   Thu, 17 Aug 2023 16:48:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     liulongfang <liulongfang@huawei.com>
Cc:     <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v13 0/4] add debugfs to migration driver
Message-ID: <20230817164835.5c219dc0.alex.williamson@redhat.com>
In-Reply-To: <20230816094205.37389-1-liulongfang@huawei.com>
References: <20230816094205.37389-1-liulongfang@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Aug 2023 17:42:01 +0800
liulongfang <liulongfang@huawei.com> wrote:

> Add a debugfs function to the migration driver in VFIO to provide
> a step-by-step test function for the migration driver.
> 
> When the execution of live migration fails, the user can view the
> status and data during the migration process separately from the
> source and the destination, which is convenient for users to analyze
> and locate problems.
> 
> Changes v12 -> v13
> 	Solve the problem of open and close competition to debugfs.

Hi,

I'm not sure if the new To: list is a mistake or if this is an appeal
to a different set of maintainers for a more favorable response than
previous postings[1], but kvm@vger.kernel.org remains the list for this
driver, which is under the perview of vfio [adding the correct list and
co-maintainer].

I believe there is still a concern whether this is a valid and
worthwhile debugfs interface.  It has been suggested that much of what
this provides could be done through userspace drivers to exercise the
migration interfaces and/or userspace debugging techniques to examine
the device migration data.  I haven't seen a satisfactory conclusion
for these comments yet.

I think we have general consensus that the first couple patches are ok
and useful, exposing the migration state generically and supporting a
minor cleanup within the hisi_acc driver.  However, the new approach to
try to lock the device with igate is certainly not the correct (igate
is used for serializing interrupt configuration) and the proposed
hisi_acc specific debugfs interfaces themselves are not settled.
Thanks,

Alex

[1]https://lore.kernel.org/all/20230728072104.64834-1-liulongfang@huawei.com/

