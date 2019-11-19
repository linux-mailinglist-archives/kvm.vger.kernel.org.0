Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16791102D2C
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 21:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKSUC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 15:02:57 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35927 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfKSUC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 15:02:57 -0500
Received: by mail-io1-f66.google.com with SMTP id s3so24729244ioe.3
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 12:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2MFMy3LYEEEj2WKJnpUWE+LjcS6ExOPNWRw+rJNdpsw=;
        b=JYv+QpU9RCzMu4YGwNE4IB0XYB/RP0EfJKAEMlntSqLQq0E82KlEQZrkDlKAwaPWxO
         Mz3OAm3f9ta1eO7exD485mQX3lGz5rHLeAT8cN+BTsjYU5wya780Zo7pqtfw57oRCcHl
         F0LaIouXgLin+x60Mlr22jmfr/arSOJQTkH3ou2RSqPdu3pI8ahGiJol1Kwxy2n4Q8TJ
         2bhyhfsxi/F1u/6O08noh3aY8u4m0tUMe6LZEv39C/0DZjrp7xCtZjN45LzNozF2Wk57
         yT2Xx5pIwyoPvTSjNHHHnZEdoelW4/R3Amc1OH6u38evpSpQg7JiLNwbr2HLckMYr1YE
         +4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2MFMy3LYEEEj2WKJnpUWE+LjcS6ExOPNWRw+rJNdpsw=;
        b=izg2ULAYLEGx3lkPuPXsac6AGhqXAUPRlgqTE1PPxATKFy19ms/VM06v7MrScqxGMb
         6IBF06vxkNB3uSnxpT4eKYFxNGIRk+/7Q2KSG6ZL2UCrZ6OzlWsJVzDagXUf8aGjo2be
         h+t449FpQsTEizdvoTUjIXmSJWjbPPfNP4JQpI6jnhYLU6s8vQlcN1THS+qkG1WlYryl
         0hghYOpBrpOdbCevI3jBFHWAlUO90zjK2cQ4eACof7Hmsx97lscz8ieoYOcXDxqpSh9y
         0SZIXpQBUUhhbAPWLGvfF1StYo2H45F36Ko69oMgXkTrjLCbrausBdjGnHQ6vXkSH1VJ
         ECBg==
X-Gm-Message-State: APjAAAWfv0MNHJSmBSQ9r3wRslSDOVNbwabkGSgMrggODJ/r76myPixb
        H+m1BJIxez1arX3PLw+2C80sSm+3DfqYz/CygfCE6Q==
X-Google-Smtp-Source: APXvYqxyqKJGCaiQS2Qc1Xu3XQTsFmFp5Qs3VRSx5jry5cnEcT5RLvshAfvWelgmhFGgWO/EUGEbOJzXdX0WJfIkJbA=
X-Received: by 2002:a6b:e016:: with SMTP id z22mr12580177iog.296.1574193776044;
 Tue, 19 Nov 2019 12:02:56 -0800 (PST)
MIME-Version: 1.0
References: <1574101067-5638-1-git-send-email-pbonzini@redhat.com> <1574101067-5638-4-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1574101067-5638-4-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 19 Nov 2019 12:02:44 -0800
Message-ID: <CALMp9eQb5i99ML_gkbgebXP7CNmvmu4hOdmzfrti-5cpJwknVw@mail.gmail.com>
Subject: Re: [PATCH 3/5] KVM: x86: implement MSR_IA32_TSX_CTRL effect on CPUID
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 18, 2019 at 10:17 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Because KVM always emulates CPUID, the CPUID clear bit
> (bit 1) of MSR_IA32_TSX_CTRL must be emulated "manually"
> by the hypervisor when performing said emulation.
>
> Right now neither kvm-intel.ko nor kvm-amd.ko implement
> MSR_IA32_TSX_CTRL but this will change in the next patch.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
