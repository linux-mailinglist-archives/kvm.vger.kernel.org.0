Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49893FCBF3
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 18:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240366AbhHaQ7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 12:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239484AbhHaQ7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 12:59:45 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01D7C061575
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 09:58:49 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t1so17391756pgv.3
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 09:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vSsyLkLytT485YxJhtDSyUreAWOp01WMhEhWSjhjWSQ=;
        b=WikKTHCGSrl0kxsZN24g3MXifcsxcZtAFFRO48tUni80/KqA8LTr8XSi4fNFo65Aao
         gKy+EtOibB7v+ZJIdF1Wa328jMqZNCbLv4cCb4i+z0ynk/8l9lpl3kw9gcX6h9rUpCjj
         2Gn61+sOAbk86lUBL8oNCEyo9YX9I6pjhVx/8D9upbekveGjCSNiqQeYDavYkHs2QP7s
         wlyUPeRRFo0wljtXm0cBxeWR5o6v2yarB+S16jqWC+wEM8K1XmychGW+iQAzv/V/+tPl
         VDEJrvb4YXLG/prOWTh2Nvy5C9cuStXPC/8rXvUWq+lS4GPlKFtXFx7jCCRXFpQyeRdN
         reKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vSsyLkLytT485YxJhtDSyUreAWOp01WMhEhWSjhjWSQ=;
        b=q1nSOInwt2ahYOCUyRY8z+Zw5hsq0prFZhuWhZgUJQp5lvpTGpxKqMb0toqZGNVn61
         PR1qUMcR3r+coJJVkz51WzOPk/DL15pXDbl8i5Vp8X8YZXvAL74g7L0bZxidJzYfRH2C
         YNTnLIiZUpoU3o30WX9jkloY1PrFPOXO/UQSGvkZvDJgH0XWF2/V+BYcn6zpTm3bEGGg
         ajE+lC2HRb7vUNFeh6uQbSF9zY16kZGn2l3YJ6Yyj2puhm3ndGx/C6X16zR1pvrsf0so
         j7yMe+5wbHCgKbY1G3nmEgwhW3QSXGoXZo9WwoXvc6Hl9xpDASc3vaJtY9qkECcO7uSA
         rg9Q==
X-Gm-Message-State: AOAM5320/i0LcNTCLSAD+eI3C8T+taGTskW4IMszmWzjR/VL/yHy0jSI
        /1oPgHNyEROovwyu82sMaZWrOw==
X-Google-Smtp-Source: ABdhPJyeDoViWQ6dpRqrKXaytMTw6VBaCzRO2A8PkQSx0XzGLRKz7bIpGFwqEUIOHoJCNaOtosUgIQ==
X-Received: by 2002:a05:6a00:706:b0:404:d92b:82a5 with SMTP id 6-20020a056a00070600b00404d92b82a5mr4761642pfl.79.1630429129108;
        Tue, 31 Aug 2021 09:58:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y25sm18351069pfm.80.2021.08.31.09.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 09:58:48 -0700 (PDT)
Date:   Tue, 31 Aug 2021 16:58:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v3 2/2] selftests: KVM: use dirty logging to check if
 page stats work correctly
Message-ID: <YS5fxJtX/nYb43ir@google.com>
References: <20210830044425.2686755-1-mizhang@google.com>
 <20210830044425.2686755-3-mizhang@google.com>
 <CANgfPd_46=V24r5Qu8cDuOCwVRSEF9RFHuD-1sPpKrBCjWOA2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_46=V24r5Qu8cDuOCwVRSEF9RFHuD-1sPpKrBCjWOA2w@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 30, 2021, Ben Gardon wrote:
> On Sun, Aug 29, 2021 at 9:44 PM Mingwei Zhang <mizhang@google.com> wrote:
> > diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> > index af1031fed97f..07eb6b5c125e 100644
> > --- a/tools/testing/selftests/kvm/lib/test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/test_util.c
> > @@ -15,6 +15,13 @@
> >  #include "linux/kernel.h"
> >
> >  #include "test_util.h"
> > +#include "processor.h"
> > +
> > +static const char * const pagestat_filepaths[] = {
> > +       "/sys/kernel/debug/kvm/pages_4k",
> > +       "/sys/kernel/debug/kvm/pages_2m",
> > +       "/sys/kernel/debug/kvm/pages_1g",
> > +};
> 
> I think these should only be defined for x86_64 too. Is this the right
> file for these definitions or is there an arch specific file they
> should go in?

The stats also need to be pulled from the selftest's VM, not from the overall KVM
stats, otherwise the test will fail if there are any other active VMs on the host,
e.g. I like to run to selftests and kvm-unit-tests in parallel.
