Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4AB17900E3
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 18:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348338AbjIAQqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 12:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245400AbjIAQqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 12:46:36 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4535510EB
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 09:46:33 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c09c1fd0abso25091215ad.2
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 09:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693586793; x=1694191593; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xCon5474F9WwphxhfgFhUzbwn0ALvK9xFv6P5Xz3AWM=;
        b=hqU4wmxbesZHmpksagWiQXpeohEWVSELxtPPYGBcPYGHLzd4PgAZfKgihohM8nieNL
         x3j7YDZ7OFe1og77j691yrddLu54oFaBwlTOnLguDHh5p7+BR6+/NS0Pvahur84Awr49
         bkuD34JPS3lDemn9o374Aub5/hANryTKiGgwBpMkhQipD2xt1GjE8Tr7x8dvTJm1yuUP
         N4OflW4yEADxpThIY2D6fG6q7dWUsDZ8Me2Lye9Qu/RXCmRg6gJabmzXwP2Q72T9eIcR
         awghr/9a/lXoGNWrdpu9mabpbW5iiXix8awk61LcoVpzwdYHAKz7wJ9oNjs2LMhAzZ1M
         yjWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693586793; x=1694191593;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xCon5474F9WwphxhfgFhUzbwn0ALvK9xFv6P5Xz3AWM=;
        b=DEQ8a4VncFaH2odtuL2b9SGfmzdWcUR+/X3sbXlOQa5bqSIDZRKmfbTbFRKi0bAkE2
         R15UjDpqlMI09l75ibTVWweJuP8p6le6dtsMMKtjIE9a9b+79L3tDUkOa+0BS41OM2jt
         UqdK4JPfUlDv3aOUOAkFvqr6E6J/SnVGnxiyhh1mLNe3lzYvx9HFrWL4LO5CCWVKPMtQ
         /oS0BVmLAWUJoY1HoW2gXEK+mc19L61iUPd97P+/XUlzhYoW8xwNZZzRLUHg+3PlifcV
         J2m3wso5jaDbVt8Bc7MBfd2F77iepehImlVWkEQL8HeZwwSiByESfMBxNsqcnAaTZiXc
         W+zw==
X-Gm-Message-State: AOJu0YwVqMMloI3MAwEeGIEX4dgP4LdjIdBeJ69Yr3fw8boQlm2EQTHr
        DeadHPvOV3dBdW4qlgo+yxlaF4Q+eMG2aRL8IA==
X-Google-Smtp-Source: AGHT+IE7IWuztjp33Ush39YmsLck94qkQHf2UcyeDE5trFHuf5V0W6HBwaqY0C7q2Vl17GPr3mAIvAb6tklgxvjU0g==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:902:e887:b0:1bc:e6a:205e with SMTP
 id w7-20020a170902e88700b001bc0e6a205emr1066486plg.5.1693586792693; Fri, 01
 Sep 2023 09:46:32 -0700 (PDT)
Date:   Fri, 01 Sep 2023 16:46:31 +0000
In-Reply-To: <f7aaf097-6f83-0ee9-e16d-713d392b2299@linux.intel.com> (message
 from Binbin Wu on Fri, 1 Sep 2023 11:45:43 +0800)
Mime-Version: 1.0
Message-ID: <diqz34zxg7tk.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From:   Ackerley Tng <ackerleytng@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, yu.c.zhang@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        chao.p.peng@linux.intel.com, linux-riscv@lists.infradead.org,
        isaku.yamahata@gmail.com, maz@kernel.org, paul@paul-moore.com,
        anup@brainfault.org, chenhuacai@kernel.org, jmorris@namei.org,
        willy@infradead.org, wei.w.wang@intel.com, tabba@google.com,
        jarkko@kernel.org, serge@hallyn.com, mail@maciej.szmigiero.name,
        aou@eecs.berkeley.edu, vbabka@suse.cz, michael.roth@amd.com,
        paul.walmsley@sifive.com, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, qperret@google.com,
        seanjc@google.com, liam.merwick@oracle.com,
        linux-mips@vger.kernel.org, oliver.upton@linux.dev,
        linux-security-module@vger.kernel.org, palmer@dabbelt.com,
        kvm-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        pbonzini@redhat.com, akpm@linux-foundation.org,
        vannapurve@google.com, linuxppc-dev@lists.ozlabs.org,
        kirill.shutemov@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Binbin Wu <binbin.wu@linux.intel.com> writes:

> <snip>
>
>>
>> I'm not sure whose refcount the folio_put() in kvm_gmem_allocate() is
>> dropping though:
>>
>> + The refcount for the filemap depends on whether this is a hugepage or
>>    not, but folio_put() strictly drops a refcount of 1.
>> + The refcount for the lru list is just 1, but doesn't the page still
>>    remain in the lru list?
>
> I guess the refcount drop here is the one get on the fresh allocation.
> Now the filemap has grabbed the folio, so the lifecycle of the folio now 
> is decided by the filemap/inode?
>

This makes sense! So folio_put() here is saying, I'm not using this
folio anymore, but the filemap and the lru list are stil using the
folio.

> <snip>
