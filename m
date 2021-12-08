Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164B346CFCC
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 10:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhLHJPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 04:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhLHJPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 04:15:45 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD741C061746;
        Wed,  8 Dec 2021 01:12:13 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y13so5950200edd.13;
        Wed, 08 Dec 2021 01:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GDLoQdTrc8Yo+1DH3zW/AaXhqmiChAytiXvcT8C2fo4=;
        b=ZUqNfSm4LTQTtusxsYZMMRnLfnHibU0oXLC0KW3HAncUBfNTbtiJL8pEoQLH0e2nwn
         owuypPr0clsqchOKvu86wKVK7URTkzVzaeRLmNGWPR+jsPl8mR5kgetBDnpfOzbDqxim
         7CksUcL5D/ORLepXPzIJ1XUfsT7IoYqWNzq8EGug/tjhOFckZoeZyheG4rJr870yksS0
         j3Lq2Yup/ltwgtf1NjzovpBXGhgg7crBPjIEgaMxyeyfuirbr+/KBQsQKJ0Ml5pcKYMX
         oRLgb0byaC3Gyy0G6bD/Qg8HuhCdifmzNV1bpYIPm2dLdUm7eeEMyjHmPWcyvWMX6DAX
         a+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GDLoQdTrc8Yo+1DH3zW/AaXhqmiChAytiXvcT8C2fo4=;
        b=rIl/o8aNXGgp7DcsGwQ29T3X6yVdTUs9rmOT00ttPoZB7qhtRDLDdg3cl8xDdbNmfu
         xsbuRTutaA3VAtAYH6PpR/u3ErBfNcTBokN5XrMdrZxNvtV1eCDRxPH9S6mDbSVZI7Ui
         Pu1fhvqsoFTu6DXsDVd869TICoDKi/oA+DUyKyraQn4UXevM/6/vfjGu/4WSUXIPJQBp
         gmivKsuxLDsU+eBGx7YwP3FObcbJRQ2xLKrOIM/1Mr0o4bxw3gZwZ63XAKQNvb4fKec2
         /uV6HCE/ClOX1eFNu00Vucs8j463pbDSmnZZoCv2HiR0xX1eiryeB0gnnaXGPE8x5Ix4
         m5nQ==
X-Gm-Message-State: AOAM530UfRFAH41OgBX+GiSfe4kD/ANGSMLlqYgLqJEk+I2aD4Df+0UC
        BpZUX1GTFpxQSfqLwtoRJdhlna/5LN0=
X-Google-Smtp-Source: ABdhPJwglkW9prE2/GqJ8CEoDyK1Ari6QN4ViqIrhpwUDazB8a1rDXpDxWVbX4kCZoUqgMlPIgCuYA==
X-Received: by 2002:a17:907:728a:: with SMTP id dt10mr5895530ejc.526.1638954732268;
        Wed, 08 Dec 2021 01:12:12 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id ar2sm1140904ejc.20.2021.12.08.01.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 01:12:11 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <69b91477-5c9a-2335-fc74-37ae125116e5@redhat.com>
Date:   Wed, 8 Dec 2021 10:12:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 3/4] KVM: X86: Handle implicit supervisor access with SMAP
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211207095039.53166-1-jiangshanlai@gmail.com>
 <20211207095039.53166-4-jiangshanlai@gmail.com> <Ya/XoYTsEvkPqRuh@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ya/XoYTsEvkPqRuh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/21 22:52, Sean Christopherson wrote:
>> -	unsigned long not_smap = (cpl - 3) & (rflags & X86_EFLAGS_AC);
>> +	u32 not_smap = (rflags & X86_EFLAGS_AC) & vcpu->arch.explicit_access;
> I really, really dislike shoving this into vcpu->arch.  I'd much prefer to make
> this a property of the access, even if that means adding another param or doing
> something gross with @access (@pfec here).
> 

Well, we already have something gross going on with the pfec.  Maybe we 
should add separate constants for the index into mmu->permissions.

Paolo
