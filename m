Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAAA513C0C
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 21:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351395AbiD1TQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 15:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiD1TQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 15:16:55 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94351BB080
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 12:13:39 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id s27so7964291ljd.2
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 12:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IpoRjAHqTnS4FmpnPiFyNV6WV8eg0o3grtiws+E6G5I=;
        b=Gnzvaueav3QHGTSn7IyGj9WlErm4/3cYsOlmJMi09SF5tZ6OBo/373LzTgnUWbgqXT
         A03fvitVFsIQw2doRuinCCqU52MtRKWXi3xzJ1pMVOS0pJHQcJQ1qIU4VRvmcxvVieUT
         faj9CVcRtYDLdXNh99b1VQBFaUkwquL1M/chrNy51+cpPCiCK1/2g7biBgi4VLNUBLJX
         p/1wjZC5ee2I8wSEssw1QytxzNS4B3V9ydKmCI22TWL2MNoVTucYJPt7grCJ51++pB9r
         LUnIFgYUBZwylhSv5El2OBTMkBlM2o4IRRIZA7a1hRBDzEcYMWFbdVseetwL6AsA9QH7
         rwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IpoRjAHqTnS4FmpnPiFyNV6WV8eg0o3grtiws+E6G5I=;
        b=exNLvXVYruxXrNUvBDlN90WRpakWPVTuMLvjwuQPR7iCcSLDUNXEesZ10Zm68+kp2d
         yd/+sDMGH7MaNVRaCTbVD5APK+J4ZLfPobYOo3doXppmf21i8VMmi1uUj+NhZq9/rfuW
         M96zvjKlR2QntmeJvkdbZVgxx1NzQDnAQmzizMCR8Du8VPTghijhq07/BYpSIIu5C0sN
         24QXatbQFXQPGmkyaUBzKXnMlr3RQ5rxthe+9JGZ67oXLNt+w0CTg7faw8QL+WqUoCj8
         IYxDSjxSk65ohXWF3o+jFK+SqIT+HHD6/GrFtG2uopTP/ikYuhSfj1ca1hsxg+QbyqCo
         JRtA==
X-Gm-Message-State: AOAM530s3q4chyZOoz4KSYZ3Jn3OYnrK3mQyufgzoIBMJcOyjTVdD41h
        XjwGWJMjVr5NtvX+KOqihgiUt+gj36C2+VfiThFIWQ==
X-Google-Smtp-Source: ABdhPJxBofabfcdSg6XepYgQ/fzBd7Kgdln9EwjGB+dwQXfcwYdd8V3ihEWM57Pp+OHEO327j0znLc/DfgZ1mZpliSg=
X-Received: by 2002:a2e:9041:0:b0:24a:ce83:dcb4 with SMTP id
 n1-20020a2e9041000000b0024ace83dcb4mr23085886ljg.291.1651173217688; Thu, 28
 Apr 2022 12:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220421165137.306101-1-posk@google.com> <b1b04160-1604-8281-4c82-09b1f84ba86c@redhat.com>
In-Reply-To: <b1b04160-1604-8281-4c82-09b1f84ba86c@redhat.com>
From:   Peter Oskolkov <posk@google.com>
Date:   Thu, 28 Apr 2022 12:13:26 -0700
Message-ID: <CAPNVh5eTzpK6QpJumegoN4_7r56ZHsi6hFCG-Mqt+R8ngrCitw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: add HC_VMM_CUSTOM hypercall
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Peter Oskolkov <posk@posk.io>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022 at 10:14 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 4/21/22 18:51, Peter Oskolkov wrote:
> > Allow kvm-based VMMs to request KVM to pass a custom vmcall
> > from the guest to the VMM in the host.
> >
> > Quite often, operating systems research projects and/or specialized
> > paravirtualized workloads would benefit from a extra-low-overhead,
> > extra-low-latency guest-host communication channel.
>
> You can use a memory page and an I/O port.  It should be as fast as a
> hypercall.  You can even change it to use ioeventfd if an asynchronous
> channel is enough, and then it's going to be less than 1 us latency.

So this function:

uint8_t hyperchannel_ping(uint8_t arg)
{
        uint8_t inb;
        uint16_t port = PORT;

        asm(
                "outb %[arg] , %[port]  \n\t"  // write arg
                "inb  %[port], %[inb]   \n\t"  // read  res
                : [inb] "=r"(inb)
                : [arg] "r"(arg), [port] "r"(port)
        );
        return inb;
}

takes about 5.5usec vs 2.5usec for a vmcall on the same
hardware/kernel/etc. I've also tried AF_VSOCK, and a roundtrip there
is 30-50usec.

The main problem of port I/O vs a vmcall is that with port I/O a
second VM exit is needed to return any result to the guest. Am I
missing something?

I'll try now using ioeventfd, but I suspect that building a
synchronous request/response channel on top of it will not match a
direct vmcall in terms of latency.

Are there any other alternatives I should look at?

Thanks,
Peter

>
> Paolo
>
> > With cloud-hypervisor modified to handle the new hypercall (simply
> > return the sum of the received arguments), the following function in
> > guest_userspace_  completes, on average, in 2.5 microseconds (walltime)
> > on a relatively modern Intel Xeon processor:
>
