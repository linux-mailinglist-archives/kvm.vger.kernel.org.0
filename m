Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C4158D57C
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 10:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240820AbiHIIiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 04:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiHIIiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 04:38:16 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225F51EAFE;
        Tue,  9 Aug 2022 01:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660034295; x=1691570295;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uz6Rv3ZWjocJjMhymMHh6vkFnqaEDU/d8bs+q2jM1zk=;
  b=MlO1e2BmZICiQh4/ShctlqChmmRy8b1gDus09iwTz6D6etFsWynXtIeB
   FcxUYCFsV0LoRaioKb/xs7qhpD+bcVfofxO10U2CNiET0fU6yY04kvZwM
   4bougcwyXTTWio3LOBXPfb1tuota15+unGZWyO5njPuRwcnb6m/6Fchnl
   6L0q9QvEstHG64Qo4fBOp6gBMYzyyT1T+l/65lCAs54H4JSAc/gWErYcC
   8jR0IrhagpJ4W70ZbKWiHf9q/IsGb39VbIKHniLh20vUtq8m4Klua15dp
   xI5MPr1dLhGQ3oZdlsJpmfnuBZCcEHjkTt0ClYO7rWy9jSMoq9V9f2c6P
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="277721031"
X-IronPort-AV: E=Sophos;i="5.93,224,1654585200"; 
   d="scan'208";a="277721031"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 01:38:14 -0700
X-IronPort-AV: E=Sophos;i="5.93,224,1654585200"; 
   d="scan'208";a="672808501"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.171.147]) ([10.249.171.147])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 01:38:12 -0700
Message-ID: <e63b0606-9819-d1db-872a-b1d414d38dcb@linux.intel.com>
Date:   Tue, 9 Aug 2022 16:38:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v8 004/103] KVM: VMX: Move out vmx_x86_ops to 'main.c' to
 wrap VMX and TDX
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <005b92abc8b8ada2896af662d4459323ee6b7e36.1659854790.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <005b92abc8b8ada2896af662d4459323ee6b7e36.1659854790.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/8/8 6:00, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> KVM accesses Virtual Machine Control Structure (VMCS) with VMX instructions
> to operate on VM.  TDX defines its data structure and TDX SEAMCALL APIs for
> VMM to operate on Trust Domain (TD) instead.
>
> Trust Domain Virtual Processor State (TDVPS) is the root control structure
> of a TD VCPU.  It helps the TDX module control the operation of the VCPU,
> and holds the VCPU state while the VCPU is not running. TDVPS is opaque to
> software and DMA access, accessible only by using the TDX module interface
> functions (such as TDH.VP.RD, TDH.VP.WR ,..).  TDVPS includes TD VMCS, and
> TD VMCS auxiliary structures, such as virtual APIC page, virtualization
> exception information, etc.  TDVPS is composed of Trust Domain Virtual
> Processor Root (TDVPR) which is the root page of TDVPS and Trust Domain
> Virtual Processor eXtension (TDVPX) pages which extend TDVPR to help
> provide enough physical space for the logical TDVPS structure.
>
> Also, we have a new structure, Trust Domain Control Structure (TDCS) is the
> main control structure of a guest TD, and encrypted (using the guest TD's
> ephemeral private key).  At a high level, TDCS holds information for
> controlling TD operation as a whole, execution, EPTP, MSR bitmaps, etc. KVM
> needs to set it up.  Note that MSR bitmaps are held as part of TDCS (unlike
> VMX) because they are meant to have the same value for all VCPUs of the
> same TD.  TDCS is a multi-page logical structure composed of multiple Trust
> Domain Control Extension (TDCX) physical pages.  Trust Domain Root (TDR) is
> the root control structure of a guest TD and is encrypted using the TDX
> global private key. It holds a minimal set of state variables that enable
> guest TD control even during times when the TD's private key is not known,
> or when the TD's key management state does not permit access to memory
> encrypted using the TD's private key.
>
> The following shows the relationship between those structures.
>
>          TDR--> TDCS                     per-TD
>           |       \--> TDCX
>           \
>            \--> TDVPS                    per-TD VCPU
>                   \--> TDVPR and TDVPX
>
> The existing global struct kvm_x86_ops already defines an interface which
> fits with TDX.  But kvm_x86_ops is system-wide, not per-VM structure.  To
> allow VMX to coexist with TDs, the kvm_x86_ops callbacks will have wrappers
> "if (tdx) tdx_op() else vmx_op()" to switch VMX or TDX at run time.
>
> To split the runtime switch, the VMX implementation, and the TDX
> implementation, add main.c, and move out the vmx_x86_ops hooks in
> preparation for adding TDX, which can coexist with VMX, i.e. KVM can run
> both VMs and TDs.  Use 'vt' for the naming scheme as a nod to VT-x and as a
> concatenation of VmxTdx.
>
> The current code looks as follows.
> In vmx.c
>    static vmx_op() { ... }
>    static struct kvm_x86_ops vmx_x86_ops = {
>          .op = vmx_op,
>    initialization code
>
> The eventually converted code will look like
> In vmx.c, keep the VMX operations.
>    vmx_op() { ... }
>    VMX initialization
> In tdx.c, define the TDX operations.
>    tdx_op() { ... }
>    TDX initialization
> In x86_ops.h, declare the VMX and TDX operations.
>    vmx_op();
>    tdx_op();
> In main.c, define common wrappers for VMX and VMX.

LGTM.
One typo here, VMX and TDX.


>    static vt_ops() { if (tdx) tdx_ops() else vmx_ops() }
>    static struct kvm_x86_ops vt_x86_ops = {
>          .op = vt_op,
>    initialization to call VMX and TDX initialization
>
> Opportunistically, fix the name inconsistency from vmx_create_vcpu() and
> vmx_free_vcpu() to vmx_vcpu_create() and vxm_vcpu_free().
>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
