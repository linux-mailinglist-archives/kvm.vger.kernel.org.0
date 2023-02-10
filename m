Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877F66923B3
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 17:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjBJQyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 11:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbjBJQyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 11:54:14 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E2A1167C
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 08:54:13 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id m2so7081935plg.4
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 08:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J3jP/FVeKqvhJpM+QE0UM1W//XR/6fa/Br2TVuQNjKk=;
        b=QzUbR1U+NtQX5jDzqlzCSeeww3wnzPgAxUER8vufYdOpsiQmDVLhmP6L4T+y0mJWSm
         hcIgG/dlZ43aPScQg+Z65NOlQWPbzQAPSwuq7YCpXtZE+OfjYjN6TJa8cRGx7xYgklZp
         qyg6XFnyNbKrp5+IHW3YPjIZWRQo9x33eyO5dvohAq2/qrSNNkhoYfi2wnkwJOAG89/h
         9rHtAN2X61FrWWpRlnKURk5Jeu9JjvSkgGybufNxV+ATLMVYDv1dWhM+ZEKH/rOdtHFy
         /dm1bo9cRT0871n7mo80fgkOxrqCLvWTHLi5PtWpjJ68Z5Ew7Ajshz7MWwU/FtEVrW0A
         0x4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J3jP/FVeKqvhJpM+QE0UM1W//XR/6fa/Br2TVuQNjKk=;
        b=4/zGGbwch0ew5J5nN9zRysXb4FJxlZntZkQxJLbHz6SDsRGu+zJkWTo7fllUMH4DQr
         SqviHrf7HgfsbrXOC8OohqVF6CD/EoOSbU84DmX35ylp2Ywk9QTqfDmp3iLZUwFOO6/l
         T2VCrr0pgb0Jhct8AlrcnCf/aankDq+9vJuMHvZADrpEo/c43AI1XuI4SBHagX9fXX+V
         C3uV+nEOkBUgBXpLnkkQFgSBTGQSbUVRuUH6XmYNWLl7VM8JL28gqUVL0xvEV9zP/Ybr
         qmn81QwWBmbOgpWbaHjZM3JTQwmAqcMe52hGTDCq30Kqh4UdB7i4BKT4yQlMpFe5/K1W
         qlYQ==
X-Gm-Message-State: AO0yUKW36C4z+XjqEfVKgYioMygZDF1t2uiryM5GuiZABCKBaTKL226u
        5xY67oFhpuIBpK1Y4iVhu+1OvA==
X-Google-Smtp-Source: AK7set/zZM7dPuJVGyS965+Zc8wli9Ze3KU1YXdyfn2Ps53blIXYLFx/TCYI4Cay5IBct8xNlc+qYw==
X-Received: by 2002:a17:902:f0d4:b0:198:af4f:de09 with SMTP id v20-20020a170902f0d400b00198af4fde09mr206318pla.9.1676048052704;
        Fri, 10 Feb 2023 08:54:12 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v8-20020a17090331c800b00199023c688esm3624777ple.26.2023.02.10.08.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 08:54:11 -0800 (PST)
Date:   Fri, 10 Feb 2023 16:54:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com,
        yu.c.zhang@linux.intel.com, yuan.yao@linux.intel.com,
        jingqi.liu@intel.com, weijiang.yang@intel.com,
        isaku.yamahata@intel.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 3/9] KVM: x86: MMU: Commets update
Message-ID: <Y+Z2sLTnD4UTv2m4@google.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-4-robert.hu@linux.intel.com>
 <Y+XrStGM5J/hGX6r@gao-cwp>
 <565f9b25ffbe4aef08dd8511ea66b0cb3f1d932d.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <565f9b25ffbe4aef08dd8511ea66b0cb3f1d932d.camel@linux.intel.com>
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

On Fri, Feb 10, 2023, Robert Hoo wrote:
> On Fri, 2023-02-10 at 14:59 +0800, Chao Gao wrote:
> > On Thu, Feb 09, 2023 at 10:40:16AM +0800, Robert Hoo wrote:
> > > kvm_mmu_ensure_valid_pgd() is stale. Update the comments according
> > > to
> > > latest code.
> > > 
> > > No function changes.
> > > 
> > > P.S. Sean firstly noticed this in
> > 
> > Reported-by:?
> 
> OK. Sean agree?
> > 
> > Should not this be post separately? This patch has nothing to do with
> > LAM.
> 
> It's too trivial to post separately, I think, just comments updates.
> And it on the code path of LAM KVM enabling, therefore I observed and
> update passingly; although no code change happens.

No need, I already applied a similar patch:

https://lore.kernel.org/all/20221128214709.224710-1-wei.liu@kernel.org
