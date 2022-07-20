Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD8D57B3B5
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 11:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbiGTJX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 05:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiGTJX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 05:23:28 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F27C474D3
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 02:23:26 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658309004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DXu1ttuM/4nB6h+hG9M8DKITaTQ3r2iVyd84bbxFhoY=;
        b=CVuZtFXIlocdzLsPkedUaYL2rM8D/PxCoN7bDOBnQxm90DDc8RgieqLE1DOHYk544qtN9O
        fy2m0NX/6MMarHsRfMcwJjm9aiHlpK03uNqQ3j98iRkfAK2OjCtjtuOn0pkIaT16rRw6Ng
        Ncz6Oy1Gmf2wSsUBgFXOY+mz8W5E/yc=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>
Subject: [PATCH v3 0/6] KVM: Clean up debugfs init/destroy
Date:   Wed, 20 Jul 2022 09:22:46 +0000
Message-Id: <20220720092259.3491733-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Oliver Upton <oupton@google.com>

The way that KVM handles debugfs init/destroy is somewhat sloppy. Even
though debugfs is stood up after kvm_create_vm(), it is torn down from
kvm_destroy_vm(). There exists a window where we need to tear down a VM
before debugfs is created, requiring delicate handling.

This series cleans up the debugfs lifecycle by fully tying it to the
VM's init/destroy pattern.

First two patches hoist some unrelated stats initialization to a more
appropriate place for kvm and kvm_vcpu.

The next 3 patches are the meat of the series, changing around the
initialization order to get an FD early and wiring in debugfs
initialization to kvm_create_vm().

Lastly, patch 6 is essentially a revert of Sean's fix [1] for a NULL deref
in debugfs, though I stopped short of an outright revert since that one
went to stable and is still entirely correct.

"Works on my machine", and with luck it will on yours too.

[1] 5c697c367a66 ("KVM: Initialize debugfs_dentry when a VM is created to avoid NULL deref")

v1: http://lore.kernel.org/r/20220415201542.1496582-1-oupton@google.com
v2: https://lore.kernel.org/kvm/20220518175811.2758661-1-oupton@google.com

v1 -> v2:
 - Don't conflate debugfs+stats. Initialize stats_id outside of the
   context of debugfs (Sean)
 - Pass around the FD as a string to avoid subsequent KVM changes
   inappropriately using the FD (Sean)

v2 -> v3:
 - Spare readers from needing to refer to the title of a commit (Sean)
 - Crack fd stringization and move of kvm_create_vm_debugfs() into two
   patches (Sean)
 - Fix a bug that crops up in the middle of the series. Failed to pass
   the fd through to kvm_create_vm_debugfs()

Oliver Upton (6):
  KVM: Shove vm stats_id init into kvm_create_vm()
  KVM: Shove vcpu stats_id init into kvm_vcpu_init()
  KVM: Get an fd before creating the VM
  KVM: Pass the name of the VM fd to kvm_create_vm_debugfs()
  KVM: Actually create debugfs in kvm_create_vm()
  KVM: Hoist debugfs_dentry init to kvm_create_vm_debugfs() (again)

 virt/kvm/kvm_main.c | 91 +++++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 41 deletions(-)


base-commit: 8031d87aa9953ddeb047a5356ebd0b240c30f233
-- 
2.37.0.170.g444d1eabd0-goog

