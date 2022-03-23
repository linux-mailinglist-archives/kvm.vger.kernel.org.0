Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0164E5968
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 20:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240423AbiCWTyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 15:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiCWTyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 15:54:49 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2533B7C16F
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 12:53:19 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id r2so3014211iod.9
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 12:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ey05sTiU2qlbU8kwj/4AtdgsovBnPHqmS42nG0aXPe4=;
        b=C2XX3ptmp7iD/+L38rLxHCKv+MC7cTKYynD9R0G3uf6eM4YjbyAcAwIKKKOS9Nm88f
         bkipYfhoLP1iaiyF07cmrsDtij8od+icgukWGgOIgW6V6KNE+6oC3iXxwWIiKZWKvrWv
         3kVr1Uau4ONlunHm7FW+YwqMFgGRR/o1+/Vrcs2aJYbDXuUqMkjJEi35MBh6xSrDwEIQ
         778SU1hchiQfPS/HEUuhYR1iA/ABf0VNQoVfg/emOUH0GQykvdLbv3sPlyLPruRHHicp
         ulgCKWw2Lmb5/Zu5M5staLb7/oEhxbk7LYIKpPpp9OtQNUot2GYewoUUoumCvNa0knWP
         c0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ey05sTiU2qlbU8kwj/4AtdgsovBnPHqmS42nG0aXPe4=;
        b=KcLMR+ddS3aWOy3/p27hWyz8iwZeHkKh/u01JcZVtW9vhhpALjuqmvjGhXcBNjCYt4
         CYZ+Y7GlT6ttDZDp16noj92Cp47G6WlKDxdP1ZpOWV4QMULoLG+YuAxZnmtHb523J8hK
         nd42yNAXjgcx9xZIhPKG9fJUH0/l0hgBXC7XATscBrc3t1Mx8XPT/G2iHaDKellDv9N7
         0iRIbRuQKe0VlfGkGARDx178fewMLxz4IEfAfXZm/Few3dsD8DAr0ZZBlApjvaHPV33a
         2ufD2QKVP8254z9u9u6iXbHndiDobJsEcG6/ckfkKH8gGiRuQ83/S56ErNGSsNGq3o/y
         KGJQ==
X-Gm-Message-State: AOAM533y6X7E7X+0ST2MJtcSfMT0BVeP+i1IEsq9PUNIdrGpqLJ4FNNs
        ZzijUBoDZsUv2Z6yl3WCRgMztA==
X-Google-Smtp-Source: ABdhPJzUI0F5LFrmcE14GaFF3gmoKkkqu/VNMiQEZebQz2uN4fibQPYY9LvuU7HinRZJngUIkr4wZA==
X-Received: by 2002:a05:6638:460d:b0:31a:7b70:e1b6 with SMTP id bw13-20020a056638460d00b0031a7b70e1b6mr797194jab.141.1648065198317;
        Wed, 23 Mar 2022 12:53:18 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id a3-20020a5ec303000000b006496b4dd21csm378009iok.5.2022.03.23.12.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 12:53:17 -0700 (PDT)
Date:   Wed, 23 Mar 2022 19:53:14 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
Message-ID: <Yjt6qvYliEDqzF9j@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311044811.1980336-12-reijiw@google.com>
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

Hi Reiji,

On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> Add hidden or reserved ID registers, and remaining ID registers,
> which don't require special handling, to id_reg_desc_table.
> Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> or reserved registers. Since now id_reg_desc_init() is called even
> for hidden/reserved registers, change it to not do anything for them.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>

I think there is a very important detail of the series that probably
should be highlighted. We are only allowing AArch64 feature registers to
be configurable, right? AArch32 feature registers remain visible with
their default values passed through to the guest. If you've already
stated this as a precondition elsewhere then my apologies for the noise.

I don't know if adding support for this to AArch32 registers is
necessarily the right step forward, either. 32 bit support is working
just fine and IMO its OK to limit new KVM features to AArch64-only so
long as it doesn't break 32 bit support. Marc of course is the authority
on that, though :-)

If for any reason a guest uses a feature present in the AArch32 feature
register but hidden from the AArch64 register, we could be in a
particularly difficult position. Especially if we enabled traps based on
the AArch64 value and UNDEF the guest.

One hack we could do is skip trap configuration if AArch32 is visible at
either EL1 or EL0, but that may not be the most elegant solution.
Otherwise, if we are AArch64-only at every EL then the definition of the
AArch32 feature registers is architecturally UNKNOWN, so we can dodge
the problem altogether. What are your thoughts?

--
Thanks,
Oliver
