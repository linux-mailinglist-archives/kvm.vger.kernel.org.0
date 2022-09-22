Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6948C5E62B8
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 14:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbiIVMqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 08:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiIVMqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 08:46:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FBDE11D5
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 05:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AEBEB81DA1
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93B7C433B5;
        Thu, 22 Sep 2022 12:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663850759;
        bh=n4JSB6WoU8bXcdZr4LnmY2WYceFV6C8tipj3JIw+9EA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IqSJe9cYLUsBbeJp7cenTLNyQgGD3+Sw133H3p8hr305BYXY4bfgsn/4HkqU/FBy5
         oc+/0kemzKDIF9yzqBsBnb6qL1iCb7TYycu9BNz0zpt3/wMNEVYIjS36ghogt/8k7P
         932gNZpb137/CQ1//wvvnjjS2orENWsHl8o7YQFe+67w3TsDZaXvR3xaNJa8sbq+0u
         XooVFtvQ6ucHEFpGeOx5iym4SPvUrs9eX8G1TlCL368MLCP8ui0sKW6rRg/fkB9tig
         3zCzML9tcL+sZGPwqmXD+S3xCZim1a/Fh3LYFTa3HUdPDSn2sgg/gSkPr5p68NzhU5
         /9yQpjlEspEIA==
From:   Will Deacon <will@kernel.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, jean-philippe@linaro.org,
        kvm@vger.kernel.org, alexandru.elisei@arm.com, maz@kernel.org
Subject: Re: [kvmtool PATCH] net: Use vfork() instead of fork() for script execution
Date:   Thu, 22 Sep 2022 13:45:41 +0100
Message-Id: <166384963117.14685.11930673924564879612.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220809124816.2880990-1-suzuki.poulose@arm.com>
References: <20220809124816.2880990-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 9 Aug 2022 13:48:16 +0100, Suzuki K Poulose wrote:
> When a script is specified for a guest nic setup, we fork() and execl()s
> the script when it is time to execute the script. However this is not
> optimal, given we are running a VM. The fork() will trigger marking the
> entire page-table of the current process as CoW, which will trigger
> unmapping the entire stage2 page tables from the guest. Anyway, the
> child process will exec the script as soon as we fork(), making all
> these mm operations moot. Also, this operation could be problematic
> for confidential compute VMs, where it may be expensive (and sometimes
> destructive) to make changes to the stage2 page tables.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] net: Use vfork() instead of fork() for script execution
      https://git.kernel.org/will/kvmtool/c/9987a37cfc57

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
