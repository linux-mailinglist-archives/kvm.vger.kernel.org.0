Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085825E6B0E
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiIVSfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbiIVSet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:34:49 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20B3B84D
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 11:33:36 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id y11so10652017pjv.4
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 11:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=JHw5orBQa9fjHWtiq5m7r5MDZM4jOrepTGAAQD/BpUI=;
        b=jCvcrIGB9qkCnasJ2L0iYh0pidSSCsNLKD8wCDLDy0S4OnYbRCnE+WqGvQFicSmk3H
         XG3W+6noNZbVNwgwLJ/jzRprNcfo8huoc4EEqDj5pag7AHnR8+klwdZ21DwdlZjLt8zh
         QYX+/kmz2tm28Xgbj2pWFI8wIpk4B7DdrLn7OXBfspA73uQ/L9Btg5SXH4WsI0lRk2kP
         NAhE+SY/9ZTN6cTVTf1PEeWwnqRMIEjDba3mRIgYk9eSp67Vl2dKum/AjOkOy6jQ5Jqi
         vaJ48e+LoyxrhMi72kTnzibFQlagCaDmLR85mXyFDoa25JDQQUBzdvC90adu6kw/QOaw
         +ADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=JHw5orBQa9fjHWtiq5m7r5MDZM4jOrepTGAAQD/BpUI=;
        b=6HxyL6BNJD5FAvZ9klC+JzBOy1r2dVJ5BzB4VUfteXliaK3/RKj9AUWE/Kpd4ZmlYE
         FuPcpUjdrlt9cwENL3JZ0dbmghGb9pSZYEocjJfAZULJlshArTGsrZb7mN9foxTFG2yD
         cqLzU1BmKr0Z1oaEGz8Ew0+JKkk4WZwpfPy3AkoV6ze/dmq2q8s/Bw9x1+sBAFS+Bxz/
         4swoeM/pFWoTbAJVkYJJABB9tNYaSGSn0SzEZHexiX5lKeL8GVUOG5m3mUe3HcHDwns1
         9cs2GdTY3W8DdWWMQf0/ksYz5sy88hcepdGSg/NdyCjKRkY6YP/z2LSzzBVwJJCiseo4
         5hhg==
X-Gm-Message-State: ACrzQf2BvIAiYpaxezl53KCvuQ+s9m4+OP5uLIf+rngB/eNeofxaSWCg
        lFXfQ3oozscep8VvC/W5dzeWBg==
X-Google-Smtp-Source: AMsMyM5mStuYZC5EKDjaUUVbyd5f7qTAfMX0b1EB0qsMWoehhrmpSYCKMFqWipvzb/5lmLe2C1KDQA==
X-Received: by 2002:a17:90b:1e47:b0:200:b9b4:ba0f with SMTP id pi7-20020a17090b1e4700b00200b9b4ba0fmr16718929pjb.245.1663871616008;
        Thu, 22 Sep 2022 11:33:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g13-20020a170902e38d00b00174a4bcefc7sm4356621ple.217.2022.09.22.11.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 11:33:35 -0700 (PDT)
Date:   Thu, 22 Sep 2022 18:33:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v8 07/14] KVM: selftests: Add vm->memslots[] and enum
 kvm_mem_region_type
Message-ID: <YyyqfG8RkS4G8x+p@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922031857.2588688-8-ricarkol@google.com>
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

On Thu, Sep 22, 2022, Ricardo Koller wrote:
> The vm_create() helpers are hardcoded to place most page types (code,
> page-tables, stacks, etc) in the same memslot #0, and always backed with
> anonymous 4K.  There are a couple of issues with that.  First, tests
> willing to differ a bit, like placing page-tables in a different backing
> source type must replicate much of what's already done by the vm_create()
> functions.  Second, the hardcoded assumption of memslot #0 holding most
> things is spread everywhere; this makes it very hard to change.
> 
> Fix the above issues by having selftests specify how they want memory to be
> laid out. Start by changing ____vm_create() to not create memslot #0; a
> test (to come) will specify all memslots used by the VM.  Then, add the
> vm->memslots[] array to specify the right memslot for different memory
> allocators, e.g.,: lib/elf should use the vm->[MEM_REGION_CODE] memslot.
> This will be used as a way to specify the page-tables memslots (to be
> backed by huge pages for example).
> 
> There is no functional change intended. The current commit lays out memory
> exactly as before. A future commit will change the allocators to get the
> region they should be using, e.g.,: like the page table allocators using
> the pt memslot.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
