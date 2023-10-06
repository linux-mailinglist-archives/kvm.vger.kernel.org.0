Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2FAB7BB5F7
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 13:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjJFLIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 07:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjJFLIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 07:08:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C526783
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 04:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696590468;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=r1A2X3DRHnkezZCoqIfTELZbBShKBtMABNcNwGcyuVY=;
        b=hSZil3x9gjwzMz9TrHtY0eiSb8xBlZUHppEdPU/j9yY9bjk1ymo4QemY63BhFQXPcJjRu2
        exL4DqK109lWHET/RTc7czqTz9+ePH/f8jc0zocIV/bOhVBeNxd9OdYEKn1nm84w7jCqt4
        ypT3OBrP00P/evHNfK1Y+zO+q1U9vrY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-whKW8SQiPfOLG6wNl6Q6zw-1; Fri, 06 Oct 2023 07:07:35 -0400
X-MC-Unique: whKW8SQiPfOLG6wNl6Q6zw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D4808007A4;
        Fri,  6 Oct 2023 11:07:34 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01A4B1054FC0;
        Fri,  6 Oct 2023 11:07:31 +0000 (UTC)
Date:   Fri, 6 Oct 2023 12:07:29 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        isaku.yamahata@gmail.com, Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: Re: [RFC PATCH v2 02/21] RAMBlock: Add support of KVM private gmem
Message-ID: <ZR/qcetI22X/O1aW@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <20230914035117.3285885-3-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230914035117.3285885-3-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023 at 11:50:58PM -0400, Xiaoyao Li wrote:
> From: Chao Peng <chao.p.peng@linux.intel.com>
> 
> Add KVM gmem support to RAMBlock so both normal hva based memory
> and kvm gmem fd based private memory can be associated in one RAMBlock.
> 
> Introduce new flag RAM_KVM_GMEM. It calls KVM ioctl to create private
> gmem for the RAMBlock when it's set.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  accel/kvm/kvm-all.c     | 17 +++++++++++++++++
>  include/exec/memory.h   |  3 +++
>  include/exec/ramblock.h |  1 +
>  include/sysemu/kvm.h    |  2 ++
>  softmmu/physmem.c       | 18 +++++++++++++++---
>  5 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 60aacd925393..185ae16d9620 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -4225,3 +4225,20 @@ void query_stats_schemas_cb(StatsSchemaList **result, Error **errp)
>          query_stats_schema_vcpu(first_cpu, &stats_args);
>      }
>  }
> +
> +int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp)
> +{
> +    int fd;
> +    struct kvm_create_guest_memfd gmem = {
> +        .size = size,
> +        /* TODO: to decide whether KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is supported */
> +        .flags = flags,
> +    };
> +
> +    fd = kvm_vm_ioctl(kvm_state, KVM_CREATE_GUEST_MEMFD, &gmem);
> +    if (fd < 0) {
> +        error_setg_errno(errp, errno, "%s: error creating kvm gmem\n", __func__);
> +    }
> +
> +    return fd;
> +}
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 68284428f87c..227cb2578e95 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -235,6 +235,9 @@ typedef struct IOMMUTLBEvent {
>  /* RAM is an mmap-ed named file */
>  #define RAM_NAMED_FILE (1 << 9)
>  
> +/* RAM can be private that has kvm gmem backend */
> +#define RAM_KVM_GMEM    (1 << 10)
> +
>  static inline void iommu_notifier_init(IOMMUNotifier *n, IOMMUNotify fn,
>                                         IOMMUNotifierFlag flags,
>                                         hwaddr start, hwaddr end,
> diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
> index 69c6a5390293..0d158b3909c9 100644
> --- a/include/exec/ramblock.h
> +++ b/include/exec/ramblock.h
> @@ -41,6 +41,7 @@ struct RAMBlock {
>      QLIST_HEAD(, RAMBlockNotifier) ramblock_notifiers;
>      int fd;
>      uint64_t fd_offset;
> +    int gmem_fd;
>      size_t page_size;
>      /* dirty bitmap used during migration */
>      unsigned long *bmap;

You're adding a file descriptor to RAMBlock, but I don't see
anything in this patch that ever calls close(gmem_fd) when the
RAMBlock is released. Presuambly reclaim_ramblock() needs to
deal with this ?


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

