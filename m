Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD334E5D30
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 03:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244635AbiCXC2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 22:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347772AbiCXC2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 22:28:06 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6709939B1
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 19:26:35 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id k25so3930429iok.8
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 19:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=890X9ZlW/q/ZeZqirs7HvcNCWN7aGL7evmsesPaQNmQ=;
        b=rxX998mFFfKKFwyAeeJOshWSPWoXTtcDGc2Rs99n2aE5JPs2wCNBni5DWMWGDK5FKx
         Q7lLIGEqmOvSWff8vXIyOD5ZNt/HCfvrjTYtRVygUmtaS7rEK4hsmBPgiNSjolAwPt9B
         bEcqIk7A9aVcGT6tLAygknW8s63iFNnBVF7O1b6flHzqX0rdAHmWJFaDpNyRrWbESTdW
         w7w3go6IUFDbYKQPt+ig5iHmLmSpZdvceZhiU0rhomRZs+M2kx+IhNEDhVI3yxhdh2hX
         HG8dyKnD5kbiK/15DzoJOKw6fGH74ySt5vJZPCnhT2FsMkINzT7lCURMaC2F4D6EI9AF
         vl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=890X9ZlW/q/ZeZqirs7HvcNCWN7aGL7evmsesPaQNmQ=;
        b=NNEm7WX4jPonQPZZvYzP6C9TJFVMyW+gr/itnZBCIVhABXZaEvIB0DV78AtRF0lXw1
         JduSuMhpCwQmBLiiA71aXWw66DQEZGv6AcVuqTT3yk2ot955ZjcLrIAqzMv3Ejil0nIt
         hbLuuD9DrFbsV2WqHyg+Q9QFtc97w3aUn973UirFtaoSKXKZdjV+fdvLyfEtbJ4n1z4r
         CIyAm9HlH0JYb9fVHT+Qkx/wDj9SrnJbgPakmU8RRhDyuHiM0KmdfgWHHB/+SCHr07G7
         QXI3lWUjyvWq96VFYeuS/vgY0fIoxi9HWZ5pICzYnCS9injXhvdb5aYeVBs7v5zT/N6P
         BbZg==
X-Gm-Message-State: AOAM530R+DgksHVsflyG/GzCfgTt4SJHtsn1t2xhM5/yibnv10EVZv5Z
        t7VuXolvAk7t1I/xADftuqEvLg==
X-Google-Smtp-Source: ABdhPJwIwB7dsVZCMZPmvWaa1HkqW3/JHdv1qtXXns+LPlUOuyK0nCVpB3hi5nVUva0OPPnhM1Z1Sg==
X-Received: by 2002:a05:6638:3043:b0:314:7ce2:4a6e with SMTP id u3-20020a056638304300b003147ce24a6emr1650582jak.258.1648088794648;
        Wed, 23 Mar 2022 19:26:34 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id a3-20020a5ec303000000b006496b4dd21csm774433iok.5.2022.03.23.19.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 19:26:33 -0700 (PDT)
Date:   Thu, 24 Mar 2022 02:26:30 +0000
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
Message-ID: <YjvW1lLT1sVZf0jK@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com>
 <Yjt/bJidLEPsiPfQ@google.com>
 <YjuGqunshjhCoIs5@google.com>
 <Yjuds73S1sO1UpJI@google.com>
 <YjueX2DOxjoc/d4j@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjueX2DOxjoc/d4j@google.com>
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

On Wed, Mar 23, 2022 at 10:25:35PM +0000, Oliver Upton wrote:
> On Wed, Mar 23, 2022 at 03:22:43PM -0700, Ricardo Koller wrote:
> > On Wed, Mar 23, 2022 at 08:44:26PM +0000, Oliver Upton wrote:
> > > On Wed, Mar 23, 2022 at 01:13:32PM -0700, Ricardo Koller wrote:
> > > > On Wed, Mar 23, 2022 at 07:53:14PM +0000, Oliver Upton wrote:
> > > > > Hi Reiji,
> > > > > 
> > > > > On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > > > > > Add hidden or reserved ID registers, and remaining ID registers,
> > > > > > which don't require special handling, to id_reg_desc_table.
> > > > > > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > > > > > or reserved registers. Since now id_reg_desc_init() is called even
> > > > > > for hidden/reserved registers, change it to not do anything for them.
> > > > > > 
> > > > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > > 
> > > > > I think there is a very important detail of the series that probably
> > > > > should be highlighted. We are only allowing AArch64 feature registers to
> > > > > be configurable, right? AArch32 feature registers remain visible with
> > > > > their default values passed through to the guest. If you've already
> > > > > stated this as a precondition elsewhere then my apologies for the noise.
> > > > 
> > > > Aren't AArch64 ID regs architecturally mapped to their AArch32
> > > > counterparts?  They should show the same values.  I'm not sure if it's a
> > > > problem (and if KVM is faithful to that rule),
> > > 
> > > I believe it's a bit more subtle than that. The AArch32 feature registers
> > > are architecturally mapped to certain encodings accessible from AArch64.
> > > For example, ID_PFR0_EL1 is actually a 64 bit register where bits [31:0]
> > > map to the ID_PFR0 AArch32 register. ID_PFR0_EL1 is only accessible from
> > > AArch64 with the MRS instruction, and ID_PFR0 is only accessible from
> > > AArch32 with the MRC instruction. KVM just so happens to handle both of
> > > these reads from the same sys_reg_desc.

Ughhhhh.

We actually clear HCR_EL2.TID3 for AArch32 guests, so AArch32 EL1 reads
straight from hardware. Considering the work we put in to make sure
feature registers are consistent system-wide and the limitations on
certain features, this is plain wrong.

I have a series that addresses this but need to go find some 32 bit
hardware to test with :)

--
Thanks,
Oliver
