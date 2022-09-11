Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED425B4B67
	for <lists+kvm@lfdr.de>; Sun, 11 Sep 2022 05:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiIKDBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Sep 2022 23:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiIKDA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Sep 2022 23:00:58 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B963BC60;
        Sat, 10 Sep 2022 20:00:55 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id t65so5169914pgt.2;
        Sat, 10 Sep 2022 20:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=vZI0secSgQDVrrZ+hFN1G6qYcS6FtuxhXb5Cw3ioq1o=;
        b=dk1lGuiTcpQkGUNntG9Ljl+sZo+KHgQKWbcIIqKqHjGHIY5LFa2xj33wcqM9KAM8q8
         hekmOJSYNqkJyN3vguQH8UvIhfiQiwR9rW0WmbKhz1sOQzQlqoMoiIdCr0jcOvjUcCuy
         OEpl+YIaozB0WSnHtk9iv2hcGbt200V+lwUpRBS8ESk4FWVDKrsi/WDnSuhsAaQUujsz
         4nK2skcdPuKDQXy/DYMPe6wKwEQ7nWjN6otX+nI+JINecX1JR7YcNGP1cqGBLsqcMU4l
         Kz4Ley6Nod17cNGGniCkhwyqDfNyAHMkTtJ4YDWAyCn5P/cXk4LyZCx2VYJPDtJIjvGI
         tDnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=vZI0secSgQDVrrZ+hFN1G6qYcS6FtuxhXb5Cw3ioq1o=;
        b=0/9r5Z51eQ7xwRcTQ9y+POu0VsyirWBMaPg5ao25DIrRrq+uuv+wZlEfnti6IjAbe7
         4rXQM82SuW8B5IqnFvPk9yDueUyPz7f3GgtoRALMHdDxkT3EQs97K/gPz9iPhf1FvqFg
         rLaJj/H4oN9dNuvRq2mSzvQgUScIhcS/sbMkUfNnl0+4j6ejYSE6xXZ2fIsHIhCCx5+j
         okXHw6qFcA93VZoRdRJ67ecE6ToJ/yPGgnHZjZZGTHTlMQDyDWK9SRYGKSO41AxR9n+R
         6TlaYqSj0/oX2Jiei+seTlLK6zKk8zYW/J4wEMMDTv1uNuNx5a9XVT8ZqyVP6MJ5f77c
         MkQQ==
X-Gm-Message-State: ACgBeo2nPJgLxJK6uAStnafRyEuCdh9a3m5FT+LP/1DUZK9xBlbMHPaM
        sqoZbqV2eNAHe0S2lqS4770=
X-Google-Smtp-Source: AA6agR4V0mATiwXObkReV+vUpqV3pq96JVLqyCyT7/nmoaVbUuk1Y8WMVIZKG35xB/epeu5HwHEUKQ==
X-Received: by 2002:a63:2cc2:0:b0:41c:681d:60d2 with SMTP id s185-20020a632cc2000000b0041c681d60d2mr17565592pgs.502.1662865254401;
        Sat, 10 Sep 2022 20:00:54 -0700 (PDT)
Received: from localhost ([192.55.55.56])
        by smtp.gmail.com with ESMTPSA id d8-20020a170902654800b0016d295888e3sm2951367pln.241.2022.09.10.20.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Sep 2022 20:00:53 -0700 (PDT)
Date:   Sat, 10 Sep 2022 20:00:52 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     isaku.yamahata@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH v4 16/26] KVM: kvm_arch.c: Remove a global variable,
 hardware_enable_failed
Message-ID: <20220911030052.GB873583@ls.amr.corp.intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <60ca73d7d931ec8046ac50b20f05723a97ef643b.1662679124.git.isaku.yamahata@intel.com>
 <YxrjDdn5xCxrJYUT@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YxrjDdn5xCxrJYUT@gao-cwp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 02:54:05PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
> >index 4fe16e8ef2e5..ad23537ebe3b 100644
> >--- a/virt/kvm/kvm_arch.c
> >+++ b/virt/kvm/kvm_arch.c
> >@@ -13,14 +13,13 @@
> > #include <linux/kvm_host.h>
> > 
> > static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
> >-static atomic_t hardware_enable_failed;
> > 
> > __weak int kvm_arch_post_init_vm(struct kvm *kvm)
> > {
> > 	return 0;
> > }
> > 
> >-static void hardware_enable(void *caller_name)
> >+static int __hardware_enable(void *caller_name)
> 
> nit: caller_name can be dropped and use __builtin_return_address(0) instead.

Do you want to update your patch
"KVM: Provide more information in kernel log if hardware enabling fails"?
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
