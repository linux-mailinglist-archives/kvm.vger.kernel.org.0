Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96303C17FF
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 19:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhGHRX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 13:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhGHRX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 13:23:57 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B90DC061574
        for <kvm@vger.kernel.org>; Thu,  8 Jul 2021 10:21:14 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id q10so6054647pfj.12
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 10:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QCo14xV8rAUzfCQotnJU7VU371YftBdUOIgGhDFsTfQ=;
        b=uKrPkQ7z//kRJCEDNzlJq3jk9963Z+56kAkAGNixVeitn98yJqkQMIhBYO1kGOdsDG
         ChwAe9JIO+Y+NVLtWJVhoW37GHQ5l6q7n9Hs15/uIcr0+YY1NhV3cU7rgWfuhjUTHLDP
         F3kPdaqUAsErGeyoU4v1lN/j9va7VuIJ44dMfTd+0mnRTjHW4xzPYoWJwUMgGkF0JOje
         yORTgZVVMPOSQeFNwMbzTh7Lu303zxcjjeBLIZLrQBzzlZ/WjxLtyKdSusYE9v+IZDfE
         KxEkj8zPLAJPsvrgrpuUwkSAwQa4v0VHjEq84bmaS4mtyQypu42ylkQklHjyK5Tu1ZyD
         nQmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QCo14xV8rAUzfCQotnJU7VU371YftBdUOIgGhDFsTfQ=;
        b=Yj/URtjzrfiUjzImNDvuQ298cujfkQ07Je7q6ZYx3ZO9ayeogo03lCyOwBGrJPlGVr
         hGPmvlulC/uqgeo0LfDCnFr4PT8XwM4p1vSvSrCKh3j1k1K5TUzcJJdRlYMyp+FPlOhW
         xUmeP/Ynpp1/V2pHbGvginfTXT28rI/zL+Mpf7Va/iJ1M7cGALi8Q9PCQeYY550RKwTA
         JRuVn/LwbLPf7MyFckqu3QaYlg8FWZP7ZO4ewLQ6+yOaypw3Q/E2ifsrSJzxZ6iN/OdK
         GO4PGwVGD5YXsdCP/CrfSppUF8lKcQgZsMdLDlrdTF7Q4Faxv2bQuzbvWiH6mVOBKrnh
         Rq0Q==
X-Gm-Message-State: AOAM531HuPjeIkFSwJhOB2vq10Aw6undfnKn5fg9JQ693XDVarduVin5
        iakE8jvL5aQi7BamqCTn95go8Q==
X-Google-Smtp-Source: ABdhPJxw9Zesv74cgLZNu9iz4EI0aH/v4a9liAq8BZawNc4Jve8bQGGcctC73X4IMo9Il18j/byJCQ==
X-Received: by 2002:a05:6a00:b41:b029:324:2cb7:ed97 with SMTP id p1-20020a056a000b41b02903242cb7ed97mr13631893pfo.53.1625764873255;
        Thu, 08 Jul 2021 10:21:13 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id h14sm3833299pgv.47.2021.07.08.10.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 10:21:12 -0700 (PDT)
Date:   Thu, 8 Jul 2021 10:21:09 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 0/5] KVM: x86: Use kernel x86 cpuid utilities in KVM
 selftests
Message-ID: <YOc0BUrL6VMw78nF@google.com>
References: <20210422005626.564163-1-ricarkol@google.com>
 <c4524e4a-55c7-66f9-25d6-d397f11d25a8@redhat.com>
 <YIm7iWxggvoN9riz@google.com>
 <CALMp9eSfpdWF0OROsOqxohxMoFrrY=Gt7FYfB1_31D7no4JYLw@mail.gmail.com>
 <16823e91-5caf-f52e-e0dc-28ebb9a87b47@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16823e91-5caf-f52e-e0dc-28ebb9a87b47@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 08, 2021 at 06:50:41PM +0200, Paolo Bonzini wrote:
> On 29/06/21 19:28, Jim Mattson wrote:
> > > Thanks. I was thinking about kvm-unit-tests, but the issue is that it
> > > would also be a copy. And just like with kernel headers, it would be
> > > ideal to keep them in-sync. The advantage of the kernel headers is that
> > > it's much easier to check and fix diffs with them. On the other hand, as
> > > you say, there would not be any #ifdef stuff with kvm=unit-tests. Please
> > > let me know what you think.
> > 
> > I think the kvm-unit-tests implementation is superior to the kernel
> > implementation, but that's probably because I suggested it. Still, I
> > think there's an argument to be made that selftests, unlike
> > kvm-unit-tests, are part of the kernel distribution and should be
> > consistent with the kernel where possible.
> > 
> > Paolo?
> 
> I also prefer the kvm-unit-tests implementation, for what it's worth...
> Let's see what the code looks like?

I'm not sure I understand the question. You mean: let's see how this
looks using kvm-unit-tests headers? If that's the case I can work on a
v3 using kvm-unit-tests.

Thanks,
Ricardo

> 
> Paolo
> 
