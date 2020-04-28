Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBF21BB306
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 02:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgD1ArQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 20:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726263AbgD1ArQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 20:47:16 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DA7C03C1A8;
        Mon, 27 Apr 2020 17:47:16 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id 190so4297016ooa.12;
        Mon, 27 Apr 2020 17:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mg3ylSUl5nTSYGxTWgCy2J6jsay82JWyxDHWJ67sXd0=;
        b=BHJTeAgxrQcdxgbSnbBQ2r3yUouEpq5tFpfBfLiRMbGMAbOJzp1gwLavi3skk3+Xtb
         dxrmQdkZHP8gf7Ytiwcy3oNE9Wlg0kzA/CWUZbxRKKcZP+DREC6/sPGzsZvXAmoWKkk7
         w0CowYAgQeloZl2ELKOxGPjT+xqSZmtw2c8nPDlZ6b72NmCBuV7ouIbpo2uojIEqk2iU
         9EL5QuLqh5SfOT/24fsJ6IQaq9RSGRBuCwHUQDTdwgd1p/8MopMrdg9ZH6VMQvO29oop
         sP6JpPREldsbh6DWITEbl5XIwHqlxvCMwqIqf+h8gDUDuaOy1gqv5XgEbZ9e/77o7Kk/
         2dbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mg3ylSUl5nTSYGxTWgCy2J6jsay82JWyxDHWJ67sXd0=;
        b=mnJlIOOzlZHyVLMSL1Gx0EYalIQka+d6OJBNks/7vuM3+JmerntnwTZHdcwGdkpQsA
         JMWBwSJxqKRjaPBuzI45C8DhvR+d5qf5qYHgHOT+vmXwmg8sZICff/ReG1SQm90Spz+H
         M8OTz6nFRo9I0E1Gq8Qq7iOvOTo2vegXNrd8R6vyCFO7+oXN+FkUwiLCtzmDWE+qTy80
         GuaHnN1en+vzj7yVUaIFb2oMtUc8CkjCOq61U25t2bL+RWDW8irwgRyFlQ5xIryRFJlJ
         Y+NK/D5ZdmeT7HntA6AR4dd9bLpu25OdUllSAFsLFdLPDekseCGgvdVdznMFglPetcCE
         gQsw==
X-Gm-Message-State: AGi0PuZDp0+kmw3xjvZ8/WTgrASJrjWSrayZk9vF40rqFg6WPOYM//D4
        mtZk8vQvFVkHjjv26ZI3miBK3iFyp3CCMs1tkbk=
X-Google-Smtp-Source: APiQypIfTPGQQQfOB5A+EopR4kh38+zyXjtO9KEGC+3ldyqv7OPbmaTqNkuTiK37dBY9a1ss/9o7LJcM3QQ8lLvQ4hU=
X-Received: by 2002:a4a:d355:: with SMTP id d21mr9857599oos.66.1588034835594;
 Mon, 27 Apr 2020 17:47:15 -0700 (PDT)
MIME-Version: 1.0
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
 <1587709364-19090-2-git-send-email-wanpengli@tencent.com> <20200427182631.GM14870@linux.intel.com>
In-Reply-To: <20200427182631.GM14870@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 28 Apr 2020 08:47:05 +0800
Message-ID: <CANRm+CyNOnCDEwAK04Yr_Yom3ebfKH61_3-fXaCs-LbcTiEd7w@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] KVM: VMX: Introduce generic fastpath handler
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Apr 2020 at 02:26, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Apr 24, 2020 at 02:22:40PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Introduce generic fastpath handler to handle MSR fastpath, VMX-preemption
> > timer fastpath etc. In addition, we can't observe benefit from single
> > target IPI fastpath when APICv is disabled, let's just enable IPI and
> > Timer fastpath when APICv is enabled for now.
>
> There are three different changes being squished into a single patch:
>
>   - Refactor code to add helper
>   - Change !APICv behavior for WRMSR fastpath
>   - Introduce EXIT_FASTPATH_CONT_RUN
>
> I don't think you necessarily need to break this into three separate
> patches, but's the !APICv change needs to be a standalone patch, especially
> given the shortlog.  E.g. the refactoring could be introduced along with
> the second fastpath case, and CONT_RUN could be introduced with its first
> usage.

Agreed, will split to two separate patches.

    Wanpeng
