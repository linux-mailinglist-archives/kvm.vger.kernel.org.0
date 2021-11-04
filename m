Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CD3445537
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 15:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhKDOYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 10:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhKDOYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 10:24:09 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1C9C0432C7
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 07:18:31 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id j9so5552562pgh.1
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 07:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GgU1oUsck/kv7V8rA9YPXtLGsU5UGF/lzeg6fggjKVY=;
        b=RTR1r+Ui0w7nUSHbbKl234uth/uzF1T7qF0sliOvvfsRTTb+Ux1LBt/ffQdTAY+/ec
         E1O0cYaxUcP9JJO91gsHWRMciPl/F1cyjYk822jBCR9TBPiuByHH3wQyg8CO0RsG69s3
         xxzxbxhqtVhFtR1IL3PwpUwYtMOSHDPFnwjUBiz3EACBzoEuXHLTOpHAkW6OfrqPvopQ
         XlcXyGEUw7b6wzkLr4K8OvDzbhOksbBNbi3EmpkiMJmFBXoGv87f+9auU+g0UJJslfkq
         YHd6yOra6jxs1gpwYkmD3+RM+zmhPNdO2qhY5Blp/Ql4/z42+YEAbgjAkELLYFLa2Wdb
         1tBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GgU1oUsck/kv7V8rA9YPXtLGsU5UGF/lzeg6fggjKVY=;
        b=6AQTEV8t7qJMkw1R0j7dFx5xBwysaMudUkQ0mZPpOXK9cb7om/cLM/Q6I2apCoBIT5
         1w27lwRNPMIoE+rpWEcHkETTr4zYRyelGquYenqgXzobs+K5hv5UdrJ8+LV9eSGa5/QK
         FePAdEOVFkFc96GKNhkTBRRvPDywqsg7SoontiCBa0++XJSxxODdNkDuJ6wwSP1msc6W
         0DjD6GoprsRCrqZMkmrRhnFtnVh/7Mgt/P0OuLRbSfiG9sq1OhKXmjN3NXqcvDm6uChI
         UJlMgGAClMZBFpEzgyusN2mRYF1J24lU8a7b3+k4A3j6PVAG9ABeKDPZ12I5slFa6cu0
         UNUQ==
X-Gm-Message-State: AOAM530WreRkzEIiyARYCtmtIuJLqbEcJ2RMtBdx+JKl/0lQMkpVi/tX
        AqvuQgwqRsoc1WuVyzMiFSlGaQ==
X-Google-Smtp-Source: ABdhPJxdt1yraCn5ATAvpc1jCPrfM/2fIu0pWDknNbK+x2XDbxsbKhM1gzBOeaAuduFP4pk+NDgWGQ==
X-Received: by 2002:a65:5b01:: with SMTP id y1mr22260090pgq.451.1636035510920;
        Thu, 04 Nov 2021 07:18:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c9sm4061004pgq.58.2021.11.04.07.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 07:18:30 -0700 (PDT)
Date:   Thu, 4 Nov 2021 14:18:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Ingo Molnar <mingo@redhat.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greentime Hu <green.hu@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Marc Zyngier <maz@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Guo Ren <guoren@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH v3 01/16] perf: Ensure perf_guest_cbs aren't reloaded
 between !NULL check and deref
Message-ID: <YYPrst2CUBXLYc9h@google.com>
References: <20210922000533.713300-1-seanjc@google.com>
 <20210922000533.713300-2-seanjc@google.com>
 <77e3a76a-016b-8945-a1d5-aae4075e2147@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77e3a76a-016b-8945-a1d5-aae4075e2147@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 04, 2021, Like Xu wrote:
> On 22/9/2021 8:05 am, Sean Christopherson wrote:
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 464917096e73..80ff050a7b55 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -6491,14 +6491,21 @@ struct perf_guest_info_callbacks *perf_guest_cbs;
> >   int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
> >   {
> > -	perf_guest_cbs = cbs;
> > +	if (WARN_ON_ONCE(perf_guest_cbs))
> > +		return -EBUSY;
> > +
> > +	WRITE_ONCE(perf_guest_cbs, cbs);
> 
> So per Paolo's comment [1], does it help to use
> 	smp_store_release(perf_guest_cbs, cbs)
> or
> 	rcu_assign_pointer(perf_guest_cbs, cbs)
> here?

Heh, if by "help" you mean "required to prevent bad things on weakly ordered
architectures", then yes, it helps :-)  If I'm interpeting Paolo's suggestion
correctly, he's pointing out that oustanding stores to the function pointers in
@cbs need to complete before assigning a non-NULL pointer to perf_guest_cbs,
otherwise a perf event handler may see a valid pointer with half-baked callbacks.

I think smp_store_release() with a comment would be appropriate, assuming my
above interpretation is correct.

> [1] https://lore.kernel.org/kvm/37afc465-c12f-01b9-f3b6-c2573e112d76@redhat.com/
> 
> >   	return 0;
> >   }
> >   EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
> >   int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
> >   {
> > -	perf_guest_cbs = NULL;
> > +	if (WARN_ON_ONCE(perf_guest_cbs != cbs))
> > +		return -EINVAL;
> > +
> > +	WRITE_ONCE(perf_guest_cbs, NULL);
> > +	synchronize_rcu();
> >   	return 0;
> >   }
> >   EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
> > 
