Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8737388692
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 07:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhESFfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 01:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237940AbhESFev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 01:34:51 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64372C061347
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:33:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso2859889pjp.5
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ArOATr+a0hXgg0J/jDFFZIaPxMAnGoAVL6O4IK6IU5Q=;
        b=PA5YOTA74ZqK4ihTbqvYrO6pwXRBFTcGA+K8i1355p/H2iLpC5IVs6RWKWmEK9hNr4
         MMoc7u6cNDNhMU90PHJtcMwv0OXFRITfQt2V/tARKcNKdN+SVhTce09sc/HC6YWJEvzW
         IMsZC/cKydRDZ+G23T3Ht7TkYV7vB8h0OHjQuaUuEsg5jpbMtEJPo0phnwLg8C8m+5hu
         BFDWqPxcF8bysY5K5aCCPUkYnNHB9gbqr/l2YUruyQ/udBaBNJGuVORCP7m9UW14uFSB
         SNmD2kkEejOExEFCj8qCoHFVMbmRwxCmtZWqv4GMRA/dUZqFnTfuMRHvqe6YMqq12qbO
         Zwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ArOATr+a0hXgg0J/jDFFZIaPxMAnGoAVL6O4IK6IU5Q=;
        b=el6/Fi3M4b3OLCNiAl2+YuKDmPh88LCsm91jO64fII2O2EG5w+f7SBYkoRx74fVDiC
         pBIhUstwO9anwPjYJ3cLZQG1yu1tWVlUtcr3gGknUnzXwJ/95gMPg2CLHaHDtlf6/aI5
         CYbe1a8+ljyVPbj/fkf+Cy70C6OrQKkyzwVCQEKdQkZ2QkXwAD8+CNupTGGGzs4U+Ann
         aHlrc16YduZg3JJnpfE/JAG4uszZBH8Rfx7N9RyUv4lcYxH3pirlnLtOWESTYTUP2Z7l
         Zbx5WFcVJJUKjbRvDyNoK4uEok/LEdD2Et6OAOSYhZFSwzL9yi4eGZ+33BIPyQ7jXqv2
         uj0A==
X-Gm-Message-State: AOAM5302pFqjvcuXDB3DGU8o68w+JMcQFQ0f+u6XuPL5R8D557gngcmS
        yidLf9OCH73jh02Hfmf6cD6iWRpgZ6DeLl6eJVU6/g==
X-Google-Smtp-Source: ABdhPJwgB/PikSymdwEqi0NsFKS6ad6C5UPBpSBjvW7I4YRC2SriqOp2m3HIhoEvlTgLuxjqp+CO+8H/9EX5oh8nCjQ=
X-Received: by 2002:a17:90a:6f06:: with SMTP id d6mr9671757pjk.216.1621402389903;
 Tue, 18 May 2021 22:33:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-10-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-10-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 18 May 2021 22:32:54 -0700
Message-ID: <CAAeT=FzKr2s60gh8ejqLwk92WySwEv_Ooa1se3g0WDP=qu7yiA@mail.gmail.com>
Subject: Re: [PATCH 09/43] KVM: SVM: Drop a redundant init_vmcb() from svm_create_vcpu()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 5:48 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Drop an extra init_vmcb() from svm_create_vcpu(), svm_vcpu_reset() is
> guaranteed to call init_vmcb() and there are no consumers of the VMCB
> data between ->vcpu_create() and ->vcpu_reset().  Keep the call to
> svm_switch_vmcb() as sev_es_create_vcpu() touches the current VMCB, but
> hoist it up a few lines to associate the switch with the allocation of
> vmcb01.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
