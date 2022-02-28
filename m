Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DBE4C7CEF
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 23:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiB1WHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 17:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiB1WHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 17:07:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E18E9C4B55
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 14:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646085998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d94j7lxxX5y02+A6WG5OxYm+EuL2bPwYE+feweTMi6I=;
        b=J0ohMJ9U4ZN2kRr3Weze39lKaA2qodgnMc2U8kKg2jj2hagwo7Z89eTVrnJTmbp9kN8iQp
        h6WAvdENA2NstwlRqY7ftZc5uM+XFeiHJEt+qmcrDz8x3bA8qd0uSU9A6L6rBA9ZutRL1g
        jHofp/lyat83++zOLirrqDWEJrhor9o=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-w9k_7iMoMxqjgwJcL3oujQ-1; Mon, 28 Feb 2022 17:06:36 -0500
X-MC-Unique: w9k_7iMoMxqjgwJcL3oujQ-1
Received: by mail-ot1-f69.google.com with SMTP id l23-20020a056830239700b005ad40210ca2so9955582ots.3
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 14:06:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d94j7lxxX5y02+A6WG5OxYm+EuL2bPwYE+feweTMi6I=;
        b=NRiasTOhGq28VjmjpYxiccfaYyuEUQKINrtjZnD3odNcidwipAFk7CQWzUjfPaImSB
         F5dYCI1XT4SOvIhSuYjMJGtkiAmr3AqCdsS5V5saXy5OfyCNAlKlfm70Olb7POk/OiS7
         B0tvCkHm2F6fKkTcB8+JluTu1eDMC1zIwcNxeGTyR+m0m7XzONH9ALwHpe9MZq40j8Xa
         enkbttk+CiiX3T6J9bcIkn6ivbEdMxkUbtGujonNFDG0fm3LKxXcbisk4LmXMwM3kkNA
         H8/3TW9+I77uD8LlKeZohffNByJiYXpFlyC/aR7bhY45PeQOR+gUQyOj1Z0Ol66bc2fF
         /GWA==
X-Gm-Message-State: AOAM53078KAjyZKXNHRufGyszvkYiSREpV6ZC95ARFg4Z9YdEXoh6hKY
        +Pp+G2SkxIAQvrZPaGytsnUdt13zYLYA2yO5Q3usXWf4g+h6FXdsW3VI2w7meIdjMt/D9kjgCzP
        12iSqXwmemqHN
X-Received: by 2002:a05:6808:1586:b0:2d5:1211:5785 with SMTP id t6-20020a056808158600b002d512115785mr10690614oiw.0.1646085995965;
        Mon, 28 Feb 2022 14:06:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLGQUBEm26I4XhzS9O0hC1lMHUwWYT/sXCYb5vTAfKM0mj7adVygonLblatFgJDlUF3+gebg==
X-Received: by 2002:a05:6808:1586:b0:2d5:1211:5785 with SMTP id t6-20020a056808158600b002d512115785mr10690580oiw.0.1646085995791;
        Mon, 28 Feb 2022 14:06:35 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m21-20020a056820051500b0031d0841b87esm5371712ooj.34.2022.02.28.14.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 14:06:35 -0800 (PST)
Date:   Mon, 28 Feb 2022 15:06:33 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 10/11] vfio: Remove iommu group notifier
Message-ID: <20220228150633.3438200c.alex.williamson@redhat.com>
In-Reply-To: <20220228005056.599595-11-baolu.lu@linux.intel.com>
References: <20220228005056.599595-1-baolu.lu@linux.intel.com>
        <20220228005056.599595-11-baolu.lu@linux.intel.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
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

On Mon, 28 Feb 2022 08:50:55 +0800
Lu Baolu <baolu.lu@linux.intel.com> wrote:

> The iommu core and driver core have been enhanced to avoid unsafe driver
> binding to a live group after iommu_group_set_dma_owner(PRIVATE_USER)
> has been called. There's no need to register iommu group notifier. This
> removes the iommu group notifer which contains BUG_ON() and WARN().
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 147 --------------------------------------------
>  1 file changed, 147 deletions(-)

Acked-by: Alex Williamson <alex.williamson@redhat.com>

