Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D648C640A23
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 17:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbiLBQE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 11:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbiLBQEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 11:04:34 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6411D3
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 08:04:14 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id 4so5054972pli.0
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 08:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b2GsRYGpugbtZSHFD2RurCZ4JW4xZuzTsOfxXrCkfT8=;
        b=NpcRjd8PL93RDmu18EFPPR+cTZLP3kvCDAEAva9wUQzgEtv6dhPvDs1R9Q9+h2mN7N
         H42dGaT+sl8xeMuYK2rfUD+midQutKuG+T3MUl21HeEIW4MolVpdsUIo9SmBbkggNx39
         8eN3yXePSJelVozj19wEaq9z6VDhzvEr0ForIWyEXE5qa5rozQa3WxAYewh7SubIBKmO
         02PPePyseXuLiMMtCMvFiCLdBEv6hZUEsP/WY2KPh2svytXFAqt8tvoUSmd0DdfZmIR5
         sLez1JP4ikgagdRRPh2k9RbfsucGTq+KVdolkDHLvc/Uk58Zr0iw+nxpff3e47GDmBB4
         X4Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b2GsRYGpugbtZSHFD2RurCZ4JW4xZuzTsOfxXrCkfT8=;
        b=yxWZrpE6p5PeRSFNzAnngcBlGCzxAwgCNQ5ghrqch8YMK98ywKs3YeHDcdTy2aoEye
         pjotsSvQyKR36jafZYTmYlgw4IXGzcToNOcOVn+Jtjto/x0fk5ZNxVaNQgq9T43LOLFO
         oEdpgdxFN8NNycFWU2nI8z4l17xgHXkShHtiEl4xKmJETWgveozFxvawES/0hpNou7sm
         Nh8nlkOQeMnqrjaP3Trvz+xbQRUtkIT2BkCDaWntudxgbdmrvwaJWvlokRI35ZmfuymZ
         Ib4mG0011XzrtGWLkbUYWxWUsXiytNOk8vrUq4CP4BPPQ4U6F7cTX4uipJdNKZ84xEul
         /dAQ==
X-Gm-Message-State: ANoB5pkU1TdJcaUeryeN9HWKsWjw99Q0q+1ibMEuXNRPFSdwiAX4Aiv9
        6J3lOHnQyaYRZL6zNfKHfbQgSWJZKdZJEPxK
X-Google-Smtp-Source: AA0mqf7w0TN/IsoZof5JEkNGBQ8Yd2Zjjhh4wCVFAlaPO07IGqPcQWl6OiCMwNp3DG6Q8B9rQJAiYA==
X-Received: by 2002:a17:90a:9a98:b0:219:2f90:4fb3 with SMTP id e24-20020a17090a9a9800b002192f904fb3mr28837193pjp.109.1669997053879;
        Fri, 02 Dec 2022 08:04:13 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q42-20020a17090a1b2d00b00219752c8ea5sm3349337pjq.37.2022.12.02.08.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 08:04:13 -0800 (PST)
Date:   Fri, 2 Dec 2022 16:04:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "paul@xen.org" <paul@xen.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farosas@linux.ibm.com" <farosas@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "atishp@atishpatra.org" <atishp@atishpatra.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v2 40/50] KVM: x86: Do compatibility checks when onlining
 CPU
Message-ID: <Y4oh+XsbifA2BSj9@google.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-41-seanjc@google.com>
 <cf755389c21c73e8367d8162cabc83629d3f9a74.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf755389c21c73e8367d8162cabc83629d3f9a74.camel@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 02, 2022, Huang, Kai wrote:
> On Wed, 2022-11-30 at 23:09 +0000, Sean Christopherson wrote:
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11967,6 +11967,11 @@ int kvm_arch_hardware_enable(void)
> >  	bool stable, backwards_tsc = false;
> >  
> >  	kvm_user_return_msr_cpu_online();
> > +
> > +	ret = kvm_x86_check_processor_compatibility();
> > +	if (ret)
> > +		return ret;
> > +
> >  	ret = static_call(kvm_x86_hardware_enable)();
> >  	if (ret != 0)
> >  		return ret;
> 
> Thinking more, AFAICT, kvm_x86_vendor_init() so far still does the compatibility
> check on all online cpus.  Since now kvm_arch_hardware_enable() also does the
> compatibility check, IIUC the compatibility check will be done twice -- one in
> kvm_x86_vendor_init() and one in hardware_enable_all() when creating the first
> VM.
> 
> Do you think it's still worth to do compatibility check in vm_x86_vendor_init()?
> 
> The behaviour difference should be "KVM module fail to load" vs "failing to
> create the first VM" IIUC.  I don't know whether the former is better than the
> better, but it seems duplicated compatibility checking isn't needed?

It's not strictly needed, but I think it's worth keeping.  The duplicate checking
annoys me too, and I considered removing it multiple times when creating this
series.  But, if there is a hardware incompatibility for whatever reason, failing
to load and thus not instantiating /dev/kvm is friendlier to userspace, e.g.
userspace can immediately flag the platform as potentially flaky, whereas
detecting the likely hardware issue when VM creation fails would essentialy require
scraping the kernel logs.
