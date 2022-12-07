Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C4E64505D
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 01:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiLGAdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 19:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiLGAdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 19:33:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60094A479
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 16:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670373158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bx3BXv2xaG+1EbHubRbeDcJNx5uekjE2mo+oSlv4S6s=;
        b=DQf6dzsD1agHUbtZuAiFwcLzOAFkDZ03nInWtn3qE6c6pG97bha+L0w++27gA9LFuk72Bz
        WYjVaKgQYf7KidNqdZQnkjRZtCsNeDQkM4jCmVt86lCq9+rgMlriWe4ETkD38qm7role87
        4jP0ThuMc2Hv/MHCaVMO3rG+Qn9o8Wk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-578-2QVNvla9PEKGZPwzZatlQA-1; Tue, 06 Dec 2022 19:32:37 -0500
X-MC-Unique: 2QVNvla9PEKGZPwzZatlQA-1
Received: by mail-ej1-f70.google.com with SMTP id hs18-20020a1709073e9200b007c0f9ac75f9so2387628ejc.9
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 16:32:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bx3BXv2xaG+1EbHubRbeDcJNx5uekjE2mo+oSlv4S6s=;
        b=O+5KV9xDrDvpThCnWpmL7p4CT+y8UCMEJPWvgo88kF3bfQ6IVhqD46L9ScpTteuZSp
         wXTxzcrPu/0WiPuA+FqEoAImUA15yo4xZ/z5FVJbntEr1nNyPjqPo7ujW8uj+Tj+67do
         I2YrUcVs37R2Br4klu9WVfZGwSCNL0xtNIbLOqiQ2NRE/KU3dpLDjIwkqkGdl472TcIn
         4FzD4ujLxQJFW/GHHLzSAoBSBSEH+NgbfSSDR0dLjVQWIG7zD5i20tGIPu1BV2CHN0Ld
         g3wD8uIP/xmtaAUlAcfo1Zos7EIIMjRJ30bh2Ka6NIbVeVbeN36tBD9mZz0r4mCZGz1J
         FYGQ==
X-Gm-Message-State: ANoB5pkuiS5V+sZPb+sPLciNuUWhCYIKOEvq3BJsAwBDP/3HnXj48ogo
        ISGu6/gWmwa2AO2u0JMAbx2EwziuEQv4pPdg8TNMW4aHVAO7cz4AvdmWZ8DgK4Mn3lCVFn0dpD+
        juYrVOeP4R6hm
X-Received: by 2002:a17:906:c358:b0:7c1:15ff:ce80 with SMTP id ci24-20020a170906c35800b007c115ffce80mr2620651ejb.172.1670373155576;
        Tue, 06 Dec 2022 16:32:35 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6Oxf+wCsuYpvkjV1axw2D5khlwYSyP4XXkZLxf8xeI771oZdd9N0RssiIxK8XsowEBoPe0XQ==
X-Received: by 2002:a17:906:c358:b0:7c1:15ff:ce80 with SMTP id ci24-20020a170906c35800b007c115ffce80mr2620637ejb.172.1670373155280;
        Tue, 06 Dec 2022 16:32:35 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id bv19-20020a170906b1d300b0077016f4c6d4sm7869812ejb.55.2022.12.06.16.32.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 16:32:34 -0800 (PST)
Message-ID: <16b5bdd0-ac8c-640f-579e-1335d1286d80@redhat.com>
Date:   Wed, 7 Dec 2022 01:32:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: x86: Add proper ReST tables for userspace MSR
 exits/flags
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221207000959.2035098-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221207000959.2035098-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/22 01:09, Sean Christopherson wrote:
> Add ReST formatting to the set of userspace MSR exits/flags so that the
> resulting HTML docs generate a table instead of malformed gunk.  This
> also fixes a warning that was introduced by a recent cleanup of the
> relevant documentation (yay copy+paste).
> 
>   >> Documentation/virt/kvm/api.rst:7287: WARNING: Block quote ends
>      without a blank line; unexpected unindent.

Queued, thanks.

Paolo

> Fixes: 1ae099540e8c ("KVM: x86: Allow deflecting unknown MSR accesses to user space")
> Fixes: 1f158147181b ("KVM: x86: Clean up KVM_CAP_X86_USER_SPACE_MSR documentation")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   Documentation/virt/kvm/api.rst | 20 ++++++++++++--------
>   1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index c618fae44ad7..778c6460d1de 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6455,9 +6455,11 @@ The "reason" field specifies why the MSR interception occurred. Userspace will
>   only receive MSR exits when a particular reason was requested during through
>   ENABLE_CAP. Currently valid exit reasons are:
>   
> -	KVM_MSR_EXIT_REASON_UNKNOWN - access to MSR that is unknown to KVM
> -	KVM_MSR_EXIT_REASON_INVAL - access to invalid MSRs or reserved bits
> -	KVM_MSR_EXIT_REASON_FILTER - access blocked by KVM_X86_SET_MSR_FILTER
> +============================ ========================================
> + KVM_MSR_EXIT_REASON_UNKNOWN access to MSR that is unknown to KVM
> + KVM_MSR_EXIT_REASON_INVAL   access to invalid MSRs or reserved bits
> + KVM_MSR_EXIT_REASON_FILTER  access blocked by KVM_X86_SET_MSR_FILTER
> +============================ ========================================
>   
>   For KVM_EXIT_X86_RDMSR, the "index" field tells userspace which MSR the guest
>   wants to read. To respond to this request with a successful read, userspace
> @@ -7256,11 +7258,13 @@ to inform a user that an MSR was not emulated/virtualized by KVM.
>   
>   The valid mask flags are:
>   
> -	KVM_MSR_EXIT_REASON_UNKNOWN - intercept accesses to unknown (to KVM) MSRs
> -	KVM_MSR_EXIT_REASON_INVAL   - intercept accesses that are architecturally
> -                                invalid according to the vCPU model and/or mode
> -	KVM_MSR_EXIT_REASON_FILTER  - intercept accesses that are denied by userspace
> -                                via KVM_X86_SET_MSR_FILTER
> +============================ ===============================================
> + KVM_MSR_EXIT_REASON_UNKNOWN intercept accesses to unknown (to KVM) MSRs
> + KVM_MSR_EXIT_REASON_INVAL   intercept accesses that are architecturally
> +                             invalid according to the vCPU model and/or mode
> + KVM_MSR_EXIT_REASON_FILTER  intercept accesses that are denied by userspace
> +                             via KVM_X86_SET_MSR_FILTER
> +============================ ===============================================
>   
>   7.22 KVM_CAP_X86_BUS_LOCK_EXIT
>   -------------------------------
> 
> base-commit: 3d7af7c5e000c68581429d533ed63414e4a48e6d

