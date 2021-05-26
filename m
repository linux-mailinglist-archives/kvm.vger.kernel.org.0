Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9BE391ACB
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbhEZOyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbhEZOyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 10:54:09 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18461C061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 07:52:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ot16so922971pjb.3
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 07:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eoAeJOslU32tSMc2qJZf18amvBfvR8t1rjHXFS5iqFU=;
        b=Pmd9mMAbLGhN1DQQPINGPRjI69nF/3FyQCsUVo6FPnf2PAy6ozaO5JJmpjXmB4PODw
         UxxJiVUdstI3yktjMXfnlwJSkHVBTsocM+mkjJyTvjHQZsG9WUQOw+OligCLoFu2yxC1
         972TDZpVGLRNBUbxH9dwQN462+SlCbj0wR4Lp0uj2kT8OSY63RoaVj9jc1ol7HZ6bqP9
         j19bO8R6wBztlBB4SHhWjBTiD+MThV1aPz/T3LH56EWQkrhhbJ0bicaXan/Ny46RO7+C
         aiF4ZABx8NORIgiwRgNdfiSf8TW47ZnC23aJmJuLbH2xSFLShgsew1bL1EWjHtWj+2Gs
         9NYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eoAeJOslU32tSMc2qJZf18amvBfvR8t1rjHXFS5iqFU=;
        b=K5LOnVvsBA0zJKBs8zmP10ryiQTc430rA1fUPKN4sDrn3SQtv9TjzidKjOn4SNSBUf
         QGGeQAkK/+lefFY5f79sLQEdnQGX2MRfYK3r/tbmFlutWwDD8tTvslpvxqR+ocVrX1Ez
         t7gkqoosqRuOtZLrOyO7MJR41qiBEHSq28gpZoLxlgPui1QBmQrYFtvBPH24EY6usJvc
         HWQ2MrkO+/yejZmrQtWz2nQQDfueHAoyHhZZV7ZVPzRqMDBowR0xw2P51FDYXQ+lPLVQ
         6eC/s3z5ZSLWXpwcRJIvAnk7ccxaggSjzepLORVvYXdrDN2/omACrCGKq3JjG5EdJpH3
         onBQ==
X-Gm-Message-State: AOAM533Thr+eKstOYy8aBF0GNK0OF38eBtZ/m+47U/mMaQGspJrPr8X4
        yRzVtpx55BCzjC4sB8wSObEong==
X-Google-Smtp-Source: ABdhPJzHJUFntFD6C1nrIoG6sKdQ3gptyGrzaPLnbX37KX3nn2H0asaB5b/I74SVE6mKgwWRBrVBGA==
X-Received: by 2002:a17:902:c112:b029:f0:d571:8fb0 with SMTP id 18-20020a170902c112b02900f0d5718fb0mr36486961pli.11.1622040757372;
        Wed, 26 May 2021 07:52:37 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id mj7sm4421086pjb.47.2021.05.26.07.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 07:52:36 -0700 (PDT)
Date:   Wed, 26 May 2021 14:52:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH] KVM: X86: Use kvm_get_linear_rip() in single-step and
 #DB/#BP interception
Message-ID: <YK5gsUVi2AJkt0uu@google.com>
References: <20210526063828.1173-1-yuan.yao@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526063828.1173-1-yuan.yao@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021, Yuan Yao wrote:
> From: Yuan Yao <yuan.yao@intel.com>
> 
> The kvm_get_linear_rip() handles x86/long mode cases well and has
> better readability, __kvm_set_rflags() also use the paired
> fucntion kvm_is_linear_rip() to check the vcpu->arch.singlestep_rip
  ^^^^^^^^
  function

Please run checkpatch before submitting in the future, it will catch some of
these misspellings.

> set in kvm_arch_vcpu_ioctl_set_guest_debug(), so change the
> "CS.BASE + RIP" code in kvm_arch_vcpu_ioctl_set_guest_debug() and
> handle_exception_nmi() to this one.
> 
> Signed-off-by: Yuan Yao <yuan.yao@intel.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>
