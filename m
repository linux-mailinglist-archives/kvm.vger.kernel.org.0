Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E3270328
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 17:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfGVPKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 11:10:33 -0400
Received: from mta02.hs-regensburg.de ([194.95.104.12]:34522 "EHLO
        mta02.hs-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbfGVPKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 11:10:33 -0400
Received: from E16S02.hs-regensburg.de (e16s02.hs-regensburg.de [IPv6:2001:638:a01:8013::92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client CN "E16S02", Issuer "E16S02" (not verified))
        by mta02.hs-regensburg.de (Postfix) with ESMTPS id 45slRB2LZnzxys;
        Mon, 22 Jul 2019 17:10:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oth-regensburg.de;
        s=mta01-20160622; t=1563808230;
        bh=uT9eFfN9707bKIsdfkLV36CVDsG1k/APnhL2oeG0JcM=;
        h=From:Subject:To:References:Date:In-Reply-To:From;
        b=iwVXMEZuNq5JTgpbaKwheE5Ii5gBk8ZnsCNelZNKLqALLHZcMk5vDbYxZ6/DKhfvW
         6mDFgfXXc/T0x0WB0586rP3OXFo1mACTwUbEs/llJmAxrZ7GCbDbtymji1QTQZrzz0
         O+tH+f4Dn08fjUsH+/TgLl2gEHzS6409hYsnt+5u108V9rCUFyS/Mdc6k++B7dBq4y
         kJ80LpsrPQWbRLsPKK7f5WgnwsIaEKL++P/T9SS7Ybfz9cqDmvEESQIi4sXeZ6VILU
         3U2b/azp3mhmlnA3gnAdMC58HfW/zcuJutslrrsAORrwc7gOXUOoIysKhKaonB2UZL
         eq9n0JrXn2vIQ==
Received: from [192.168.178.10] (194.95.106.138) by E16S02.hs-regensburg.de
 (2001:638:a01:8013::92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 22 Jul
 2019 17:10:30 +0200
From:   Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>
Subject: Re: KVM_SET_NESTED_STATE not yet stable
To:     Jan Kiszka <jan.kiszka@web.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <9eb4dd9f-65e5-627d-b288-e5fe8ade0963@siemens.com>
 <1562772280.18613.25.camel@amazon.de>
 <f1936ed9-e41b-4d36-50bb-3956434d993c@siemens.com>
 <cfd86643-dbac-3a69-9faf-03eaa8aee6a1@siemens.com>
 <47e8c75d-f39a-89f8-940f-d05a9bc91899@oth-regensburg.de>
 <e81b5c46-1700-33d2-4db7-a887e339d4ac@redhat.com>
 <68880241-ff91-1cb1-1bd5-ab5d2e307bec@redhat.com>
 <c44c9d59-3ef0-cda9-fd4a-6e6c67fd9e71@web.de>
Openpgp: preference=signencrypt
Message-ID: <7afe03c6-cd51-3688-7b5c-c6156221327a@oth-regensburg.de>
Date:   Mon, 22 Jul 2019 17:10:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c44c9d59-3ef0-cda9-fd4a-6e6c67fd9e71@web.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
X-Originating-IP: [194.95.106.138]
X-ClientProxiedBy: E16S03.hs-regensburg.de (2001:638:a01:8013::93) To
 E16S02.hs-regensburg.de (2001:638:a01:8013::92)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/21/19 11:05 AM, Jan Kiszka wrote:
> On 19.07.19 18:38, Paolo Bonzini wrote:
>> On 11/07/19 19:30, Paolo Bonzini wrote:
>>> On 11/07/19 13:37, Ralf Ramsauer wrote:
>>>> I can reproduce and confirm this issue. A system_reset of qemu after
>>>> Jailhouse is enabled leads to the crash listed below, on all machines.
>>>>
>>>> On the Xeon Gold, e.g., Qemu reports:
>>>>
>>>> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000f61
>>>> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
>>>> EIP=0000fff0 EFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
>>>> ES =0000 00000000 0000ffff 00009300
>>>> CS =f000 ffff0000 0000ffff 00a09b00
>>>> SS =0000 00000000 0000ffff 00c09300
>>>> DS =0000 00000000 0000ffff 00009300
>>>> FS =0000 00000000 0000ffff 00009300
>>>> GS =0000 00000000 0000ffff 00009300
>>>> LDT=0000 00000000 0000ffff 00008200
>>>> TR =0000 00000000 0000ffff 00008b00
>>>> GDT=     00000000 0000ffff
>>>> IDT=     00000000 0000ffff
>>>> CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000680
>>>> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
>>>> DR3=0000000000000000
>>>> DR6=00000000ffff0ff0 DR7=0000000000000400
>>>> EFER=0000000000000000
>>>> Code=00 66 89 d8 66 e8 af a1 ff ff 66 83 c4 0c 66 5b 66 5e 66 c3 <ea> 5b
>>>> e0 00 f0 30 36 2f 32 33 2f 39 39 00 fc 00 00 00 00 00 00 00 00 00 00 00
>>>> 00 00 00 00
>>>>
>>>> Kernel:
>>>> [ 1868.804515] kvm: vmptrld           (null)/6b8640000000 failed
>>>> [ 1868.804568] kvm: vmclear fail:           (null)/6b8640000000
>>>>
>>>> And the host freezes unrecoverably. Hosts use standard distro kernels
>>>
>>> Thanks.  I'm going to look at it tomorrow.
>>
>> Ok, it was only tomorrow modulo 7, but the first fix I got is trivial:
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 6e88f459b323..6119b30347c6 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -194,6 +194,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
>>  {
>>  	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
>>  	vmcs_write64(VMCS_LINK_POINTER, -1ull);
>> +	vmx->nested.need_vmcs12_to_shadow_sync = false;
>>  }
>>
>>  static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
>>
>> Can you try it and see what you get?
>>
> 
> Confirmed that this fixes the host crashes for me as well.

Works, thanks. Tested on a v5.3-rc1. There, the proper patch is already
applied. No more crashes, qemu resets as expected. Let's wait for the
backport…

  Ralf

> 
> Now I'm only still seeing guest corruptions on vmport/vmmouse accesses from L2.
> Looking into that right now.
> 
> Jan
> 
