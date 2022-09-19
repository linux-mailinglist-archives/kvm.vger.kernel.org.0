Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECAD55BC9CA
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 12:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiISKst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 06:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiISKsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 06:48:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDEC2BB17
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 03:38:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4815AB807E6
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 10:38:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C13FC433C1;
        Mon, 19 Sep 2022 10:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663583902;
        bh=j39Tp6VEuKTc+/AErRW9+NoKA7wEq5qplZoA/aOI984=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slWmdQiMz1SGG8Du5GM9EVagfY+ZyQK6DBE6JAeeZt6F5bM9WjFGBbnn+iGubwDS6
         X+9uqOVMyvZYNdsXEGKkZTS486moQ0safhy2x67peNtApnpf+i5o7my3/Y3t2/3vKE
         GDoxXcRtwQRIGwBzzUGk6x1eStGV8g7SmzpFJvtjThgvDUx2aI/DzyqZqcA4DISd2v
         ++jE5lRiUbLf91O2V9oAJXgCf4HcOE3JqDM2ojrxOs2HI7WfRw2cZfRIo1zEu7fJVR
         KECLSvllYvbFsMmHKBoSJMSDuoAR+1932VEiYxvnd6QomW48DBF4I79KCjjQ8jPJp1
         Mdl9rgUfFKDyA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oaEAO-00B4ku-48;
        Mon, 19 Sep 2022 11:38:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc:     seanjc@google.com, pbonzini@redhat.com, rananta@google.com,
        dmatlack@google.com, bgardon@google.com, reijiw@google.com,
        axelrasmussen@google.com, oupton@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH v6 00/13] KVM: selftests: Add aarch64/page_fault_test
Date:   Mon, 19 Sep 2022 11:38:17 +0100
Message-Id: <166358370892.2832387.8903539023908338224.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220906180930.230218-1-ricarkol@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, ricarkol@google.com, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev, seanjc@google.com, pbonzini@redhat.com, rananta@google.com, dmatlack@google.com, bgardon@google.com, reijiw@google.com, axelrasmussen@google.com, oupton@google.com, alexandru.elisei@arm.com, eric.auger@redhat.com
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

On Tue, 6 Sep 2022 18:09:17 +0000, Ricardo Koller wrote:
> This series adds a new aarch64 selftest for testing stage 2 fault handling for
> various combinations of guest accesses (e.g., write, S1PTW), backing sources
> (e.g., anon), and types of faults (e.g., read on hugetlbfs with a hole, write
> on a readonly memslot). Each test tries a different combination and then checks
> that the access results in the right behavior (e.g., uffd faults with the right
> address and write/read flag). Some interesting combinations are:
> 
> [...]

Given how long this has been around, I've picked this series up, applying
Oliver's fixes in the process. Any additional fixes will be added on top.

Applied to next, thanks!

[01/13] KVM: selftests: Add a userfaultfd library
        commit: b9e9f0060d69ace412846b3dda318189e74d80ea
[02/13] KVM: selftests: aarch64: Add virt_get_pte_hva() library function
        commit: b3e02786e384d83637fc29dca2af9604a6314e62
[03/13] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
        commit: 77c071a5376c9fdc0c510138d081af5e6ead754d
[04/13] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h macros
        commit: a68c2b6545af95729eb57fe39f173557d1f22649
[05/13] tools: Copy bitfield.h from the kernel sources
        commit: 8998ed5834af0a9cc3de8d5bd485576c654620fc
[06/13] KVM: selftests: Stash backing_src_type in struct userspace_mem_region
        commit: 20a8d07c0828592d72c756c98f2708e905bfabd3
[07/13] KVM: selftests: Change ____vm_create() to take struct kvm_vm_mem_params
        commit: cb7f9c457b94b2ad71eaf9621a9e7f3e9c3832db
[08/13] KVM: selftests: Use the right memslot for code, page-tables, and data allocations
        commit: 72ad71ddb5fae4dc26a2fa7e885213598baab9ad
[09/13] KVM: selftests: aarch64: Add aarch64/page_fault_test
        commit: fa7b86adf85be5de36a797df7b1509542af1f119
[10/13] KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
        commit: 596fcc0f6888241b0b2f02577a2b608f274b299d
[11/13] KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
        commit: 0740d435146f69be9950df5dd45a31fbaec943ba
[12/13] KVM: selftests: aarch64: Add readonly memslot tests into page_fault_test
        commit: a9246644455d51faa4063749bb17aa7e060adc70
[13/13] KVM: selftests: aarch64: Add mix of tests into page_fault_test
        commit: 383d48a1442ca477732ea77d6231b3cc73b9d7f8

Cheers,

	M.
