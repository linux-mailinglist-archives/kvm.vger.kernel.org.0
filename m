Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428D438869F
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 07:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244818AbhESFhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 01:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240282AbhESFft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 01:35:49 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACB8C061343
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:34:27 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso2926609pjx.1
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BvCMRttPf/TJqIxdmSUmQm/huvf1KSvWFJ4QU8dhZnk=;
        b=CV3ss4X4zAfCIAxywB9c5q8IlVUT1MajJkdkgC6I1ntnX9+2t276blstc5JZXkrArs
         yG6PXbxxCaQ0iHrRO2CTgoomX4v1YH1TnxgirKjmSoB7LwA38t8GXd0yxCpGO+jhizJY
         PCF7+9P80QUYBMoNxT667Bq5uW5JSS98qs6K+3tU79MJ7ztOWwNCN1aL3lBTvIxK8BRi
         dFSxrAvLrdEYdHAsJTz4u1zb1PKZXrbXOPwhtXvEdHbVYsqHgiMf1tfFpDKsdjwxFi9U
         U0rHSGwE7UjiFSnHUbE2LatX+hxDXvouahNkVFQCUdb8bE6cOGB45YagFvOLcXi2IFbm
         oULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BvCMRttPf/TJqIxdmSUmQm/huvf1KSvWFJ4QU8dhZnk=;
        b=rbPAhwjlLmS0myyAs6apRsKuCku1/TcfhOgEXJK7ik6UDB5Sl9V2Xkt0wrRcEAegdO
         BF48FWQtc+f5Xd4jm1bI+qOfPJM5O+NjKfjyuG+RojK6QBD1Oo1/GRctTmwYOpU/p2ue
         fsW/LK4mM0WKtNxj9V2Tk5nx5m340Ui6rdXdN5q4h5Wfig034fgib7MprMHPRlbdgXrx
         QERXW3OfY8wd0myt7lUPDgvuASdD6BWEaO01dFkKoPD+DGMJMPxu7cugaVph4ONjjwix
         ddMf3Ix3Yu8A4H8zey2gRgtSBVDR5ibiVfDJtd9LcGMCc+bf2Nr6Gwv27VuYtzJG4KGw
         59WA==
X-Gm-Message-State: AOAM530CPTPrP1RV2l1BDo8iKqGPvcXvXHr8nS0nc+hqzBzTUJVviJQZ
        L7btEFJ+x6N0ZLrwS6RrTgg1fWf9jOXl6lFz3XnQ7g==
X-Google-Smtp-Source: ABdhPJyo4fL8c9W5UWz7sAEOga5ZdnbLPesZtp5YMsbclajiI+GYH9FAyRMTx+a8zYcjrPDC8/Fb/X6r2ucNAVseJIg=
X-Received: by 2002:a17:90a:6f06:: with SMTP id d6mr9677207pjk.216.1621402466801;
 Tue, 18 May 2021 22:34:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-21-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-21-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 18 May 2021 22:34:11 -0700
Message-ID: <CAAeT=FzHOCDH3-vZWOx798x6pGekCgjD8w1m8xPbrPh-ddR+vA@mail.gmail.com>
Subject: Re: [PATCH 20/43] KVM: SVM: Don't bother writing vmcb->save.rip at
 vCPU RESET/INIT
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

On Fri, Apr 23, 2021 at 5:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Remove unnecessary initialization of vmcb->save.rip during vCPU RESET/INIT,
> as svm_vcpu_run() unconditionally propagates VCPU_REGS_RIP to save.rip.
>
> No true functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
