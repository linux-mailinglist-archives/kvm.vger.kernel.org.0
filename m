Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C15557501D
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 15:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239884AbiGNNzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 09:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240325AbiGNNza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 09:55:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61B8168DE8
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 06:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657806732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/DbMY4fkJWP+PysgOKi02iEpV+7O3rbRErGJbwgQ+eQ=;
        b=gdoCgCRJ3po2Ot7ONu2/y0Qj3x0d1Ugib2Kf+4ns5tVDwrRW7YyQzKaMtl2XPRsqJBVau3
        GH//dMcnvi+v0SniruIOLK79VP43AX5H30cmY8RCE4zqVgfUxQAuO/ayfPvWJFu9hpzfJa
        +XwALvj2nVosWpdwJPPRtij6zxBE5d4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-LYG0CypaOnufaG8xmU7dyg-1; Thu, 14 Jul 2022 09:52:09 -0400
X-MC-Unique: LYG0CypaOnufaG8xmU7dyg-1
Received: by mail-ej1-f72.google.com with SMTP id sb15-20020a1709076d8f00b0072b692d938cso798907ejc.10
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 06:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/DbMY4fkJWP+PysgOKi02iEpV+7O3rbRErGJbwgQ+eQ=;
        b=5/k2umyBBBwqttpmfdb7sIiopGHQH+Bulsysr9WhOu8gR+Eul91MjhjEebj5eTqu0z
         HD1A4WjHjWt1gQHYZM5GIEs4uBjcOnjTQCzeOhmnu9aI/eWQVyACBhzmRj84rrTLRkcs
         LDH2DugVr8hB03gxMnV6iheThSI/j6lRQzWK97MC09bHoPP7ALD86aSDK+3sbhjIUQ8R
         qqbI9esScDZB0WLI+23OlppndaMfQjBzk7aVO59Lq1kIzo+4IrPxfqApEBfnGlIUbRyD
         NRNZgnSa4tprbASKdlaTL1jIAvB0STwNN3lW3Kl9COunPuH29XRDK3fkpe1U4dk7kyQQ
         l6iw==
X-Gm-Message-State: AJIora8AmrmjBou6XikRLZQfwPmKWh+XouYquoWKhC2c5nWypNcuXnBt
        N/uAMZELaVcLtiqoqo22dnzVxEfeePCAuwmISJI/bAHo040mKU37tAvW0EFTGkChxugDD+Qqdr2
        y3pc+iK1ABI5i
X-Received: by 2002:a05:6402:5388:b0:435:71b:5d44 with SMTP id ew8-20020a056402538800b00435071b5d44mr12127181edb.364.1657806727935;
        Thu, 14 Jul 2022 06:52:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t9j243sp0KAU90kUpGzuuJ6eriMDQU6VG9uY7+LPoOkHNVc5QAtLQp/FA07g5PE0QNkP3Luw==
X-Received: by 2002:a05:6402:5388:b0:435:71b:5d44 with SMTP id ew8-20020a056402538800b00435071b5d44mr12127159edb.364.1657806727740;
        Thu, 14 Jul 2022 06:52:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id s18-20020a170906501200b007121361d54asm734486ejj.25.2022.07.14.06.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 06:52:07 -0700 (PDT)
Message-ID: <c5d81d4a-5002-3ffe-e70e-f4238da873c5@redhat.com>
Date:   Thu, 14 Jul 2022 15:52:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] KVM: selftests: Double check on the current CPU in
 rseq_test
Content-Language: en-US
To:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com,
        mathieu.desnoyers@efficios.com, shuah@kernel.org, maz@kernel.org,
        oliver.upton@linux.dev, shan.gavin@gmail.com
References: <20220714080642.3376618-1-gshan@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220714080642.3376618-1-gshan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/14/22 10:06, Gavin Shan wrote:
> In rseq_test, there are two threads created. Those two threads are
> 'main' and 'migration_thread' separately. We also have the assumption
> that non-migration status on 'migration-worker' thread guarantees the
> same non-migration status on 'main' thread. Unfortunately, the assumption
> isn't true. The 'main' thread can be migrated from one CPU to another
> one between the calls to sched_getcpu() and READ_ONCE(__rseq.cpu_id).
> The following assert is raised eventually because of the mismatched
> CPU numbers.
> 
> The issue can be reproduced on arm64 system occasionally.
> 
>    host# uname -r
>    5.19.0-rc6-gavin+
>    host# # cat /proc/cpuinfo | grep processor | tail -n 1
>    processor    : 223
>    host# pwd
>    /home/gavin/sandbox/linux.main/tools/testing/selftests/kvm
>    host# for i in `seq 1 100`;   \
>          do echo "--------> $i"; \
>          ./rseq_test; sleep 3;   \
>          done
>    --------> 1
>    --------> 2
>    --------> 3
>    --------> 4
>    --------> 5
>    --------> 6
>    ==== Test Assertion Failure ====
>      rseq_test.c:265: rseq_cpu == cpu
>      pid=3925 tid=3925 errno=4 - Interrupted system call
>         1  0x0000000000401963: main at rseq_test.c:265 (discriminator 2)
>         2  0x0000ffffb044affb: ?? ??:0
>         3  0x0000ffffb044b0c7: ?? ??:0
>         4  0x0000000000401a6f: _start at ??:?
>      rseq CPU = 4, sched CPU = 27
> 
> This fixes the issue by double-checking on the current CPU after
> call to READ_ONCE(__rseq.cpu_id) and restarting the test if the
> two consecutive CPU numbers aren't euqal.
> 
> Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>   tools/testing/selftests/kvm/rseq_test.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index 4158da0da2bb..74709dd9f5b2 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -207,7 +207,7 @@ int main(int argc, char *argv[])
>   {
>   	int r, i, snapshot;
>   	struct kvm_vm *vm;
> -	u32 cpu, rseq_cpu;
> +	u32 cpu, rseq_cpu, last_cpu;
>   
>   	/* Tell stdout not to buffer its content */
>   	setbuf(stdout, NULL);
> @@ -259,8 +259,9 @@ int main(int argc, char *argv[])
>   			smp_rmb();
>   			cpu = sched_getcpu();
>   			rseq_cpu = READ_ONCE(__rseq.cpu_id);
> +			last_cpu = sched_getcpu();
>   			smp_rmb();
> -		} while (snapshot != atomic_read(&seq_cnt));
> +		} while (snapshot != atomic_read(&seq_cnt) || cpu != last_cpu);
>   
>   		TEST_ASSERT(rseq_cpu == cpu,
>   			    "rseq CPU = %d, sched CPU = %d\n", rseq_cpu, cpu);

Queued for -rc, thanks.

Paolo

