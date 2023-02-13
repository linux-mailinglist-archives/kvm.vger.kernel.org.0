Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFA8694E61
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 18:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjBMRto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 12:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjBMRtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 12:49:43 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19467CA3E;
        Mon, 13 Feb 2023 09:49:43 -0800 (PST)
Received: from [192.168.2.1] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3ABE420C8B73;
        Mon, 13 Feb 2023 09:49:41 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3ABE420C8B73
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1676310582;
        bh=ZbGl/VBo0r7/1sjPPHzx3Hl70sd5RKWcyoeUqOe+iBI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hfWI6KV4HncZEJ5DCEXmnE5OdPaA84w+pmbonGEjze0pbNwQhw1mGWDhj/xNdWA3j
         Er6nwKnONl54+vDmJUKxa0XBF1Bkl+W1a61JIAJGHMcafvGjnTv8nDdYU/iG6YH9Jl
         3oSG0MA1iwOQ+p0n9ta1Wmjg0Yeu9Su0ErOSvd6g=
Message-ID: <e4aadbce-20a2-47c5-8f4a-f491b4d1182a@linux.microsoft.com>
Date:   Mon, 13 Feb 2023 18:49:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: "KVM: x86/mmu: Overhaul TDP MMU zapping and flushing" breaks SVM
 on Hyper-V
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tianyu Lan <ltykernel@gmail.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
References: <43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com>
 <Y+p1j7tYT+16MX6B@google.com>
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <Y+p1j7tYT+16MX6B@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-20.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/2023 18:38, Sean Christopherson wrote:
> On Fri, Feb 10, 2023, Jeremi Piotrowski wrote:
>> Hi Paolo/Sean,
>>
>> We've noticed that changes introduced in "KVM: x86/mmu: Overhaul TDP MMU
>> zapping and flushing" conflict with a nested Hyper-V enlightenment that is
>> always enabled on AMD CPUs (HV_X64_NESTED_ENLIGHTENED_TLB). The scenario that
>> is affected is L0 Hyper-V + L1 KVM on AMD,
> 
> Do you see issues with Intel and HV_X64_NESTED_GUEST_MAPPING_FLUSH?  IIUC, on the
> KVM side, that setup is equivalent to HV_X64_NESTED_ENLIGHTENED_TLB.
> 

I couldn't reproduce this in any way on Intel. I can test again tomorrow, and see what
the differences are in the ftrace.

>> IIRC, KVM side always uses write-protected translation table to shadow and so
>> doesn't meet such issue with the commit.
> 
> This is incorrect.  KVM write-protects guest PTEs that point at 2MiB and larger
> pages, but 4KiB PTEs are allowed to become "unsync" and KVM's shadow NPT/EPT entries
> are synchronized with the guest only on a relevant TLB.
> 
> I know of at least one non-KVM-hypervisor TDP TLB flushing bug that was found
> specifically because of KVM's infinite software TLB.  That doesn't mean that this
> isn't a KVM bug, I just want to call out that KVM-on-KVM should be capable of
> detecting KVM-as-L1 TLB bugs, at least on Intel/VMX/EPT (KVM's nested SVM support
> is woefully naive from a TLB flushing perspective and synchronizes guest PTEs
> before every nested VM-Entry to L2).
