Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F5F65F948
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjAFBpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjAFBpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:45:50 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9663C0EB;
        Thu,  5 Jan 2023 17:45:49 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p24so196895plw.11;
        Thu, 05 Jan 2023 17:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UpVMk2Dd9I4vOTdEu8HrQBo7c2QIPMfLOnbWvVFoEe8=;
        b=VVRMf023mEb+lXLvmYBe0prP7T1MkHBxI0ieybJRA3FV6TxfdPFe91YGH5vWJdmhAO
         PwilYacb9BwcGW3yWNCR/Rv91+44hniVBZoKUBnEssAP3z26dbfYc6FZ9/l3X+jJe8Ig
         +nArDYp50AU0+z6YD0QAh6iQ7Tl9ly+P2Uke/fE8z4Y1aKZYZmkY/dS3UQrO+YfADUFo
         vfl0w6mUqa2TnOeowLSirwXxVzSANaC+ErGzIjFudAI/C19xBamJg55YhpQr1sJV4aJt
         hWt1FtmYmcOC/F38j4YXcYwi8wEvpC/kBNxtqtRB+cLftgtVLHj73twgONj0CCjVx3CQ
         jJ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UpVMk2Dd9I4vOTdEu8HrQBo7c2QIPMfLOnbWvVFoEe8=;
        b=0+iLsU4SjW5RXLLZSkpOvkKGXA+J2CCvIx7kqA/Q+5G0kjBTVcN0H/Ljt20SSfzwqR
         CWPxjR0WjQmzwLcgkIyJVZbcWvyU03qiwbECXI+K7KmJ8FQOxkuBGcgll0i1nF6DpQJd
         23Db9kIZKAoH+j08zQ0mKrIavJKoZ90/ezQG42hdcDizPnNi+veZupzAmlu0vm9Jevg3
         iSgJ1g4sflJ8ztu9Z8/R7a/0wWIwccujseZU7OfVNXxu8cKueEvQYmoa8Tqe4lBeUOEX
         PAACyEfTEQIpwPYvISkB2d9Lh/A2RPuTS80x5bmz48NqSAYJiyoAMWKTPrk5r6t4XiYd
         MmVA==
X-Gm-Message-State: AFqh2kqkvHGyhYXauga4OwHJ/XkVN7XsbDPRf1YYJQlat0wCYUQNXGJN
        ckMNTBbjbsmmBtt8z6ANB9t3YfQrCqJGZPjQELbZJQbX
X-Google-Smtp-Source: AMrXdXsosIdVez0q2J6MRpLF29MJCBr6h5gCfKqWCFvJT4wJzUgd3nlsLwp/FYGQoBW6LadKurLzq9j4ZsIjeGeoPuI=
X-Received: by 2002:a17:902:cecb:b0:190:f88e:255 with SMTP id
 d11-20020a170902cecb00b00190f88e0255mr4090961plg.114.1672969548950; Thu, 05
 Jan 2023 17:45:48 -0800 (PST)
MIME-Version: 1.0
References: <20221213125538.81209-1-jiangshanlai@gmail.com>
In-Reply-To: <20221213125538.81209-1-jiangshanlai@gmail.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Fri, 6 Jan 2023 09:45:37 +0800
Message-ID: <CAJhGHyDr6WH+yREd4=ua--c1BA7s5HNHLGJoPSSWAOAwECCZ+g@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86/mmu: Remove FNAME(is_self_change_mapping)
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022 at 8:54 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
>
> FNAME(is_self_change_mapping) has two functionalities.
>
>   If the fault is on a huge page but at least one of the pagetable on
>   the walk is also on the terminal huge page, disable the huge page
>   mapping for the fault.
>
>   If the fault is modifying at least one of the pagetable on the walk,
>   set something to tell the emulator.
>
> The first functionality is much better handled by kvm_mmu_hugepage_adjust()
> now, and it has a defect that it blindly disables the huge page mapping
> rather than trying to reduce the size of the huge page first.
>
> Huang Hang reported that when a guest is writing to a 1G page, but
> only a 4K page is mapped because of the first functionality in a case
> in which we think a 2M page should be mapped.  The 1G page includes
> a pagetable on the pagetable-walk, but the narrowed 2M page doesn't.
>
> To fix the problem, remove FNAME(is_self_change_mapping) for its first
> functionality is already and better handled by kvm_mmu_hugepage_adjust(),
> and re-implement the second functionality in FNAME(fetch).
>
> Reported-by: Huang Hang <hhuang@linux.alibaba.com>
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---


Hello,

Ping.

Thanks

Lai
