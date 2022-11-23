Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02F0635145
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 08:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbiKWHrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 02:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235411AbiKWHrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 02:47:19 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895D4F8864;
        Tue, 22 Nov 2022 23:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669189638; x=1700725638;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VaHG5HHnXNhrmj47fPmtSxSofcO5/Z8rZp/3ZUNa69o=;
  b=faGkb5plFC0CYvinlY51NwRQNjDT7g6lgyg5GxELcF3tozhqpor7j5kb
   r/eunKWDz0EqQRsjyGRbW8jdPYKfeenkr+qjFEoZZ1rSax800hIMlk21z
   uR2Op/Lu9bT9igi0kYzNpEaaxZlfPzqIx9EC0sr8JLzbvqD0Om6Cbaqj9
   jGAto3ZENTUBFp7gOFSw2bIvJYswBEDdIs/b6CxudJDIAqCApCd5v8hEA
   Kq9jcjs19QzDvKiH2xLTILFZutJqFnzghtNejkr5pSTz8pHp1gCvo7O3H
   SHeoX1JFsOzDPm0Q/3xRBcWqZuf05O/ih4RmKUevKjG3z3gJEjXNGMAqP
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="315826957"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="315826957"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 23:47:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="674629012"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="674629012"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.254.210.241]) ([10.254.210.241])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 23:47:02 -0800
Message-ID: <ffc31149-8780-5499-7d25-08b871399bde@linux.intel.com>
Date:   Wed, 23 Nov 2022 15:46:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v4 1/6] x86: KVM: Advertise CMPccXADD CPUID to user space
To:     Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
 <20221118141509.489359-2-jiaxi.chen@linux.intel.com>
 <efb55727-f8bd-815c-ddfc-a8432ae5af4e@intel.com>
 <f04c2e74-87e4-5d50-579a-0a60554b83d3@linux.intel.com>
 <Y3ubcwLlEdkj0/zK@zn.tnic>
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
In-Reply-To: <Y3ubcwLlEdkj0/zK@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/21/2022 11:38 PM, Borislav Petkov wrote:
> On Mon, Nov 21, 2022 at 10:46:21PM +0800, Jiaxi Chen wrote:
>> Features which has been enabled in kernel usually should be added to
>> /proc/cpuinfo.
> 
> No, pls read this first: Documentation/x86/cpuinfo.rst
> 
> If something's not clear, we will extend it so that it is.
> 
> /proc/cpuinfo - a user ABI - is not a dumping ground for CPUID bits.
> 

Thanks. Sorry for the miss understanding.

For those feature bits who have truly kernel usage, their flags should
appear in /proc/cpuinfo. For others, they are not generally show up
here, it depends.

As for features in this patch series:

The first-way defined bits are on an expected-dense cpuid leaf[1] and
some of their siblings have kernel usages[2]. Given that, define them
like X86_FEATURE_* in arch/x86/include/asm/cpufeatures.h. But due to
their complicated and unreadable feature name[3], prefer to hide them in
/proc/cpuinfo.

The second-way defined bits are on a new and sparse cpuid leaf. Besides,
these bits have no turly kernel use case. Therefore, move these new bits
to kvm-only leaves to achieve the purpose for advertising these bits to
kvm userspace[4]. Then of course they will not show up in /proc/cpuinfo.

[1] https://lore.kernel.org/all/Y3O7UYWfOLfJkwM%2F@zn.tnic/
[2]
https://lore.kernel.org/all/f8607d23-afaa-2670-dd03-2ae8ec1e79a0@intel.com/
[3]
https://lore.kernel.org/all/6d7fae50-ef3c-dc1e-336c-691095007117@intel.com/
[4] https://lore.kernel.org/all/Y1ATKF2xjERFbspn@google.com/

-- 
Regards,
Jiaxi
