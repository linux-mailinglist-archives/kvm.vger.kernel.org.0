Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408BE984B4
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 21:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbfHUTpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 15:45:42 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45977 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729957AbfHUTpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 15:45:42 -0400
Received: by mail-io1-f65.google.com with SMTP id t3so6971555ioj.12
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 12:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YpMEj+NWj00I7foN2WrqzBLVN+AGOJvo2s3dxJ45E5M=;
        b=tZOH3QR0fZUbdQ7kAWqBMyzJ2J3tx6QAJAHPkFTCCf0h58w7Dz7jtudO3qgo5ubKTd
         cR6Cilk2rkU0EVZL3KEy3pTR3RcwCh2HqolL29QYRG+tvsmuJK1kC5+B0M4+xFvb/Ojf
         JpiyoCEkA5QbA+AoFHAZZqtwJi4sptLMCzj9Eb38L2lMV7bxR3H+LaYXuCz3mOBBG2hM
         NOkMcwJHbajBdp5NX56FcZof+blQlpJ+Jt6amvRVr8YMUwUmB2FbvZDQulpQVDQuWaMS
         kL9B1UwBEeAF3Garanxfhoq87nBlqpevdagqPd4r2mY68SBMuM3UtztvhgVu49pBzx0E
         LofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YpMEj+NWj00I7foN2WrqzBLVN+AGOJvo2s3dxJ45E5M=;
        b=St43awf/exHUErNfJJ+LJltlKVDrHI3im1GGTEdH5Ekt/LDBffaVULn28ltvjh+XaD
         97jnStAvDOtT898t8eISRzXN0oDR86CMs3aUYCXx0aWDGnaV1e+5WKpvH2jovGKw1e9H
         W84LaWpK+Yf/N4/F5Tfh/yUrsoNcx6b5GNcTZRo/NqZiWsuZXw/fijfQ+BCxs/rhYtMx
         y34PLSm3ckA3dWHGVinNK8yF7Hcwt6kK2VFdr+bTezP8FeE6tky5oSniiRMTkfMyp0W6
         BsQxqYzOUVYZfzyQtbXULyyIG27iu+ExT0+H4wxwtTtnBu8Z6w3VH2uoAefZBcSuu3kH
         JveQ==
X-Gm-Message-State: APjAAAU/gurAL/rAsh8YOzQ5BmXfeox8Q1NVTW2LYFxBMc3jveIsmtGt
        82f7CVvDK0fmdOcl+1xkfeJDJpjNh2kgSwGkYG5QaOKp2q4=
X-Google-Smtp-Source: APXvYqxFfK6hxk1+ostWDfVFMf1N3zdsSZ97J/GlbNiJ9ZeNnr3BcrpU1baCdKWNQ7dpGMfOkIos5oOpIs7zZN38vSE=
X-Received: by 2002:a02:a405:: with SMTP id c5mr11796233jal.54.1566416740913;
 Wed, 21 Aug 2019 12:45:40 -0700 (PDT)
MIME-Version: 1.0
References: <1566376002-17121-1-git-send-email-pbonzini@redhat.com> <1566376002-17121-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1566376002-17121-2-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Aug 2019 12:45:29 -0700
Message-ID: <CALMp9eQoHLngzb5v9aqxpJ39OszXLjdm+sWbHdeOk2JaPofv5Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: x86: fix reporting of AMD speculation bug CPUID leaf
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, jmattson@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 1:27 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> The AMD_* bits have to be set from the vendor-independent
> feature and bug flags, because KVM_GET_SUPPORTED_CPUID does not care
> about the vendor and they should be set on Intel processors as well.
> On top of this, SSBD, STIBP and AMD_SSB_NO bit were not set, and
> VIRT_SSBD does not have to be added manually because it is a
> cpufeature that comes directly from the host's CPUID bit.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
