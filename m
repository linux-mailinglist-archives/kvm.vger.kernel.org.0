Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C1B5FD874
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 13:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiJMLfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 07:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiJMLfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 07:35:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968E39A9D7;
        Thu, 13 Oct 2022 04:35:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3343A61787;
        Thu, 13 Oct 2022 11:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748D4C433C1;
        Thu, 13 Oct 2022 11:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665660937;
        bh=TycQmVJ6jXUOyk9ucIX1dRffGw6LVYgXTvtb6cNlgZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRinFqH1c2Qd0p3WjDwRlXc2NX091fbWECJol5jdbNJoBs0WmVFStREnwn+3c39eJ
         5osZwwPej6SepvpGUt7GUMq7/SGLOa3SRNATok21IfM3Bt7fO4oCC38R3t0/6oYlYo
         DPXH8J9JGSwl2hndm2hQTpyEeHFHnJWoVIoVx3pRbAPy8CoXFn1qpTfdQrVMyjGn5l
         6ryyCoGQh+xnSJBlpzmWi5LQN+kD5vm41qBqpACJCeJdxkKFe8jOfT6fwOgC6EHEFx
         cxTaplsoq906pTwl5EZOpOFJL+tns4VFtxRXg98/1YSn4E9paguhUMhn/KZQEAEFHa
         qwSQVkLgqHg8A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oiwUx-00GI0Y-7d;
        Thu, 13 Oct 2022 12:35:35 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, Gavin Shan <gshan@redhat.com>
Cc:     oliver.upton@linux.dev, linux-kernel@vger.kernel.org,
        ajones@ventanamicro.com, kvm@vger.kernel.org, seanjc@google.com,
        kvmarm@lists.cs.columbia.edu, dmatlack@google.com,
        pbonzini@redhat.com, venkateshs@chromium.org, peterx@redhat.com,
        shan.gavin@gmail.com, shuah@kernel.org
Subject: Re: [PATCH] KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test
Date:   Thu, 13 Oct 2022 12:35:31 +0100
Message-Id: <166566092380.1304242.1787049894105591539.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221013063020.201856-1-gshan@redhat.com>
References: <20221013063020.201856-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, gshan@redhat.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, ajones@ventanamicro.com, kvm@vger.kernel.org, seanjc@google.com, kvmarm@lists.cs.columbia.edu, dmatlack@google.com, pbonzini@redhat.com, venkateshs@chromium.org, peterx@redhat.com, shan.gavin@gmail.com, shuah@kernel.org
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

On Thu, 13 Oct 2022 14:30:20 +0800, Gavin Shan wrote:
> It's required by vm_userspace_mem_region_add() that memory size
> should be aligned to host page size. However, one guest page is
> provided by memslot_modification_stress_test. It triggers failure
> in the scenario of 64KB-page-size-host and 4KB-page-size-guest,
> as the following messages indicate.
> 
>  # ./memslot_modification_stress_test
>  Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
>  guest physical test memory: [0xffbfff0000, 0xffffff0000)
>  Finished creating vCPUs
>  Started all vCPUs
>  ==== Test Assertion Failure ====
>    lib/kvm_util.c:824: vm_adjust_num_guest_pages(vm->mode, npages) == npages
>    pid=5712 tid=5712 errno=0 - Success
>       1	0x0000000000404eeb: vm_userspace_mem_region_add at kvm_util.c:822
>       2	0x0000000000401a5b: add_remove_memslot at memslot_modification_stress_test.c:82
>       3	 (inlined by) run_test at memslot_modification_stress_test.c:110
>       4	0x0000000000402417: for_each_guest_mode at guest_modes.c:100
>       5	0x00000000004016a7: main at memslot_modification_stress_test.c:187
>       6	0x0000ffffb8cd4383: ?? ??:0
>       7	0x0000000000401827: _start at :?
>    Number of guest pages is not compatible with the host. Try npages=16
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test
      commit: 05c2224d4b049406b0545a10be05280ff4b8ba0a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


