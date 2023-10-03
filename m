Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88597B71E7
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 21:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240878AbjJCTlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 15:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbjJCTlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 15:41:49 -0400
Received: from out-197.mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DDE93
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 12:41:46 -0700 (PDT)
Date:   Tue, 3 Oct 2023 19:41:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696362104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V79QyC7RXTrpI5ufqPj8jcBHkQ4sW7kYXdmUSPCuGu8=;
        b=YnsyQeZH8wtUt88iltpg5Zpl54Qzkn/eyC4ghPfONRytGTHhHRHEfbbp+Qe3BQT+EB5TZi
        bV8nfssi3YZ9lxHwt5hfiatPE1jQFjmaddKWKhpA1LOOsVPyZ5pcnT7wVRcPRlWF+fTcsR
        Mw7fn3YN+py6g6ObR8SKa0Ldj7FCcOM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Kristina Martsenko <kristina.martsenko@arm.com>
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Jing Zhang <jingzhangos@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v10 06/12] KVM: arm64: Allow userspace to change
 ID_AA64ISAR{0-2}_EL1
Message-ID: <ZRxudJGhSe8dOiDj@linux.dev>
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
 <20230920183310.1163034-7-oliver.upton@linux.dev>
 <80140d61-82e7-2795-409d-2cf6dc4993bc@arm.com>
 <ZQ3UaYTsZ1lVeShQ@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQ3UaYTsZ1lVeShQ@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 05:52:41PM +0000, Oliver Upton wrote:
> > Nit: it shouldn't be necessary to override BC anymore, as it was recently fixed
> > in the arm64 code:
> >   https://lore.kernel.org/linux-arm-kernel/20230912133429.2606875-1-kristina.martsenko@arm.com/
> 
> Perfect, looks like that patch should go in 6.6 too. Thanks for the fix!

Going to squash the following into the patch:

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c74920063287..179f82bd90af 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1225,10 +1225,6 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 			break;
 		}
 		break;
-	case SYS_ID_AA64ISAR2_EL1:
-		if (kvm_ftr.shift == ID_AA64ISAR2_EL1_BC_SHIFT)
-			kvm_ftr.type = FTR_LOWER_SAFE;
-		break;
 	case SYS_ID_DFR0_EL1:
 		if (kvm_ftr.shift == ID_DFR0_EL1_PerfMon_SHIFT)
 			kvm_ftr.type = FTR_LOWER_SAFE;

-- 
Thanks,
Oliver
