Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DB5782449
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 09:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbjHUHSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 03:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjHUHSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 03:18:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16893A9
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 00:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692602250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ciBbLcY28Ot5+CnRRhBBgFJKp8dZk6YcG5T4tpJoW/E=;
        b=MrqZzvERemB9tRdcKeB+5i0Yk6LCW30Lwo0ys4SrsLLNpgHGW1e8V1qoJcADiNdBRb/00b
        ghJSDun52eTvcOrZEDrhJQApwW8UL+qsAZkW0RwZsieuI7Xwd7gmOQtlkmoKO4GKxOnYnW
        CYM96rCYRuKE9edeyu69NZ8LLHjo3mo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-2yfPL0YeP9CJ9OjHrBd9mQ-1; Mon, 21 Aug 2023 03:17:26 -0400
X-MC-Unique: 2yfPL0YeP9CJ9OjHrBd9mQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CBEE101A528;
        Mon, 21 Aug 2023 07:17:25 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CE143140E919;
        Mon, 21 Aug 2023 07:17:24 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
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
In-Reply-To: <86sf8hg45k.wl-maz@kernel.org>
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
 <874jkyqe13.fsf@redhat.com> <86sf8hg45k.wl-maz@kernel.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 21 Aug 2023 09:17:23 +0200
Message-ID: <87sf8c9858.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 17 2023, Marc Zyngier <maz@kernel.org> wrote:

> On Thu, 17 Aug 2023 09:16:56 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
>> 
>> On Mon, Aug 14 2023, Jing Zhang <jingzhangos@google.com> wrote:
>> 
>> > Maybe it'd be better to leave this to whenever we do need to add other
>> > range support?
>> 
>> My point is: How does userspace figure out if the kernel that is running
>> supports ranges other than id regs? If this is just an insurance against
>> changes that might arrive or not, we can live with the awkward "just try
>> it out" approach; if we think it's likely that we'll need to extend it,
>> we need to add the mechanism for userspace to find out about it now, or
>> it would need to probe for presence of the mechanism...
>
> Agreed. Nothing like the present to address this sort of things. it
> really doesn't cost much, and I'd rather have it right now.
>
> Here's a vague attempt at an advertising mechanism. If people are OK
> with it, I can stash that on top of Jing's series.

I think that looks reasonable.

