Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E774E4D0B
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 08:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240138AbiCWHHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 03:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbiCWHHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 03:07:35 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC2E71EF7
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 00:06:01 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id x4so660388iop.7
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 00:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/miMnKL4kaQ7vT+uR7jkwmb3+siwfRd5pcJFIiCuqFk=;
        b=dZgCuH70fW6h2bUCVGqSqcUfjwe9gRFbhE0jEDHSjs1zNzB7/Kp7GVELo20co5+jVG
         o4Qz1q1XMwbrSOB/I1Z3aHBBH3CSKPqwgjNlHUn1D5hGWd52rqKtA9wB/fFC8/GOj9Po
         X2ZqD+qpGHzmBu+0RqHjbw3R+s3gYHK+/wE8zNpH4uZqsa7bfk+pBE193lABOu7O5RJh
         wgd/aTk2+gL1MiIijDTW1373AWjHEeeUgaXVPVr0KEwUWggB+Q2fEXevdU6Wxc/Fb3M/
         aSWD8MiClIgCjt02tDXEkCX2xo1FUZZHBs6hGA7Q/mGXyFNzNCGl3mTKRfcpI4GQwF7v
         pzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/miMnKL4kaQ7vT+uR7jkwmb3+siwfRd5pcJFIiCuqFk=;
        b=wxhAAPUcEbbJRNos2PjbGjV1GM2l4EA2Y8rRYVFzvovVreZvz8AO7TZKBvH7AsO/zu
         PlEa0SUZBMmngXlIyAi9Nm9AWPuGLTkl7WOX4OK5hiR3VTqmpsrjO1Y693WfpNSfpZ1q
         8yAwkFE8117F0r9b+MNbSkX5Ov3AW+6givD8XrvgokgU6DVpLvGdUsdso5DwCzUxakb0
         xsX12KZQG3lgXziV1vxpQ9Zz3FB3SSyg3dGm4usLmOBY2KDBnyNCu4MVz14lJliKSYxB
         4vAeCNHR6YgIYnGEwJ44VF+F8gayTn4+3H6Wbch90tics7MwdZXEPhtVbbSCD7itGaM4
         Zrjw==
X-Gm-Message-State: AOAM530b4lEIPhDd0csp32LNIlmWRHgqcwzBwTn/JIMx7AXFBySMbiqT
        6HIB9O//RO6cz23zkcGpQtfrykCmLQhZSijE
X-Google-Smtp-Source: ABdhPJzbMKzfJP+9oJi/cTbwf64cP7kfvgXvfrr+u0NJiMiYNSt7CzGj3qdYxmH/yXQ0QuScpJNIlg==
X-Received: by 2002:a05:6638:130b:b0:317:cc10:1c88 with SMTP id r11-20020a056638130b00b00317cc101c88mr15649821jad.34.1648019160340;
        Wed, 23 Mar 2022 00:06:00 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id r9-20020a6bd909000000b00649276ea9fesm10724253ioc.7.2022.03.23.00.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 00:05:59 -0700 (PDT)
Date:   Wed, 23 Mar 2022 07:05:55 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v6 01/25] KVM: arm64: Introduce a validation function for
 an ID register
Message-ID: <YjrG0xiubC108tIN@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-2-reijiw@google.com>
 <Yjl96UQ7lUovKBWD@google.com>
 <CAAeT=FzELqXZiWjZ9aRNqYRbX0zx6LdhETiZUS+CMvax2vLRQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FzELqXZiWjZ9aRNqYRbX0zx6LdhETiZUS+CMvax2vLRQw@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 11:06:26PM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> > On Thu, Mar 10, 2022 at 08:47:47PM -0800, Reiji Watanabe wrote:
> > > Introduce arm64_check_features(), which does a basic validity checking
> > > of an ID register value against the register's limit value, which is
> > > generally the host's sanitized value.
> > >
> > > This function will be used by the following patches to check if an ID
> > > register value that userspace tries to set for a guest can be supported
> > > on the host.
> > >
> > > The validation is done using arm64_ftr_bits_kvm, which is created from
> > > arm64_ftr_regs, with some entries overwritten by entries from
> > > arm64_ftr_bits_kvm_override.
> > >
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> >
> > I have some concerns regarding the API between cpufeature and KVM that's
> > being proposed here. It would appear that we are adding some of KVM's
> > implementation details into the cpufeature code. In particular, I see
> > that KVM's limitations on AA64DFR0 are being copied here.
> 
> I assume "KVM's limitation details" you meant is about
> ftr_id_aa64dfr0_kvm.
> Entries in arm64_ftr_bits_kvm_override shouldn't be added based
> on KVM's implementation.  When cpufeature.c doesn't handle lower level
> of (or fewer) features as the "safe" value for fields, the field should
> be added to arm64_ftr_bits_kvm_override.  As PMUVER and DEBUGVER are not
> treated as LOWER_SAFE, they were added in arm64_ftr_bits_kvm_override.

I believe the fact that KVM is more permissive on PMUVER and DEBUGVER
than cpufeature is in fact a detail of KVM, no? read_id_reg() already
implicitly trusts the cpufeature code filtering and applies additional
limitations on top of what we get back. Similarly, there are fields
where KVM is more restrictive than cpufeature (ID_AA64DFR0_PMSVER).

Each of those constraints could theoretically be expressed as an
arm64_ftr_bits structure within KVM.

> Having said that, although ftr_id_aa64dfr0 has PMUVER as signed field,
> I didn't fix that in ftr_id_aa64dfr0_kvm, and the code abused that....
> I should make PMUVER unsigned field, and fix cpufeature.c to validate
> the field based on its special ID scheme for cleaner abstraction.

Good point. AA64DFR0 is an annoying register :)

> (And KVM should skip the cpufeature.c's PMUVER validation using
>  id_reg_desc's ignore_mask and have KVM validate it locally based on
>  the KVM's special requirement)
> 
> 
> > Additionally, I think it would be preferable to expose this in a manner
> > that does not require CONFIG_KVM guards in other parts of the kernel.
> >
> > WDYT about having KVM keep its set of feature overrides and otherwise
> > rely on the kernel's feature tables? I messed around with the idea a
> > bit until I could get something workable (attached). I only compile
> > tested this :)
> 
> Thanks for the proposal!
> But, providing the overrides to arm64_ftr_reg_valid() means that its
> consumer knows implementation details of cpufeture.c (values of entries
> in arm64_ftr_regs[]), which is a similar abstraction problem I want to
> avoid (the default validation by cpufeature.c should be purely based on
> ID schemes even with this option).

It is certainly a matter of where you choose to draw those lines. We already
do bank on the implementation details of cpufeature.c quite heavily, its
just stuffed away behind read_sanitised_ftr_reg(). Now we have KVM bits and
pieces in cpufeature.c and might wind up forcing others to clean up our dirty
laundry in the future.

It also seems to me that if I wanted to raise the permitted DEBUGVER for KVM,
would I have to make a change outside of KVM.

> Another option that I considered earlier was having a full set of
> arm64_ftr_bits in KVM for its validation. At the time, I thought
> statically) having a full set of arm64_ftr_bits in KVM is not good in
> terms of maintenance.  But, considering that again, since most of
> fields are unsigned and lower safe fields, and KVM doesn't necessarily
> have to statically have a full set of arm64_ftr_bits

I think the argument could be made for KVM having its own static +
verbose cpufeature tables. We've already been bitten by scenarios where
cpufeature exposes a feature that we simply do not virtualize in KVM.
That really can become a game of whack-a-mole. commit 96f4f6809bee
("KVM: arm64: Don't advertise FEAT_SPE to guests") is a good example,
and I can really see no end to these sorts of issues without an
overhaul. We'd need to also find a way to leverage the existing
infrasturcture for working out a system-wide safe value, but this time
with KVM's table of registers.

KVM would then need to take a change to expose any new feature that has
no involvement of EL2. Personally, I'd take that over the possibility of
another unhandled feature slipping through and blowing up a guest kernel
when running on newer hardware.

> (dynamically generate during KVM's initialization)

This was another one of my concerns with the current state of this
patch. I found the register table construction at runtime hard to
follow. I think it could be avoided with a helper that has a prescribed
set of rules (caller-provided field definition takes precedence over the
general one).

Sorry it took me a bit to comment on everything, needed to really sit
down and wrap my head around the series.

--
Thanks,
Oliver
