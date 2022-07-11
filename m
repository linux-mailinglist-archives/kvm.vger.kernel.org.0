Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1327A57069D
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 17:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbiGKPJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 11:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbiGKPJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 11:09:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 414465C97A
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 08:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657552144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kFM/HEtXZOYwhdUDHDICOY0NO6iZvyQ10TFIilDHEGc=;
        b=XT9q6TV0h7psBO01URMoMfLDTVlCpVDm/wisVAYGSP+BU23Cf8IxxJo/GKAyI31M74Le5B
        Olps4tUZ/iySF1vYxtZ3MhRjhoURv5Hk68Y7/PMatTpnUQvOBD1emmsMusjEXFVGlIjLGj
        Yp4lL8EKhRR5FbwJRZayULe+RE8zQ5g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-YLpegqmMNImf2jGbCwM8ZA-1; Mon, 11 Jul 2022 11:09:02 -0400
X-MC-Unique: YLpegqmMNImf2jGbCwM8ZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BE2F811E9B;
        Mon, 11 Jul 2022 15:09:01 +0000 (UTC)
Received: from localhost (unknown [10.39.192.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 13C6440D296C;
        Mon, 11 Jul 2022 15:09:00 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/2] arm: enable MTE for QEMU + kvm
In-Reply-To: <YswkdVeESqf5sknQ@work-vm>
Organization: Red Hat GmbH
References: <20220707161656.41664-1-cohuck@redhat.com>
 <YswkdVeESqf5sknQ@work-vm>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Mon, 11 Jul 2022 17:08:59 +0200
Message-ID: <87o7xv660k.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 11 2022, "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * Cornelia Huck (cohuck@redhat.com) wrote:
>> For kvm, mte stays off by default; this is because migration is not yet
>> supported (postcopy will need an extension of the kernel interface, possibly
>> an extension of the userfaultfd interface), and turning on mte will add a
>> migration blocker.
>
> My assumption was that a normal migration would need something as well
> to retrieve and place the MTE flags; albeit not atomically.

There's KVM_ARM_MTE_COPY_TAGS, which should be sufficient to move tags
around for normal migration.

>
>> My biggest question going forward is actually concerning migration; I gather
>> that we should not bother adding something unless postcopy is working as well?
>
> I don't think that restriction is fair on you; just make sure
> postcopy_ram_supported_by_host gains an arch call and fails cleanly;
> that way if anyone tries to enable postcopy they'll find out with a
> clean fail.

Ok, if simply fencing off postcopy is fine, we can try to move forward
with what we have now. The original attempt at
https://lore.kernel.org/all/881871e8394fa18a656dfb105d42e6099335c721.1615972140.git.haibo.xu@linaro.org/
hooked itself directly into common code; maybe we should rather copy the
approach used for s390 storage keys (extra "device") instead?

