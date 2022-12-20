Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA8365211E
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 14:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiLTNBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 08:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbiLTNBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 08:01:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A91239
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 05:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671541256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H2t8W77PSTr4Llxbj7tYL3QF8gC1sNMoCFvARbmtY94=;
        b=NxhKlYK+NfzxiulAQtdfhcJt99MYCZCFOa+6tjoShSUZaypgbqQrdxFSKVQmGqq4lTTx4J
        JLTPczzXcTOl19RlOxBo17uZ5ayIhW2dA2XZL/LjxQNHKT0+5MqB8IyuoZCbEG1H5749at
        +h5piqQ0pjx5FevbQAUpgmDVx5Ix41s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-gegjNKZEN5OA-g0pkCielw-1; Tue, 20 Dec 2022 08:00:52 -0500
X-MC-Unique: gegjNKZEN5OA-g0pkCielw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53E6687A9E2;
        Tue, 20 Dec 2022 13:00:52 +0000 (UTC)
Received: from localhost (unknown [10.39.193.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB8EF2166B26;
        Tue, 20 Dec 2022 13:00:51 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 0/2] arm: enable MTE for QEMU + kvm
In-Reply-To: <20221026160511.37162-1-cohuck@redhat.com>
Organization: Red Hat GmbH
References: <20221026160511.37162-1-cohuck@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 20 Dec 2022 14:00:49 +0100
Message-ID: <87h6xqz0u6.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 26 2022, Cornelia Huck <cohuck@redhat.com> wrote:

> After wayyy too long (last version was sent in *July*), a respin of my
> kvm/mte series. Still no migration support. I've been hacking around on
> a device for transferring tags while stopped, but don't really have anything
> to show, probably because I get distra- <ohh, what's that?>
>
> ...I guess you get the point :(
>
> Anyway, I wanted to post this as non-RFC; likely too late for 7.2, but maybe
> for 8.0 (and I'd get a chance to make at least pre-copy migration work; I'm open
> to suggestions for that. Support for post-copy needs kernel-side changes.) Tested
> on the FVP models; qtests only on a non-MTE KVM host.
>
> Changes v2->v3:
> - rebase to current master
> - drop some parts of the qtests that didn't actually work
> - really minor stuff
> - drop RFC
>
> Cornelia Huck (2):
>   arm/kvm: add support for MTE
>   qtests/arm: add some mte tests
>
>  docs/system/arm/cpu-features.rst |  21 +++++
>  target/arm/cpu.c                 |  18 ++---
>  target/arm/cpu.h                 |   1 +
>  target/arm/cpu64.c               | 133 +++++++++++++++++++++++++++++++
>  target/arm/internals.h           |   1 +
>  target/arm/kvm64.c               |   5 ++
>  target/arm/kvm_arm.h             |  12 +++
>  target/arm/monitor.c             |   1 +
>  tests/qtest/arm-cpu-features.c   |  76 ++++++++++++++++++
>  9 files changed, 256 insertions(+), 12 deletions(-)
>

Friendly ping, as 7.2 has been released now... this should still apply
without problems AFAICS. I can also respin, if needed.

