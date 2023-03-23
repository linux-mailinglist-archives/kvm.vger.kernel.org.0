Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D853B6C6075
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjCWHPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCWHPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:15:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298F74EC7
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 00:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679555670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=43ejkovPDeSvkZYThQw50buKihsZBioA5QB7A7P269I=;
        b=JP3qIMv3dnBnCcD6Eqq8ZX0oc4M2A+JTOpkigyJzjlZ5AjmMfODy3KJUpTWsWClqd1xSd4
        16vRxXUcFaf494R4oC3eSUUXfP9SgdrqFNzpFP7n6ocx+u7+cFVByFDF+0ESI/Jb5+xyV8
        d+KQMUCEauRUfJdR4AFq44olOfkWFQo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-jCOaue0oNpCXqdBksbTq-g-1; Thu, 23 Mar 2023 03:14:26 -0400
X-MC-Unique: jCOaue0oNpCXqdBksbTq-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E68D855300;
        Thu, 23 Mar 2023 07:14:25 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 40BCA40C6E67;
        Thu, 23 Mar 2023 07:14:25 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 3585621E6926; Thu, 23 Mar 2023 08:14:24 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     Sam Li <faithilikerun@gmail.com>
Cc:     qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        damien.lemoal@opensource.wdc.com, kvm@vger.kernel.org,
        hare@suse.de, Paolo Bonzini <pbonzini@redhat.com>,
        dmitry.fomichev@wdc.com, Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v8 3/4] block: add accounting for zone append operation
References: <20230323052828.6545-1-faithilikerun@gmail.com>
        <20230323052828.6545-4-faithilikerun@gmail.com>
Date:   Thu, 23 Mar 2023 08:14:24 +0100
In-Reply-To: <20230323052828.6545-4-faithilikerun@gmail.com> (Sam Li's message
        of "Thu, 23 Mar 2023 13:28:27 +0800")
Message-ID: <87y1no0wj3.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sam Li <faithilikerun@gmail.com> writes:

> Taking account of the new zone append write operation for zoned devices,
> BLOCK_ACCT_ZONE_APPEND enum is introduced as other I/O request type (read,
> write, flush).
>
> Signed-off-by: Sam Li <faithilikerun@gmail.com>

[...]

> diff --git a/qapi/block-core.json b/qapi/block-core.json
> index c05ad0c07e..501b554fc5 100644
> --- a/qapi/block-core.json
> +++ b/qapi/block-core.json
> @@ -849,6 +849,9 @@
>  # @min_wr_latency_ns: Minimum latency of write operations in the
>  #                     defined interval, in nanoseconds.
>  #
> +# @min_zone_append_latency_ns: Minimum latency of zone append operations
> +#                              in the defined interval, in nanoseconds.

Lacks (since 8.1).  Your other additions, too.

[...]

