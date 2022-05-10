Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189E95211AC
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 12:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239489AbiEJKJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 06:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239476AbiEJKJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 06:09:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718611DB585;
        Tue, 10 May 2022 03:05:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2033AB81C25;
        Tue, 10 May 2022 10:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A90C385C6;
        Tue, 10 May 2022 10:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652177104;
        bh=MOo8nsiLJfqxrIWRjZulpDT7AErX6Kq8hkthnCTA5uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jy9sOx5IhAIDejPVKVF2+Bd/T0Py/5wx8+Po+Ecv0CR8BCrEvcq4NXAPEFAm802Ty
         8cRLHqys6IkXu4/djRBMoMkQByyOaFyW7LcnB56PnnqYCrewDk0t6vAPt0ilmAqrP9
         bNMqa/zDBvxt0x7TuFwji5mwsLRZamsLaTtuQqGt1cN7zj1bUdASCaiZelDL/z3VNI
         p6Pj8oL0tYCYRKw+uLngJYl8jq0JkOQqTFSh+zQdDgfqqYgwiiEl9uEIIUab3OLN22
         s6YnDdfn2O6lVXVwCwlbEjUqg8hcgBeNsxeTbQ0nkjXTKMo0wGcRneJRpqWIfMrr3l
         ymPB75JvnFwsw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1noMjm-00ACgV-4r; Tue, 10 May 2022 11:05:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
Cc:     will@kernel.org, tabba@google.com, qperret@google.com,
        james.morse@arm.com, alexandru.elisei@arm.com, kvm@vger.kernel.org,
        suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Minor pKVM cleanups
Date:   Tue, 10 May 2022 11:04:59 +0100
Message-Id: <165217709150.1535314.2127016424159834600.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220509162559.2387784-1-oupton@google.com>
References: <20220509162559.2387784-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, james.morse@arm.com, alexandru.elisei@arm.com, kvm@vger.kernel.org, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 9 May 2022 16:25:57 +0000, Oliver Upton wrote:
> I was reading through some of the pKVM stuff to get an idea of how it
> handles feature registers and spotted a few minor nits.
> 
> Applies cleanly to 5.18-rc5.
> 
> Oliver Upton (2):
>   KVM: arm64: pkvm: Drop unnecessary FP/SIMD trap handler
>   KVM: arm64: pkvm: Don't mask already zeroed FEAT_SVE
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: pkvm: Drop unnecessary FP/SIMD trap handler
      commit: 4d2e469e163ec79340b2f42c2a07838b5ff30686
[2/2] KVM: arm64: pkvm: Don't mask already zeroed FEAT_SVE
      commit: 249838b7660ac04a67bfb017364a7f01029370a0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


