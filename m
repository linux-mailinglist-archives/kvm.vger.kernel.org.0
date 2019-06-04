Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2903C34E8E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfFDRR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:17:27 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39775 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfFDRR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:17:26 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so861266wma.4
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 10:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FofTEEiYxT/UH6DGA+rayhc3KBBIJPlV9fE+A9Bei4g=;
        b=Xu4EJO/XxE8oS4Nu3SJjn0STAcIdRqt912uUDbuGupABRc5YnCLUuYs2k7+TYCGT+o
         YnUHhPFls54CWKwK8xr3y3LG/KOPVtK/QFJe1zHuR8f+kKsjwFlA0DJNaMjAelmDocfZ
         2wH52tQfTMOiK2DsU6fKkZva+GTqmfwoe6nH57Pt88NKscnjPeyXqDRR/m26/3MjBAMs
         7f2v2RSgew5yrdkPtTxeCj0xrtYQXTjyPODSorJfZ288L6n8zL9vSLHm3k1McTR6d6zA
         y3wY/VdMVtnbPtt59mK41wgmCV79WVCcOhBhAmAL7mk7n7MCc81CP0E3brvefAmk8rTU
         qUbg==
X-Gm-Message-State: APjAAAUJwKWw6qfPbADCJSko+ZGJs9R0dXA/ICTQ4c4r1VLgHjKKrO28
        6sXokkOrZJFxw275r6ppwPSsCg==
X-Google-Smtp-Source: APXvYqzqu2sq8kxZr3aAvQULJVA9W4e8pp0hIojA0ezQI0+rwHgf/KTdYdTCz8KXa/1UsR1oKusMWQ==
X-Received: by 2002:a7b:c189:: with SMTP id y9mr7404847wmi.116.1559668644884;
        Tue, 04 Jun 2019 10:17:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id k185sm2659539wma.3.2019.06.04.10.17.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:17:24 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] kvm: selftests: aarch64: use struct kvm_vcpu_init
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, thuth@redhat.com, peterx@redhat.com
References: <20190527143141.13883-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <39548ccf-0628-06db-7f49-329c4ce87536@redhat.com>
Date:   Tue, 4 Jun 2019 19:17:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190527143141.13883-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/19 16:31, Andrew Jones wrote:
> aarch64 vcpu setup requires a vcpu init step that takes a kvm_vcpu_init
> struct. So far we've just hard coded that to be one that requests no
> features and always uses KVM_ARM_TARGET_GENERIC_V8 for the target. We
> should have used the preferred target from the beginning, so we do that
> now, and we also provide an API to unit tests to select a target of their
> choosing and/or cpu features.
> 
> Switching to the preferred target fixes running on platforms that don't
> like KVM_ARM_TARGET_GENERIC_V8. The new API will be made use of with
> some coming unit tests.
> 
> v2:
> - rename vm_vcpu_add_memslots to vm_vcpu_add_with_memslots
> 
> Andrew Jones (4):
>   kvm: selftests: rename vm_vcpu_add to vm_vcpu_add_with_memslots
>   kvm: selftests: introduce vm_vcpu_add
>   kvm: selftests: introduce aarch64_vcpu_setup
>   kvm: selftests: introduce aarch64_vcpu_add_default
> 
>  .../selftests/kvm/include/aarch64/processor.h |  4 +++
>  .../testing/selftests/kvm/include/kvm_util.h  |  5 +--
>  .../selftests/kvm/lib/aarch64/processor.c     | 33 +++++++++++++++----
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +++++++++++++---
>  .../selftests/kvm/lib/x86_64/processor.c      |  2 +-
>  .../testing/selftests/kvm/x86_64/evmcs_test.c |  2 +-
>  .../kvm/x86_64/kvm_create_max_vcpus.c         |  2 +-
>  tools/testing/selftests/kvm/x86_64/smm_test.c |  2 +-
>  .../testing/selftests/kvm/x86_64/state_test.c |  2 +-
>  9 files changed, 63 insertions(+), 18 deletions(-)
> 

Queued with my replacement for patches 1 and 2 (but please do review it).

Paolo
