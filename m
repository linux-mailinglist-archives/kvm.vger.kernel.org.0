Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745076173A5
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 02:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiKCBSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 21:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKCBSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 21:18:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD78860FB
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 18:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667438227;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NmQsZmBTCkuGAN896yyMOVJWW9s2mj/JMAQxe0Fh0uA=;
        b=WGNkkU0oMJW/orYr+cebTiKbBhyHHcuNx5Ergo+rwZEWmtlLdEuA5RHCX+ossy1Vkp8Jtg
        ak/PfKTPihgom4xdf1n1l760VZxDCfwyvwMdxr15jJ6CNTxk078YPcwGJ+zC3ZCAUHwqy4
        RihZx81F0MEx/mGfh1umWDAwOdwoHIw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-xLGLhBxvNFOGw3Gl-VT7CA-1; Wed, 02 Nov 2022 21:17:04 -0400
X-MC-Unique: xLGLhBxvNFOGw3Gl-VT7CA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4089101A52A;
        Thu,  3 Nov 2022 01:17:03 +0000 (UTC)
Received: from [10.64.54.56] (vpn2-54-56.bne.redhat.com [10.64.54.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B9C9140EBF5;
        Thu,  3 Nov 2022 01:17:01 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [RFC 1/1] KVM: selftests: rseq_test: use vdso_getcpu() instead of
 syscall()
To:     Sean Christopherson <seanjc@google.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
References: <20221102020128.3030511-1-robert.hu@linux.intel.com>
 <20221102020128.3030511-2-robert.hu@linux.intel.com>
 <Y2MPe3qhgQG0euE0@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <b7ae920f-dae0-b3f3-aba3-944cb73c19c2@redhat.com>
Date:   Thu, 3 Nov 2022 09:16:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y2MPe3qhgQG0euE0@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/22 8:46 AM, Sean Christopherson wrote:
> On Wed, Nov 02, 2022, Robert Hoo wrote:
>> vDSO getcpu() has been in Kernel since 2.6.19, which we can assume
>> generally available.
>> Use vDSO getcpu() to reduce the overhead, so that vcpu thread stalls less
>> therefore can have more odds to hit the race condition.
>>
>> Fixes: 0fcc102923de ("KVM: selftests: Use getcpu() instead of sched_getcpu() in rseq_test")
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> ---
> 
> ...
> 
>> @@ -253,7 +269,7 @@ int main(int argc, char *argv[])
>>   			 * across the seq_cnt reads.
>>   			 */
>>   			smp_rmb();
>> -			sys_getcpu(&cpu);
>> +			vdso_getcpu(&cpu, NULL, NULL);
>>   			rseq_cpu = rseq_current_cpu_raw();
>>   			smp_rmb();
>>   		} while (snapshot != atomic_read(&seq_cnt));
> 
> Something seems off here.  Half of the iterations in the migration thread have a
> delay of 5+us, which should be more than enough time to complete a few getcpu()
> syscalls to stabilize the CPU.
> 
> Has anyone tried to figure out why the vCPU thread is apparently running slow?
> E.g. is KVM_RUN itself taking a long time, is the task not getting scheduled in,
> etc...  I can see how using vDSO would make the vCPU more efficient, but I'm
> curious as to why that's a problem in the first place.
> 
> Anyways, assuming there's no underlying problem that can be solved, the easier
> solution is to just bump the delay in the migration thread.  As per its gigantic
> comment, the original bug reproduced with up to 500us delays, so bumping the min
> delay to e.g. 5us is acceptable.  If that doesn't guarantee the vCPU meets its
> quota, then something else is definitely going on.
> 

I doubt if it's still caused by busy system as mentioned previously [1]. At least,
I failed to reproduce the issue on my ARM64 system until some workloads are enforced
to hog CPUs. Looking at the implementation syscall(NR_getcpu), it's simply to copy
the per-cpu data from kernel to userspace. So I don't see it should consume lots
of time. As system call is handled by interrupt/exception, the time consumed by
the interrupt/exception handler should be architecture dependent. Besides, the time
needed by ioctl(KVM_RUN) also differs on architectures.

[1] https://lore.kernel.org/kvm/d8290cbe-5d87-137a-0633-0ff5c69d57b0@redhat.com/

I think Sean's suggestion to bump the delay to 5us would be the quick fix if it helps.
However, more time will be needed to complete the test. Sean, do you mind to reduce
NR_TASK_MIGRATIONS from 100000 to 20000 either?

Thanks,
Gavin

