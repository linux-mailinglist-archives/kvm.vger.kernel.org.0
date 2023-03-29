Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349696CD163
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 07:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjC2FCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 01:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2FCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 01:02:20 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DDA2723
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 22:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680066139; x=1711602139;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r74EaM73zY5ZRtB94VXOU/R69ArxoNuVsyjq3AcjTU4=;
  b=nM3W5EJV6Si/iEWHRyz4i9RMjsyJ2gWpcgNM75+R634ULfqxXsr4VnO0
   0SNR3WtAnZXCbAH+ZEIvH+Vi1pCgApifYdZQyDx5luuxQSpPwAMZPMcy/
   AZv8WGad8rI5kMyGPhnwk7XCIBWOJmUk+fNMHUzTWa+tfVx9sx0by0IY7
   u1NdWbIvcQZcrS1avgya7pY6MOzZqjR6XbwyrbmIB6ZDlgOItawvnFmdi
   AphpTi1PC21YDP1CZNAzVgYVDLqksvwsG6T/NkknwpSxP/cfkaYoa9qHz
   uoo4vhDDK9FW0hZhGlKAvXQhvw4m0hKXvU9W7shUgV3qbM/9XU+ix4Hv6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="342368582"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="342368582"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 22:02:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="858337799"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="858337799"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.2.227]) ([10.238.2.227])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 22:02:18 -0700
Message-ID: <f097e63d-dce2-2abd-3050-a71c09dadd13@linux.intel.com>
Date:   Wed, 29 Mar 2023 13:02:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 6/7] KVM: x86: Untag address when LAM applicable
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-7-binbin.wu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230319084927.29607-7-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/19/2023 4:49 PM, Binbin Wu wrote:
> Untag address for 64-bit memory/mmio operand in instruction emulations
> and vmexit handlers when LAM is applicable.
>
> For instruction emulation, untag address in __linearize() before
> canonical check. LAM doesn't apply to instruction fetch and invlpg,
> use KVM_X86_UNTAG_ADDR_SKIP_LAM to skip LAM untag.
>
> For vmexit handlings related to 64-bit linear address:
> - Cases need to untag address
>    Operand(s) of VMX instructions and INVPCID
>    Operand(s) of SGX ENCLS
>    Linear address in INVVPID descriptor.
> - Cases LAM doesn't apply to (no change needed)
>    Operand of INVLPG
>    Linear address in INVPCID descriptor
>
> Co-developed-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
>   arch/x86/kvm/emulate.c    | 25 +++++++++++++++++--------
>   arch/x86/kvm/vmx/nested.c |  2 ++
>   arch/x86/kvm/vmx/sgx.c    |  1 +
>   arch/x86/kvm/x86.c        |  4 ++++
>   4 files changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index a630c5db971c..c46f0162498e 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -688,7 +688,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>   				       struct segmented_address addr,
>   				       unsigned *max_size, unsigned size,
>   				       bool write, bool fetch,
> -				       enum x86emul_mode mode, ulong *linear)
> +				       enum x86emul_mode mode, ulong *linear,
> +				       u64 untag_flags)
>   {
>   	struct desc_struct desc;
>   	bool usable;
> @@ -701,9 +702,10 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>   	*max_size = 0;
>   	switch (mode) {
>   	case X86EMUL_MODE_PROT64:
> -		*linear = la;
> +		*linear = static_call(kvm_x86_untag_addr)(ctxt->vcpu, la, untag_flags);
> +
>   		va_bits = ctxt_virt_addr_bits(ctxt);
> -		if (!__is_canonical_address(la, va_bits))
> +		if (!__is_canonical_address(*linear, va_bits))
>   			goto bad;

Find  la as a local variable, will be used later.
This part will be updated as following to make la untagged to avoid 
further changes:

@@ -701,6 +702,7 @@ static __always_inline int __linearize(struct 
x86_emulate_ctxt *ctxt,
         *max_size = 0;
         switch (mode) {
         case X86EMUL_MODE_PROT64:
+               la = ctxt->ops->untag_addr(ctxt, la, untag_flags);
                 *linear = la;
                 va_bits = ctxt_virt_addr_bits(ctxt);
                 if (!__is_canonical_address(la, va_bits))


