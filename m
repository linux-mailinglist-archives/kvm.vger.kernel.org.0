Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F56C3EBA04
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 18:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhHMQ3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 12:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbhHMQ3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 12:29:14 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50707C0617AD
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 09:28:47 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id q2so12629633plr.11
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 09:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5vsrCAhIhqleSp4ilnt79j6IYc6DztFKdxcos4U/Zdw=;
        b=s/gPWOK8ezdqks7mEUKZQGuY3ur/s9nmz5Xm799RPiVLlhDeWVeLaq4jwY6wGUpZzk
         kfQBYmld7FNccLGlURTq+4X5SM0Ld67qddVGTEfkj/tWtjysVvvlgA9C5m3Fkd/bpjp/
         MU6i66OntDLzok1dUjkKiGJO+DggV18HL7D+s7JnFal3Pi8D4HjcE9JwyuF7DVt7YChG
         uZ9Uv4Wg0ycik3MJ+eAR6cidd+x9kNOjv4dOGPtG1xUGr8TFzJYENi8fjK+8UyN3tbmS
         rJdtxUQgeUwXjnACaHFBTrHv7iCLgOiVCAPRsmuN5zOCQFBrMI5BUO/2T2vUe5ahZfjp
         zrMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5vsrCAhIhqleSp4ilnt79j6IYc6DztFKdxcos4U/Zdw=;
        b=ZDfRssv/LuEYhAOsZG8ZmIe1lW4VLGSKpQyEx5RIqffhxESFzu9nNv1qb+KQnOEc4j
         AAPnDFMFWRHsatmkk7sX98akKCYf1p2jNXaTEpIso0+isD9Hx5gxDA+zHwmpNl8C/WRQ
         ffDYfyW2uhVDpmkP566q8jsBKUYofJfq8wW+xaFeI/xxBUmKGjVaykRXOhvNdiiM+zYA
         VeRJZrZOURKlkA0bThTi7s3q0DFs09hBtfzVoanKIpChukn6S7RkmqbL8SJn6U6Ro4V6
         HbvmDd+VaHUc1cCkDg/ztYG2zjCudEINniDQaquv0rmtQ55GSXtKc/S+WCPa95L7PVZE
         IPrA==
X-Gm-Message-State: AOAM533iCu2d+bjDksyo65L4CGy2BJNaGbpkQphCz2MnCc3fZOEVLoZ8
        CYzdQeT+nfI0SJ0kvhRhi9+BuqoCA1voZw==
X-Google-Smtp-Source: ABdhPJzFcDg42Qi/QLxlT+AItPtHajHKKItsai4wbDeuQpZVXo0+ztFHB94T39wdHTdSuIGS4ouPdw==
X-Received: by 2002:aa7:8a04:0:b029:3e0:ec4a:6e65 with SMTP id m4-20020aa78a040000b02903e0ec4a6e65mr3227176pfa.47.1628872126672;
        Fri, 13 Aug 2021 09:28:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f6sm2745044pfv.69.2021.08.13.09.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 09:28:45 -0700 (PDT)
Date:   Fri, 13 Aug 2021 16:28:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        peterx@redhat.com
Subject: Re: [PATCH 02/16] KVM: x86: clamp host mapping level to max_level in
 kvm_mmu_max_mapping_level
Message-ID: <YRaduAFaHZ+w643k@google.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
 <20210807134936.3083984-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807134936.3083984-3-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 07, 2021, Paolo Bonzini wrote:
> This patch started as a way to make kvm_mmu_hugepage_adjust a bit simpler,
> in preparation for switching it to struct kvm_page_fault, but it does
> fix a microscopic bug in zapping collapsible PTEs.

I think this also fixes a bug where userspace backs guest memory with a 1gb hugepage
but only assigns a subset of the page to the guest.  1gb pages would be disallowed
by the memslot, but not 2mb.  kvm_mmu_max_mapping_level() would fall through to the
host_pfn_mapping_level() logic, see the 1gb huge, and map the whole thing into the
guest.  I can't imagine any userspace would actually do something like that, but the
failure mode is serious enough that it warrants a Fixes: + Cc: stable@.
