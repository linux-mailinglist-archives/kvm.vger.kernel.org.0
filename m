Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD5B5961D9
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 20:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbiHPSEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 14:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236847AbiHPSE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 14:04:29 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F6983079;
        Tue, 16 Aug 2022 11:04:25 -0700 (PDT)
Date:   Tue, 16 Aug 2022 18:04:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660673064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BaX6zUOOB6mOJWb9jOYpWn8KedE3Bw2epJs9deanoek=;
        b=Rudm4t1Ftj5lHfcxKtn0ZpHzQpjwhGziX0X92kJWRbepwloG2nQgfp4iFF+RiqxsUcORT7
        aeXdekvkMNzXnMnwJqchFZDWdqIDKCF9ODWZOFesjho2XKHKB2GDJ+LG6sMH+NrcgqGawD
        xk5XXBb+IMM19PES1vEHmf4XPedLdLA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+744e173caec2e1627ee0@syzkaller.appspotmail.com,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 3/3] KVM: Move coalesced MMIO initialization (back) into
 kvm_create_vm()
Message-ID: <YvvcHitVaf2EDAj0@google.com>
References: <20220816053937.2477106-1-seanjc@google.com>
 <20220816053937.2477106-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816053937.2477106-4-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022 at 05:39:37AM +0000, Sean Christopherson wrote:
> Invoke kvm_coalesced_mmio_init() from kvm_create_vm() now that allocating
> and initializing coalesced MMIO objects is separate from registering any
> associated devices.  Moving coalesced MMIO cleans up the last oddity
> where KVM does VM creation/initialization after kvm_create_vm(), and more
> importantly after kvm_arch_post_init_vm() is called and the VM is added
> to the global vm_list, i.e. after the VM is fully created as far as KVM
> is concerned.
> 
> Originally, kvm_coalesced_mmio_init() was called by kvm_create_vm(), but
> the original implementation was completely devoid of error handling.
> Commit 6ce5a090a9a0 ("KVM: coalesced_mmio: fix kvm_coalesced_mmio_init()'s
> error handling" fixed the various bugs, and in doing so rightly moved the
> call to after kvm_create_vm() because kvm_coalesced_mmio_init() also
> registered the coalesced MMIO device.  Commit 2b3c246a682c ("KVM: Make
> coalesced mmio use a device per zone") cleaned up that mess by having
> each zone register a separate device, i.e. moved device registration to
> its logical home in kvm_vm_ioctl_register_coalesced_mmio().  As a result,
> kvm_coalesced_mmio_init() is now a "pure" initialization helper and can
> be safely called from kvm_create_vm().
> 
> Opportunstically drop the #ifdef, KVM provides stubs for
> kvm_coalesced_mmio_{init,free}() when CONFIG_KVM_MMIO=n (arm).
							   ^^^
We have CONFIG_KVM_MMIO=y on arm64. Is it actually s390?

--
Thanks,
Oliver
