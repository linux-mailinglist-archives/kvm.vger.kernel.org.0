Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCF377F1EE
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 10:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348808AbjHQISQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 04:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348789AbjHQIRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 04:17:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29622112
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 01:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692260225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QOolyAIrKdePCuvcf3d2mbyCsBtqXn7nucEha9KLm/Y=;
        b=LnMgo9cpTDMhmzBmW5ktXv7EfYNwWvcUHhSdhK4WfY55IdH4tVkewjiMrmKOMXxqA6hOJ6
        eFaURtJZF0G1dN4v3v9/TY4sZC8SLbAyXLyhswpfZA8GkJClj8PTou7aEPlSgSwW5EBHzU
        UPN1ynZioHXJpfjLg2Sbt65rKz7p0yY=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-rtujf1jXPdWVOplIqO1E_A-1; Thu, 17 Aug 2023 04:17:01 -0400
X-MC-Unique: rtujf1jXPdWVOplIqO1E_A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D18261C06EE0;
        Thu, 17 Aug 2023 08:16:59 +0000 (UTC)
Received: from localhost (unknown [10.39.193.36])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44BB7492C14;
        Thu, 17 Aug 2023 08:16:59 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v8 02/11] KVM: arm64: Document
 KVM_ARM_GET_REG_WRITABLE_MASKS
In-Reply-To: <CAAdAUtivsxqpSE_0BL_OftxzwR=e5Rnugb69Ln841ooJqVXgmA@mail.gmail.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-3-jingzhangos@google.com>
 <878raex8g0.fsf@redhat.com>
 <CAAdAUtivsxqpSE_0BL_OftxzwR=e5Rnugb69Ln841ooJqVXgmA@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 17 Aug 2023 10:16:56 +0200
Message-ID: <874jkyqe13.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14 2023, Jing Zhang <jingzhangos@google.com> wrote:

> On Mon, Aug 14, 2023 at 2:46=E2=80=AFAM Cornelia Huck <cohuck@redhat.com>=
 wrote:
>>
>> On Mon, Aug 07 2023, Jing Zhang <jingzhangos@google.com> wrote:
>>
>> > Add some basic documentation on how to get feature ID register writable
>> > masks from userspace.
>> >
>> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
>> > ---
>> >  Documentation/virt/kvm/api.rst | 29 +++++++++++++++++++++++++++++
>> >  1 file changed, 29 insertions(+)
>> >
>> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/a=
pi.rst
>> > index c0ddd3035462..92a9b20f970e 100644
>> > --- a/Documentation/virt/kvm/api.rst
>> > +++ b/Documentation/virt/kvm/api.rst
>> > @@ -6068,6 +6068,35 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registe=
rs using the SET_ONE_REG
>> >  interface. No error will be returned, but the resulting offset will n=
ot be
>> >  applied.
>> >
>> > +4.139 KVM_ARM_GET_REG_WRITABLE_MASKS
>> > +-------------------------------------------
>> > +
>> > +:Capability: none
>> > +:Architectures: arm64
>> > +:Type: vm ioctl
>> > +:Parameters: struct reg_mask_range (in/out)
>> > +:Returns: 0 on success, < 0 on error
>> > +
>> > +
>> > +::
>> > +
>> > +        #define ARM64_FEATURE_ID_SPACE_SIZE  (3 * 8 * 8)
>> > +
>> > +        struct reg_mask_range {
>> > +                __u64 addr;             /* Pointer to mask array */
>> > +                __u64 reserved[7];
>> > +        };
>> > +
>> > +This ioctl would copy the writable masks for feature ID registers to =
userspace.
>> > +The Feature ID space is defined as the System register space in AArch=
64 with
>> > +op0=3D=3D3, op1=3D=3D{0, 1, 3}, CRn=3D=3D0, CRm=3D=3D{0-7}, op2=3D=3D=
{0-7}.
>> > +To get the index in the mask array pointed by ``addr`` for a specifie=
d feature
>> > +ID register, use the macro ``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn=
, crm, op2)``.
>> > +This allows the userspace to know upfront whether it can actually twe=
ak the
>> > +contents of a feature ID register or not.
>> > +The ``reserved[7]`` is reserved for future use to add other register =
space. For
>> > +feature ID registers, it should be 0, otherwise, KVM may return error.
>>
>> In case of future extensions, this means that userspace needs to figure
>> out what the kernel supports via different content in reg_mask_range
>> (i.e. try with a value in one of the currently reserved fields and fall
>> back to using addr only if that doesn't work.) Can we do better?
>>
>> Maybe we could introduce a capability that returns the supported ranges
>> as flags, i.e. now we would return 1 for id regs masks, and for the
>> future case where we have some values in the next reserved field we
>> could return 1 & 2 etc. Would make life easier for userspace that needs
>> to work with different kernels, but might be overkill if reserved[] is
>> more like an insurance without any concrete plans for extensions.
>>
>
> Maybe it'd be better to leave this to whenever we do need to add other
> range support?

My point is: How does userspace figure out if the kernel that is running
supports ranges other than id regs? If this is just an insurance against
changes that might arrive or not, we can live with the awkward "just try
it out" approach; if we think it's likely that we'll need to extend it,
we need to add the mechanism for userspace to find out about it now, or
it would need to probe for presence of the mechanism...

