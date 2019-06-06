Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C4036937
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 03:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfFFBav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 21:30:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:62051 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfFFBav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 21:30:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 18:30:49 -0700
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.239.196.166]) ([10.239.196.166])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 05 Jun 2019 18:30:48 -0700
Subject: Re: [RESEND PATCH v3] KVM: x86: Add Intel CPUID.1F cpuid emulation
 support
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
References: <20190526133052.4069-1-like.xu@linux.intel.com>
 <20190603165616.GA11101@flask> <20190603191818.GF13384@linux.intel.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <5e49ff48-9071-1419-ee36-bbc857164c28@linux.intel.com>
Date:   Thu, 6 Jun 2019 09:30:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603191818.GF13384@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/6/4 3:18, Sean Christopherson wrote:
> On Mon, Jun 03, 2019 at 06:56:17PM +0200, Radim Krčmář wrote:
>>> +			break;
>>> +		}
>>>   		entry->eax = min(entry->eax, (u32)(f_intel_pt ? 0x14 : 0xd));
>>
>> Similarly in the existing code.  If we don't have f_intel_pt, then we
>> should make sure that leaf 0x14 is not being filled, but we don't really
>> have to limit the maximal index.
>>
>> Adding a single clamping like
>>
>> 		/* Limited to the highest leaf implemented in KVM. */
>> 		entry->eax = min(entry->eax, 0x1f);
>>
>> seems sufficient.
>>
>> (Passing the hardware value is ok in theory, but it is a cheap way to
>>   avoid future leaves that cannot be simply zeroed for some weird reason.)
> 
> I don't have a strong opinion regarding the code itself, but whatever ends
> up getting committed should have a big beefy changelog explaining why the
> clamping exists, or at least extolling its virtues.  I had a hell of a
> time understanding the intent of this one line of code because as your
> response shows, there is no one right answer.
> 

Hi Radim & Sean,

Thanks for your review and finally we find a better way.

Please help review the new version, I am not sure that the changelog 
could help new submitter understand why the clamping exists.
