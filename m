Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E295598834
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 18:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344365AbiHRP7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 11:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245730AbiHRP72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 11:59:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559695851D
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 08:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660838366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s6slTsTy/Pyr3LUrFg5ZWWvb0V6yCPma3CmmqBIOSdY=;
        b=UdJsMMTAldvfaFvCpb85Gwl8SuROWrZFGfHqiNl5xT1QU0H1pWcbrcNdr1UUq4OKm16tVg
        zpOt8GrjdIjZoYrsgXp0FCWdUcziga8pIJqVgk9+t2bXRDgdJ4H+XqGLjVFwUKPfjRkxRR
        lZG1ntQTzAfLZbO8jZg/2FDhbSSh8Do=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-145-cpcreHLuNRi1PMfeAImZyQ-1; Thu, 18 Aug 2022 11:59:25 -0400
X-MC-Unique: cpcreHLuNRi1PMfeAImZyQ-1
Received: by mail-ed1-f69.google.com with SMTP id q32-20020a05640224a000b004462f105fa9so91627eda.4
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 08:59:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=s6slTsTy/Pyr3LUrFg5ZWWvb0V6yCPma3CmmqBIOSdY=;
        b=v3cqVzaadHpL+V4IK/doSzHMQtSFauBIa7+GskjJZzY8hjX1c6lqP1CcXHA0nHk/f0
         +Fx/okm/4HsgiC2f0S5gsRYMDRkEiW3begXu7k9NwCEeZEBk6fwDG5iEPc8HcJ+7Eze4
         PFj4dIwdhTCJbo+fyfbkUOGs5wggH05PnxQm84XYjnLt/DW5g/2BqLesaxz5T/jJk6yD
         6sJHO8sdK7EiNJ7tlr5QrvicNsFpqUc9jh4YjmpKktEjWNIDokomu9ZMU7ldlxJvph80
         +acUAYpvrDV3BFfzBpbA13TWj1zXn1ljFXBxOxkBb5rsXF68jW7IpYTJecrmrc1PsF/y
         PZNQ==
X-Gm-Message-State: ACgBeo2FPZ6V/eQd5eQ0NfyPjQKg7b7NWHybCaEeAHOxxWQx4AnLFYKt
        UV0QADzOQFRRWp/ZZaexrWEhehJOzrXbYJgQLkH/IV4qAhL6QD4bp/ch5rCNHHdvbhBtdWXtG/1
        5iPhl9lb/gj6P
X-Received: by 2002:a17:907:16ab:b0:731:55c0:e7a1 with SMTP id hc43-20020a17090716ab00b0073155c0e7a1mr2262763ejc.154.1660838364160;
        Thu, 18 Aug 2022 08:59:24 -0700 (PDT)
X-Google-Smtp-Source: AA6agR43/Fekyuhe13hqCkeDMRAWKoBKaprssqUdg/IBU7sIkeVPGzkM+98pWaDy6eX29y9yAdIC3Q==
X-Received: by 2002:a17:907:16ab:b0:731:55c0:e7a1 with SMTP id hc43-20020a17090716ab00b0073155c0e7a1mr2262742ejc.154.1660838363940;
        Thu, 18 Aug 2022 08:59:23 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v2-20020a170906292200b0071cef6c53aesm1000562ejd.0.2022.08.18.08.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 08:59:23 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/26] KVM: x86: hyper-v: Expose access to debug MSRs
 in the partition privilege flags
In-Reply-To: <Yv5fcKOEVAlAh0px@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-2-vkuznets@redhat.com>
 <Yv5XPnSRwKduznWI@google.com> <878rnltw7b.fsf@redhat.com>
 <Yv5fcKOEVAlAh0px@google.com>
Date:   Thu, 18 Aug 2022 17:59:22 +0200
Message-ID: <8735dttued.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Aug 18, 2022, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
>> >> For some features, Hyper-V spec defines two separate CPUID bits: one
>> >> listing whether the feature is supported or not and another one showing
>> >> whether guest partition was granted access to the feature ("partition
>> >> privilege mask"). 'Debug MSRs available' is one of such features. Add
>> >> the missing 'access' bit.
>> >> 
>> >> Note: hv_check_msr_access() deliberately keeps checking
>> >> HV_FEATURE_DEBUG_MSRS_AVAILABLE bit instead of the new HV_ACCESS_DEBUG_MSRS
>> >> to not break existing VMMs (QEMU) which only expose one bit. Normally, VMMs
>> >> should set either both these bits or none.
>> >
>> > This is not the right approach long term.  If KVM absolutely cannot unconditionally
>> > switch to checking HV_ACCESS_DEBUG_MSRS because it would break QEMU users, then we
>> > should add a quirk, but sweeping the whole thing under the rug is wrong.
>> >
>> 
>> First, this patch is kind of unrelated to the series so in case it's the
>> only thing which blocks it from being merged -- let's just pull it out
>> and discuss separately.
>
> Regarding the series, are there any true dependencies between the eVMCS patches
> (1 - 11) and the VMCS sanitization rework (12 - 26)?  I.e. can the VMCS rework
> be queued ahead of the eVMCS v1 support?

My memory is a bit blurry already but I think PATCH11 ("KVM: VMX: Get
rid of eVMCS specific VMX controls sanitization") needs to go before
PATCH24 ("KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs")
to have "bug compatibility" and resolve Jim's concern: guest visible
VMX feature MSR values are not supposed to change. Currently, we filter
out unsupported features from eVMCS for KVM itself but not for L1 as we
expose raw host MSR values there. This is likely broken if L1 decides to
*use* these features for real but that's another story.

-- 
Vitaly

