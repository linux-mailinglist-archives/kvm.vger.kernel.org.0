Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954A4379689
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhEJR4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhEJR4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:56:46 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DE9C06175F
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:55:40 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id b15so3343584plh.10
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ENyXchrEwZFqrIacbznFvbJBEbNl/lZ9i1nxAnl+9g=;
        b=UYnI3HCSiBU6cvrm7dQI9tdEKSpp7CV9MxA5EuqiU1bGvJozPE8d1aTvUMwq39OvOd
         6hCzlmIZ4HAEv63tDmVIVKWs9W/onufqIfZR0FJAiNKvjvqbAGyfuN9WDmRCYeKCbSO5
         eJyWoEjCXEYhAF6SLKA5MebZNUldv1yONyhuZjb36IRxEIqV5b5WDCOkbL8OQ7vb4pRh
         IowdP6NS5bWsZGrw8dyywqqSnSDrD01UxPFtiSFzC7LaB1fWvGvTe61QibO+dQemlWPB
         jWxT35Zkc40rObpO+UVyCdQmjq+8lF8jqrR13Mp0g7PBbaExIEj5E/xbQS+K2pBE5lU4
         SNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ENyXchrEwZFqrIacbznFvbJBEbNl/lZ9i1nxAnl+9g=;
        b=purNldR9wqX+jv+96WML6iFxeg1JISI2oPhSNQY3Rlomm0xtZwfrUeLc8M49jugWRG
         Ut8gLIWYrayLY5F1/rHL+fEaO85nvScXY7+e/Ei9y/PQhOWFaAtf21g+/9P7sTHxTDfp
         wElsLSJAB6xSWPmiNKYDIueEanh/B5SYxA20OOo3TPCvRVyBrUfcLtKxl3mg5FfOMcZj
         6snBQZGnuGJJRyWI7a86P/IuEiKIBqe6SLa6iq6pZciUsaUC38Gp0B6z+P/ozrX/wOey
         QEOTGld3om2WapiTJ3X9FVIjz45m6808+fkn1kp2oqiSx37nQfPWOWDnlkAV8VTkmtqM
         nyug==
X-Gm-Message-State: AOAM531ucCjS6eQtUgWqgO3t1hsjLVPBQIFcobS+BZZvCcVO3zdWdSZw
        fx8F21SgCBgBgKksVtA8Re9dyZAQ14Wl4CmhfaODug==
X-Google-Smtp-Source: ABdhPJzYS0mfwifF6JB5ZMhzPe6Yj6fIZ8OsHaCnRLd+QrUH0DbuWH4cUGjgbuEIW9GLWUClBxbn5gr61i4+/DsRBU0=
X-Received: by 2002:a17:902:f203:b029:ee:af8f:8e4b with SMTP id
 m3-20020a170902f203b02900eeaf8f8e4bmr25110542plc.23.1620669340375; Mon, 10
 May 2021 10:55:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com> <20210504171734.1434054-10-seanjc@google.com>
 <CAAeT=FyKjHykGNcQc=toqvhCR281SWc6UqNihsjyU+vuo3z5Yg@mail.gmail.com> <YJlixiTcwFkrnxIL@google.com>
In-Reply-To: <YJlixiTcwFkrnxIL@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 10:55:24 -0700
Message-ID: <CAAeT=FxTfF2-FsKn93u3ba1Rdg8ehz6XUG9G=bBT7fx_OtXgdw@mail.gmail.com>
Subject: Re: [PATCH 09/15] KVM: VMX: Use flag to indicate "active" uret MSRs
 instead of sorting list
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Shouldn't vmx_setup_uret_msr(,MSR_TSC_AUX,) be called to update
> > the new flag load_into_hardware for MSR_TSC_AUX when CPUID
> > (X86_FEATURE_RDTSCP/X86_FEATURE_RDPID) of the vCPU is updated ?
>
> Yes.  I have a patch in the massive vCPU RESET/INIT series to do exactly that.
> I honestly can't remember if there was a dependency that "required" the fix to
> be buried in the middle of that series.  I suspect not; I'm guessing I just
> didn't think it was worth backporting to stable kernels and so didn't prioritize
> hoisting the patch out of that mess.
>
> https://lkml.kernel.org/r/20210424004645.3950558-34-seanjc@google.com

I see. I hadn't checked the patch.
Thank you for your answer !

Regards,
Reiji
