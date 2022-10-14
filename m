Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2801E5FF56A
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 23:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiJNVaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 17:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiJNVaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 17:30:18 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12244B992
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:30:15 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id 10so5942111pli.0
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UaGZO5Hv6UO255nOsoKhnllnauSBkcqiuPiJxTDzjd0=;
        b=eLxbHnR+/Z0k38LQnsiu5GDDZYfLK1u8OX6UY90/yfUgW+27vqBsqXb8bCgtxbI5fh
         lgsWlvg8UEl9D+vdBm8p0JHe8QTEZLpD9uidBNQHB1UJ6Iutl7Ei5BQN38KSXT3r0Hrc
         wdL4oJQTCUk8iJfzvh+hsIEWpknOq9iY0mc6ekYsF4KfWLdersIn4WMWo3/te0V0V464
         OYXHMKslBz0+Ic1+K+93oHYnvp4U1RoegOTolMGhZ7PHNn4VH93CoXE2fwEgmXh97yrG
         rCeuvLu6YqMN4iTW47LO4DgBthdQ6Idt0LUJyRn3L/0Kl5tglDnwJVMuQO9ngGn+Ae7H
         Ld0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UaGZO5Hv6UO255nOsoKhnllnauSBkcqiuPiJxTDzjd0=;
        b=kLtPsIBfgvWBuSkHx9gxtZhjSOQY5wWC3Y2yOw0aAmtzJqyX2h3lvCNG8dHhbzazDL
         Di6KNBO1Qhm+5c511TLQVxcu6405yygswcXoRXWzPslWbf2kbgRup3wwuaJF0i/7LhqI
         iSvisxKKE0H89j2GAEvdqR+2rED0iIWJUvZpw0wQdMlzsf3Kcck0tcmBD0x9E570CNJX
         FOYyKOttn3VO3p4oa2mU6VxLkERSobQrqZhaWNBov6zUSRXgmTgkl0xRYv7FWDE4JddN
         oSn6JsNoxPpiUci2dnaUvvr/FAqusuSb1WeKLDYdCQDEaQL9fgHSUZNOyvd7N5ho7mPJ
         6heQ==
X-Gm-Message-State: ACrzQf1HqmTkBlJkuovddDdAcECQInJB3s88z8eSqPhhTKNnr3gP2luZ
        iMag6RkJUixh5HkJy/3g3dIc+/SLYoUK2Q==
X-Google-Smtp-Source: AMsMyM5ZZxiVnrK/NpY/bh0FFNLfQybRi6b93cxVHKJ5G5do04wwSqHxuNRfRJ2HCeiRqZMhzu3VWg==
X-Received: by 2002:a17:902:8e84:b0:178:71f2:113c with SMTP id bg4-20020a1709028e8400b0017871f2113cmr6994097plb.79.1665783014700;
        Fri, 14 Oct 2022 14:30:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r27-20020a63205b000000b00412a708f38asm1828522pgm.35.2022.10.14.14.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:30:14 -0700 (PDT)
Date:   Fri, 14 Oct 2022 21:30:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com
Subject: Re: [PATCH v9 00/14] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Y0nU4vIIyjfQuQGV@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 11, 2022, Ricardo Koller wrote:
> Ricardo Koller (14):
>   KVM: selftests: Add a userfaultfd library
>   KVM: selftests: aarch64: Add virt_get_pte_hva() library function
>   KVM: selftests: Add missing close and munmap in
>     __vm_mem_region_delete()
>   KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
>     macros
>   tools: Copy bitfield.h from the kernel sources
>   KVM: selftests: Stash backing_src_type in struct userspace_mem_region
>   KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
>   KVM: selftests: Fix alignment in virt_arch_pgd_alloc() and
>     vm_vaddr_alloc()
>   KVM: selftests: Use the right memslot for code, page-tables, and data
>     allocations
>   KVM: selftests: aarch64: Add aarch64/page_fault_test
>   KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
>   KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
>   KVM: selftests: aarch64: Add readonly memslot tests into
>     page_fault_test
>   KVM: selftests: aarch64: Add mix of tests into page_fault_test

A bunch of nits, mostly about alignment/indentation, but otherwise no more whining
on my end.  A v10 would probably be nice to avoid churn?  But I'm also ok if y'all
want to merge this asap and do the cleanup on top.
