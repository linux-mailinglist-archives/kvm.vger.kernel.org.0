Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B710C729422
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 11:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241013AbjFIJFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 05:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241092AbjFIJFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 05:05:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745962711
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 02:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686301475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TLk6gSKtsM+p9Rtgq5+IZGVTEjc3fvT8GmlHeUGj3wU=;
        b=ehUwn+5fAisgAEtAIMl5EIJdeclqSq8CTML5XxKV3vnBdSoKWM2gHwMxwSDWO0iw5VXJLh
        8SS/MgxwDJJJA3Tt6AO+Slri6c8ud7wu7sku5IGptOdbBlKOktrAg+YkIdnNEDgtpKVACA
        bxrEekcdTsq3Acc+35VY7WKEzTLjEFM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-wTqRt9dDOn-ibtZ3MK628A-1; Fri, 09 Jun 2023 05:04:34 -0400
X-MC-Unique: wTqRt9dDOn-ibtZ3MK628A-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9715654ab36so150684366b.0
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 02:04:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686301473; x=1688893473;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TLk6gSKtsM+p9Rtgq5+IZGVTEjc3fvT8GmlHeUGj3wU=;
        b=QnU8pdGpWyJIWFNqDZyo6LztUgowCgtsCKfwong98jKA0OSf8+m9oC1L3jNk7tN2k+
         NIWrNl6TI86LWpUHi3iY/3Bgms4v4PnSJxCg9guup/F4oeRVERPlYst1qMC60PVkozRC
         bYTNpqXX3YYbs0lnMxc/KowloJ00xPIWnBfa4GcFPAWOPDPOLpEeTfZBETVPds9Sy3WB
         4bo+uMP2d1Ois+/wCauc7/MoZ7nO4wyaNg6urQVAfdNJbFYBaw1MKY2NQxRNHCxukNGu
         bRnGITb1331WZ72BSxB/Z+kBFbCWBHNNC0T7i/4SJl4nsJzwpYUZH/et1RkRdAPFl7q+
         nChA==
X-Gm-Message-State: AC+VfDzFIKcanI9mKvlmaTSE3VUydtevxUK9Pq4Oo2APOtiG8+PtMgzj
        bHHbZwBRjDopTQUyDyZSjUmmlyMQrc/DkHGG5ZgCuj2C6JdXKz+2v5J4kBJbpV6PatVj9jALyOP
        PGqoiNSIXv+xd
X-Received: by 2002:a17:907:c15:b0:94e:1764:b09b with SMTP id ga21-20020a1709070c1500b0094e1764b09bmr1027460ejc.45.1686301472972;
        Fri, 09 Jun 2023 02:04:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4KrasOi5l6sCNShc9kV8qfG1eq+fRbvkSLL3UxeHKWwdsKczbSQdc/+63BzxHLxAbWxA2H7A==
X-Received: by 2002:a17:907:c15:b0:94e:1764:b09b with SMTP id ga21-20020a1709070c1500b0094e1764b09bmr1027414ejc.45.1686301472616;
        Fri, 09 Jun 2023 02:04:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id v5-20020a170906858500b0096f72424e00sm1013932ejx.131.2023.06.09.02.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 02:04:32 -0700 (PDT)
Message-ID: <e948d02f-cd93-b6e2-72fd-123e483f66fe@redhat.com>
Date:   Fri, 9 Jun 2023 11:04:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH mm-unstable v2 01/10] mm/kvm: add
 mmu_notifier_ops->test_clear_young()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>, Yu Zhao <yuzhao@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alistair Popple <apopple@nvidia.com>,
        Anup Patel <anup@brainfault.org>,
        Ben Gardon <bgardon@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Gavin Shan <gshan@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Larabel <michael@michaellarabel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paul Mackerras <paulus@ozlabs.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-trace-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@google.com
References: <20230526234435.662652-1-yuzhao@google.com>
 <20230526234435.662652-2-yuzhao@google.com> <ZHedMX470b7EMwbe@ziepe.ca>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZHedMX470b7EMwbe@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/23 21:17, Jason Gunthorpe wrote:
>> +	int (*test_clear_young)(struct mmu_notifier *mn, struct mm_struct *mm,
>> +				unsigned long start, unsigned long end,
>> +				bool clear, unsigned long *bitmap);
>> +
> Why leave clear_young behind? Just make a NULL bitmap mean
> clear_young?

It goes away in patch 2, together with:

@@ -437,7 +412,7 @@ static inline int mmu_notifier_clear_young(struct mm_struct *mm,
  					   unsigned long end)
  {
  	if (mm_has_notifiers(mm))
-		return __mmu_notifier_clear_young(mm, start, end);
+		return __mmu_notifier_test_clear_young(mm, start, end, true, NULL);
  	return 0;
  }
  
@@ -445,7 +420,7 @@ static inline int mmu_notifier_test_young(struct mm_struct *mm,
  					  unsigned long address)
  {
  	if (mm_has_notifiers(mm))
-		return __mmu_notifier_test_young(mm, address);
+		return __mmu_notifier_test_clear_young(mm, address, address + 1, false, NULL);
  	return 0;
  }
  

Paolo

