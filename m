Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92D9742B29
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 19:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbjF2R0n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 13:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjF2R0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 13:26:41 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD9210C9;
        Thu, 29 Jun 2023 10:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688059600; x=1719595600;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HNJ1F4CHqqf6Cxe/kg2nLGIn5lZXHUbXh0rXt0mPCo0=;
  b=lvWXQDUaHxu3VJzUaX42d2LKjb1qsmd/9ar4jEJ+LRil293tJ3R/s0Co
   qSzoG3tMiN+PA6q5nEPZwFRzwLKnats33yrMBKsWg5JzP9hjxqI2Wsorc
   UmzyrQC8nof17i98L5744WFd9Nzm6YZ7eFAF3G0z2AFw24T2Z8vMA6YM9
   dQNwpB8ranwQs6nYayPam8dEeClst4Y86vCy45OWS16s9Qg6W0glJH4VE
   HctN/Ye8YZjE8uf6oTkLjsN5h55qyqW9FCB/qEiikCkBKd6COClrbI+72
   yvLvFXQlWdpNpIJhpG7jb6NRoFXqWqvZkMAJwH1DoVN/pyi0NexMJxqJH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="361019489"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="361019489"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 10:26:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="717462367"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="717462367"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.17.222]) ([10.93.17.222])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 10:26:35 -0700
Message-ID: <bf98965c-51c5-aaaa-efd9-ce2ecf1c2cbb@linux.intel.com>
Date:   Fri, 30 Jun 2023 01:26:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v9 4/6] KVM: x86: Introduce untag_addr() in kvm_x86_ops
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
 <20230606091842.13123-5-binbin.wu@linux.intel.com>
 <ZJt7vud/2FJtcGjV@google.com>
 <bf5ef935-b676-4f2a-7df3-271eff24e6bb@linux.intel.com>
 <ZJ2gW1gD9noko8H6@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZJ2gW1gD9noko8H6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/29/2023 11:16 PM, Sean Christopherson wrote:
>> And for LAM, X86EMUL_F_IMPLICIT will not be used because in the implicit
>> access to memory management registers or descriptors,
>> the linear base addresses still need to be canonical and no hooks will be
>> added to untag the addresses in these pathes.
>> So I probably will remove the check for X86EMUL_F_IMPLICIT here.
> No, please keep it, e.g. so that changes in the emulator don't lead to breakage,
> and to document that they are exempt.
>
> If you want, you could do WARN_ON_ONCE() for the IMPLICIT case, but I don't know
> that that's worthwhile, e.g. nothing will go wrong if KVM tries to untag an
> implicit access, and deliberately avoiding the call make make it annoying to
> consolidate code in the future.
Right.
Have a second thought, X86EMUL_F_IMPLICIT should be kept in case SVM has 
a different implementation and needs to do untag for IMPLICIT cases.


