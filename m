Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602C22DD7EC
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 19:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731395AbgLQSNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 13:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731350AbgLQSNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 13:13:42 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D77BC061794
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 10:13:02 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id b64so23243081qkc.12
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 10:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0qfeWQiP0AW2162hkE5Wl6WLCWpu2XRzvthPkHqek88=;
        b=GLXWdWWLfjeWOBA35LBSPYYlvw6iE/CErBYDpE8AWw8S0zF4hLp4ltzUpQnYb0nxec
         H6q6qd2EMi+Ohl1/wpJ7YYDun+cpbN7Vmp3q6zQxcuKZKqGjQBmacwqcXJokCVTBP8wL
         jExxwOWt3vQ4YC5Ur+C81u6trEeF4QgHZ0Ads/oyT/ZIEZsxiUQuAW2CzmnugtkYhUhf
         z94o41BOpbGaoOxDa/czLyFWHoorRnDbXq87JRGJDlap/EqDg5IQXX7GXGkFsZ2fFOue
         Zs2pbP2cnC7c+se3TeP5UKssN3fGQmraUoSPluQeDMfiDkGnjyAMqnTIWXDojEbwfAW0
         Nvxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0qfeWQiP0AW2162hkE5Wl6WLCWpu2XRzvthPkHqek88=;
        b=Z0RlSnvUS/BVHs2FF+we4o0XFU5bUfBOroExAwTOwTvLoH+7nSISOSW4YnnC2/6AKD
         xyBf+1Pe6FooXqfTYuU8dGGIV3Bo+D3e5v3RJF26nANiIT7Mc4ZymJKUzuhkvqdtExHm
         /RY/x2NCU0cHBYPCTQ8KrPgnn6mxA1pcBfQFtCbFdWpLuA1PJ8OAxJ3XP0PS6doPJScS
         yV2Wb2Piee/mJDMNQXxBxg9I/OpnEmWG9nhGxdPxaCx1SnRth30NKujymzTdALBlegyI
         jxTJZYz4rqlgoR/RsVmPN1In07HD068i+e1V512r/rqqKsFRs06tk+xCQnBIFbWSqakc
         YK7g==
X-Gm-Message-State: AOAM5313Y9gkxFkNMIRZq2iSNBBnNXy2OigSD7DwLmrxGxaz/VOoveul
        5FGLaLZ4cULehdJr97ZYFubvQPtNyA4xRdSpWz4=
X-Google-Smtp-Source: ABdhPJyi70hbuXy5bT3hRyhDPZvFsiEina2csvN7+05XvPssWJTXvPJ7SyBuSrqIRmdzxQy72/zeL1+fIGzWYAYORvo=
X-Received: by 2002:a05:620a:69c:: with SMTP id f28mr523280qkh.127.1608228781182;
 Thu, 17 Dec 2020 10:13:01 -0800 (PST)
MIME-Version: 1.0
References: <20201029134145.107560-1-ubizjak@gmail.com> <CAFULd4av_xehfPBBL76dH+On4ezLa6rqU6YkqBuLhPcvZTr5pQ@mail.gmail.com>
 <X9udlkYvuaMme5pj@google.com>
In-Reply-To: <X9udlkYvuaMme5pj@google.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Thu, 17 Dec 2020 19:12:50 +0100
Message-ID: <CAFULd4YXPzOqL3Dc-OzoQ_quPZr--Q1t7hKVLsHPXKxFw9byPw@mail.gmail.com>
Subject: Re: [PATCH] KVM/nVMX: Use __vmx_vcpu_run in nested_vmx_check_vmentry_hw
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 17, 2020 at 7:04 PM Sean Christopherson <seanjc@google.com> wrote:
>
> For future patches, please Cc LKML (in additional to KVM) so that the automatic
> archiving and patchwork stuff kicks in.  Thanks!
>
> On Wed, Dec 16, 2020, Uros Bizjak wrote:
> > Ping.  This patch didn't receive any feedback.
> >
> > On Thu, Oct 29, 2020 at 2:41 PM Uros Bizjak <ubizjak@gmail.com> wrote:
> > >
> > > Replace inline assembly in nested_vmx_check_vmentry_hw
> > > with a call to __vmx_vcpu_run.  The function is not
> > > performance critical, so (double) GPR save/restore
> > > in __vmx_vcpu_run can be tolerated, as far as performance
> > > effects are concerned.
> > >
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > > ---
>
> vmx_vmenter() in vmx/vmenter.S can and should now use SYM_FUNC_START_LOCAL
> instead of SYM_FUNC_LOCAL.  Other than that nit:
>
> Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>

Thanks!

I'll prepare a v2 (and added LKML, as you suggested).

Uros.
