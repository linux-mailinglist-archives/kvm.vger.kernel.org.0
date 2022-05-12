Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6775257ED
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 00:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359262AbiELWnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 18:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356984AbiELWnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 18:43:51 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A226128245A
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 15:43:50 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id s18-20020a056830149200b006063fef3e17so3748292otq.12
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 15:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1t970B0fJHlEuyIXUobZJRtdZ+neS/qyKKJxNpMTOxg=;
        b=jS0cP6aQeTYuJhFXvnLlQ+p5gdFQUNk4IZuAln/UMY8iT0rGeTreJ6hilp0syiuyVb
         pbwQol8xkHcGnHNptEVqx6GpVQ0saHx/X0aXVRDVXjPXmPd7Y9HDUo0bfv8evYBbiAup
         bVHNFJZjkz47YxvA54L95gGRuqm/J7udeWeTUmT2i+zGNYGR8awOzW8ViwG7GxWGa2pB
         SVpsKhe+h/wdxFPoQ+LDcYPM0jQLH+z1BmzFenKmKpzeomolN1xm7NgcZRXJWA/1Kutv
         X1ujJOcUIM9CIvDGQ8foE4gKd71NemiU90d51zP1vJ1PjtZlLwmtoYXmqWdPP+gSNbvH
         41wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1t970B0fJHlEuyIXUobZJRtdZ+neS/qyKKJxNpMTOxg=;
        b=LbceszPleg4C4m8lV5q0vo7V6u1quWTdHl2AyvDT7xY2Vf6mLded2lSyELX2uXEpkv
         YHG6sBOAvY7hvBMhnmgvtZB8DF8h0woEwzbmaINSc6crv28lQZ5NMMNLy3pqJym8qtse
         ykU2c3r+qcJTW6CCJ3aFVE2CafQZ2DIoz7cupkV21vSN0zr7jMeCk3x+PKOvcJCmxYp7
         GoIQGoNajbr/kh3C4XbuD/HhWcW8uyyXumk+wFvUkFSHD13m2yOSOD6r9PjHktmIZLrj
         lUS/SeXEchMFWzv8vTMUMyZvneRcL/CZaHRWUQ/xwHlZVHtltqUFfdnETYJSN33lJkBo
         FMYw==
X-Gm-Message-State: AOAM530TMWEXuCXhAjNxHjFfNA8O1MzeNPR6dsYm7U/hNFavFKYZfgp3
        J3sm8J4ulaiPTGd7K697XtkLEHL8u7jS3Enc8J2Oeg==
X-Google-Smtp-Source: ABdhPJx7ZsFAXwdLg9qDgIdSwjaW2ZGxSuROUTaCnIssPEdTzTozEAQCGpFfehKDAZJpy9Jb+A01B3nYcORcUVnCKUE=
X-Received: by 2002:a05:6830:280e:b0:606:ae45:6110 with SMTP id
 w14-20020a056830280e00b00606ae456110mr851166otu.14.1652395429826; Thu, 12 May
 2022 15:43:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220512222716.4112548-1-seanjc@google.com> <20220512222716.4112548-2-seanjc@google.com>
In-Reply-To: <20220512222716.4112548-2-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 May 2022 15:43:38 -0700
Message-ID: <CALMp9eSzx6SEa+rrBR2DpizuwqUzYvU7GNQrW=AOToeTp9mC8Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: x86: Signal #GP, not -EPERM, on bad WRMSR(MCi_CTL/STATUS)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jue Wang <juew@google.com>
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

On Thu, May 12, 2022 at 3:27 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Return '1', not '-1', when handling an illegal WRMSR to a MCi_CTL or
> MCi_STATUS MSR.  The behavior of "all zeros' or "all ones" for CTL MSRs
> is architectural, as is the "only zeros" behavior for STATUS MSRs.  I.e.
> the intent is to inject a #GP, not exit to userspace due to an unhandled
> emulation case.  Returning '-1' gets interpreted as -EPERM up the stack
> and effecitvely kills the guest.
>
> Fixes: 890ca9aefa78 ("KVM: Add MCE support")
> Fixes: 9ffd986c6e4e ("KVM: X86: #GP when guest attempts to write MCi_STATUS register w/o 0")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
Reviewed-by: Jim Mattson <jmattson@google.com>
