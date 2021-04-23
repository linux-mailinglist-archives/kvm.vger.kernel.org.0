Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E19368DA5
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 09:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240868AbhDWHJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 03:09:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52769 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbhDWHJg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 03:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619161740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q8ibsUJr2Xw/0Bx+47uUdT7BpjL9CbRIh33qYka8yhk=;
        b=G63DP9uNTp1EdHBbtthf0ZcBi3qp0brUoYzACYBg1UqxQVvmo4qAZv+GxzfLQJqrTvDRLZ
        r0ecJlY7Pax0uZpNV/S6ryCxs078lJ5UNgktz1j5tJqZthgV1MC9GicA6aKzQDCrK67ydv
        5MITLMRsBDxP7nZ8tG86s1OByUYDxmg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-Ajmon8ElO2eRHuH2cZVIyA-1; Fri, 23 Apr 2021 03:08:58 -0400
X-MC-Unique: Ajmon8ElO2eRHuH2cZVIyA-1
Received: by mail-ej1-f72.google.com with SMTP id x21-20020a1709064bd5b029037c44cb861cso8032755ejv.4
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 00:08:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q8ibsUJr2Xw/0Bx+47uUdT7BpjL9CbRIh33qYka8yhk=;
        b=SqJBEQOZEEqFqOEpPiJdTZL+u/n8nYwf+5QfZBZGryjFkgSIiemVvb23wg+Y8TBh6v
         46EdkUh7EZg/0V8Qj2s18JQqUvCbU86rxGFjCrqpgwHQnD682PMf1f1PWjsInSallKln
         Y1V+t2t4SobYZi6pK0Ov+aUfvYNzho0U92auNOQlCh2wVwNRkaeJAPIlnJvLVP2avEuD
         yadA+F0lzfPKr3DakkLTeBn428L+v8BHyFSOHcpVcMvx8S5PVX8P2fY2R/PmMNSLoJkA
         WmTqelHYYi+hDFBWiaAWEBI2uMj9veKk38kJZyuCrHB/KCVDpmyAXwdsipvKV+oedQCI
         /CxA==
X-Gm-Message-State: AOAM532wQrUmjdlrYDDwSRB+HWKG9N92TIpZddd9U6LVKq1vpKU0sFjn
        ntX3+1pFXy81PaVPcuPde86Xw4PCBM2wD/hJGy4g81thjs9u/BDZ8zG6L4HE6uri5lWlOofRfOl
        1NzLaU/nn8BI+
X-Received: by 2002:a17:906:8407:: with SMTP id n7mr2602602ejx.264.1619161737479;
        Fri, 23 Apr 2021 00:08:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKqvDTxTMHU32SuNhtPSengJjdOtcKbAFGUrVKJrR2v+QuY2jmt97ToVycVtIsglBSI71ryw==
X-Received: by 2002:a17:906:8407:: with SMTP id n7mr2602582ejx.264.1619161737244;
        Fri, 23 Apr 2021 00:08:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p4sm3890045edr.43.2021.04.23.00.08.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 00:08:56 -0700 (PDT)
Subject: Re: [PATCH v5 03/15] KVM: SVM: Disable SEV/SEV-ES if NPT is disabled
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wei Huang <wei.huang2@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210422021125.3417167-1-seanjc@google.com>
 <20210422021125.3417167-4-seanjc@google.com>
 <5e8a2d7d-67de-eef4-ab19-33294920f50c@redhat.com>
 <YIGhC/1vlIAZfwzm@google.com>
 <882d8bb4-8d40-1b4d-0742-4a4f2c307e5b@redhat.com>
 <YIG8Ythi0UIbO+Up@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0a00ee34-965a-0ee1-1e2c-7fda8e21ec9e@redhat.com>
Date:   Fri, 23 Apr 2021 09:08:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YIG8Ythi0UIbO+Up@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 20:11, Sean Christopherson wrote:
>> Yes, you're right.  NPT is easy but we would have to guess what the spec
>> would say about MAXPHYADDR, while nNPT would require the stacking of a PML5.
>> Either way, blocking KVM is the easiest thing todo.
> How about I fold that into the s/lm_root/pml4_root rename[*]?  I.e. make the
> blocking of PML5 a functional change, and the rename an opportunistic change?
> 
> [*]https://lkml.kernel.org/r/20210318201131.3242619-1-seanjc@google.com
> 

Yes, that's a good plan.  Thanks,

Paolo

