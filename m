Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031DB6EB5AC
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 01:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbjDUXUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 19:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDUXUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 19:20:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106A91706
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 16:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682119172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gArk5kA5h91jQajZJDrJgiT/ybVjEuAxb1hpzR7LDuo=;
        b=YLPbFFQbVF96lUFsMGryIUbJXQDF9kIwa/nJbhTay3VJCRiBkFzCfKb78Z6VU/Wv5kNMpk
        xBlI6pxIFp300cFiwQrcA3VC64zcbDwLfr30EJ4ZENdADk+U6bdkhTgO6OVI/+xYn+GHrO
        mmxptNjrqvBwJ+ZYj5sl5O5CLsPDNzQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-v967u5dtOOm5xzeL2C-bIw-1; Fri, 21 Apr 2023 19:19:30 -0400
X-MC-Unique: v967u5dtOOm5xzeL2C-bIw-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-506a4c0af47so2130415a12.1
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 16:19:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682119169; x=1684711169;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gArk5kA5h91jQajZJDrJgiT/ybVjEuAxb1hpzR7LDuo=;
        b=Uqen9Jv9/3Ab9wf154at733PGGjvwz7SHySogxBjjRhPRwxu8pg2Bjh3TZVXWvbvM7
         ca6p7b3ElaPXL3gT26C7wevEOxQC3Kl19V4Cw8pSneMVuIeQKll0toYCg10KDVyX9FlA
         DxrgOGNqhtLAdWE8SCIO5Nj/xsHzgOyII4UegqBaGxyzvEd6tVVjcjnT3dDw4h4LOCA6
         fEPaf7GGDCE6b5IJcdYS0MsE98zF5k301jQnbWF5xFt+D5nJx1wTxknmGanigMWAKJ4V
         YskGCFouJCSsq7zlAE3QbUdOEB51gGB0XDxz5YmkbTbuKMFIXcjFqZpdd6ItQEu/cQJy
         +1iQ==
X-Gm-Message-State: AAQBX9clBHGyWXX+YgXGnCRJmNNga6CUVtFPDKTnhJjUlWAS+OtWGgno
        CD52F9GWQdjyokC2AYWp6z2vkUb2ALEVur8TuoNJw2Vtceor02988kmsQjOBfY9sGlfTD3zXony
        MAJHK3HTCQi31
X-Received: by 2002:a17:906:6696:b0:94f:296d:75d0 with SMTP id z22-20020a170906669600b0094f296d75d0mr4131501ejo.30.1682119168888;
        Fri, 21 Apr 2023 16:19:28 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZZ3xqFfRB+TCuv6iug8ekUlrIuTCxxZuHbavzl6Dc3sGW8mAGG3LfQs+u3PgmIl6xEzLAkvg==
X-Received: by 2002:a17:906:6696:b0:94f:296d:75d0 with SMTP id z22-20020a170906669600b0094f296d75d0mr4131473ejo.30.1682119168476;
        Fri, 21 Apr 2023 16:19:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id e6-20020a1709062c0600b0094ef2003581sm2612514ejh.153.2023.04.21.16.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 16:19:27 -0700 (PDT)
Message-ID: <1583e743-2448-6bb9-1653-265887f73eb0@redhat.com>
Date:   Sat, 22 Apr 2023 01:19:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [GIT PULL v2] KVM/arm64 fixes for 6.3, part #4
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Mostafa Saleh <smostafa@google.com>,
        Dan Carpenter <dan.carpenter@linaro.org>
References: <ZEAOmK52rgcZeDXg@thinky-boi>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZEAOmK52rgcZeDXg@thinky-boi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/19/23 17:54, Oliver Upton wrote:
> Hi Paolo,
> 
> Here is v2 of the last batch of fixes for 6.3 (for real this time!)
> 
> Details in the tag, but the noteworthy addition is Dan's fix for a
> rather obvious buffer overflow when writing to a firmware register.
> 
> Please pull,
> 
> Oliver
> 
> The following changes since commit e81625218bf7986ba1351a98c43d346b15601d26:
> 
>    KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs (2023-04-04 15:52:06 +0000)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.3-4
> 
> for you to fetch changes up to a25bc8486f9c01c1af6b6c5657234b2eee2c39d6:
> 
>    KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg() (2023-04-19 15:22:37 +0000)

Pulled, thanks.

Paolo

> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.3, part #4
> 
>   - Plug a buffer overflow due to the use of the user-provided register
>     width for firmware regs. Outright reject accesses where the
>     user register width does not match the kernel representation.
> 
>   - Protect non-atomic RMW operations on vCPU flags against preemption,
>     as an update to the flags by an intervening preemption could be lost.
> 
> ----------------------------------------------------------------
> Dan Carpenter (1):
>        KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()
> 
> Marc Zyngier (1):
>        KVM: arm64: Make vcpu flag updates non-preemptible
> 
>   arch/arm64/include/asm/kvm_host.h | 19 ++++++++++++++++++-
>   arch/arm64/kvm/hypercalls.c       |  2 ++
>   2 files changed, 20 insertions(+), 1 deletion(-)
> 

