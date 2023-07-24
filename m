Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DB575EE4F
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 10:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjGXItk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 04:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbjGXItd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 04:49:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF0218E
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 01:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690188518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CJ6ZG+0vLUsia/tm0ndIdy96+hJ8O488N7k/b0KMW2M=;
        b=Ft3EpbighCgVufJZ78MzjWe2qzejhioREFMynYDxQe3+IgbyrWuKNxkoJ6j93j/KUJNfvf
        XwJchlAnKex6CP6OuGvy8d7y8MK4tzvXFOttJlOqF7qKw2N3c1AfTkH+9P2dvdrilxqgLw
        HW6cqq+H3yr3wEbUkgqTp6zOzIkOEm8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-l62iWj7YPFuKhdCBjfwx4A-1; Mon, 24 Jul 2023 04:48:37 -0400
X-MC-Unique: l62iWj7YPFuKhdCBjfwx4A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06DE7104D514;
        Mon, 24 Jul 2023 08:48:37 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C46FAF7833;
        Mon, 24 Jul 2023 08:48:36 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Gavin Shan <gshan@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH for-8.2 2/2] arm/kvm: convert to kvm_get_one_reg
In-Reply-To: <db578c20-22d9-3b76-63e7-d99b891f6d36@redhat.com>
Organization: Red Hat GmbH
References: <20230718111404.23479-1-cohuck@redhat.com>
 <20230718111404.23479-3-cohuck@redhat.com>
 <db578c20-22d9-3b76-63e7-d99b891f6d36@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 24 Jul 2023 10:48:35 +0200
Message-ID: <878rb5g0f0.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 24 2023, Gavin Shan <gshan@redhat.com> wrote:

> Hi Connie,
>
> On 7/18/23 21:14, Cornelia Huck wrote:
>> We can neaten the code by switching the callers that work on a
>> CPUstate to the kvm_get_one_reg function.
>> 
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>   target/arm/kvm.c   | 15 +++---------
>>   target/arm/kvm64.c | 57 ++++++++++++----------------------------------
>>   2 files changed, 18 insertions(+), 54 deletions(-)
>> 
>
> The replacements look good to me. However, I guess it's worty to apply
> the same replacements for target/arm/kvm64.c since we're here?
>
> [gshan@gshan arm]$ pwd
> /home/gshan/sandbox/q/target/arm
> [gshan@gshan arm]$ git grep KVM_GET_ONE_REG
> kvm64.c:    err = ioctl(fd, KVM_GET_ONE_REG, &idreg);
> kvm64.c:    return ioctl(fd, KVM_GET_ONE_REG, &idreg);
> kvm64.c:        ret = ioctl(fdarray[2], KVM_GET_ONE_REG, &reg);

These are the callers that don't work on a CPUState (all in initial
feature discovery IIRC), so they need to stay that way.

