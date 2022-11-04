Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B098619BE3
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 16:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbiKDPkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 11:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbiKDPkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 11:40:41 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845D831DFA
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 08:40:40 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 130so4834387pfu.8
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 08:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aFlTeUJ4nQplolWHip6FrS/j8TYR0+QbDmRZAFvu7G8=;
        b=slnKaxTVWka5uyvV8ksftk1iXtqkYG7wonGPtAtNy/P6RP4ZnWhdbZSV/6seXnMCof
         dnF6JUiRfV2oVCETco2jEIOQzRouLfUDiH7vxFD2orQpNLxCcfMVtLr6ntSOZeUo+8A4
         1WMtzeSAIQ00ZBggEzItHUadG+pi52a6RW5LTbSCWNWQHjLySk/BPh9TembQq8ly6ISW
         XBS14fXfAOCGbRuWccsHUKA4no5JdNrqlAYc2mDDTkISHx1kXdJjDDClXTXp09r2HKHF
         4YYshPvOotdfKVbVnw4u/+IsxQ4NAMvmIrkrc7+c9m8NGZEp/7DC/KTLI5ge39pksAS0
         M2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFlTeUJ4nQplolWHip6FrS/j8TYR0+QbDmRZAFvu7G8=;
        b=dMnXGgR5OVdNTvGD6opejJmcq35nc3m1PE4FB6GaU5oLASvkT0aIAwQSQtnSYc/zqO
         2TTUZw8wDUKkCxrsy3Dgi5KL3ge+76SuESJ+Cbu6fcakSqjTKDw7eSxW7r0lgzxEWhKR
         2Ult4bnNXh/O2PrA3eJ61PpHY/5RAc41SPMnLQseC1reiKBRdY1EsfACeK8ebd3BrtS1
         HB3up2cyRzvPeFPnKlrTI9p4JBFpulAkXohq8u67kCDqxccW5m5GCa4W0j1bgyYfEU2Y
         eVdJ5G5f5KhezWeIUjx2ZxZOztM49DelkcN0/5ROeldHf0jxaUpTedStIWq+4PjAeWlk
         HL0A==
X-Gm-Message-State: ACrzQf2VK9s2PWXfU8zjl8TP77/iu32LyfRYHPulpNt43cVOgL+/2H+f
        QEfsx0bXO0xDuvGeE7LAk6XAOw==
X-Google-Smtp-Source: AMsMyM5MdI5VKNUr37j2LDfWFXfSalVZ70lqDfROHdw5vEhrWbzDEJP2xBkjkN31VBShKB5D+mx4vA==
X-Received: by 2002:a62:1a8d:0:b0:544:1309:19f3 with SMTP id a135-20020a621a8d000000b00544130919f3mr36549720pfa.37.1667576439875;
        Fri, 04 Nov 2022 08:40:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y133-20020a62ce8b000000b00565cbad9616sm2905778pfg.6.2022.11.04.08.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 08:40:39 -0700 (PDT)
Date:   Fri, 4 Nov 2022 15:40:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
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
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 33/44] KVM: x86: Do VMX/SVM support checks directly in
 vendor code
Message-ID: <Y2UydNBFR3e2DAe7@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-34-seanjc@google.com>
 <bfa98587-3b36-3834-a4b9-585a0e0aa56a@redhat.com>
 <Y2QJ2TuyZImbFFvi@google.com>
 <c29e7d40-ddb9-def0-f944-a921a05a4bb2@redhat.com>
 <Y2QPSK1/6esl61wQ@google.com>
 <6c71fcca-c17f-5979-e15e-afcf08899064@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c71fcca-c17f-5979-e15e-afcf08899064@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 04, 2022, Paolo Bonzini wrote:
> On 11/3/22 19:58, Sean Christopherson wrote:
> > 
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index 3e508f239098..ebe617ab0b37 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -191,6 +191,8 @@ static void default_init(struct cpuinfo_x86 *c)
> >                          strcpy(c->x86_model_id, "386");
> >          }
> >   #endif
> > +
> > +       clear_cpu_cap(c, X86_FEATURE_MSR_IA32_FEAT_CTL);
> >   }
> >   static const struct cpu_dev default_cpu = {
> 
> Not needed I think?  default_init does not call init_ia32_feat_ctl.

cpuid_deps is only processed by do_clear_cpu_cap(), so unless there's an explicit
"clear" action, the dependencies will not be updated.  It kinda makes sense since
hardware-based features shouldn't end up with scenarios where a dependent feature
exists but the base feature does not (barring bad KVM setups :-) ).

That said, this seems like a bug waiting to happen, and unless I'm missing something
it's quite straightforward to process all dependencies during setup.  Time to find
out if Boris and co. agree :-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 1a85e1fb0922..c4408d03b180 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -147,6 +147,7 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 
 extern void setup_clear_cpu_cap(unsigned int bit);
 extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
+extern void apply_cpuid_deps(struct cpuinfo_x86 *c);
 
 #define setup_force_cpu_cap(bit) do { \
        set_cpu_cap(&boot_cpu_data, bit);       \
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3e508f239098..28ce31dadd7f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1884,6 +1884,8 @@ static void identify_cpu(struct cpuinfo_x86 *c)
                        c->x86_capability[i] |= boot_cpu_data.x86_capability[i];
        }
 
+       apply_cpuid_deps(c);
+
        ppin_init(c);
 
        /* Init Machine Check Exception if available. */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index c881bcafba7d..7e91e97973ca 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -138,3 +138,13 @@ void setup_clear_cpu_cap(unsigned int feature)
 {
        do_clear_cpu_cap(NULL, feature);
 }
+
+void apply_cpuid_deps(struct cpuinfo_x86 *c)
+{
+       const struct cpuid_dep *d;
+
+       for (d = cpuid_deps; d->feature; d++) {
+               if (!cpu_has(c, d->feature))
+                       clear_cpu_cap(c, d->feature);
+       }
+}

