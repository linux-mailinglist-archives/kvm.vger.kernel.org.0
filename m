Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFA1253948
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 22:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgHZUpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 16:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgHZUpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 16:45:13 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E874C061574
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 13:45:13 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id e6so2741201oii.4
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 13:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QnLfeoLcCvYGQhSXCHvu6ntO3iZypCG03j0v0V/lE60=;
        b=oEpPptmh8R/ckvOynlZJ0jBvRyvSgLg+QaTk85AvfB5WWtFS64+ArAY6dtSzIgW24p
         UzviT/lXocVLE2aWZpLhJA+/l9NktOLBwDMVhswDM/teObIMU1J+8LDfA4qnVFaoBFrC
         b/ucW8ynwOUH2jpcdHHAKtea59hSC+gyN2xU/o0yaIY+s+7jqQaNFGqo3rOR1Omq3mQp
         /g31ng79Q59TbpLRpyYVd/s/Gwj6PiQuxNyXkK6WlSw+oWKm7VHGRU5VUkWSO5vGQO0c
         WWjwA7GB3h0CfFeEjJfxmJJsxgD9PnFMkojRobSrFawZwkOYgCpR094C3Tu4v/aBfWBM
         LwOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QnLfeoLcCvYGQhSXCHvu6ntO3iZypCG03j0v0V/lE60=;
        b=EPZ9KZEbU3bN/6876imvWRoPg9QtWc1x+LtemD4xsEQTzZHd4ig5jd20RQZTyTFI6E
         OymXm8hHEjwobkYcn84GoXQVTR7qtZX7r/Hb0Z+1T8txTIBrx3vGE4TWMsUbSvu3OFke
         BOHw97LXicTfxuUjAx1dAYDFXthX2qjAw0SYNBq1x4yKWM1yxHy8UEMuv14EvIbQlMb8
         kPS8cMeh1ON1g9gYkp1zNHF9QYy1sePswOhBL15vYaqa16f53SQfc6W4TfMXZHTXhlvE
         +9T1gddo/ZvhxJ2EF6x4zzf9/A7neA0vi/CRYT2rKHvXe7ZQ90VHKHzBwkTR15JlKO/l
         Znvg==
X-Gm-Message-State: AOAM530bXIDTGKXwl8Wp9oSFZjGAogLktqBnESiJoptgvef8XN2hCVia
        BA1Igd1Dxqy+Bg6DhSPW0IReHM7iwky8cVieYorUaQ==
X-Google-Smtp-Source: ABdhPJztiKIs+AKmRQMjj8AupE0RfyXrDjWJ/I5FIYrFSEg+06xO6+xJgEtk14F9HUsJ3uBQwaGnAQSaytfPXKIFy8I=
X-Received: by 2002:aca:b942:: with SMTP id j63mr4826397oif.28.1598474712710;
 Wed, 26 Aug 2020 13:45:12 -0700 (PDT)
MIME-Version: 1.0
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu> <159846924650.18873.2599714820148493539.stgit@bmoger-ubuntu>
In-Reply-To: <159846924650.18873.2599714820148493539.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 26 Aug 2020 13:45:01 -0700
Message-ID: <CALMp9eTo_HMPcobJos-KMKBCjOuT=P+j9=WSh7Cf3JrQb3xftQ@mail.gmail.com>
Subject: Re: [PATCH v5 03/12] KVM: SVM: Change intercept_dr to generic intercepts
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 26, 2020 at 12:14 PM Babu Moger <babu.moger@amd.com> wrote:
>
> Modify intercept_dr to generic intercepts in vmcb_control_area. Use
> the generic vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept
> to set/clear/test the intercept_dr bits.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
