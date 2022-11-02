Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B43F616A1D
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiKBRKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiKBRKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:10:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F7615707
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667408984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=akfUnKDkyHdw6CJdXMPMOatfFRUJHL9zU65unIR/pRQ=;
        b=Cb8Fom359NMRfeE7lkonvw3OiO3D1Yk9OvRsEVLCM5gaHWG+/9icCP9aWRF08vOZ/9V+ZC
        md9b5NiNrwQF4nfrrwCnTxxUaMo5r2IBUdFjRdnzaoVQ1PMmQxRNEN5NDA/VapHCMUCn2P
        stt6E6VRnM/tgZfigRE91XYIuC2jAVM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-616-MnQaqlNmPxywmn9jy9RFyg-1; Wed, 02 Nov 2022 13:09:38 -0400
X-MC-Unique: MnQaqlNmPxywmn9jy9RFyg-1
Received: by mail-ej1-f72.google.com with SMTP id qk31-20020a1709077f9f00b00791a3e02c80so10506974ejc.21
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=akfUnKDkyHdw6CJdXMPMOatfFRUJHL9zU65unIR/pRQ=;
        b=mNQ8IoRN5VhOC7TZDBnNc2NugfRclmH5EK0BOVajiqvVjRijfyAW0XeydjKdihnSWs
         POpmuji9SNAnlYnt6Y1KN8OzkGqJsNpsXCX0X0U7Hubl2Ocqxq/QHzlLVZbeGJe1hoO3
         7zBstHcAUT3Y5iYoRgMFR+E4efb6Ilyf9AlPWZeFlS90m7JvmaMH2wykT5KN6nj392JD
         b/+0EyeaHFAawg/4bfqIPwN0X63WNTGiyl5knEsH3+x3Hfhq/RnhYOmjZo92GB0GPXYX
         GI4SjDOyii0DU1MCN2Mnoh4Z1asaYvDw4Envr4hfp1eDH7QldPBWfwbSNsYbkOBwVjxh
         YB1g==
X-Gm-Message-State: ACrzQf1Ozt7T62vU7Prc7gl98DFmJLfnK9HtcEQCepdQxUwSUI2ROmRM
        reHP8qjRU7i9QTumt0qe56Qb7pQJdOkcqA6AynzQJH6ixtpeZjHVPZ0W/Hc6pMIvayvRIwoFtyj
        GIqG/Ml7vQcTR
X-Received: by 2002:a17:907:7637:b0:7ad:b869:2cc7 with SMTP id jy23-20020a170907763700b007adb8692cc7mr21604644ejc.159.1667408975458;
        Wed, 02 Nov 2022 10:09:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4CJLxtMqHbz1dMFAFk5cy6mkFthnGD4URcLfuOlCKz7waWk6cxJDJ+bDTplU/SPtJT3rD+og==
X-Received: by 2002:a17:907:7637:b0:7ad:b869:2cc7 with SMTP id jy23-20020a170907763700b007adb8692cc7mr21604628ejc.159.1667408975209;
        Wed, 02 Nov 2022 10:09:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id ku11-20020a170907788b00b0078ba492db81sm5631647ejc.9.2022.11.02.10.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 10:09:34 -0700 (PDT)
Message-ID: <19d25f07-a9b8-cc88-cc0a-290e95c71bd7@redhat.com>
Date:   Wed, 2 Nov 2022 18:09:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 0/5] MSR filtering and MSR exiting flag clean up
Content-Language: en-US
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20220921151525.904162-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220921151525.904162-1-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/22 17:15, Aaron Lewis wrote:
> The changes in this series were intended to be accepted at the same time as
> commit cf5029d5dd7c ("KVM: x86: Protect the unused bits in MSR exiting
> flags").  With that already accepted this series is the rest of the changes
> that evolved from the code review.  The RFC tag has been removed because
> that part of the change has already been accepted.  All that's left is the
> clean up and the selftest.
> 
> v3 -> v4
>   - Patches 2 and 3 are new.  They were intended to be a part of commit
>     cf5029d5dd7c ("KVM: x86: Protect the unused bits in MSR exiting flags"),
>     but with that accepted it made sense to split what remained into two.
> 
> v2 -> v3
>   - Added patch 1/4 to prevent the kernel from using the flag
>     KVM_MSR_FILTER_DEFAULT_ALLOW.
>   - Cleaned up the selftest code based on feedback.
> 
> v1 -> v2
>   - Added valid masks KVM_MSR_FILTER_VALID_MASK and
>     KVM_MSR_EXIT_REASON_VALID_MASK.
>   - Added patch 2/3 to add valid mask KVM_MSR_FILTER_RANGE_VALID_MASK, and
>     use it.
>   - Added testing to demonstrate flag protection when calling the ioctl for
>     KVM_X86_SET_MSR_FILTER or KVM_CAP_X86_USER_SPACE_MSR.
> 
> Aaron Lewis (5):
>    KVM: x86: Disallow the use of KVM_MSR_FILTER_DEFAULT_ALLOW in the kernel
>    KVM: x86: Add a VALID_MASK for the MSR exit reason flags
>    KVM: x86: Add a VALID_MASK for the flag in kvm_msr_filter
>    KVM: x86: Add a VALID_MASK for the flags in kvm_msr_filter_range
>    selftests: kvm/x86: Test the flags in MSR filtering and MSR exiting
> 
>   arch/x86/include/uapi/asm/kvm.h               |  5 ++
>   arch/x86/kvm/x86.c                            |  8 +-
>   include/uapi/linux/kvm.h                      |  3 +
>   .../kvm/x86_64/userspace_msr_exit_test.c      | 85 +++++++++++++++++++
>   4 files changed, 96 insertions(+), 5 deletions(-)

Queued, thanks.

Paolo

