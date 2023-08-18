Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158DE7812A7
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 20:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359123AbjHRSPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 14:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379478AbjHRSPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 14:15:32 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC0EE74
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 11:15:30 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bde8160fbdso17125085ad.1
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 11:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692382530; x=1692987330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2UpHtort9A6GjNTa35crOHhwpakPEKD1yUlcxtVr0FM=;
        b=Wf3bir3HeQk+WypI1ZAPThcOJ8gBnSqr+4uMmAGs5XkTifA1Jk+MIDWHiHZRdNk0+C
         M5661hEphU/S9CH1QehwULjXmETLlJNjdYP7x4EH3ZdU2MpvGa5UN9y+2vDZICrkZDzZ
         9a649TKMt+pSSYcAeMrscys6un16n6z/fPt7iyYlqM4sbvaWGeLiX+6zLD4vT13u8GdA
         3bdku6+tGWd8ndlrBLcc0mCDTPvthWqpoilu/rEO+XcSveGnU4nmPXc5G48yPu6t9WW9
         xAesWTGzznMOvZ3+KVJhuC/+J7hHFF43hvk0Pb9RuSXACDXlbQZZQTwmjhwqyIP7otfl
         IU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692382530; x=1692987330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2UpHtort9A6GjNTa35crOHhwpakPEKD1yUlcxtVr0FM=;
        b=gniN+g5YaBJxHBqEBGZ/e9nffBe0H56azsIBq38FuSZ6ne8/YWwu2lugja+7n63M4E
         gfXzwHlvLrXf0rTeVlV9sDpvwLxrZafqIvZgC3LQ0gTyoqc1BwFBh3kJYuvYaDDpI5K5
         BumB0eDvtxX3hWG993s7UlA7ShUnPONaE3sCyFOdi3TNnqWoLzr5JaQOfPDRSisMAHfD
         nePuQn8GTs4zqxvqWS2RmZI7YQi2/os+kdX4y4f95C152veGJQOuGWXQp2RhvpagSB49
         cSCYOBJkjj5dzS5WLYhzPaInPA8Pfalz7xV3UR6hoYTHJfP3cgLmX6bypXzb8hGXt3BO
         sa7w==
X-Gm-Message-State: AOJu0YyBVyIVu8NZllL83sjK+uDF/qMo+GV3QOhh3aWKMMiHxySqxshf
        McwLmfEs4hI6WZZ6FDioFH1D/tmwu8I=
X-Google-Smtp-Source: AGHT+IFIP6KRkFSo7uDQ6UxRK3c68Ehxfv1w9ffi6BGnhY+oGbePYtHkVZUTFVjvumMFptQ/4PuZ+lXpYqw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f547:b0:1b8:8fe2:6627 with SMTP id
 h7-20020a170902f54700b001b88fe26627mr1183892plf.8.1692382529796; Fri, 18 Aug
 2023 11:15:29 -0700 (PDT)
Date:   Fri, 18 Aug 2023 11:15:28 -0700
In-Reply-To: <c3128665745b58500f71f46db6969d02cabcc8db.1692119201.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1692119201.git.isaku.yamahata@intel.com> <c3128665745b58500f71f46db6969d02cabcc8db.1692119201.git.isaku.yamahata@intel.com>
Message-ID: <ZN+1QHGa6ltpQxZn@google.com>
Subject: Re: [PATCH 7/8] KVM: gmem: Avoid race with kvm_gmem_release and mmu notifier
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add slots_lock around kvm_flush_shadow_all().  kvm_gmem_release() via
> fput() and kvm_mmu_notifier_release() via mmput() can be called
> simultaneously on process exit because vhost, /dev/vhost_{net, vsock}, can
> delay the call to release mmu_notifier, kvm_mmu_notifier_release() by its
> kernel thread.  Vhost uses get_task_mm() and mmput() for the kernel thread
> to access process memory.  mmput() can defer after closing the file.
> 
> kvm_flush_shadow_all() and kvm_gmem_release() can be called simultaneously.

KVM shouldn't reclaim memory on file release, it should instead do that on the
inode being "evicted": https://lore.kernel.org/all/ZLGiEfJZTyl7M8mS@google.com

> With TDX KVM, HKID releasing by kvm_flush_shadow_all() and private memory
> releasing by kvm_gmem_release() can race.  Add slots_lock to
> kvm_mmu_notifier_release().

No, the right answer is to not release the HKID until the VM is destroyed.  gmem
has a reference to its associated kvm instance, and so that will naturally ensure
memory all memory encrypted with the HKID is freed before the HKID is released.
kvm_flush_shadow_all() should only tear down page tables, it shouldn't be freeing
guest_memfd memory.

Then patches 6-8 go away.
