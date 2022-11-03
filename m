Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB5C6186AC
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 18:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiKCRxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 13:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiKCRxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 13:53:40 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E71C1CFC2
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 10:53:36 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id g129so2308885pgc.7
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 10:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3tXwq1v6tJCedr2VtV8ELYd8BpIXTKwmGjuY8weIxs8=;
        b=gjqnoLy192oz/Zxvag+BlBreQGGSfkeJOmpmCEx7rtJpm2GzAgZsoDzOerCZhLAwiY
         s4s7ScvfoZl8zwg6HI1Ymb7QpOkn2NxzwKs5NTcMl1wbeFQ/hmv3VmCXwSollG4iohk8
         ZfCLF4UOQot0TZFoB2ZSgy0wzT2PFfm47J97NCOCE8O1C25eIzJzc1jTDAryWTakKtb6
         +QR4ykcFsYtONZVST62uH0g9I4NSfzwB8k/a9JLQz8I+tNs7JhVckzNuFRTBv1+mgFsk
         IdkM799qrsruF4xx+MeYDtb4Sd8Y4cxbHh++70LJo94wIuv8aLLKYeYlUVyl7mOC3bBK
         Ww4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3tXwq1v6tJCedr2VtV8ELYd8BpIXTKwmGjuY8weIxs8=;
        b=sH2bZ+WaXNMiisos2I3EarvqwyMqi2M6knjSYfWJJVitgDLnLNRdZKOLADJdcvuWHt
         EciiloOFYUwEipXXCA2h2LtKNIJmGBGYwA4jSQPCL8miGyB3FANx4pI/lph1oVVu1Lsd
         HbErE9Q1cua4s3Moz4M5N35FxR/A2xLGO5fpC8xEpZzR04n2UX6vfMCV/2dPTopswwcR
         QzUWy2/zanuX10tJDRzb4QEtkzVvOIMck4cBl2alKWSQXXPwuoe8NO2jkC4uMztq8gBO
         1rbc5YLAp6fgEtMWyaO4L9tfdWN2QEFLb0XZREyaRTVbtXaMJs0IUf/IxshsjxtEcw7l
         8eug==
X-Gm-Message-State: ACrzQf3WkGPaPt3z96st+OcHY3rlT6Yobt75r9oUZx0WdUxXJW5Coa+8
        XkkiH53OM9dQwjj3Mfn4JBc/Vg==
X-Google-Smtp-Source: AMsMyM5pSkjZTiut6RFho0StQnuo7qAiklz26C63x768BJpOt4UV7sKT8fcspUYyR/B7P1xdFXKPhA==
X-Received: by 2002:a05:6a00:999:b0:56c:3d0d:96fe with SMTP id u25-20020a056a00099900b0056c3d0d96femr31657100pfg.12.1667498015565;
        Thu, 03 Nov 2022 10:53:35 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e20-20020a63e014000000b0045ff216a0casm1080329pgh.3.2022.11.03.10.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 10:53:35 -0700 (PDT)
Date:   Thu, 3 Nov 2022 17:53:31 +0000
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
Subject: Re: [PATCH 39/44] KVM: Drop kvm_count_lock and instead protect
 kvm_usage_count with kvm_lock
Message-ID: <Y2QAG0wCPNv7atC/@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-40-seanjc@google.com>
 <7b6ce80e-7f1f-11cd-8bde-8d8fa9fd7e1d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b6ce80e-7f1f-11cd-8bde-8d8fa9fd7e1d@redhat.com>
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

On Thu, Nov 03, 2022, Paolo Bonzini wrote:
> On 11/3/22 00:19, Sean Christopherson wrote:
> > +- kvm_lock is taken outside kvm->mmu_lock
> 
> Not surprising since one is a mutex and one is an rwlock. :)

Heh, 

  Signed-off-by: Captain Obvious <seanjc@google.com>

> You can drop this hunk as well as the "Opportunistically update KVM's locking
> documentation" sentence in the commit message.

Will do.

> >   - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
> >   - kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock and
> > @@ -216,15 +220,11 @@ time it will be set using the Dirty tracking mechanism described above.
> >   :Type:		mutex
> >   :Arch:		any
> >   :Protects:	- vm_list
> > -
> > -``kvm_count_lock``
> > -^^^^^^^^^^^^^^^^^^
> > -
> > -:Type:		raw_spinlock_t
> > -:Arch:		any
> > -:Protects:	- hardware virtualization enable/disable
> > -:Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
> > -		migration.
> > +		- kvm_usage_count
> > +		- hardware virtualization enable/disable
> > +		- module probing (x86 only)
> 
> What do you mean exactly by "module probing"?  Is it anything else than what
> is serialized by vendor_module_lock?

Ooh, I forgot to update this patch after switching to vendor_module_lock.  I
added the above after fixing the first deadlock between kvm_lock and cpu_hotplug_lock,
but later gave up on trying to use kvm_lock after deadlock #2, which is when I
when I realized piggybacking kvm_lock was going to be a maintainance nightmare due.
