Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80975F9B42
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 10:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiJJIn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 04:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiJJInx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 04:43:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE485F990;
        Mon, 10 Oct 2022 01:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AC0CCCE09CC;
        Mon, 10 Oct 2022 08:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1483C433D6;
        Mon, 10 Oct 2022 08:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665391428;
        bh=TpTFBaVpcpiipRfNA/wPYZumGbWrDPFoKZ4zg95sX2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bLD4p6KyiC8H+vTEJd2NqrviY1Lf+ftSXPWJj3Emh0FLcCLGnNyqi2PzGNhqjfdFw
         eumzzstin/gMueyI62tUqsBu/zOrNiZtrvAfV5JyiU44V3uvhph1FZDWRLqNvh9Xot
         WRqNcBls1LRbhtiiv1rpQeJNuiH9+HLtUZjwnaeERiURJOLDqOz/lOsSAyWWpSF5mI
         1xW/g8kplrW/fyrptykPq/KiRoBAFPXvpJblpXoeFsHSfAoed0/OvlZi5KVVm+HSwI
         OXN2W9Q/EGkX7gDj1H8WWsFVW4P8sJ7uYg9tJ6eDtYMs6kBS3Mmy3A/iR9SM6B4Bli
         9U3qlAcoKToqA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ohoO2-00FYgY-GI;
        Mon, 10 Oct 2022 09:43:46 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
        Zenghui Yu <yuzenghui@huawei.com>
Cc:     alexandru.elisei@arm.com, seanjc@google.com,
        oliver.upton@linux.dev, pbonzini@redhat.com, james.morse@arm.com,
        andrew.jones@linux.dev, wanghaibin.wang@huawei.com,
        suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM: arm64: selftests: Fix multiple versions of GIC creation
Date:   Mon, 10 Oct 2022 09:43:43 +0100
Message-Id: <166539141624.256352.10322774978905917521.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221009033131.365-1-yuzenghui@huawei.com>
References: <20221009033131.365-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, seanjc@google.com, oliver.upton@linux.dev, pbonzini@redhat.com, james.morse@arm.com, andrew.jones@linux.dev, wanghaibin.wang@huawei.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 9 Oct 2022 11:31:31 +0800, Zenghui Yu wrote:
> Commit 98f94ce42ac6 ("KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to
> separate helper") wrongly converted a "real" GIC device creation to
> __kvm_test_create_device() and caused the test failure on my D05 (which
> supports v2 emulation). Fix it.

Applied to fixes, thanks!

[1/1] KVM: arm64: selftests: Fix multiple versions of GIC creation
      commit: 8a6ffcbe26fd14d58075dcf3cbdf1b5b69b20402

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


