Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C41B4E2947
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 15:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348746AbiCUODu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 10:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349280AbiCUODf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 10:03:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8C517B0E4
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 07:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1356B816C8
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 14:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F303C340F2;
        Mon, 21 Mar 2022 14:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647871244;
        bh=z+fIyMiBBd9j4jMIRyKXadB39SI8/RcOLqnYSNbAIGc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T3q5wPbp1TfmqF7yEQSWdjhu2naNVrifB/ledyvPrgszgZWORR1+s/z2BNdiP3V/c
         zL6TTcaywFbKxM4xwld5fwGAM4KvbcXTOzjjIWTuv/spEiHo1web87LIwKtqX+tBmZ
         AAIeIHGK0X1B8rQW8UXgw/u4q7imvYZrEE88zi/xOLJfguo7zNQC7jIa5DHXmB6sRJ
         WFcz2XwoB2FzOIzlmstmr1AG2odE8z4Jv/r191ulrAsi5dwEaZnCuHasx0CXCcUMX4
         sGjP+64noaNkDBHyLHNjuHH+yJTOy3jlyeHNXX8I8TmUVzAjKNL6MO1r+//amR2IUG
         1h1KpNiSmn+NQ==
Date:   Mon, 21 Mar 2022 14:00:39 +0000
From:   Will Deacon <will@kernel.org>
To:     Sebastian Ene <sebastianene@google.com>
Cc:     kvm@vger.kernel.org, qperret@google.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool v11 0/3] aarch64: Add stolen time support
Message-ID: <20220321140039.GA11036@willie-the-truck>
References: <20220313161949.3565171-1-sebastianene@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220313161949.3565171-1-sebastianene@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sebastian,

On Sun, Mar 13, 2022 at 04:19:47PM +0000, Sebastian Ene wrote:
> This series adds support for stolen time functionality.
> 
> Patch #1 moves the vCPU structure initialisation before the target->init()
> call to allow early access to the kvm structure from the vCPU
> during target->init().
> 
> Patch #2 modifies the memory layout in arm-common/kvm-arch.h and adds a
> new MMIO device PVTIME after the RTC region. A new flag is added in
> kvm-config.h that will be used to control [enable/disable] the pvtime
> functionality. Stolen time is enabled by default when the host
> supports KVM_CAP_STEAL_TIME.
> 
> Patch #3 adds a new command line argument to disable the stolen time
> functionality(by default is enabled).
> 
> Changelog since v10:
>  - set the return value to -errno on failed exit path from
>    'kvm_cpu__setup_pvtime' 

Thanks. I've applied this, but I think it would be worth a patch on top
to make the new '--no-pvtime' option part of the 'arch-specific' options
rather than a generic option given that this is only implemented for
arm64 at the moment.

Please could you send an extra patch to move the option? You can look at
how we deal with the other arm64-specific options in
arm/aarch64/include/kvm/kvm-config-arch.h for inspiration.

Cheers,

Will
