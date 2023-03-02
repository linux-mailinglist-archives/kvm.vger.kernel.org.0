Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16BB6A837E
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 14:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjCBN1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 08:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCBN1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 08:27:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9698C1CF7E
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 05:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677763572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a2nxODxGNCf2GEDTesp0abZC6ZU/bJOaxWOZgcF9cDk=;
        b=ETYqeC5pUBgxpitJ5NJl3uQzxm4ak9ox3KNzUtZsa8zREmwE1jsm/fbt/U+87TngysBwq7
        hwsNxKpB9Pz2ptt5TSlHWLVRN4R75Q8/fAugrbVunZqtSWk5iwwYbDpJro2R0Nos3sI6VE
        S/guuMvXfP6Gyamg6JCFp0jCjyz9NO4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-f5WNOqXyO6-aa48-cPrfJg-1; Thu, 02 Mar 2023 08:26:09 -0500
X-MC-Unique: f5WNOqXyO6-aa48-cPrfJg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B06F800B23;
        Thu,  2 Mar 2023 13:26:09 +0000 (UTC)
Received: from localhost (unknown [10.39.192.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BEDC740C83B6;
        Thu,  2 Mar 2023 13:26:08 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Andrea Bolognani <abologna@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 1/2] arm/kvm: add support for MTE
In-Reply-To: <CABJz62PbzFMB3ifg7OvTXe34TS5b3xDHJk8XGs-inA5t5UEAtA@mail.gmail.com>
Organization: Red Hat GmbH
References: <20230228150216.77912-1-cohuck@redhat.com>
 <20230228150216.77912-2-cohuck@redhat.com>
 <CABJz62OHjrq_V1QD4g4azzLm812EJapPEja81optr8o7jpnaHQ@mail.gmail.com>
 <874jr4dbcr.fsf@redhat.com>
 <CABJz62MQH2U1QM26PcC3F1cy7t=53_mxkgViLKjcUMVmi29w+Q@mail.gmail.com>
 <87sfeoblsa.fsf@redhat.com>
 <CABJz62PbzFMB3ifg7OvTXe34TS5b3xDHJk8XGs-inA5t5UEAtA@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 02 Mar 2023 14:26:06 +0100
Message-ID: <87fsanmgi9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01 2023, Andrea Bolognani <abologna@redhat.com> wrote:

> On Wed, Mar 01, 2023 at 03:15:17PM +0100, Cornelia Huck wrote:
>> On Wed, Mar 01 2023, Andrea Bolognani <abologna@redhat.com> wrote:
>> > I'm actually a bit confused. The documentation for the mte property
>> > of the virt machine type says
>> >
>> >   mte
>> >     Set on/off to enable/disable emulating a guest CPU which implements
>> >     the Arm Memory Tagging Extensions. The default is off.
>> >
>> > So why is there a need to have a CPU property in addition to the
>> > existing machine type property?
>>
>> I think the state prior to my patches is actually a bit confusing: the
>> user needs to set a machine type property (causing tag memory to be
>> allocated), which in turn enables a cpu feature. Supporting the machine
>> type property for KVM does not make much sense IMHO: we don't allocate
>> tag memory for KVM (in fact, that would not work). We have to keep the
>> previous behaviour, and explicitly instructing QEMU to create cpus with
>> a certain feature via a cpu property makes the most sense to me.
>
> I agree that a CPU feature makes more sense.
>
>> We might want to tweak the documentation for the machine property to
>> indicate that it creates tag memory and only implicitly enables mte but
>> is a pre-req for it -- thoughts?
>
> I wonder if it would be possible to flip things around, so that the
> machine property is retained with its existing behavior for backwards
> compatibility, but both for KVM and for TCG the CPU property can be
> used on its own?
>
> Basically, keeping the default of machine.mte to off when cpu.mte is
> not specified, but switching it to on when it is. This way, you'd be
> able to simply use
>
>   -machine virt -cpu xxx,mte=on
>
> to enable MTE, regardless of whether you're using KVM or TCG, instead
> of requiring the above for KVM and
>
>   -machine virt,mte=on -cpu xxx
>
> for TCG.

The machine prop is a bool; that means that we cannot distinguish
between "user did not set mte at all" and "user explicitly set
mte=off" -- I think we want

  -machine virt,mte=off -cpu xxx,mte=on

to generate an error, but that would still imply that we'd need to error
out for

  -machine virt -cpu xxx,mte=on

as well.

We could make the machine prop OnOffAuto, but that looks like overkill
to me.

>
> Note that, from libvirt's point of view, there's no advantage to
> doing things that way instead of what you already have. Handling the
> additional machine property is a complete non-issue. But it would
> make things nicer for people running QEMU directly, I think.

I'm tempted to simply consider this to be another wart of the QEMU
command line :)

