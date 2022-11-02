Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A77B615B65
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 05:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiKBEZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 00:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiKBEZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 00:25:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CEE248ED
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 21:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667363062;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ka7Osup5DV6yuD8HHLmPPzojpLGP5jXKxXOIT/4q/DU=;
        b=VGpJ9RIr7xbTQNwUY6chXOnv6TFDw/DiM7B4MQeAz938KqWZ7uwPqHfEThxEoUaq7QHpGU
        ZmJKEoO+1xyrfwnS2z6lApjS4qvXdbPy/MENU2HzWkSze4hg74OpnTLV742+z899Stf1Ls
        0F3UcXt1C6pv3gxI0Gy5w+apU5LU+NM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-tJw0Rl95PqGJK_D3KWWuTg-1; Wed, 02 Nov 2022 00:24:18 -0400
X-MC-Unique: tJw0Rl95PqGJK_D3KWWuTg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C8118828C1;
        Wed,  2 Nov 2022 04:24:18 +0000 (UTC)
Received: from [10.64.54.151] (vpn2-54-151.bne.redhat.com [10.64.54.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65BFA2166B2D;
        Wed,  2 Nov 2022 04:24:12 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [RFC 1/1] KVM: selftests: rseq_test: use vdso_getcpu() instead of
 syscall()
To:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org
References: <20221102020128.3030511-1-robert.hu@linux.intel.com>
 <20221102020128.3030511-2-robert.hu@linux.intel.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <7371fbbd-25b0-6cb1-0a46-1f1bd194af2e@redhat.com>
Date:   Wed, 2 Nov 2022 12:24:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20221102020128.3030511-2-robert.hu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robert,

On 11/2/22 10:01 AM, Robert Hoo wrote:
> vDSO getcpu() has been in Kernel since 2.6.19, which we can assume
> generally available.
> Use vDSO getcpu() to reduce the overhead, so that vcpu thread stalls less
> therefore can have more odds to hit the race condition.
> 

It would be nice to provide more context to explain how the race
condition is caused.

> Fixes: 0fcc102923de ("KVM: selftests: Use getcpu() instead of sched_getcpu() in rseq_test")
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---
>   tools/testing/selftests/kvm/rseq_test.c | 32 ++++++++++++++++++-------
>   1 file changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index 6f88da7e60be..0b68a6b19b31 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -42,15 +42,29 @@ static void guest_code(void)
>   }
>   
>   /*
> - * We have to perform direct system call for getcpu() because it's
> - * not available until glic 2.29.
> + * getcpu() was added in kernel 2.6.19. glibc support wasn't there
> + * until glibc 2.29.
> + * We can direct call it from vdso to ease gblic dependency.
> + *
> + * vdso manipulation code refers from selftests/x86/test_vsyscall.c
>    */
> -static void sys_getcpu(unsigned *cpu)
> -{
> -	int r;
> +typedef long (*getcpu_t)(unsigned *, unsigned *, void *);
> +static getcpu_t vdso_getcpu;
>   
> -	r = syscall(__NR_getcpu, cpu, NULL, NULL);
> -	TEST_ASSERT(!r, "getcpu failed, errno = %d (%s)", errno, strerror(errno));
> +static void init_vdso(void)
> +{
> +	void *vdso = dlopen("linux-vdso.so.1", RTLD_LAZY | RTLD_LOCAL |
> +			    RTLD_NOLOAD);
> +	if (!vdso)
> +		vdso = dlopen("linux-gate.so.1", RTLD_LAZY | RTLD_LOCAL |
> +			      RTLD_NOLOAD);
> +	if (!vdso)
> +		TEST_ASSERT(!vdso, "failed to find vDSO\n");
> +
> +	vdso_getcpu = (getcpu_t)dlsym(vdso, "__vdso_getcpu");
> +	if (!vdso_getcpu)
> +		TEST_ASSERT(!vdso_getcpu,
> +			    "failed to find __vdso_getcpu in vDSO\n");
>   }
>   

As the comments say, vdso manipulation code comes from selftests/x86/test_vsyscall.c.
I would guess 'linux-vdso.so.1' and 'linux-gate.so.1' are x86 specific. If I'm correct,
the test case will fail on other architectures, including ARM64.

>   static int next_cpu(int cpu)
> @@ -205,6 +219,8 @@ int main(int argc, char *argv[])
>   	struct kvm_vcpu *vcpu;
>   	u32 cpu, rseq_cpu;
>   
> +	init_vdso();
> +
>   	/* Tell stdout not to buffer its content */
>   	setbuf(stdout, NULL);
>   
> @@ -253,7 +269,7 @@ int main(int argc, char *argv[])
>   			 * across the seq_cnt reads.
>   			 */
>   			smp_rmb();
> -			sys_getcpu(&cpu);
> +			vdso_getcpu(&cpu, NULL, NULL);
>   			rseq_cpu = rseq_current_cpu_raw();
>   			smp_rmb();
>   		} while (snapshot != atomic_read(&seq_cnt));
> 

Thanks,
Gavin

