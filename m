Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53D8722D5E
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbjFERJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbjFERJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:09:44 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3647A91;
        Mon,  5 Jun 2023 10:09:44 -0700 (PDT)
Received: from [172.27.2.41] ([73.231.166.163])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 355H9Nti3949316
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 5 Jun 2023 10:09:23 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 355H9Nti3949316
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023051001; t=1685984965;
        bh=ARF61ZCq+kfZkPMQEa+3a7MUblrckeT4wBBe6OxOWqk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kLNPGYrIKcXROHv8jwO1WZiri1/A10Ss1zcQ9NVC+sbbYF9LOTQEoRTwTUmK8WZX9
         fEnQa+qdsMyzHHJaa7HP+NnkJXwvh9iktpKHj2WSprTAcrYZ3YfXc7Gn14NvYj7pQC
         /fVqZD06JAyfaICj74MFnhxabt8z55E84YQOMSr+6bBVLvMpr4Y9KITl/JNx4oT/j9
         6sK2jzcjakh4ZDvB5vd5bxSLTrWpViR446qRD6MBRAJChsRWTZNYunJw+9tKTfiRit
         T2kHzIXzuDcWnML3Me1nCKY/RTMkgK36xHXeNxDWqYdG93K893zt9AI61uhcvt3KMO
         s+wab0M9PfyZQ==
Message-ID: <70ef07f1-e3b7-7c4e-01ac-11f159a87a6b@zytor.com>
Date:   Mon, 5 Jun 2023 10:09:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, Xin Li <xin3.li@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        peterz@infradead.org, andrew.cooper3@citrix.com, seanjc@google.com,
        pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-2-xin3.li@intel.com> <87leh08e1h.ffs@tglx>
 <87edmp6doh.ffs@tglx>
From:   "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <87edmp6doh.ffs@tglx>
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

On 6/5/23 10:07, Thomas Gleixner wrote:
> On Sat, Jun 03 2023 at 22:51, Thomas Gleixner wrote:
>> On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
>>> IRQ_MOVE_CLEANUP_VECTOR is the only one of the system IRQ vectors that
>>> is *below* FIRST_SYSTEM_VECTOR. It is a slow path, so just push it
>>> into common_interrupt() just before the spurious interrupt handling.
>>
>> This is a complete NOOP on not FRED enabled systems as the IDT entry is
>> still separate. So this change makes no sense outside of the FRED
>> universe. Can we pretty please make this consistent?
> 
> The right thing to make this consistent is to get rid of this vector
> completely.
> 
> There is zero reason for this to be an IPI. This can be delegated to a
> worker or whatever delayed mechanism.
> 

As we discussed offline, I agree that this is a better solution (and 
should be a separate changeset before the FRED one.)

	-hpa
