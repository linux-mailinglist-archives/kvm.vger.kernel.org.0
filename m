Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668F31A47CE
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 17:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgDJPR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 11:17:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21715 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726009AbgDJPR2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Apr 2020 11:17:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586531847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lxA/tgR1C4hkGx3HZZll51D+Ssqd304gHaE+7JqW5D4=;
        b=adIolzRXnxT/vyltyeVgIobbrFFViDtxnj0cupJ8QMPbb+K98BIL6NpOAkOg+3kNUxa+kX
        aSWlf9wxj+a6NtPUKquunxJTgiJkBiR4+vLy1X65koXxbVoHexeehglslbVo3ocxSbH6Sh
        i+16bN2OnGYz8sz6hOrjHAuvzbnR7z8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-AJnKwJvKP1m-yENo1iiWXg-1; Fri, 10 Apr 2020 11:17:26 -0400
X-MC-Unique: AJnKwJvKP1m-yENo1iiWXg-1
Received: by mail-wm1-f72.google.com with SMTP id f9so755893wme.7
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 08:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lxA/tgR1C4hkGx3HZZll51D+Ssqd304gHaE+7JqW5D4=;
        b=oY7bm+EXrH3ERXLdauOpS1v/S5hBJQ3qwJTmxA5W9KrO4kDcG8HzHrgZwmCmLtM4pY
         q/f+3914BJqpP+KRBwWoQ6Ea9TR/F3YGm52EDQ6FnpcmleJKu+2CnYrhUWlUTSO6nvw9
         HEuQpN1ivd8pJUdRXl7gGBWg6d6Hxe3MVQFYQ62Nq3iKgQRGcwUvgwbfcgNsKNYqHOaK
         ZIJJTReQac4FC3RJWo7viB51eJ2WRWfIPBqie14PoU2YLjtA8B4F+RW8mPxpCsMmX9eI
         ByYVcMDRNWj4dSdnZdhFaMLRcv9l4A3I7cgHLw3L1Ot1T39K2sF3Y1QZTR+fDR2RMK0Y
         duRw==
X-Gm-Message-State: AGi0PuZFnMng6+5jvGCjlI+qEKg1YxSmJWwqwVFEJrtVjJOOKUkKCIdA
        pHenKhiKzioK8Ljkdt5qqg0JMx3xf8yCBXwdhazifNHEzH/J6uxlsVw7eQv1vfpXv2oYasNDsW7
        a6NnZcTE3fEHR
X-Received: by 2002:a1c:dc8b:: with SMTP id t133mr5656671wmg.117.1586531844663;
        Fri, 10 Apr 2020 08:17:24 -0700 (PDT)
X-Google-Smtp-Source: APiQypJWNqZ9O7KLUo6jbp8USvz8XGxE5RktlTZ/tBRjyLf56EOrhOkXcv6t2w0OjupApH3JE2eFYA==
X-Received: by 2002:a1c:dc8b:: with SMTP id t133mr5656648wmg.117.1586531844436;
        Fri, 10 Apr 2020 08:17:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4b7:b34c:3ace:efb6? ([2001:b07:6468:f312:f4b7:b34c:3ace:efb6])
        by smtp.gmail.com with ESMTPSA id c4sm3266515wmb.5.2020.04.10.08.17.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2020 08:17:23 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: X86: Ultra fast single target IPI fastpath
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
References: <1586480607-5408-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e639e0f6-9393-7a32-9e2d-13725d7d96f8@redhat.com>
Date:   Fri, 10 Apr 2020 17:17:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1586480607-5408-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/04/20 03:03, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> IPI and Timer cause the main MSRs write vmexits in cloud environment 
> observation, let's optimize virtual IPI latency more aggressively to 
> inject target IPI as soon as possible.
> 
> Running kvm-unit-tests/vmexit.flat IPI testing on SKX server, disable 
> adaptive advance lapic timer and adaptive halt-polling to avoid the 
> interference, this patch can give another 7% improvement.
> 
> w/o fastpath -> fastpath            4238 -> 3543  16.4%
> fastpath     -> ultra fastpath      3543 -> 3293     7%
> w/o fastpath -> ultra fastpath      4238 -> 3293  22.3% 
> 
> This also revises the performance data in commit 1e9e2622a1 (KVM: VMX: 
> FIXED+PHYSICAL mode single target IPI fastpath), that testing adds
> --overcommit cpu-pm=on to kvm-unit-tests guest which is unnecessary.
> 
> Tested-by: Haiwei Li <lihaiwei@tencent.com>
> Cc: Haiwei Li <lihaiwei@tencent.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * rebase on latest kvm/queue
>  * update patch description
> 
>  arch/x86/include/asm/kvm_host.h |  6 +++---
>  arch/x86/kvm/svm/svm.c          | 21 ++++++++++++++-------
>  arch/x86/kvm/vmx/vmx.c          | 19 +++++++++++++------
>  arch/x86/kvm/x86.c              |  4 ++--
>  4 files changed, 32 insertions(+), 18 deletions(-)

That's less ugly than I expected. :D  I'll queue it in the next week or
so.  But even though the commit subject is cool, I'll change it to "KVM:
x86: move IPI fastpath inside kvm_x86_ops.run".

Thanks,

Paolo

