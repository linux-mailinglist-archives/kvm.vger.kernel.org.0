Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA4D552CE8
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 10:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiFUIYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 04:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347940AbiFUIYC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 04:24:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB6D113EB3
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 01:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655799817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XGU7mDtKklVPCqn8Uk3bMEFXs2W9T3w03LpqwdG17/Y=;
        b=gGO1aDgYqdOwsKkrCMRJ5ZG5N9Br+8SqnRw8z+OrIPfX1XA8cUsrvwWnfgaOCsC7VMxX6D
        rVnpCcBA73U9bhNRDGnfXD1WN8/Rw5JrqRr0ZNUrNFjRnK+LI9SpXVDCay3ZG4AkDKXRSt
        k1EaOGUBuaeUCLLBKYlETSuk21+GLEE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-r58LM1fiPnKIMUFuw7Uhzw-1; Tue, 21 Jun 2022 04:23:35 -0400
X-MC-Unique: r58LM1fiPnKIMUFuw7Uhzw-1
Received: by mail-wr1-f70.google.com with SMTP id r20-20020adfb1d4000000b0021b8507563eso1897279wra.16
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 01:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=XGU7mDtKklVPCqn8Uk3bMEFXs2W9T3w03LpqwdG17/Y=;
        b=bOdGVVWEoXBXJ4IGkTdDPsk5fHaAGD5wf4Yyzy49ZtCZrQWgKDOh9G7GJZaLXt2WQl
         0PjfSdMsymeDVekYm8UZHZ5CnjNV1Q6whN+1fzQbuKa0zX2adoEhe4Kvw3LQ6fMl42HS
         WjVA+qRR3yqrxffsFzUx0PgXUQv7MmFjWDYkYvSQkrvcZUbdxImQMa58GKXlycss2qxT
         xqGbrB3ZB3W6PyhvnTeLkEN1BIZXjbuNwkxSjU/nieZ01gX6MwsDME9o5KDlobWOd6mI
         1n1bi7Xlc/5c3uBzMdnvEaDQBxDtN/8AqmOmCe+cazwX+HyXV0o3h91BdqEa8znrC2dM
         EiFQ==
X-Gm-Message-State: AJIora80xFUNT+Xd3cGW6SshXhpQ4pG6KonDPx29IIDO5XjHCNxj6aOc
        QSbtqv58Bcn+zcV2AWpOI9UlMvIXWgKJ5SElRt+mFJoQ7VMHMD2q6g9IQEh0qyX1TyXPVgrWWwu
        8eGtOYNpxioxa
X-Received: by 2002:a7b:c758:0:b0:39c:44ce:f00f with SMTP id w24-20020a7bc758000000b0039c44cef00fmr28512312wmk.167.1655799814490;
        Tue, 21 Jun 2022 01:23:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sUotCk+6rcFy05ZeXu+qAjpL3NaHybbZ2BoBeUtiL7/zNAYd2GvpjFdw35xlTwbym9LSrXXg==
X-Received: by 2002:a7b:c758:0:b0:39c:44ce:f00f with SMTP id w24-20020a7bc758000000b0039c44cef00fmr28512300wmk.167.1655799814242;
        Tue, 21 Jun 2022 01:23:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f04:2500:cdb0:9b78:d423:43f? (p200300d82f042500cdb09b78d423043f.dip0.t-ipconnect.de. [2003:d8:2f04:2500:cdb0:9b78:d423:43f])
        by smtp.gmail.com with ESMTPSA id j11-20020a05600c190b00b0039c5328ad92sm24367503wmq.41.2022.06.21.01.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 01:23:33 -0700 (PDT)
Message-ID: <212f8b31-e470-d62c-0090-537d0d60add9@redhat.com>
Date:   Tue, 21 Jun 2022 10:23:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH RFC 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20220617014147.7299-1-peterx@redhat.com>
 <20220617014147.7299-2-peterx@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220617014147.7299-2-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.06.22 03:41, Peter Xu wrote:
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

This makes sense to me. I assume relevant callers will detect "GUP
failed" but also "well, there is a signal to handle" and cleanly back
off, correct?

-- 
Thanks,

David / dhildenb

