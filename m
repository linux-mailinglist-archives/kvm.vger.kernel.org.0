Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C26369B53
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 22:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhDWUcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 16:32:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25236 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243982AbhDWUb6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 16:31:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619209881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jcf2LEXehLSaHuRbbU6aSop037iG6kk2SicpUgepmck=;
        b=GkPMXhpemav/NxNMXP3rP6FCCY04u1cnFYLuG/qG/yZu8FiqHLuJYzNVuxh1PhRZAr3ZOO
        11vpCuKDOsuQYRcSDam8x59LD4Zxldi7/Nid3WmmPO1ZCs5o1U7ln/jGtDu/FX19wgbV5K
        Gb+uDx1lHmUaCaGjgDxcYtZgq8kU2WM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-xi-mI8-nPfWvPr1C_dC0tw-1; Fri, 23 Apr 2021 16:31:20 -0400
X-MC-Unique: xi-mI8-nPfWvPr1C_dC0tw-1
Received: by mail-ed1-f71.google.com with SMTP id i18-20020aa7c7120000b02903853032ef71so10265880edq.22
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 13:31:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jcf2LEXehLSaHuRbbU6aSop037iG6kk2SicpUgepmck=;
        b=uX7lNKYZpG8K/qkZlwq8KgtP2KcvUA7fFu6i3dHoqtP1f8d++nRM/Bvgrg+ruY6tmQ
         9pEvVDhrl28y1F7ye2eQ26Ru63aXV6qojS0EhruOhZ3x+w3zns14Qr6kKCFC6ekr9k/n
         XuosTyUV0lzVQuct0oh2bFhdD+RdvVDDiuM8Y3z2pZh7N/XwaTOn9WT1QM9kokmUfnQP
         C67/nJgzWeh1+p0y6RbLQdf4lO2xIqPznfxXX4BAYJcBZomncmPZNnpvxbJw6cKSLbgY
         5pO8bNfWn84qYO66CiFW7MBFJTnwJEZaQK2pLcDD72JidAnY8No/s7Krzjf4VixthCoj
         DPvg==
X-Gm-Message-State: AOAM532saBjjaRCqv9h4d8f4toMNDjMD1hK23maidKNCDnVfZLRjWPff
        4pbzaAULAoLVzERujmUQwUdENekatqdUiAyQ02dN0m0jLsZODlczNSR+jN8IdvFC5SLh9a77AA7
        0ioujTPKo5HG7
X-Received: by 2002:a17:907:217b:: with SMTP id rl27mr6138257ejb.359.1619209878870;
        Fri, 23 Apr 2021 13:31:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwciz/tDTxfTcWj+PwlDLoBMVw5prnVLKwQRNUPB5jmuPYHde3766XeC0C78AFui9uDWA2JaA==
X-Received: by 2002:a17:907:217b:: with SMTP id rl27mr6138233ejb.359.1619209878637;
        Fri, 23 Apr 2021 13:31:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id p9sm5591251edu.79.2021.04.23.13.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 13:31:17 -0700 (PDT)
Subject: Re: [PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and
 IOPM bitmaps
To:     Sean Christopherson <seanjc@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-4-krish.sadhukhan@oracle.com>
 <YH8y86iPBdTwMT18@google.com>
 <058d78b9-eddd-95d9-e519-528ad7f2e40a@oracle.com>
 <cb1bb583-b8ac-ab3a-2bc3-dd3b416ee0e7@oracle.com>
 <YIG6B+LBsRWcpftK@google.com>
 <a9f74546-6ab7-88fc-83d1-382b380f6264@oracle.com>
 <YILuJohrTE+P06tt@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d6bf17a8-029a-37ec-ab96-5e2bebedb88a@redhat.com>
Date:   Fri, 23 Apr 2021 22:31:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YILuJohrTE+P06tt@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/21 17:56, Sean Christopherson wrote:
> On Thu, Apr 22, 2021, Krish Sadhukhan wrote:
>> On 4/22/21 11:01 AM, Sean Christopherson wrote:
>>> 		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
>>>
>>> 		if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4)) <- This reads vmcb12
>>> 			return false;
>>>
>>> 		svm->nested.msrpm[p] = svm->msrpm[p] | value; <- Merge vmcb12's bitmap to KVM's bitmap for L2
> 
> ...
>   
>> Getting back to your concern that this patch breaks
>> nested_svm_vmrun_msrpm().  If L1 passes a valid address in which some bits
>> in 11:0 are set, the hardware is anyway going to ignore those bits,
>> irrespective of whether we clear them (before my patch) or pass them as is
>> (my patch) and therefore what L1 thinks as a valid address will effectively
>> be an invalid address to the hardware. The only difference my patch makes is
>> it enables tests to verify hardware behavior. Am missing something ?
> 
> See the above snippet where KVM reads the effectively vmcb12->msrpm to merge L1's
> desires with KVM's desires.  By removing the code that ensures
> svm->nested.ctl.msrpm_base_pa is page aligned, the above offset calculation will
> be wrong.

In fact the kvm-unit-test you sent was also wrong for this same reason 
when it was testing addresses near the end of the physical address space.

Paolo

