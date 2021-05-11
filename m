Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDBA37ACB0
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhEKRJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:09:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231512AbhEKRJT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 13:09:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620752892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y/O0ej2NcOY86TRKShKCBi1CW9Ph72+cFotAeokd3co=;
        b=Q+9eGSZwpJDU8sCH/mDeqj9xFD8L1HrUZ7dlQeKqm6mfaQe2oAweFt2DyKCsDKRFyTCiGa
        Zp0XDyXFmoIFjv4Hu/FAyRZfy2d7lmA1TlXS43DhyAnNJvk41Ivc19l5iA/USAKF3Vz7fT
        saRB6b7qNCOQafUJWpzAvI8O7DJigR8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-xgq0eoy-ORu51uvQZYANBQ-1; Tue, 11 May 2021 13:08:10 -0400
X-MC-Unique: xgq0eoy-ORu51uvQZYANBQ-1
Received: by mail-ej1-f69.google.com with SMTP id z15-20020a170906074fb029038ca4d43d48so6238343ejb.17
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y/O0ej2NcOY86TRKShKCBi1CW9Ph72+cFotAeokd3co=;
        b=YOVSCvlVfcBZPEXgzvdpYJCfi3y3CeygLvhPXY1vxl9j4T4wWp+sfdimTcz4zrBNpj
         rPyKEe4yBXjrD7+f+WVqxZeb410BEl+Kd8aBrb2LysdhGPEL095ZjHq5tdC2N/Lc92Ga
         DyFrgRyetygjP8/DyqU0SZi0DtdVOGoLPhGew5N+6MrT3YfdC1baMjVI7y+8RSNbXKtC
         OeG3qTMW+BiHpJM04UEimhMGlUMGKtTJLRGZ+7VOrgnPGJ6RfEpu2ZDcFC5Wcq8kiyC7
         A01/jRL9YXFvRZ3VnkxMA79CGq7utDzARaCr6BTI2ejyO1p6kUwj3yGnlyiwoMtuYvHb
         8fHA==
X-Gm-Message-State: AOAM530w3SoF6jwsbu9nUpM/jLV5smIYPX3MFQtXXQDg05q9b/9wkCpN
        YnwD/q6/CiZ/3m8Zf2fu0r1r7Su5M972NlDqIY2bNMOAd2W/r0B5em/CcUUUqhfyuMloPLOw1tm
        JoetS0VB8Ha6YqvBO8HeZ0Zma1Rrbri+UqEE2Gg4FiMufVlb+th2bRFW3TGufqsoC
X-Received: by 2002:a17:907:d27:: with SMTP id gn39mr32747814ejc.389.1620752889137;
        Tue, 11 May 2021 10:08:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHL65UmHr+40ZydsbeP1XaOSmKOo1QTVQipNWaixaGRIOiaAE8Cs988k5gMsXqRa0g9r0dzg==
X-Received: by 2002:a17:907:d27:: with SMTP id gn39mr32747752ejc.389.1620752888909;
        Tue, 11 May 2021 10:08:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id sb20sm12114420ejb.100.2021.05.11.10.08.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 10:08:08 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: use wrpkru directly in
 kvm_load_{guest|host}_xsave_state
To:     Dave Hansen <dave.hansen@intel.com>, Jon Kohler <jon@nutanix.com>
Cc:     Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Juergen Gross <jgross@suse.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210511155922.36693-1-jon@nutanix.com>
 <ab09f739-89fa-901d-9ee3-27a6c674d9a0@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <95947b5c-9add-e5d3-16a5-a40ab6d24978@redhat.com>
Date:   Tue, 11 May 2021 19:08:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <ab09f739-89fa-901d-9ee3-27a6c674d9a0@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/05/21 18:45, Dave Hansen wrote:
> On 5/11/21 8:59 AM, Jon Kohler wrote:
>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
>> index b1099f2d9800..20f1fb8be7ef 100644
>> --- a/arch/x86/include/asm/pgtable.h
>> +++ b/arch/x86/include/asm/pgtable.h
>> @@ -151,7 +151,7 @@ static inline void write_pkru(u32 pkru)
>>   	fpregs_lock();
>>   	if (pk)
>>   		pk->pkru = pkru;
>> -	__write_pkru(pkru);
>> +	wrpkru(pkru);
>>   	fpregs_unlock();
>>   }
> 
> This removes the:
> 
> 	if (pkru == rdpkru())
> 		return;
> 
> optimization from a couple of write_pkru() users:
> arch_set_user_pkey_access() and copy_init_pkru_to_fpregs().
> 
> Was that intentional?  Those aren't the hottest paths in the kernel, but
> copy_init_pkru_to_fpregs() is used in signal handling and exeve().

Yeah, you should move it from __write_pkru() to write_pkru() but not 
remove it completely.

Paolo

