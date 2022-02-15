Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2B34B7740
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 21:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243311AbiBOS6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 13:58:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243309AbiBOS6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 13:58:03 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291FAB150C
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 10:57:53 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id r144so25050387iod.9
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 10:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xYfVux+CIlABTBnGP+1TuKUKEth7AQ/+EngXOD7SJRc=;
        b=c0Itl5iwd/n5gn0l5gRQjED/Gm+0SUMu0QvAZlzu6Uunay0OCCnebIYN2QLWE/vgr0
         b1SRkggvbPIBirN3uR9G5/FqbZZKRlx3HIl6zHi42iNs9pE++n4yCWMnWxJsWqTcwU97
         y2RWZMGWmQAMWgWTGZH6Hw6PF/jimIW8xqlfEhLrp3ruxE/g8+tVDBosnyy5nZH+16bF
         RyFh4PQA5cMTq7MPRu9GGizYCvIm5yOLfVSYyjfCM01wVqZged3cV+8o2n2goyKDU05h
         E2Rf2bZhDgmsgls83iQbHlO7n8aKBGV3ARfKHLKQIIYuZ5+qtEwnDjS8agz5x+/My3w8
         OQfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xYfVux+CIlABTBnGP+1TuKUKEth7AQ/+EngXOD7SJRc=;
        b=4jKjOqzIZuwXXVYxVRkY9N1Pyda9Bsn89igMw7/qqdbH0clac9Etcmvuvkrn/nEqdS
         rC90kliBibAg2U90j8ta/te/2rxprTFAMJEQi4MU7hUaaj8C4WIFhfPCUEqMyy60U/Td
         u6st9CN1VYFUTXDKzYo9j8m92O0se50tuqV8X8sIYQMP3w+ALGr9z3n10nr92E/rp02E
         5g9UVYxizYUoQf5pAOPwf7i9vvxzN96XCIu4VrDG7+036u6osjry0ehV8bctfcdUT47W
         Az2bXC1l8qiWMLxXihFajbWuBLEpPcvmSxiEQsjUkSYs2haS1MSAVB5nnXD5Z86J20WG
         NTtw==
X-Gm-Message-State: AOAM530oZBNb+s4aaX9IlMMAPbrnRsKRiVA9SpkzMHY5fv2TDyWvhPq6
        DYnygkFvPQVZX3F+EYjblWVa+w==
X-Google-Smtp-Source: ABdhPJwBqvknVuwUJVoIKC4yoStt6Wy8q4gp/ncMH7iNUF6wTE+Enpcr3H0D3NZSs3azu2iT2aFs3Q==
X-Received: by 2002:a02:c90a:: with SMTP id t10mr220027jao.142.1644951472295;
        Tue, 15 Feb 2022 10:57:52 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id t195sm16834393iof.47.2022.02.15.10.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 10:57:51 -0800 (PST)
Date:   Tue, 15 Feb 2022 18:57:47 +0000
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
Subject: Re: [PATCH v5 10/27] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
Message-ID: <Ygv3q/+arejIWnzs@google.com>
References: <20220214065746.1230608-1-reijiw@google.com>
 <20220214065746.1230608-11-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214065746.1230608-11-reijiw@google.com>
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

On Sun, Feb 13, 2022 at 10:57:29PM -0800, Reiji Watanabe wrote:
> When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> expose the value for the guest as it is.  Since KVM doesn't support
> IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> expose 0x0 (PMU is not implemented) instead.
> 
> Change cpuid_feature_cap_perfmon_field() to update the field value
> to 0x0 when it is 0xf.

Definitely agree with the change in this patch. Do we need to tolerate
writes of 0xf for ABI compatibility (even if it is nonsensical)?
Otherwise a guest with IMP_DEF PMU cannot be migrated to a newer kernel.

--
Thanks,
Oliver
