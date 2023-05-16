Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30004705070
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 16:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbjEPOUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 10:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbjEPOT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 10:19:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1168C8694
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 07:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684246745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FXV8+kPpgJVEuMcxQ38ltGoZl/HtyeVRK1HJvm3lGSw=;
        b=VTea9aubDL/dD/wihuvr3J6sXRa6KfHZScq3Z1ioupOM7+0Z/wYzkeczqDVC6Pb0KsS6ze
        sO5f6EG1ChxsIn+fNQLXIQFk8eF5rNI3+Bd3BUSqFC3B2Zt/sOWmz3VxqG2uDA3He9lFP3
        MeL2EFVxQ2utHy6ZZXYfhErO25zF5DE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-g-sG8WJmNZ67hxwXZGELBA-1; Tue, 16 May 2023 10:19:03 -0400
X-MC-Unique: g-sG8WJmNZ67hxwXZGELBA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D692F857DE4;
        Tue, 16 May 2023 14:19:01 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94BCA63ABB;
        Tue, 16 May 2023 14:19:01 +0000 (UTC)
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
In-Reply-To: <867ct8mnel.wl-maz@kernel.org>
Organization: Red Hat GmbH
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <2ef9208dabe44f5db445a1061a0d5918@huawei.com>
 <868rdomtfo.wl-maz@kernel.org>
 <1a96a72e87684e2fb3f8c77e32516d04@huawei.com> <87cz30h4nx.fsf@redhat.com>
 <867ct8mnel.wl-maz@kernel.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 16 May 2023 16:19:00 +0200
Message-ID: <87a5y4gy0b.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

> On Tue, 16 May 2023 12:55:14 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
>> 
>> Do you have more concrete ideas for QEMU CPU models already? Asking
>> because I wanted to talk about this at KVM Forum, so collecting what
>> others would like to do seems like a good idea :)
>
> I'm not being asked, but I'll share my thoughts anyway! ;-)
>
> I don't think CPU models are necessarily the most important thing.
> Specially when you look at the diversity of the ecosystem (and even
> the same CPU can be configured in different ways at integration
> time). Case in point, Neoverse N1 which can have its I/D caches made
> coherent or not. And the guest really wants to know which one it is
> (you can only lie in one direction).
>
> But being able to control the feature set exposed to the guest from
> userspace is a huge benefit in terms of migration.

Certainly; the important part is that we can keep the guest ABI
stable... which parts match to a "CPU model" in the way other
architectures use it is an interesting question. It almost certainly
will look different from e.g. s390, where we only have to deal with a
single manufacturer.

I'm wondering whether we'll end up building frankenmonster CPUs.

Another interesting aspect is how KVM ends up influencing what the guest
sees on the CPU level, as in the case where we migrate across matching
CPUs, but with a different software level. I think we want userspace to
control that to some extent, but I'm not sure if this fully matches the
CPU model context.

>
> Now, this is only half of the problem (and we're back to the CPU
> model): most of these CPUs have various degrees of brokenness. Most of
> the workarounds have to be implemented by the guest, and are keyed on
> the MIDR values. So somehow, you need to be able to expose *all* the
> possible MIDR values that a guest can observe in its lifetime.

Fun is to be had...

>
> I have a vague prototype for that that I'd need to dust off and
> finish, because that's also needed for this very silly construct
> called big-little...

That would be cool to see. Or at least interesting ;)

