Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF1C58800A
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237945AbiHBQOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237863AbiHBQNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:13:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D671C53D12
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F1BN/Juwioxn78sXhSX6LDo1G2nc1seQzhjMfYqlHN4=;
        b=KxnUhOhFbpkr4t8I7uY0schWeZIuYEG8VBj0vmyX/FBm5TOdgKiRcAXxJQ0Um9uETWglDT
        rsvMqdiXH/zy5g/C7aTIoKfz75RnyAEmgmNULcaGoKWKCK3+gjIM92Dr5T9o7jxRWdDbHJ
        nCs4X40W/OaeGx8T0VWkPIyN2/svMM8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-Xn6TerBXNXe1fGfEOhsxOg-1; Tue, 02 Aug 2022 12:11:04 -0400
X-MC-Unique: Xn6TerBXNXe1fGfEOhsxOg-1
Received: by mail-wr1-f72.google.com with SMTP id i17-20020adfaad1000000b0021ecb856a71so3626387wrc.4
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 09:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=F1BN/Juwioxn78sXhSX6LDo1G2nc1seQzhjMfYqlHN4=;
        b=jSffXQMConlwuGhUDCieMZ8802HaWCVom/TdN3XQLKgCkN6UGA02yUfznoKfCGTsxS
         j7Q2qK+/AEjf2J/ajQtGEDjF9Yx1uLwJCEeTDzzHyyn0NV+RRJn2jOwzc6cdKA9QuO1v
         CzKb2SjIPPrXIWMWDpfBNCV8KbbMIId9l4uxZ1oAZfFqrkogVZkna7hkI6pURivoSj43
         2KKJA9uWLANW5R2UMnz+W3ZBRqcwJtTBbagVnekIRDZSY3ewsNyJNaY/SaHSls5+ivQa
         dPBczNO4VKHh9fF2i0Vv8e/sBiHLUaaNR2v5AJ31/4am21tykc+ZEH1jNrtgPKa5zVtd
         fLsg==
X-Gm-Message-State: ACgBeo1o5LfjVCLfzLy4l7GpvfMMgGoJ04yoYSc1GU1y4aWlmeJoht7c
        TDSMNPnzeeE/vQR5LkYQrc9K/r4fItcRpIG5KMByZJmzAlakHI2w022XDpCdcYtlnV3fExaa3bJ
        X+Nxuk52BpNoo
X-Received: by 2002:a05:600c:502b:b0:3a3:1f5c:57f5 with SMTP id n43-20020a05600c502b00b003a31f5c57f5mr126021wmr.5.1659456663497;
        Tue, 02 Aug 2022 09:11:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4z2D1nMb0fc3xUyccQZzyhRJhby4+XRhjb1IvU3RAlBh2PniSqCm1AcHu/nTp/gdJktDH9Ng==
X-Received: by 2002:a05:600c:502b:b0:3a3:1f5c:57f5 with SMTP id n43-20020a05600c502b00b003a31f5c57f5mr125997wmr.5.1659456663291;
        Tue, 02 Aug 2022 09:11:03 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n5-20020a05600c3b8500b003a03185231bsm14130710wms.31.2022.08.02.09.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 09:11:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 24/25] KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
In-Reply-To: <Ytnb2Zc0ANQM+twN@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-25-vkuznets@redhat.com>
 <Ytnb2Zc0ANQM+twN@google.com>
Date:   Tue, 02 Aug 2022 18:11:01 +0200
Message-ID: <87fsie1v8q.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
>> @@ -2613,6 +2614,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>  	if (((vmx_msr_high >> 18) & 15) != 6)
>>  		return -EIO;
>>  
>> +	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
>
> Might make sense to sanitize fields that KVM doesn't use and that are not exposed
> to L1.  Not sure it's worthwhile though as many of the bits fall into a grey area,
> e.g. all the SMM stuff isn't technically used by KVM, but that's largely because
> much of it just isn't relevant to virtualization.
>
> I'm totally ok leaving it as-is, though maybe name it "unsanitized_misc" or so
> to make that obvious?

I couldn't convince myself to add 'unsanitized_' prefix as I don't think
it significantly reduces possible confusion (the quiestion would be
'sanitized for what and in which way?') so a need for 'git grep' seems
imminent anyway. Hope I've addressed the rest of your comments in v5
though, thanks for your review!

-- 
Vitaly

