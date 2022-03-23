Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAE04E5B3D
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 23:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345220AbiCWW1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 18:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239421AbiCWW1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 18:27:10 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7FF8F99B
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:25:39 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id r2so3449098iod.9
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Iw4wMyP5Sf7W5X1SZGLIFvrZ1vroraSXt5QoxGjdF1M=;
        b=FHQvXDNOL/p4c7tAShXmGLu/popVPfW38AKAwxh2ANgtNcIWhJWfHCPZYfyhM/AAk/
         +j/n8a7BB6UW7PmitudVKaPQJvhDziWaAK0FhG6LmrQ4J8w4khhOAS2d1L9F34Sg8Yvx
         YnXF/2SGLHH07V7QbBmUvY6h1RCMa3NZxgeCKFr4J/C+P+7NYug8FXhn1irgLBdQUO2a
         s6XZ54F2Ks+HAzaMbVV/x+vRkNPsEUrgTQW4QE994IEE8Vh8dmhPLCPgL5BUjGl6/3lO
         LVDogmh0MHe0CYiCysBKnsGgQc5hXtrgUCJJepWyv36g6zTjTjlEzZetrl7KipXF/GbW
         ogHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Iw4wMyP5Sf7W5X1SZGLIFvrZ1vroraSXt5QoxGjdF1M=;
        b=Hb7QdulFBChM01ZEvLFTpA6WGrccKt7Vzuy6egSh+HFH0heAW2urs+U+fyOZqsBRNq
         jZAQjwypxCl9Zp27Wyef7H935SuoVd3YQCYWpi0XkSjPJ/Aj9AC/wRadvU+BxirIEw1+
         /1QXqpmk71tp9e78eefSTx2nQqBrWewS2W3j1AoRG14ZCvO4qKhLNd5hD0aAHUpPntBL
         TV3xXXq6dNoSn97ynilMEHg1E4CSFioNmG7r4YTJR2aihtl3bB6B16b9M8XnZVmak/xu
         VSoeSB/2TTfl4kTHgY83eBt5dBuf6bJgtZyVxKStKjjubtuldZ+lLmehN5Xnjsv8XZIP
         k8Ng==
X-Gm-Message-State: AOAM533+2iq9edCtX4XMYC/Pd6BvTQQ4qhNz1mZxs3iV+PnWR4btbmeE
        3s3QDLRBg/ZFPaguF7FDa5ElIQ==
X-Google-Smtp-Source: ABdhPJxFIaPDyYYMcQ0NO8UayiA1llXj46Qabe9a/Yfed4n4kjHRHD6mY3KZ7CChW/I8o13Kyd7LSQ==
X-Received: by 2002:a5d:83c8:0:b0:604:c09b:259c with SMTP id u8-20020a5d83c8000000b00604c09b259cmr1182670ior.106.1648074339082;
        Wed, 23 Mar 2022 15:25:39 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id t7-20020a5e9907000000b00649d6bd1ec5sm575577ioj.31.2022.03.23.15.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 15:25:38 -0700 (PDT)
Date:   Wed, 23 Mar 2022 22:25:35 +0000
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
Message-ID: <YjueX2DOxjoc/d4j@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com>
 <Yjt/bJidLEPsiPfQ@google.com>
 <YjuGqunshjhCoIs5@google.com>
 <Yjuds73S1sO1UpJI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yjuds73S1sO1UpJI@google.com>
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

On Wed, Mar 23, 2022 at 03:22:43PM -0700, Ricardo Koller wrote:
> On Wed, Mar 23, 2022 at 08:44:26PM +0000, Oliver Upton wrote:
> > On Wed, Mar 23, 2022 at 01:13:32PM -0700, Ricardo Koller wrote:
> > > On Wed, Mar 23, 2022 at 07:53:14PM +0000, Oliver Upton wrote:
> > > > Hi Reiji,
> > > > 
> > > > On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > > > > Add hidden or reserved ID registers, and remaining ID registers,
> > > > > which don't require special handling, to id_reg_desc_table.
> > > > > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > > > > or reserved registers. Since now id_reg_desc_init() is called even
> > > > > for hidden/reserved registers, change it to not do anything for them.
> > > > > 
> > > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > 
> > > > I think there is a very important detail of the series that probably
> > > > should be highlighted. We are only allowing AArch64 feature registers to
> > > > be configurable, right? AArch32 feature registers remain visible with
> > > > their default values passed through to the guest. If you've already
> > > > stated this as a precondition elsewhere then my apologies for the noise.
> > > 
> > > Aren't AArch64 ID regs architecturally mapped to their AArch32
> > > counterparts?  They should show the same values.  I'm not sure if it's a
> > > problem (and if KVM is faithful to that rule),
> > 
> > I believe it's a bit more subtle than that. The AArch32 feature registers
> > are architecturally mapped to certain encodings accessible from AArch64.
> > For example, ID_PFR0_EL1 is actually a 64 bit register where bits [31:0]
> > map to the ID_PFR0 AArch32 register. ID_PFR0_EL1 is only accessible from
> > AArch64 with the MRS instruction, and ID_PFR0 is only accessible from
> > AArch32 with the MRC instruction. KVM just so happens to handle both of
> > these reads from the same sys_reg_desc.
> > 
> > AFAIK, there does not exist a direct bit mapping between the
> > ID_*_EL1 <-> ID_AA64*_EL1 registers. But hey, could be wrong :)
> 
> I think you are right. ID_PFR0_EL1[31:0] doesn't even have the same
> field as ID_AA64PFR0_EL1[31:0]. The only exception would be RAS which is
> at [31:28] on both, but it doesn't say anywhere that ID_PFR0_EL1.RAS
> maps architecturally to ID_AA64PFR0_EL1.RAS. So, I think we can assume
> it doesn't (?).

Right, the feature registers are generally related (you will find fields
of similar meaning), but figuring out that tangle and making it work is
going to be a massive waste of time IMO. If we can say that our new
feature configuration is AArch64-only, all potential bugs relating to
AArch32 collapse :-)

--
Thanks,
Oliver
