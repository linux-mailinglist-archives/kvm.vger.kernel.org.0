Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471A14E5A00
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 21:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343769AbiCWUqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 16:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiCWUqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 16:46:01 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E83A196
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 13:44:31 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id p22so3201567iod.2
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 13:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fBYzqNvet64/0krUr0ciJEOs0VfPj+5SgRq8wB41m/Y=;
        b=lLOyeDE2K2xnQP2wIsZs+7lFjAZSUj+oUmRol43y2da5eJOostn3fkxHSFqFT1OEoE
         DLJLBtgCvey2Y6GmWH+AVUYWVDk5ms0Pn4hWGrwF5nL+TJ/T5R2fktQIlF/lcushiszq
         W4PP9+tx8xGR6cgtFo3T9retLiCapuKxPzlGCopIMxn623ciKn/lu7rUK4ar8gVKrWWH
         /zln0ndb20fztc0l9AiKPOzEFe4T4YxiHzKoYrpDJHBNnYyuYe38LJcdKWb3HF98Wcip
         ZJU9aEkYve+mZv7RHs5kvtHOYKRGHNuDy9LZWztx70CdbisJJ8L2vp5eYA5qa2UF8S6+
         y8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fBYzqNvet64/0krUr0ciJEOs0VfPj+5SgRq8wB41m/Y=;
        b=rE+T8Fh2++aq4EJkaIMOullhnR2bzyheMRB6dehuMNSqRqXZ4HfRuuSvIAUo8Eye/u
         4bxmCqV8rkcC4wSFS9hupIkaJGjyyek3ONdd4qKeCXige7D7Yh7oUNc9huw58euJzlc3
         GLd9DcEGL9XGRKIZ9kPRzRXclo4zMHDYyyruwLx8RiWils8hkg4c7Nhl7pOGMz/TPpNh
         9WP5Jl7k5+TWkEA42fgEXscQiy4WU9EipNW6534aBBKqFhYxOrDM3wWfCPbxAOKmusxR
         /u3X/KqrxgXEaDU9VkwP2Sr4I7XR+4Xvue9GvCLFkstAQs7H0ZUQ8s9ESTYf1U37MK/D
         vwsg==
X-Gm-Message-State: AOAM533/9q9P3Vj1vhlcTeNsPejjB++CK7YA+MSzdDH2+MFRLUREiDgO
        OabZwdbhbe9twvxpT0kZlEq96w==
X-Google-Smtp-Source: ABdhPJw3ZsqPYgRWN2t8hFdvcwjyxZrgb4iSxxaz6Qmr0jj4ImtSi0dpxqgCuiywJjF12eN2LenMAA==
X-Received: by 2002:a05:6602:1409:b0:5e7:487:133c with SMTP id t9-20020a056602140900b005e70487133cmr986456iov.196.1648068270491;
        Wed, 23 Mar 2022 13:44:30 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id k5-20020a6bf705000000b00649a2634725sm470970iog.17.2022.03.23.13.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 13:44:29 -0700 (PDT)
Date:   Wed, 23 Mar 2022 20:44:26 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
Message-ID: <YjuGqunshjhCoIs5@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com>
 <Yjt/bJidLEPsiPfQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yjt/bJidLEPsiPfQ@google.com>
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

On Wed, Mar 23, 2022 at 01:13:32PM -0700, Ricardo Koller wrote:
> On Wed, Mar 23, 2022 at 07:53:14PM +0000, Oliver Upton wrote:
> > Hi Reiji,
> > 
> > On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > > Add hidden or reserved ID registers, and remaining ID registers,
> > > which don't require special handling, to id_reg_desc_table.
> > > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > > or reserved registers. Since now id_reg_desc_init() is called even
> > > for hidden/reserved registers, change it to not do anything for them.
> > > 
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > 
> > I think there is a very important detail of the series that probably
> > should be highlighted. We are only allowing AArch64 feature registers to
> > be configurable, right? AArch32 feature registers remain visible with
> > their default values passed through to the guest. If you've already
> > stated this as a precondition elsewhere then my apologies for the noise.
> 
> Aren't AArch64 ID regs architecturally mapped to their AArch32
> counterparts?  They should show the same values.  I'm not sure if it's a
> problem (and if KVM is faithful to that rule),

I believe it's a bit more subtle than that. The AArch32 feature registers
are architecturally mapped to certain encodings accessible from AArch64.
For example, ID_PFR0_EL1 is actually a 64 bit register where bits [31:0]
map to the ID_PFR0 AArch32 register. ID_PFR0_EL1 is only accessible from
AArch64 with the MRS instruction, and ID_PFR0 is only accessible from
AArch32 with the MRC instruction. KVM just so happens to handle both of
these reads from the same sys_reg_desc.

AFAIK, there does not exist a direct bit mapping between the
ID_*_EL1 <-> ID_AA64*_EL1 registers. But hey, could be wrong :)

--
Thanks,
Oliver
