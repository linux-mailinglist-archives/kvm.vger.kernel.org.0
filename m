Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0067D615B
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 07:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjJYF7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 01:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjJYF7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 01:59:23 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB5812F;
        Tue, 24 Oct 2023 22:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698213561; x=1729749561;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sl7Ov3shGCR6/Lo9HN950tbCO7I47zj+Y3uAuM/GEeI=;
  b=K6UV0ywqfu//UyPgQoX4jLicMrerhVcg0XdCzM07MQqLcLDUeAbDho2R
   Cv8sewl0rMN9SWPxtS3XDYiY5xvXqGi6R1gHErwoJVPBueGVGYR2OIjox
   HrtYQt6dvNNrNgJXDDz+qhfRsHddR5uZikHZecsBTtqUPzQ0zIhoSNgtQ
   dZCWvRDTXC38LEfaO89AC5huDcX7GhfLYKvmSSproo2ZdC9w77HrBQsL3
   ZbA+asm/dr/WSsVoq+eYKDeQ7BPhFzFpRe5l0X8umEKl+T7DE1u+qPi3g
   Uj0FuNJeIxpcX2Y6If86zk52Zovw1utrdtlAsWbMh4bYGfQGNTiYS4gFS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="473479208"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="473479208"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 22:59:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="788021746"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="788021746"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga008.jf.intel.com with ESMTP; 24 Oct 2023 22:59:17 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 0/2] x86/asyncpf: Fixes the size of asyncpf PV data and related docs
Date:   Wed, 25 Oct 2023 01:59:12 -0400
Message-Id: <20231025055914.1201792-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

First patch tries to make the size of 'struct kvm_vcpu_pv_apf_data'
matched with its documentation.

Second patch fixes the wrong description of the MSR_KVM_ASYNC_PF_EN
documentation and some minor improvement.

v1: https://lore.kernel.org/all/ZS7ERnnRqs8Fl0ZF@google.com/T/#m0e12562199923ab58975d4ae9abaeb4a57597893

Xiaoyao Li (2):
  x86/kvm/async_pf: Use separate percpu variable to track the enabling
    of asyncpf
  KVM: x86: Improve documentation of MSR_KVM_ASYNC_PF_EN

 Documentation/virt/kvm/x86/msr.rst   | 19 +++++++++----------
 arch/x86/include/uapi/asm/kvm_para.h |  1 -
 arch/x86/kernel/kvm.c                | 11 ++++++-----
 3 files changed, 15 insertions(+), 16 deletions(-)


base-commit: 2b3f2325e71f09098723727d665e2e8003d455dc
-- 
2.34.1

