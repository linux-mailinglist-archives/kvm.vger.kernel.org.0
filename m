Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08A378D917
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbjH3ScU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343779AbjH3QzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 12:55:05 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FBD19A
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 09:55:02 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1bc83a96067so36606195ad.0
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 09:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693414502; x=1694019302; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K0kNasBWHXDxag6PfFG1PPRe3KwHHljqTxvWTjzCMWw=;
        b=S4BI71I/Zvm3XvJX1+jBSExkYJmPOARu2UROjfbKTHdGGY26Cqkm/YXrsVSK5jvpr+
         eVq9zCmSnf4nFbq8vjlwXGjqsvWjurXqxEYzeS/XY/Ulv3PUbZ5ll4TJOH+U8iY4KRnI
         WCRR6UJAx2cV/4fA/puNGVh4YnDsHlx7loVonv0fkTfp0aKjrqLXBxW+xy91eiUjeqfr
         KSNotIjtdubXrk1OgA1MZUTrVQz1yASVJMaEB4otk3sSBlizP6lZUW6fJYxpUAQtXSQP
         kJ25zLFFq5I+rNCY+WwKEuzM6q5nmJfSBZojFRM/C33mTs5CeUUA7Nq63+SY9TvNeRBt
         Hoxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693414502; x=1694019302;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K0kNasBWHXDxag6PfFG1PPRe3KwHHljqTxvWTjzCMWw=;
        b=cMVFhM9I37kprF6H/PJCCyjEdm1K/e4MEgYkvT07ouxChnhVEqShr68j2xhOHPVBqk
         TVHl73X1HpyvtYWK9RfuaxJihoMnUaWY4A2fyLGBiDBpgC3hm7MwV+aKJx82wORiKJbf
         g0dFLh9DgXfy5cJHV+aGo+7P1i+Ld26io0zbhZmOmenv1zSoPWmxcc+P3pHoDbvYW8x3
         +RRokbnN2ZVKX9+wnuxuKRGe799ofBQFtM9yOEsIok00ljhIcvuL7KGVNUXB3fiPoYtp
         NrjyATdiBCMxDoH7CU0kfIF3KYZJ6DcPAj4+vwpGYyorc8aVIrR+rGX1Dj7knO/N4wgY
         E8Pg==
X-Gm-Message-State: AOJu0YzRl7Fef03ocekkpjTmZWxxcdu2Fc2JfWCmrWBV9kWwMGfd/PcR
        2mgPuJIdT7lPLy8peEJABB8=
X-Google-Smtp-Source: AGHT+IEY7YnkM6ikGI3bE4Jy6dgMQCVAbQv/5XNLLtG2muVIw6W6RFGP1GjEFkMCrNNM1OIieqmO9Q==
X-Received: by 2002:a17:902:e80f:b0:1c1:fbec:bc1c with SMTP id u15-20020a170902e80f00b001c1fbecbc1cmr3160197plg.42.1693414502173;
        Wed, 30 Aug 2023 09:55:02 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902d68b00b001bba1475c92sm11237866ply.113.2023.08.30.09.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 09:55:01 -0700 (PDT)
Date:   Wed, 30 Aug 2023 09:54:54 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v2 13/58] kvm: Introduce kvm_arch_pre_create_vcpu()
Message-ID: <20230830165454.GB3638268@ls.amr.corp.intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-14-xiaoyao.li@intel.com>
 <5bfefa59-6e1e-dcfd-a2a6-e49a0b71fded@linaro.org>
 <6ea095cd-db21-c95a-b518-2d97b6098281@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ea095cd-db21-c95a-b518-2d97b6098281@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 30, 2023 at 09:45:58AM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 8/29/2023 10:40 PM, Philippe Mathieu-Daudé wrote:
> > On 18/8/23 11:49, Xiaoyao Li wrote:
> > > Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
> > > work prior to create any vcpu. This is for i386 TDX because it needs
> > > call TDX_INIT_VM before creating any vcpu.
> > > 
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> > > ---
> > >   accel/kvm/kvm-all.c  | 12 ++++++++++++
> > >   include/sysemu/kvm.h |  1 +
> > >   2 files changed, 13 insertions(+)
> > > 
> > > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > > index c9f3aab5e587..5071af917ae0 100644
> > > --- a/accel/kvm/kvm-all.c
> > > +++ b/accel/kvm/kvm-all.c
> > > @@ -422,6 +422,11 @@ static int kvm_get_vcpu(KVMState *s, unsigned
> > > long vcpu_id)
> > >       return kvm_vm_ioctl(s, KVM_CREATE_VCPU, (void *)vcpu_id);
> > >   }
> > > +int __attribute__ ((weak)) kvm_arch_pre_create_vcpu(CPUState *cpu)
> > > +{
> > > +    return 0;
> > > +}
> > 
> > kvm_arch_init_vcpu() is implemented for each arch. Why not use the
> > same approach here?
> 
> Because only x86 needs it currently, for TDX. Other arches don't require an
> implementation.
> 
> If don't provide the _weak_ function, it needs to implement the empty
> function (justing return 0) in all the other arches just as the placeholder.
> If QEMU community prefers this approach, I can change to it in next version.

Alternative is to move the hook to x86 specific function, not common kvm
function. With my quick grepping, x86_cpus_init() or x86_cpu_realizefn().
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>
