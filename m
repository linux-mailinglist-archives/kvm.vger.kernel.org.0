Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 050DF5D4B5
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfGBQul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:50:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35825 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBQul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:50:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id c27so10959040wrb.2
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:50:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZaeCbDgmf98qwd0keV/0bxBU+bvtrqjhrhzMzVcLt/4=;
        b=aWe3QaZzkFbnhrJV103kujVGn/5WqL4FdbTDED1as7olTpNYQBMRAbgQ12OkLYpQou
         iicihlF/k+B89/ep+G3TNKhzz5g01T+LUsHT3DCljdsI4oIFOAnATzA5FgJHnGbOzrdL
         vOw7NgpU6wc8mvZVc1jH5P90DQ1HkN3fSQHDulQ8dcOx84b3l2qAbt9hwDtg9NEi/Au+
         PR95faGlxvQ7TlBEuE1u2ypw0+hbX+sxI6xgSdKTgXg5U+aeXt26E3dKyTS3HP8Aqfi1
         pOIWpmUH7Mgx5Vcn7ZYLpEbUGRudQvk6bz5TvgG6TsoOq+2St6gRK/4rqNrQE9aZupD+
         paHA==
X-Gm-Message-State: APjAAAX+urW1eOLZo8HodNe21WFcsdp8R3JZxAQOhLe+FUPjGNYLR/Rh
        CrHycAd4+iSCoiVZpgmjdf+YKQ==
X-Google-Smtp-Source: APXvYqyGwqzZrLmFmeaOlYrmR1/e8LvBMOuAAGUh3dnVWWQ7asSZTAGVomHWoePm7wIAGaS6PIkynA==
X-Received: by 2002:adf:f542:: with SMTP id j2mr17273466wrp.16.1562086239509;
        Tue, 02 Jul 2019 09:50:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id o6sm32692245wra.27.2019.07.02.09.50.38
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:50:38 -0700 (PDT)
Subject: Re: [PATCH] kvm: nVMX: Remove unnecessary sync_roots from
 handle_invept
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Junaid Shahid <junaids@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Nadav Har'El <nyh@il.ibm.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Xinhao Xu <xinhao.xu@intel.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Gleb Natapov <gleb@redhat.com>
References: <20190613161608.120838-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7caa0e52-2b2f-9706-e117-abef3aa98a5b@redhat.com>
Date:   Tue, 2 Jul 2019 18:50:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190613161608.120838-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/06/19 18:16, Jim Mattson wrote:
> When L0 is executing handle_invept(), the TDP MMU is active. Emulating
> an L1 INVEPT does require synchronizing the appropriate shadow EPT
> root(s), but a call to kvm_mmu_sync_roots in this context won't do
> that. Similarly, the hardware TLB and paging-structure-cache entries
> associated with the appropriate shadow EPT root(s) must be flushed,
> but requesting a TLB_FLUSH from this context won't do that either.
> 
> How did this ever work? KVM always does a sync_roots and TLB flush (in
> the correct context) when transitioning from L1 to L2. That isn't the
> best choice for nested VM performance, but it effectively papers over
> the mistakes here.
> 
> Remove the unnecessary operations and leave a comment to try to do
> better in the future.
> 
> Reported-by: Junaid Shahid <junaids@google.com>
> Fixes: bfd0a56b90005f ("nEPT: Nested INVEPT")
> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Cc: Nadav Har'El <nyh@il.ibm.com>
> Cc: Jun Nakajima <jun.nakajima@intel.com>
> Cc: Xinhao Xu <xinhao.xu@intel.com>
> Cc: Yang Zhang <yang.z.zhang@Intel.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by Peter Shier <pshier@google.com>
> Reviewed-by: Junaid Shahid <junaids@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Queued, thanks.

Paolo
