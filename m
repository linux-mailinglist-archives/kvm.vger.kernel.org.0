Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B3D5A4B4E
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 14:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiH2MPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 08:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiH2MOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 08:14:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD81385ABD
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 04:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661774292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ab0J6P8U/r6Cnl9kTb0FuzLIbBDJFAgg8fopygncHGw=;
        b=D/OE02cDa4oaKtC0I1NaK8HgHiuUfcJ8iTiGaNLLoZPJ2WgmnLvTEzfzjsYnH1aopd3lxd
        6/tVqke5HbqVXNJgusp7npjl8GmJ0BiqmJek8OP6N47dCQnvzCVlc88+ZL4ww2jrMWOqAf
        t+cbqG/0XZe5aphUG0OF5Z269wIbT/g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-IBrt8wSlOUW-IabNN1aDlA-1; Mon, 29 Aug 2022 07:47:51 -0400
X-MC-Unique: IBrt8wSlOUW-IabNN1aDlA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E688380673F;
        Mon, 29 Aug 2022 11:47:51 +0000 (UTC)
Received: from localhost (unknown [10.39.193.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 100C6C15BBA;
        Mon, 29 Aug 2022 11:47:50 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v2 1/3] vfio/pci: Split linux/vfio_pci_core.h
In-Reply-To: <1-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <1-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Mon, 29 Aug 2022 13:47:49 +0200
Message-ID: <877d2rfeze.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> The header in include/linux should have only the exported interface for
> other vfio_pci module's to use.  Internal definitions for vfio_pci.ko

s/module's/modules/

> should be in a "priv" header along side the .c files.
>
> Move the internal declarations out of vfio_pci_core.h. They either move to
> vfio_pci_priv.h or to the C file that is the only user.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c        |   2 +-
>  drivers/vfio/pci/vfio_pci_config.c |   2 +-
>  drivers/vfio/pci/vfio_pci_core.c   |  19 +++-
>  drivers/vfio/pci/vfio_pci_igd.c    |   2 +-
>  drivers/vfio/pci/vfio_pci_intrs.c  |  16 +++-
>  drivers/vfio/pci/vfio_pci_priv.h   | 106 +++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_rdwr.c   |   2 +-
>  drivers/vfio/pci/vfio_pci_zdev.c   |   2 +-
>  include/linux/vfio_pci_core.h      | 134 +----------------------------
>  9 files changed, 145 insertions(+), 140 deletions(-)
>  create mode 100644 drivers/vfio/pci/vfio_pci_priv.h

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

