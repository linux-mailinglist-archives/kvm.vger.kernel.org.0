Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD82760EBD6
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 00:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJZWsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 18:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbiJZWs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 18:48:29 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FAB11C0A
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:48:28 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h2so10343169pgp.4
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0YtP+k+6uts8m9tNmFsigaW1IdIDo2sBUM/m3vJA+cQ=;
        b=oH1lHDkxtfk94OzKVfdbwe6bUoopLQw8Fghgdm0DYNrRhRldudBMola+VmESIeCxE0
         xYiDR++f8zbRrdUq2GGtiY9GCOFV2OgDsTxliRWveBhCoMqtQ47QG6DhCMIX2MT82B4D
         Cs9u7o3QPDOAS415bfY/rVRZnuiqymrnbTL1wo17/9KZBKWDjykX5vAMc/FDvgNz/qAR
         iJctqm16e1YVEnopCQtXwoeF/1IXX+Q4AlYELqB5yiDAtlJneoDvIkYrvbCf8IosAOJt
         1UbU5g70iqur0DCnv17npW+TPdxuSZJuR1iGbsR62f5gOSuEzAqyHXfMQe+k89YIDTNL
         vCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0YtP+k+6uts8m9tNmFsigaW1IdIDo2sBUM/m3vJA+cQ=;
        b=xED3Hsx9gv7UhREDOT53wQ6wU14mr6PUiKDJGu5wGrtOpavipP6PZQgc/O0yKaBka8
         dEerwuPFur1l296xvlRd1UZmM2LC+hca7PMRDsooB+RhPrn6gQ1RYjsGFEz1bpq8Zicc
         h8LV0qSLyoaB88b0exhGcQWDbDj+8MGv9QSWll62DW5KbXMwG88oPrFJnyITJFiACsj2
         XVg6ID+cum65/7nDYvuUIQHGia3C+aTEakHCmCirFjI1/jM3boPyEw4kaYxIoeJND3sy
         2yU1ZFkyoswJWXD5Bw9XMtutl8nw8IcjgSz0uHQnbHANq/bZ3X3HO/xdpZMn3EEj8WIb
         Y9MA==
X-Gm-Message-State: ACrzQf3JMfWe7FkY4zUgBvk20pEcO/WDP3JINYpH5P5Ro29ytHTzyKie
        erFRcmKR7w5D0hCBaMDTWCpwJA==
X-Google-Smtp-Source: AMsMyM4G9zTFrU6aX0grlDJI8Q2JBxZqVIsOeKPjDFIE4dCdLpZvssF+F8UMJwT79BWrXJLwGRwTGw==
X-Received: by 2002:a63:5425:0:b0:450:738:9a78 with SMTP id i37-20020a635425000000b0045007389a78mr38496648pgb.429.1666824507430;
        Wed, 26 Oct 2022 15:48:27 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ij1-20020a170902ab4100b0015e8d4eb26esm3372997plb.184.2022.10.26.15.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 15:48:22 -0700 (PDT)
Date:   Wed, 26 Oct 2022 22:48:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v4 2/4] kvm: Add KVM_PFN_ERR_SIGPENDING
Message-ID: <Y1m5J2+6AcYHUf4P@google.com>
References: <20221011195809.557016-1-peterx@redhat.com>
 <20221011195809.557016-3-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011195809.557016-3-peterx@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Uber nit, s/kvm/KVM for the shortlog,

On Tue, Oct 11, 2022, Peter Xu wrote:
> Add a new pfn error to show that we've got a pending signal to handle

Please avoid pronouns in changelogs and comments, they're unnecessarily ambiguous.
E.g. 

  Add a new pfn error to capture that hva_to_pfn_slow() failed due to a
  pending signal.  The new error will be used in future patches to
  propagate -EINTR back to userspace instead of returning -EFAULT.
 

> during hva_to_pfn_slow() procedure (of -EINTR retval).
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

Nits aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>
