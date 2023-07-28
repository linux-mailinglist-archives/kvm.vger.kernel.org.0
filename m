Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D677673B3
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 19:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjG1RpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 13:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjG1RpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 13:45:18 -0400
Received: from newman.cs.utexas.edu (newman.cs.utexas.edu [128.83.139.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AD03AB4
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 10:45:13 -0700 (PDT)
X-AuthUser: ysohail
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
        s=default; t=1690566311;
        bh=X4lAta4mJ8SekyIvKTiNJG9DhKP9T6+34mJfE29GbyQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=H4fPuZefmLDZLy3Y7W4yPOG/do8FIdG/gRLIrBOs4EeYcKpoNaoi+aMUGrSHllcbw
         jMf0/Zmm7pfFQd5nJENVmaIfZoRIq/IMPe1gnBpLlhVSxy4K5OoLXqO8egu38ilOpn
         kirJsXmtAa3TKB22K7amM/z6FilMqBMLI0f/zv4w=
Received: from [192.168.0.202] (71-138-92-128.lightspeed.hstntx.sbcglobal.net [71.138.92.128])
        (authenticated bits=0)
        by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id 36SHjAUE026222
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 28 Jul 2023 12:45:10 -0500
Message-ID: <6bc819fd-18e4-8472-be7d-14db6e059e9a@cs.utexas.edu>
Date:   Fri, 28 Jul 2023 12:45:10 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: KVM_EXIT_FAIL_ENTRY with hardware_entry_failure_reason = 7
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <7b5f626c-9f48-15e2-8f7a-1178941db048@cs.utexas.edu>
 <ZMFVLiC3YvPY3bSP@google.com>
 <27f998f5-748b-c356-9bb6-813573c758e5@cs.utexas.edu>
 <ZMF5O6Tq1UTQHvX0@google.com>
 <7d4a5084-5e1e-22dd-c203-99f46850145a@cs.utexas.edu>
 <ZMKg5WosmBu78Vgv@google.com>
From:   Yahya Sohail <ysohail@cs.utexas.edu>
In-Reply-To: <ZMKg5WosmBu78Vgv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Fri, 28 Jul 2023 12:45:11 -0500 (CDT)
X-Virus-Scanned: clamav-milter 0.103.8 at newman
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/27/23 11:52, Sean Christopherson wrote:
> On Wed, Jul 26, 2023, Yahya Sohail wrote:
>> It appears the paging bit was not set even after
>> I "fixed" cr0. I have now made sure the paging bit and the fixed bits are
>> properly set in CR0. CR0 is now equal to 0x8393870b
> 
> How did you get that value?   AFAICT, it's not outright illegal, but only because
> the CPU ignores reserved bits in CR0[31:0], as opposed to rejecting them.

Turns out that cr0 value was still erroneous. Not certain what happened, 
but I think I may have interpreted a hex number as a decimal number at 
some point while computing it. I've updated cr0 to be 0xe0000011. I got 
this value by reading the default value of the cr0 register by calling 
KVM_GET_SREGS on a newly created VM and then setting the bits I need to 
be enabled. The issue continues to persist.

> Enable /sys/module/kvm_intel/parameters/dump_invalid_vmcs, then KVM will print
> out most (all?) VMCS fields on the failed VM-Entry.  From there you'll have to
> hunt through guest state to figure out which fields, or combinations of fields,
> is invalid.

I get the following output in my log:
*** Guest State ***
CR0: actual=0x0000000080000031, shadow=0x00000000e0000011, 
gh_mask=fffffffffffffff7
CR4: actual=0x0000000000002060, shadow=0x0000000000000020, 
gh_mask=fffffffffffef871
CR3 = 0x0000000010000000
PDPTR0 = 0x0000000000000000  PDPTR1 = 0x0000000000000000
PDPTR2 = 0x0000000000000000  PDPTR3 = 0x0000000000000000
RSP = 0x0000000002000031  RIP = 0x0000000000103c00
RFLAGS=0x00000002         DR7 = 0x0000000000000400
Sysenter RSP=0000000000000000 CS:RIP=0000:0000000000000000
CS:   sel=0x0010, attr=0x0a09b, limit=0x000fffff, base=0x0000000000000000
DS:   sel=0x0018, attr=0x08093, limit=0x000fffff, base=0x0000000000000000
SS:   sel=0x0018, attr=0x08093, limit=0x000fffff, base=0x0000000000000000
ES:   sel=0x0018, attr=0x08093, limit=0x000fffff, base=0x0000000000000000
FS:   sel=0x0000, attr=0x10001, limit=0x00000000, base=0x0000000000000000
GS:   sel=0x0000, attr=0x10001, limit=0x00000000, base=0x0000000000000000
GDTR:                           limit=0x00001031, base=0x001f000000000200
LDTR: sel=0x0000, attr=0x10000, limit=0x000003e8, base=0x000003e8000081a4
IDTR:                           limit=0x00000000, base=0x0000000000000000
TR:   sel=0x0000, attr=0x10021, limit=0x01211091, base=0x0000000000010304
EFER =     0x0000000000000500  PAT = 0x0007040600070406
DebugCtl = 0x0000000000000000  DebugExceptions = 0x0000000000000000
BndCfgS = 0x0000000000000000
Interruptibility = 00000000  ActivityState = 00000000
*** Host State ***
RIP = 0xffffffffc09a444f  RSP = 0xffffa3aa0d2fbd50
CS=0010 SS=0018 DS=0000 ES=0000 FS=0000 GS=0000 TR=0040
FSBase=00007feb463e9740 GSBase=ffff93bb3dd80000 TRBase=fffffe000033d000
GDTBase=fffffe000033b000 IDTBase=fffffe0000000000
CR0=0000000080050033 CR3=0000000547886004 CR4=00000000007726e0
Sysenter RSP=fffffe000033d000 CS:RIP=0010:ffffffff910016e0
EFER = 0x0000000000000d01  PAT = 0x0407050600070106
*** Control State ***
PinBased=0000007f CPUBased=b5986dfa SecondaryExec=00032ce2
EntryControls=0001d3ff ExitControls=00abefff
ExceptionBitmap=00060042 PFECmask=00000000 PFECmatch=00000000
VMEntry: intr_info=80000044 errcode=00000000 ilen=00000000
VMExit: intr_info=00000000 errcode=00000000 ilen=00000000
         reason=80000021 qualification=0000000000000000
IDTVectoring: info=00000000 errcode=00000000
TSC Offset = 0xfffda9968024bdbc
EPT pointer = 0x0000000103f1905e
PLE Gap=00000080 Window=00001000
Virtual processor ID = 0x0021

For the control registers, the value I set is shown as shadow not 
actual. What does that mean?

Additionally, I consulted the Intel manual for the meaning of the 
0x80000021 error code, and it appears it is caused by not meeting one or 
more of the requirements for guest state set in Volume 3 Section 27.3.1 
of the Intel manual. I noticed that there are certain requirements for 
tr and ldtr registers even though they are not really used in IA-32e 
mode (see Volume 3 Section 27.3.1.2). I've tried setting them as follows 
to meet those requirements, but that didn't seem to do anything:
   state->sregs.tr.type = 0b11;
   state->sregs.tr.s = 0;
   state->sregs.tr.present = 1;
   state->sregs.tr.g = 1;
   state->sregs.tr.limit = 0xFFFFF;
   state->sregs.tr.unusable = 0;
   state->sregs.tr.selector = 0b100;
   state->sregs.ldt.unusable = 1;

Does that look correct?

I suppose my best course of action now is to go through each check in 
Volume 3 Section 27.3.1 and check each one individually.

Thanks,
Yahya Sohail
