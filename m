Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8063607BE6
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 18:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJUQOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 12:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiJUQOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 12:14:42 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7226399C6
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 09:14:41 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id h14so2831972pjv.4
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 09:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p7w2w/MW5/bGGzHO7GkFEcxzqWCtxzoSheQKtFpB84Y=;
        b=BmUYkTmUpsesYJyivwIPLevFmUf6sU0taECjMGBg33SFdAXRch3kIcYKTsgPdCj0eA
         Dh5wnT1v1UeLobi8vP+wn4T13hvmvqofLTxVPv+6x0qqlsmcC2/AIuAB/JBtqV1/Aueq
         7/7uj+rZsOlCkErDp3ANt4ikeTEO1DPxPXXrpb75nadH9g+vxn92tYzIN5bzWO3/UwTs
         iFvLLkbBIyHU/dcTwlcyYD5hSYEHbh4NnvR220hmTfXqxxFrWmXZFicGXx3DpiXw0kly
         GWDUh6Z9VFG1o/6zyntBJIkuEggSyRaIwR0pzMazLj5OZY6ONAu4Rm8x8qMr7SUxLjo2
         qw4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7w2w/MW5/bGGzHO7GkFEcxzqWCtxzoSheQKtFpB84Y=;
        b=ci6JOX+7M95TjDgbeDAyy1sUjKZgcutSxMB7dw8uSGE1CmBPSJ4BOjo7bpkkkXTArR
         Ve9UsQU0nz3naoHr//tupUE8+KjTtysVO9vTylLimgyaRPySD4d2oFeRqTcFyQRMcweR
         szISaO8uw4jccKSZeW0gzMYdg659FTjIv62V412iFODmlfG+cvjNHWouf1T28RWN2ho6
         eZi48TkzDc9eGp6LdOTD9HvPTAyeTf92UP/MbGBl1gc2LGd01zdeJGD38N/2W27znbFD
         Mm9mWHIeU57ffqPs/qZupADJUMYuJitAPnh0Vz0RlD1Vwbv9ZmYL/16BoOCorTYuzGJk
         pQnA==
X-Gm-Message-State: ACrzQf2AzdWTa4JP7Tq1AOF2GZvMpszRUQj/2i3qbbcZCHdNGPLOFFDB
        ey7ZTEB6WkB/5XuI3mlZgzhtyuFsJoA4qg==
X-Google-Smtp-Source: AMsMyM7AE5cybZSwUAcHvmbFDD0MxtcuNgDjw2xBVntg7RiOogbLwEi3+65vwuefObLaB9Bh4tmYSg==
X-Received: by 2002:a17:902:ec83:b0:185:581a:1c with SMTP id x3-20020a170902ec8300b00185581a001cmr19470371plg.78.1666368870573;
        Fri, 21 Oct 2022 09:14:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d11-20020a17090ab30b00b00202618f0df4sm36832pjr.0.2022.10.21.09.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 09:14:30 -0700 (PDT)
Date:   Fri, 21 Oct 2022 16:14:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 33/46] KVM: selftests: Hyper-V PV IPI selftest
Message-ID: <Y1LFYjyyHRiP8rNe@google.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
 <20221004123956.188909-34-vkuznets@redhat.com>
 <Y1B1eBIL9WhB4dwc@google.com>
 <874jvxcnyp.fsf@ovpn-192-65.brq.redhat.com>
 <87zgdpb8dc.fsf@ovpn-192-65.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgdpb8dc.fsf@ovpn-192-65.brq.redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 21, 2022, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
> > Sean Christopherson <seanjc@google.com> writes:
> >> Do you happen to know if errno is preserved?  I.e. if TEST_ASSERT()'s print of
> >> errno will capture the right errno?  If so, this and the pthread_join() assert
> >> can be:
> >>
> >> 	TEST_ASSERT(!r, pthread_cancel() failed on vcpu_id=%d, vcpu->id);
> >>
> >
> > The example from 'man 3 pthread_cancel' makes me think errno is not
> > set. 'man 3 errno' confirms that:
> >
> > "
> >        Note  that the POSIX threads APIs do not set errno on error.

Ah, that's annoying.

> > Instead, on failure they return an error number as the function result.
> > These error numbers have the same meanings as the error numbers returned
> > in errno by other APIs.
> > "
> >
> > but nothing stops us from doing something like
> >
> > #include <errno.h>
> > ...
> >
> > errno = pthread_cancel(thread);
> > TEST_ASSERT(!errno, pthread_cancel() failed on vcpu_id=%d, vcpu->id);
> >
> > I believe.
> 
> ... only the fact that this won't be thread safe :-( i.e. if we also try
> setting 'errno' from vcpu_thread() (where the pattern for
> pthread_setcanceltype() is exactly the same), we will likely be
> reporting the wrong errno.

errno is thread safe.  From https://man7.org/linux/man-pages/man3/errno.3.html:

       errno is defined by the ISO C standard to be a modifiable lvalue
       of type int, and must not be explicitly declared; errno may be a
       macro.  errno is thread-local; setting it in one thread does not
       affect its value in any other thread.


> I think it's better to keep reporting 'r' for now (and maybe think about
> pthread* wrappers later).

Yeah, definitely a future problem.  pthread wrappers are a good idea, I doubt
there's a single KVM selftest that wants to do anything but assert on failure.
