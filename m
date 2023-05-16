Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5D170507E
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 16:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjEPOWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 10:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbjEPOWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 10:22:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DA76EB3
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 07:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684246888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iI7IGPaVhBWiA9o2JZBNiM8ifHsTLnjxJmTcjx0w6Sw=;
        b=aqbJxm4U8Op+XdpK69EhjR5U/9zSkAj/TE2a/JZevWm6nJxUGC/fh0KGNDdeKp2SBBvIr2
        7ptbUysonULr30br5YT5etEzTu0sKx9sW30bAii99iGdRN9MuGEq6Q4f2WOFN3Wba5VbSL
        yGzUCqoNQJWSQUbhtH2oIe2XdYRf46M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-xYJHXN4xNuSjXGgPbW4jhw-1; Tue, 16 May 2023 10:21:24 -0400
X-MC-Unique: xYJHXN4xNuSjXGgPbW4jhw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E775C85C06E;
        Tue, 16 May 2023 14:21:23 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FB852166B31;
        Tue, 16 May 2023 14:21:23 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
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
Subject: RE: [PATCH v8 0/6] Support writable CPU ID registers from userspace
In-Reply-To: <bb1e038f0bf04d62beda15d0830920ee@huawei.com>
Organization: Red Hat GmbH
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <2ef9208dabe44f5db445a1061a0d5918@huawei.com>
 <868rdomtfo.wl-maz@kernel.org>
 <1a96a72e87684e2fb3f8c77e32516d04@huawei.com> <87cz30h4nx.fsf@redhat.com>
 <867ct8mnel.wl-maz@kernel.org>
 <bb1e038f0bf04d62beda15d0830920ee@huawei.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 16 May 2023 16:21:22 +0200
Message-ID: <877ct8gxwd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16 2023, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

>> -----Original Message-----
>> From: Marc Zyngier [mailto:maz@kernel.org]
>> Sent: 16 May 2023 14:12
>> To: Cornelia Huck <cohuck@redhat.com>
>> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
>> Jing Zhang <jingzhangos@google.com>; KVM <kvm@vger.kernel.org>;
>> KVMARM <kvmarm@lists.linux.dev>; ARMLinux
>> <linux-arm-kernel@lists.infradead.org>; Oliver Upton <oupton@google.com>;
>> Will Deacon <will@kernel.org>; Paolo Bonzini <pbonzini@redhat.com>;
>> James Morse <james.morse@arm.com>; Alexandru Elisei
>> <alexandru.elisei@arm.com>; Suzuki K Poulose <suzuki.poulose@arm.com>;
>> Fuad Tabba <tabba@google.com>; Reiji Watanabe <reijiw@google.com>;
>> Raghavendra Rao Ananta <rananta@google.com>
>> Subject: Re: [PATCH v8 0/6] Support writable CPU ID registers from
>> userspace
>> 
>> On Tue, 16 May 2023 12:55:14 +0100,
>> Cornelia Huck <cohuck@redhat.com> wrote:
>> >
>> > Do you have more concrete ideas for QEMU CPU models already? Asking
>> > because I wanted to talk about this at KVM Forum, so collecting what
>> > others would like to do seems like a good idea :)
>> 
>> I'm not being asked, but I'll share my thoughts anyway! ;-)
>> 
>> I don't think CPU models are necessarily the most important thing.
>> Specially when you look at the diversity of the ecosystem (and even
>> the same CPU can be configured in different ways at integration
>> time). Case in point, Neoverse N1 which can have its I/D caches made
>> coherent or not. And the guest really wants to know which one it is
>> (you can only lie in one direction).
>> 
>> But being able to control the feature set exposed to the guest from
>> userspace is a huge benefit in terms of migration.
>
> Yes, this is what we also need and was thinking of adding a named CPU with
> common min feature set exposed to Guest. There were some previous
> attempts to add the basic support in Qemu here,
>
> https://lists.gnu.org/archive/html/qemu-devel/2020-11/msg00087.html

Thanks for the link.

>
>> Now, this is only half of the problem (and we're back to the CPU
>> model): most of these CPUs have various degrees of brokenness. Most of
>> the workarounds have to be implemented by the guest, and are keyed on
>> the MIDR values. So somehow, you need to be able to expose *all* the
>> possible MIDR values that a guest can observe in its lifetime.
>
> Ok. This will be a problem and I am not sure this has an impact on our 
> platforms or not.

Oh, I see that the MIDR fun had already been mentioned in a reply to the
first version of that patchset; this needs to be addressed for the
general case, I guess...

