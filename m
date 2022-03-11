Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAA34D5809
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 03:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245743AbiCKCUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 21:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238252AbiCKCUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 21:20:39 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8A8E6D93
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 18:19:37 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id h2so2716349pfh.6
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 18:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RryUuol3Ylo4uqhnnPi8mUdUlrjxjJpVahPqVRRMRrc=;
        b=BcPBYZyZprDcx+IbcqYMhON72+fH6zR3XH526BzNCXAXytQh20KAPR4p5fYrKTc9vs
         uO+0TFZc6iKrP4NFkAbJv53WJCoJvFTeE5pDI2VJRXOyG6SecZvQ4PV/g4DqsxzCEznK
         gDK2Qgx23qcHSmcqAk7XWwH+sC38AibZg1p36hGKBDIZIEJhQNq+1fNY+Dm3mcHd0PV7
         cF9YVj4Mxd0F4NsHdIBE+/unKMg+sfZbvwCUT+SKzUZTX6L5rPQQDyZDOwTyt0qOp7Kg
         202wy7Eug99PsrXAFGVEwTd88Gco2RUY2wu2fV9Jv1N+/lFIGL7PRyEtEqI+N7DW5iM9
         Ff+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RryUuol3Ylo4uqhnnPi8mUdUlrjxjJpVahPqVRRMRrc=;
        b=xLIeSdl0XlRLysa2bbh0B0hR2enpXlDGDTedITdzCLefMgmHps5y7SPJAMi/ZDPKj4
         2S4ppjwmLSoRD90ofT1SZZm/G9CSzKrxzj2TeDfjXIjd8PwFo4WQea0QYR1Ck/9bmAce
         Yl/VsEJBPGXfNvr50LsrPBF4x1nT6qTWabc3OsHPI4r3XJfqKQ/QWkti8h3oG2VoHGMX
         2L+ty8DRt/0R3TCetnkSh6tZfWCwzNa3ULkM1c6HOFHup8JnRI+GkzAx/8QbXvCUbDZo
         sxkHuUgjrSMUyhfxQMPHyIb4ZfnPHzXHGM3pzsEkLOLTE6I5MtFlT8kW7cjBy1jWYDPo
         ZLcA==
X-Gm-Message-State: AOAM530MSSEOa2t00YkHHycqejXLy0Ds9dTaKgjYFXukcXQxgcUQb/TM
        tz5o28etAhF+a9nxkeTcg8xJiA==
X-Google-Smtp-Source: ABdhPJwlYb8ABr9x+ddIrRLA23skw7Ni1f9WWTKFKNjJO9rhDZfuN1KpcKEnzeP5T8aNDhnXHTQ/nQ==
X-Received: by 2002:a05:6a00:218d:b0:4f7:439b:64f1 with SMTP id h13-20020a056a00218d00b004f7439b64f1mr7775354pfi.8.1646965176279;
        Thu, 10 Mar 2022 18:19:36 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e6-20020a056a001a8600b004f78e446ff5sm74838pfv.15.2022.03.10.18.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 18:19:35 -0800 (PST)
Date:   Fri, 11 Mar 2022 02:19:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH 00/13] KVM: x86: Add a cap to disable NX hugepages on a VM
Message-ID: <YiqxtIz+T1LGE1Ju@google.com>
References: <20220310164532.1821490-1-bgardon@google.com>
 <Yio8QtuMd6COcnEw@google.com>
 <CANgfPd9xr5ev7fEiwBVUi89iHkuywq-Ba9zOeCMSTFmLkO243w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9xr5ev7fEiwBVUi89iHkuywq-Ba9zOeCMSTFmLkO243w@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022, Ben Gardon wrote:
> Those patches are a lot of churn, but at least to me, they make the
> code much more readable. Currently there are many functions which just
> pass along 0 for the memslot, and often have multiple other numerical
> arguments, which makes it hard to understand what the function is
> doing.

Yeah, my solution for that was to rip out all the params.  E.g. the most used
function I ended up with is

  static inline struct kvm_vm *vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
						     void *guest_code)
  {
	return __vm_create_with_one_vcpu(vcpu, 0, guest_code);
  }

and then the usage is

	vm = vm_create_with_one_vcpu(&vcpu, guest_main);

	supp_cpuid = kvm_get_supported_cpuid();
	cpuid2 = vcpu_get_cpuid(vcpu);

My overarching complaint with the selftests is that they make the hard things hard,
and the easy things harder.  If a test wants to be backed by hugepages, it shouldn't
have to manually specify a memslot.

Let me post my selftests rework as RFC (_very_ RFC at this point).  I was hoping to
do more than compile test before posting anything, but it's going to be multiple
weeks before I'll get back to it.  Hopefully it'll start a discussion on actually
rewriting the framework so that writing new tests is less painful, and so that every
new thing that comes along doesn't require poking at 50 different tests.
