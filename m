Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E923C1A0B
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 21:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhGHTtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 15:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhGHTs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 15:48:59 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5961FC061574
        for <kvm@vger.kernel.org>; Thu,  8 Jul 2021 12:46:16 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso4638120pjp.5
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 12:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k10aRlUR7+OenDnP6mq1+oUG1mQi2nyXNA5HL2wFblk=;
        b=tnwoBooFdiCi3VUYZyjDBH4NCUpnInfxgZzdF1DnFPpZhiv7iN0HRd6tcUYkzUH7CW
         K/L+mRD2zCQrpgIrl/Us2ba5zt43o98P/IJgWJ59FMZe/PIAKZPd+K06586DaEegyGrq
         8GzEw4rg6jE3WTNMn+vjuj4GO1K/Z7nVKf6DLxAHIQE2OZkpBQ8ISddmsWMvxBeP0Bn2
         0F6+ClblpQkXgS163bvyRRRC2U6AJUD91F9Xet3zEYezdOzst53EUYrTAyKeB/9uVoN3
         r1qNr5jZvxSCxbwdh/GrupxuwrVCaKZgy0q2kJogWhveU+J92XrqlnFvcPOfqvGdVMVD
         VkTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k10aRlUR7+OenDnP6mq1+oUG1mQi2nyXNA5HL2wFblk=;
        b=NhVR4XHN07cMaLB4kQI9P9WLazZSVTyB6aqfjRpJZZidf+EaHpRAOXgw6oTIV9hYhk
         5oNuEDNyY70ED12Ut4dCHPJdRFWNP/MA8NXyaM/XfvC9flzuM3m9+A7y21Y9iE80UkLN
         lhkBdFMOUQbFk/ujhldylKLEPUFYm5brnfVWY1yHIRzZyo2vcHtNlUFCrco7njUYRz5i
         N9dbLco41H7RXclRWwlrsL8s+el96gUW4lLXIJvy66uMyL9R2N9FPiw99HQ7Ojj6Xylb
         v3W37CsIFyMBbgMfzfyQf9jEb/Pn3F7wyHQR5q7CtEHpuD4T/9DZJ2gsDuapXQp0mpFK
         gZSg==
X-Gm-Message-State: AOAM531uMBB0lHHGEraSWXG7IiY2tX6MC6Z7VIv5Iq8NPSmb21zF3hre
        7Btlitu2fP4nw4rruIzJ6PPYUMC3hi9KiFZB
X-Google-Smtp-Source: ABdhPJwOcUHeTLiJbsu1zhkSv1UmqJ2IxztsciphD6g2qsBayBD2RlaGEk1noqHgiIwFshn8QKKIiQ==
X-Received: by 2002:a17:902:b409:b029:129:a9a6:fc76 with SMTP id x9-20020a170902b409b0290129a9a6fc76mr13442909plr.68.1625773575662;
        Thu, 08 Jul 2021 12:46:15 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id y9sm3506954pfn.182.2021.07.08.12.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 12:46:14 -0700 (PDT)
Date:   Thu, 8 Jul 2021 12:46:10 -0700
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
Message-ID: <YOdWAvtk66Rbv9Lk@google.com>
References: <20210422005626.564163-1-ricarkol@google.com>
 <c4524e4a-55c7-66f9-25d6-d397f11d25a8@redhat.com>
 <YIm7iWxggvoN9riz@google.com>
 <CALMp9eSfpdWF0OROsOqxohxMoFrrY=Gt7FYfB1_31D7no4JYLw@mail.gmail.com>
 <16823e91-5caf-f52e-e0dc-28ebb9a87b47@redhat.com>
 <YOc0BUrL6VMw78nF@google.com>
 <8a4163ee-ac31-60fa-4b8b-f7677ec0fd46@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a4163ee-ac31-60fa-4b8b-f7677ec0fd46@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 08, 2021 at 07:57:24PM +0200, Paolo Bonzini wrote:
> On 08/07/21 19:21, Ricardo Koller wrote:
> > > I also prefer the kvm-unit-tests implementation, for what it's worth...
> > > Let's see what the code looks like?
> > I'm not sure I understand the question. You mean: let's see how this
> > looks using kvm-unit-tests headers? If that's the case I can work on a
> > v3 using kvm-unit-tests.
> 
> Yes, exactly.  Thanks!

Cool, will give it a try and send a v3.

Thanks,
Ricardo

> 
> Paolo
> 
