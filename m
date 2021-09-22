Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032FE414C68
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbhIVOuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbhIVOuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 10:50:32 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A60C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 07:49:02 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id w19so2875678pfn.12
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 07:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0sqc+8Rn23i9NIXRc3rzWglOlIsYoDOCKK+U0vVnVf8=;
        b=i17P/LE0kBMgmTnemIWdlFQzqY0Hs2jbI6I1/q7BOVL5p2dtOUMx0v77u9KgBVc6Wn
         aKV+BPEmJqQFBnpf2JgmIIqtssY8WUcJgn0PyaL+KfSiTDztZbnAplBfnqcfDhlXXfFn
         BjrKCa5IqUkRjskJLByrIP0vUAdGBFoOpGk78YEBagXPKCi9T3kxBnFA97BcpKw7BZcR
         bmLTSv6ivPklBCfoVzjL+iJjEelTUzY+vAJf7MF3MbJsLpnqXAXpI4Q3beusWaRqYBkI
         4OoNyyAV9qr/c1FTp2tfQsv3gnSyBPHEnLObwapHJkjxKwND1CbJf6lm69JT2lSfnhHf
         qYCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0sqc+8Rn23i9NIXRc3rzWglOlIsYoDOCKK+U0vVnVf8=;
        b=nOb6JSN4E56xUjRXdfrCtWylkVAs8fsLccx/j0s5Mi031V8eevr1kz5MTLN41f0wBs
         q+LutZhK7ImuVUz9b7xydK1x+Ml3eABrbf3NBNYzkShrVlT4fUMibiWQ0288oByueXtx
         ZMjjS3ZTXr74wCFC3JqArrQ0Sh/b8A4NX7v5MA6IcV83R2V6BX1+0oy+RBQkKYjsQRne
         41XgB5xxOTmvnaHF1/ctH/cMpkiQmk4VY/wFMB9a+E06EfPJFqTDAHEriFDG30kfGc1i
         ClNjAJFJgozLlAgd/y5XUgYog7T2AFs2cmFzijw2XkPOpguiQgU82opzPVlVtfn4+1mM
         JKRQ==
X-Gm-Message-State: AOAM531Out2lwI5qGQ74RaUsRNvlFLpMqkklQ3QdjbhV8mqLE29CMWxn
        MAZaH1Y0Fn8g2XLFN6Y+IkPlYg==
X-Google-Smtp-Source: ABdhPJyY3Fv9QcnunPtvdtmn1QYeYqhfMcgkYKWmFqTAaf0DAX+dPQteKaq7uTqZ/uQmOkkrqsksfg==
X-Received: by 2002:a62:5fc7:0:b0:438:9e3a:b8c0 with SMTP id t190-20020a625fc7000000b004389e3ab8c0mr22443pfb.74.1632322141372;
        Wed, 22 Sep 2021 07:49:01 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x19sm3250084pgk.37.2021.09.22.07.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 07:49:00 -0700 (PDT)
Date:   Wed, 22 Sep 2021 14:48:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-csky@vger.kernel.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH v3 08/16] perf: Force architectures to opt-in to guest
 callbacks
Message-ID: <YUtCWOYJwCUYDYtW@google.com>
References: <20210922000533.713300-1-seanjc@google.com>
 <20210922000533.713300-9-seanjc@google.com>
 <f2ad98e2-ddfb-c688-65af-7ecbd8bc3b3d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2ad98e2-ddfb-c688-65af-7ecbd8bc3b3d@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021, Paolo Bonzini wrote:
> On 22/09/21 02:05, Sean Christopherson wrote:
> > @@ -1273,6 +1274,11 @@ static inline unsigned int perf_guest_handle_intel_pt_intr(void)
> >   }
> >   extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
> >   extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
> > +#else
> > +static inline unsigned int perf_guest_state(void)		 { return 0; }
> > +static inline unsigned long perf_guest_get_ip(void)		 { return 0; }
> > +static inline unsigned int perf_guest_handle_intel_pt_intr(void) { return 0; }
> > +#endif /* CONFIG_GUEST_PERF_EVENTS */
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Having perf_guest_handle_intel_pt_intr in generic code is a bit off.  Of
> course it has to be in the struct, but the wrapper might be placed in
> arch/x86/include/asm/perf_event.h as well (applies to patch 7 as well).

Yeah, I went with this option purely to keep everything bundled together.  I have
no strong opinion.
