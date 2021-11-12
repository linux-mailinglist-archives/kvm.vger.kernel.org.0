Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54B144E4DC
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 11:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhKLKzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 05:55:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36638 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233883AbhKLKy7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 05:54:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636714329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lCPS80YSTbxrvBdmWutyocGvup+ukBCT7aUf6G8oGDE=;
        b=gV5V1YEMGlIJBFUDTsDLbCjWlXPdlTNPSMZkGPGA42y6LPvFWMb0qQXbVgXatyNjsieTo+
        qHM+MV5nExBrQkbEirhJUIcj88vEqo2GRfkX4qmfXO1EN4oDs0Q6Sc0tsZAxBbUsmIBvQu
        aWYSH+SoOTz4rzdfydEj4JFnqjIvpmY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-iz5tOEPiOiu7gqOK80vfJg-1; Fri, 12 Nov 2021 05:52:06 -0500
X-MC-Unique: iz5tOEPiOiu7gqOK80vfJg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74C8015721;
        Fri, 12 Nov 2021 10:52:03 +0000 (UTC)
Received: from [10.39.193.118] (unknown [10.39.193.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA02E19D9D;
        Fri, 12 Nov 2021 10:51:55 +0000 (UTC)
Message-ID: <ff2ab085-bde9-5d88-e8ce-aa92c165361a@redhat.com>
Date:   Fri, 12 Nov 2021 11:51:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/5] KVM: arm64: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20211111162746.100598-1-vkuznets@redhat.com>
 <20211111162746.100598-2-vkuznets@redhat.com>
 <a5cdff6878b7157587e92ebe4d5af362@kernel.org> <875ysxg0s1.fsf@redhat.com>
 <20211112103851.pmb35qf5bvcukjmg@gator.home>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211112103851.pmb35qf5bvcukjmg@gator.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/21 11:38, Andrew Jones wrote:
>>
>> I'd like KVM to be consistent across architectures and have the same
>> (similar) meaning for KVM_CAP_NR_VCPUS.
> KVM_CAP_NR_VCPUS seems pretty useless if we just want to tell userspace
> the same thing it can get with _SC_NPROCESSORS_ONLN. In fact, if userspace
> knows something we don't about the future onlining of some pcpus, then
> maybe userspace would prefer to check _SC_NPROCESSORS_CONF.

It's the same for most architectures, but for example PPC has to take 
into account the handling of threads, which can exist while the VMs run 
but not in the host.  So KVM_CAP_NR_VCPUS on PPC is _SC_NPROCESSORS_CONF 
times the number of threads per core.

If you don't count PPC (not sure about s390), it _is_ pretty useless indeed.

Paolo

