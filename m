Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B342C63B1F4
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 20:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbiK1TNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 14:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiK1TNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 14:13:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966421B9E0
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 11:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669662764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=laiMLZDaOVByc2Tcnom+DTWx/4jSS/rm3aOTN+j/w2o=;
        b=KE8bK1kiUPa3YfCJTKV8+krky5On2mbsianXIBGTaBp45RP0vvFXv/lXJNwwlFIFZWceH9
        yZxwcRArYPRKCXuI6utTo5MFxjUph2wBc2FyKgwsu7p+0+Ea7vB0DoM1ZvaR/EVbBzvaHp
        pqRW39d4CMfDc0NzK7oZYaIcLwXz3pA=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-231-oP9lj5ZEP3OJO7GIGU7Rsg-1; Mon, 28 Nov 2022 14:12:43 -0500
X-MC-Unique: oP9lj5ZEP3OJO7GIGU7Rsg-1
Received: by mail-io1-f72.google.com with SMTP id g23-20020a6b7617000000b006df9f243c1bso660905iom.20
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 11:12:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=laiMLZDaOVByc2Tcnom+DTWx/4jSS/rm3aOTN+j/w2o=;
        b=1qmaZANauTDnBR1EppNLj6If+yK3fwGtShyKie6bNEDcy5ea0i4PPSbGXFFr4z5b76
         wwJWOJeeN/qwj73P+wbW7mUDt5EiERHEKc0iTEFCz3ADb7Syr4t9cjEQy7yRRhtknMQV
         Q2ztXYjZZpMgNX8M/uPC+kuGfVdbss/DICVssj+md1WoOULwbxProPoZ01ouEfPLNpTP
         UaccbIVDo+CD5EjFjX1ZeOmEsXfJAzS0eqts4FSRFDvsZzEYW54HFFaWsQUs5cp3b1qy
         6pv5ttC4O8DwoHcP2Eq89ojEXRPEjd905m994U1e2E1EQUuGwwoY9dhtDvqjTnO8NJH7
         KIhw==
X-Gm-Message-State: ANoB5pkyhf9PABsp10jtMLViSYA6SUQYgBo7WrvV1SPOT53DuTXLWKW3
        Z91u/bU+lUK9n9XePTIkhkbzjOzrdNi1QWMmECxelOqlinze9yW6jktFfnq791vxcv10k6R054s
        0k5Kc9wfotJP1
X-Received: by 2002:a5e:c64a:0:b0:6cc:e295:7bde with SMTP id s10-20020a5ec64a000000b006cce2957bdemr15381764ioo.183.1669662762114;
        Mon, 28 Nov 2022 11:12:42 -0800 (PST)
X-Google-Smtp-Source: AA0mqf71A/TLogb9bRidmXwksIPdOXOFnvCZ0AyB2LS3YdqFdT1O/O2VFtxoJ6W7E3uuH3K6PQapIw==
X-Received: by 2002:a5e:c64a:0:b0:6cc:e295:7bde with SMTP id s10-20020a5ec64a000000b006cce2957bdemr15381752ioo.183.1669662761920;
        Mon, 28 Nov 2022 11:12:41 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p3-20020a92d483000000b0030014a5556bsm4021960ilg.69.2022.11.28.11.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 11:12:41 -0800 (PST)
Date:   Mon, 28 Nov 2022 12:12:40 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH] vfio/iova_bitmap: refactor iova_bitmap_set() to better
 handle page boundaries
Message-ID: <20221128121240.333d679d.alex.williamson@redhat.com>
In-Reply-To: <20221125172956.19975-1-joao.m.martins@oracle.com>
References: <20221125172956.19975-1-joao.m.martins@oracle.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Nov 2022 17:29:56 +0000
Joao Martins <joao.m.martins@oracle.com> wrote:

> Commit f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
> had fixed the unaligned bitmaps by capping the remaining iterable set at
> the start of the bitmap. Although, that mistakenly worked around
> iova_bitmap_set() incorrectly setting bits across page boundary.
> 
> Fix this by reworking the loop inside iova_bitmap_set() to iterate over a
> range of bits to set (cur_bit .. last_bit) which may span different pinned
> pages, thus updating @page_idx and @offset as it sets the bits. The
> previous cap to the first page is now adjusted to be always accounted
> rather than when there's only a non-zero pgoff.
> 
> While at it, make @page_idx , @offset and @nbits to be unsigned int given
> that it won't be more than 512 and 4096 respectively (even a bigger
> PAGE_SIZE or a smaller struct page size won't make this bigger than the
> above 32-bit max). Also, delete the stale kdoc on Return type.
> 
> Cc: Avihai Horon <avihaih@nvidia.com>
> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

Should this have:

Fixes: f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")

?
Thanks,
Alex

