Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D868D55FB5F
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 11:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiF2JGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 05:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiF2JGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 05:06:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BB2826126
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 02:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656493610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HvWzvzdAUmdish1ZjSGH2vHCDmFvOStbYvaW/KwyrXg=;
        b=i9xJvqZ0dB8X4DW+xmyB6djIMiyLqJdQ8egMleHFIOMVYL41kvP517I+PaXJ9pohIhac7/
        t5TA8uNgxwqqn89EB2+psmEy4yFTKAVrkGGs15rhUFbH90iivjoOHBQpOEOOofF5MQ+I0R
        ZLkhY41FkiKIb8PbPfhaTzU+XcgNMOA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-bQeKuNh_PLiiIf4wtF68Ag-1; Wed, 29 Jun 2022 05:06:48 -0400
X-MC-Unique: bQeKuNh_PLiiIf4wtF68Ag-1
Received: by mail-wr1-f71.google.com with SMTP id n7-20020adfc607000000b0021a37d8f93aso2240175wrg.21
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 02:06:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HvWzvzdAUmdish1ZjSGH2vHCDmFvOStbYvaW/KwyrXg=;
        b=gaY2WHujYEP6UQsWkNGZfey+amkeumdtV6kARNZTS3VIHwt37AN7K1IYnhiNvcd3Aw
         7y1WyFHUEIhWmK/B1/w20zlhAwOGOhYz5zdBO148aTktxo0sHYJdDK2O6twIbVkaSyI/
         RA2IR/EwmL+ocg70orH96qGCacKRhRcpA6l2ymx8wLHAqjeII85nVhIBC4oMhjMc8Bgc
         qgQ9bwa7hpPgHQPp7WWhdd/o7cH6OvDRIesXtZDwktxvVjbimS+45E63Dyv9G1uad5NN
         hXD764iCAgEB1AfFm8X6vx+f0feGlGhGsUXmwUYXQUyseuXsTzzQViH41asieKfFhry7
         3GUg==
X-Gm-Message-State: AJIora90dgLiFbMMaSjv2LyI9EADEh+nz3O65zwLTCpZuyPF7CLjncyA
        4e8x73pG2F4fcONDdYUExR0IHErBtildYi9n57kymsY25xvviLN/fVbKjc2PX2WjDkjAzyYwNZY
        VHNJ27dCG8pxu
X-Received: by 2002:a5d:53ca:0:b0:21b:940f:8e29 with SMTP id a10-20020a5d53ca000000b0021b940f8e29mr2024199wrw.490.1656493607759;
        Wed, 29 Jun 2022 02:06:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1slfgJ4CmLtTDf48t9U1mX1pHXjxoYEcJdwqwzZ9MajWVRs6KVcjT0ny0vB8KhBz1k0tami8A==
X-Received: by 2002:a5d:53ca:0:b0:21b:940f:8e29 with SMTP id a10-20020a5d53ca000000b0021b940f8e29mr2024164wrw.490.1656493607451;
        Wed, 29 Jun 2022 02:06:47 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i206-20020a1c3bd7000000b003a03ae64f57sm2609957wma.8.2022.06.29.02.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 02:06:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] KVM: nVMX: Use vmcs_config for setting up nested
 VMX MSRs
In-Reply-To: <CALMp9eQ35g8GpwObYBJRxjuxZAC8P_HNMMaC0v0uZeC+pMeW_Q@mail.gmail.com>
References: <20220627160440.31857-1-vkuznets@redhat.com>
 <CALMp9eQL2a+mStk-cLwVX6NVqwAso2UYxAO7UD=Xi2TSGwUM2A@mail.gmail.com>
 <87y1xgubot.fsf@redhat.com>
 <CALMp9eSBLcvuNDquvSfUnaF3S3f4ZkzqDRSsz-v93ZeX=xnssg@mail.gmail.com>
 <87letgu68x.fsf@redhat.com>
 <CALMp9eQ35g8GpwObYBJRxjuxZAC8P_HNMMaC0v0uZeC+pMeW_Q@mail.gmail.com>
Date:   Wed, 29 Jun 2022 11:06:46 +0200
Message-ID: <87czeru9cp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Tue, Jun 28, 2022 at 9:01 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>

...

>
> Read-only MSRs cannot be changed after their values may have been
> observed by the guest.
>
>> Anirudh, the same concern applies to your 'intermediate' patch too.
>>
>> Smart ideas on what can be done are more than welcome)
>
> You could define a bunch of "quirks," and userspace could use
> KVM_CAP_DISABLE_QUIRKS2 to ask that the broken bits be cleared.

This sounds correct, but awful :-) I, however, think we can avoid this.

For the KVM-on-eVMCS case:
- When combined with "[PATCH 00/11] KVM: VMX: Support TscScaling and
EnclsExitingBitmap whith eVMCS" series
(https://lore.kernel.org/kvm/20220621155830.60115-1-vkuznets@redhat.com/),
the filtering we do in setup_vmcs_config() is no longer needed. I need
to check various available Hyper-V versions but my initial investigation
shows that we were only filtering out TSC Scaling and 'Load
IA32_PERF_GLOBAL_CTRL' vmexit/vmentry, the rest were never present in
VMX control MSRs (as presented by Hyper-V) in the first place.

For PERF_GLOBAL_CTRL errata:
- We can move the filtering to vmx_vmexit_ctrl()/vmx_vmentry_ctrl()
preserving the status quo: KVM doesn't use the feature but it is exposed
to L1 hypervisor (and L1 hypervisor presumably has the same check and
doesn't use the feature. FWIW, the workaround was added in 2011 and the
erratas it references appeared in 2010, this means that the affected
CPUs are quite old, modern proprietary hypervisors won't likely boot
there).

If we do the above, there's going to be no changes to VMX control MSRs
generated by nested_vmx_setup_ctls_msrs(). I, however, need to work on
a combined series.

-- 
Vitaly

