Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07594E389D
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 06:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236794AbiCVFvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 01:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236808AbiCVFvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 01:51:03 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BA731535
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 22:49:34 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id r11so11747596ila.1
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 22:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bWjZMLU+VFCSrR0lmrzXv5X+bH9F7caMUKl8oy21g1s=;
        b=GNd7/xXpwD7cgS56Oo4ahnoy7Q/tYMIQk8nR9PdKbphhOdpbUdRhugE5U0c0v8mpWy
         8ePlQ22UlEluvp5V4IOKUMXV9oWogrhbFplL/M5bGE9qVUyINV5ij+W1Vl7GW5Z1ajXv
         2/FZw0j8nTQ4pXXJ+9AzPRVRpMWwWvG/et9yer0dNhBSogswjZT+HBwaNpVn5PsKP7Vw
         IJk1dHlDRIWSNkpwek/bemefUZkMrugq3DmD2xpMWMXzn+lxOcY9CMWJL+ucofgz8Uxu
         uZnPsxwJI34uyrVxWyTgkrX4JJ2NXeEQnFShMQpdcgghgxvETg1xaV24K/RTfWSNJ7rf
         Uk5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bWjZMLU+VFCSrR0lmrzXv5X+bH9F7caMUKl8oy21g1s=;
        b=L21fipTP4HDDQnfPft2Mu6XgXtRrbdvPzHrDIZlLV9MHl5mR2+7QxGbOevlruajK2q
         Bs1fYEaLaiOu4I7yrs1X5MbA2X2+qvijnSCyOaQIJPnwTT+PuMbykOHWp3tr/DqcL+au
         hr/h5OwB3zMLkmlvwOaZry5pRYO5gyLoLG85yYs6IJW0U1rNRLokbVaxL2YrckXl0J8/
         nWmcKD1/cNkdX+0e6K93luwlHYXKZCCdJQ65vaowFaATDTxbf/jQQp5g4ppIZ6QAWN54
         ws93s26r/tXxx8qSKGmh6KvWjI8mFUW0YBNWe2J6KKmGDO2mAS+OihD94TMoTzte49TR
         Bh0w==
X-Gm-Message-State: AOAM531F1yMQ6serX21e9nHFIsBSVxPGq1RH3L0+hDEgaiMUc8hBZ+eo
        Py/W0j50fSj5BEcnt/3BSIiTKQ==
X-Google-Smtp-Source: ABdhPJyYsgwXPFau1PVGew3KMrIqlZSvQU08WKe/gwzt6lhUP9tczQJPrl7k58LJ0N+qJV996Ll1pA==
X-Received: by 2002:a92:cbc3:0:b0:2c6:78fa:41e9 with SMTP id s3-20020a92cbc3000000b002c678fa41e9mr11457667ilq.112.1647928173864;
        Mon, 21 Mar 2022 22:49:33 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id k11-20020a926f0b000000b002c2756f7e90sm9842447ilc.17.2022.03.21.22.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 22:49:32 -0700 (PDT)
Date:   Tue, 22 Mar 2022 05:49:29 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/2] KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2
 from AArch32
Message-ID: <YjljaS3Jeste4/ID@google.com>
References: <20220318193831.482349-1-oupton@google.com>
 <20220318193831.482349-3-oupton@google.com>
 <CAAeT=FwR-=U_0WvKqV4UTCmo8x1=atBVtTQeirwiF3XCo+S=1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FwR-=U_0WvKqV4UTCmo8x1=atBVtTQeirwiF3XCo+S=1g@mail.gmail.com>
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

On Mon, Mar 21, 2022 at 09:41:39PM -0700, Reiji Watanabe wrote:
> On 3/18/22 12:38 PM, Oliver Upton wrote:
> > The SMCCC does not allow the SMC64 calling convention to be used from
> > AArch32. While KVM checks to see if the calling convention is allowed in
> > PSCI_1_0_FN_PSCI_FEATURES, it does not actually prevent calls to
> > unadvertised PSCI v1.0+ functions.
> >
> > Check to see if the requested function is allowed from the guest's
> > execution state. Deny the call if it is not.
> >
> > Fixes: d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest")
> > Cc: Will Deacon <will@kernel.org>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>

Appreciated :-)

> BTW, considering the new kvm_psci_check_allowed_function()implementation
> in the patch-1, it might be better to call kvm_psci_check_allowed_function()
> from kvm_psci_call() instead?  Then, we could avoid the similar issue
> next time we support a newer PSCI version.

Good point. If Marc doesn't bite in the next day or two I'll address
this with a new spin, otherwise I'll do a separate cleanup. Just want to
avoid spamming on this topic since I already replied with yet another
patch [1].

Thanks!

[1] https://lore.kernel.org/kvmarm/20220322013310.1880100-1-oupton@google.com

--
Oliver
