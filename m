Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF8E57A2F4
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 17:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbiGSP05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 11:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbiGSP0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 11:26:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA2C8481C8
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 08:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658244408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G7zzeWeOFiX/qPfQUEc/yUHAFf2sghiN9c5AjnoHblQ=;
        b=iVMiytTyIP/wTT9Jb0TITimeGlntljxz8hduAQHAHXnseuu+x00ZSym3AHL8LJIYAeW8GT
        OcTtasDACdxflZEEtfzt48XnRE1jJIRJO7AAVM/6DdF5hG/nB28nGRCLvhOX+y9wPcNJr6
        xrpXI/76wmHZ+J4kvKxLEj1KG5YQRV4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-fq0ivay3OgGDOpIqvLmESw-1; Tue, 19 Jul 2022 11:26:47 -0400
X-MC-Unique: fq0ivay3OgGDOpIqvLmESw-1
Received: by mail-io1-f72.google.com with SMTP id t3-20020a5d81c3000000b0067bcd25f108so6941069iol.4
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 08:26:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=G7zzeWeOFiX/qPfQUEc/yUHAFf2sghiN9c5AjnoHblQ=;
        b=oLC0phrTILGLKzRZBpSj9DxK9EjxCDKL0BxCNjizqGUs9y6ElxoKZO5gyq8WvA5ixO
         ZbXhHRgDw82hEqAJWINwYO6krsMUjvV1MGkOEg0qm2i1vBLkOxo5BA2nmwMHlLJ/jE4W
         X7VSfkj8jcZYPkkEuvuJN/Y7zjh6HndmvDvCEtTc63T+f9yx5avRfUPR9NvQ1X5sKS2L
         wleUTmRryKFZ03T6pNt5OzclVkVsB9anIOJC0XSBq07P6/grNEIIw1EQT1YlhEg9efKo
         KjaA7noUL7wqiXbpEnOLY6thhZbhTDZH8PLhqse3oapM3DaEBUjMGh1vsSbHNxuDFupY
         VJkQ==
X-Gm-Message-State: AJIora9Zn5T2tHHor9uo2RsKAq3Yv0uBiot5RqFB2qAYpZV4vTUwKsb7
        vo6UH4Vkeb5Z45RErx+MqXTOAJ8N4cEwNkv5zVpVoqfyvhPNzksYkZ4uoAO30tKocHmEmL7BlgP
        KkHfExELNNi3a
X-Received: by 2002:a05:6638:348c:b0:33f:82b2:7441 with SMTP id t12-20020a056638348c00b0033f82b27441mr17856990jal.296.1658244406585;
        Tue, 19 Jul 2022 08:26:46 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sCP7legSjso0LeShf9Ua6sFhO1nc12IEp69v7ovtogZn2d+6QLUaad2RzcOZuMrXJv8UG/8A==
X-Received: by 2002:a05:6638:348c:b0:33f:82b2:7441 with SMTP id t12-20020a056638348c00b0033f82b27441mr17856977jal.296.1658244406330;
        Tue, 19 Jul 2022 08:26:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t2-20020a92cc42000000b002dcf927087asm1345647ilq.65.2022.07.19.08.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 08:26:45 -0700 (PDT)
Date:   Tue, 19 Jul 2022 09:26:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Subject: Re: simplify the mdev interface v6
Message-ID: <20220719092644.3db1ceee.alex.williamson@redhat.com>
In-Reply-To: <20220719144928.GB21431@lst.de>
References: <20220709045450.609884-1-hch@lst.de>
        <20220718054348.GA22345@lst.de>
        <20220718153331.18a52e31.alex.williamson@redhat.com>
        <1f945ef0eb6c02079700a6785ca3dd9864096b82.camel@linux.ibm.com>
        <20220719144928.GB21431@lst.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jul 2022 16:49:28 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Jul 18, 2022 at 10:01:40PM -0400, Eric Farman wrote:
> > I'll get the problem with struct subchannel [1] sorted out in the next
> > couple of days. This series breaks vfio-ccw in its current form (see
> > reply to patch 14), but even with that addressed the placement of all
> > these other mdev structs needs to be handled differently.  
> 
> Alex, any preference if I should just fix the number instances checking
> with either an incremental patch or a resend, or wait for this ccw
> rework?

Since it's the last patch, let's at least just respin that patch rather
than break and fix.  I'd like to make sure Eric is ok to shift around
structures as a follow-up or make a proposal how this series should
change though.  Thanks,

Alex

