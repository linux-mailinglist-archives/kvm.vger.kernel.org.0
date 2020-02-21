Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B81167E59
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 14:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgBUNUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 08:20:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40896 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727352AbgBUNUt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 08:20:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582291247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V45FPE8E/uSpIv1R1RMAVvbVJqCO9c9QhM88Z/L7IQI=;
        b=KIpZPdVDzq24mU96yfjTo9tDyfyQtHZ1MKWslRUY/IFkzs+g579CK/jK3S/8ieXwvlqWjC
        GX8mM2Ly5rslWweW2Sf+m9DE6PHNyDkOsk+ZucS1hyxTi+8Ir59oHObX154Mw1D5k5YGBG
        M2UxrIauZ48/M8/0xLdOesrRPlooyXo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-pl1hUi6LPBCpEc7kxuJvHQ-1; Fri, 21 Feb 2020 08:20:45 -0500
X-MC-Unique: pl1hUi6LPBCpEc7kxuJvHQ-1
Received: by mail-wr1-f70.google.com with SMTP id u8so1009069wrp.10
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 05:20:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V45FPE8E/uSpIv1R1RMAVvbVJqCO9c9QhM88Z/L7IQI=;
        b=qV5VNLpbAC+pxKz5uudflhyzIJ8JxgbiR0nWRIRl2Sz3RBKlSIn3Qq3FS27uXkMSBF
         JgG/Enww5weHXBdSQWq1kAsG/dbO2Y8onPp1VUbuM2ApI0XLO4AbWo5GfvJYdFdnOELA
         IQt8rx5SnhdJ95Mh7zAWMb5Ols53oj0O75oS0So3dEOb7S9GyeK2I8NUSCeQhF2eKwyi
         cKWviQaZQD2ePk+Kp8fpaceXceKr61kS8MYGuLdef4lu94lNg5FdRMNIhhfN51A54uIU
         rDs4Cc+U1MHk6Gd8r9kq7LT5Fe8YXj97L+tZMfTcfp60ZU9FyRqzwR6JPx/PgIwu5TiX
         xCaw==
X-Gm-Message-State: APjAAAX6WPUx2MDTdnz6rI2m2g/sQP4xm108/m2hNBFG0Gv/LiLxpCtN
        g9IFjHyL4wpfm61ebgQpZ3cQTRANjRou9Eh1ctjmIZ0v/Z1KKJtlQo3E86KKBAU3ajzPVIxVhhx
        IMbzoSIPP0+HK
X-Received: by 2002:a05:6000:1208:: with SMTP id e8mr51009111wrx.351.1582291244366;
        Fri, 21 Feb 2020 05:20:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqwXgzt5blvA3I2e+h/HOQivRsOOnvHTyqfqBCG2YxfjYwz0b8N/EbQuo8Mp5i1XvX2dQVzGhg==
X-Received: by 2002:a05:6000:1208:: with SMTP id e8mr51009081wrx.351.1582291244058;
        Fri, 21 Feb 2020 05:20:44 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id m9sm3971187wrx.55.2020.02.21.05.20.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 05:20:43 -0800 (PST)
Subject: Re: [PATCH 00/10] KVM: x86: Clean up VMX's TLB flushing code
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200220204356.8837-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <efb07c80-58ab-c3ce-1fed-832475190add@redhat.com>
Date:   Fri, 21 Feb 2020 14:20:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200220204356.8837-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/02/20 21:43, Sean Christopherson wrote:
> This series is technically x86 wide, but it only superficially affects
> SVM, the motivation and primary touchpoints are all about VMX.
> 
> The goal of this series to ultimately clean up __vmx_flush_tlb(), which,
> for me, manages to be extremely confusing despite being only ten lines of
> code.
> 
> The most confusing aspect of __vmx_flush_tlb() is that it is overloaded
> for multiple uses:
> 
>  1) TLB flushes in response to a change in KVM's MMU
> 
>  2) TLB flushes during nested VM-Enter/VM-Exit when VPID is enabled
> 
>  3) Guest-scoped TLB flushes for paravirt TLB flushing
> 
> Handling (2) and (3) in the same flow as (1) is kludgy, because the rules
> for (1) are quite different than the rules for (2) and (3).  They're all
> squeezed into __vmx_flush_tlb() via the @invalidate_gpa param, which means
> "invalidate gpa mappings", not "invalidate a specific gpa"; it took me
> forever and a day to realize that.
> 
> To clean things up, handle (2) by directly calling vpid_sync_context()
> instead of bouncing through __vmx_flush_tlb(), and handle (3) via a
> dedicated kvm_x86_ops hook.  This allows for a less tricky implementation
> of vmx_flush_tlb() for (1), and (hopefully) clarifies the rules for what
> mappings must be invalidated when.
> 
> Sean Christopherson (10):
>   KVM: VMX: Use vpid_sync_context() directly when possible
>   KVM: VMX: Move vpid_sync_vcpu_addr() down a few lines
>   KVM: VMX: Handle INVVPID fallback logic in vpid_sync_vcpu_addr()
>   KVM: VMX: Fold vpid_sync_vcpu_{single,global}() into
>     vpid_sync_context()
>   KVM: nVMX: Use vpid_sync_vcpu_addr() to emulate INVVPID with address
>   KVM: x86: Move "flush guest's TLB" logic to separate kvm_x86_ops hook
>   KVM: VMX: Clean up vmx_flush_tlb_gva()
>   KVM: x86: Drop @invalidate_gpa param from kvm_x86_ops' tlb_flush()
>   KVM: VMX: Drop @invalidate_gpa from __vmx_flush_tlb()
>   KVM: VMX: Fold __vmx_flush_tlb() into vmx_flush_tlb()
> 
>  arch/x86/include/asm/kvm_host.h |  8 +++++++-
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/svm.c              | 14 ++++++++++----
>  arch/x86/kvm/vmx/nested.c       | 12 ++++--------
>  arch/x86/kvm/vmx/ops.h          | 32 +++++++++-----------------------
>  arch/x86/kvm/vmx/vmx.c          | 26 +++++++++++++++++---------
>  arch/x86/kvm/vmx/vmx.h          | 19 ++++++++++---------
>  arch/x86/kvm/x86.c              |  8 ++++----
>  8 files changed, 62 insertions(+), 59 deletions(-)
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

