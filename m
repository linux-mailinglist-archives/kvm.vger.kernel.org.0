Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D497B42E7
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 20:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbjI3SNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Sep 2023 14:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjI3SNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Sep 2023 14:13:02 -0400
Received: from out-208.mta0.migadu.com (out-208.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D54D3
        for <kvm@vger.kernel.org>; Sat, 30 Sep 2023 11:12:59 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696097577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NobuwGoK/IfZYCAUHu+l3Ra9aadEGrlb36GWP9YgCKg=;
        b=eeTMEX7jx4g/oM9E4pE2PlyJUQHQkWgZ7FBfm42L2iH5P9365yWo3i+3WP9lL3A0fekqJI
        T0jftYIUzrw9zZLaMHhuVxhqg1oRtACaDzeA/pWJ2Flp1N/AD0EULy7xiQJtV50RoZlOB4
        URdfRNjH0XKRse9u9QF/WwmI/3u2V6w=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org, Vipin Sharma <vipinsh@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH] KVM: arm64: Always invalidate TLB for stage-2 permission faults
Date:   Sat, 30 Sep 2023 18:12:42 +0000
Message-ID: <169609738440.1610883.10121904970438248127.b4-ty@linux.dev>
In-Reply-To: <20230922223229.1608155-1-oliver.upton@linux.dev>
References: <20230922223229.1608155-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,TO_EQ_FM_DIRECT_MX autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Sep 2023 22:32:29 +0000, Oliver Upton wrote:
> It is possible for multiple vCPUs to fault on the same IPA and attempt
> to resolve the fault. One of the page table walks will actually update
> the PTE and the rest will return -EAGAIN per our race detection scheme.
> KVM elides the TLB invalidation on the racing threads as the return
> value is nonzero.
> 
> Before commit a12ab1378a88 ("KVM: arm64: Use local TLBI on permission
> relaxation") KVM always used broadcast TLB invalidations when handling
> permission faults, which had the convenient property of making the
> stage-2 updates visible to all CPUs in the system. However now we do a
> local invalidation, and TLBI elision leads to vCPUs getting stuck in a
> permission fault loop. Remember that the architecture permits the TLB to
> cache translations that precipitate a permission fault.
> 
> [...]

Applied to kvmarm/next, with the fixes and stable tag dropped.

[1/1] KVM: arm64: Always invalidate TLB for stage-2 permission faults
      https://git.kernel.org/kvmarm/kvmarm/c/5a6e594fc607

--
Best,
Oliver
