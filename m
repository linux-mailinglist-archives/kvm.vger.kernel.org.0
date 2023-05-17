Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D980E706CFB
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 17:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbjEQPhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 11:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbjEQPhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 11:37:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F7510E6
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 08:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684337817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KbDLs8k7xk1BP8cNoSb52gD0F4f3+vK5kAXj+lHqOUA=;
        b=ZnwqwFRGABP0dTCL3nKw6IvRdtbuBxo0zlT7ib7KaLp0xxCnJKQ4TB8SfoWpJXftlP3X4v
        Q4S4IS8lUjGgNmNTyr1vwkC2OL7P1DP4QpwafxCVlVQrrZCA6lukWytjja4R0ehu4lPKkQ
        LAN/nl5+tNDGLJKV5xyteH8B2SLKkuk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-WUiAR-IFMhuRL2uYA4Z6VQ-1; Wed, 17 May 2023 11:36:55 -0400
X-MC-Unique: WUiAR-IFMhuRL2uYA4Z6VQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4D5B2A5955F;
        Wed, 17 May 2023 15:36:52 +0000 (UTC)
Received: from localhost (unknown [10.39.192.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B0322166B31;
        Wed, 17 May 2023 15:36:51 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v8 0/6] Support writable CPU ID registers from userspace
In-Reply-To: <86353wmfj2.wl-maz@kernel.org>
Organization: Red Hat GmbH
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <2ef9208dabe44f5db445a1061a0d5918@huawei.com>
 <868rdomtfo.wl-maz@kernel.org>
 <1a96a72e87684e2fb3f8c77e32516d04@huawei.com> <87cz30h4nx.fsf@redhat.com>
 <867ct8mnel.wl-maz@kernel.org> <87a5y4gy0b.fsf@redhat.com>
 <86353wmfj2.wl-maz@kernel.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 17 May 2023 17:36:49 +0200
Message-ID: <877ct7x94e.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16 2023, Marc Zyngier <maz@kernel.org> wrote:

> On Tue, 16 May 2023 15:19:00 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
>> 
>> On Tue, May 16 2023, Marc Zyngier <maz@kernel.org> wrote:
>> 
>> > On Tue, 16 May 2023 12:55:14 +0100,
>> > Cornelia Huck <cohuck@redhat.com> wrote:
>> >> 
>> >> Do you have more concrete ideas for QEMU CPU models already? Asking
>> >> because I wanted to talk about this at KVM Forum, so collecting what
>> >> others would like to do seems like a good idea :)
>> >
>> > I'm not being asked, but I'll share my thoughts anyway! ;-)
>> >
>> > I don't think CPU models are necessarily the most important thing.
>> > Specially when you look at the diversity of the ecosystem (and even
>> > the same CPU can be configured in different ways at integration
>> > time). Case in point, Neoverse N1 which can have its I/D caches made
>> > coherent or not. And the guest really wants to know which one it is
>> > (you can only lie in one direction).
>> >
>> > But being able to control the feature set exposed to the guest from
>> > userspace is a huge benefit in terms of migration.
>> 
>> Certainly; the important part is that we can keep the guest ABI
>> stable... which parts match to a "CPU model" in the way other
>> architectures use it is an interesting question. It almost certainly
>> will look different from e.g. s390, where we only have to deal with a
>> single manufacturer.
>> 
>> I'm wondering whether we'll end up building frankenmonster CPUs.
>
> We already do. KVM hides a bunch of things we don't want the guest to
> see, either because we don't support the feature, or that we want to
> present it with a different shape (cache topology, for example), and
> these combination don't really exist in any physical implementation.
>
> Which is why I don't really buy the "CPU model" concept as defined by
> x86 and s390. We already are in a vastly different place.

Yes, I agree that the "named cpu models" approach probably won't work on
Arm (especially if you add other accelerators into the mix -- cpu 'foo'
with tcg is unlikely to be 100% identical to cpu 'foo' with KVM.) OTOH,
"these two cpus are not that different from each other, so we support
migration between them with a least common denominator feature/behaviour
set" seems more reasonable.

>
> The way I see it, you get a bunch of architectural features that can
> be enabled/disabled depending on the underlying HW, hypervisor's
> capabilities and userspace input. On top of that, there is a layer of
> paint that tells you what is the overall implementation you could be
> running on (that's what MIDR+REVIDR+AIDR tell you) so that you can
> apply some unspeakable, uarch-specific hacks that keep the machine
> going (got to love these CPU errata).
>
>> Another interesting aspect is how KVM ends up influencing what the guest
>> sees on the CPU level, as in the case where we migrate across matching
>> CPUs, but with a different software level. I think we want userspace to
>> control that to some extent, but I'm not sure if this fully matches the
>> CPU model context.
>
> I'm not sure I get the "different software level" part. Do you mean
> VMM revisions?

Yes. Basically, two (for migration purposes) identical machines with
different kernel/QEMU versions, but using the same QEMU compat
machine. Migrate from old to new, get more regs: works. Migrate from
new to old, get less regs: boom. Expectation would be for this to
work, and handling it from machine compat code seems very awkward.

