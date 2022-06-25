Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5845555A591
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 02:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbiFYAf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 20:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbiFYAf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 20:35:57 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CA46DB17
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 17:35:56 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id o43so6955708qvo.4
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 17:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NM0GgLb9K/faELYgxhv94xXavXWp8l4qd5OqY1giIjw=;
        b=U69OIV7CgPSGtm8OqOm28OWNbN1YRWzwmy/hcEHCQGaZhd1y9dxB1CdsEQfGzSsAin
         Orp+V/IpbecyMh2Bzikox1ViXds4pJms6PXjq8af4g5e3WIGmYC/OjyQCM+G61m0cDd+
         QmtmnQR+oO2kccH/K0fLbbyptLFGbbubd4rKz0g62V2faqm19zOb9oCiW4pXEr/vjxQv
         iCU4Lcbrcv/RgW4CFzF5lA2cSnwDrvRYuINo+95BIStrIK6Vjncvibg/svSQwSW4gskf
         2jzpzUCrpGkc9CzTQxcBsJDevFN9XC6qciUNraNguv21OfdSduVb8u+bWAuSCWj5/9ob
         khOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NM0GgLb9K/faELYgxhv94xXavXWp8l4qd5OqY1giIjw=;
        b=u8Oe8y8DL11SfEtwyyUZ4i6K7tf3pwGk1LZkEaHJkOHXG3akxzmm4cw2Xj7qRNbjgr
         2Nwa33w2j1RalI9/i4UWMI3Br74S3zov4gNrzBHtpy9mZ0r9tpxg52fLSLdnqLNuUNPy
         3lhdk10b9qYxhCkk+joM2jyyUScZEY5vfrulaMhSs8bvijqPenrf79gbuP2yJq+ztOy1
         M2jFYczJeIo+THecQxZCVpAa24IpovP86lTxvt0d0+cNgcV4L4/55X0JUBdLRXS5xN47
         NuQtFGzz9S9sTTYBaALGeEDXROgDLTEhA7j+ucgYfZGRQ1xRQQqLFOxoJlu8Aoj3+eGH
         Ys7g==
X-Gm-Message-State: AJIora8v1yyJkcV388Pe4xpKzCHhvJ+6JQMnL8HHLlAA/V1Wj7FC+htY
        WOaFeic3Szm3o1zt4z3aepT+Zg==
X-Google-Smtp-Source: AGRyM1tfYT/2a5qKqWVRQYrtWwn+8o/oCCmUXnhNTKR8+fV1gFV92jB4at1BOe2NSslr9MM375OOIA==
X-Received: by 2002:ad4:5c68:0:b0:470:52b5:c85c with SMTP id i8-20020ad45c68000000b0047052b5c85cmr1538212qvh.3.1656117355520;
        Fri, 24 Jun 2022 17:35:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id bq11-20020a05620a468b00b006a700aad48bsm2977173qkb.91.2022.06.24.17.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 17:35:54 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1o4tmE-001Izr-B3; Fri, 24 Jun 2022 21:35:54 -0300
Date:   Fri, 24 Jun 2022 21:35:54 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Message-ID: <20220625003554.GJ23621@ziepe.ca>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-2-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622213656.81546-2-peterx@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 05:36:53PM -0400, Peter Xu wrote:
> We have had FAULT_FLAG_INTERRUPTIBLE but it was never applied to GUPs.  One
> issue with it is that not all GUP paths are able to handle signal delivers
> besides SIGKILL.
> 
> That's not ideal for the GUP users who are actually able to handle these
> cases, like KVM.
> 
> KVM uses GUP extensively on faulting guest pages, during which we've got
> existing infrastructures to retry a page fault at a later time.  Allowing
> the GUP to be interrupted by generic signals can make KVM related threads
> to be more responsive.  For examples:
> 
>   (1) SIGUSR1: which QEMU/KVM uses to deliver an inter-process IPI,
>       e.g. when the admin issues a vm_stop QMP command, SIGUSR1 can be
>       generated to kick the vcpus out of kernel context immediately,
> 
>   (2) SIGINT: which can be used with interactive hypervisor users to stop a
>       virtual machine with Ctrl-C without any delays/hangs,
> 
>   (3) SIGTRAP: which grants GDB capability even during page faults that are
>       stuck for a long time.
> 
> Normally hypervisor will be able to receive these signals properly, but not
> if we're stuck in a GUP for a long time for whatever reason.  It happens
> easily with a stucked postcopy migration when e.g. a network temp failure
> happens, then some vcpu threads can hang death waiting for the pages.  With
> the new FOLL_INTERRUPTIBLE, we can allow GUP users like KVM to selectively
> enable the ability to trap these signals.

Can you talk abit about what is required to use this new interface
correctly?

Lots of GUP callers are in simple system call contexts (like ioctl),
can/should they set this flag and if so what else do they need to do?

Thanks,
Jason
