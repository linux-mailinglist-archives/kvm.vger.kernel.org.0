Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA0275D65A
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 23:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjGUVS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 17:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjGUVS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 17:18:26 -0400
Received: from out-13.mta0.migadu.com (out-13.mta0.migadu.com [91.218.175.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CE8359D
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 14:18:23 -0700 (PDT)
Date:   Fri, 21 Jul 2023 21:18:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689974302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dW9NP/U3Lw4IrnYzKtHyEmbm5SYrC7sHbcRAwqr1Q6g=;
        b=htfKD0iphw+LxaE/ciCC0u+nKsmGLVDB03x9kKT3fNnaWGEs+s9aHLHT9Y9dfNJmsU68iN
        CcR9XMxhZkPpuvAZ9bADXUYm5+D9dxQiq5k/RClu4UZ8ze9Y1pxr2TkNEd+Bd6jx20Cov0
        mBokEEOl3Gu6UpKc/cJo5Jamw5zqWbQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v6 2/6] KVM: arm64: Reject attempts to set invalid debug
 arch version
Message-ID: <ZLr2GXAgj5Y/fdJw@linux.dev>
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-3-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718164522.3498236-3-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 04:45:18PM +0000, Jing Zhang wrote:
> From: Oliver Upton <oliver.upton@linux.dev>
> 
> The debug architecture is mandatory in ARMv8, so KVM should not allow
> userspace to configure a vCPU with less than that. Of course, this isn't
> handled elegantly by the generic ID register plumbing, as the respective
> ID register fields have a nonzero starting value.
> 
> Add an explicit check for debug versions less than v8 of the
> architecture.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>

This patch needs to be broken up. You're doing a couple things:

 1) Forcing the behavior of the DebugVer field to be FTR_LOWER_SAFE, and
   adding the necessary check for a valid version

 2) Changing KVM's value for the field to expose up to Debugv8p8 to the
   guest.

The latter isn't described in the changelog at all, and worse yet the
ordering of the series is not bisectable. Changing the default value of
the field w/o allowing writes breaks migration.

So, please split this patch in two and consider stacking like so:

 - Change #1 above (field sanitization)

 - "KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1"

 - Change #2 above (advertise up to v8p8)

-- 
Thanks,
Oliver
