Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839A6674707
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjASXOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjASXNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:13:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DD71BD4
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674169624;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OzQ8d1jXdJYzLh2FRotyWLcD3ZyAJ/HLipvCJpGF0Y8=;
        b=V0VrJ/UXtOLpArVihApQXV3GoWSw9g/SCVHDX/BqmfT7y9wSeyUNCpobzMia0wLatADR5q
        m7lL2/3p7It4zFsPaX+Zf9J6mGH6jQfcV6R3QttStx48v3Z/F0VkPINuMPig4VRvzr5mba
        CVtxELMlmvtuqsYuDnQvOcaw9We1/s4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-UKGCTogHM4yg4Ko8tyN4xQ-1; Thu, 19 Jan 2023 18:07:02 -0500
X-MC-Unique: UKGCTogHM4yg4Ko8tyN4xQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75A75830F4F;
        Thu, 19 Jan 2023 23:07:01 +0000 (UTC)
Received: from [10.64.54.98] (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1CB12166B2A;
        Thu, 19 Jan 2023 23:06:54 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 4/4] KVM: Improve warning report in
 mark_page_dirty_in_slot()
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, corbet@lwn.net,
        james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, ricarkol@google.com,
        eric.auger@redhat.com, yuzhe@nfschina.com, renzhengeek@gmail.com,
        ardb@kernel.org, peterx@redhat.com, shan.gavin@gmail.com
References: <20230116040405.260935-1-gshan@redhat.com>
 <20230116040405.260935-5-gshan@redhat.com> <Y8bBzKF17IdZP9eF@google.com>
 <d8e63ad9-e0e3-dbb1-b646-a1b5771d4c4b@redhat.com>
 <Y8lfdgcjLvtgII2a@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <4bc6857d-662c-cee4-01af-c441fb4ed623@redhat.com>
Date:   Fri, 20 Jan 2023 10:06:52 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y8lfdgcjLvtgII2a@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 1/20/23 2:19 AM, Sean Christopherson wrote:
> On Thu, Jan 19, 2023, Gavin Shan wrote:
>> On 1/18/23 2:42 AM, Sean Christopherson wrote:
>>> On Mon, Jan 16, 2023, Gavin Shan wrote:
>>>> There are two warning reports about the dirty ring in the function.
>>>> We have the wrong assumption that the dirty ring is always enabled when
>>>> CONFIG_HAVE_KVM_DIRTY_RING is selected.
>>>
>>> No, it's not a wrong assumption, becuase it's not an assumption.  The intent is
>>> to warn irrespective of dirty ring/log enabling.  The orignal code actually warned
>>> irrespective of dirty ring support[1], again intentionally.  The
>>> CONFIG_HAVE_KVM_DIRTY_RING check was added because s390 can mark pages dirty from
>>> an worker thread[2] and s390 has no plans to support the dirty ring.
>>>
>>> The reason for warning even if dirty ring isn't enabled is so that bots can catch
>>> potential KVM bugs without having to set up a dirty ring or enable dirty logging.
>>>
>>> [1] 2efd61a608b0 ("KVM: Warn if mark_page_dirty() is called without an active vCPU")
>>> [2] e09fccb5435d ("KVM: avoid warning on s390 in mark_page_dirty")
>>>
>>
>> Thanks for the linker. I was confused when looking at the code, but now it's clear to
>> me. Thanks for your explanation. How about to add a comment there?
>>
>>    /*
>>     * The warning is expected when the dirty ring is configured,
>>     * but not enabled.
>>     */
> 
> That's not correct either.  By design, the warning can also fire if the dirty ring
> is enabled.  KVM's rule is that writes to guest memory always need to be done in
> the context of a running vCPU, with the recently added exception of
> kvm_arch_allow_write_without_running_vcpu().  That intent of the warning is to
> enforce that rule regardless of the state of the VM.
> 
> Concretely, I think you can just drop patches 3 and 4, and just fix the arm64 issues.
> 

Right, the warning report is still expected when dirty ring is enabled. My attempt
was to have comment for the confused case. Anyway, it's not a big deal. I will drop
PATCH[3] and PATCH[4] in v2.

Thanks,
Gavin

