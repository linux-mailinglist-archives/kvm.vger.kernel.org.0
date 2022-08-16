Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FC159617A
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 19:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbiHPRwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 13:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiHPRwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 13:52:45 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCC082763;
        Tue, 16 Aug 2022 10:52:44 -0700 (PDT)
Date:   Tue, 16 Aug 2022 17:52:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660672361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q7GzCHpVG7Wwapi8snUOsa+0evy9/qQD8vVEsMqe4rc=;
        b=PCK/uec1VTNPAPm9bkC4rVejRIVlzNGvrmwPsjkHtuej17Djedxh17ZNZfyvdfXVqZ3Otr
        /IfX3csoFElUvB7JtzWtftO5cEG6/MG0mGGo0f64UnRsv33tMdU5PIivlQ9EoCgswN1GBg
        paBKly6TCYhea1yh+DWZ3+z60qQ779U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+744e173caec2e1627ee0@syzkaller.appspotmail.com,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 1/3] KVM: Properly unwind VM creation if creating debugfs
 fails
Message-ID: <YvvZYEt6hiqOTFHV@google.com>
References: <20220816053937.2477106-1-seanjc@google.com>
 <20220816053937.2477106-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816053937.2477106-2-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022 at 05:39:35AM +0000, Sean Christopherson wrote:
> Properly unwind VM creation if kvm_create_vm_debugfs() fails.  A recent
> change to invoke kvm_create_vm_debug() in kvm_create_vm() was led astray

typo: kvm_create_vm_debugfs()

> by buggy try_get_module() handling adding by commit 5f6de5cbebee ("KVM:
> Prevent module exit until all VMs are freed").  The debugfs error path
> effectively inherits the bad error path of try_module_get(), e.g. KVM
> leaves the to-be-free VM on vm_list even though KVM appears to do the
> right thing by calling module_put() and falling through.
> 
> Opportunistically hoist kvm_create_vm_debugfs() above the call to
> kvm_arch_post_init_vm() so that the "post-init" arch hook is actually
> invoked after the VM is initialized (ignoring kvm_coalesced_mmio_init()
> for the moment).  x86 is the only non-nop implementation of the post-init
> hook, and it doesn't allocate/initialize any objects that are reachable
> via debugfs code (spawns a kthread worker for the NX huge page mitigation).
> 
> Leave the buggy try_get_module() alone for now, it will be fixed in a
> separate commit.
> 
> Fixes: b74ed7a68ec1 ("KVM: Actually create debugfs in kvm_create_vm()")
> Reported-by: syzbot+744e173caec2e1627ee0@syzkaller.appspotmail.com
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Fun times! Thanks for the fix Sean.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Best,
Oliver
