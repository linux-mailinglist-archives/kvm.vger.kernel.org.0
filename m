Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AD6701266
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240598AbjELXXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbjELXXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:23:32 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A918F0
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:23:31 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-644d9bf05b7so5710233b3a.3
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683933811; x=1686525811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8ljHnrY6VdN7PYdreXu26+ii27Kp3emVsixsuksMV4=;
        b=1AcbTCG9to2+VB/AW4VUY/jUl5B6kV/vGeEKSZuYfBfpFOKACrD2ld1bfbB5ibzUXe
         XRiY4Dq0oV4bQM86oSZLHKmZ+J5j67QbDFzyLEaLY86co4PhiypJYjSZIgMeyAqtQ+WD
         Rz8zkt0aYmeGCC87auXIgg6O4KZoTAb1yuZpusUiHxQiZCWAnCo+QoOyxbwjYVf8lfbi
         PABPYcsFinm6Z56fiHkxxxP6zrb7NoiXdDEAET086BE4T9F9tSEYNkjYnPu9dccMF/Wc
         LAu1ckS75VjcWmgbC+sAAa9KIrsU0+bMH8RkGJ24AOl/mB+cgDtBT7799Z7cm7ntuH1p
         8Igw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683933811; x=1686525811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8ljHnrY6VdN7PYdreXu26+ii27Kp3emVsixsuksMV4=;
        b=l5gvltXm+yXr9gi4sjlQ4I5NqDEqUgC2BZ6rBHT4PhNGcolKh3uqZvWZ8KPcBgB/Wn
         j/QdsA+fo/Aci/++FvbHyc1zkrgmR7gQ2KpKpFVIS9oVPG5p25pPuqOsSio7zCYYh3zx
         3GE2loSanxnFOd7XmZtSlYrHSMCVXP8kPEWQ1uaGFo8YaNgYSa4sxIJifYLIqbVvboRh
         BUAd2gRJHskr3TjiguoUq4JCgFK9i3X53QaPqGnpcLsTMUjJ3/fyrMou4Ah3X47RvXAB
         VvP9fOYhFhmOUPdhy2KQpbyYiMaQb/0QEeEDlPAAKFBN1rjvwStscCkn8YmL/7dbPKA3
         opJQ==
X-Gm-Message-State: AC+VfDxHWCPAAbOkU/HB8/OC+bTD4QGaDL+i7TR0jBakA/BRWQAKoP0V
        ljIElJDUCYvbsrOxZUXCntJYog==
X-Google-Smtp-Source: ACHHUZ5e81OK9etD7uBNfIwbII9YSC8SBz0Ovo0Hxd6lnAZfH0vM51CSW9NnPZw5kvcWLKpim+Kr6g==
X-Received: by 2002:a05:6a20:8e19:b0:f3:67da:9db5 with SMTP id y25-20020a056a208e1900b000f367da9db5mr30909564pzj.38.1683933810925;
        Fri, 12 May 2023 16:23:30 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id c25-20020a62e819000000b0063f172b1c47sm1353990pfi.35.2023.05.12.16.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 16:23:30 -0700 (PDT)
Date:   Fri, 12 May 2023 16:23:26 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 4/9] KVM: x86/mmu: Rename MMU_WARN_ON() to
 KVM_MMU_WARN_ON()
Message-ID: <ZF7KbsCXBQHnOv7g@google.com>
References: <20230511235917.639770-1-seanjc@google.com>
 <20230511235917.639770-5-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511235917.639770-5-seanjc@google.com>
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

On Thu, May 11, 2023 at 04:59:12PM -0700, Sean Christopherson wrote:
> Rename MMU_WARN_ON() to make it super obvious that the assertions are
> all about KVM's MMU, not the primary MMU.

I think adding KVM is a step in the right direction but I have 2
remaining problems with KVM_MMU_WARN_ON():

 - Reminds me of VM_WARN_ON(), which toggles between WARN_ON() and
   BUG_ON(), whereas KVM_MMU_WARN_ON() toggles between no-op and
   WARN_ON().

 - It's not obvious from the name that it's a no-op most of the time.

Naming is hard so I might just make things worse by trying but...

How about KVM_MMU_PROVE(condition). That directly pairs it with the new
CONFIG_KVM_PROVE_MMU(), makes it sufficiently different from
VM_WARN_ON() and WARN_ON() that readers will not make assumptions about
what's happening under the hood. Also "PROVE" sounds like a high bar
which conveys this might not always be enabled.

That also will allow us to convert this to a WARN_ON_ONCE() (my
suggestion on the other patch) without having to make the name any
longer.
