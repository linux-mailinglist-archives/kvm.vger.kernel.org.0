Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B824EA5A2
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 05:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiC2DC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 23:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiC2DC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 23:02:57 -0400
Received: from out0-142.mail.aliyun.com (out0-142.mail.aliyun.com [140.205.0.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1812923F9F6;
        Mon, 28 Mar 2022 20:01:13 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047187;MF=darcy.sh@antgroup.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---.NF0ngfN_1648522870;
Received: from localhost(mailfrom:darcy.sh@antgroup.com fp:SMTPD_---.NF0ngfN_1648522870)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 29 Mar 2022 11:01:10 +0800
From:   "SU Hang" <darcy.sh@antgroup.com>
To:     seanjc@google.com, kvm@vger.kernel.org
Cc:     "Lai Jiangshan" <jiangshan.ljs@antgroup.com>,
        "SU Hang" <darcy.sh@antgroup.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] KVM: x86: Replace magic number with readable macro
Date:   Tue, 29 Mar 2022 11:01:05 +0800
Message-Id: <20220329030108.97341-1-darcy.sh@antgroup.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace magic number 0x180 with `EPT_VIOLATION_GVA_IS_VALID | EPT_VIOLATION_GVA_TRANSLATED`
in arch/x86/kvm/mmu/paging_tmpl.h
Similarly, replace `(pte_access & 0x7) << 3` with
`(pte_access & VMX_EPT_RWX_MASK) << EPT_VIOLATION_RWX_SHIFT`.

v1 -> v2: https://lore.kernel.org/kvm/20220321094203.109546-1-darcy.sh@antgroup.com/
- Rename `EPT_VIOLATION_GVA_VALIDATION` to `EPT_VIOLATION_GVA_IS_VALID`. [Sean]
- Using new added `VMX_EPT_RWX_MASK` to replace magic number 0x7 and so on,
  to avoid using branch statement in hotpath. [Sean]

SU Hang (1):
  KVM: VMX:  replace 0x180 with EPT_VIOLATION_* definition

Sean Christopherson (1):
  KVM: x86/mmu: Derive EPT violation RWX bits from EPTE RWX bits

 arch/x86/include/asm/vmx.h     |  9 +++------
 arch/x86/kvm/mmu/paging_tmpl.h | 11 +++++++++--
 arch/x86/kvm/vmx/vmx.c         |  4 +---
 3 files changed, 13 insertions(+), 11 deletions(-)

--
2.32.0.3.g01195cf9f

