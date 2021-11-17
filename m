Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8970F454634
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 13:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237174AbhKQMPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 07:15:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54229 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233484AbhKQMPM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 07:15:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637151133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qW1Ag/nVqux59E+nwE+CUidv8LwOpqfdLxGb0nVtHYk=;
        b=IIaWzzJ8DLpId1ExtCQayk/cUnuUTffliDwGyLNEHCAsEIVfFs2ee8vnLIkEdlUqKqe803
        A3J7hFq4AeQzfMxSis+E03ycZgn7g0GI79Vo1ul32a1IuQWtj4XiQV6RsHDiuxLGJYHKK2
        t/TjJ5DByQa0zS14TUAacx4bmwWNYow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-pNbwtZJUMga-oNgrbu54tA-1; Wed, 17 Nov 2021 07:12:08 -0500
X-MC-Unique: pNbwtZJUMga-oNgrbu54tA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C4B88030D2;
        Wed, 17 Nov 2021 12:12:06 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA24C60C0F;
        Wed, 17 Nov 2021 12:12:01 +0000 (UTC)
Message-ID: <7cd420c0-4fe5-7c37-5eb8-da82b277ff60@redhat.com>
Date:   Wed, 17 Nov 2021 13:12:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 6/6] KVM: x86: Drop arbitraty KVM_SOFT_MAX_VCPUS
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211116163443.88707-1-vkuznets@redhat.com>
 <20211116163443.88707-7-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211116163443.88707-7-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 17:34, Vitaly Kuznetsov wrote:
> KVM_CAP_NR_VCPUS is used to get the "recommended" maximum number of
> VCPUs and arm64/mips/riscv report num_online_cpus(). Powerpc reports
> either num_online_cpus() or num_present_cpus(), s390 has multiple
> constants depending on hardware features. On x86, KVM reports an
> arbitrary value of '710' which is supposed to be the maximum tested
> value but it's possible to test all KVM_MAX_VCPUS even when there are
> less physical CPUs available.
> 
> Drop the arbitrary '710' value and return num_online_cpus() on x86 as
> well. The recommendation will match other architectures and will mean
> 'no CPU overcommit'.
> 
> For reference, QEMU only queries KVM_CAP_NR_VCPUS to print a warning
> when the requested vCPU number exceeds it. The static limit of '710'
> is quite weird as smaller systems with just a few physical CPUs should
> certainly "recommend" less.
> 
> Suggested-by: Eduardo Habkost<ehabkost@redhat.com>
> Signed-off-by: Vitaly Kuznetsov<vkuznets@redhat.com>

Given that KVM_SOFT_MAX_VCPUS has already been dropped in 5.16, I 
changed the commit message to

     KVM: x86: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS

     It doesn't make sense to return the recommended maximum number of
     vCPUs which exceeds the maximum possible number of vCPUs.

Paolo

