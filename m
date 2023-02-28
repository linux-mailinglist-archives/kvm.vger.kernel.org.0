Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE046A60DE
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 22:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjB1VCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 16:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjB1VCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 16:02:36 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731B134F60;
        Tue, 28 Feb 2023 13:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677618155; x=1709154155;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NfWEprhNDVdb4rY3h5e3xlesFVpU3kv1Uas10C/R2y4=;
  b=Srb9DVA0phCFra0xog4k97q9HgC3IMm+VOlh8FW64uUuyniCqZbWFfZN
   FnK4lspTfhr61WERXuTaz4xhCLItbgw1jn0CccxfCwppd11zPTQolBYZw
   gUxL/3E1fKYWN7zzAMOUP5ENTBHpZxwWckgK9NzHn6kUA7kZZwkuvajcJ
   n7e8RkM9PIJH4rBXJV9gqgjCqfvpIoVDX1cF+SaFc2/BffTesigUsrOIZ
   6H63R2gd/GRx5b29ADIAv/XVoFIRqe/I+aGFOo6FVXWseKdix5NLkqqZX
   9AeriTU/gp+2QAOFD/gWSHCZ5DtyOxh0dCzOXa1oQnrROGFpj15viy4jp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="314673223"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="314673223"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 13:02:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="784025412"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="784025412"
Received: from avandeve-mobl1.amr.corp.intel.com (HELO [10.212.193.190]) ([10.212.193.190])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 13:02:33 -0800
Message-ID: <96c0c723-9976-a222-8dc8-a5da6a1a558e@linux.intel.com>
Date:   Tue, 28 Feb 2023 13:02:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v12 07/11] x86/smpboot: Remove early_gdt_descr on 64-bit
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-8-usama.arif@bytedance.com> <878rghmrn2.ffs@tglx>
From:   Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <878rghmrn2.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> 
> Maybe we should enforce CONFIG_SMP=y first :)
> 
> Thanks,

for 64 bit I can see the point of removing the !SMP case entirely from arch/x86 .
maybe even for 32 bit if it just makes the code simpler I suppose

