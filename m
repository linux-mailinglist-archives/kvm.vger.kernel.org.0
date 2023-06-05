Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7763A722D15
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 18:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbjFEQ4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 12:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbjFEQ4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 12:56:03 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A46FE8;
        Mon,  5 Jun 2023 09:56:02 -0700 (PDT)
Received: from [172.27.2.41] ([73.231.166.163])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 355Gtg3v3944865
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 5 Jun 2023 09:55:42 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 355Gtg3v3944865
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023051001; t=1685984144;
        bh=KcP52s6Jw81oN0ddZllHGZWFTWEw/h5qK+0sGBKaOvQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=GdQsEfqH+ayBj0hAAn8mpzHQWafKlnObqngLYYTdkre0rsaSsmWB6UIxeTlTGLO0V
         VNsnnBiJQ6dWpKMDr3XN4cd9XTfy1zwN4pA9T+fA1eQcAqDphst2LFrSeyrfbXkFow
         q5MnSobQSYrLM5nyzvn+nCBDtJ75nu2sW+za7DcvdF7d1TS8RqSdrBJuFvUZNV+HWg
         DtXi9no/UF1dauuKoKYuw7N2u8Cv9UtrLyruHK5RdPBI3XIk5oNlg7warB0ikLoCPY
         8u4TFdjsbPQytToeL2I9Z1L3TEpuhMcOPp0awscThA2b/iC1XZE37m/MlijLazwGoT
         YilmBo9KmoDlg==
Message-ID: <2d069dc4-6383-57f2-819c-23b7d65f460e@zytor.com>
Date:   Mon, 5 Jun 2023 09:55:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 29/33] x86/fred: allow FRED systems to use interrupt
 vectors 0x10-0x1f
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, Xin Li <xin3.li@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        peterz@infradead.org, andrew.cooper3@citrix.com, seanjc@google.com,
        pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-30-xin3.li@intel.com> <87zg5e57go.ffs@tglx>
From:   "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <87zg5e57go.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/5/23 07:06, Thomas Gleixner wrote:
> On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
>> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
>>
>> FRED inherits the Intel VT-x enhancement of classified events with
>> a two-level event dispatch logic. The first-level dispatch is on
>> the event type, and the second-level is on the event vector. This
>> also means that vectors in different event types are orthogonal,
>> thus, vectors 0x10-0x1f become available as hardware interrupts.
>>
>> Enable interrupt vectors 0x10-0x1f on FRED systems (interrupt 0x80 is
>> already enabled.) Most of these changes are about removing the
>> assumption that the lowest-priority vector is hard-wired to 0x20.
> 
> I'm not really interested in this again premature optimization.
> 
> Can we please clarify how the final result of FRED vector layout will
> look like?
> 
> I rather give up on reclaiming these 16 vectors than making _all_ system
> vectors dynamically assignable to avoid an extra partitioning of the
> vector space.
> 

So this patch was meant to go *after* the FRED patch set proper.

This patch does not change any of the system vectors except, by 
necessity, IRQ_MOVE_CLEANUP_VECTOR, nor does it change the way they are 
assigned to fixed vectors today.

It does make the lowest *non*-system vector a variable, but the system 
vectors are at the end.

This is something that should be commented: the setting of bits in 
system_vector is really misleading: those aren't "system vectors", they 
are the vectors reserved for hardware use. On IDT, this means vectors 
0-31 because they are used for exceptions, but on FRED interrupts and 
exceptions are separate; however vectors 0-15 still need to be reserved 
because the APIC doesn't support them.

We *could* change that, but that is completely independent of this.

	-hpa
