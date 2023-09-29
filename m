Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993D27B379C
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 18:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbjI2QQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 12:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjI2QQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 12:16:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D06E1B0
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 09:16:32 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c74e099ba9so3583235ad.1
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 09:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696004192; x=1696608992; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m8ED9VoqMtCkpTtLFW76301m/H4UqXDUmHKK4VWKxuU=;
        b=i5VZrFf39qcbI5+2i83FP4hCAYvEg1tCgbJ9Kw6v47hKRD4KHU7unUTziGpsbfyDxe
         kb6A8aQIZPBNWC89ASc3UJ+CiVHMIoiAVaEmrGeDDp1/zSbeZepDlVd5SomC/mUwh/1P
         HZiGRjHrV8+GhK3DRYhQxyEjHjpte+BKoqDGcMTnOW7Z9o9P4qwLZrlFnJixbB7M9Ipc
         +0xi5Iupw9eINZ66RbKnwRHrwdB14/57jjFr8b3OYrefDJrPX9p0q9thilexW/1kQoO3
         Gbak6IHcDj5RAP/IOT34zMvSkIYLeRQuXEJaTeNn9QdPvYGLUrzKgImdDE0e4wuVkoO5
         FXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696004192; x=1696608992;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m8ED9VoqMtCkpTtLFW76301m/H4UqXDUmHKK4VWKxuU=;
        b=JiZdGVsCTcZ9eop1cAnF5mLfLQUicbU1YLyrLYdSR7hvy3hgzdYBNBRpBMpDH/1dk9
         5JcH9uhOd5svGT5nsotA+jjLl01r9GtQ+AiTUila+ZGaDp5oP4uZb4eUL5vPrtm4PHNk
         NQwKeFw+OQbPGK/t+0KQEEf19CxfD43a0/HjQmP87qYFSNYOCuFpffWGqh+xePSLmaxR
         Nwc4s8aJjWGTVJtqK54gcbzd6vCkBJGsxfrKqE+97s+OmrmJ3uc71oW/5fGdktYff42d
         NP43y8qzfiYQ+bfni7LtB6qps7FWsK1tdEt+KkBtf8az5IShDj8Ra/TGCDw6XOdTiMjx
         npmg==
X-Gm-Message-State: AOJu0YzUaSyMkE5CEi7WBjTl7zHXRZKxlcijMc6dkyybM+n5OhA6c6Lb
        NmGR/ljzTZ2af6kpJfl6qGZgh+lFKTc=
X-Google-Smtp-Source: AGHT+IEcMBD7diQ2LsTM7SpHys4JB1miD267Z1vsK5Ye4CIryM3/plPRl3GXLRwP4mzyviTl1KO7x4CE6Ps=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c9:b0:1c7:2bb4:54fb with SMTP id
 o9-20020a170902d4c900b001c72bb454fbmr63696plg.4.1696004191965; Fri, 29 Sep
 2023 09:16:31 -0700 (PDT)
Date:   Fri, 29 Sep 2023 09:16:30 -0700
In-Reply-To: <202309291557.Eq3JDvT6-lkp@intel.com>
Mime-Version: 1.0
References: <20230928162959.1514661-4-pbonzini@redhat.com> <202309291557.Eq3JDvT6-lkp@intel.com>
Message-ID: <ZRb4Xt2ORf7gT5Cu@google.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: always take tdp_mmu_pages_lock
From:   Sean Christopherson <seanjc@google.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 29, 2023, kernel test robot wrote:
> Hi Paolo,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on kvm/queue]
> [also build test WARNING on linus/master v6.6-rc3 next-20230929]
> [cannot apply to mst-vhost/linux-next kvm/linux-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Bonzini/KVM-x86-mmu-remove-unnecessary-bool-shared-argument-from-functions/20230929-003259
> base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> patch link:    https://lore.kernel.org/r/20230928162959.1514661-4-pbonzini%40redhat.com
> patch subject: [PATCH 3/3] KVM: x86/mmu: always take tdp_mmu_pages_lock
> config: x86_64-buildonly-randconfig-004-20230929 (https://download.01.org/0day-ci/archive/20230929/202309291557.Eq3JDvT6-lkp@intel.com/config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230929/202309291557.Eq3JDvT6-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202309291557.Eq3JDvT6-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> arch/x86/kvm/mmu/tdp_mmu.c:289: warning: Excess function parameter 'shared' description in 'tdp_mmu_unlink_sp'
> 
> 
> vim +289 arch/x86/kvm/mmu/tdp_mmu.c
> 
> 43a063cab325ee7 Yosry Ahmed         2022-08-23  278  
> a9442f594147f95 Ben Gardon          2021-02-02  279  /**
> c298a30c2821cb0 David Matlack       2022-01-19  280   * tdp_mmu_unlink_sp() - Remove a shadow page from the list of used pages
> a9442f594147f95 Ben Gardon          2021-02-02  281   *
> a9442f594147f95 Ben Gardon          2021-02-02  282   * @kvm: kvm instance
> a9442f594147f95 Ben Gardon          2021-02-02  283   * @sp: the page to be removed
> 9a77daacc87dee9 Ben Gardon          2021-02-02  284   * @shared: This operation may not be running under the exclusive use of
> 9a77daacc87dee9 Ben Gardon          2021-02-02  285   *	    the MMU lock and the operation must synchronize with other
> 9a77daacc87dee9 Ben Gardon          2021-02-02  286   *	    threads that might be adding or removing pages.
> a9442f594147f95 Ben Gardon          2021-02-02  287   */

The bot is complaining about the kernel doc, i.e. the above @shared documentation
needs to be deleted.  Took me a few seconds to understand what the complaint was
about...
