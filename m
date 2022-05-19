Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85B552D9BD
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 18:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241691AbiESQEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 12:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbiESQEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 12:04:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E29A057141
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652976284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cn9DGsidYHLKIgSfwQZyuGk5MNvO4cusQzW9CGpB6cM=;
        b=LbpIyEBfDzOPyhC6wR+8x3Ti/ZW1M5DVKCgkmDEkN4V7KPUxzB7bNRfEKnMwgwR2flI5jj
        4szAcoTzQYhvfUvDB7TAhE4iO5/fc8Yj2FCtYlLOfnGCykD63w7AtiRN2os2KBz7ZzDhbT
        pfcbUKVLinHBMQM631RHl8TVOnzK2JQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-7ojEZJgSMiSRSdArIuqXag-1; Thu, 19 May 2022 12:04:42 -0400
X-MC-Unique: 7ojEZJgSMiSRSdArIuqXag-1
Received: by mail-qk1-f200.google.com with SMTP id c8-20020a05620a268800b0069c0f1b3206so4456625qkp.18
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:04:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cn9DGsidYHLKIgSfwQZyuGk5MNvO4cusQzW9CGpB6cM=;
        b=w6N4IWhCMvgMIY0+ErfX0zXovHDKkSdeQaEiHZZgBrA3C0zHx7WuQIpb1rcbGwEKkK
         l0BCu1BfFgqlW8l+wwjipasyZPLxJmowap0nvY8dr6JhHu35svWG5tgFPUXWbhJIk4a8
         N+mxgP0D5UvQCOGquyZPczJ1Xe+b8G7H5cIRFyy4fmC09Vc0M6COK3avO1AIu/KnsyQ7
         4RsxfsE5OjKdVJdWK7xyC0bNhqQWqZ8vfs+LE7ogkLPRknvHayNAAo4xK/MUoXPB3OVE
         lQ/6qfHEseQkBEMXkUyqH3XTDu92J2UAzxMFT4yKdzTQuWpWVwUJp76lgfJCaetDoZbc
         aaYg==
X-Gm-Message-State: AOAM530LzTAamNdm945jWhV5BpFfpbp28KgVSinq4AojGjeoQq1yzjPI
        SmyCMZKG4JhdtUMGqOia38PJGligrCq1w+ETreqSYEHpHfm9Yf4Aacstn+UkWZK1zre9WuccMcp
        i6vdqI+bK4A8E
X-Received: by 2002:a05:620a:29c2:b0:6a0:5fac:2f45 with SMTP id s2-20020a05620a29c200b006a05fac2f45mr3340494qkp.529.1652976282231;
        Thu, 19 May 2022 09:04:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2Oj1i3ECAaRC8bD7Zm1tmm+5AblYIrHtBAeojqUV3W8R84H9LagTNe0ivlgrCeQ6ZxU1Wmw==
X-Received: by 2002:a05:620a:29c2:b0:6a0:5fac:2f45 with SMTP id s2-20020a05620a29c200b006a05fac2f45mr3340446qkp.529.1652976281677;
        Thu, 19 May 2022 09:04:41 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id z10-20020ac87f8a000000b002f39b99f6a3sm1590625qtj.61.2022.05.19.09.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 09:04:41 -0700 (PDT)
Date:   Thu, 19 May 2022 18:04:34 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     mst@redhat.com, jasowang@redhat.com, lvivier@redhat.com,
        netdev@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        parav@nvidia.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, lingshan.zhu@intel.com,
        linux-kernel@vger.kernel.org, gdawar@xilinx.com
Subject: Re: [PATCH v2] vdpasim: allow to enable a vq repeatedly
Message-ID: <20220519160434.5s5jzwdmajewpqvg@sgarzare-redhat>
References: <20220519145919.772896-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220519145919.772896-1-eperezma@redhat.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 04:59:19PM +0200, Eugenio Pérez wrote:
>Code must be resilient to enable a queue many times.
>
>At the moment the queue is resetting so it's definitely not the expected
>behavior.
>
>v2: set vq->ready = 0 at disable.
>
>Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
>Cc: stable@vger.kernel.org
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> drivers/vdpa/vdpa_sim/vdpa_sim.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

