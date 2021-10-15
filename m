Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6616142FA85
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 19:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242196AbhJORuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 13:50:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242259AbhJORuS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 13:50:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634320091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Zx3QxbiVEuPANTUXByKBFYol9oS003tMx/6Xs2/A9c=;
        b=FAbD7sPN5gUj94l6iK7E7Ajv6X7zMMrYmHwkhGgAeizgLeBO26kaMcESnY6utzMhyOxjDJ
        zkY3p0s20flVn9vgbvUUUI5Q5polL61cDN+7kGLeco6XApeE2xNvsKtHjJKK89ivbRew6n
        Perx4RcxLeT5ChNL4UQkGVwmCxYxh1I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-u91_vnPBP3-cmyKLLSGgJg-1; Fri, 15 Oct 2021 13:48:09 -0400
X-MC-Unique: u91_vnPBP3-cmyKLLSGgJg-1
Received: by mail-ed1-f70.google.com with SMTP id h19-20020aa7de13000000b003db6ad5245bso8959823edv.9
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 10:48:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8Zx3QxbiVEuPANTUXByKBFYol9oS003tMx/6Xs2/A9c=;
        b=d/XCQhjRNTY9ZCm5qpsVq9Y1apjthFGiM7pVH44soe9HilLZrvtQeFGU2XT+VJoN8S
         FgI5BmRHrW6UpNlEi3f8CV0GOKTSUSKyLhNxGRmPaX1kPprINL2CqBAZC2oB0YvTVP/F
         SXYtHI6UMJEHOkXCOD5OH68KDIvxxI9IwGKNSQ9dNVxb7GOWLNNQmUd8Rqj0ro8mXWLo
         nRGv0/k/On/E8zf996rxcARRLN5TJ1De8sScdikGDNbNLNpSq8DVKa9rgvNCz7m1nPI4
         Fzf8Dmt4hbcJBlkMBQC/O934VliywPbudV+uh4nRRqGb1Yf2aoAR8cCPsYg5UlnicVUe
         /Qog==
X-Gm-Message-State: AOAM530RW9W36uYa9q7EWpaK9s2IVv2XhFufFz+Mi6gmRCpzbg/EL72f
        hjCp486pdeU+m+6B6a93xVAf2UaIUV2Hse9zeHAg1YX6eYtFUnHTh7G3Ow+AsRdDbQirzBHo+/L
        YqUkFXcOdUlLq
X-Received: by 2002:a17:906:af49:: with SMTP id ly9mr8398344ejb.479.1634320088532;
        Fri, 15 Oct 2021 10:48:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxN8zHTsa2avoK79t+VzDxFG17YeNaDYgRUaBIbvox/PBiiKKv/pjM+2il7eq6d78TEsKK1A==
X-Received: by 2002:a17:906:af49:: with SMTP id ly9mr8398318ejb.479.1634320088336;
        Fri, 15 Oct 2021 10:48:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t19sm4729162ejb.115.2021.10.15.10.48.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 10:48:07 -0700 (PDT)
Message-ID: <163c7948-f41d-986d-871b-9689995ba282@redhat.com>
Date:   Fri, 15 Oct 2021 19:48:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: replace large kvmalloc allocation with vmalloc
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
References: <20211015165519.135670-1-pbonzini@redhat.com>
 <YWm6KcNvaHDMhfsG@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YWm6KcNvaHDMhfsG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/21 19:28, Sean Christopherson wrote:
>>   	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
>>   		slot->arch.gfn_track[i] =
>> -			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
>> -				 GFP_KERNEL_ACCOUNT);
>> +			vcalloc(npages, sizeof(*slot->arch.gfn_track[i]));
> This loses the memcg accounting, which is somewhat important for the theoretical
> 4MiB allocations:-)

True, and in fact 4 MiB is not so theoretical.

> Maybe split out the introduction of vcalloc() to a separate patch (or two) and
> introduce additional helpers to allow passing in gfp_t to e.g. __vzalloc()?

Yes, this is what actually slowed me down this week.This is the bare 
minimum that I can send to Linus right now to avoid the WARN.

I have patches to clean all of this up, but they will have to go throw 
Andrew Morton; he will decide whether to throw them in 5.15 or go 
through stable, but anyway 5.16.1 or .2 should have the accounting back 
at most.

Paolo

