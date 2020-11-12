Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105402B0708
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 14:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgKLNwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 08:52:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728072AbgKLNwI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 08:52:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605189126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ovz0QF/x/uupMiti2X+MXoiJmLsE2F47KX00gjbVesA=;
        b=RuIqfC+sA9aVwJTQ7MSDAviMYOyJhTIb55A6Zsoc3ywpyAZWO5OpzEN7BFcbO7fB3Dh+eo
        wQSAjed4BlkQyHH28hu6yXNoDcZe4tmSJo4lfnXVdNGhcAK0Ce51YG+q91q6z61WSjJfss
        Z8iJ6GijGOBJV3QOu+130eXDom4QB9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-N2MZqoGENgiShZy496AdTQ-1; Thu, 12 Nov 2020 08:52:05 -0500
X-MC-Unique: N2MZqoGENgiShZy496AdTQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C84CD1868423;
        Thu, 12 Nov 2020 13:52:03 +0000 (UTC)
Received: from localhost.localdomain (ovpn-113-46.phx2.redhat.com [10.3.113.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DED96EF5F;
        Thu, 12 Nov 2020 13:52:03 +0000 (UTC)
Subject: Re: [PATCH v3 0/2] KVM: SVM: Create separate vmcbs for L1 and L2
To:     Babu Moger <babu.moger@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Huang2, Wei" <Wei.Huang2@amd.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
References: <20201026174222.21811-1-cavery@redhat.com>
 <75b85cc7-96d9-eab9-9748-715ed951034d@amd.com>
From:   Cathy Avery <cavery@redhat.com>
Message-ID: <062059f4-1d7d-d334-0c95-9ba4fc57706b@redhat.com>
Date:   Thu, 12 Nov 2020 08:52:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <75b85cc7-96d9-eab9-9748-715ed951034d@amd.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

That would be the master branch of 
git://git.kernel.org/pub/scm/virt/kvm/kvm.git where the last commit was 
969df928fee43b4219646a57c7beaccccf2c0635

I was originally working off of the queue branch but there were issues 
with the prior commits passing the various tests.

Cathy

On 11/11/20 4:35 PM, Babu Moger wrote:
> Hi Cathy,
> I was going to test these patches. But it did not apply on my tree.
> Tried on kvm(https://git.kernel.org/pub/scm/virt/kvm/kvm.git) and
> Mainline
> (https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git). What
> is your base tree?
> thanks
> Babu
>
>> -----Original Message-----
>> From: Cathy Avery <cavery@redhat.com>
>> Sent: Monday, October 26, 2020 12:42 PM
>> To: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; pbonzini@redhat.com
>> Cc: vkuznets@redhat.com; Huang2, Wei <Wei.Huang2@amd.com>;
>> mlevitsk@redhat.com; sean.j.christopherson@intel.com
>> Subject: [PATCH v3 0/2] KVM: SVM: Create separate vmcbs for L1 and L2
>>
>> svm->vmcb will now point to either a separate vmcb L1 ( not nested ) or L2 vmcb
>> ( nested ).
>>
>> Changes:
>> v2 -> v3
>>   - Added vmcb switching helper.
>>   - svm_set_nested_state always forces to L1 before determining state
>>     to set. This is more like vmx and covers any potential L2 to L2 nested state
>> switch.
>>   - Moved svm->asid tracking to pre_svm_run and added ASID set dirty bit
>>     checking.
>>
>> v1 -> v2
>>   - Removed unnecessary update check of L1 save.cr3 during nested_svm_vmexit.
>>   - Moved vmcb01_pa to svm.
>>   - Removed get_host_vmcb() function.
>>   - Updated vmsave/vmload corresponding vmcb state during L2
>>     enter and exit which fixed the L2 load issue.
>>   - Moved asid workaround to a new patch which adds asid to svm.
>>   - Init previously uninitialized L2 vmcb save.gpat and save.cr4
>>
>> Tested:
>> kvm-unit-tests
>> kvm self tests
>> Loaded fedora nested guest on fedora
>>
>> Cathy Avery (2):
>>    KVM: SVM: Track asid from vcpu_svm
>>    KVM: SVM: Use a separate vmcb for the nested L2 guest
>>
>>   arch/x86/kvm/svm/nested.c | 125 ++++++++++++++++++--------------------
>>   arch/x86/kvm/svm/svm.c    |  58 +++++++++++-------
>>   arch/x86/kvm/svm/svm.h    |  51 +++++-----------
>>   3 files changed, 110 insertions(+), 124 deletions(-)
>>
>> --
>> 2.20.1


