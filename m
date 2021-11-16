Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAFE45368F
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 16:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238711AbhKPQC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 11:02:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238680AbhKPQBw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 11:01:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637078334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FUd95vU2iSWhtX+C2mcdhQw7Dtmpee6Qjpm6zn3irQ4=;
        b=TLgCQDgIl5hCCb6fq9rSLPmVuMmhQpOB/6MjGNc6a4nroTg+YPDc7FfVZSjwNoZ7Nou5jv
        Yp/kV3qqtfJjhNyV6s+K8zkfKUY16B40ZX5t66iNy9Zz+0Mph2tJlWQuTfLedgwTExFumy
        65Y5SKwvZHJJqzBlVKrKR4lH5fh6Rr0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-DnLZkEu7Obyh6mlLOa--nA-1; Tue, 16 Nov 2021 10:58:48 -0500
X-MC-Unique: DnLZkEu7Obyh6mlLOa--nA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8857E824F8B;
        Tue, 16 Nov 2021 15:58:45 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D581314104;
        Tue, 16 Nov 2021 15:58:37 +0000 (UTC)
Message-ID: <ca25cf55-dcc8-9df4-a286-3c65a26803cd@redhat.com>
Date:   Tue, 16 Nov 2021 16:58:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/5] KVM: arm64: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
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
 <87k0hd8obo.wl-maz@kernel.org>
 <ad3534bc-fe3a-55f5-b022-4dbec5f29798@redhat.com> <87y25onsj6.fsf@redhat.com>
 <875yss859c.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <875yss859c.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 16:55, Marc Zyngier wrote:
>> - Always kvm_arm_default_max_vcpus to make the output independent on 'if
>>   (kvm)'.
> This. Between two useless numbers, I prefer the one that doesn't
> introduce any userspace visible changes.

Fair enough, I'm not going to override you---but please add a comment 
that says

	/*
	 * arm64 treats KVM_CAP_NR_CPUS different from all other
	 * architectures, as it does not bound it to num_online_cpus().
	 * It should not matter much because this is just an advisory
	 * value.
	 */

or something like that.

Paolo

