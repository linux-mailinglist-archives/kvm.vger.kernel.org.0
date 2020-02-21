Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B231682BB
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 17:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgBUQFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 11:05:05 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38494 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728130AbgBUQFE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 11:05:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582301103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b/XFBGDvO3UXFNECW6P4x7ADbFivKxUA9DrB33OKpco=;
        b=LrGOaPZZi+0r6jMswW8Kg3U+hUtKwG2LoeAK9htl6eR/aT8DoHOzHwhyJroOnm0UW88klz
        CJKsyLw+8pFuqa6EKcBknGT8wQ8uonSu+si3RIWhpuN27edA+28NkfuBHugULODvSuY25U
        A2nUMugumoZ9fZNzPRWR/b4YDgY24iY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-VLwmia8RN-eCpjy3yLpDzw-1; Fri, 21 Feb 2020 11:05:01 -0500
X-MC-Unique: VLwmia8RN-eCpjy3yLpDzw-1
Received: by mail-wm1-f72.google.com with SMTP id p2so799070wmi.8
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 08:05:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b/XFBGDvO3UXFNECW6P4x7ADbFivKxUA9DrB33OKpco=;
        b=duYo/JDCwLd7QuyMPZDratdurZqmlKjX0NDoBsY+DXDBsXZJgaHEyPEEpH+C5eD23f
         7G5CtnmQmqsZnW8fKeps9wCVBThtGB2vu70vH7amejhwv3aPtdAJraU1t5qz01NLtLAY
         7eBKOyhSqfymK4xwBDRNWZR4MTbmu+n7sp/yRGugSKaRCJwUQDiKhtDCGYNVaUiwS0t+
         lXLUSKO68DTg1i0MTNrQc8V6UVgnvRRZ3wk4xGqSvRG89x/un5XOIxVSV1UoaKJqZACt
         +Pt4quKCUUq/mWyFOMVRUujQFpoV2b5RPT7fps5/RNIi4HIOVf/EDqrxxHZGj/Ifuuaf
         8CUQ==
X-Gm-Message-State: APjAAAXzyeOwKVWqFMAexKss8Ge7RP/11fuAVRMlmT09mynzo1GjsY5n
        hsGDzQfuAPXx24pANwWzrHlvXxmPpfiRB3qQBU1G+LIuTdxHes+QJEF07IgYR0TS9yFiaGSylOY
        5bIbZ0m5Z742p
X-Received: by 2002:adf:c453:: with SMTP id a19mr49870871wrg.341.1582301097213;
        Fri, 21 Feb 2020 08:04:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqxcNZy47AONFyMZVt1Po1fABbweri3/gLj6WIymqQWTWEqb3bitDkuCMdiuyDTbVITIsZ7gWA==
X-Received: by 2002:adf:c453:: with SMTP id a19mr49870335wrg.341.1582301089399;
        Fri, 21 Feb 2020 08:04:49 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id 25sm4424881wmi.32.2020.02.21.08.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 08:04:48 -0800 (PST)
Subject: Re: [PATCH] kvm: x86: svm: Fix NULL pointer dereference when AVIC not
 enabled
To:     Alex Williamson <alex.williamson@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joro@8bytes.org,
        jon.grimm@amd.com
References: <1582296737-13086-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20200221083934.3ed38014@x1.home>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bad78ab6-45b6-5d8d-be36-2ff18a5373a2@redhat.com>
Date:   Fri, 21 Feb 2020 17:04:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200221083934.3ed38014@x1.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/02/20 16:39, Alex Williamson wrote:
> On Fri, 21 Feb 2020 08:52:17 -0600
> Suravee Suthikulpanit <suravee.suthikulpanit@amd.com> wrote:
> 
>> Launching VM w/ AVIC disabled together with pass-through device
>> results in NULL pointer dereference bug with the following call trace.
>>
>>     RIP: 0010:svm_refresh_apicv_exec_ctrl+0x17e/0x1a0 [kvm_amd]
>>
>>     Call Trace:
>>      kvm_vcpu_update_apicv+0x44/0x60 [kvm]
>>      kvm_arch_vcpu_ioctl_run+0x3f4/0x1c80 [kvm]
>>      kvm_vcpu_ioctl+0x3d8/0x650 [kvm]
>>      do_vfs_ioctl+0xaa/0x660
>>      ? tomoyo_file_ioctl+0x19/0x20
>>      ksys_ioctl+0x67/0x90
>>      __x64_sys_ioctl+0x1a/0x20
>>      do_syscall_64+0x57/0x190
>>      entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> Investigation shows that this is due to the uninitialized usage of
>> struct vapu_svm.ir_list in the svm_set_pi_irte_mode(), which is
>> called from svm_refresh_apicv_exec_ctrl().
>>
>> The ir_list is initialized only if AVIC is enabled. So, fixes by
>> adding a check if AVIC is enabled in the svm_refresh_apicv_exec_ctrl().
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=206579
>> Fixes: 8937d762396d ("kvm: x86: svm: Add support to (de)activate posted interrupts.")
>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> Cc: Alex Williamson <alex.williamson@redhat.com>
>> ---
>>  arch/x86/kvm/svm.c | 3 +++
>>  1 file changed, 3 insertions(+)
> 
> Works for me, thanks Suravee!
> 
> Tested-by: Alex Williamson <alex.williamson@redhat.com>
> 
>>
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 19035fb..1858455 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -5222,6 +5222,9 @@ static void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>>  	struct vmcb *vmcb = svm->vmcb;
>>  	bool activated = kvm_vcpu_apicv_active(vcpu);
>>  
>> +	if (!avic)
>> +		return;
>> +
>>  	if (activated) {
>>  		/**
>>  		 * During AVIC temporary deactivation, guest could update
> 

Thanks to both of you.  I'll get it to Linus next Monday.

Paolo

