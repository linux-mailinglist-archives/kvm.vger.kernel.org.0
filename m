Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216444651FF
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 16:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351186AbhLAPuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 10:50:02 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:46404 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351106AbhLAPt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 10:49:26 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msRnl-0008HA-LA; Wed, 01 Dec 2021 16:45:45 +0100
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
 <9698a99ccd1938a36dd0c7399262f888dcdf01ac.1638304316.git.maciej.szmigiero@oracle.com>
 <YabnLaz3QBbsxLl0@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v6 27/29] KVM: Optimize overlapping memslots check
Message-ID: <c0789ae0-6617-fbcc-4e58-6cccef56ce9b@maciej.szmigiero.name>
Date:   Wed, 1 Dec 2021 16:45:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YabnLaz3QBbsxLl0@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.12.2021 04:08, Sean Christopherson wrote:
> On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> Do a quick lookup for possibly overlapping gfns when creating or moving
>> a memslot instead of performing a linear scan of the whole memslot set.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> [sean: tweaked params to avoid churn in future cleanup]
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   virt/kvm/kvm_main.c | 35 +++++++++++++++++++++--------------
>>   1 file changed, 21 insertions(+), 14 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 086f18969bc3..52117f65bc5b 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1817,6 +1817,18 @@ static int kvm_set_memslot(struct kvm *kvm,
>>   	return 0;
>>   }
>>   
>> +static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
>> +				      gfn_t start, gfn_t end)
>> +{
>> +	struct kvm_memslot_iter iter;
>> +
>> +	kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end)
> 
> The for loop needs curly braces, per coding-style.rst:
> 
> Also, use braces when a loop contains more than a single simple statement:
> 
> .. code-block:: c
> 
>          while (condition) {
>                  if (test)
>                          do_something();
>          }
> 
> With that,
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 

Will add these braces (and your R-b, too).

Thanks,
Maciej
