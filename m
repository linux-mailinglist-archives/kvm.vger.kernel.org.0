Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E715760EBDA
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 00:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbiJZWtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 18:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbiJZWtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 18:49:36 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86BA25CA
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:49:31 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so4330688pji.1
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ON6rj+Dk6S1cuE4b5I/v59JYrp3U2LwWuWudO6aMeKY=;
        b=GfkiFLyIMYl+2mu/NGzKesOt0o+XKT2iPX51PI7gfjc0SEnVe1TGgqMcpjudHjRGSX
         NBFQmHdMuA7SLkbFQnS+VJjQO1NikX9UlILHAYmZrEkK9aosgGdEdu8BpPCmptpnZSgD
         s5gQ6nzIFi/teY1vMowbZAJIPE7fdLUNDGKIAaYMhYz2ECzhhDWJihfOYN9OxJ+LN/5F
         bm3p3+5HCdKnj8vqiBJHa7arrCMCZBJ7kJCtQg2EDMdWbdiGv0koruA2XmEvcMuc6spA
         AU1B6Oh31PXZcQZ4FJp1G5By+L1XLfG/tv59ya4p/0+7yWoCG5VUeZahNOR/1/esnBoU
         /ylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ON6rj+Dk6S1cuE4b5I/v59JYrp3U2LwWuWudO6aMeKY=;
        b=6qJYyCjbIkm1CwAvuYTE68iB/hz3MycBiTN9j143vAhtShFG88VnFEcXMCCPGq6Fjl
         rVb1JAd0Vu0XrxaO2nVHnnsV4rlvCm7jyc09oDDdyX0b+CYSgZ9BHCVHlHJFhiZXJqgT
         gYeLe8uvLj6lZTXCqCXb5TzC0fs5xcr4wzPiFYEMiOYRzrIFHy3P1FCY30DMeUg+moOs
         k577J0Xkya4M1h9FkqasdjnrDDdCWDadS5yEPAceVAUOPdtaJAMHdVQvYgyFNm3ZdRZi
         61c43yxm9wIhj5E7gJYL64YnNqhlJuofQ2A8zFkKiR5xokwwT5M4fIOhOYB9g0+PGLSC
         IXhw==
X-Gm-Message-State: ACrzQf0Y3SX13Cbw7uDLdE2Km81kMJbvqV3LXYyzceDYF50MISXWWiBn
        7jczCtroHJi6Z07iRqFsIz3VqA==
X-Google-Smtp-Source: AMsMyM7BYX42JN7HaDMZxrqe7AGtHQkbroLKdVAztUQNqXiaAVuI7ZfIUtjGR4nmYTLPuh3Cbcmbsg==
X-Received: by 2002:a17:902:e845:b0:186:96fe:56cc with SMTP id t5-20020a170902e84500b0018696fe56ccmr23349250plg.110.1666824570980;
        Wed, 26 Oct 2022 15:49:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w70-20020a628249000000b0056c058ab000sm3457122pfd.155.2022.10.26.15.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 15:49:30 -0700 (PDT)
Date:   Wed, 26 Oct 2022 22:49:26 +0000
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
Subject: Re: [PATCH v4 3/4] kvm: Add interruptible flag to
 __gfn_to_pfn_memslot()
Message-ID: <Y1m5dv48PKOY6Xbq@google.com>
References: <20221011195809.557016-1-peterx@redhat.com>
 <20221011195809.557016-4-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011195809.557016-4-peterx@redhat.com>
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

"KVM:" for the shortlog.

On Tue, Oct 11, 2022, Peter Xu wrote:
> Add a new "interruptible" flag showing that the caller is willing to be
> interrupted by signals during the __gfn_to_pfn_memslot() request.  Wire it
> up with a FOLL_INTERRUPTIBLE flag that we've just introduced.
> 
> This prepares KVM to be able to respond to SIGUSR1 (for QEMU that's the
> SIGIPI) even during e.g. handling an userfaultfd page fault.
> 
> No functional change intended.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
