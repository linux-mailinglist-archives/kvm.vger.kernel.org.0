Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D8C5B77D3
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 19:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbiIMRZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 13:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiIMRZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 13:25:19 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD049E2E4
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 09:12:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id go6so7601197pjb.2
        for <kvm@vger.kernel.org>; Tue, 13 Sep 2022 09:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4GTld6ZU8MtCcyeBG9nWMSKRKMoB2xn8bpkZwXHEw2s=;
        b=DihabYGaFpN/XoOHm1MSaQi2kRH2os0yj0QoILo7SPAJF8OpMSQjLf1+pqVt7GZRjd
         D81sKZU5Oq0vtGEgr0Plm1UVQOezX4s/yuWlGktjKnB/6aqUWru04VRRHhXjgMf9lgKo
         FR9C6O8IdbFGuxPJakYZ4BdDTShUXISvdElPZULkotAb3nTa0x7V27hT49l5H57ZEuzT
         Y2ncOVkRrhHKP66UtZI06AJkG7HRBc21aMZ2rHU6LkxtwqHKRvYMVYVLxRX743DN2L19
         qdr5gZklkks6Bi/hi2Z1rhwNsdKW/awWh0sDR0Rahs+8lcIfTne4V8e5TEE/NSU59M4J
         aEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4GTld6ZU8MtCcyeBG9nWMSKRKMoB2xn8bpkZwXHEw2s=;
        b=JnDQkRVgKD2xQAuYpF+TepinUMwKjB7hhOKnoFZuQezw3bFohrcSTtCtx+fp0lJgmU
         QmLAPlQAZBbKLbOX4vCFwr5N+t7/+ta3iqx/C+n+yMzGJZEhqf8XDf0aGuyKC64B99tD
         Wu3PeUyVqpMzBA2t3ZLNJFiucBP4jiQEee+RUpCHlnZ43eyygBUk0Nvingk3zXysurkd
         qwcWzeaD9K2arNpKsJfv2PhYAHn2Zx1HcN+JmEK83qp7Z4CoUMwlaQ0t38w+SySN7JSV
         Ly7oRHuA5vRnzXm/ZZdELX0Ru+ivBkzu8m1ccquaiDCHu1KWBymvsM3daGieSEWSg0RT
         KCew==
X-Gm-Message-State: ACgBeo28eDbHdngXgI8mfEwaOXtPPxe44h9pkldOebm+Pe3cG9FS3xBp
        oAuKk5EGMrV9bDgxl2F1TTF1BA==
X-Google-Smtp-Source: AA6agR40QaognMZ1z9EKqE4W87Ed5lvL47BWBF35ur3fvygfSXXOQSwbnkou/SgHBPbWX+ZFZu3LkA==
X-Received: by 2002:a17:902:ce12:b0:172:9512:595d with SMTP id k18-20020a170902ce1200b001729512595dmr33361116plg.101.1663085528936;
        Tue, 13 Sep 2022 09:12:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ij24-20020a170902ab5800b001783f964fe3sm3191697plb.113.2022.09.13.09.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 09:12:07 -0700 (PDT)
Date:   Tue, 13 Sep 2022 16:12:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, qemu-devel@nongnu.org,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>, luto@kernel.org,
        jun.nakajima@intel.com, dave.hansen@intel.com, ak@linux.intel.com,
        david@redhat.com, aarcange@redhat.com, ddutile@redhat.com,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>, mhocko@suse.com,
        Muchun Song <songmuchun@bytedance.com>,
        "Gupta, Pankaj" <pankaj.gupta@amd.com>,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: Re: [PATCH v7 00/14] KVM: mm: fd-based approach for supporting KVM
 guest private memory
Message-ID: <YyCr1IfPWtAHmrwN@google.com>
References: <20220818132421.6xmjqduempmxnnu2@box>
 <c6ccbb96-5849-2e2f-3b49-4ea711af525d@google.com>
 <20220820002700.6yflrxklmpsavdzi@box.shutemov.name>
 <c194262b-b634-4baf-abf0-dc727e8f1d7@google.com>
 <20220831142439.65q2gi4g2d2z4ofh@box.shutemov.name>
 <20220908011037.ez2cdorthqxkerwk@box.shutemov.name>
 <YyBQ+wzPtGwwRB/U@google.com>
 <20220913132821.3ch5cv3rgdxqgz3i@box.shutemov.name>
 <YyCZZSyCrwXLLCD9@google.com>
 <20220913160046.rkz7uh6cpwy6wyzg@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913160046.rkz7uh6cpwy6wyzg@box.shutemov.name>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 13, 2022, Kirill A. Shutemov wrote:
> On Tue, Sep 13, 2022 at 02:53:25PM +0000, Sean Christopherson wrote:
> > > > Switching topics, what actually prevents mmapp() on the shim?  I tried to follow,
> > > > but I don't know these areas well enough.
> > > 
> > > It has no f_op->mmap, so mmap() will fail with -ENODEV. See do_mmap().
> > > (I did not read the switch statement correctly at first. Note there are
> > > two 'fallthrough' there.)
> > 
> > Ah, validate_mmap_request().  Thought not implementing ->mmap() was the key, but
> > couldn't find the actual check.
> 
> validate_mmap_request() is in mm/nommu.c which is not relevant for real
> computers.
> 
> I was talking about this check:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/mmap.c#n1495

Hence the comment about 'fallthrough'.  Thanks again!
