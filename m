Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30E956AD46
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 23:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbiGGVLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 17:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236742AbiGGVLc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 17:11:32 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735702E6BE
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 14:11:31 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id e16so9073933pfm.11
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 14:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZTnfo6xRgRnDJAawujjn6RVFJwv9JbaWoUFvSQYT7gc=;
        b=b6mVfEU3B1Kz+nxNI3jjT4RpusLpAVsVtGCThcqz2WxsNk8Y3tI17P9xznRGksBAb+
         8GtcLKGD6SqLecoii/sJRZBzYe/oHHfCmBQ6KyjOUKEs9JbhsSO8LlGC7Gg3qZOKpu6t
         R+U7jZ4wKm/B+FwKq2Z/bXAYtTf5NK7zJgDRNJHgaUVfPSOGNvaRqHsaiOSfkPwSd99I
         8OUzNcHpzBwaMfSLWuFKpCaWhXyShGNvFjcSuQGRbO512wy3OM/j+/9PUvBMJJDZlQt4
         pVg+ex6bvlhCnCQYp6vGAzpwe0MyOM/LaQwAKdRF13SuWllj3O+oHHym/YUmAyOh3Fqs
         358g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZTnfo6xRgRnDJAawujjn6RVFJwv9JbaWoUFvSQYT7gc=;
        b=MKcxlENF4FA0T9NKYzkPrTHJdqsvBbUKkYEUTjOeJ5bf8zMokbpX3zR7ZFybk3gr4g
         qq+9XXD6RwUQOJCLJoxdhAyv0DHfpMh6BqjXDlRHCT8ijvFyOL/WgYB7TdRBv+I0TtZR
         uf5LRvGNl7KbgEU9RCF29IvGqlkysEA3mUVol3YcnPTVd1XN/6nzhRMYNKkEKK5SJFt5
         7V+qe+TZduhu6N5wfzW6OzQtsUdwWPYmpg4V3cZAQowXLiUopN2w7w8vM/emxVbON+wv
         9t0yOBSP/n/pJVfT1uI7sts1DVffmCnvKikbdPvBdvl1c91ttz6kO81qKWiLLayLkNoZ
         3dbQ==
X-Gm-Message-State: AJIora/Iw6WCvVwgr55jIi97lHRGLrE1qu708rPLS9anpcAElDk7NDQy
        +6BrUcD+0OR/Mk6zqrGosvmpzA==
X-Google-Smtp-Source: AGRyM1so1CUFpRb/W+9u8G0bNWrE/aR8hrt1uZojq1495gVto4hEMFt63EXSJhIZ1QbYWGtmOiiswQ==
X-Received: by 2002:aa7:9215:0:b0:528:56ba:ccec with SMTP id 21-20020aa79215000000b0052856baccecmr179112pfo.24.1657228290881;
        Thu, 07 Jul 2022 14:11:30 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id k23-20020a628417000000b005289fad1bbesm3853638pfd.94.2022.07.07.14.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 14:11:30 -0700 (PDT)
Date:   Thu, 7 Jul 2022 21:11:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>, Huang@google.com,
        Shaoqin <shaoqin.huang@intel.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v6 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Message-ID: <YsdL/mgrbCCM/mtr@google.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-4-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628220938.3657876-4-yosryahmed@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> Count the pages used by KVM mmu on x86 in memory stats under secondary
> pagetable stats (e.g. "SecPageTables" in /proc/meminfo) to give better
> visibility into the memory consumption of KVM mmu in a similar way to
> how normal user page tables are accounted.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
