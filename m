Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C760A372F03
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhEDRii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbhEDRih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:38:37 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CB5C06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:37:41 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id l6so9560046oii.1
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uQJdUXEx8maMY/qSJE4caWuHD5W+mMvJWFUW8MPsCdU=;
        b=Z2XmxRIGEs+aA4d/74oGwD1FDn7Q/Ilim4Q3Irnx6sHCVz04n1GuGScOZxS9lR4fCj
         RtJM0jmmdBmsSzCLagcOsZoI8m1ZRmA9MwQDDml9y0Qex4//GXkmWj0so2jXOtt2a2Ab
         HvrVVvhWBloMqucQDbYcoW/CCULw4c8CnxT8XqvqIBXTOos8tWFxvEurwpPqEBJG/UuJ
         Wynls0Y4wQizGcvvBGQTBM+r/scTdza0iJxOclAIQtisUI3IV+8nk/0S+NIZO28bAb00
         Ae/bMhto+kK2yEyj3j57ymNqa2h2KAhNGwkRwMVfWCMDoYIKWgiSms5nvpNuCy/Ks9Dz
         TOiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uQJdUXEx8maMY/qSJE4caWuHD5W+mMvJWFUW8MPsCdU=;
        b=VP39KKhyloVqT8tcScPLyOfNJ/bAP4F1rpYhpz3aEo6xZdwz1Z1/MVff4FFbijZCA9
         2OBD1fmFiq6juc7X5ZFRsT6CnagtJPe591/Og7frIV5gTqTYJLM4PqsQOiPzWxxsqgGY
         qJ34k8XvfUuMEFpg4DU0n71OvOHoVeMwvkcy1+6bXJGT1mtPb9sP1r/IJPHOHSdI4JRj
         NIFZPY9j+Sg4Omsvv3ovDo36mDCRLfDNW8CEI42DIF4VdPzz/DAh7NqYUCQdX3ixv84v
         08bE8CJwh+gM9D2t3OUG5GGZo5n/M4AbBU1Q7nVUwaxgilUBQWFMcTnxVWqeblzaApu6
         yyAA==
X-Gm-Message-State: AOAM532/vWDwrT/16Vk+6XLnKZcA/2gTOEsJHWI5l7iP17m7P8UGjSGv
        uJgtUZXsWk5mhNNdgAbNmfxQQ3QhfWhD3ZyyzAZiKg==
X-Google-Smtp-Source: ABdhPJy62AFpAROaQIN9dPxNDLR0eJkP8Ot0H7OpqD9T1/6g9TuNu6fUPjm89rupzH+YCfd6pdjXwHMaiozxIwZzuTM=
X-Received: by 2002:a05:6808:b2f:: with SMTP id t15mr3814416oij.6.1620149860953;
 Tue, 04 May 2021 10:37:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com> <20210504171734.1434054-2-seanjc@google.com>
In-Reply-To: <20210504171734.1434054-2-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 4 May 2021 10:37:29 -0700
Message-ID: <CALMp9eToSSQ=8Dy4Vt5-GYEB4YB9c6-LTp8c60C97LOY9ufdjg@mail.gmail.com>
Subject: Re: [PATCH 01/15] KVM: VMX: Do not adverise RDPID if ENABLE_RDTSCP
 control is unsupported
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 4, 2021 at 10:17 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Clear KVM's RDPID capability if the ENABLE_RDTSCP secondary exec control is
> unsupported.  Despite being enumerated in a separate CPUID flag, RDPID is
> bundled under the same VMCS control as RDTSCP and will #UD in VMX non-root
> if ENABLE_RDTSCP is not enabled.
>
> Fixes: 41cd02c6f7f6 ("kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

But KVM will happily emulate RDPID if the instruction causes a #UD
VM-exit, won't it? See commit fb6d4d340e05 (KVM: x86: emulate RDPID).
