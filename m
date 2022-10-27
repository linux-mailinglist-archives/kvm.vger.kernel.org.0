Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4674960FB93
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 17:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbiJ0PNv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 11:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236096AbiJ0PN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 11:13:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AC65BC8E
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:10:20 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso1732442pjc.2
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mOE5YC1odPIto26VxcFgI67eA84sQCrj5U7fBUEDyi0=;
        b=eXnHhADxkOpmHCjFYTbu1ZvZ1jCEa8WprtP/t7Q5QISj6+dYBvxq+MnuheOzZzs8Vc
         Rjf3Akm+pFNY/j3rUVAYDBATizUq6Pp7KRpuyb3yWrVM9suPFtRMaqoEZqAWSAY/W2RN
         NYe+7TE+YMZK9aC5ik6kEmhc8iD0g/BLpfFvuBfRaxb0v/ytxNAoSE8JNHKB7qk/GZJv
         +gfl4EAF1ZJgb8tMThqihIc3AUWeQoURRRJybCGBnGPljDsXYCjJpZxXYhvmU4EeQi+Q
         UZ1rEh2B3q2Y4SA2e8tkkIcrggqLVIOJXNUJjiBJ0+0ACwJ6doJKFHaoEZVO/v8z6vSP
         WjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mOE5YC1odPIto26VxcFgI67eA84sQCrj5U7fBUEDyi0=;
        b=ojnf4EPLPnXxDgxbZSAIrCG7oxIhdJ7PqcjPJFa8yJrhBidzTfCvLoWaJKd7d1J9qH
         KeLAUVy1R1nMNLMu9rPhiYmI1wYCc0HFofZu/yWh0Z8CQ6I69Io/pblo4+v65EGe43M8
         dJCIDB2Vz/V3FS+gWvUF0sKraT+hxnKs3l9UQYzfO1O9i0o/+aISR/GSC/0OhCT/TdTT
         PVix+g6Yu8gMLGea69+2gGabG+KyuwKiudwqn7UhNAGXp0CNabIWdWFwduzKJ7vi/fTR
         fDiFfO2Wr90QjFwBQCgnCKRLUMqbg1KC/zIXP3Ru8WK3PGY5b/FLoweQN9KZQIdfSNJh
         cm2g==
X-Gm-Message-State: ACrzQf3+/Y7fXqzan71KP4d+bm05Xl4I4iIxsDZyqQge4fZp/WQqanYI
        wR9ESFX1KKVEVqK5xEOXSCs/gA==
X-Google-Smtp-Source: AMsMyM66QVbKSRENFn3nLdhkQIQI25NOpIUCGPF9SlBKViXjUpQ7Fp/DYlrCw/wv48s5nn552R4TAA==
X-Received: by 2002:a17:903:2286:b0:182:2f05:8abb with SMTP id b6-20020a170903228600b001822f058abbmr48146922plh.14.1666883411687;
        Thu, 27 Oct 2022 08:10:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a10-20020a170902ee8a00b00186dcc37e17sm1292899pld.210.2022.10.27.08.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 08:10:11 -0700 (PDT)
Date:   Thu, 27 Oct 2022 15:10:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 03/16] KVM: x86: Always use non-compat
 vcpu_runstate_info size for gfn=>pfn cache
Message-ID: <Y1qfT2Mnwk5GmjFI@google.com>
References: <20221013211234.1318131-1-seanjc@google.com>
 <20221013211234.1318131-4-seanjc@google.com>
 <afad5f40-03ef-1380-9bfe-03bbaaed47a9@redhat.com>
 <Y1qZagwM0dMBjYhe@google.com>
 <24768aa3-0e2e-6d29-2749-9d74a26f9205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24768aa3-0e2e-6d29-2749-9d74a26f9205@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022, Paolo Bonzini wrote:
> On 10/27/22 16:44, Sean Christopherson wrote:
> > > - long mode cannot be changed after the shared info page is enabled (which
> > > makes sense because the shared info page also has a compat version)
> > 
> > How is this not introducing an additional restriction?  This seems way more
> > onerous than what is effectively a revert.
> > 
> > > - the caches must be activated after the shared info page (which enforces
> > > that the vCPU attributes are set after the VM attributes)
> > > 
> > > This is technically a userspace API break, but nobody is really using this
> > > API outside Amazon so...  Patches coming after I finish testing.
> > 
> > It's not just userspace break, it affects the guest ABI as well.
> 
> Yes, I was talking of the VMM here; additional restrictions are fine there.

Additional restrictions are fine where?

> The guests however should be compatible with Xen, so you also need to
> re-activate the cache after the hypercall page is written, but that's two
> lines of code.

And do what if the guest transitions from 32-bit => 64-bit and the cache isn't
aligned for 64-bit?  E.g. kvm_xen_set_evtchn() will silently drop events no matter
what KVM does.  In other words, I don't see how KVM can provide a same ABI without
forcing the cached pages to be aligned for the largets possible size.
