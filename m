Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C828156143
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 23:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBGWf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 17:35:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43828 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727068AbgBGWf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 17:35:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581114926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ugZBz7enuCINLO2hCs0M9spDUSXUeBZ8X9fYPkjTl9M=;
        b=AOc/2UwsgyWFumXlcUmRsQ8YnXeZxd8AmFdKV20GYopInCVNjKV1YsFzGsH1Kx/lNK5pSc
        69wzGCdve9owXwCsTPAjVeWdhLMjpunhhA6XYWQCfP2TnUH5afAWHF1N1uGAuOuctBVKHP
        ZpOCyyrQ9WJlM8pyFN9HjuqbTTwTSMM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-1Pfh9b79OpSJjTvqcPBcPg-1; Fri, 07 Feb 2020 17:35:24 -0500
X-MC-Unique: 1Pfh9b79OpSJjTvqcPBcPg-1
Received: by mail-qt1-f199.google.com with SMTP id e8so538349qtg.9
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 14:35:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ugZBz7enuCINLO2hCs0M9spDUSXUeBZ8X9fYPkjTl9M=;
        b=QO5jZhtmrZmO/PRE8SoEddwV9vqX1m+sFR6JmulP/9hmboZTPXbxf5TiI/bVepW+7v
         X4yASW9vvd8VzutOnRwEmiPpWeUYWo1Me4Ih9qOD+Z5cJ5SbOD+N2vFDd05PpVNwvP2M
         dK95KwGw0ffwV+5CQbAUddZbBVPL5e5qgscDS/p5nBLyOgH1f6eFusLVs4e2xvx1rnXS
         58bM8/HnWcmhX1Kh3PraYeFZ7w3TTQECR8BKw+BL88P071BLXR/DtIlkLXDEn0KG5c5f
         3YBSNNgctbJoOtRTUm8NVs017J3md2SSmbbpo4q+q3Lcmr4hlouO0YJvqelnEAp8phBT
         trDw==
X-Gm-Message-State: APjAAAXIHQ+CoYi7lwgd7iorFPNT26vaA0MiyJ/1folqaYBzrRu8rSOJ
        RLA55TRLQPlFy/EwLe9sRMVsNgMS+CY7HWNhfGUiAHlUazp8yX5XiUuHj9cb6Zqw+mF2Ak4n8oq
        ucQEzj2jkVqwr
X-Received: by 2002:ac8:1205:: with SMTP id x5mr598702qti.238.1581114923526;
        Fri, 07 Feb 2020 14:35:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqzFhVS1bhbCdouqP3dIqYiC7xAeG36OuHcbu/fkXUSHwKqa8FFEiGxaaY0/f//YMJs09H18pw==
X-Received: by 2002:ac8:1205:: with SMTP id x5mr598684qti.238.1581114923289;
        Fri, 07 Feb 2020 14:35:23 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id u12sm2178736qtj.84.2020.02.07.14.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 14:35:22 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-mips@vger.kernel.org, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 0/4] KVM: MIPS: Provide arch-specific kvm_flush_remote_tlbs()
Date:   Fri,  7 Feb 2020 17:35:16 -0500
Message-Id: <20200207223520.735523-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[This series is RFC because I don't have MIPS to compile and test]

kvm_flush_remote_tlbs() can be arch-specific, by either:

- Completely replace kvm_flush_remote_tlbs(), like ARM, who is the
  only user of CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL so far

- Doing something extra before kvm_flush_remote_tlbs(), like MIPS VZ
  support, however still wants to have the common tlb flush to be part
  of the process.  Could refer to kvm_vz_flush_shadow_all().  Then in
  MIPS it's awkward to flush remote TLBs: we'll need to call the mips
  hooks.

It's awkward to have different ways to specialize this procedure,
especially MIPS cannot use the genenal interface which is quite a
pity.  It's good to make it a common interface.

This patch series removes the 2nd MIPS usage above, and let it also
use the common kvm_flush_remote_tlbs() interface.  It should be
suggested that we always keep kvm_flush_remote_tlbs() be a common
entrance for tlb flushing on all archs.

This idea comes from the reading of Sean's patchset on dynamic memslot
allocation, where a new dirty log specific hook is added for flushing
TLBs only for the MIPS code [1].  With this patchset, logically the
new hook in that patch can be dropped so we can directly use
kvm_flush_remote_tlbs().

TODO: We can even extend another common interface for ranged TLB, but
let's see how we think about this series first.

Any comment is welcomed, thanks.

Peter Xu (4):
  KVM: Provide kvm_flush_remote_tlbs_common()
  KVM: MIPS: Drop flush_shadow_memslot() callback
  KVM: MIPS: Replace all the kvm_flush_remote_tlbs() references
  KVM: MIPS: Define arch-specific kvm_flush_remote_tlbs()

 arch/mips/include/asm/kvm_host.h |  7 -------
 arch/mips/kvm/Kconfig            |  1 +
 arch/mips/kvm/mips.c             | 22 ++++++++++------------
 arch/mips/kvm/trap_emul.c        | 15 +--------------
 arch/mips/kvm/vz.c               | 14 ++------------
 include/linux/kvm_host.h         |  1 +
 virt/kvm/kvm_main.c              | 10 ++++++++--
 7 files changed, 23 insertions(+), 47 deletions(-)

-- 
2.24.1

