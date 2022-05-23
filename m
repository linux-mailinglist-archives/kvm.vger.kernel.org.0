Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED98531E28
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 23:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiEWVsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 17:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiEWVsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 17:48:37 -0400
Received: from mout-u-107.mailbox.org (mout-u-107.mailbox.org [IPv6:2001:67c:2050:101:465::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CC026C1
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 14:48:35 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-u-107.mailbox.org (Postfix) with ESMTPS id 4L6WDH2BNSz9sQh;
        Mon, 23 May 2022 23:48:31 +0200 (CEST)
X-Hashcash: 1:24:220523:seanjc@google.com::+pndUZwQNfsPbpzt:00000000000000000000000000000000000000000000vdKp
X-Hashcash: 1:24:220523:kvm@vger.kernel.org::4wnOJU5MdZOWDpRT:000000000000000000000000000000000000000001dmmo
X-Hashcash: 1:24:220523:lkujaw@member.fsf.org::5tXkkivReZur9+8H:00000000000000000000000000000000000000002pXQ
References: <20220521081511.187388-1-lkujaw@member.fsf.org>
 <You/kms+AnKE1t0L@google.com>
From:   Lev Kujawski <lkujaw@member.fsf.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, lkujaw@member.fsf.org
Subject: Re: [PATCH] KVM: set_msr_mce: Permit guests to ignore single-bit
 ECC errors
Message-ID: <874k1gnlre.fsf@iridium.uucp>
In-reply-to: <You/kms+AnKE1t0L@google.com>
X-PGP-Key: https://meta.sr.ht/~lkujaw.pgp
X-PGP-Fingerprint: AC2ADB1BEE410BB0B791E393441828874091B824
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4L6WDH2BNSz9sQh
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,MISSING_DATE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Date:   Mon, 23 May 2022 17:48:37 -0400
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Sean Christopherson writes:

> "KVM: x86:" for the shortlog scope.
>
> On Sat, May 21, 2022, Lev Kujawski wrote:
>> Certain guest operating systems (e.g., UNIXWARE) clear bit 0 of
>> MC1_CTL to ignore single-bit ECC data errors.
>
> Not that it really matters, but is this behavior documented anywhere?  I've searched
> a variety of SDMs, APMs, and PPRs, and can't find anything that documents this exact
> behavior.  I totally believe that some CPUs behave this way, but it'd be nice to
> document exactly which generations of whose CPUs allow clearing bit zero.

Intel's coverage of IA32_MC1_CTL appears to be proprietary (perhaps
Appendix H material), but AMD helpfully documented it on page 204 of
their BIOS and Kernel Developer's Guide:

https://www.amd.com/system/files/TechDocs/26094.PDF

I experimentally determined that UNIXWARE writes MC1_CTL on QEMU models
"pentium2" or newer, but my guess is that this functionality was
actually introduced with the Pentium Pro.

>> Single-bit ECC data errors are always correctable and thus are safe to ignore
>> because they are informational in nature rather than signaling a loss of data
>> integrity.
>> 
>> Prior to this patch, these guests would crash upon writing MC1_CTL,
>> with resultant error messages like the following:
>> 
>> error: kvm run failed Operation not permitted
>> EAX=fffffffe EBX=fffffffe ECX=00000404 EDX=ffffffff
>> ESI=ffffffff EDI=00000001 EBP=fffdaba4 ESP=fffdab20
>> EIP=c01333a5 EFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
>> ES =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>> CS =0100 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
>> SS =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>> DS =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>> FS =0000 00000000 ffffffff 00c00000
>> GS =0000 00000000 ffffffff 00c00000
>> LDT=0118 c1026390 00000047 00008200 DPL=0 LDT
>> TR =0110 ffff5af0 00000067 00008b00 DPL=0 TSS32-busy
>> GDT=     ffff5020 000002cf
>> IDT=     ffff52f0 000007ff
>> CR0=8001003b CR2=00000000 CR3=0100a000 CR4=00000230
>> DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000
>> DR6=ffff0ff0 DR7=00000400
>> EFER=0000000000000000
>> Code=08 89 01 89 51 04 c3 8b 4c 24 08 8b 01 8b 51 04 8b 4c 24 04 <0f>
>> 30 c3 f7 05 a4 6d ff ff 10 00 00 00 74 03 0f 31 c3 33 c0 33 d2 c3 8d
>> 74 26 00 0f 31 c3
>> 
>> Signed-off-by: Lev Kujawski <lkujaw@member.fsf.org>
>> ---
>>  arch/x86/kvm/x86.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 4790f0d7d40b..128dca4e7bb7 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3215,10 +3215,13 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>  			/* only 0 or all 1s can be written to IA32_MCi_CTL
>>  			 * some Linux kernels though clear bit 10 in bank 4 to
>>  			 * workaround a BIOS/GART TBL issue on AMD K8s, ignore
>> -			 * this to avoid an uncatched #GP in the guest
>> +			 * this to avoid an uncatched #GP in the guest.
>> +			 *
>> +			 * UNIXWARE clears bit 0 of MC1_CTL to ignore
>> +			 * correctable, single-bit ECC data errors.
>>  			 */
>>  			if ((offset & 0x3) == 0 &&
>> -			    data != 0 && (data | (1 << 10)) != ~(u64)0)
>> +			    data != 0 && (data | (1 << 10) | 1) != ~(u64)0)
>>  				return -1;
>
> If KVM injects a #GP like it's supposed to[*], will UNIXWARE eat the #GP and continue
> on, or will it explode?  If it continues on, I'd prefer to avoid more special casing in
> KVM.
>
> If it explodes, I think my preference would be to just drop the MCi_CTL checks
> entirely.  AFAICT, P4-based and P5-based Intel CPus, and all? AMD CPUs allow
> setting/clearing arbitrary bits.  The checks really aren't buying us anything,
> and it seems like Intel retroactively defined the "architectural" behavior of
> only 0s/1s.
>
> [*] https://lore.kernel.org/all/20220512222716.4112548-2-seanjc@google.com

Unfortunately, I cannot say if the UNIXWARE kernel would panic because
QEMU enters a STOP state from which attempts to continue are met with
"Error: Resetting the Virtual Machine is required."

Thanks for the feedback, Lev

