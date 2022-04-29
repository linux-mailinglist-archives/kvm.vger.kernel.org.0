Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55785140F6
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 05:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbiD2Dpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 23:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236682AbiD2Dpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 23:45:50 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1535F8F6
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 20:42:33 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z26so8534400iot.8
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 20:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R4JPQup2EYs9JDGRJV40gMfrDAg1pajknYA/JOwy6a0=;
        b=o2ny9/GcrvLgIXJIbeNdVaugvjxib9crpwPekIyQlVLwX9Tj4yU9mA+rmY2QrBjeMy
         iGK4ZD6N+xuLUM12CGNXKgpe17s0aptFQIiGz+be7VN+mJ8kIsC156v/J25IgKhwAcYs
         snWl1PZNGUvJqCbCDCdHARKwVI/fwxRMLo46DpcNVjs5L9aP9NlsYl+K5VCJNIJb7a41
         STDcKB75F9xo6mbz3JeeljcMQAuTJocuLOuofTJxXel8Kg5vNV09RUBLE7IADdXm/gvx
         1l2F7hGGzEhePeZxS83ovSdzYZ6hPg9HLeQFU71ekcj3kCXJVBHuKm0PavfmO0GQdxo2
         IXrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R4JPQup2EYs9JDGRJV40gMfrDAg1pajknYA/JOwy6a0=;
        b=uKvaVYPdRNF1ifzrsSq72bvTM0OgbFiyPyVg7x+hcZcrwC7SSA4LyL/x1VWDjeOLWZ
         N5r5edfdWCxUXWnN5SmzYvR0IF918TNEieASKoXH17qMveZCJnpS8EJF+pq4IeM0+LSN
         G2MH1Faid8o8BbQZnuyaG1zeW0GDgyGW1u7G5vse+VqLrlL1o09WW0Evq7Cc7yB4sF3e
         T1Nh/HbQydhxo5kViGa8pZqVT9I11iWxG9IN8jwkBWCAl6QxiRHvThrNTUSa2+5sGoOF
         7pDR8U6zaGWWl746EKN6vmkf8F6A7qR1hY/wM2O/Dc7hhfmRsI8To/wBwORiXJuWbdgt
         TIhA==
X-Gm-Message-State: AOAM531WvE6x9JdIgy0nrBggVNjW1SwIGUugVAPwWi/MDF9vMa2uHfHW
        NWK2YhMyLZbRwAcdbbSjt3q3wA==
X-Google-Smtp-Source: ABdhPJwWnQdNl48oTXoNwQUBwq9CjglUWwury57PWB4FK6563eKFNWxVLyVdM+5Op/zhn5KEiAyWZA==
X-Received: by 2002:a05:6602:2a42:b0:652:8e2d:e4b7 with SMTP id k2-20020a0566022a4200b006528e2de4b7mr14588853iov.142.1651203752971;
        Thu, 28 Apr 2022 20:42:32 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id h37-20020a022b25000000b0032b3a78178asm249050jaa.78.2022.04.28.20.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 20:42:31 -0700 (PDT)
Date:   Fri, 29 Apr 2022 03:42:28 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        James Morse <james.morse@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH v5 07/13] KVM: arm64: Add support for userspace to
 suspend a vCPU
Message-ID: <YmtepGWYckmUKln+@google.com>
References: <20220409184549.1681189-1-oupton@google.com>
 <20220409184549.1681189-8-oupton@google.com>
 <CAAeT=FzURZmYfsLJnWMXufBiaZ6Wypan+xK4WxOSM=p=kEnYxA@mail.gmail.com>
 <CAOQ_Qsg2oNx8Ke7wGy1sU-5Ruq8uCWMKU5VkvTn=co6oRhhXww@mail.gmail.com>
 <CAAeT=Fx5Nb0EJ+6825fYxAxF9bK5DHOXNmJiSVGP=JVSbWuCrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=Fx5Nb0EJ+6825fYxAxF9bK5DHOXNmJiSVGP=JVSbWuCrQ@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022 at 11:28:42PM -0700, Reiji Watanabe wrote:

[...]

> > > > +static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +       vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
> > > > +       kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> > > > +       kvm_vcpu_kick(vcpu);
> > >
> > > Considering the patch 8 will remove the call to kvm_vcpu_kick()
> > > (BTW, I wonder why you wanted to make that change in the patch-8
> > > instead of the patch-7),
> >
> > Squashed the diff into the wrong patch! Marc pointed out this is of
> > course cargo-culted as I was following the pattern laid down by
> > KVM_REQ_SLEEP :)
> 
> I see. Thanks for the clarification !
> 
> > > it looks like we could use the mp_state
> > > KVM_MP_STATE_SUSPENDED instead of using KVM_REQ_SUSPEND.
> > > What is the reason why you prefer to introduce KVM_REQ_SUSPEND
> > > rather than simply using KVM_MP_STATE_SUSPENDED ?
> >
> > I was trying to avoid any heavy refactoring in adding new
> > functionality here, as we handle KVM_MP_STATE_STOPPED similarly (make
> > a request). ARM is definitely a bit different than x86 in the way that
> > we handle the MP states, as x86 doesn't bounce through vCPU requests
> > to do it and instead directly checks the mp_state value.
> 
> The difference from KVM_MP_STATE_STOPPED is that kvm_arm_vcpu_power_off()
> calls kvm_vcpu_kick(), which made me think having KVM_REQ_SLEEP was
> reasonable (it appears kvm_vcpu_kick() won't be needed there due to
> the same reason as kvm_arm_vcpu_suspend).

Just to finish the thought on this before mailing out what I hope is the
last take on all of this. I'm going to leave the pointless call to
kvm_vcpu_kick() in place, if only to follow the pattern of other MP
states.

That will all get cleaned up later on, as discussed :)

--
Thanks,
Oliver
