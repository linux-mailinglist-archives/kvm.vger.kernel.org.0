Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E91BD1AED
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 23:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732069AbfJIV32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 17:29:28 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45886 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732038AbfJIV31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 17:29:27 -0400
Received: by mail-io1-f66.google.com with SMTP id c25so8678216iot.12
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 14:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=53RDSTgRTc4OIaltPTdnTdVl82bbEDBXdYsk9AgolP0=;
        b=PtttGKZ4CYT4Zoi/nq6emZ9TtWyk5GVdkhBrRLPlI9OVwkZLg4h5bEi4rT/oXAjJSn
         g8HDZuNJ2+hZr35v0F8Qa2+ADjeIaks0ChZYpoNnQ4PrkJ5Q5v4SijQEx6kOTAbcpanL
         Eq9wYy4gcJczW80QtaoG5gxb6JxJJwGE+FYeSCtYkab+CqcdlrgoZ7IeTpXqEXh4ty5K
         MmlbSe9JrteqfSrMCSWAWd8Wh+Yc5xWsfojMZLmZDzUnyeQiSLokBKw4adwxensx3tlx
         5pbyXLureK6Fm7dWQaMTSfj/yo8ACqBsuN7aBOHaK5uVZ7izn/mrlA9An6+YK8t9+xF5
         RvmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=53RDSTgRTc4OIaltPTdnTdVl82bbEDBXdYsk9AgolP0=;
        b=QNtC8K4+H+kXgEj3tgUjl+iHvVyu3ZMwb5GkruwfHYWz2ULqOntFIKZN5d815IdyQP
         rYgfeY/RzEScRWuirtvHDYHZmFrKKNI1EM8pWsW7VvDl/g1crxOFWShbpRKdKHbWMu58
         49RmBio+iBKXV1Fooqk1W7YpT2xIXHg3V6QFDPrKGcd2bn7gzCkCEHSDNX76ctYJ3V2X
         LDCjgxTAKBgS0SFwy1ENmDEHtRBHEAoD+knzoje3aqKjSNsMZckoP6GlzCkCL/dwPTcI
         PrkevNjc3pzk4LhtzUV+IkyEvPe2+jytIa3g4ahTmUmIgEQ6jZnXtli/R/sTj95gRM2P
         YiHg==
X-Gm-Message-State: APjAAAWl2LLzbtBZJIGBeCCGpfB/nF1e1oTq66obDMJTXENTUAtMlNQw
        Lcp3Tp6wAer2rR7jgHiaLVdX14b9Nu25W8K5nM1bWg==
X-Google-Smtp-Source: APXvYqyXc5EEY4YQVj5Xm0skYSBjSmyAQTXp4JSHqnNLHi2cb+5b2sXfKa07KGIB2GkuIVn8XbPw+8iW1n4qKYGFtXQ=
X-Received: by 2002:a6b:d210:: with SMTP id q16mr6374946iob.108.1570656566545;
 Wed, 09 Oct 2019 14:29:26 -0700 (PDT)
MIME-Version: 1.0
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-3-aaronlewis@google.com> <56cf7ca1-d488-fc6e-1c20-b477dd855d84@redhat.com>
In-Reply-To: <56cf7ca1-d488-fc6e-1c20-b477dd855d84@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 9 Oct 2019 14:29:15 -0700
Message-ID: <CALMp9eRNdLdb7zR=wwx2tTc8n-ewCKuhrw9pxXGVQVUBjNpRow@mail.gmail.com>
Subject: Re: [Patch 3/6] kvm: svm: Add support for XSAVES on AMD
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm list <kvm@vger.kernel.org>,
        Luwei Kang <luwei.kang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 9, 2019 at 12:02 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/10/19 02:41, Aaron Lewis wrote:
> > -             /*
> > -              * The only supported bit as of Skylake is bit 8, but
> > -              * it is not supported on KVM.
> > -              */
> > -             if (data != 0)
> > -                     return 1;
>
> This comment is actually not true anymore; Intel supports PT (bit 8) on
> Cascade Lake, so it could be changed to something like
>
>         /*
>          * We do support PT (bit 8) if kvm_x86_ops->pt_supported(), but
>          * guests will have to configure it using WRMSR rather than
>          * XSAVES.
>          */
>
> Paolo

Isn't it necessary for the host to set IA32_XSS to a superset of the
guest IA32_XSS for proper host-level context-switching?

arch/x86/kernel/fpu/xstate.c has this comment:

 * Note that we do not currently set any bits on IA32_XSS so
 * 'XCR0 | IA32_XSS == XCR0' for now.
