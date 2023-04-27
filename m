Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72E76F03C7
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 11:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243249AbjD0J4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 05:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242993AbjD0J4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 05:56:18 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794842684;
        Thu, 27 Apr 2023 02:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682589377; x=1714125377;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rVn2ZiVnq8csV2fs4smsTIN5Y9o8VV3U1LDwNb4K/fA=;
  b=CWzdeMBmCxKj3Tw6tDbqc3TGh25KV+eeHTGG5yq2h8rGLdHcy09BuZTZ
   UAC4eCTuOG5IX0GWFfZFPrHnhOPKCcs8cmqGSVAMwL36eYWQFRJyXf2hL
   SgNIBYIjIIOGtWx9aLwZhmrIRoQydsHX/oObz7I7E45S/H/2WFN7UbhsC
   A=;
X-IronPort-AV: E=Sophos;i="5.99,230,1677542400"; 
   d="scan'208";a="319019086"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 09:56:12 +0000
Received: from EX19MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com (Postfix) with ESMTPS id 0910A40E62;
        Thu, 27 Apr 2023 09:56:09 +0000 (UTC)
Received: from EX19D008UEA004.ant.amazon.com (10.252.134.191) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 27 Apr 2023 09:56:01 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D008UEA004.ant.amazon.com (10.252.134.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 27 Apr 2023 09:56:01 +0000
Received: from dev-dsk-abusse-1c-9fba1bbe.eu-west-1.amazon.com (10.13.253.110)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26 via Frontend Transport; Thu, 27 Apr 2023 09:56:00 +0000
From:   Anselm Busse <abusse@amazon.com>
CC:     <dwmw@amazon.co.uk>, <hborghor@amazon.de>, <sironi@amazon.de>,
        "Anselm Busse" <abusse@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] KVM support for Intel PMU v5 fixed function PMC bitmap
Date:   Thu, 27 Apr 2023 09:53:31 +0000
Message-ID: <20230427095333.35038-1-abusse@amazon.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Starting with v5, the Intel PMU allows to indicate the available fixed
function PMCs not only through CPUID.0AH.EDX[4:0] but also through a
bit mask in CPUID.0AH.ECX. According to the SDM the OS can consider a
fix function PMC i supported for:

CPUID.0AH.ECX[i] || (CPUID.0AH.EDX[4:0] > i)

This behavior is already supported by the Intel PMU driver. However, KVM
support is missing. This patch series add the support by first
refactoring the tracking of available fixed function PMCs in KVM from a
number to a bitmap in the frist patch. The second patch populates the
bitmap accoring to the rule given by the SDM mentioned above.

Regards,
Anselm

Anselm Busse (2):
  KVM: vmx/pmu: Indicate available fixed function PMCs through a bitmap
  KVM: vmx/pmu: Add support for selected fixed vPMU enablement for PMU v5

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/pmu.h              |  6 ++---
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 40 ++++++++++++++++++++-------------
 4 files changed, 30 insertions(+), 20 deletions(-)


base-commit: 0cfd8703e7da687924371e9bc77a025bdeba9637
-- 
2.39.2




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



