Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C805AE3A6
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 11:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239295AbiIFI7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 04:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239272AbiIFI7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 04:59:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D626317594
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 01:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662454787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=upwZ6/+sWektF85qqDzioRQviQjik2FU617Bvf3EIVU=;
        b=JWaoBTJayO7iSWlxemgQkFBldiEiQOwRyMpylfO/A5nUQ5U5Wuj7CdWVsK/baQm8ng0pzW
        jP9BS/8TiH/BO7Ds1iiBXlVUiBEH82Ygl091K1iqd15TvxVJcY2aouDV646XwCoAvGEJeg
        Ji7jujS/5suw3PARBgP3xvoWfAqdyC8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-Gs4LqpiXPGCrk2LD_XA5tg-1; Tue, 06 Sep 2022 04:59:42 -0400
X-MC-Unique: Gs4LqpiXPGCrk2LD_XA5tg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C418F805B9A;
        Tue,  6 Sep 2022 08:59:41 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.193.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8762F4C816;
        Tue,  6 Sep 2022 08:59:41 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 8C7DC21E6900; Tue,  6 Sep 2022 10:59:38 +0200 (CEST)
From:   Markus Armbruster <armbru@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: Re: [PATCH v9 04/10] hw/core: introducing drawer and books for s390x
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
        <20220902075531.188916-5-pmorel@linux.ibm.com>
Date:   Tue, 06 Sep 2022 10:59:38 +0200
In-Reply-To: <20220902075531.188916-5-pmorel@linux.ibm.com> (Pierre Morel's
        message of "Fri, 2 Sep 2022 09:55:25 +0200")
Message-ID: <87ilm03mkl.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pierre Morel <pmorel@linux.ibm.com> writes:

> S390x defines two topology levels above sockets: nbooks and drawers.

nbooks or books?

> Let's add these two levels inside the CPU topology implementation.
>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---

[...]

> diff --git a/qapi/machine.json b/qapi/machine.json
> index 6afd1936b0..bdd92e3cb1 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -900,13 +900,15 @@
>  # a CPU is being hotplugged.
>  #
>  # @node-id: NUMA node ID the CPU belongs to
> -# @socket-id: socket number within node/board the CPU belongs to
> +# @drawer-id: drawer number within node/board the CPU belongs to
> +# @book-id: book number within drawer/node/board the CPU belongs to
> +# @socket-id: socket number within book/node/board the CPU belongs to
>  # @die-id: die number within socket the CPU belongs to (since 4.1)
>  # @cluster-id: cluster number within die the CPU belongs to (since 7.1)
>  # @core-id: core number within cluster the CPU belongs to
>  # @thread-id: thread number within core the CPU belongs to
>  #
> -# Note: currently there are 6 properties that could be present
> +# Note: currently there are 7 properties that could be present

Should this be 8?

>  #       but management should be prepared to pass through other
>  #       properties with device_add command to allow for future
>  #       interface extension. This also requires the filed names to be kept in
   #       sync with the properties passed to -device/device_add.

Not your patch's fault, but the second sentence is less than clear.
What are "the filed names"?  A typo perhaps?

> @@ -916,6 +918,8 @@
>  ##
>  { 'struct': 'CpuInstanceProperties',
>    'data': { '*node-id': 'int',
> +            '*drawer-id': 'int',
> +            '*book-id': 'int',
>              '*socket-id': 'int',
>              '*die-id': 'int',
>              '*cluster-id': 'int',
> @@ -1465,6 +1469,10 @@
>  #
>  # @cpus: number of virtual CPUs in the virtual machine
>  #
> +# @drawers: number of drawers in the CPU topology
> +#
> +# @books: number of books in the CPU topology
> +#
>  # @sockets: number of sockets in the CPU topology
>  #
>  # @dies: number of dies per socket in the CPU topology
> @@ -1481,6 +1489,8 @@
>  ##
>  { 'struct': 'SMPConfiguration', 'data': {
>       '*cpus': 'int',
> +     '*drawers': 'int',
> +     '*books': 'int',
>       '*sockets': 'int',
>       '*dies': 'int',
>       '*clusters': 'int',

[...]

