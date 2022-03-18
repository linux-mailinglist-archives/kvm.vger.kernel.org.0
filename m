Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352664DDB3E
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 15:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbiCROIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 10:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237051AbiCROIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 10:08:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B1CFF2
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 07:07:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1F49B823E5
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 14:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953BEC340E8;
        Fri, 18 Mar 2022 14:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647612445;
        bh=C3OQt/00TuxMRT85jYxLnQpTSKyb+BvUMIF15Qmze5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZOI6CxP9H5taRrXVzzRPxfzZWcCotG7UiXtDahIEn8LzrU8lw9ulCnGuKH3ftYFT
         bzS7pnDJxxw9cPt9uSmta2JYM21Cs0CPkrvhOcLT0j414yDVHGI/KFM5A8UttMpnnJ
         +xdaylg85g/H0r6rtlt0hYZ71rIcFfEtcxcnRn9vGWJPxWdxwsWpEp1LqJP9DIGdq5
         YlEWcC5OzOUvACmsn6fw99UhLx1CjThJ1ElLquOQVOA46lm0pi3VS9uDOmQWW+WIvw
         56UhSPk1QcnCtsN/Nl4UNv2RvZJlMVEoMn6XEHS2DzH9V++Wdy1uGzfh9SkrDrKhCQ
         9n8WMpBLURQJA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nVDGF-00FSSq-2K; Fri, 18 Mar 2022 14:07:23 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
Cc:     wanpengli@tencent.com, jmattson@google.com, pbonzini@redhat.com,
        vkuznets@redhat.com, pshier@google.com, atishp@atishpatra.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, joro@8bytes.org
Subject: Re: (subset) [PATCH v4 00/15] KVM: arm64: PSCI SYSTEM_SUSPEND + SYSTEM_RESET2 bugfix
Date:   Fri, 18 Mar 2022 14:07:20 +0000
Message-Id: <164761240231.2295955.10089198303947734980.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
References: <20220311174001.605719-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com, wanpengli@tencent.com, jmattson@google.com, pbonzini@redhat.com, vkuznets@redhat.com, pshier@google.com, atishp@atishpatra.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, joro@8bytes.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Mar 2022 17:39:46 +0000, Oliver Upton wrote:
> **NOTE** Patch 2 is a bugfix for commit d43583b890e7 ("KVM: arm64:
> Expose PSCI SYSTEM_RESET2 call to the guest") on kvmarm/next. Without
> this patch, it is possible for the guest to call
> PSCI_1_1_FN64_SYSTEM_RESET2 from AArch32.
> 
> The PSCI v1.0 specification describes a call, SYSTEM_SUSPEND, which
> allows software to request that the system be placed into the lowest
> possible power state and await an IMPLEMENTATION DEFINED wakeup event.
> This call is optional in v1.0 and v1.1. KVM does not currently support
> this optional call.
> 
> [...]

Applied to next, thanks!

[01/15] KVM: arm64: Generalise VM features into a set of flags
        commit: 06394531b425794dc56f3d525b7994d25b8072f7

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


