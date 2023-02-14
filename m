Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D47696AC8
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 18:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjBNRHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 12:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbjBNRHO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 12:07:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BA916AC3
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 09:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676394379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2vnqanjS3R8xWSEQunNpq4jdpZ+fB5HxGqABnquYPyY=;
        b=eZQHZAipfJ/g/XvY4+9YzjRAHcuPU4klWizj0kbt/jzZTnPMYoN+qRmrUOYG4LvPOuMeR1
        xpxMggmDXfNt+bfSWUw/NAwPlqULN0JWTAZXu8oFmRpRRmBVX7SckRAqwzlet6juVl2bIT
        vDuXWkrGex9GgzPrEyfFQV1S+oh2YjM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-bzSsldSnOkSvPOOJrj10IA-1; Tue, 14 Feb 2023 12:06:17 -0500
X-MC-Unique: bzSsldSnOkSvPOOJrj10IA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38FFA18E004A;
        Tue, 14 Feb 2023 17:06:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CFB2C15BA0;
        Tue, 14 Feb 2023 17:06:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     thomas.lendacky@amd.com
Subject: [FYI PATCH 0/3] Cross-Thread Return Address Predictions vulnerability
Date:   Tue, 14 Feb 2023 12:06:12 -0500
Message-Id: <20230214170615.1297202-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Certain AMD processors are vulnerable to a cross-thread return address
predictions bug. When running in SMT mode and one of the sibling threads
transitions out of C0 state, the other thread gets access to twice as many
entries in the RSB, but unfortunately the predictions of the now-halted
logical processor are not purged.  Therefore, the executing processor
could speculatively execute from locations that the now-halted processor
had trained the RSB on.

The Spectre v2 mitigations cover the Linux kernel, as it fills the RSB
when context switching to the idle thread. However, KVM allows a VMM to
prevent exiting guest mode when transitioning out of C0 using the
KVM_CAP_X86_DISABLE_EXITS capability can be used by a VMM to change this
behavior. To mitigate the cross-thread return address predictions bug,
a VMM must not be allowed to override the default behavior to intercept
C0 transitions.

These patches introduce a KVM module parameter that, if set, will prevent
the user from disabling the HLT, MWAIT and CSTATE exits.

The patches apply to Linus's tree and (with a one-line context difference)
to the 6.1 stable tree.  They will be applied to the 6.2 and 6.1 trees
through bundles that I have sent to Linus and Greg.

A separate 5.15 backport will come soon.

Thanks,

Paolo

Tom Lendacky (3):
  x86/speculation: Identify processors vulnerable to SMT RSB predictions
  KVM: x86: Mitigate the cross-thread return address predictions bug
  Documentation/hw-vuln: Add documentation for Cross-Thread Return
    Predictions

 .../admin-guide/hw-vuln/cross-thread-rsb.rst  | 92 +++++++++++++++++++
 Documentation/admin-guide/hw-vuln/index.rst   |  1 +
 arch/x86/include/asm/cpufeatures.h            |  1 +
 arch/x86/kernel/cpu/common.c                  |  9 +-
 arch/x86/kvm/x86.c                            | 43 ++++++---
 5 files changed, 133 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/admin-guide/hw-vuln/cross-thread-rsb.rst

-- 
2.39.1

