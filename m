Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA1462431A
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 14:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiKJNV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 08:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiKJNVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 08:21:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F766B399
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 05:21:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F009B821A2
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 13:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B72C433C1;
        Thu, 10 Nov 2022 13:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668086511;
        bh=vsKYJwz6b+8G9OYObnAUmHW9XZF2g9Jn8L3VpwTYoLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cw9PUhvxJOphnbK+yH0weDhtE/IJ9rrAJtFBNWJ2OCUmFFXZ7mxR5nYCBMRtxoVAl
         SATrNZktcM7DppSFMnU+61XPpGqM0/6Ty6QFUAwHtk8/t6Ibe4bCVN9olBTRvLCJtC
         6hhCZUHQT6gadLeUFZDtSjZXyg5wPWgq2/dh2mkrp7jE/98NOr5VXAOTQmfHgRzrVt
         Q/tT43TCO3pG/dC/0r5B99h6oQ8z8q6yVufZzrRqegOt7mR8erArTIwZjTvvARF2rq
         U8UKFHHDI+TkjNp84mBDHXNb33v96p5B3eiQ5IBw790HhW6MNyt4gXXas0CME2bqQs
         bEJKPNpBRBjbQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ot7V7-0059yG-00;
        Thu, 10 Nov 2022 13:21:49 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, Gavin Shan <gshan@redhat.com>
Cc:     catalin.marinas@arm.com, kvm@vger.kernel.org,
        ajones@ventanamicro.com, bgardon@google.com, shuah@kernel.org,
        shan.gavin@gmail.com, kvmarm@lists.cs.columbia.edu,
        dmatlack@google.com, andrew.jones@linux.dev, zhenyzha@redhat.com,
        pbonzini@redhat.com, will@kernel.org
Subject: Re: [PATCH v10 0/7] KVM: arm64: Enable ring-based dirty memory tracking
Date:   Thu, 10 Nov 2022 13:21:46 +0000
Message-Id: <166808649563.2653656.5582018167024205345.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110104914.31280-1-gshan@redhat.com>
References: <20221110104914.31280-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, gshan@redhat.com, catalin.marinas@arm.com, kvm@vger.kernel.org, ajones@ventanamicro.com, bgardon@google.com, shuah@kernel.org, shan.gavin@gmail.com, kvmarm@lists.cs.columbia.edu, dmatlack@google.com, andrew.jones@linux.dev, zhenyzha@redhat.com, pbonzini@redhat.com, will@kernel.org
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

On Thu, 10 Nov 2022 18:49:07 +0800, Gavin Shan wrote:
> This series enables the ring-based dirty memory tracking for ARM64.
> The feature has been available and enabled on x86 for a while. It
> is beneficial when the number of dirty pages is small in a checkpointing
> system or live migration scenario. More details can be found from
> fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking").
> 
> For PATCH[v9 3/7], Peter's ack-by is kept since the recent changes
> don't fundamentally break what he agreed. However, it would be nice
> for Peter to double confirm.
> 
> [...]

Applied to next, thanks!

[1/7] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
      commit: cf87ac739e488055a6046a410caa8f4da108948f
[2/7] KVM: Move declaration of kvm_cpu_dirty_log_size() to kvm_dirty_ring.h
      commit: e8a18565e59303ac12c626a161d72bd890bd2062
[3/7] KVM: Support dirty ring in conjunction with bitmap
      commit: 86bdf3ebcfe1ded055282536fecce13001874740
[4/7] KVM: arm64: Enable ring-based dirty memory tracking
      commit: 9cb1096f8590bc590326087bea65db932b53c3b5
[5/7] KVM: selftests: Use host page size to map ring buffer in dirty_log_test
      commit: a737f5ffb1e883e580730122be11c9eb832a7749
[6/7] KVM: selftests: Clear dirty ring states between two modes in dirty_log_test
      commit: 7167190ddb863bd061c0c6b61f4cec94184b40da
[7/7] KVM: selftests: Automate choosing dirty ring size in dirty_log_test
      commit: dc6df7d4d0633e65850d5372ae9f1234bcc6e26e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


