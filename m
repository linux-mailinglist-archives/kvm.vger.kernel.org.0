Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D18530D4A6
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 09:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhBCIGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 03:06:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232169AbhBCIGI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 03:06:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612339482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+oG1iepI5e+YoRSW15dR/Lg6jPhIDaE96zUxkSlCngY=;
        b=OcYuoymMmPzvZXB9CsrD2Dtumsbz6uzxWN+NAMZ0pSwW6spKmv1snEhYwEIkKUJPyDl4xB
        S11xf7nYA8sQVXLDVLDsq3UVw2uLJqSt5L+euPu8iq240kHsEYeOnfcu2skQcuSf6wiB1u
        OLjXgJ9LwRWwMBefsAG0sR6qbe1eWSM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-lgxjXYABMrecDAEwTXS5KA-1; Wed, 03 Feb 2021 03:04:40 -0500
X-MC-Unique: lgxjXYABMrecDAEwTXS5KA-1
Received: by mail-ed1-f71.google.com with SMTP id w14so3495275edv.6
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 00:04:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+oG1iepI5e+YoRSW15dR/Lg6jPhIDaE96zUxkSlCngY=;
        b=Oyds3MC7ddlYHWTk93VimqS0/q/Bs4wFDBwkksveWPAgJ3krSupBR2t+OEeLbVpczO
         J282GNjaj7Wa4Nr49lQ6pblcV73JOv9sKTDArxMCh2c8QIQUSmYLvmxLxqHc7azKr1pK
         Hqo6rlfEa9wjE87b/nKMqYZYIGpU45fSjrXU2tplRBJNL+eTHBC8zNJvFrrQoON/66K4
         cszz+Ld4YtRlj7AYrK5P4wdn2Pr2bN784FzMZIo4YwRR4/NKz2ML1W84WF9ShLN4fb0C
         YUiPqMyTsXIMtPfRBmZC895nDZRq2mD5CCyvReyQfoZ5W649ReAHjgy4p/XQMNeA4hyd
         x/qw==
X-Gm-Message-State: AOAM530Ls+HFLpSEXXG2Y5l1JuhBi2/iR1DN+PHh4KhwAAozP7HS4zE8
        Zxj9ZNAmJKa3hm6EGJMtJuTESlU2MfY2yHpptCWCK22a3+AKuqE8aootkDcZA7SyUidOVrf5EEf
        +59jNfd7HtDtl
X-Received: by 2002:a17:906:9249:: with SMTP id c9mr2055017ejx.416.1612339479658;
        Wed, 03 Feb 2021 00:04:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9ieYS7R8bKJ//fPnjyvJXLt8OWDR0VRxfS3newcnOgK3FN3F9pIY3diGwH0IR9kZERgI0pA==
X-Received: by 2002:a17:906:9249:: with SMTP id c9mr2054998ejx.416.1612339479416;
        Wed, 03 Feb 2021 00:04:39 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o11sm483181eds.19.2021.02.03.00.04.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 00:04:38 -0800 (PST)
Subject: Re: [PATCH v4 1/3] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
To:     Sean Christopherson <seanjc@google.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210202190126.2185715-1-michael.roth@amd.com>
 <20210202190126.2185715-2-michael.roth@amd.com> <YBnwaiy8L/O0PCrR@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <509b0e43-7f15-53bc-ab08-e27edbb855f8@redhat.com>
Date:   Wed, 3 Feb 2021 09:04:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBnwaiy8L/O0PCrR@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 01:38, Sean Christopherson wrote:
>>   
>> +static inline void vmload(hpa_t pa)
> This needs to be 'unsigned long', using 'hpa_t' in vmsave() is wrong as the
> instructions consume rAX based on effective address.  I wrote the function
> comment for the vmsave() fix so that it applies to both VMSAVE and VMLOAD,
> so this can be a simple fixup on application (assuming v5 isn't needed for
> other reasons).
> 
> https://lkml.kernel.org/r/20210202223416.2702336-1-seanjc@google.com
> 

Yup, fixed.

Paolo

