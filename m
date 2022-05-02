Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF06516FE2
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385133AbiEBM6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 08:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385135AbiEBM6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 08:58:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C67115701
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 05:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651496100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CqL4KiR9uD/RXOMEb8URbmnxGDSjsgc67isSNuA7kNo=;
        b=RDOV6sUYve+LqfR4ziuutrHEsHUuCSjFwpUXU3qhQf7NdxbSGjiqSVEqEhB18JYvAzSQaI
        7D9LRI6z2XSQsPpllYmhDmNa4UoI7zt3SZCEfA3lXaMOPM2FZdoWIHQJOp/XUzGDAsGuV8
        e0a5mZtsEZAZOJVGRB/Frjg/lkWLCbA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-QE2QBk5aPe-IBXJWuMykJA-1; Mon, 02 May 2022 08:54:57 -0400
X-MC-Unique: QE2QBk5aPe-IBXJWuMykJA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC9C93811A22;
        Mon,  2 May 2022 12:54:56 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.36.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 95B4B14DE24A;
        Mon,  2 May 2022 12:54:56 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 7251F21E68BC; Mon,  2 May 2022 14:54:55 +0200 (CEST)
From:   Markus Armbruster <armbru@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud?= =?utf-8?Q?=C3=A9?= 
        <f4bug@amsat.org>, Cornelia Huck <cohuck@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G . Johnson" <john.g.johnson@oracle.com>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 09/10] migration/dirtyrate: Expand dirty_bitmap to
 be tracked separately for devices
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
        <20220428211351.3897-10-joao.m.martins@oracle.com>
Date:   Mon, 02 May 2022 14:54:55 +0200
In-Reply-To: <20220428211351.3897-10-joao.m.martins@oracle.com> (Joao
        Martins's message of "Thu, 28 Apr 2022 22:13:50 +0100")
Message-ID: <87k0b4ksbk.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Joao Martins <joao.m.martins@oracle.com> writes:

> Expand dirtyrate measurer that is accessible via HMP calc_dirty_rate
> or QMP 'calc-dirty-rate' to receive a @scope argument. The scope
> then restricts the dirty tracking to be done at devices only,
> while neither enabling or using the KVM (CPU) dirty tracker.
> The default stays as is i.e. dirty-ring / dirty-bitmap from KVM.
>
> This is useful to test, exercise the IOMMU dirty tracker and observe
> how much a given device is dirtying memory.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

[...]

> diff --git a/qapi/migration.json b/qapi/migration.json
> index 27d7b281581d..082830c6e771 100644
> --- a/qapi/migration.json
> +++ b/qapi/migration.json
> @@ -1793,6 +1793,19 @@
>  { 'enum': 'DirtyRateMeasureMode',
>    'data': ['page-sampling', 'dirty-ring', 'dirty-bitmap'] }
>  
> +##
> +# @DirtyRateScope:
> +#
> +# An enumeration of scope of measuring dirtyrate.

"dirtyrate" is not a word.

> +#
> +# @dirty-devices: calculate dirtyrate by devices only.

Please document @all, too.

> +#
> +# Since: 6.2
> +#
> +##
> +{ 'enum': 'DirtyRateScope',
> +  'data': ['all', 'dirty-devices'] }
> +
>  ##
>  # @DirtyRateInfo:
>  #
> @@ -1827,6 +1840,7 @@
>             'calc-time': 'int64',
>             'sample-pages': 'uint64',
>             'mode': 'DirtyRateMeasureMode',
> +           'scope': 'DirtyRateScope',

Please document new member @scope.

>             '*vcpu-dirty-rate': [ 'DirtyRateVcpu' ] } }
>  
>  ##
> @@ -1851,6 +1865,7 @@
>  ##
>  { 'command': 'calc-dirty-rate', 'data': {'calc-time': 'int64',
>                                           '*sample-pages': 'int',
> +                                         '*scope': 'DirtyRateScope',
>                                           '*mode': 'DirtyRateMeasureMode'} }
>  
>  ##

[...]

