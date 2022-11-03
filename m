Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACAD618B9A
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 23:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiKCWeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 18:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiKCWeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 18:34:15 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E730820187
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 15:34:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id z5-20020a17090a8b8500b00210a3a2364fso6578922pjn.0
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 15:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ldFAJy69ux+7z8nNCEANq8kYxugZwXEN2GoxlipQK+E=;
        b=mkCIQ7bnuqf5rnZcP6hp5JREtMJ78/S1f1OWtkJaTeRse5OVZRNDMID1AYpz+jBJzg
         eTpW9c3Fpt1GJSjywJBWRecDimPLsqOLfN7Nt46XLz4VoW6wiMtnGP3QRSBmWb2Jy2Ue
         XIrU3j6Zv6WjRE+wBsl7MInjLBoh0ETGKk290BPhyym2xqAHPTTSp2piVfBSnA5Xqpa6
         3LkVfTkbpSA7y+3xQukW44oEvhoV3ll0HshYQg8WmMixLpenp+usLAkNlELtK9JmVVTO
         f4CyPp1jxX+2aW0ZdvzjRbMLb0KbcueA1rrAX1kSu3aGK0UrE4ad6SuEvUCcApyckgBR
         ztmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ldFAJy69ux+7z8nNCEANq8kYxugZwXEN2GoxlipQK+E=;
        b=cJseX2QK4vtKkKTQD2tc47SFnJT2hcOeZ6FRpu4N55nW1mgc61yN8IxxpTsVLxL+YP
         Wov3AJZ9ofTb2atPZGwOF8GCrBLCr58THLdx8WO4gIxnUQUGO60uOgJP1QzeJ3SKZwga
         qrdc1aBhgxtV4Gj+7tBQbiukfypYy536l9mIvOlbzBLFD+uMcCPYrjtatrEztO+HcgG8
         R6rKSbPIgQrC+bZ/YxPE9itgJhZiX9YrmeHHNWqToMR7oo6ARTYoiUqcYOtPD6mmL8wH
         /wND5+UzEVSH87wiRN9AWA79MJMlVsDhY8OmNcY+cOvpJ1UmOZ6GnWoatP9uZXUZ/l3m
         4dFQ==
X-Gm-Message-State: ACrzQf1gvCVlBNNlVCnqP5xp8Um2HdTkRzM8UsQ/Nfu4ZM9dfVWALnwN
        6yVafMpspVRSepqBdY3HvhsZwQ==
X-Google-Smtp-Source: AMsMyM4x/1h/4H3vdmKr9CnvGb6Osipgsi8YDrhqpMcYmjYNzerzqYc2UHi5AhKhfTxXN1DVaborYg==
X-Received: by 2002:a17:90a:6045:b0:212:fe9a:5792 with SMTP id h5-20020a17090a604500b00212fe9a5792mr49415367pjm.178.1667514854306;
        Thu, 03 Nov 2022 15:34:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u10-20020a170902e80a00b00186ad73e2d5sm1151929plg.208.2022.11.03.15.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 15:34:13 -0700 (PDT)
Date:   Thu, 3 Nov 2022 22:34:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
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
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 36/44] KVM: x86: Do compatibility checks when onlining CPU
Message-ID: <Y2RB4qT02EkhMjPL@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-37-seanjc@google.com>
 <20221103210402.GB1063309@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103210402.GB1063309@ls.amr.corp.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03, 2022, Isaku Yamahata wrote:
> On Wed, Nov 02, 2022 at 11:19:03PM +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f223c845ed6e..c99222b71fcc 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1666,7 +1666,7 @@ struct kvm_x86_nested_ops {
> >  };
> >  
> >  struct kvm_x86_init_ops {
> > -	int (*check_processor_compatibility)(void);
> > +	int (*check_processor_compatibility)(int cpu);
> 
> Is this cpu argument used only for error message to include cpu number
> with avoiding repeating raw_smp_processor_id() in pr_err()?

Yep.

> The actual check is done on the current executing cpu.
> 
> If cpu != raw_smp_processor_id(), cpu is wrong. Although the function is called
> in non-preemptive context, it's a bit confusing. So voting to remove it and
> to use.

What if I rename the param is this_cpu?  I 100% agree the argument is confusing
as-is, but forcing all the helpers to manually grab the cpu is quite annoying.
