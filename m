Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39A24D035C
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 16:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243970AbiCGPt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 10:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243965AbiCGPtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 10:49:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9E14E394
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 07:48:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 156FF614A8
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 15:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EFFC340E9;
        Mon,  7 Mar 2022 15:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646668103;
        bh=rwwzfeJQx2Fg241T8gSzdrTLHq4FAEtTT9qgzpxZuYs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qj/5v6HUgig2upI/ZQVz9M4+6nTGaOt373JQpKOK2F7Fts+HHlvYnteq6vGPsfR17
         oF+1sUPeVUe0/R0OUgUIxXiIv1QIYbZaPtztfyDh9kfXqcKpb0IDIfHIKUHb2KlvI9
         sDenSBWvQi5e8cWjL2U6HjuxJwUTfK7FRILOLo90w8ZxFHDpc5K7m4z2QqNikfyN5r
         0+qgU6gtYUfh7fR0G51vEfPpSLc2Qm6ajNhmDRUhGqWsSHUzphHsDSwnc6zdutWjTz
         AxUdWSNbs0mGxfrOlZ4sQ/PMFC/lDvxfC+Qql3MF5X+WLdd4OAi0QnR2xcrCdSb8kE
         MMDeDoZLTYNFg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nRFat-00CpXt-Kq; Mon, 07 Mar 2022 15:48:20 +0000
MIME-Version: 1.0
Date:   Mon, 07 Mar 2022 15:48:19 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 43/64] KVM: arm64: nv: arch_timer: Support hyp timer
 emulation
In-Reply-To: <YiYcLIhdo5fQFbSA@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-44-maz@kernel.org>
 <YiYcLIhdo5fQFbSA@monolith.localdoman>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c084f234eff61b0ab8da5716879745e2@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-03-07 14:52, Alexandru Elisei wrote:
> Hi,
> 
> I was under the impression that KVM's nested virtualization doesn't 
> support
> AArch32 in the guest, why is the subject about hyp mode aarch32 timers?

Where did you see *ANY* mention of AArch32?

Or is that a very roundabout way to object to the 'hyp' name?
If that's the case, just apply a mental 's/hyp/el2/' substitution.

         M.
-- 
Jazz is not dead. It just smells funny...
