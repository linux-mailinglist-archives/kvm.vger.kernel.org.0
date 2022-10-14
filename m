Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EDC5FE86E
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 07:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJNFeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 01:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiJNFe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 01:34:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F054E196B5C
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 22:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665725668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V8trlJsHTyBYFl3iSoKLkKxiftpMCd5kSe7wrtw8WL4=;
        b=AeDaDqd7mjMHhHjB1TeTpgQVbrlj9sNVaX0kQEhntjZJ8r8pTHDz9h29lz2Hwpblrrc7zK
        LZ+VOf8oXlgMMkbp+G8cGQ1PKl/1rh+yBhEWCV2qLzjDoEqBWa4xV9xp9BOfDBfcZlH87J
        1b1bCQb+kE/JyOTZcP5Q0s3NUmpyZlU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-211-yESvCzNDOL24xPjuN-g9mA-1; Fri, 14 Oct 2022 01:34:26 -0400
X-MC-Unique: yESvCzNDOL24xPjuN-g9mA-1
Received: by mail-wm1-f72.google.com with SMTP id t20-20020a7bc3d4000000b003c6bfea856aso1649431wmj.1
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 22:34:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V8trlJsHTyBYFl3iSoKLkKxiftpMCd5kSe7wrtw8WL4=;
        b=QIzkj29D4KrLl4/XnIWdHkQcmkeuh02k5saw1bsWBq+cgPo4MXfGpjL1C1+pgGzP+L
         WS6SMW/X1Ze6pbh9hZiFJdVsghcWbcmgL6o0G+/M4ABcot6E5vbnSEp/wdmP7hoClSi5
         GHbR9a3SRcfsEwvtp9u9S/hnI7zefYPGvS8yTJ50SfQt0BSzfZkc4u4BiO2/AIHQCPPq
         c35G463i2SKViCeztC7cDgqc77O3Q+7ZjWqslJyNxMd9//c4Cl3Ada5Bz3FetY+u7SbS
         W4D8etUOx5Bi+GV58S8X06dSn0OYEZS5Ph/WF2AjkLawyZ3tZC87nwdP9hu2RVwNsKer
         AlMw==
X-Gm-Message-State: ACrzQf1zo6kZwmu0Rlx/9j6+idQ/cKvZSvym4N4DtRj+NCQ7Errq5BVd
        SC2+QcBRoiKo1GYg4oCuYTOUze5dQhq9OJVkUV4utrBqVdUzBH8pV1/GrQP3WlDzO9Zw0dMzX63
        nZYg/9m8MkDh/
X-Received: by 2002:a05:600c:4611:b0:3c5:e3a3:942a with SMTP id m17-20020a05600c461100b003c5e3a3942amr9049116wmo.82.1665725665671;
        Thu, 13 Oct 2022 22:34:25 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6bB8zKYPiC5hvp1CsHP3BssllLnc3EpU8ceRce26Epnl3AziK2mHwtoH4iEZ7wcoRzL51/lQ==
X-Received: by 2002:a05:600c:4611:b0:3c5:e3a3:942a with SMTP id m17-20020a05600c461100b003c5e3a3942amr9049103wmo.82.1665725665395;
        Thu, 13 Oct 2022 22:34:25 -0700 (PDT)
Received: from redhat.com ([2.54.162.123])
        by smtp.gmail.com with ESMTPSA id bl13-20020adfe24d000000b00228de351fc0sm1076394wrb.38.2022.10.13.22.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 22:34:24 -0700 (PDT)
Date:   Fri, 14 Oct 2022 01:34:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v3] target/i386: Set maximum APIC ID to KVM prior to vCPU
 creation
Message-ID: <20221014013323-mutt-send-email-mst@kernel.org>
References: <20220825025246.26618-1-guang.zeng@intel.com>
 <2c9d8124-c8f5-5f21-74c5-307e16544143@intel.com>
 <cea2094f-72e7-a63d-ddca-86160240db7b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cea2094f-72e7-a63d-ddca-86160240db7b@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 09:01:02AM +0800, Zeng Guang wrote:
> PING again !
> This QEMU patch is to optimize max APIC ID set for current VM session
> introduced since linux v6.0. It's also compatible with previous linux
> version.
> 
> Thanks.
> 
> On 9/5/2022 9:27 AM, Zeng Guang wrote:
> > Kindly PING!
> > 
> > On 8/25/2022 10:52 AM, Zeng Guang wrote:
> > > Specify maximum possible APIC ID assigned for current VM session to KVM
> > > prior to the creation of vCPUs. By this setting, KVM can set up VM-scoped
> > > data structure indexed by the APIC ID, e.g. Posted-Interrupt Descriptor
> > > pointer table to support Intel IPI virtualization, with the most optimal
> > > memory footprint.
> > > 
> > > It can be achieved by calling KVM_ENABLE_CAP for KVM_CAP_MAX_VCPU_ID
> > > capability once KVM has enabled it. Ignoring the return error if KVM
> > > doesn't support this capability yet.
> > > 
> > > Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> > > ---
> > >    hw/i386/x86.c              | 4 ++++
> > >    target/i386/kvm/kvm-stub.c | 5 +++++
> > >    target/i386/kvm/kvm.c      | 5 +++++
> > >    target/i386/kvm/kvm_i386.h | 1 +
> > >    4 files changed, 15 insertions(+)
> > > 
> > > diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> > > index 050eedc0c8..4831193c86 100644
> > > --- a/hw/i386/x86.c
> > > +++ b/hw/i386/x86.c
> > > @@ -139,6 +139,10 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
> > >            exit(EXIT_FAILURE);
> > >        }
> > > +    if (kvm_enabled()) {
> > > +        kvm_set_max_apic_id(x86ms->apic_id_limit);
> > > +    }
> > > +
> > >        possible_cpus = mc->possible_cpu_arch_ids(ms);
> > >        for (i = 0; i < ms->smp.cpus; i++) {
> > >            x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
> > > diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
> > > index f6e7e4466e..e052f1c7b0 100644
> > > --- a/target/i386/kvm/kvm-stub.c
> > > +++ b/target/i386/kvm/kvm-stub.c
> > > @@ -44,3 +44,8 @@ bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
> > >    {
> > >        abort();
> > >    }
> > > +
> > > +void kvm_set_max_apic_id(uint32_t max_apic_id)
> > > +{
> > > +    return;
> > > +}
> > > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > > index f148a6d52f..af4ef1e8f0 100644
> > > --- a/target/i386/kvm/kvm.c
> > > +++ b/target/i386/kvm/kvm.c
> > > @@ -5428,3 +5428,8 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
> > >            mask &= ~BIT_ULL(bit);
> > >        }
> > >    }
> > > +
> > > +void kvm_set_max_apic_id(uint32_t max_apic_id)
> > > +{
> > > +    kvm_vm_enable_cap(kvm_state, KVM_CAP_MAX_VCPU_ID, 0, max_apic_id);
> > > +}
> > > diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> > > index 4124912c20..c133b32a58 100644
> > > --- a/target/i386/kvm/kvm_i386.h
> > > +++ b/target/i386/kvm/kvm_i386.h
> > > @@ -54,4 +54,5 @@ uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
> > >    bool kvm_enable_sgx_provisioning(KVMState *s);
> > >    void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask);
> > > +void kvm_set_max_apic_id(uint32_t max_apic_id);
> > >    #endif


Looks ok on the surface, but this is Paolo's area.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

-- 
MST

