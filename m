Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B9B6A9823
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 14:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjCCNHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 08:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjCCNHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 08:07:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975E05D74A
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 05:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677848773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v07IDWMxZry0XXohrnatEt4gHWwOiAbWwK6lrNuE9qk=;
        b=YEVCgr67jqOP7fUqN94e9uSC7SbvQBKo9872P6vrfxhLO/Wxa+hm0YCPhR8dYFrPjZZD3v
        ZhdwSG3p+MHNGbWZdi7bMSYwBxfMEgwQ6y5o2nH63e7kj9WB3BQjPOcnA+IdG/N8kiHZmP
        9Ig/bqHV5yrY9+xbIbaToem4cozwuKI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-caECKmB_PNWeUU7H5QlysA-1; Fri, 03 Mar 2023 08:06:10 -0500
X-MC-Unique: caECKmB_PNWeUU7H5QlysA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 991A0802D2F;
        Fri,  3 Mar 2023 13:06:09 +0000 (UTC)
Received: from localhost (unknown [10.39.194.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05B5140C6EC4;
        Fri,  3 Mar 2023 13:06:08 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Jean-Philippe Brucker <jpb@kernel.org>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Itaru Kitayama <itaru.kitayama@gmail.com>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
In-Reply-To: <2418536c-2658-18d6-f70c-c1af5adaa816@arm.com>
Organization: Red Hat GmbH
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <Y9PtKJ3Wicc19JF1@myrica>
 <CANW9uyud8RTkqgiL=64wV712QMxtAyubqeyCJ0vpcADJ42VqJA@mail.gmail.com>
 <Y/8Y3WLmiw6+Z5AS@myrica>
 <CANW9uysnvGCwANu+_6dp9+3rvHGOkThT9d0K2qpQV4exdmYWoA@mail.gmail.com>
 <20230303094618.GC361458@myrica>
 <1c91b777-982e-e71a-4829-51744e9555c5@arm.com>
 <20230303113905.GD361458@myrica> <20230303120800.ahtyc6et77ig4s27@orel>
 <2418536c-2658-18d6-f70c-c1af5adaa816@arm.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Fri, 03 Mar 2023 14:06:07 +0100
Message-ID: <875ybi0ytc.fsf@redhat.com>
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

On Fri, Mar 03 2023, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> On 03/03/2023 12:08, Andrew Jones wrote:
>> On Fri, Mar 03, 2023 at 11:39:05AM +0000, Jean-Philippe Brucker wrote:
>>> On Fri, Mar 03, 2023 at 09:54:47AM +0000, Suzuki K Poulose wrote:
>>>> On 03/03/2023 09:46, Jean-Philippe Brucker wrote:
>>>>> On Thu, Mar 02, 2023 at 07:12:24AM +0900, Itaru Kitayama wrote:
>>>>>>>> I've tried your series in Real on CCA Host, but the KVM arch init
>>>>>>>> emits an Invalid argument error and terminates.
>>>>>
>>>>> This was the KVM_SET_ONE_REG for the SVE vector size. During my tests I
>>>>> didn't enable SVE in the host but shrinkwrap enables more options.
>>>>
>>>> Does the Qemu check for SVE capability on /dev/kvm ? For kvmtool, we
>>>> changed to using the VM instance and that would prevent using SVE,
>>>> until the RMM supports it.
>>>
>>> Yes, QEMU does check the SVE cap on /dev/kvm. I can propose changing it or
>>> complementing it with a VM check in my next version, it seems to work
>>> (though I need to double-check the VM fd lifetime). Same goes for
>>> KVM_CAP_STEAL_TIME, which I need to disable explicitly at the moment.
>> 
>> I'm probably missing something since I haven't looked at this, but I'm
>> wondering what the "VM instance" check is and why it should be necessary.
>
> Userspace can check for a KVM_CAP_ on KVM fd (/dev/kvm) or a VM fd
> (returned via KVM_CREATE_VM).
>
>> Shouldn't KVM only expose capabilities which it can provide? I.e. the
>
> Correct, given now that we have different "types" of VMs possible on
> Arm64, (Normal vs Realm vs pVM), the capabilities of each of these
> could be different and thus we should use the KVM_CAP_ on the VM fd (
> referred to VM instance above) and not the generic KVM fd.

Using the vm ioctl is even encouraged in the doc for
KVM_CHECK_EXTENSION:

"Based on their initialization different VMs may have different capabilities.
It is thus encouraged to use the vm ioctl to query for capabilities"

It would probably make sense to convert QEMU to use the vm ioctl
everywhere (the wrapper falls back to the global version on failure
anyway.)

>
>> "VM instance" check should be done by KVM and, when it fails, the SVE and
>> steal-time capabilities should return 0.
>> 
>
> Correct.
>
> Suzuki
>
>> Thanks,
>> drew

