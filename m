Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D80969125F
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 22:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjBIVEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 16:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjBIVEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 16:04:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C851468AE3
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 13:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675976630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=15RBc8Kc+mz08KzRl7Pmij5Fys07bNfCAt+lRMFD2SE=;
        b=E7Ol8LprbdQy0KWjS/RzUJ78QetHTpfeJ+SAtAnmAM+50lVQUbgBUrj+iy3K9nbeNhU8B8
        ikIH+n2vnhwmeOfaky0lB7WWQYHu5qpalY36cuQH5RxCi65RSKP8yurPrJOMIz6Vksx9Fk
        c3nZTWThhWJzZV48HoebsVRWiWINWKw=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-361-JUhGG34bO5qv9M-xBsbojw-1; Thu, 09 Feb 2023 16:03:48 -0500
X-MC-Unique: JUhGG34bO5qv9M-xBsbojw-1
Received: by mail-io1-f71.google.com with SMTP id t185-20020a6bc3c2000000b00733ef3dabe3so2063818iof.14
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 13:03:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=15RBc8Kc+mz08KzRl7Pmij5Fys07bNfCAt+lRMFD2SE=;
        b=u6b22xN8byY7TVNZyj9ua3D1R+wGzA+kiCrf8OVA8FYdK57esR/FnX29r+lxDvaoIL
         69b4EMxwRcm4BKX3BjV4cgO05YlTDLPPBDVqTvY6MoWtCG3L7d1klJr7srIUBM2RmzcJ
         fK00244glqBfQ9ohpubYOVZ/QuQCQ62oVRo7oHbd4SohZKjZ+hQxirUGSURMrIGtjsYz
         8+cquGcQr4xZOGQciHPVkd3+ZJUXclRcWjC+m4LShIiA5E+KIxgBYFe3QYomDECMmuDJ
         4cnqFIt2ahAsyrI7w6XQSMtL98GPUtdUVl8KaEWyE7PGvif3rOgJLUEIKKnOVh+xnY1N
         3gaw==
X-Gm-Message-State: AO0yUKUBgUy1ZUxFFm/IdbVMWPLEa6rCMbg31+/ZSj+lUAsyUa9sw145
        dh6Vh4mQk/Q6DUWEdXq7Q+0SRoKxuoWQNycgJxK4fqmn6/SlzMOszcyX4lEE68lMsf973hu/ZI8
        d/+m7e1BQPElp
X-Received: by 2002:a6b:c41a:0:b0:71f:f480:7ce with SMTP id y26-20020a6bc41a000000b0071ff48007cemr10260119ioa.20.1675976627409;
        Thu, 09 Feb 2023 13:03:47 -0800 (PST)
X-Google-Smtp-Source: AK7set+k0QLN3m5XfBbIR02cUuVhgUszHfZJRKNAfZunZMcrzvUzbT9/eadJzRbUHUQTXY1kO6kPOA==
X-Received: by 2002:a6b:c41a:0:b0:71f:f480:7ce with SMTP id y26-20020a6bc41a000000b0071ff48007cemr10260107ioa.20.1675976627146;
        Thu, 09 Feb 2023 13:03:47 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c5-20020a5ea905000000b0071cbf191687sm698346iod.55.2023.02.09.13.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 13:03:46 -0800 (PST)
Date:   Thu, 9 Feb 2023 14:03:31 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V8 0/7] fixes for virtual address update
Message-ID: <20230209140331.4cdac203.alex.williamson@redhat.com>
In-Reply-To: <1675184289-267876-1-git-send-email-steven.sistare@oracle.com>
References: <1675184289-267876-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Tue, 31 Jan 2023 08:58:02 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Fix bugs in the interfaces that allow the underlying memory object of an
> iova range to be mapped in a new address space.  They allow userland to
> indefinitely block vfio mediated device kernel threads, and do not
> propagate the locked_vm count to a new mm.  Also fix a pre-existing bug
> that allows locked_vm underflow.
> 
> The fixes impose restrictions that eliminate waiting conditions, so
> revert the dead code:
>   commit 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
>   commit 487ace134053 ("vfio/type1: implement notify callback")
>   commit ec5e32940cc9 ("vfio: iommu driver notify callback")
> 
> Changes in V2 (thanks Alex):
>   * do not allow group attach while vaddrs are invalid
>   * add patches to delete dead code
>   * add WARN_ON for never-should-happen conditions
>   * check for changed mm in unmap.
>   * check for vfio_lock_acct failure in remap
> 
> Changes in V3 (ditto!):
>   * return errno at WARN_ON sites, and make it unique
>   * correctly check for dma task mm change
>   * change dma owner to current when vaddr is updated
>   * add Fixes to commit messages
>   * refactored new code in vfio_dma_do_map
> 
> Changes in V4:
>   * misc cosmetic changes
> 
> Changes in V5 (thanks Jason and Kevin):
>   * grab mm and use it for locked_vm accounting
>   * separate patches for underflow and restoring locked_vm
>   * account for reserved pages
>   * improve error messages
> 
> Changes in V6:
>   * drop "count reserved pages" patch
>   * add "track locked_vm" patch
>   * grab current->mm not group_leader->mm
>   * simplify vfio_change_dma_owner
>   * fix commit messages
> 
> Changes in v7:
>   * compare current->mm not group_leader->mm (missed one)
>   * misc cosmetic changes
> 
> Changes in v8:
>   * updated group_leader comment in vfio_dma_do_map
>   * delete async arg from mm_lock_acct
>   * pass async=false to vfio_lock_acct in vfio_pin_page_external
>   * locked_vm becomes size_t
>   * improved commit message in "restore locked_vm"
>   * simplified flow in vfio_change_dma_owner
>   * rebase to v6.2-rc6
> 
> Steve Sistare (7):
>   vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
>   vfio/type1: prevent underflow of locked_vm via exec()
>   vfio/type1: track locked_vm per dma
>   vfio/type1: restore locked_vm
>   vfio/type1: revert "block on invalid vaddr"
>   vfio/type1: revert "implement notify callback"
>   vfio: revert "iommu driver notify callback"
> 
>  drivers/vfio/container.c        |   5 -
>  drivers/vfio/vfio.h             |   7 --
>  drivers/vfio/vfio_iommu_type1.c | 248 ++++++++++++++++++----------------------
>  include/uapi/linux/vfio.h       |  15 ++-
>  4 files changed, 120 insertions(+), 155 deletions(-)
> 

Applied to vfio next branch for v6.3.  Thanks,

Alex

