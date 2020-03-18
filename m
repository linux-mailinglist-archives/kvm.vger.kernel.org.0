Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D40718A1AA
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 18:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCRRjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 13:39:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:21186 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726506AbgCRRjE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 13:39:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584553143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ltahyOOW3gyw5hu5HKZgwII4enLzMRUQpOYTS+Rs5s=;
        b=FklvOzYNTibxE2f3qRFgl6lzhNdmIMG1/6tXEXjOVfcImOTElNrwxi/xaPxeoCqcg9AmWW
        i65SramMglYPHbUetvxm5SqE7NCNBglgd7xR5l4uBJGH2cfT22Ip3WuGBeXVzheqXZPdwk
        4TyoKobv8qZyAk+UNpbEmr76pwEKhwg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-Z3tSmAQgONm1YBlQomcxlg-1; Wed, 18 Mar 2020 13:39:01 -0400
X-MC-Unique: Z3tSmAQgONm1YBlQomcxlg-1
Received: by mail-wm1-f72.google.com with SMTP id f9so1351032wme.7
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 10:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8ltahyOOW3gyw5hu5HKZgwII4enLzMRUQpOYTS+Rs5s=;
        b=juMhehYotV5ByAIZwmXlkIM5oib6Jjish8Wf3iJrVpXr8nb/TQe4t3j6ktQKsCBtb5
         dp+/75WWu0fHxJxBfBkL8evg+hb1IJQA9IofVdNANs2O6qX4g5hRtBg381sLrSFX5S3p
         QvDBBmqEvt2ygyfA/Cp3M8hO9oTTHZ64GB0uwAZSQ8aLz/O7gqeKUrt7zl8zxuxjKBNt
         jHt2RnURGnQHwIQRYzgXxza2f+7hzfoCw71Mydsry230caHSLNVvW9154pWrHBxWXti8
         BVwO7donrHVCPs93Wn+/m8x7pceXZpFYg2c/l9a7JN0vtPJDcbH00MBCHMOExm0PUpoE
         TD1Q==
X-Gm-Message-State: ANhLgQ38XfLg+03X6EFd57khWWDN+ZTVDWtl06ahgPEYCdAG9Zo7QPMZ
        FFTs6l/+Jbgo6GugJvITYCw9zXARd6MKd1MTZ9XfEFiH0K2LZRgdkVNFDi1H0bH/a8x8qmaUKTC
        V1BTEW63fRUNH
X-Received: by 2002:a05:600c:24c:: with SMTP id 12mr6260269wmj.119.1584553140455;
        Wed, 18 Mar 2020 10:39:00 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuYkHCYYMA4Xp4XlBoTwsVoafCfvFQAPbXylg2R+kbEgu+F7kEaGahXtLtVFBCfm2S5tlQlBQ==
X-Received: by 2002:a05:600c:24c:: with SMTP id 12mr6260237wmj.119.1584553140189;
        Wed, 18 Mar 2020 10:39:00 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id r3sm3775498wrm.35.2020.03.18.10.38.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 10:38:59 -0700 (PDT)
Subject: Re: [PATCH v2 31/32] KVM: nVMX: Don't flush TLB on nested VM
 transition with EPT enabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
 <20200317045238.30434-32-sean.j.christopherson@intel.com>
 <97f91b27-65ac-9187-6b60-184e1562d228@redhat.com>
 <20200317182251.GD12959@linux.intel.com>
 <218d4dbd-20f1-5bf8-ca44-c53dd9345dab@redhat.com>
 <20200318170241.GJ24357@linux.intel.com>
 <3c3a4d9b-b213-dfc0-2857-a975e9c20770@redhat.com>
 <20200318172614.GK24357@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7661081d-6276-6176-dbbb-700aeec656b8@redhat.com>
Date:   Wed, 18 Mar 2020 18:38:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200318172614.GK24357@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/20 18:26, Sean Christopherson wrote:
>>>
>>> 	if (!nested_ept)
>>> 		kvm_mmu_new_cr3(vcpu, cr3, enable_ept ||
>>> 					   nested_cpu_has_vpid(vmcs12));
>>
>> ... which is exactly nested_has_guest_tlb_tag(vcpu).  Well, not exactly
>> but it's a bug in your code above. :)
>
> I don't think it's a bug, it's intentionally different.  When enable_ept=0,
> nested_has_guest_tlb_tag() returns true if and only if L1 has enabled VPID
> for L2 *and* L2 has been assigned a unique VPID by L0.
> 
> For sync purposes, whether or not L2 has been assigned a unique VPID is
> irrelevant.  L0 needs to invalidate TLB entries to prevent resuing L1's
> entries (assuming L1 has been assigned a VPID), but L0 doesn't need to sync
> SPTEs because L2 doesn't expect them to be refreshed.
                ^^
                L1

Yes you're right.  So I would say keep your code, but we can simplify
the comment.  Something like:

/*
 * We can skip the TLB flush if we have EPT enabled (because...)  and
 * also if L1 is using VPID, because then it doesn't expect SPTEs for L2
 * to be refreshed.
 *
 * This is almost the same as nested_has_guest_tlb_tag(vcpu), but here
 * we don't care if L2 has been assigned a unique VPID; L1 doesn't know,
 * and will nevertheless do INVVPID to avoid reuse of stale page
 * table entries.
 */

Nevertheless it's scary in that this is a potential attack vector for
reusing stale L0 SPTEs, so we should make sure it's all properly commented.

Thanks,

Paolo

>> It completely makes sense to use that as the third argument, and while a
>> comment is still needed it will be much smaller.
> Ya, agreed.
> 

