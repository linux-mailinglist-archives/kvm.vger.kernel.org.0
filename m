Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943F55EF2E1
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 11:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbiI2J6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 05:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235255AbiI2J6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 05:58:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81BD132FE4
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 02:58:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5327660B3E
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 09:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF62C433D6;
        Thu, 29 Sep 2022 09:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664445524;
        bh=eSMwBKa9imsr6TaLmSDnLEatSh53XGbj9jMl67t/9vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IY4IgaY4MKlkwWYDiOCrp8cVtrr18gRGx7Yky3IbBs+4xmxgOrZk/IsBVd8XNxld9
         Q3AcpGyfvasdn8ZiCdOTbrxjOLMlP7vidyO3z+iQkrnOiqAocBlGTMFXfZUMnnGr8t
         u/TatetA3VYzb3CtEAIQ5ky9fiESUO57t0P8zmgtk3w8pQqvCOwPcWi6E0uEe0tp9G
         9fb9jPSTR4OU26+mHjvHckds8bfakaH1+4CaVR0IaVbRWrQn0j9OY9N3ZyornVOoPs
         XHo5mzLfY0Jwyzm580m19MTyuU5O+e50RQztuApkiCz2pJ6L7ZhQvGwhqzxCGgOsod
         vSlqx3r5soA2Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1odqJW-00DVUy-Ag;
        Thu, 29 Sep 2022 10:58:42 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     catalin.marinas@arm.com, will@kernel.org, dmatlack@google.com,
        zhenyzha@redhat.com, shuah@kernel.org, pbonzini@redhat.com,
        shan.gavin@gmail.com, bgardon@google.com, andrew.jones@linux.dev
Subject: Re: [PATCH v2 0/6] KVM: Fix dirty-ring ordering on weakly ordered architectures
Date:   Thu, 29 Sep 2022 10:58:39 +0100
Message-Id: <166444538478.3798115.5401520250620155536.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926145120.27974-1-maz@kernel.org>
References: <20220926145120.27974-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, will@kernel.org, dmatlack@google.com, zhenyzha@redhat.com, shuah@kernel.org, pbonzini@redhat.com, shan.gavin@gmail.com, bgardon@google.com, andrew.jones@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Sep 2022 15:51:14 +0100, Marc Zyngier wrote:
> [Same distribution list as Gavin's dirty-ring on arm64 series]
> 
> This is an update on the initial series posted as [0].
> 
> As Gavin started posting patches enabling the dirty-ring infrastructure
> on arm64 [1], it quickly became apparent that the API was never intended
> to work on relaxed memory ordering architectures (owing to its x86
> origins).
> 
> [...]

Applied to next, thanks!

[1/6] KVM: Use acquire/release semantics when accessing dirty ring GFN state
      commit: 8929bc9659640f35dd2ef8373263cbd885b4a072
[2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option
      commit: 17601bfed909fa080fcfd227b57da2bd4dc2d2a6
[3/6] KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL
      commit: fc0693d4e5afe3c110503c3afa9f60600f9e964b
[4/6] KVM: Document weakly ordered architecture requirements for dirty ring
      commit: 671c8c7f9f2349d8b2176ad810f1406794011f63
[5/6] KVM: selftests: dirty-log: Upgrade flag accesses to acquire/release semantics
      commit: 4eb6486cb43c93382c27a2659ba978c660e98498
[6/6] KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ACQ_REL if available
      commit: 4b3402f1f4d9860301d6d5cd7aff3b67f678d577

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


