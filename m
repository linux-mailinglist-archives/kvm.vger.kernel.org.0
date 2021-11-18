Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11174456224
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhKRSRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbhKRSRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 13:17:34 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27616C061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:14:34 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 8so6853437pfo.4
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lbp4MqK4c4z46q/2aYIm+UQvoFvvxFhTS5B7WVrAEA8=;
        b=ZBJBE1l2bVWc31h1gSBYlaeKhfXICxNNZZh4GSHjPRpL/HcYekj89wSpDHqQ0PWapE
         p06o68QrvN7pgpY7AxFh7kOaRq3uoQeW808ZTUSvQJYFGgriMKP8pzqt9N7jhALjr6lv
         9BF2eHpQJ+rZdd6q0LF9SugofO0pZ0osBfrse9ZPZoI6aVpgPpH8Uw/UdhUfL2XnsrgR
         W1EV1uUvDrZ2cN5S68b6Zth7hrY+35LNhU9K2HMa8LEJWpkz6+L4tMY7M9p32Aae09De
         5BYE4VaXV+6oK1bsdTFVzezx7a+h35quyjqtKjRKR4JzrUvYUTZ5gqbKh/UgUT2az07o
         pVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lbp4MqK4c4z46q/2aYIm+UQvoFvvxFhTS5B7WVrAEA8=;
        b=nbS4eN825cb9LYdS0lWrfRvNeZitZ+9uAyy0gRIxKKymbOgHw3rozWqRwnTM3qrtJo
         kzdPaEXT5F4JPlCfc2kUhSMZn8JF/dVHsVwaal97nQ2o4vjfS7I7v6JuVUfbYhhV6OF1
         UP1H09KcWc/m0JaqSw8oiKK+RvMS/0Nb8hVd/wzoNh3rz66GkjlnwGKZegCFAk/qQm67
         L6YnaA2mrROq7y+ABnt87lfQz5A+fIoSJcFfWKaQ8fmP0CHs+B3Cd/vJsJkAlfbmKNfj
         iA0cAvvmUUQ63nMu9zcFzlOFuWZBM3TYRUo2LAnMYMcw2fQbBu373tA8BeOdGxpF52Dp
         1DNw==
X-Gm-Message-State: AOAM532aOWWT5vOrWSfLJjYoseWeu3IwcsFBMtmv+dIHxHLwojZXZ1dl
        v6LbCbKz7z21wwKPORzUy4+2qg==
X-Google-Smtp-Source: ABdhPJwjDPgQSoqj/zhVHGckKLjTYkAZpZu+dwkqMC5y0WTkG3fcKlYNus6y0JPo9sIcu71qwcxclw==
X-Received: by 2002:a05:6a00:cc8:b0:49f:c4a9:b9f1 with SMTP id b8-20020a056a000cc800b0049fc4a9b9f1mr16915645pfv.32.1637259273548;
        Thu, 18 Nov 2021 10:14:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d2sm310276pfj.42.2021.11.18.10.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:14:33 -0800 (PST)
Date:   Thu, 18 Nov 2021 18:14:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [RFC 11/19] KVM: x86/mmu: Factor shadow_zero_check out of
 make_spte
Message-ID: <YZaYBUkNgnaiFEtQ@google.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-12-bgardon@google.com>
 <YZW02M0+YzAzBF/w@google.com>
 <YZXIqAHftH4d+B9Y@google.com>
 <YZaBSf+bPc69WR1R@google.com>
 <db8a2431-8a05-bd50-dd79-74c814c71edd@redhat.com>
 <YZaVKcFoKR4lqDIZ@google.com>
 <12a5ad9a-c1c5-852c-5041-096d2c518f8c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12a5ad9a-c1c5-852c-5041-096d2c518f8c@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021, Paolo Bonzini wrote:
> On 11/18/21 19:02, Sean Christopherson wrote:
> > > but that's not a great name because the former is used also when shadowing
> > > EPT/NPT.  I'm thinking of standardizing on "shadow" and "TDP" (it's not
> > > perfect because of the 32-bit and tdp_mmu=0 cases, but it's a start).  Maybe
> > > even split parts of mmu.c out into shadow_mmu.c.
> > But shadow is flat out wrong until EPT and NPT support is ripped out of the "legacy"
> > MMU.
> 
> Yeah, that's true.  "full" MMU? :)

Or we could just rip out non-nested TDP support from the legacy MMU and call it
the shadow MMU :-)
