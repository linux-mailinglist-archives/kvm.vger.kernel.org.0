Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF375454627
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 13:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237151AbhKQMLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 07:11:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42591 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231761AbhKQMLA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 07:11:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637150882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EUAsRQ1K2L2naUKa9LkNaNxpsS38eJg7MFYq/EUQFt4=;
        b=VWrHgeFu7nz1shvqooJHw7Q9rPNpd/ugYQSDmWVS+QFGbB2bsHtk9Vc6QH+qsOxeEZxgiv
        Cr61XNW7nWuLfxGwGQ+JcphfBJIv5WlcQiJrhO0VzSa1rfYFuZh4F447+W0v4/TZyqidUP
        KNawGfWHpbEP9jo5tUf7IGa38AjRGcc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-FvmuAdXlOey1skiIYuat1g-1; Wed, 17 Nov 2021 07:07:58 -0500
X-MC-Unique: FvmuAdXlOey1skiIYuat1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 439731023F4E;
        Wed, 17 Nov 2021 12:07:56 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F8315DF56;
        Wed, 17 Nov 2021 12:07:43 +0000 (UTC)
Message-ID: <539f71a6-f62a-c7d2-51a8-bd062a639e87@redhat.com>
Date:   Wed, 17 Nov 2021 13:07:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 1/6] KVM: arm64: Cap KVM_CAP_NR_VCPUS by
 kvm_arm_default_max_vcpus()
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
 <20211116163443.88707-2-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211116163443.88707-2-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 17:34, Vitaly Kuznetsov wrote:
> -		r = num_online_cpus();
> +		/*
> +		 * ARM64 treats KVM_CAP_NR_CPUS differently from all other
> +		 * architectures, as it does not always bound it to
> +		 * num_online_cpus(). It should not matter much because this
                   ^^^^^^^^^^^^^^^^^^

KVM_CAP_MAX_VCPUS (sorry for the typo in my suggestion).  I'll fix it 
when applying.

Paolo

> +		 * is just an advisory value.
> +		 */
> +		r = min_t(unsigned int, num_online_cpus(),
> +			  kvm_arm_default_max_vcpus());

