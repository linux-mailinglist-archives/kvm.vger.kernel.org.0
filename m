Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4579C76A06A
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 20:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbjGaSaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 14:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjGaSaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 14:30:00 -0400
Received: from out-103.mta1.migadu.com (out-103.mta1.migadu.com [IPv6:2001:41d0:203:375::67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A8D10E4
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 11:29:59 -0700 (PDT)
Date:   Mon, 31 Jul 2023 18:29:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690828198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NeX+BTQhkz1hkGfxaYW5m3HOmH/qPCvTm2ZC5kk5axY=;
        b=PXJ5ihB3HjR3iQoLymxlbHr5/RsJ1YRGvzpt728eEEVabWE2GREe+S2Q/QDowGAi0Ipe+2
        wZRo8XZKrJyJVcmb2D3dnRsmiuF2xDywb+C01K/C9DkVJ7nQ6SLL779lzEUs1VVshVQIkD
        1QY+kFgAs1spyll4MAzb5yPL6UmopxQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: x86/tsc: Don't sync user changes to TSC with
 KVM-initiated change
Message-ID: <ZMf9ovBFpGNEOG3c@linux.dev>
References: <20230731080758.29482-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731080758.29482-1-likexu@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 04:07:58PM +0800, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Add kvm->arch.user_changed_tsc to avoid synchronizing user changes to
> the TSC with the KVM-initiated change in kvm_arch_vcpu_postcreate() by
> conditioning this mess on userspace having written the TSC at least
> once already.
> 
> Here lies UAPI baggage: user-initiated TSC write with a small delta
> (1 second) of virtual cycle time against real time is interpreted as an
> attempt to synchronize the CPU. In such a scenario, the vcpu's tsc_offset
> is not configured as expected, resulting in significant guest service
> response latency, which is observed in our production environment.

The changelog reads really weird, because it is taken out of context
when it isn't a comment over the affected code. Furthermore, 'our
production environment' is a complete black box to the rest of the
community, it would be helpful spelling out exactly what the use case
is.

Suggested changelog:

  KVM interprets writes to the TSC with values within 1 second of each
  other as an attempt to synchronize the TSC for all vCPUs in the VM,
  and uses a common offset for all vCPUs in a VM. For brevity's sake
  let's just ignore what happens on systems with an unstable TSC.

  While this may seem odd, it is imperative for VM save/restore, as VMMs
  such as QEMU have long resorted to saving the TSCs (by value) from all
  vCPUs in the VM at approximately the same time. Of course, it is
  impossible to synchronize all the vCPU ioctls to capture the exact
  instant in time, hence KVM fudges it a bit on the restore side.

  This has been useful for the 'typical' VM lifecycle, where in all
  likelihood the VM goes through save/restore a considerable amount of
  time after VM creation. Nonetheless, there are some use cases that
  need to restore a VM snapshot that was created very shortly after boot
  (<1 second). Unfortunately the TSC sync code makes no distinction
  between kernel and user-initiated writes, which leads to the target VM
  synchronizing on the TSC offset from creation instead of the
  user-intended value.

  Avoid synchronizing user-initiated changes to the guest TSC with the
  KVM initiated change in kvm_arch_vcpu_postcreate() by conditioning the
  logic on userspace having written the TSC at least once.

I'll also note that the whole value-based TSC sync scheme is in
desperate need of testing.

-- 
Thanks,
Oliver
