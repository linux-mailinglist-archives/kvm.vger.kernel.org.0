Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A75709BB1
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 17:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjESPwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 11:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjESPwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 11:52:50 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3921AB2
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 08:52:49 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-561f1c2af16so24385637b3.0
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 08:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684511568; x=1687103568;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6zkKhy+RcJw1Q9jKiForPq7NeS9lLVzxRaGQSXMt0Ac=;
        b=lLJ3ZgyoZpj98rVKCB0rrnrwlWYw44sZ1PsocAoKc9c0fUE2wa8T7SC03sdaA4adVO
         8gQ9UhyftEhM9Zr2umUzRxNRDTRVZkGsgvZWF3bqyBK3XPes6E0c6CQf8xB0eXGqKeSD
         CZb5aQbYV/7R9t99S8eALl7IGqW8QBfx5RoW9A9ng9OiGuICl+TYjSw7NJnr6pzEDmEW
         kpkrRB0saghQ+iVL/JxhJdEtsATMwnkxm0N8lPJM7nBtDHxfaImmVAAg70+ygIMKIzRf
         YfFhi1vm5emmp7UCpolsWXU3ebolslMLtuhgNR3nNtp3VjHSVcdjoSoal0VDuf1Lo2A/
         aLYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684511568; x=1687103568;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6zkKhy+RcJw1Q9jKiForPq7NeS9lLVzxRaGQSXMt0Ac=;
        b=ZtLDP/fbr/1FurFDcbWJ/5cr2PhVQFMXMpscGC1Krih+uIt8GE/Wbx+3NF4FsSbqUJ
         1rWku4/K6ig0dEys7cTMEy3KXpiLLu+utbI+NsygMkptzsaNAZSlZjzI5raaPAQvQUS8
         4P1itbMc/wnFY10g/Rjf5HQjQizcBK6VmZfeIYBcl2nQUth4yvUmUVtKN8Yk/RqDNAgO
         1q6WgXE7KbdPrkD63N7hrfDXQL/u7J1XTDaSza9GHHsA5yPmZNtHSmbdSF6CuS/ArFur
         NmBb8IWLInRyYxANX1Qv+u43cqn9HR2WtCRWcSP599vPgWHW1Xt9fjNQTXIf/dd70f+l
         iI3A==
X-Gm-Message-State: AC+VfDwIzPLPsqGfUYK7lNBqhr9lLCHgrp9TIFsLP8ykmj2CueSHqqBa
        ojfxoQOMruyOFmd+ld0x+Tt1v8OO49Q=
X-Google-Smtp-Source: ACHHUZ5lXecYf534roQew4aGk1EJqASfm11ZJvjbrps/9i0LIFiuaAs145/Avq8gz9m0Aj124UhQt0LaY8w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:8d06:0:b0:541:61aa:9e60 with SMTP id
 d6-20020a818d06000000b0054161aa9e60mr1489572ywg.6.1684511568317; Fri, 19 May
 2023 08:52:48 -0700 (PDT)
Date:   Fri, 19 May 2023 08:52:46 -0700
In-Reply-To: <20230519065843.10653-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230519065843.10653-1-yan.y.zhao@intel.com>
Message-ID: <ZGebTm4GCYSHDAQ5@google.com>
Subject: Re: [PATCH v2] vfio/type1: check pfn valid before converting to
 struct page
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kevin.tian@intel.com, jgg@nvidia.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 19, 2023, Yan Zhao wrote:
> Check physical PFN is valid before converting the PFN to a struct page
> pointer to be returned to caller of vfio_pin_pages().
> 
> vfio_pin_pages() pins user pages with contiguous IOVA.
> If the IOVA of a user page to be pinned belongs to vma of vm_flags
> VM_PFNMAP, pin_user_pages_remote() will return -EFAULT without returning
> struct page address for this PFN. This is because usually this kind of PFN
> (e.g. MMIO PFN) has no valid struct page address associated.
> Upon this error, vaddr_get_pfns() will obtain the physical PFN directly.
> 
> While previously vfio_pin_pages() returns to caller PFN arrays directly,
> after commit
> 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()"),
> PFNs will be converted to "struct page *" unconditionally and therefore
> the returned "struct page *" array may contain invalid struct page
> addresses.
> 
> Given current in-tree users of vfio_pin_pages() only expect "struct page *
> returned, check PFN validity and return -EINVAL to let the caller be
> aware of IOVAs to be pinned containing PFN not able to be returned in
> "struct page *" array. So that, the caller will not consume the returned
> pointer (e.g. test PageReserved()) and avoid error like "supervisor read
> access in kernel mode".
> 
> Fixes: 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()")
> Cc: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>
