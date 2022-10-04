Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAE35F4AAD
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 23:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiJDVHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 17:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJDVHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 17:07:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EF66AE9D;
        Tue,  4 Oct 2022 14:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664917668; x=1696453668;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f+bN7q0J598sgXYDRSmOgQEwWqaQ4PKzdTfPJ/hdZRg=;
  b=n6C0xOU7NZCTX+r0iIhz4jEDEAo+EdjKN1SHJj9+1uv1LklASa3C32Qe
   E5caVZMKcnOavlvHy8OmMrZENZJDG8EJvJ0YDtjQQN0zRH2gNhSs6os3N
   CG6IXjq3QoZEN8OVIwXnuHwMwXki3hw9tvJh6kxe5WFpQ+cQifbCp9VJk
   mzuaY02QeJ96yZPP5dV2IscK12hkpKsetNGPDgB3kiqAygYVlnxhzS1/v
   fLSX2RUBJbVH8vqxfwe+ZHOx6wPc7R1XAELWYQEGrTLiQmf78NV8BevAv
   MZU8TUz9+/BIm2+FRuveXV86dfnSe+tcBEJ18WVH8zCEtxM+vtkj7NT/N
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="300626789"
X-IronPort-AV: E=Sophos;i="5.95,158,1661842800"; 
   d="scan'208";a="300626789"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 14:07:47 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="869174199"
X-IronPort-AV: E=Sophos;i="5.95,158,1661842800"; 
   d="scan'208";a="869174199"
Received: from samrober-mobl.amr.corp.intel.com (HELO [10.209.85.136]) ([10.209.85.136])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 14:07:46 -0700
Message-ID: <c7a0b0f1-5a74-7f8c-b707-bce8086bc4c7@intel.com>
Date:   Tue, 4 Oct 2022 14:07:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Finish removing MPX from arch/x86?
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>
References: <547a1203-0339-7ad2-9505-eab027046298@intel.com>
 <CALMp9eRTp9Jemy91o0S9Fz4JYFdQ5rM36g4uWhp5LsncCQHRwA@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CALMp9eRTp9Jemy91o0S9Fz4JYFdQ5rM36g4uWhp5LsncCQHRwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/4/22 11:21, Jim Mattson wrote:
> On Tue, Oct 4, 2022 at 10:45 AM Dave Hansen <dave.hansen@intel.com> wrote:
>>
>> We zapped the userspace MPX ABIs and most of its supporting code in here:
>>
>>         45fc24e89b7c ("x86/mpx: remove MPX from arch/x86")
>>
>> But, the XSAVE enabling and KVM code were left in place.  This let folks
>> at least keep running guests with MPX.
>>
>> It's been a couple of years and I don't think I've had a single person
>> opine about the loss of MPX.  Intel also followed through and there's no
>> MPX to be found on newer CPUs like my "Tiger Lake" 11th Gen Intel(R)
>> Core(TM) i7-1165G7.
>>
>> Is it time to zap MPX from arch/x86/kvm/?
> 
> Until Google Cloud retires all of our MPX-capable hardware, we will
> require MPX support in KVM.
> 
> Removing that support would leave VMs with MPX enabled in XCR0 with
> nowhere to go.

Is this because you migrate guest VMs between hosts?  A _potential_ VM
migration target host is ineligible if it has a subset of the features
of the source host?

Would it be _possible_ to leave existing VMs alone, but to stop
enumerating MPX to newly-created VMs?  I don't know how long-lived your
VMs are, but I'm hoping that the ones that know about MPX will all die
naturally of old age at some point.
