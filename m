Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BE06A5413
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 09:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjB1IDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 03:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjB1IDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 03:03:20 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD5AD528;
        Tue, 28 Feb 2023 00:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677571399; x=1709107399;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+fjRBEyt8zyZIu0/NzNVouVY1z5OE8APuiDz1ezJ0g4=;
  b=LYl7NbzHqqGv3NiqR/VjfLAj/TaTtID3YKn5pHU0XDxQ0BgKodg5XRVW
   1AppAnfBqQbXGvdHvvrCKPrVRIos4nbySotCw6L0Dnxd124tRi3EN7ATF
   hRLmCwGywySPVuBDuMk63p9KutHNx1lqApbHYktEdAMen/k+gSd4tO0y9
   zn5uLCi0RzbK3PJpJr9Uq6K30/4x1k9AVFkmYe4KSTxl4kG2Q5ptw2m90
   KDS/O95PfdEBr/WJQec1xdsw5242RTR03DGaJavA26G5Os3yXfL1hL/0z
   m2GGPkxby2Adc2OD6uvb11LoFznbk4fWE4jd/LWy8hbPDkOlUCdeX1wMc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="336364246"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="336364246"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 00:03:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="674041439"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="674041439"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.254.211.20]) ([10.254.211.20])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 00:03:14 -0800
Message-ID: <7ec69b6b-540c-95d1-079d-8527fabd440b@intel.com>
Date:   Tue, 28 Feb 2023 16:03:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [PATCH v12 000/106] KVM TDX basic feature support
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/27/2023 4:21 PM, isaku.yamahata@intel.com wrote:
> KVM TDX basic feature support
> 
> Hello.  This is v12 the patch series vof KVM TDX support.  This is based on
> v6.2-rc7 + the following patch series.
> 
> Related patch series This patch is based on:
> - fd-based approach for supporing KVM v10 and
>    https://lore.kernel.org/lkml/20221202061347.1070246-1-chao.p.peng@linux.intel.com/
>    git@github.com:sean-jc/linux.git  x86/upm_base_support
> - TDX host kernel support v9
>    https://lore.kernel.org/lkml/e1c717b36033caf8de9d7a448e06eff88ed0c9ae.camel@intel.com/T/#m2562c7f18eabae171793ed7ea81b3544d7af09c4


  9fdabaaf0346 KVM: TDX: Make TDX VM type supported
  fa6b8135913c KVM: x86: Introduce vm_type to differentiate default VMs 
from confidential VMs
  6dbc1fdfb61f KVM: TDX: Add placeholders for TDX VM/vcpu structure
  64a9c956f265 KVM: TDX: Initialize the TDX module when loading the KVM 
intel kernel module
  bacb6554fcf5 KVM: x86/vmx: Refactor KVM VMX module init/exit functions
  b17eee6a7d53 KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX 
and TDX
  5a8b8d63a2e8 x86/mtrr: Mask out keyid bits from variable mtrr mask 
register
  29017e2c04cc KVM: arm64: Mark kvm_arm_init() and its unique 
descendants as __init


I find above 8 patches not included in this patch series after TDX host 
kernel support series. Some of them were included in v11 before, and I 
think they are important to make the patch series intact. What's the 
reason for not including them?



