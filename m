Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A64E3C6270
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 20:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbhGLSOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 14:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbhGLSOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 14:14:01 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313ADC0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 11:11:12 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id v7so19125628pgl.2
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 11:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J0xopyei2ILQndbNL4EibL4fjjCHTkXjjwtwnY7nW3U=;
        b=tikxSdVU095l0lIuaBCmrDNNZWM7dHHkbnlRrlyOZUEDYp1oHSdkmKF5HkvRmJBVGc
         5KKbW+M87eagKfP6lKbx+YMmWPQk+6Ih8WikMeuArrskJvdsidsXo3BsXGDldEjnu3QU
         8/FhGQXtZ9SqR6m442L8pWgkSFyscEs01nxOiCuV2GdjRzG35iAFxsXUemHrQZdsnu+t
         HCFU1afDTG1OhcYGgEgQeOm70dRww8swcuG91JhV3jB9xcWOXACs9s8MejacAguMoxLb
         uRVPGfoS8jfKtBK5GhMWuaGSrqDpx6K2uNcf6Zb0OKe33MO0iCbkJCkbuTnVUELHQxZR
         jQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J0xopyei2ILQndbNL4EibL4fjjCHTkXjjwtwnY7nW3U=;
        b=Hv4b3o566HV9XHY5x5ypPScmXeqoM/yRQ3WMcu16SnR9pI59g66oQ2IsZvbXJkkuZ7
         gslwdnnzJxs0EKqYdKVJHvge+FdGkDTdOJroxp1VjKdKrMcm9RKye1dYYYGyCcHT2iZU
         Nf4twGVJpUqCF1gtNUncvPyjUSmxaSKK0HLm3vcMxbd+9s4yjqOKr5fyqNXiDc+JaIgw
         ARguUbhrvho1wTCSVn06S35zoasYyRyq8M71NUfS6eVdzLZNYlSS8IQOvuxP6Gv68B88
         YkallBxjLw3eIetaI2c2emqroJhspmIdA+6v80G73xfuX38SCd+Khp2krgba6OIclo0t
         DT5A==
X-Gm-Message-State: AOAM530Md8zNV7BjjE77HpOx3zz3V46DC0gFuJPwfiQxNHY4Si1bVUWd
        94rPtac9zP2HYKVJMwQx1priPA==
X-Google-Smtp-Source: ABdhPJzXBYVDMb/EEU1OavkjsdTnZxxvQv9VAuzw2phvPhwpLTl4NCNJ4LDpl6UpiWwZ1o57qGLW8w==
X-Received: by 2002:a62:8fc8:0:b029:2ec:9b7a:f59e with SMTP id n191-20020a628fc80000b02902ec9b7af59emr294573pfd.39.1626113471505;
        Mon, 12 Jul 2021 11:11:11 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id 144sm18889276pgg.4.2021.07.12.11.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 11:11:10 -0700 (PDT)
Date:   Mon, 12 Jul 2021 18:11:06 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: Make
 walk_shadow_page_lockless_{begin,end} interoperate with the TDP MMU
Message-ID: <YOyFutKh8Ora2+V9@google.com>
References: <20210630214802.1902448-1-dmatlack@google.com>
 <20210630214802.1902448-4-dmatlack@google.com>
 <CANgfPd8Vo0qvBiGuQLrt4U6ChCUgXZ9kx3VoEjAZDjkOS5bZWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8Vo0qvBiGuQLrt4U6ChCUgXZ9kx3VoEjAZDjkOS5bZWQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021 at 10:02:31AM -0700, Ben Gardon wrote:
> On Wed, Jun 30, 2021 at 2:48 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Acquire the RCU read lock in walk_shadow_page_lockless_begin and release
> > it in walk_shadow_page_lockless_end when the TDP MMU is enabled.  This
> > should not introduce any functional changes but is used in the following
> > commit to make fast_page_fault interoperate with the TDP MMU.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> 
> This as I understand this, we're just lifting the rcu_lock/unlock out
> of kvm_tdp_mmu_get_walk, and then putting all the TDP MMU specific
> stuff down a level under walk_shadow_page_lockless_begin/end and
> get_walk.
> 
> Instead of moving kvm_tdp_mmu_get_walk_lockless into get_walk, it
> could also be open-coded as:
> 
> walk_shadow_page_lockless_begin
>  if (is_tdp_mmu(vcpu->arch.mmu))
>                leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
>  else
>                leaf = get_walk(vcpu, addr, sptes, &root);
> walk_shadow_page_lockless_end
> 
> in get_mmio_spte, since get_walk isn't used anywhere else. Then
> walk_shadow_page_lockless_begin/end could also be moved up out of
> get_walk instead of having to add a goto to that function.
> I don't have a strong preference either way, but the above feels like
> a slightly simpler refactor.

I don't have a strong preference either way as well. I'd be happy to
switch to your suggestion in v3.
