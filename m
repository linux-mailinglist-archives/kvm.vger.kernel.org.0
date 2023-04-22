Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98016EB933
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 14:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjDVMyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 08:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjDVMyK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 08:54:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B341713
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 05:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682168002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o3yJS9XUaCtW8cWnEGnzvEvDPb32kZ0iUuU5jk5AgM4=;
        b=Ki+ZiHz74i4dB4ImpDuUKRN0PKY/lOM8v/oRA67naPXaFnPetV/4BJ3bfHxJnO0+KuEylk
        Pp6TZpieNH+/n64seedkl5U4Qtp5xLGBHOKp6eG/g3GJzqRzyEY48SNSUILjQzrvfZ6OcL
        52v4i+zLLuOegQ722ej0gGrz77t9PPU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-hJfRprEaOZun9TMc_NkHyw-1; Sat, 22 Apr 2023 08:53:18 -0400
X-MC-Unique: hJfRprEaOZun9TMc_NkHyw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 933F388CC44;
        Sat, 22 Apr 2023 12:53:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75A12404CD80;
        Sat, 22 Apr 2023 12:53:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Final KVM fixes for Linux 6.3
Date:   Sat, 22 Apr 2023 08:53:17 -0400
Message-Id: <20230422125317.2222959-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 0bf9601f8ef0703523018e975d6c1f3fdfcff4b9:

  Merge tag 'kvmarm-fixes-6.3-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2023-04-06 13:34:19 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 265b97cbc22e0f67f79a71443b60dc1237ca5ee6:

  Merge tag 'kvmarm-fixes-6.3-4' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2023-04-21 19:19:02 -0400)

(I checked and indeed last week's mishap was due to an incorrect push
_after_ I had generated the message and before I sent it.  I always
use "git request-pull", or more precisely a wrapper that generates the
mail headers and the "Linus," at the top, since I am clearly clumsy
enough with the automation that it provides...).

----------------------------------------------------------------
Two serious ARM fixes:

* Plug a buffer overflow due to the use of the user-provided register
  width for firmware regs. Outright reject accesses where the
  user register width does not match the kernel representation.

* Protect non-atomic RMW operations on vCPU flags against preemption,
  as an update to the flags by an intervening preemption could be lost.

----------------------------------------------------------------
Dan Carpenter (1):
      KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()

Marc Zyngier (1):
      KVM: arm64: Make vcpu flag updates non-preemptible

Paolo Bonzini (1):
      Merge tag 'kvmarm-fixes-6.3-4' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

 arch/arm64/include/asm/kvm_host.h | 19 ++++++++++++++++++-
 arch/arm64/kvm/hypercalls.c       |  2 ++
 2 files changed, 20 insertions(+), 1 deletion(-)

