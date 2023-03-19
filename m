Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCE16C000B
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 09:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjCSIc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 04:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCSIc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 04:32:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7194227B8
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 01:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679214747; x=1710750747;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=R7lmpiyI0koH9CLCcodgPgexGMAC+2GuHvTjRGvmEWo=;
  b=PZKzlA4FBWBl55lieqy7KErWmUK/vd18uP8O8sPs7tySML3mNzMGm0So
   uot4/lSy6Ydr9j59MVawOOY77Ij67e4OWBP4KzXxC7thSvukg5p7qMRwJ
   krQfaK6D2ej94YoZk/u1k0Ga+f4T4Tuv5SfOjsTzY4FXhCZgaPF6epV+1
   DyOo9ZtG1afAK9SG5uHRnYnP5RcpHFL//4EzcxPWdr2f6KzxV6ahypQ3Y
   PuXcVln+thN31/ZK3a6GxkHpHxTLM47LjthQtjgtjKIeaSfQK6vHtdc28
   V1KXzDUfV8l5hBo5b9oycAGZ97CtmSBY6+nrxqp2a2wHAyeFl7FOOMKR1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="401066015"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="401066015"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:32:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="713219733"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="713219733"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.209.111]) ([10.254.209.111])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:32:26 -0700
Message-ID: <3d8e83ca-8490-b91c-01a3-9f8c4d07d74c@linux.intel.com>
Date:   Sun, 19 Mar 2023 16:32:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 0/4] x86: Add test cases for LAM
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com
References: <20230319082225.14302-1-binbin.wu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230319082225.14302-1-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for forgetting adding kvm-unit-test prefix. I will resend with the 
patch series with the right prefix.


On 3/19/2023 4:22 PM, Binbin Wu wrote:
> Intel Linear-address masking (LAM) [1], modifies the checking that is applied to
> *64-bit* linear addresses, allowing software to use of the untranslated address
> bits for metadata.
>
> The patch series add test cases for LAM:
>
> Patch 1 makes change to HOST_CR3 tests in vmx.
> If LAM is supported, VM entry allows CR3.LAM_U48 (bit 62) and CR3.LAM_U57
> (bit 61) to be set in CR3 field. Change the test result expectations when
> setting CR3.LAM_U48 or CR3.LAM_U57 on vmlaunch tests when LAM is supported.
>
> Patch 2~4 add test cases for LAM supervisor mode and user mode, including:
> - For supervisor mode
>    CR4.LAM_SUP toggle
>    Memory/MMIO access with tagged pointer
>    INVLPG
>    INVPCID
>    INVVPID (also used to cover VMX instruction vmexit path)
> - For user mode
>    CR3 LAM bits toggle
>    Memory/MMIO access with tagged pointer
>
> [1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
>      Chapter Linear Address Masking (LAM)
>
> ---
> Changelog
> v1 --> v2:
> Add cases to test INVLPG, INVPCID, INVVPID with LAM_SUP
> Add cases to test LAM_{U48,U57}
>
> Binbin Wu (3):
>    x86: Allow setting of CR3 LAM bits if LAM supported
>    x86: Add test cases for LAM_{U48,U57}
>    x86: Add test case for INVVPID with LAM
>
> Robert Hoo (1):
>    x86: Add test case for LAM_SUP
>
>   lib/x86/processor.h |   7 +
>   x86/Makefile.x86_64 |   1 +
>   x86/lam.c           | 340 ++++++++++++++++++++++++++++++++++++++++++++
>   x86/unittests.cfg   |  10 ++
>   x86/vmx_tests.c     |  79 +++++++++-
>   5 files changed, 436 insertions(+), 1 deletion(-)
>   create mode 100644 x86/lam.c
>
>
> base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6
