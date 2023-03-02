Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B900C6A842D
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 15:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjCBOaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 09:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjCBOaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 09:30:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1582F1E1FA
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 06:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677767361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/LwPmwF6aOZkaxAAZKxBAIRvbtyP1kysZ+PdVwd9ULo=;
        b=HZ/RV8JMw/i5zdIQP/e8JT25jKpgcRlwWO1Gbt1rdz51oMzUoeBuUeBwFR0+i7kNLKSr+F
        K4x8iNOo0qGmaikbKhjZCFRHdieWlk3GFMQFhFUUnBxrESNTrr/R4tkua6P+0Yz3TEqfZG
        eT5xJuVGCObPzh76yKDzylsmZBAK2gI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-a33i-XWnPPqPdo26q-G0lQ-1; Thu, 02 Mar 2023 09:29:03 -0500
X-MC-Unique: a33i-XWnPPqPdo26q-G0lQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 763852800486;
        Thu,  2 Mar 2023 14:29:02 +0000 (UTC)
Received: from localhost (unknown [10.39.192.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2770740C6EC4;
        Thu,  2 Mar 2023 14:29:01 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Andrea Bolognani <abologna@redhat.com>,
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
In-Reply-To: <CAFEAcA8z9mS55oBySDYA6PHB=qcRQRH1Aa4WJidG8B=n+6CyEQ@mail.gmail.com>
Organization: Red Hat GmbH
References: <20230228150216.77912-1-cohuck@redhat.com>
 <20230228150216.77912-2-cohuck@redhat.com>
 <CABJz62OHjrq_V1QD4g4azzLm812EJapPEja81optr8o7jpnaHQ@mail.gmail.com>
 <874jr4dbcr.fsf@redhat.com>
 <CABJz62MQH2U1QM26PcC3F1cy7t=53_mxkgViLKjcUMVmi29w+Q@mail.gmail.com>
 <87sfeoblsa.fsf@redhat.com>
 <CAFEAcA8z9mS55oBySDYA6PHB=qcRQRH1Aa4WJidG8B=n+6CyEQ@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 02 Mar 2023 15:28:59 +0100
Message-ID: <87cz5rmdlg.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 02 2023, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Wed, 1 Mar 2023 at 14:15, Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> On Wed, Mar 01 2023, Andrea Bolognani <abologna@redhat.com> wrote:
>>
>> > On Wed, Mar 01, 2023 at 11:17:40AM +0100, Cornelia Huck wrote:
>> >> On Tue, Feb 28 2023, Andrea Bolognani <abologna@redhat.com> wrote:
>> >> > On Tue, Feb 28, 2023 at 04:02:15PM +0100, Cornelia Huck wrote:
>> >> >> +MTE CPU Property
>> >> >> +================
>> >> >> +
>> >> >> +The ``mte`` property controls the Memory Tagging Extension. For TCG, it requires
>> >> >> +presence of tag memory (which can be turned on for the ``virt`` machine via
>> >> >> +``mte=on``). For KVM, it requires the ``KVM_CAP_ARM_MTE`` capability; until
>> >> >> +proper migration support is implemented, enabling MTE will install a migration
>> >> >> +blocker.
>> >> >
>> >> > Is it okay to use -machine virt,mte=on unconditionally for both KVM
>> >> > and TCG guests when MTE support is requested, or will that not work
>> >> > for the former?
>> >>
>> >> QEMU will error out if you try this with KVM (basically, same behaviour
>> >> as before.) Is that a problem for libvirt, or merely a bit inconvinient?
>> >
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
> This isn't really how the virt board does any other of these
> properties, though: secure=on/off and virtualization=on/off also
> both work by having a board property that sets up the board related
> parts and also sets the CPU property appropriately.
>
> I think having MTE in the specific case of KVM behave differently
> to how we've done all these existing properties and how we've
> done MTE for TCG would be confusing. The simplest thing is to just
> follow the existing UI for TCG MTE.
>
> The underlying reason for this is that MTE in general is not a feature
> only of the CPU, but also of the whole system design. It happens
> that KVM gives us tagged RAM "for free" but that's an oddity
> of the KVM implementation -- in real hardware there needs to
> be system level support for tagging.

Hm... the Linux kernel actually seems to consider MTE to be a cpu
feature (at least, it lists it in the cpu features).

So, is your suggestion to use the 'mte' prop of the virt machine to mean
"enable all prereqs for MTE, i.e. allocate tag memory for TCG and enable
MTE in the kernel for KVM"? For TCG, we'll get MTE for the max cpu
model; for KVM, we'd get MTE for host (== max), but I'm wondering what
should happen if we get named cpu models and the user specifies one
where we won't have MTE (i.e. some pre-8.5 one)?

