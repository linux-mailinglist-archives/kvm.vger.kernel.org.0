Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70E077DABF
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 08:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242214AbjHPGzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 02:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242213AbjHPGzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 02:55:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F07610E7
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 23:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692168861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VgxVBCPXJnsNLI+46xSarM00ICOkVY08GNNNdoBDjSY=;
        b=EU7OUBkFv/mdgYOzep8HRi9BXNUVVwcqiwe8MdSIualAjZXNq9Y8xiF8SNzMAGRY6NtPVe
        PwV+fulbF94hAHYXwSBx1QuGzReunuE+b+nrNs0jVGehvCHh+NNYOsxa0+L4y9+HPEyyvM
        m2vCCankaejbi9Ogd9GGeaLV7Oa2Lyc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-lisf7NdGMx6joRrJcPoq1Q-1; Wed, 16 Aug 2023 02:54:20 -0400
X-MC-Unique: lisf7NdGMx6joRrJcPoq1Q-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-26b62afbd28so623596a91.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 23:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692168859; x=1692773659;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VgxVBCPXJnsNLI+46xSarM00ICOkVY08GNNNdoBDjSY=;
        b=BaXlJUgopR0uZIH99b8jbANQ/CBBiIoYpjBBuJ/xhJrszeaQ5mYnrlGGVldKzvSI1O
         QcZ3/4/XZNEyHYEWPK7bAEjgItmGMA3Yu+ITI7up80kZlf1j2YTfzoJJ2IBeNwwKxskt
         spXRQ0l7NsAT6gV1NzFV9pD/Ig5ntZKRG6NMMUUWuPAxDDRR8CFKq9LxosNG78xvYlNv
         zwsU8RNyG+Laa2GcQAZcbq38J1QlbAp/yCtQ1JNtbAFAwqoRSc4mVJbZFhAohaLwqpSZ
         hpRpUoQsYhZOpOXpt/YUWfA0ZgO5yoifjju+PnNYzfyE9tCX5ZQTGF0OJeCyv9BECYsB
         uDVQ==
X-Gm-Message-State: AOJu0YwpKK9+Dj34N7+Cpfq3KEKPgaVYIkaog52lMWfb/sHuwbgEJ0YA
        ysaeNk5HClAc/z25GAuttR2gveya71jsPd07OqsunuopSDa7MXRuZbTk+9h+7VX7nEwa/I+loi3
        h2NX7KGnXKgrK
X-Received: by 2002:a17:90a:3ee5:b0:26b:27f6:90cc with SMTP id k92-20020a17090a3ee500b0026b27f690ccmr770935pjc.2.1692168859072;
        Tue, 15 Aug 2023 23:54:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEd1P04owTF2cdwpf0pccpR9NLO2ED6eD6S+SvhMYjVhqIN6dPlHq32ucBOvg9alBVH6mrqyw==
X-Received: by 2002:a17:90a:3ee5:b0:26b:27f6:90cc with SMTP id k92-20020a17090a3ee500b0026b27f690ccmr770914pjc.2.1692168858740;
        Tue, 15 Aug 2023 23:54:18 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id gk18-20020a17090b119200b00263ba6a248bsm12594305pjb.1.2023.08.15.23.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 23:54:18 -0700 (PDT)
Message-ID: <eaa2519e-15b3-2fd4-199e-8e3368df7e0d@redhat.com>
Date:   Wed, 16 Aug 2023 14:54:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 10/11] KVM: arm64: selftests: Import automatic system
 register definition generation from kernel
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-11-jingzhangos@google.com>
Content-Language: en-US
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230807162210.2528230-11-jingzhangos@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On 8/8/23 00:22, Jing Zhang wrote:
> Import automatic system register definition generation from kernel and
> update system register usage accordingly.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index c692cc86e7da..a8cf0cb04db7 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -200,14 +200,15 @@ ifeq ($(ARCH),x86_64)
>   LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
>   else
>   LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
> +ARCH_GENERATED_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include/generated
>   endif
>   CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
> -	-Wno-gnu-variable-sized-type-not-at-end -MD\
> +	-Wno-gnu-variable-sized-type-not-at-end -MD \
>   	-fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
>   	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>   	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
>   	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
> -	$(KHDR_INCLUDES)
> +	-I$(ARCH_GENERATED_INCLUDE) $(KHDR_INCLUDES)
>   ifeq ($(ARCH),s390)
>   	CFLAGS += -march=z10
>   endif
> @@ -255,8 +256,16 @@ $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
>   $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
>   	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
>   
> +ifeq ($(ARCH),arm64)
> +GEN_SYSREGS := $(ARCH_GENERATED_INCLUDE)/asm/sysreg-defs.h
> +ARCH_TOOLS := $(top_srcdir)/tools/arch/$(ARCH)/tools/
> +
> +$(GEN_SYSREGS): $(ARCH_TOOLS)/gen-sysreg.awk $(ARCH_TOOLS)/sysreg
> +	mkdir -p $(dir $@); awk -f $(ARCH_TOOLS)/gen-sysreg.awk $(ARCH_TOOLS)/sysreg > $@
> +endif
> +
>   x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> -$(TEST_GEN_PROGS): $(LIBKVM_OBJS)
> +$(TEST_GEN_PROGS): $(LIBKVM_OBJS) $(GEN_SYSREGS)

I don't this this really works. Since the $(GEN_SYSREG) is the 
prerequisites of $(TEST_GEN_PROGS). Only when $(TEST_GEN_PROGS) being 
compiled, the $(GEN_SYSREG) can be generated.

But the fact is, the $(TEST_GEN_PROGS) is relies on $(TEST_GEN_OBJ), 
which means $(TEST_GEN_OBJ) will be compiled before $(TEST_GEN_PROGS), 
but $(TEST_GEN_OBJ) depends on $(GEN_SYSREG) again, at the time, the 
$(GEN_SYSREG) hasn't been generated, so it will has error:

No such file or directory.

#include "asm/sysreg-defs.h"

I think the correct way to generate $(GEN_SYSREGS) is add a prerequisite 
for $(TEST_GEN_OBJ), like:

$(TEST_GEN_OBJ): $(GEN_SYSREGS)

Thanks,
Shaoqin

>   $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
>   
>   cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
-- 
Shaoqin

