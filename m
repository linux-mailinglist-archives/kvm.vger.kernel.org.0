Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62D759BC4C
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 11:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiHVJI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 05:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbiHVJIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 05:08:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAE617E36
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 02:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661159331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o7p2mCd+etTTt3onbvjwFRzgYq7Aw2dr69iVt9EbyiQ=;
        b=MW6N6PrBrSPgZpoXRPSzD+iZQ49j9HSy++pGejyqNsxg/8XXkHzX2FSGXB2vSB0myj7MIF
        CRyZ0uWXOWmbzqNUxbcZszc3I6Cs3nhwH0dO7S8dOMZepiTr8Y4vQgE8O4FuBXLyyp/7Kb
        a06zEHV4/kg9+MdfwrbtSRcKwVhKPpk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-gLehc8U1NZ-ycCuXhrLRqQ-1; Mon, 22 Aug 2022 05:08:48 -0400
X-MC-Unique: gLehc8U1NZ-ycCuXhrLRqQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F340129ABA3B;
        Mon, 22 Aug 2022 09:08:47 +0000 (UTC)
Received: from localhost (unknown [10.39.193.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1C3F403348;
        Mon, 22 Aug 2022 09:08:47 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: Re: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay
 kvm_vm_ioctl to the commit phase
In-Reply-To: <20220816101250.1715523-3-eesposit@redhat.com>
Organization: Red Hat GmbH
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-3-eesposit@redhat.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Mon, 22 Aug 2022 11:08:46 +0200
Message-ID: <874jy4prvl.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16 2022, Emanuele Giuseppe Esposito <eesposit@redhat.com> wrote:

> Instead of sending a single ioctl every time ->region_* or ->log_*
> callbacks are called, "queue" all memory regions in a list that will
> be emptied only when committing.
>
> This allow the KVM kernel API to be extended and support multiple
> memslots updates in a single call.
>
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  accel/kvm/kvm-all.c       | 99 ++++++++++++++++++++++++++++-----------
>  include/sysemu/kvm_int.h  |  6 +++
>  linux-headers/linux/kvm.h |  9 ++++

Meta comment: Please split out any linux-headers changes into a [dummy,
if not yet accepted in the kernel] headers update patch.

>  3 files changed, 87 insertions(+), 27 deletions(-)

