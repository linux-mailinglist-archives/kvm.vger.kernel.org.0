Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BAD624A0C
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 20:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiKJTAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 14:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKJTAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 14:00:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D32931EDF;
        Thu, 10 Nov 2022 11:00:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BA0E61E0D;
        Thu, 10 Nov 2022 19:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8018BC433D6;
        Thu, 10 Nov 2022 19:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668106844;
        bh=Xo5ZXPpv2Kz2QQAGSoMKDNSlgsw71TmAienD13Km1Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bceoK/IiO31N0l4xqOqhszwwzTzzH79tlkJG/Wjq20uTXVJmWDb17Qc3kkVsqqvBC
         VfCLQ5T+w9YOhH/No2W6ja8zCGx34roiiXIvIVVDVr/jM4py3ZdOJoKukGO3K+Tf0O
         yD9c6fzXALHfvsW8ExvyuLLxNqnLxI8Ds9HONhU8cgWn5WY4uuXNXDC30G2/xPDQ8Y
         YkImyr8Pig9+utm8AwGuGvc1fhYktn4XsSN2DRUK8zuLXmq5vLhUb93OWhr4+XB7bF
         6yZpSC0s4YZ7clMuSRyMHJ5ygDpiyfNjCjQWK8JsTQt//J/cuzMt4BB8jIlxAgkhIg
         nRwZpUj7PxKaA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1otCn4-005EHi-3v;
        Thu, 10 Nov 2022 19:00:42 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, Gavin Shan <gshan@redhat.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, oliver.upton@linux.dev,
        linux-kernel@vger.kernel.org, zhenyzha@redhat.com,
        peterx@redhat.com, kvmarm@lists.cs.columbia.edu,
        ricarkol@google.com, mail@maciej.szmigiero.name,
        shan.gavin@gmail.com, shuah@kernel.org, seanjc@google.com,
        ajones@ventanamicro.com
Subject: Re: [PATCH v3 0/6] KVM: selftests: memslot_perf_test: aarch64 cleanup/fixes
Date:   Thu, 10 Nov 2022 19:00:38 +0000
Message-Id: <166810681799.3361246.8104966072193072364.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020071209.559062-1-gshan@redhat.com>
References: <20221020071209.559062-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, gshan@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, zhenyzha@redhat.com, peterx@redhat.com, kvmarm@lists.cs.columbia.edu, ricarkol@google.com, mail@maciej.szmigiero.name, shan.gavin@gmail.com, shuah@kernel.org, seanjc@google.com, ajones@ventanamicro.com
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

On Thu, 20 Oct 2022 15:12:03 +0800, Gavin Shan wrote:
> kvm/selftests/memslots_perf_test doesn't work with 64KB-page-size-host
> and 4KB-page-size-guest on aarch64. In the implementation, the host and
> guest page size have been hardcoded to 4KB. It's ovbiously not working
> on aarch64 which supports 4KB, 16KB, 64KB individually on host and guest.
> 
> This series tries to fix it. After the series is applied, the test runs
> successfully with 64KB-page-size-host and 4KB-page-size-guest.
> 
> [...]

Applied to next, thanks!

[1/6] KVM: selftests: memslot_perf_test: Use data->nslots in prepare_vm()
      commit: 3bfadb2325891d122771ce534336af531e93d7b2
[2/6] KVM: selftests: memslot_perf_test: Consolidate loop conditions in prepare_vm()
      commit: 2aae5e6795e1407334bb849f96f11c9051b959e2
[3/6] KVM: selftests: memslot_perf_test: Probe memory slots for once
      commit: 34396437b11f904fc61b272e3974f4c92868451b
[4/6] KVM: selftests: memslot_perf_test: Support variable guest page size
      commit: 8675c6f226986ddb67752be22279a0e2385b197e
[5/6] KVM: selftests: memslot_perf_test: Consolidate memory
      commit: 88a64e65484ef6b5cb09fe545d0dd00c950a1131
[6/6] KVM: selftests: memslot_perf_test: Report optimal memory slots
      commit: a69170c65acdf430e24fc1b6174dcc3aa501fe2f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


