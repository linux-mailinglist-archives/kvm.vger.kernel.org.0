Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C0C572A34
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 02:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiGMAWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 20:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiGMAWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 20:22:38 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44726951E5;
        Tue, 12 Jul 2022 17:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657671757; x=1689207757;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=effvbrNy0O1vUmq93yrxqu28Ft9tve9MZHdOlTQGrKw=;
  b=KJtYZZdjc3WjMtWiuVJoYlh9lpdEUuK3lxW2RM9VwzbLgF4QtkaOKgGA
   IC6n5Dk53WgRMwNpBFemB9DonsTg3BxpE55UXjRClZ5vVmCGpSyMV3NrI
   RNTgLT4nK1Y+W8znOP5oTPrFHJHhuWkBgOMlvObmA41fIdbB8+uGQNH58
   SQyFVZLLHEjBAqks4BmGfdfwXx256KA21jxknHOvm39FxZ1+yjKXmiVbV
   oVQmcXT86ScMbXuYePRvmMdU/2o5nxZKgaH+ELguP0OwoJlyZhyFt1yut
   orTZXAcuZ25ZYN8Lsxt2cgQkySyYGdIMKQ9Oqa12kzJkRE9we5Hu4teG2
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="268110188"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="268110188"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 17:22:35 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="622712651"
Received: from hli101-mobl1.ccr.corp.intel.com (HELO [10.255.31.119]) ([10.255.31.119])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 17:22:32 -0700
Message-ID: <732553c4-8c2a-bd3f-cd2a-3e03fb364b5f@intel.com>
Date:   Wed, 13 Jul 2022 08:22:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v7 030/102] KVM: TDX: Do TDX specific vcpu initialization
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <e05ce01e400f80437803146564d4c351bf1df047.1656366338.git.isaku.yamahata@intel.com>
 <20220708021443.v4frmpcqgbk23hkp@yy-desk-7060>
 <20220712203542.GN1379820@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220712203542.GN1379820@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/13/2022 4:35 AM, Isaku Yamahata wrote:
> On Fri, Jul 08, 2022 at 10:14:43AM +0800,
> Yuan Yao <yuan.yao@linux.intel.com> wrote:
> 
...
>>> +int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>>> +{
>>> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>>> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>>> +	struct kvm_tdx_cmd cmd;
>>> +	u64 err;
>>> +
>>> +	if (tdx->initialized)
>>
>> Minor: How about "tdx_vcpu->initialized" ? there's
>> "is_td_initialized()" below, the "tdx" here may lead guys to treat it
>> as whole td vm until they confirmed it's type again.
> 
> I think you man tdx->vcpu_initialized.  If so, makes sense. I'll rename it.

IMO, no need to do so.

All around tdx.c, "tdx" is the brief pointer name, just like "vmx" used 
in vmx.c. People will get used to it.

