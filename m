Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092A421A688
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 20:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgGISBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 14:01:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23387 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726693AbgGISBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 14:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594317669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P+Smn+qbrEaL68M0kp1IAVljg+f544E0Mx1LSyAW08k=;
        b=MSo0ZWXIPQ/g88bBiAPHs3VG/e5d7SbJkHfwnIWkLHD8/HURjbETTO4oHASH4k9FD6s57+
        uZM6eEaSi+V/AGAQajW2jBEM+J7SMtvXVxuGZnXthyz/WEZypo41KArgVoI4lK43sCqFez
        wVVE5wfmuouaUiOA+ZxqtBbOPJ2BUTg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-vV7KdL8_O4ONKYhJe4wn-Q-1; Thu, 09 Jul 2020 14:01:07 -0400
X-MC-Unique: vV7KdL8_O4ONKYhJe4wn-Q-1
Received: by mail-wm1-f69.google.com with SMTP id g6so2937184wmk.4
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 11:01:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P+Smn+qbrEaL68M0kp1IAVljg+f544E0Mx1LSyAW08k=;
        b=eC67YBUMsPxMNkTDhxQSckqUj2GnIXw1l04TFl5cIoCCflbV2L680np0ptT3Z1ZZaU
         m2pAPz7yAe2nU4TjTqLVOkSLqseRZMnjSGw6LN+VDGKrXWxd7txoDgbcnD8ZJoxvD9U+
         4Cx5Axc1wEqCmUwJ5v61FRv6KDW7WzQMBgxO4d3Fa/M13vudxZDtALBgCouzRU9163IA
         O27B4NRvTUm9dDFpYFco3aecH2Ik+qWeiobLftnlqfqTokVVnV//FYXLKQts4bUt1g4P
         wDNJxamCOPAidRAee5jAr3rmo+F4lmvDHfqh/RKqdmej7NAefA347aIzv8SzsHwk1Q0s
         rgmQ==
X-Gm-Message-State: AOAM533NdhZRu1BG/XqJQWQDlX5OPpm4/MYYT7ZtuC7EHA4McZVbW7da
        IIaSPZxuxS8corZJIJ0O9YFLFnin7cS+fzZPz0Sz11gfGwfUgj+mOQMbOAku/ntzBdaXQ4hDJts
        A5ZJmwSLrzpeW
X-Received: by 2002:a5d:5151:: with SMTP id u17mr34275349wrt.154.1594317666623;
        Thu, 09 Jul 2020 11:01:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3GYXLHf1eEB36ksMDjvbW000ZwH159y2USM6sITXUNHpZ8wwObz8hqscS/TMYpvSXCY1m9A==
X-Received: by 2002:a5d:5151:: with SMTP id u17mr34275321wrt.154.1594317666393;
        Thu, 09 Jul 2020 11:01:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id h5sm7296815wrc.97.2020.07.09.11.01.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 11:01:05 -0700 (PDT)
Subject: Re: [PATCH v3 0/9] KVM: nSVM: fixes for CR3/MMU switch upon nested
 guest entry/exit
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
References: <20200709145358.1560330-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8bc0fbf7-98a2-3e10-37df-aaf19e4d218d@redhat.com>
Date:   Thu, 9 Jul 2020 20:01:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709145358.1560330-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 16:53, Vitaly Kuznetsov wrote:
> This is a successor of "[PATCH v2 0/3] KVM: nSVM: fix #TF from CR3 switch
> when entering guest" and "[PATCH] KVM: x86: drop erroneous mmu_check_root()
> from fast_pgd_switch()".
> 
> The snowball is growing fast! It all started with an intention to fix
> the particular 'tripple fault' issue (now fixed by PATCH7) but now we
> also get rid of unconditional kvm_mmu_reset_context() upon nested guest
> entry/exit and make the code resemble nVMX. There is still a huge room
> for further improvement (proper error propagation, removing unconditional
> MMU sync/TLB flush,...) but at least we're making some progress.
> 
> Tested with kvm selftests/kvm-unit-tests and by running nested Hyper-V
> on KVM. The series doesn't seem to introduce any new issues.

Looks like a v4 is needed but we're converging at least, it won't have
27 patches. :)

> Vitaly Kuznetsov (9):
>   KVM: nSVM: split kvm_init_shadow_npt_mmu() from kvm_init_shadow_mmu()
>   KVM: nSVM: stop dereferencing vcpu->arch.mmu to get the context in
>     kvm_init_shadow{,_npt}_mmu()
>   KVM: nSVM: reset nested_run_pending upon nested_svm_vmrun_msrpm()
>     failure
>   KVM: nSVM: prepare to handle errors from enter_svm_guest_mode()
>   KVM: nSVM: introduce nested_svm_load_cr3()
>   KVM: nSVM: move kvm_set_cr3() after nested_svm_uninit_mmu_context()
>   KVM: nSVM: implement nested_svm_load_cr3() and use it for host->guest
>     switch
>   KVM: nSVM: use nested_svm_load_cr3() on guest->host switch
>   KVM: x86: drop superfluous mmu_check_root() from fast_pgd_switch()
> 
>  arch/x86/kvm/mmu.h        |   3 +-
>  arch/x86/kvm/mmu/mmu.c    |  39 ++++++++++----
>  arch/x86/kvm/svm/nested.c | 108 ++++++++++++++++++++++++++++----------
>  arch/x86/kvm/svm/svm.c    |   6 ++-
>  arch/x86/kvm/svm/svm.h    |   4 +-
>  5 files changed, 116 insertions(+), 44 deletions(-)
> 

