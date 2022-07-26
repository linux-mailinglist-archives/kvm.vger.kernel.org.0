Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2E25813F7
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 15:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbiGZNNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 09:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238676AbiGZNNP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 09:13:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2900C27CFD
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 06:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658841193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8lGwWcKgXjbZMsb7f3KkrDpC0QKsfV0t/BrUUpRw1V4=;
        b=hPIXgHhMNEhuwgX4QAf18nSkRyy5VQ+DKwzlquK3CvMI2dcAYRkDb9AewNn+5Ufed6QrCi
        GueLSA/6P23iPrOTgLY5yIzhvBMdASe7Jq4GGIpHiQ0WaAr7463I8OLVo53GWmR9nc/UVf
        LxeMjqCVmFG7Duo70rss7ngpKbmYBFY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-ZNs6M0RYMWmMFdM8eCT6vg-1; Tue, 26 Jul 2022 09:13:10 -0400
X-MC-Unique: ZNs6M0RYMWmMFdM8eCT6vg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48F57802D1C;
        Tue, 26 Jul 2022 13:13:09 +0000 (UTC)
Received: from localhost (unknown [10.39.192.224])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EECF81415118;
        Tue, 26 Jul 2022 13:13:08 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 1/5] vfio: Add the device features for the low power
 entry and exit
In-Reply-To: <bd7bca18-ae07-c04a-23d3-bf71245da0cc@nvidia.com>
Organization: Red Hat GmbH
References: <20220719121523.21396-1-abhsahu@nvidia.com>
 <20220719121523.21396-2-abhsahu@nvidia.com>
 <20220721163445.49d15daf.alex.williamson@redhat.com>
 <aaef2e78-1ed2-fe8b-d167-8ea2dcbe45b6@nvidia.com>
 <20220725160928.43a17560.alex.williamson@redhat.com>
 <bd7bca18-ae07-c04a-23d3-bf71245da0cc@nvidia.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Tue, 26 Jul 2022 15:13:07 +0200
Message-ID: <87fsiom2zg.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 26 2022, Abhishek Sahu <abhsahu@nvidia.com> wrote:

>  #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
>  
>  /*
>   * Upon VFIO_DEVICE_FEATURE_SET, disallow use of device low power states as
>   * previously enabled via VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device features.
>   * This device feature IOCTL may itself generate a wakeup eventfd notification
>   * in the latter case if the device has previously entered a low power state.

Nit: s/has/had/

>   */
>  #define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5

I haven't followed this closely, and I'm not that familiar with power
management, but at least I can't spot anything obviously problematic.

