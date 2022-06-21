Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352F8552F4C
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 12:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiFUJ75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 05:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349238AbiFUJ62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 05:58:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A416326AF5
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 02:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655805505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H4C/sB5um4hN9/XHAJjRJCQS2mg0bGELmgXp1B2D5DI=;
        b=gk4t6USREeSuC5RQ7vIMs15xiTmEmZWvRlryiiUzAxmEnkREWAPZ4aQLLwYVTIH/kSJA/U
        LQyEYe7Um3KqemrRsNXvn/itTjZQBJCTs9jq5ISn8Lhlu7OZCcibYZJ3Py5l80Mx1rrhpp
        jxiEqJSBYAxGopmKGFde+FjWlJG5d4c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-88tBitKPN0CK2RYLsijSLA-1; Tue, 21 Jun 2022 05:58:21 -0400
X-MC-Unique: 88tBitKPN0CK2RYLsijSLA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F208F101E9BC;
        Tue, 21 Jun 2022 09:58:20 +0000 (UTC)
Received: from localhost (unknown [10.39.193.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F16F1121314;
        Tue, 21 Jun 2022 09:58:20 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, mst <mst@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] virtio: disable notification hardening by default
In-Reply-To: <CACGkMEun6C9RgQVGq1B8BJMd9DyRQkSXj8shXVVhDymQYQLxgA@mail.gmail.com>
Organization: Red Hat GmbH
References: <20220620024158.2505-1-jasowang@redhat.com>
 <87y1xq8jgw.fsf@redhat.com>
 <CACGkMEun6C9RgQVGq1B8BJMd9DyRQkSXj8shXVVhDymQYQLxgA@mail.gmail.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Tue, 21 Jun 2022 11:58:19 +0200
Message-ID: <87sfny8hj8.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21 2022, Jason Wang <jasowang@redhat.com> wrote:

> On Tue, Jun 21, 2022 at 5:16 PM Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> The ifdeffery looks a big ugly, but I don't have a better idea.
>
> I guess you meant the ccw part, I leave the spinlock here in V1, but
> Michael prefers to have that.

Not doing the locking dance is good; I think the #ifdefs all over are a
bit ugly, but as I said, I can't think of a good, less-ugly way...

> In the future, we may consider removing that, one possible way is to
> have a per driver boolean for the hardening.

As in "we've reviewed and tested this driver, so let's turn it on for
every device bound to it"?

