Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA8E345621
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 04:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhCWDQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 23:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhCWDQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 23:16:45 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773C9C061756
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 20:16:45 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id x187-20020a4a41c40000b02901b664cf3220so4603848ooa.10
        for <kvm@vger.kernel.org>; Mon, 22 Mar 2021 20:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KcHr5KhxTe2vIA5SGKoePAFtx0EJjffM/gwX16Axq9U=;
        b=trUflAVOrYzkJLJ7USUfjk7wQVnu8xRNa1VihcL4PE4shDAYTo6g3SEZO1aB6HhweQ
         Dwm11DtzXghFoS9wAUSe4OmSQnq5qlm6bAJcMQ4NwAg+vrxE1hTx7vv6jHbvFH7J1pNo
         WhtQAJjJFCcnNb0rcy3Yd8opHmDADxIFaDDIk6H7aTkZwZ/MoKQwtQfFegjpi34QaRZZ
         wpH1xLV1Wq/44eG8FSuxmU13RsV/tH2ZHCG4TfTyzUGuroXSboyuHQA7Iz4kOFR/GV7g
         DwfpGsRTcYrCcJlPC+uylVN0n+G7l5gpyFy+aAR9h+C9nNSxp/ZxcCuqRb10C5WCuYtv
         4BZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KcHr5KhxTe2vIA5SGKoePAFtx0EJjffM/gwX16Axq9U=;
        b=hwWTsLOLPPe9zJBEPD9+gbdncqsfM1RpS43v4vV0M3zLYhYlHs+15RXv2oTwnG+DH9
         kazTJ6AyeXiiB7FLLBdSCmlflSu/k6QtfqIfdbGs+KGKYoVutASht1xacK9SqBi0J9s/
         9tUQZvbS8buVkCdneFsajv/Tho9r2UsGbrukTuMtzqVcQM9RzoRqL/Zroa7O+4e5T7EZ
         up8ocsaorw3Na0NlXfzRxmBB/tIMv2RFN3Y0h+FC4gq8ZLbypQgfcRx0ZsiWhSyIWMTG
         6SjuDp33AueURFVT57fZSnVV/4t4J5SY6a5CCPZldZAv0t9OO9RsnFtXja+A1vSzhBNL
         k9Cw==
X-Gm-Message-State: AOAM532UvC2c5EEBiHQu/INSzQGbZw6GXCecOYivQ1w/n+hjeLtS7nLO
        jkjIlpF4aKP9WGKldswZeNyantWH4W/m5rEqCDJp9Q==
X-Google-Smtp-Source: ABdhPJze0SqjbbV2eflTYdACyTLKDcX+dUtq3fTM/RvTCrPzyPhAKgHsTYBcLaSLApUHRSVmn+O9y47iCUxJFvy/AXI=
X-Received: by 2002:a4a:ea11:: with SMTP id x17mr2015315ood.81.1616469404495;
 Mon, 22 Mar 2021 20:16:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210323023726.28343-1-lihaiwei.kernel@gmail.com>
In-Reply-To: <20210323023726.28343-1-lihaiwei.kernel@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 22 Mar 2021 20:16:33 -0700
Message-ID: <CALMp9eST+qAnXLpzPpORn6piVMNi3xY=P0KmP-cKixtCNAOH9Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Check the corresponding bits according to the
 intel sdm
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 7:37 PM <lihaiwei.kernel@gmail.com> wrote:
>
> From: Haiwei Li <lihaiwei@tencent.com>
>
> According to IA-32 SDM Vol.3D "A.1 BASIC VMX INFORMATION", two inspections
> are missing.
> * Bit 31 is always 0. Earlier versions of this manual specified that the
> VMCS revision identifier was a 32-bit field in bits 31:0 of this MSR. For
> all processors produced prior to this change, bit 31 of this MSR was read
> as 0.

For all *Intel* processors produced prior to this change, bit 31 of
this MSR may have been 0. However, a conforming hypervisor may have
selected a full 32-bit VMCS revision identifier with the high bit set
for nested VMX. Furthermore, there are other vendors, such as VIA,
which have implemented the VMX extensions, and they, too, may have
selected a full 32-bit VMCS revision identifier with the high bit set.
Intel should know better than to change the documentation after the
horse is out of the barn.

What, exactly, is the value you are adding with this check?
