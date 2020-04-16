Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A5B1ACD64
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 18:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410760AbgDPQQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 12:16:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40125 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388603AbgDPQOD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 12:14:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587053642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OKFPJKDrwMxxZMkSgpW+lREO9oEC/Q2oH5KaLd5HI80=;
        b=ftVaZBsYpSA0amitXhN4QUevQOeGxlyxVSjXVHhQi4Z8QDdTkaYWkHZTJRClHktD/ABUPY
        2s6pT5AVtzb8zc18PrIfgrq4O0airaeu56wz6wxOhFP9mxneAHUk2WMi8fY3+xxKCVMM3O
        bVBD6VvZKofTJe1JF1Qe7+xwutTJY5U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-7WFMK5N4MgOp1EFFq5MTHg-1; Thu, 16 Apr 2020 12:14:00 -0400
X-MC-Unique: 7WFMK5N4MgOp1EFFq5MTHg-1
Received: by mail-wm1-f69.google.com with SMTP id v185so653545wmg.0
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 09:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OKFPJKDrwMxxZMkSgpW+lREO9oEC/Q2oH5KaLd5HI80=;
        b=e2IHnWTwGqDRqRHxC2r+XkR/bwEQgA549vpMQhfCj+r8GXXl4A3kpGtTD9gnI8u4/q
         JVByKIt4xjQUIvvT8VZWzemYcOTKWAloPBmxt733bPOhOWQ391Fs4f5SsMxVXrejc3Pk
         vUYL8v8oR1jQK1zkKwsRIxUWJ5fp2idwF/SarGU9dqd6Bnsx84t3dtoPbzdyW+HxYiXe
         2NSF06GueIKRm4vSuoK+kL7jNq3C2soLwTbWHh7dtKR43WDQylTTLp+FqyGezcLbIOT9
         KB0O84akO+Q9kjU7dCAHH1Tk5M9G2dZHmJoAcH7MhabvDCZyFEazbwCdTjq1zZ4uWaRS
         /IRA==
X-Gm-Message-State: AGi0PuZ8JVM0MD/YaB/wTsVaagHosmpVhwOeLlsbdCA90TR6ywwNcTZX
        nOLprTuXEtCAu6d33SJSGdGVLzOvu/Fib+WXFmZFfUAAO7BfV5SbzUzcHO4RowHxqMOUAIErlss
        i/nzFYnvuO4Oo
X-Received: by 2002:a1c:3c87:: with SMTP id j129mr5448724wma.157.1587053639123;
        Thu, 16 Apr 2020 09:13:59 -0700 (PDT)
X-Google-Smtp-Source: APiQypLVD0YkhLXYDXAiRXOPwWtPmpI2Nv3hFjWcnfOySET6aVt92wHyVi3nCwJ97+O/lVbgF5c6Ww==
X-Received: by 2002:a1c:3c87:: with SMTP id j129mr5448709wma.157.1587053638870;
        Thu, 16 Apr 2020 09:13:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399d:3ef7:647c:b12d? ([2001:b07:6468:f312:399d:3ef7:647c:b12d])
        by smtp.gmail.com with ESMTPSA id c190sm4232376wme.10.2020.04.16.09.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 09:13:58 -0700 (PDT)
Subject: Re: [PATCH] KVM: Remove async parameter for hva_to_pfn_remapped()
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200416155903.267414-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7f576843-6b64-6561-05ee-730326249409@redhat.com>
Date:   Thu, 16 Apr 2020 18:13:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200416155903.267414-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/20 17:59, Peter Xu wrote:
> We always do synchronous fault in for those pages.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
> 
> Or, does it make sense to allow async pf for PFNMAP|IO too?  I just
> didn't figure out why not...
> ---

I think async pf would use FAULT_FLAG_ALLOW_RETRY |
FAULT_FLAG_RETRY_NOWAIT.  On failure you would set *async = true.

In practice I don't think fixup_user_fault is likely to do anything
asynchronously.

Paolo

