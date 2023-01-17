Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABFD66E476
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 18:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbjAQRIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 12:08:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbjAQRI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 12:08:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B531D2FCC9
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673975261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zx3zKZFLOeTrJ4XYrt2hPvepxZ1+7gKs5QAOksY3UGw=;
        b=PikUeunc5p3RMM1vO6yZXCHSN6HcmMIQ8aM3amDWWkVJZhKbCKDF3fJe++4B9J45EXTwCC
        FlX9NPBMz5NgpcLB30DJ5mDiBDsQ+2ZkNolildKHW7eFyxQo892CtjnPe4ttDqNBAfH/uh
        x2ieTdcCpoOKKdi3k+v4AH0DLD0I7Rg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-5us2cJ4DMAiwhWVCxoUkpw-1; Tue, 17 Jan 2023 12:02:24 -0500
X-MC-Unique: 5us2cJ4DMAiwhWVCxoUkpw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AD8E1C29D65;
        Tue, 17 Jan 2023 16:59:35 +0000 (UTC)
Received: from localhost (unknown [10.39.192.81])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B9481492B00;
        Tue, 17 Jan 2023 16:59:34 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 1/2] arm/kvm: add support for MTE
In-Reply-To: <Y8bR7xrsCMr5z6xI@work-vm>
Organization: Red Hat GmbH
References: <20230111161317.52250-1-cohuck@redhat.com>
 <20230111161317.52250-2-cohuck@redhat.com>
 <CAFEAcA9BKX+fSEZZbziwTNq5wsshDajuxGZ_oByVZ=gDSYOn9g@mail.gmail.com>
 <Y8bR7xrsCMr5z6xI@work-vm>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 17 Jan 2023 17:59:32 +0100
Message-ID: <877cxl85cb.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 17 2023, "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * Peter Maydell (peter.maydell@linaro.org) wrote:
>> On Wed, 11 Jan 2023 at 16:13, Cornelia Huck <cohuck@redhat.com> wrote:
>> >
>> > Introduce a new cpu feature flag to control MTE support. To preserve
>> > backwards compatibility for tcg, MTE will continue to be enabled as
>> > long as tag memory has been provided.
>> >
>> > If MTE has been enabled, we need to disable migration, as we do not
>> > yet have a way to migrate the tags as well. Therefore, MTE will stay
>> > off with KVM unless requested explicitly.
>> >
>> > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> > ---
>> >  docs/system/arm/cpu-features.rst |  21 +++++
>> >  hw/arm/virt.c                    |   2 +-
>> >  target/arm/cpu.c                 |  18 ++---
>> >  target/arm/cpu.h                 |   1 +
>> >  target/arm/cpu64.c               | 133 +++++++++++++++++++++++++++++++
>> >  target/arm/internals.h           |   1 +
>> >  target/arm/kvm64.c               |   5 ++
>> >  target/arm/kvm_arm.h             |  12 +++
>> >  target/arm/monitor.c             |   1 +
>> >  9 files changed, 181 insertions(+), 13 deletions(-)
>> >
>> > diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
>> > index 00c444042ff5..e278650c837e 100644
>> > --- a/docs/system/arm/cpu-features.rst
>> > +++ b/docs/system/arm/cpu-features.rst
>> > @@ -443,3 +443,24 @@ As with ``sve-default-vector-length``, if the default length is larger
>> >  than the maximum vector length enabled, the actual vector length will
>> >  be reduced.  If this property is set to ``-1`` then the default vector
>> >  length is set to the maximum possible length.
>> > +
>> > +MTE CPU Property
>> > +================
>> > +
>> > +The ``mte`` property controls the Memory Tagging Extension. For TCG, it requires
>> > +presence of tag memory (which can be turned on for the ``virt`` machine via
>> > +``mte=on``). For KVM, it requires the ``KVM_CAP_ARM_MTE`` capability; until
>> > +proper migration support is implemented, enabling MTE will install a migration
>> > +blocker.
>> > +
>> > +If not specified explicitly via ``on`` or ``off``, MTE will be available
>> > +according to the following rules:
>> > +
>> > +* When TCG is used, MTE will be available iff tag memory is available; i.e. it
>> > +  preserves the behaviour prior to introduction of the feature.
>> > +
>> > +* When KVM is used, MTE will default to off, so that migration will not
>> > +  unintentionally be blocked.
>> > +
>> > +* Other accelerators currently don't support MTE.
>> 
>> Minor nits for the documentation:
>> we should expand out "if and only if" -- not everybody recognizes
>> "iff", especially if they're not native English speakers or not
>> mathematicians.
>> 
>> Should we write specifically that in a future QEMU version KVM
>> might change to defaulting to "on if available" when migration
>> support is implemented?
>
> Please make sure if you do something like that, that the failure
> is obious; 'on if available' gets messy for things like libvirt
> and higher level tools detecting features that are available and
> machines they can migrate to.

I guess we can just keep the door open but decline walking through it if
we fail to come up with a good solution...

