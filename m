Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A76A6E87DC
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 04:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbjDTCNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 22:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjDTCNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 22:13:11 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECEC448F
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 19:13:09 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a652700c36so265255ad.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 19:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681956789; x=1684548789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j3mfY1x+gF/1P1SV5MF/1QshXYyOurUnvNxF9n5huIU=;
        b=3MVPFD/cqk5XTZrmHEVcAVMpV/Y7QawbyBzDzxNaLFtCq2pf42OHih1gcM5zFexrAD
         VIi0L+poaGd8q7UyJL0FujPTvymtAieNzFdlJrIBGS6D2D/RZmBYLTP+s0tn/Z8a495J
         J7kfqtt2E3ZqlqZwdTlgKp6q1aAl+ygmx5aFrCUhd6wTY5RzNrNS5DEiRtx8G6854Cqg
         N7JePQFiutxIzwFliy0kTUHvBSklQ/vpKmRYUlmKAgfAdGsQS64nKdSYW6vI8jhXAmoY
         udRjjvt/SUZRtzNc97T8fO9BrtA4GDcaBZrrkXD/uJcp5h873yYCDXLnT4M+GjzAabf+
         M+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681956789; x=1684548789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3mfY1x+gF/1P1SV5MF/1QshXYyOurUnvNxF9n5huIU=;
        b=DEqUv+hVUOUW8oZ7QZftQ5tY33hv+mfDVqX/Ib8SS1zPFdkZPp5a/fpNwqlhJZlKxw
         V86ItW2O3DtlpWxr/QujKPdvHLeHJbV3RAejihWAlrTK1vLwzqMXGErMdsHoAD8DvYri
         TcQqJp/liGpjucfQb0ho5Wi70jE/LCWGVdJthf0/ziR3qcY3fdwCxUzuX00dK77SzG8l
         +EbklieBKdc9G4G5NTQt29/5VG/e7kEPEUWZZMeg+T6up6KRUocof0M/JEZY9K3+/UqH
         eUFzt7ITmzXQqYFkKv2wpuNvl9QfZhChNKMke1JASxGh5HTU8gXKD3zQ+upasBzY12mv
         O5ww==
X-Gm-Message-State: AAQBX9cc4msAx8jb6KYanu8EPAZ57OhL3o1Le8sMNnrkv9PH6kRX69ps
        v5NQBZtjBED7hizeFS5SHRhyvA==
X-Google-Smtp-Source: AKy350YmZ9FCjXaXJs440gj9/oyG4q157BweH7jdiFAbmU46Ga8I0nAgzsKweQOdMmdBbqjFbov9cQ==
X-Received: by 2002:a17:903:192:b0:1a6:760c:af3d with SMTP id z18-20020a170903019200b001a6760caf3dmr141041plg.16.1681956789231;
        Wed, 19 Apr 2023 19:13:09 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id 3-20020a170902c10300b001a194df5a58sm108537pli.167.2023.04.19.19.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 19:13:07 -0700 (PDT)
Date:   Wed, 19 Apr 2023 19:13:02 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1 1/2] KVM: arm64: Acquire mp_state_lock in
 kvm_arch_vcpu_ioctl_vcpu_init()
Message-ID: <20230420021302.iyl3pqo3lg6lpabv@google.com>
References: <20230419021852.2981107-1-reijiw@google.com>
 <20230419021852.2981107-2-reijiw@google.com>
 <87cz405or6.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cz405or6.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Wed, Apr 19, 2023 at 08:12:45AM +0100, Marc Zyngier wrote:
> On Wed, 19 Apr 2023 03:18:51 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> > kvm_arch_vcpu_ioctl_vcpu_init() doesn't acquire mp_state_lock
> > when setting the mp_state to KVM_MP_STATE_RUNNABLE. Fix the
> > code to acquire the lock.
> > 
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/arm.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index fbafcbbcc463..388aa4f18f21 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1244,8 +1244,11 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
> >  	 */
> >  	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
> >  		kvm_arm_vcpu_power_off(vcpu);
> > -	else
> > +	else {
> > +		spin_lock(&vcpu->arch.mp_state_lock);
> >  		WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
> > +		spin_unlock(&vcpu->arch.mp_state_lock);
> > +	}
> >  
> >  	return 0;
> >  }
> 
> I'm not entirely convinced that this fixes anything. What does the
> lock hazard against given that the write is atomic? But maybe a

It appears that kvm_psci_vcpu_on() expects the vCPU's mp_state
to not be changed by holding the lock.  Although I don't think this
code practically causes any real issues now, I am a little concerned
about leaving one instance that updates mpstate without acquiring the
lock, in terms of future maintenance, as holding the lock won't prevent
mp_state from being updated.

What do you think ?

> slightly more readable of this would be to expand the critical section
> this way:
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 4ec888fdd4f7..bb21d0c25de7 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1246,11 +1246,15 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>  	/*
>  	 * Handle the "start in power-off" case.
>  	 */
> +	spin_lock(&vcpu->arch.mp_state_lock);
> +
>  	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
> -		kvm_arm_vcpu_power_off(vcpu);
> +		__kvm_arm_vcpu_power_off(vcpu);
>  	else
>  		WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
>  
> +	spin_unlock(&vcpu->arch.mp_state_lock);
> +
>  	return 0;
>  }
> 
> Thoughts?

Yes, it looks better!

Thank you,
Reiji
