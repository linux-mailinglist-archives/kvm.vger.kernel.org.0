Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB51655442D
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 10:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354210AbiFVIAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 04:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354206AbiFVIAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 04:00:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8527437A80
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 01:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655884841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p1O7sFFlmBgOcKNYL09qPTXcCanshyqj/I9EvbrMxCk=;
        b=Z6tnmzC7vKpqafSaF0xQmtmY99MwZ7FBdmxbooQXIghCzuVhbjqb0VBCCeJLOZwOgTm9v2
        c1wks5rrXosGF8SfwDlZzj744NmLwb6ltoHNd/j8VWsHsInWuqcZ4UVPVzYh1MiRG+GYB7
        Wrq2jBXqyBnhYFtEGxtZH8RpvRZboCA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-scXM64pdMXy9fiJYS295aQ-1; Wed, 22 Jun 2022 04:00:32 -0400
X-MC-Unique: scXM64pdMXy9fiJYS295aQ-1
Received: by mail-wm1-f72.google.com with SMTP id l3-20020a05600c1d0300b0039c7efa2526so7458831wms.3
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 01:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=p1O7sFFlmBgOcKNYL09qPTXcCanshyqj/I9EvbrMxCk=;
        b=K9M6cJPGOciFQAOVTD/yt6AV9mWsNAf7sl76JH23lCpmzhQsTztz4xw0MgvVAS4sN6
         V2vJFxRvNCkTkyhdkv7LMlmLnXga2C5HdoXcwb4033Ln0ugICcxBJQwi06KObkyYataJ
         OuS91LEXiMo5aeRISt76x65JqUVktcWfjkWUtLZZFii7bXOVqE6osB+cOKtqB8CIBHqe
         e1CRYcPisNhctYPZOGF1PTBmZsHW8y4B6PcI2Tx845vjEhDo4Q9wg8rXkXHPaY2AhERq
         C+072LbtWCVKGU2SlbT7pqqWBs0eo8PKklqcGyqtBMswis6G0tpmPfMgKf5kGHe5vOxJ
         16VQ==
X-Gm-Message-State: AOAM531IdIfu9rlGyo1deLSLzbaN+WAbKypZ8MIMiYtYtZ0bzfeAUJcQ
        jXzaK5T0kzcv46j1xuhu88/f+Pjm8iS2A673/epu57sMfXURDrXAwXCy0xAAqXugu65oUKMzRzY
        gtMUaH6cV+PzJ
X-Received: by 2002:a05:600c:128c:b0:39c:85a4:d334 with SMTP id t12-20020a05600c128c00b0039c85a4d334mr44541240wmd.159.1655884831677;
        Wed, 22 Jun 2022 01:00:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWZgf9RVSF+aIRirRYltfNsKueQoUWUM/G2tiYpbbYlVSqaru9w78PwKw0eRYh5iGAaI861w==
X-Received: by 2002:a05:600c:128c:b0:39c:85a4:d334 with SMTP id t12-20020a05600c128c00b0039c85a4d334mr44541196wmd.159.1655884831411;
        Wed, 22 Jun 2022 01:00:31 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h4-20020a5d6e04000000b0020d02262664sm18307926wrz.25.2022.06.22.01.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 01:00:30 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, mail@anirudhrb.com,
        kumarpraveen@linux.microsoft.com, wei.liu@kernel.org,
        robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
In-Reply-To: <YqiwoOP4HX2LniI4@google.com>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
 <YqdsjW4/zsYaJahf@google.com> <YqipLpHI24NdhgJO@anrayabh-desk>
 <YqiwoOP4HX2LniI4@google.com>
Date:   Wed, 22 Jun 2022 10:00:29 +0200
Message-ID: <87zgi5xh42.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jun 14, 2022, Anirudh Rayabharam wrote:
>> On Mon, Jun 13, 2022 at 04:57:49PM +0000, Sean Christopherson wrote:

...

>> > 
>> > Any reason not to use the already sanitized vmcs_config?  I can't think of any
>> > reason why the nested path should blindly use the raw MSR values from hardware.
>> 
>> vmcs_config has the sanitized exec controls. But how do we construct MSR
>> values using them?
>
> I was thinking we could use the sanitized controls for the allowed-1 bits, and then
> take the required-1 bits from the CPU.  And then if we wanted to avoid the redundant
> RDMSRs in a follow-up patch we could add required-1 fields to vmcs_config.
>
> Hastily constructed and compile-tested only, proceed with caution :-)

Independently from "[PATCH 00/11] KVM: VMX: Support TscScaling and
EnclsExitingBitmap whith eVMCS" which is supposed to fix the particular
TSC scaling issue, I like the idea to make nested_vmx_setup_ctls_msrs()
use both allowed-1 and required-1 bits from vmcs_config. I'll pick up
the suggested patch and try to construct something for required-1 bits.

Thanks!

-- 
Vitaly

