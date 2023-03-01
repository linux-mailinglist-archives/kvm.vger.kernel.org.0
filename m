Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27676A6E23
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 15:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjCAOQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 09:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjCAOQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 09:16:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DF32A9AF
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 06:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677680123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KZK/Eir0iXKfCuBI/Twp952puaSpLfvrLp9JkJpn/ZA=;
        b=YbBNWUp1TXFkVEfaGEWV2tIqmcGWtI/V3BkzguxDpdrvUsfJDYPyHoghEQMq5JTifowDjC
        oTHPoI+twULqEp2ta9K0hQ692HQZjtDlo01HfxHjft9su2g/N3T6GSjAh5WNRW/8ocLCdX
        8UXwy45CDFQX/fLPF4i+SNR45aO7yvM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-x_3F7MgmPfq2-Z2EsiR_vg-1; Wed, 01 Mar 2023 09:15:20 -0500
X-MC-Unique: x_3F7MgmPfq2-Z2EsiR_vg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 842B5100F90F;
        Wed,  1 Mar 2023 14:15:19 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D699492C3E;
        Wed,  1 Mar 2023 14:15:19 +0000 (UTC)
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
In-Reply-To: <CABJz62MQH2U1QM26PcC3F1cy7t=53_mxkgViLKjcUMVmi29w+Q@mail.gmail.com>
Organization: Red Hat GmbH
References: <20230228150216.77912-1-cohuck@redhat.com>
 <20230228150216.77912-2-cohuck@redhat.com>
 <CABJz62OHjrq_V1QD4g4azzLm812EJapPEja81optr8o7jpnaHQ@mail.gmail.com>
 <874jr4dbcr.fsf@redhat.com>
 <CABJz62MQH2U1QM26PcC3F1cy7t=53_mxkgViLKjcUMVmi29w+Q@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 01 Mar 2023 15:15:17 +0100
Message-ID: <87sfeoblsa.fsf@redhat.com>
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

On Wed, Mar 01 2023, Andrea Bolognani <abologna@redhat.com> wrote:

> On Wed, Mar 01, 2023 at 11:17:40AM +0100, Cornelia Huck wrote:
>> On Tue, Feb 28 2023, Andrea Bolognani <abologna@redhat.com> wrote:
>> > On Tue, Feb 28, 2023 at 04:02:15PM +0100, Cornelia Huck wrote:
>> >> +MTE CPU Property
>> >> +================
>> >> +
>> >> +The ``mte`` property controls the Memory Tagging Extension. For TCG, it requires
>> >> +presence of tag memory (which can be turned on for the ``virt`` machine via
>> >> +``mte=on``). For KVM, it requires the ``KVM_CAP_ARM_MTE`` capability; until
>> >> +proper migration support is implemented, enabling MTE will install a migration
>> >> +blocker.
>> >
>> > Is it okay to use -machine virt,mte=on unconditionally for both KVM
>> > and TCG guests when MTE support is requested, or will that not work
>> > for the former?
>>
>> QEMU will error out if you try this with KVM (basically, same behaviour
>> as before.) Is that a problem for libvirt, or merely a bit inconvinient?
>
> I'm actually a bit confused. The documentation for the mte property
> of the virt machine type says
>
>   mte
>     Set on/off to enable/disable emulating a guest CPU which implements
>     the Arm Memory Tagging Extensions. The default is off.
>
> So why is there a need to have a CPU property in addition to the
> existing machine type property?

I think the state prior to my patches is actually a bit confusing: the
user needs to set a machine type property (causing tag memory to be
allocated), which in turn enables a cpu feature. Supporting the machine
type property for KVM does not make much sense IMHO: we don't allocate
tag memory for KVM (in fact, that would not work). We have to keep the
previous behaviour, and explicitly instructing QEMU to create cpus with
a certain feature via a cpu property makes the most sense to me.

We might want to tweak the documentation for the machine property to
indicate that it creates tag memory and only implicitly enables mte but
is a pre-req for it -- thoughts?

>
> From the libvirt integration point of view, setting the machine type
> property only for TCG is not a problem.

Ok.

