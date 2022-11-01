Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BAB6151CB
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 19:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiKASuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 14:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiKASub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 14:50:31 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49C25FCF
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 11:50:30 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id l127so490973oia.8
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 11:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/lzaJ9vFpPB3/dlpN7poyD5G6lsqU1rGmJtxNXCxakA=;
        b=A0235Avuyam5ZytK5Jc38OKhNwnftC/OBDxEeGMYf++u8ZiUjc32Ui2e5kZ7X7GAjy
         E4CK0om2BbBj61i4vXTRG52nGy/dEjfVDPQXtF7tZtzJg6DWmXH8lePZkz8M9mNQbJSW
         AlHDwfXoEZdthr7+Ji7DPaGddYPHPnQ4y6kJTC6v5DmYQOVn+nnf9xtg0zHG2kJm8kGX
         Hi/+KRZ8QX6sxCams6T2dG3RPQjTFHBxtx2i7vwH64fxeIs04SZwmz1J8/G42hNZ3G4X
         3EFwHG5wBNkT0MNnOf9/P5Q5wpSpiF4mBbTCy0VHf7OL8egAsdoGuWwOv04hW7hX7Y6o
         /PFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/lzaJ9vFpPB3/dlpN7poyD5G6lsqU1rGmJtxNXCxakA=;
        b=cmZjWJBgArbaDlwe57B/DXEpQTlb/TP2N0kwkmpURhyqto+g+fv+RpXfzwIPbghZb7
         8L09svUmPTW6+v2GBz+/pnZQ/iD2VOFVR312vJHeDpUJx0DggM1dP8lqaPs+r6rPw4tO
         rm1JfOS/wUiNNck3nGaE2kPJ7oVmVE6+NIrdWjrw9kq77GkSXP6q8o9xxQRcOJsa6ee8
         sOEpXj49f+2Bt7uFuE3QCiqhxNqFsjNcTAPSBpps8YOTezk/ScCitVYmxcXKTL9qLDNr
         PZwvsP+lGT2+VEt7t9WYDb/ZdYKEUZtnltm5vizKvOu/JEm6lj4uX++niRLEESZ3BUuX
         4Mtw==
X-Gm-Message-State: ACrzQf16K2+jkX+Y0Wd4eS4aJkNRKMa4c0dzXdng9bTQtpiDP1UcyUJ2
        96+VR4z1t4PqZG04bwz11hJsDi5kLOfpa1kfhbUXkDbN/9E=
X-Google-Smtp-Source: AMsMyM4LNN7ZiQykqsQnoz7X0t+E61RiQn3lI3Kl0k1xD343EwvZtwc3pue5yyB8TaZSyzlhTELkW+NWCULawI/hWkg=
X-Received: by 2002:aca:6007:0:b0:35a:1bda:d213 with SMTP id
 u7-20020aca6007000000b0035a1bdad213mr4659553oib.181.1667328629654; Tue, 01
 Nov 2022 11:50:29 -0700 (PDT)
MIME-Version: 1.0
References: <20221019213620.1953281-1-jmattson@google.com>
In-Reply-To: <20221019213620.1953281-1-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 1 Nov 2022 11:50:18 -0700
Message-ID: <CALMp9eScfLedYd3DiwEipjbnEbteDV-=gcD4TLfT6pvHN48pBQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: nVMX: Add IBPB between L2 and L1 to
To:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
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

On Wed, Oct 19, 2022 at 2:36 PM Jim Mattson <jmattson@google.com> wrote:
>
> Since L1 and L2 share branch prediction modes (guest {kernel,user}), the
> hardware will not protect indirect branches in L1 from steering by a
> malicious agent in L2. However, IBRS guarantees this protection. (For
> basic IBRS, a value of 1 must be written to IA32_SPEC_CTRL.IBRS after
> the transition  from L2 to L1.)
>
> Fix the regression introduced in commit 5c911beff20a ("KVM: nVMX: Skip
> IBPB when switching between vmcs01 and vmcs02") by issuing an IBPB when
> emulating a VM-exit from L2 to L1.
>
> This is CVE-2022-2196.
>
> v2: Reworded some comments [Sean].
>
> Jim Mattson (2):
>   KVM: VMX: Guest usage of IA32_SPEC_CTRL is likely
>   KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS
>
>  arch/x86/kvm/vmx/nested.c | 11 +++++++++++
>  arch/x86/kvm/vmx/vmx.c    | 10 ++++++----
>  2 files changed, 17 insertions(+), 4 deletions(-)
>
> --
> 2.38.0.413.g74048e4d9e-goog
>

Ping?
