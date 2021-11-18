Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958B34561F4
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhKRSKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:10:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231377AbhKRSKl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 13:10:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637258860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ky9VfCMdddLinCcImh3pCLGfk11QOxyvTFjuti24tCk=;
        b=O1z4aSUsChdWL6iEp55buTYJVrrpzzgv8zRcy4O06xEoxQ1SA/lNfMSyKMhJaNOC1so1pV
        ZzYeflInn9VSn01UobocIby/MPgpxJz1LU4Ipj7x/AQPYlp+W/u5XCeQthiWStiu9633A3
        5nu1mxkTpZX+FqCs/Z+Uq17JUckpTWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381--RDlEA3pOTOU5rHWG2lLLA-1; Thu, 18 Nov 2021 13:07:37 -0500
X-MC-Unique: -RDlEA3pOTOU5rHWG2lLLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9572C1023F4E;
        Thu, 18 Nov 2021 18:07:35 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B04E5F4ED;
        Thu, 18 Nov 2021 18:07:08 +0000 (UTC)
Message-ID: <12a5ad9a-c1c5-852c-5041-096d2c518f8c@redhat.com>
Date:   Thu, 18 Nov 2021 19:07:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC 11/19] KVM: x86/mmu: Factor shadow_zero_check out of
 make_spte
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-12-bgardon@google.com> <YZW02M0+YzAzBF/w@google.com>
 <YZXIqAHftH4d+B9Y@google.com> <YZaBSf+bPc69WR1R@google.com>
 <db8a2431-8a05-bd50-dd79-74c814c71edd@redhat.com>
 <YZaVKcFoKR4lqDIZ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YZaVKcFoKR4lqDIZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 19:02, Sean Christopherson wrote:
>> but that's not a great name because the former is used also when shadowing
>> EPT/NPT.  I'm thinking of standardizing on "shadow" and "TDP" (it's not
>> perfect because of the 32-bit and tdp_mmu=0 cases, but it's a start).  Maybe
>> even split parts of mmu.c out into shadow_mmu.c.
> But shadow is flat out wrong until EPT and NPT support is ripped out of the "legacy"
> MMU.

Yeah, that's true.  "full" MMU? :)

>> - the two walkers (I'm quite convinced of splitting that part out of struct
>> kvm_mmu and getting rid of walk_mmu/nested_mmu): that's easy, it can be
>> walk01 and walk12 with "walk" pointing to one of them
>
> I am all in favor of walk01 and walk12, the guest_mmu vs. nested_mmu confusion
> is painful.
> 
>> - the two MMUs: with nested_mmu gone, root_mmu and guest_mmu are much less
>> confusing and we can keep those names.
>
> I would prefer root_mmu and nested_tdp_mmu.  guest_mmu is misleading because its
> not used for all cases of sp->role.guest_mode=1, i.e. when L1 is not using TDP
> then guest_mode=1 but KVM isn't using guest_mmu.

Ok, that sounds good too.

Paolo

