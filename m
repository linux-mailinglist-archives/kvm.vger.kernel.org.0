Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406FB493522
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 07:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351156AbiASGmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 01:42:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245700AbiASGm1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 01:42:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642574546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MF1FuGFJdpOohIJ1ssXp+qAxwbB16v8stQCdey9tRcg=;
        b=QZBh/S5obycedEYcYaocchDNEmgUeR43nEDnaNyTj+97rjCscl+6hH8qBqmrtIrZGvS/Xa
        IENGxSyS1ox7p3VrJlpChoMs3i9h4aselNMMUw+gxFTCf4B4Ulf56hBDGbJzMDml1eDe7x
        eLWC168nji/3dRoveVxYmSXaNGqRJWs=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-NKVA7Jq6P_KOQRYZxSTbPA-1; Wed, 19 Jan 2022 01:42:24 -0500
X-MC-Unique: NKVA7Jq6P_KOQRYZxSTbPA-1
Received: by mail-pj1-f69.google.com with SMTP id y14-20020a17090ad70e00b001b4fc2943b3so561361pju.8
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 22:42:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MF1FuGFJdpOohIJ1ssXp+qAxwbB16v8stQCdey9tRcg=;
        b=Z0xn7PpEOXbCKhiClsVXxjeOPc8Hl+Urqn8WnA5jtjTQLdvtuhCVkvw7FRotu4LAhK
         hq3FtSMptMm9LzQPfS90A9Rq12aRaXHmwK4SyEdsYPXvpiFRNAY448NIuCrBr7TLX5QO
         HDxbew7rgSTWQQoIYheDA+2+ZJlALXckJj1HFd9TES33YnuNLjsuF4UVGJ0gB/OH/gKs
         gAQXG2Emrw0glIfFx55cHcFTC/8VVVhfSevyXs2PMqZbDm7YF6igFA/Vq6JEa5Rral1b
         RKui7l9kxFQosmgINfTHjmcp4mRDrcLRFn3p0zMAnFb4SokwFTpfFjgW293S80YGD83C
         gHKg==
X-Gm-Message-State: AOAM532Eo0QE47GC+I1eI2c1kKorx0fGDO+fF22MNezvOrxLruYaCO31
        dnhP+TEPGMPaF0BYvSwiZLJ9rm+Dz2v8Ybfg+BFIEW5UtoveaaSD2WKCmblpkJ/1pQWQHAk2sgZ
        GLNB7F3P2+g/N
X-Received: by 2002:a17:902:ac8f:b0:14a:ac30:47d7 with SMTP id h15-20020a170902ac8f00b0014aac3047d7mr16543324plr.168.1642574543714;
        Tue, 18 Jan 2022 22:42:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfLyBSLuUdFeXn+Bg5WDLz7nFtnsc2uixZcGKG5XSs6BPtw5MhYNQsaP8UjQVY658RSwJjgQ==
X-Received: by 2002:a17:902:ac8f:b0:14a:ac30:47d7 with SMTP id h15-20020a170902ac8f00b0014aac3047d7mr16543301plr.168.1642574543414;
        Tue, 18 Jan 2022 22:42:23 -0800 (PST)
Received: from [10.72.13.227] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4sm4821921pjn.56.2022.01.18.22.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 22:42:22 -0800 (PST)
Message-ID: <960d4166-1718-55ef-d324-507a8add7e3e@redhat.com>
Date:   Wed, 19 Jan 2022 14:42:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v3 04/11] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-5-rananta@google.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220104194918.373612-5-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/1/5 上午3:49, Raghavendra Rao Ananta 写道:
> KVM regularly introduces new hypercall services to the guests without
> any consent from the Virtual Machine Manager (VMM). This means, the
> guests can observe hypercall services in and out as they migrate
> across various host kernel versions. This could be a major problem
> if the guest discovered a hypercall, started using it, and after
> getting migrated to an older kernel realizes that it's no longer
> available. Depending on how the guest handles the change, there's
> a potential chance that the guest would just panic.
>
> As a result, there's a need for the VMM to elect the services that
> it wishes the guest to discover. VMM can elect these services based
> on the kernels spread across its (migration) fleet. To remedy this,
> extend the existing firmware psuedo-registers, such as
> KVM_REG_ARM_PSCI_VERSION, for all the hypercall services available.



Haven't gone through the series but I wonder whether it's better to have 
a (e)BPF filter for this like seccomp.

Thanks


>
> These firmware registers are categorized based on the service call
> owners, and unlike the existing firmware psuedo-registers, they hold
> the features supported in the form of a bitmap.
>
> The capability, KVM_CAP_ARM_HVC_FW_REG_BMAP, is used to announce
> this extension, which returns the number of psuedo-firmware
> registers supported. During the VM initialization, the registers
> holds an upper-limit of the features supported by the corresponding
> registers. It's expected that the VMMs discover the features
> provided by each register via GET_ONE_REG, and writeback the
> desired values using SET_ONE_REG. KVM allows this modification
> only until the VM has started.
>
> Older VMMs can simply ignore the capability and the hypercall services
> will be exposed unconditionally to the guests, thus ensuring backward
> compatibility.
>
> In this patch, the framework adds the register only for ARM's standard
> secure services (owner value 4). Currently, this includes support only
> for ARM True Random Number Generator (TRNG) service, with bit-0 of the
> register representing mandatory features of v1.0. Other services are
> momentarily added in the upcoming patches.
>
> Signed-off-by: Raghavendra Rao Ananta<rananta@google.com>

