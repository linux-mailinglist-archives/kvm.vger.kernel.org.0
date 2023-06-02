Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA174720BC8
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 00:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236334AbjFBWPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 18:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbjFBWPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 18:15:05 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6C01BE
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 15:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685744105; x=1717280105;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pUszmKnf/mkyzTbf6VDD11A2hHjQ1yzaAxlpvgJ3/wA=;
  b=s3iEMuEXCsMWd3rw8VlOmBrfK5TUOY04XKBWBUMx9yFMNjXMi7aC9XdQ
   CbHXJLEqBy8tMpliCSzQyGy+3/S52AIdIMgEsrMG3c7VShzrgaCP+Z97I
   9Y4I5mmryk37Q9CP/sVdQmiWpcjocFjvKPplz6LJeKVKTDx8gp0GldnWi
   U=;
X-IronPort-AV: E=Sophos;i="6.00,214,1681171200"; 
   d="scan'208";a="338443037"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 22:15:03 +0000
Received: from EX19MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com (Postfix) with ESMTPS id 65CBE61319;
        Fri,  2 Jun 2023 22:15:01 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 22:14:58 +0000
Received: from u1e958862c3245e.ant.amazon.com (10.187.170.26) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 22:14:58 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <jingzhangos@google.com>
CC:     <alexandru.elisei@arm.com>, <james.morse@arm.com>,
        <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
        <linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>,
        <oupton@google.com>, <pbonzini@redhat.com>, <rananta@google.com>,
        <reijiw@google.com>, <suzuki.poulose@arm.com>, <tabba@google.com>,
        <will@kernel.org>, <sjitindarsingh@gmail.com>,
        "Suraj Jitindar Singh" <surajjs@amazon.com>
Subject: [PATCH 0/3] RE: Support writable CPU ID registers from userspace [v11]
Date:   Fri, 2 Jun 2023 15:14:44 -0700
Message-ID: <20230602221447.1809849-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230602005118.2899664-1-jingzhangos@google.com>
References: <20230602005118.2899664-1-jingzhangos@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.26]
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the patch set you posted I get some kvm unit tests failures due to
being unable to update register values from userspace for tests using smp.
The first patch addresses this.

The second 2 are optimisations/cleanups.

Based on "Support writable CPU ID registers from userspace" [1]

[1] https://lore.kernel.org/linux-arm-kernel/20230602005118.2899664-1-jingzhangos@google.com/

Suraj Jitindar Singh (3):
  KVM: arm64: Update id_reg limit value based on per vcpu flags
  KVM: arm64: Move non per vcpu flag checks out of
    kvm_arm_update_id_reg()
  KVM: arm64: Use per guest ID register for ID_AA64PFR1_EL1.MTE

 arch/arm64/include/asm/kvm_host.h |  21 +++--
 arch/arm64/kvm/arm.c              |  11 ++-
 arch/arm64/kvm/sys_regs.c         | 122 +++++++++++++++++++++++++-----
 3 files changed, 121 insertions(+), 33 deletions(-)

-- 
2.34.1

