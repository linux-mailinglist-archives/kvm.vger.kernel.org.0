Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7AD17AABF
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 17:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgCEQnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 11:43:51 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49415 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgCEQnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 11:43:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583426629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BhhISddobKRvxCyVQfFxQKYUaxrCs/nqVOLHMdfl6w4=;
        b=gCp9ZlI1pRK6Srcadn0YBN30dOFAjXdKTHLLXNTbyJWnD7fY7jzqmMy33ijfvqOx+PWHKc
        mlPdDpy2a+B9a+P5eNISyvjkMa4fPZEG6VOlvoC1SMH1lez0wQqDHx1Uy8tvZILaWwBVaU
        TKwmF7ev6P6bB6su8eiNzSbAneCmzM4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-HyWYf0v4MbOAw7t5cr1opg-1; Thu, 05 Mar 2020 11:43:48 -0500
X-MC-Unique: HyWYf0v4MbOAw7t5cr1opg-1
Received: by mail-wr1-f71.google.com with SMTP id u18so2506632wrn.11
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 08:43:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BhhISddobKRvxCyVQfFxQKYUaxrCs/nqVOLHMdfl6w4=;
        b=G1davdUxjd4RbQI4EArtbO6qp2FNNk3YmE+BQEKmrelmBIeT7jmwHgRk4hlctlvDqO
         6eiodt6GwXhIt1PvQwbO45352eEjsPFAKgeu9eSjDMeR2fxW/qGRRrv2TRRpFhZ1vKvr
         Jj1Ya+zfAnWkTduXfv5ZBiNu2wdE/kLTOKU0GAkNgxngvlbGBrpNPLqyT858F/H7+oY0
         LK3TVlBf7M0jJ86gXOGtxJD8M1CDoOOoE7wA39wBQt4PsRUqWMlVUzlPitJxBI9n+gDV
         QvU/gpeEcY3FPObVjS20wIZ3WT8qShM4ZuZ7RUaNFela+meKlUU6EXAsWseu3cPY2SaO
         eJZA==
X-Gm-Message-State: ANhLgQ344hyab5vwAJorsuOssX/LrtOaOg5WZcZd917DUuiCDLFEqlUz
        E5WdBelTaZQy6V3i/zV5DTWWHi6G6uAaHSaj/znICBSefCynDUh/TDL1fQvwE5Zo0DDy7e2m0U2
        4lfGcY7BU/c4j
X-Received: by 2002:adf:d4c7:: with SMTP id w7mr1907319wrk.20.1583426627093;
        Thu, 05 Mar 2020 08:43:47 -0800 (PST)
X-Google-Smtp-Source: ADFU+vudytWymUEkci84I/WZSseDXaNi0Bm39I2yP2Zha9wZsreA/1rCNGnBV4PyCOqqQHgKHjKo+Q==
X-Received: by 2002:adf:d4c7:: with SMTP id w7mr1907297wrk.20.1583426626866;
        Thu, 05 Mar 2020 08:43:46 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id g129sm11491735wmg.12.2020.03.05.08.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 08:43:46 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: x86: VMX: untangle VMXON revision_id setting
 when using eVMCS
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200305100123.1013667-1-vkuznets@redhat.com>
 <20200305100123.1013667-3-vkuznets@redhat.com>
 <20200305154130.GB11500@linux.intel.com>
 <8736amg3q5.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4e4218fe-2409-558f-8d0f-aae18e8d4651@redhat.com>
Date:   Thu, 5 Mar 2020 17:43:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8736amg3q5.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/20 17:34, Vitaly Kuznetsov wrote:
>> I'd strongly prefer to keep the alloc_vmcs_cpu() name and call the new enum
>> "vmcs_type".  The discrepancy could be resolved by a comment above the
>> VMXON_REGION usage, e.g.
>>
>> 		/* The VMXON region is really just a special type of VMCS. */
>> 		vmcs = alloc_vmcs_cpu(VMXON_REGION, cpu, GFP_KERNEL);
> I have no strong opinion (but honestly I don't really know what VMXON
> region is being used for), Paolo already said 'queued' but I think I'll
> send v2 with the suggested changes (including patch prefixes :-)

Yes, please do.

Paolo

