Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CE9726B4E
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 22:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbjFGUYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 16:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbjFGUYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 16:24:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1C92D44;
        Wed,  7 Jun 2023 13:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686169415; x=1717705415;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yx3Hykw4LiAqDclb6vXT/niFHdtBDleUGtGrsmgGkKc=;
  b=DThYMbXF8Zln/lKTBCd7MeTWiEKYv1iyavT/gunhwON9Bfe5Outc6+Xh
   eA9OD0YmL/clOHij4WPcWvZ/VBTpHwkxatWUgsA1gIXZPGuoHpBWi/eO7
   IMjqy+xJ9LJFBzqXlSKp/rHIJjYFCBHjTgp0kjQGROnSe63f8QG6DV4fh
   yj7pbqODwD1QzD1ONrfvQg3dkofSwUZggTi2SmZqz+2csd59soLw1JdQ6
   EZ5bpMaomvJJhlpgwPoT3RX5/6OVoqtCbs8ilqfawB3mK6mp6ZkbonYi2
   hWuhhFMIIi+O+4aPkk8G2lIyo3DiHzO5ei3P7C/k+x4hPq1PGirgyNkNl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="355955975"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="355955975"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 13:22:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="1039828552"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="1039828552"
Received: from vsmyers-mobl2.amr.corp.intel.com (HELO [10.212.146.233]) ([10.212.146.233])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 13:22:35 -0700
Message-ID: <2061ced1-59d7-f21c-490c-b650b7378386@intel.com>
Date:   Wed, 7 Jun 2023 13:22:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, pbonzini@redhat.com,
        david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
 <92e19d74-447f-19e0-d9ec-8a3f12f04927@intel.com>
 <20230607185355.GH2244082@ls.amr.corp.intel.com>
 <f7ef157e-8f26-8d7b-a9b8-cb8de7f7aa2b@intel.com>
 <20230607194721.GI2244082@ls.amr.corp.intel.com>
 <ZIDjx4i2Z/OQgUra@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <ZIDjx4i2Z/OQgUra@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/23 13:08, Sean Christopherson wrote:
>>>>>> The current TDX_MODULE_CALL macro handles neither #GP nor #UD.  The
>>>>>> kernel would hit Oops if SEAMCALL were mistakenly made w/o enabling VMX
>>>>>> first.  Architecturally, there is no CPU flag to check whether the CPU
>>>>>> is in VMX operation.  Also, if a BIOS were buggy, it could still report
>>>>>> valid TDX private KeyIDs when TDX actually couldn't be enabled.
>>>>> I'm not sure this is a great justification.  If the BIOS is lying to the
>>>>> OS, we _should_ oops.
>>>>>
>>>>> How else can this happen other than silly kernel bugs.  It's OK to oops
>>>>> in the face of silly kernel bugs.
>>>> TDX KVM + reboot can hit #UD.  On reboot, VMX is disabled (VMXOFF) via
>>>> syscore.shutdown callback.  However, guest TD can be still running to issue
>>>> SEAMCALL resulting in #UD.
>>>>
>>>> Or we can postpone the change and make the TDX KVM patch series carry a patch
>>>> for it.
>>> How does the existing KVM use of VMLAUNCH/VMRESUME avoid that problem?
>> extable. From arch/x86/kvm/vmx/vmenter.S
>>
>> .Lvmresume:
>>         vmresume
>>         jmp .Lvmfail
>>
>> .Lvmlaunch:
>>         vmlaunch
>>         jmp .Lvmfail
>>
>>         _ASM_EXTABLE(.Lvmresume, .Lfixup)
>>         _ASM_EXTABLE(.Lvmlaunch, .Lfixup)
> More specifically, KVM eats faults on VMX and SVM instructions that occur after
> KVM forcefully disables VMX/SVM.

<grumble> That's a *TOTALLY* different argument than the patch makes.

KVM is being a _bit_ nutty here, but I do respect it trying to honor the
"-f".  I have no objections to the SEAMCALL code being nutty in the same
way.

Why do I get the feeling that code is being written without
understanding _why_, despite this being v11?
