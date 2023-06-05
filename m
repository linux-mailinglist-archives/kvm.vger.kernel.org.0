Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD56722D80
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbjFERTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjFERTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:19:37 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC7A99;
        Mon,  5 Jun 2023 10:19:36 -0700 (PDT)
Received: from [172.27.2.41] ([73.231.166.163])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 355HJARO3951140
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 5 Jun 2023 10:19:15 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 355HJARO3951140
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023051001; t=1685985564;
        bh=DULmQU2C3VCyHfZq5bD6jIOzzpqFGhvQ9Ua2jRpb2tk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nlINNk/ynFaHdaUzCL80NlOOCuMjwkyNdgiYalu1HkgfGu5y3SP5upzPuAHO+seG3
         coBQ1gPPdy0N35pRebJAkp6EfAzYcS8fFZ5ln1MNr9PtceeLB40bVZbXBCg9BdgY1R
         PAme39FSg5OqOpr8DEL3Iv+8u3W1O6usO7c8fnwDDzK/29auiWmVKyzHmGtNE96NgP
         9It7gkaYzgc7Fiy3gNywjgqc8FIhv69LBq0K5lurjgDa8qX1j+9AHfTEARx1CYRVYu
         RiJjmFSjOwc06PhkEVG/7AB2lppfJZqTZkN7XQ4aw0I+ykBF3JhMdYeOBpFoFcodW3
         JPJ0SNwgRhKZw==
Message-ID: <01d50e80-7d58-6dc8-73d4-bd8ad1d1bec0@zytor.com>
Date:   Mon, 5 Jun 2023 10:19:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 09/33] x86/cpu: add X86_CR4_FRED macro
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, Xin Li <xin3.li@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        peterz@infradead.org, andrew.cooper3@citrix.com, seanjc@google.com,
        pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-10-xin3.li@intel.com> <87r0qq6rtm.ffs@tglx>
From:   "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <87r0qq6rtm.ffs@tglx>
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

On 6/5/23 05:01, Thomas Gleixner wrote:
> On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
> 
>> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
>>
>> Add X86_CR4_FRED macro for the FRED bit in %cr4. This bit should be a
> 
> s/should/must/ no?
> 
>> +/*
>> + * These bits should not change their value after CPU init is finished.
>> + * The explicit cast to unsigned long suppresses a warning on i386 for
>> + * x86-64 only feature bits >= 32.
>> + */
>>   static const unsigned long cr4_pinned_mask =
>> -	X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP |
>> -	X86_CR4_FSGSBASE | X86_CR4_CET;
>> +	(unsigned long)
> 
> That type cast is required because:
> 
> +#define X86_CR4_FRED		_BITULL(X86_CR4_FRED_BIT)
> 
> Bah. Fred is 64 bit only. So why defining this as 1ULL << 32
> unconditionally and stripping the bit off on 32bit via the type cast?
> 
> #ifdef CONFIG_X86_64
> #define X86_CR4_FRED		_BITUL(X86_CR4_FRED_BIT)
> #else
> #define X86_CR4_FRED		0
> #endif
> 
> would be too obvious, right?
> 

It also adds an #ifdef mess to avoid a simple typecast. Is that the 
right tradeoff?

I'm not saying it is or it isn't, it is an open question.

	-hpa


