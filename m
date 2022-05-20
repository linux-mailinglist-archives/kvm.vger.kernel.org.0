Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564B452E6A8
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 09:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346310AbiETH5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 03:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235780AbiETH46 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 03:56:58 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4878414AF70
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 00:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653033418; x=1684569418;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K66iNWUluPW9Kwal4hSKalQR56Ch2PBL7m4eEpj9Jzk=;
  b=OK1QY+fhkLiRX9nyg8DPQvBvh/M5L4Z93X8XH3pz5hopIin6ciLs18FK
   viqKRecqXf2B8lboq6FBlReDRb1r7VBpQhZu6R90nFfP80JHrz8BUzqqL
   wdxuaq0KRUndqnLdtJskff7+p/VJpkB7JaGTXy8MEug6IShP+8zd/eei1
   6HFNlsGd7gjLePRJRfN6AEO/qlpKdz6yUf9vL/TXH/Gt5X0tSfl+96LOn
   rpkgjmUiV9G09ambUTi3H53Ms1pc9ZYOcTSTHl+E7ovI64av5IyzZOUkl
   OS8gPpia30VIcD/qLRdzaflZtCrVaHLT+zOuVvzy9LXLKbFJE3pOXxskU
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="335584697"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="335584697"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 00:56:58 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="701628535"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 00:56:55 -0700
Date:   Fri, 20 May 2022 15:56:46 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [QEMU PATCH] x86: Set maximum APIC ID to KVM prior to vCPU
 creation
Message-ID: <20220520075641.GA22216@gao-cwp>
References: <20220520063928.23645-1-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520063928.23645-1-guang.zeng@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 02:39:28PM +0800, Zeng Guang wrote:
>Specify maximum possible APIC ID assigned for current VM session prior to
>the creation of vCPUs. KVM need set up VM-scoped data structure indexed by
>the APIC ID, e.g. Posted-Interrupt Descriptor table to support Intel IPI
>virtualization.
>
>It can be achieved by calling KVM_ENABLE_CAP for KVM_CAP_MAX_VCPU_ID
>capability once KVM has already enabled it. Otherwise, simply prompts
>that KVM doesn't support this capability yet.
>
>Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>---
> hw/i386/x86.c | 9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)
>
>diff --git a/hw/i386/x86.c b/hw/i386/x86.c
>index 4cf107baea..ff74492325 100644
>--- a/hw/i386/x86.c
>+++ b/hw/i386/x86.c
>@@ -106,7 +106,7 @@ out:
> 
> void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
> {
>-    int i;
>+    int i, ret;
>     const CPUArchIdList *possible_cpus;
>     MachineState *ms = MACHINE(x86ms);
>     MachineClass *mc = MACHINE_GET_CLASS(x86ms);
>@@ -123,6 +123,13 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
>      */
>     x86ms->apic_id_limit = x86_cpu_apic_id_from_index(x86ms,
>                                                       ms->smp.max_cpus - 1) + 1;
>+
>+    ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_MAX_VCPU_ID,
>+                            0, x86ms->apic_id_limit);
>+    if (ret < 0) {
>+        error_report("kvm: Set max vcpu id not supported: %s", strerror(-ret));
>+    }

This piece of code is specific to KVM. Please move it to kvm-all.c and
invoke a wrapper function here. As kvm accelerator isn't necessarily
enabled, the function call should be guarded by kvm_enabled().

And I think the error message can be omitted because the failure doesn't
impact functionality; just a few more pages will be allocated by KVM.
