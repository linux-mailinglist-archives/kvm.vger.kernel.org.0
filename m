Return-Path: <kvm+bounces-3853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A73E808754
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 13:06:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 731291C21C79
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 12:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09B139AEB;
	Thu,  7 Dec 2023 12:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="eMsrg0Qm"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31F7AA9
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 04:06:41 -0800 (PST)
Received: from [192.168.178.49] (dynamic-adsl-84-220-28-122.clienti.tiscali.it [84.220.28.122])
	by linux.microsoft.com (Postfix) with ESMTPSA id 610B820B74C0;
	Thu,  7 Dec 2023 04:06:39 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 610B820B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1701950800;
	bh=MRRG7XrBA3BVkAzFjqapTbb/FV4I0PaANAuLuLVvfIs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eMsrg0QmzHKns1Q7ZwIZwQOeFqRTCi/DP176+0fcheV9JO17Ro3sZvOw/tqsEA0UU
	 BS56PJ4eeEcxBqi9KFSYWgULywo+eYvcKnhDUwMcTlWcFwZJhoPwDupPyyo15FaLaW
	 cO+bjfOji/7wZ3DATxkNMApdSmcptIL3ZnFLhjGw=
Message-ID: <ec2e5f33-4168-4d5d-ac11-2a72e78c7482@linux.microsoft.com>
Date: Thu, 7 Dec 2023 13:06:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/16] KVM: x86: Make Hyper-V emulation optional
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Maxim Levitsky <mlevitsk@redhat.com>
References: <20231205103630.1391318-1-vkuznets@redhat.com>
 <20231205103630.1391318-13-vkuznets@redhat.com>
 <46235.123120606372000354@us-mta-490.us.mimecast.lan>
 <878r67mrs4.fsf@redhat.com>
Content-Language: en-US
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <878r67mrs4.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/12/2023 13:36, Vitaly Kuznetsov wrote:
> Jeremi Piotrowski <jpiotrowski@linux.microsoft.com> writes:
> 
>> On Tue, Dec 05, 2023 at 11:36:26AM +0100, Vitaly Kuznetsov wrote:
>>> Hyper-V emulation in KVM is a fairly big chunk and in some cases it may be
>>> desirable to not compile it in to reduce module sizes as well as the attack
>>> surface. Introduce CONFIG_KVM_HYPERV option to make it possible.
>>>
>>> Note, there's room for further nVMX/nSVM code optimizations when
>>> !CONFIG_KVM_HYPERV, this will be done in follow-up patches.
>>>
>>> Reorganize Makefile a bit so all CONFIG_HYPERV and CONFIG_KVM_HYPERV files
>>> are grouped together.
>>>
>>
>> Wanted to test this for the case where KVM is running as a nested hypervisor on
>> Hyper-V but it doesn't apply cleanly - what base did you use? Tried v6.6,
>> v6.7-rc1, and v6.7-rc4.
> 
> Hi Jeremi,
> 
> the base was 'kvm/next' (git://git.kernel.org/pub/scm/virt/kvm/kvm.git,
> 'next' branch):
> 
> commit e9e60c82fe391d04db55a91c733df4a017c28b2f (kvm/next)
> Author: Paolo Bonzini <pbonzini@redhat.com>
> Date:   Tue Nov 21 11:24:08 2023 -0500
> 
>     selftests/kvm: fix compilation on non-x86_64 platforms
> 

Hi Vitaly,

Thanks. Just tested this running in an AMD Hyper-V guest with CONFIG_KVM_HYPERV
unset, and tested nested virtualization - no regressions. You can have my tag:

Tested-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>

Jeremi


