Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA175618A22
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 22:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiKCVEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 17:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiKCVEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 17:04:05 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C172626E0;
        Thu,  3 Nov 2022 14:04:04 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b11so2830024pjp.2;
        Thu, 03 Nov 2022 14:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RKpWMQos6VVD1S/I4lACLsmO/tYS5LRA7d2ENkEKbRo=;
        b=W1jfdVvCiC74H1TrCZBHpy39zmLx6ZdDw7CTvEA3hQRy2SYEYEHpqHKEqbYIPLurIe
         Y2whGNqDI5mui4w+1QXrkHh+GC9ATmNd8ps8PeHw3qaJpwgt1d7jvMCXqs25Zy8Lpx4o
         BRkdqU5nSWSpkaBgaA/lV+5CSWVpabSirQHa1cejuentrhT/uERBbBImlSMJgf6A967J
         fjOlpx3kn0dIaEHhhAKeVdXj4/EkPaL2dmbdM+AJdzuPv1TA2eEp2KkYLi7TVhEuAixL
         VUk9wO+wTZMMnlMLn0pWY/lQ/5O1/2ysb54mA9Nupm245dVRVUlabq2dQWglwCNzBaAj
         yq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RKpWMQos6VVD1S/I4lACLsmO/tYS5LRA7d2ENkEKbRo=;
        b=x3iHn7CNvIqQQgDOGl/E3Ac5YwOnedUbymwRWwkPApkAWLBj8Pxmgnbpp4wfyJ5fdH
         MKKiPCVG1xHFM5wygR7xKrxcoynlHkkZbVlh+txZBX4RE326uAUd7UnSOE5EfNIfebib
         AUYt6TJNXkrwmSLVOifQV1xYBlWM5R7WJAm7a40eLtQuLTGzmZxYltaBIboM85ElhE3e
         +u+O1WF3KrF2BBd3qgxRRNI4ZeM6hkwemxIZ6ubnfJQIq10gAPWm4sAPSj9sbCsXB1O3
         tghyJKv12qKe0KcuK6HefQx4Or9afXil+HIbuxLp+c+koOcCQj95YwNwdIfoY91G8dyR
         Ue4A==
X-Gm-Message-State: ACrzQf1Ii/nW03dqtegu/Oqr9KADH78WXudIhISRktW7GhEWkW6Hrij/
        yPRrmnX2nv2SBPjuffoz+RI=
X-Google-Smtp-Source: AMsMyM4B7LXLMUo1WLny520SMeR1sIUEIak6LqJqMDk6N+6eScsWNFNrZpvHK/6RhT2SJsSNsCUIWw==
X-Received: by 2002:a17:902:e5c5:b0:186:5f09:8468 with SMTP id u5-20020a170902e5c500b001865f098468mr32699741plf.122.1667509444114;
        Thu, 03 Nov 2022 14:04:04 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id 27-20020a63125b000000b0046a1c832e9fsm1137383pgs.34.2022.11.03.14.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 14:04:03 -0700 (PDT)
Date:   Thu, 3 Nov 2022 14:04:02 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>, isaku.yamahata@gmail.com
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
Message-ID: <20221103210402.GB1063309@ls.amr.corp.intel.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221102231911.3107438-37-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022 at 11:19:03PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> From: Chao Gao <chao.gao@intel.com>
> 
> Do compatibility checks when enabling hardware to effectively add
> compatibility checks when onlining a CPU.  Abort enabling, i.e. the
> online process, if the (hotplugged) CPU is incompatible with the known
> good setup.
> 
> At init time, KVM does compatibility checks to ensure that all online
> CPUs support hardware virtualization and a common set of features. But
> KVM uses hotplugged CPUs without such compatibility checks. On Intel
> CPUs, this leads to #GP if the hotplugged CPU doesn't support VMX, or
> VM-Entry failure if the hotplugged CPU doesn't support all features
> enabled by KVM.
> 
> Note, this is little more than a NOP on SVM, as SVM already checks for
> full SVM support during hardware enabling.
> 
> Opportunistically add a pr_err() if setup_vmcs_config() fails, and
> tweak all error messages to output which CPU failed.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/svm/svm.c          | 20 +++++++++++---------
>  arch/x86/kvm/vmx/vmx.c          | 33 +++++++++++++++++++--------------
>  arch/x86/kvm/x86.c              |  5 +++--
>  4 files changed, 34 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f223c845ed6e..c99222b71fcc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1666,7 +1666,7 @@ struct kvm_x86_nested_ops {
>  };
>  
>  struct kvm_x86_init_ops {
> -	int (*check_processor_compatibility)(void);
> +	int (*check_processor_compatibility)(int cpu);

Is this cpu argument used only for error message to include cpu number
with avoiding repeating raw_smp_processor_id() in pr_err()?
The actual check is done on the current executing cpu.

If cpu != raw_smp_processor_id(), cpu is wrong. Although the function is called
in non-preemptive context, it's a bit confusing. So voting to remove it and
to use.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
