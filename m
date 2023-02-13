Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1AE694EF8
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 19:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjBMSMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 13:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjBMSMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 13:12:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B96193D0
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 10:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676311873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=btENug+HNZMgsHueHpBS/EHiJOI8qsodxlQ5SGXxzpc=;
        b=GL6A2KK/AUCQ9IzJRqne3ntUzVXcwr4RLeu/O3rYTevx6Fk8aKUBOU09/D+NO99xyZ0Ac1
        sgZD6eJUBvRf1LB2RsLb6LcnLgQxLaWxu+iLCob1cwMlyRVYU+OYKBVxrY9/gI60mK9+Ny
        3NuXmDIPwq1Jr8GPLQFiAjSN9sk5wsY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-90-x0GdombOM8-sacPomOQePA-1; Mon, 13 Feb 2023 13:11:12 -0500
X-MC-Unique: x0GdombOM8-sacPomOQePA-1
Received: by mail-ed1-f69.google.com with SMTP id p36-20020a056402502400b004aab6614de9so8086574eda.6
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 10:11:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=btENug+HNZMgsHueHpBS/EHiJOI8qsodxlQ5SGXxzpc=;
        b=CvW8KZ3RzgmoYAPbRYpO3nhu0CrTEoqEcFPt0X0tTKzz+7GPmx2E4DRsRCFLd2PcHx
         IZ2N/vM5PMUNOOL9FzDdb/k4wGAtshH7spe0Ol2fCgcmmmUKtRomnJ3rRwktWIz1OWGq
         ES6UMPwk1eV+2iX/oTa3i9/yH/468p7OywW3zewi2l1O4FLyUxBPDDewXQgoWBdU/G1s
         MekL6Of1x1og32O+UABBVyYRWARmLjnGQ+/jMA7YAYkKCK36YAIX8EGeKN2ZaTubXRcc
         72tvQaROHprwlsVdbO+J4Iq3eMOLYstS4Fpk3s74zJlNRBy8yB/l7qJhY67tpnuXM/pP
         NxBw==
X-Gm-Message-State: AO0yUKWNw0EtaWQxH4owoZ+KqquzTpv2nEhOZUlBzpJuM86rRaXUSICl
        HbFgI9X7rN5XixjZ94PGFzq2LQHPNcjpN7im7xEHSJgdvv8nug+TDsAHY0+BwBOTTeOolQMo1YV
        Gv1FDkEPFi9pc
X-Received: by 2002:a50:c007:0:b0:4ac:d2b3:b724 with SMTP id r7-20020a50c007000000b004acd2b3b724mr1951822edb.27.1676311871479;
        Mon, 13 Feb 2023 10:11:11 -0800 (PST)
X-Google-Smtp-Source: AK7set/2IiZueKNbZNJhFBMmU9KPuO2w+xCZ6ywEnPIDIDhVsdPwjrHBnwQ6oyt753mIL9L3C/68yg==
X-Received: by 2002:a50:c007:0:b0:4ac:d2b3:b724 with SMTP id r7-20020a50c007000000b004acd2b3b724mr1951812edb.27.1676311871311;
        Mon, 13 Feb 2023 10:11:11 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id u12-20020a50950c000000b004aac44175e7sm6942278eda.12.2023.02.13.10.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 10:11:10 -0800 (PST)
Message-ID: <35ff8f48-2677-78ea-b5f3-329c75ce65c9@redhat.com>
Date:   Mon, 13 Feb 2023 19:11:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tianyu Lan <ltykernel@gmail.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
References: <43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com>
 <Y+p1j7tYT+16MX6B@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: "KVM: x86/mmu: Overhaul TDP MMU zapping and flushing" breaks SVM
 on Hyper-V
In-Reply-To: <Y+p1j7tYT+16MX6B@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/23 18:38, Sean Christopherson wrote:
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

My reading of the spec[1] is that HV_X64_NESTED_ENLIGHTENED_TLB will 
cause svm_flush_tlb_current to behave (in Intel parlance) as an INVVPID 
rather than an INVEPT.  So svm_flush_tlb_current has to be changed to 
also add a call to HvCallFlushGuestPhysicalAddressSpace.  I'm not sure 
if that's a good idea though.

First, that's a TLB shootdown rather than just a local thing; 
flush_tlb_current is supposed to be relatively cheap, and there would be 
a lot of them because of the unconditional calls to 
nested_svm_transition_tlb_flush on vmentry/vmexit.

Second, while the nCR3 matches across virtual processors for SVM, the 
(nCR3, ASID) pair does not, so it doesn't even make much sense to do a 
TLB shootdown.

Depending on the performance results of adding the hypercall to 
svm_flush_tlb_current, the fix could indeed be to just disable usage of 
HV_X64_NESTED_ENLIGHTENED_TLB.

Paolo

[1] 
https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/nested-virtualization

