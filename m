Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58AA5692F8
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 22:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiGFUDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 16:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbiGFUDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 16:03:05 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54857186CA
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 13:03:04 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id t128-20020a4a5486000000b004287b14f5c6so1930879ooa.1
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 13:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XaV9aTxKTcNCCf7JPFm5rYChNI6ntIlkrDkEkxjaSvo=;
        b=tgNHG++ZYabULMRKKhbAcfsFACsEw/FU4PxMUoQJsxN5xKPN+fZrnYQtSrdSMn3tsp
         1EACUZ8Frp2H0mr0pW3FJU+toFkJo2iOoYR8+rBnrwSVTzvaS/UZeByVOMijUkRNVNEb
         fPOHJzMHP678LQVlyu6vsSRucopKnFE9VOENDdGOKeR3wHx5dW0OAMnRlYYKkpMb11Nu
         p73jbLwuu5RETfd8TSJzxAIguevZwl34sdsJ7TKL17aRLcbUFlgUQ2TMtlKb/k7Stb38
         BB+NVu5VHO5tWaA6TP4KuHvwZyFga0xQwuJ/BvMg9VXSQusqgF91XlP6Y/dD3jN6TqXj
         Sltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XaV9aTxKTcNCCf7JPFm5rYChNI6ntIlkrDkEkxjaSvo=;
        b=Wj8GYFFxnxvzc1Dimt4wtZSp+S4L+QXKVSLaYPX10DGiUF/YrJHGPEK2BXDaSexgTa
         MHxekdR9Mr2ztS0S3Q8F+AfsIiRxxcsz/6dy7c1Wf/MnxdW+U6bR/XpXgYgs+1gwvqzF
         zFB1mTWf1XSglkQu8TCXOT4mXzHEO4NbIl4P5JlTQpKveIK6h5HkmNnDZJZYaj8BnrG0
         Lxk+hFkRUIjj4L0/nF54KXJ6sewLogncBDrTbhFk3QHcfggPFCvyI1o2YwTJ0mY8aOpm
         1aJG8CqtDT3q1FYNd72WCjAmRQlNCcjickcXUKUTKYgdtZh34podPMMTkAXfJ8lL0K1C
         EPag==
X-Gm-Message-State: AJIora8caE5EyIu4wr6ujChRYHk2VDr2q6hDyTig0Se7/zMo2dVcjx4+
        6J2qqMqandNAVYJGJ/750hqMNOYVz+hOQXnJjDnKfA==
X-Google-Smtp-Source: AGRyM1tGb1I99nxCf4dHvmWsaNlJ40c74selwVxvHl4nH6OmCS+Uri0zZ0HtDhpsb1Q0MW8o+2L1/1BcINzLWTT8iVQ=
X-Received: by 2002:a4a:b306:0:b0:425:8afc:a3d8 with SMTP id
 m6-20020a4ab306000000b004258afca3d8mr17334929ooo.47.1657137783492; Wed, 06
 Jul 2022 13:03:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com> <20220614204730.3359543-3-seanjc@google.com>
In-Reply-To: <20220614204730.3359543-3-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 6 Jul 2022 13:02:52 -0700
Message-ID: <CALMp9eRm_n4s-ryw5-JiD8-5S+r+F15pSFsQSqava6gHrYjJBg@mail.gmail.com>
Subject: Re: [PATCH v2 02/21] KVM: VMX: Drop bits 31:16 when shoving exception
 error code into VMCS
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Jun 14, 2022 at 1:47 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Deliberately truncate the exception error code when shoving it into the
> VMCS (VM-Entry field for vmcs01 and vmcs02, VM-Exit field for vmcs12).
> Intel CPUs are incapable of handling 32-bit error codes and will never

Never say "never." :-)

> generate an error code with bits 31:16, but userspace can provide an
> arbitrary error code via KVM_SET_VCPU_EVENTS.  Failure to drop the bits
> on exception injection results in failed VM-Entry, as VMX disallows
> setting bits 31:16.  Setting the bits on VM-Exit would at best confuse
> L1, and at worse induce a nested VM-Entry failure, e.g. if L1 decided to
> reinject the exception back into L2.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
