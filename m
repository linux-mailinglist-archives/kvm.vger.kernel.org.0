Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEDB58EBF8
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 14:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbiHJM3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 08:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiHJM3L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 08:29:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 476E47437F
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 05:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660134549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ur0S3vxzmpV2P3Rj1K4ZEdqLq25lb9Wh81DhfR65pxA=;
        b=il1kNtyKCoxfe7zlMv00gMhZXfkk2enD2zz3L5r1kVKzDs5TGUzmVEk4EQLMnj1U6iePdb
        JGVHNi/zaYG6gaR4nGLyuo6YWNTFiM/zhoeD2aoZHJDdEzfs/9Iqa8WZ5S7ceoBH0nXWbY
        SuozpAlkkdlmqs6gYJ/h5pnybQ3LVxE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-IV_vck5JMa6l_OZsbL4duA-1; Wed, 10 Aug 2022 08:29:06 -0400
X-MC-Unique: IV_vck5JMa6l_OZsbL4duA-1
Received: by mail-ej1-f69.google.com with SMTP id qb27-20020a1709077e9b00b0073160a55fd7so2536661ejc.17
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 05:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Ur0S3vxzmpV2P3Rj1K4ZEdqLq25lb9Wh81DhfR65pxA=;
        b=Eq4baSiUzBH+OH2lITAO6TmhhUqv/tOs27U7+1mWECpaBY1B2+HzIP93zqTiC5mGjj
         yo3svuVzvwog346/Lx+xoYy7s6HWlTKRUfy5ko4jhogoUuMopBlJiPCT2xz2nRsJS9/t
         yZ0WKF8w09miBUi/lWtXZtiuPiM2JZiavaDLL0qf4ofaZc8LUyNvDq9BozLBWtw+bIAl
         NX/gpBdPi8Msib4d1YQIpaQROuKp59Q8DPQ2lgbSl34PdER7jqUZz9ILW6BdIn4V9JKT
         Fd6WS77WdKn8YSQ9jwQ8TRMyMdmdP2nThJBJTuk3R97+7MP6DlDPq57zr810yjG2aA6M
         raYg==
X-Gm-Message-State: ACgBeo0RcbuhzDgwdK3eILw5Rxn7V4Q366UinEgy9zSU0T5GZehorb4e
        c4ET19I3XvPBzysGHcJUTxCFiTW/xd+2UDBhwAs1wixzBeVWLAU+RMH3lRafCBHFShn76+1DYru
        KxjnZJhsbFGNK
X-Received: by 2002:a05:6402:35c3:b0:43d:f5d9:b65d with SMTP id z3-20020a05640235c300b0043df5d9b65dmr26615866edc.149.1660134545250;
        Wed, 10 Aug 2022 05:29:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7s6VXCgxCV5nTHcb8Km+7rgGPW/D/i9ZJCl/KMbRISRjqKSsbjTlBqkKW6TQEEF4LuJCo/9g==
X-Received: by 2002:a05:6402:35c3:b0:43d:f5d9:b65d with SMTP id z3-20020a05640235c300b0043df5d9b65dmr26615846edc.149.1660134545002;
        Wed, 10 Aug 2022 05:29:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id f15-20020a50ee8f000000b0043bc4b28464sm7671006edr.34.2022.08.10.05.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 05:29:04 -0700 (PDT)
Message-ID: <1e41a634-0419-e0a8-364c-2e30ed2dbe4d@redhat.com>
Date:   Wed, 10 Aug 2022 14:29:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 1/2] KVM: selftests: Make rseq compatible with
 glibc-2.35
Content-Language: en-US
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Gavin Shan <gshan@redhat.com>
Cc:     kvmarm <kvmarm@lists.cs.columbia.edu>,
        KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kselftest <linux-kselftest@vger.kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        shan gavin <shan.gavin@gmail.com>, maz <maz@kernel.org>,
        andrew jones <andrew.jones@linux.dev>,
        yihyu <yihyu@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        oliver upton <oliver.upton@linux.dev>
References: <20220810104114.6838-1-gshan@redhat.com>
 <20220810104114.6838-2-gshan@redhat.com>
 <876568572.367.1660134156963.JavaMail.zimbra@efficios.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <876568572.367.1660134156963.JavaMail.zimbra@efficios.com>
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

On 8/10/22 14:22, Mathieu Desnoyers wrote:
>>
>> 	/*
>> 	 * Create and run a dummy VM that immediately exits to userspace via
>> @@ -256,7 +244,7 @@ int main(int argc, char *argv[])
>> 			 */
>> 			smp_rmb();
>> 			cpu = sched_getcpu();
>> -			rseq_cpu = READ_ONCE(__rseq.cpu_id);
>> +			rseq_cpu = READ_ONCE(__rseq->cpu_id);
> #include <rseq.h>
> 
> and use
> 
> rseq_current_cpu_raw().

Thanks, I squashed it and queued it for -rc1 (tested on both
glibc 2.34 and 2.35).

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 84e8425edc2c..987a76674f4f 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -29,7 +29,6 @@
  #define NR_TASK_MIGRATIONS 100000
  
  static pthread_t migration_thread;
-static struct rseq_abi *__rseq;
  static cpu_set_t possible_mask;
  static int min_cpu, max_cpu;
  static bool done;
@@ -218,7 +217,6 @@ int main(int argc, char *argv[])
  	r = rseq_register_current_thread();
  	TEST_ASSERT(!r, "rseq_register_current_thread failed, errno = %d (%s)",
  		    errno, strerror(errno));
-	__rseq = rseq_get_abi();
  
  	/*
  	 * Create and run a dummy VM that immediately exits to userspace via
@@ -256,7 +254,7 @@ int main(int argc, char *argv[])
  			 */
  			smp_rmb();
  			cpu = sched_getcpu();
-			rseq_cpu = READ_ONCE(__rseq->cpu_id);
+			rseq_cpu = rseq_current_cpu_raw();
  			smp_rmb();
  		} while (snapshot != atomic_read(&seq_cnt));
  

Paolo

