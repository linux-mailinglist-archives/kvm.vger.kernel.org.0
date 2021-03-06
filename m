Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CB032F923
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 10:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhCFJ1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Mar 2021 04:27:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54830 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229701AbhCFJ1D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 6 Mar 2021 04:27:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615022821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e5O/LpcxMMdquDVNYjg2lF3OYstWuYNsRwulGsHakfc=;
        b=blbWV8cU3prZoc4ZWouEcs9cXArZ+MHCuP/f7ygGNUs7gR4wPjxq6LGluQaxsr6zqttR9k
        Z4d3umG2MkTAZFEtpBGO6FnQz3my3ee33zMY1nG5Rs+9hpYRXYH+9EUsTk2em58wGJlwbk
        iraBKs4ayU8TddT1ynP8QoSC07EIWYI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-FH9W9zl-PSKWMH9tX-Zmog-1; Sat, 06 Mar 2021 04:26:59 -0500
X-MC-Unique: FH9W9zl-PSKWMH9tX-Zmog-1
Received: by mail-wr1-f72.google.com with SMTP id r12so2268194wro.15
        for <kvm@vger.kernel.org>; Sat, 06 Mar 2021 01:26:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e5O/LpcxMMdquDVNYjg2lF3OYstWuYNsRwulGsHakfc=;
        b=fOzb72KGtQ85yGsIK/qfpGoa0i/eAWEFP2N0qcx5ZzHDp6GGMyoB9ObDjE1T7Qrv4v
         NP70NbtzcyuKtyhoabyziIH4T09kRyd9WMA2dwDDmDFeSFTsrTpTkgGtthjhjgZsSSu3
         Jf36Z4LvsmbIQ/WtRL8L9BdpQmqFBsKUuOPddAWZhjTTNTaqnrrJ/BYcE5vAV9CmZpSl
         ycM4zLUzxa9n2nIk+Acc4ODiaXrVa2yGsYBuQgh6pKKQbG2EgBmOHy+IoTdLbivaoARQ
         slxQLD+cXIKuXx2nZyTAQANxeNJvkKlhAvifJY3ERymjtKThJmvQZp3zNtHvDZXBRqWj
         7NCA==
X-Gm-Message-State: AOAM532tcczjRXkJKiUJWgVQ3Gp9e41/f0TKTTnB+U1lKEuk1XVodsuh
        jTpZc119y+xCRvbmXQi0kDWxKg+nw68rV/ZtwzhXVruj3+wAJQvIh2tmIROa1/rdqYb+pKKGNcj
        l7conuu7SlG1v
X-Received: by 2002:a5d:4002:: with SMTP id n2mr3398524wrp.148.1615022818013;
        Sat, 06 Mar 2021 01:26:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw9/q/9S+4sLU2rGSr6w+yDYGAFfQ+D9c80lfJ+5k/SiOHKsOSUvmPuATMc8lsg7cJLJrdpgA==
X-Received: by 2002:a5d:4002:: with SMTP id n2mr3398516wrp.148.1615022817864;
        Sat, 06 Mar 2021 01:26:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id o14sm7710140wri.48.2021.03.06.01.26.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Mar 2021 01:26:57 -0800 (PST)
Subject: Re: [PATCH 03/28] KVM: nSVM: inject exceptions via
 svm_check_nested_events
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com,
        Jim Mattson <jmattson@google.com>
References: <YELdblXaKBTQ4LGf@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fc2b0085-eb0f-dbab-28c2-a244916c655f@redhat.com>
Date:   Sat, 6 Mar 2021 10:26:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YELdblXaKBTQ4LGf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/03/21 02:39, Sean Christopherson wrote:
> Unless KVM (L0) knowingly wants to override L1, e.g. KVM_GUESTDBG_* cases, KVM
> shouldn't do a damn thing except forward the exception to L1 if L1 wants the
> exception.
> 
> ud_interception() and gp_interception() do quite a bit before forwarding the
> exception, and in the case of #UD, it's entirely possible the #UD will never get
> forwarded to L1.  #GP is even more problematic because it's a contributory
> exception, and kvm_multiple_exception() is not equipped to check and handle
> nested intercepts before vectoring the exception, which means KVM will
> incorrectly escalate a #GP->#DF and #GP->#DF->Triple Fault instead of exiting
> to L1.  That's a wee bit problematic since KVM also has a soon-to-be-fixed bug
> where it kills L1 on a Triple Fault in L2...

I agree with the #GP problem, but this is on purpose.  For example, if 
L1 CPUID has MOVBE and it is being emulated via #UD, L1 would be right 
to set MOVBE in L2's CPUID and expect it not to cause a #UD.  The same 
is true for the VMware #GP interception case.

Maxim is also working on this, the root cause is that 
kvm_multiple_exception()'s escalation of contributory exceptions to #DF 
and triple fault is incorrect in the case of nested virtualization.

Paolo

