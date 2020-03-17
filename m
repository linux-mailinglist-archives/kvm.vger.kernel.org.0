Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4038C188C85
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 18:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgCQRvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 13:51:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:28246 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgCQRvM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 13:51:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584467472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NZ3YXnH035CTgn/zabaWGPAuRHjg1vJA7HJMRtIfZdc=;
        b=Ur/B8w9j/pP+z+vs9/gZv3I8Low6Ejxn8Rkc0cBBwl+m1tp/JHJFzjFjNGPik970Q37Vdb
        vhYGbJxswPCQIg4hzP0LwfABkIkMAwjXmc2ul+SPC5qL953UurncEgT6zjVY8+fBejpSBs
        WLAwb8NyDfnU9ZVo7STF8QF+8e94R4o=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-T2y2ooJ8N3Wot2sDzCy46g-1; Tue, 17 Mar 2020 13:51:10 -0400
X-MC-Unique: T2y2ooJ8N3Wot2sDzCy46g-1
Received: by mail-wr1-f72.google.com with SMTP id s4so5634468wrb.19
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 10:51:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NZ3YXnH035CTgn/zabaWGPAuRHjg1vJA7HJMRtIfZdc=;
        b=TTvfsD4rKYU85iAiK29sSA1F1dhteXlVPfzz9cG9bxlNEwZ3fjNs1RQ//GAYVZwUAj
         Fm2mFMeUYNDzc/5+M1llBTmVUZIN+/PbKR91nNVhSXjIuxWPoRrRJS3BUzO2kVDU0JvG
         EaxA/5EYH4WsG6VK3zwrdRzPWITKXKUJYaZ31TZOuZgZFWQnrdKbKbuudPL97VQFVJpP
         6gxsjCpEBbfhCk/zCz9yP+CMPqcYid6DqkDxd6ip3CQvro+a+rplUkBoLs0EXYvZRCf+
         6HsjrhBBBjmwHV8ZoCzXTEfE1E5ZeUflvFe3DhXUn3yaKwMGBopSe70KnPdxIkj/QN/Z
         4KAQ==
X-Gm-Message-State: ANhLgQ1Pvdtdd0aTfWc0hq7kjd+WoHwyyyjFGNO5ONIMcW0We4I92jPB
        XPknssuPRGdBD8ve6Xb67g0cEqn32wTsqQH7FjQaaDMNfniuEbMl4URp4XzAFnvP7gMHVGonHMq
        KqIemjVircDox
X-Received: by 2002:adf:fa0e:: with SMTP id m14mr208075wrr.80.1584467469290;
        Tue, 17 Mar 2020 10:51:09 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsrEmzQtkhsbsRI8q8d2+zIRnyDx4qEt4scrdo92VR8I8ZYDCuTn48J7V4PwNyy4YhlkH+msQ==
X-Received: by 2002:adf:fa0e:: with SMTP id m14mr208055wrr.80.1584467469016;
        Tue, 17 Mar 2020 10:51:09 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.227])
        by smtp.gmail.com with ESMTPSA id g2sm5832166wrs.42.2020.03.17.10.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 10:51:07 -0700 (PDT)
Subject: Re: [PATCH 10/10] KVM: VMX: Convert vcpu_vmx.exit_reason to a union
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
 <20200312184521.24579-11-sean.j.christopherson@intel.com>
 <87eetwnxsu.fsf@vitty.brq.redhat.com>
 <20200317052821.GP24267@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4b38ad68-b6fe-0087-25f6-7820588de94d@redhat.com>
Date:   Tue, 17 Mar 2020 18:51:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200317052821.GP24267@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/20 06:28, Sean Christopherson wrote:
>>>  
>>> +union vmx_exit_reason {
>>> +	struct {
>>> +		u32	basic			: 16;
>>> +		u32	reserved16		: 1;
>>> +		u32	reserved17		: 1;
>>> +		u32	reserved18		: 1;
>>> +		u32	reserved19		: 1;
>>> +		u32	reserved20		: 1;
>>> +		u32	reserved21		: 1;
>>> +		u32	reserved22		: 1;
>>> +		u32	reserved23		: 1;
>>> +		u32	reserved24		: 1;
>>> +		u32	reserved25		: 1;
>>> +		u32	reserved26		: 1;
>>> +		u32	enclave_mode		: 1;
>>> +		u32	smi_pending_mtf		: 1;
>>> +		u32	smi_from_vmx_root	: 1;
>>> +		u32	reserved30		: 1;
>>> +		u32	failed_vmentry		: 1;
>> Just wondering, is there any particular benefit in using 'u32' instead
>> of 'u16' here?
> Not that I know of.  Paranoia that the compiler will do something weird?

Since we have an "u32 full" it makes sense to have u32 here too, it
documents that we're matching an u32 field in the other side of the union.

Paolo

