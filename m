Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15591704D45
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 14:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbjEPMCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 08:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbjEPMCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 08:02:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C750A10EF
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 05:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684238530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tzUmk87snFS7HoBIZst/R05wwfkMdbgCSpiT96qaD5s=;
        b=MWVN096yC3I8nnlP8WiI1XnCqque8HGhbBBEmF5M/naOW64Jf7yzuV+e313to5o0EBO2DB
        3TQApLD7UDLb35MGWMameQ2e9X5gpJ73P62C32Y+SUE6u3RwXm3kUTuQHmpuqOAjnEgn/6
        GhCCUqZ4F9/zoZle0gCxzPvnvuSwgJo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-ZmlMnNkGOxCQCpdbM_NETQ-1; Tue, 16 May 2023 07:55:23 -0400
X-MC-Unique: ZmlMnNkGOxCQCpdbM_NETQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AC372801A68;
        Tue, 16 May 2023 11:55:16 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CEAC40C6EC4;
        Tue, 16 May 2023 11:55:15 +0000 (UTC)
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
In-Reply-To: <1a96a72e87684e2fb3f8c77e32516d04@huawei.com>
Organization: Red Hat GmbH
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <2ef9208dabe44f5db445a1061a0d5918@huawei.com>
 <868rdomtfo.wl-maz@kernel.org>
 <1a96a72e87684e2fb3f8c77e32516d04@huawei.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 16 May 2023 13:55:14 +0200
Message-ID: <87cz30h4nx.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 16 2023, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

>> -----Original Message-----
>> From: Marc Zyngier [mailto:maz@kernel.org]
>> Sent: 16 May 2023 12:01
>> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
>> Cc: Jing Zhang <jingzhangos@google.com>; KVM <kvm@vger.kernel.org>;
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
>> On Tue, 16 May 2023 11:37:20 +0100,
>> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
>> wrote:
>> >
>> > > -----Original Message-----
>> > > From: Jing Zhang [mailto:jingzhangos@google.com]
>> > > Sent: 03 May 2023 18:16
>> > > To: KVM <kvm@vger.kernel.org>; KVMARM <kvmarm@lists.linux.dev>;
>> > > ARMLinux <linux-arm-kernel@lists.infradead.org>; Marc Zyngier
>> > > <maz@kernel.org>; Oliver Upton <oupton@google.com>
>> > > Cc: Will Deacon <will@kernel.org>; Paolo Bonzini
>> <pbonzini@redhat.com>;
>> > > James Morse <james.morse@arm.com>; Alexandru Elisei
>> > > <alexandru.elisei@arm.com>; Suzuki K Poulose
>> <suzuki.poulose@arm.com>;
>> > > Fuad Tabba <tabba@google.com>; Reiji Watanabe <reijiw@google.com>;
>> > > Raghavendra Rao Ananta <rananta@google.com>; Jing Zhang
>> > > <jingzhangos@google.com>
>> > > Subject: [PATCH v8 0/6] Support writable CPU ID registers from
>> userspace
>> > >
>> > > This patchset refactors/adds code to support writable per guest CPU ID
>> > > feature
>> > > registers. Part of the code/ideas are from
>> > >
>> https://lore.kernel.org/all/20220419065544.3616948-1-reijiw@google.com
>> >
>> > Hi Jing/Reiji,
>> >
>> > Just to check the status on the above mentioned series "KVM: arm64: Make
>> CPU
>> > ID registers writable by userspace". Is there any plan to respin that one
>> soon?
>> > (Sorry, not sure there is any other series in progress for that support
>> currently)
>> 
>> I think this still is the latest, which I'm about to review again. I'd
>> appreciate if you could have a look to!
>
> Thanks Marc for confirming. Will go through. We do have some requirement to
> add support for Qemu CPU models/migration between different hosts.

Do you have more concrete ideas for QEMU CPU models already? Asking
because I wanted to talk about this at KVM Forum, so collecting what
others would like to do seems like a good idea :)

