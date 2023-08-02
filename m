Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94BF76DACD
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 00:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjHBW10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 18:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbjHBW1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 18:27:08 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C7C2130
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 15:25:52 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b9c5e07c1bso3335805ad.2
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 15:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691015152; x=1691619952;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8NueeIcQhehh0vZ2uhP2xsg4tdP5mDg1L1vXP1dHCgc=;
        b=GUpWx2WepTtZ4YY2yzF3h4EK/q9fEEmhWkTwAKSmxWpkvdx/gaS3duDWgs8n7YMwHb
         jvOLRKTzEIn7SyTtg+cyxeKK93LUTVCOwczhNw3gxnDQho0S/yCjOsDxOKDGvkdoNj5x
         M9y07zaPlh1Mh8kh0OveDsMrneIF7f5DT+4/KMTluFlt29g0ni9SF2fBg1qQpA6MEY4x
         50L7LbW5lyygb7dWJdeJAif0Oj5RvWWho0ayhC+E+dJRqiOsrCesTyNrzvYYMoOV343x
         5EAnGET/l9S2k99FF4N2BsLr1TMMuTsKzoVjjtiEVBr0UNrSDb4NYNLDiWcf9NJWly4G
         sVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691015152; x=1691619952;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8NueeIcQhehh0vZ2uhP2xsg4tdP5mDg1L1vXP1dHCgc=;
        b=Vd0NPbO7A/ktngaY/gcCcxjkh7czQE/EWwBK3oLojoVMhlSKmI0TY7nQYWBiHQjVV5
         mwbJGt8bHQhA6BUXyMAoJ+yHhMnWH3Ggf1dvjZ1tfS0qk+MEAesG5q99x0QHVcszAOF9
         dirwcwdi/kNkyERjThCB7pxAuIAiToYUHZwjYPFE3mSlvi5BwozeYQlKiNxprCpE4QXt
         i+6OGNpMjInM50iXmQHJT9SqXn+wbgoG6HgZKyUvHzLdQYhAxh4j6HIXenOW/xjJV2sy
         RjysEeGMR819zo17wdxtU9L8Y/OhGJ0oNvU3u5YXUWhTZ8f1aFD8hvgGV5Sf9UfIr+4G
         VSmA==
X-Gm-Message-State: ABy/qLYndRBKcYDT8Z30NwoKxmllN7MNGAzeBzamrLQj50O53ewQUKxc
        9/Yva3j2QHUCr0+uISugTDl6mksYv8zFlA==
X-Google-Smtp-Source: APBJJlEbbwbyg8Np5bVXnweWNCTz1B78mvGq8ka6z/HQ71m8yvQmn4YpveS1tOHmuFw4GH7cOYoK8g==
X-Received: by 2002:a17:902:9b94:b0:1bb:a6db:3fd0 with SMTP id y20-20020a1709029b9400b001bba6db3fd0mr14764149plp.69.1691015152060;
        Wed, 02 Aug 2023 15:25:52 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902b60d00b001bc16bc9f5fsm5977693pls.284.2023.08.02.15.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 15:25:51 -0700 (PDT)
Date:   Wed, 2 Aug 2023 15:25:45 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 15/19] kvm: handle KVM_EXIT_MEMORY_FAULT
Message-ID: <20230802222545.GC1807130@ls.amr.corp.intel.com>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-16-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230731162201.271114-16-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 12:21:57PM -0400,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> From: Chao Peng <chao.p.peng@linux.intel.com>
> 
> Currently only KVM_MEMORY_EXIT_FLAG_PRIVATE in flags is valid when
> KVM_EXIT_MEMORY_FAULT happens. It indicates userspace needs to do
> the memory conversion on the RAMBlock to turn the memory into desired
> attribute, i.e., private/shared.
> 
> Note, KVM_EXIT_MEMORY_FAULT makes sense only when the RAMBlock has
> gmem memory backend.
> 
> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  accel/kvm/kvm-all.c | 52 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index f9b5050b8885..72d50b923bf2 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -3040,6 +3040,48 @@ static void kvm_eat_signals(CPUState *cpu)
>      } while (sigismember(&chkset, SIG_IPI));
>  }
>  
> +static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
> +{
> +    MemoryRegionSection section;
> +    void *addr;
> +    RAMBlock *rb;
> +    ram_addr_t offset;
> +    int ret = -1;
> +
> +    section = memory_region_find(get_system_memory(), start, size);
> +    if (!section.mr) {
> +        return ret;
> +    }
> +
> +    if (memory_region_can_be_private(section.mr)) {
> +        if (to_private) {
> +            ret = kvm_set_memory_attributes_private(start, size);
> +        } else {
> +            ret = kvm_set_memory_attributes_shared(start, size);
> +        }
> +
> +        if (ret) {
> +            return ret;
> +        }
> +
> +        addr = memory_region_get_ram_ptr(section.mr) +
> +               section.offset_within_region;
> +        rb = qemu_ram_block_from_host(addr, false, &offset);

Here we have already section. section.mr->ram_block.  We don't have to
scan the existing RAMBlocks.

Except that, looks good to me.
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
