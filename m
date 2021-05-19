Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068C63886BF
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 07:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345930AbhESFj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 01:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343567AbhESFhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 01:37:42 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A248CC061357
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:35:51 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id m124so8631000pgm.13
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FmPY4Xy03mz1vCnGspPbUoX0UiPu9Hq5FqWkhs/6VR8=;
        b=OkxocQs8jiFzLDYlxIfCyrXZIDcleQzwTkn4Epd01nRoNJyxXOXpNesHdJPGE766XP
         73r3Op2+isEhJWenPxGAQMcvwu29Go8ZtPc/N81AUCPeoSJEMij9XtCYKldLuUCLkdHI
         uRDcdEnV2FTvaZiHdyEQgoeA2LyNJt+SPUKb57fid7dlOy7YJckFx1qigSWd0LMoPT49
         e3MczY+WqzONw81KcUB0Sgk7zgO0KkH3zFxLvoUMYrke+bbeTdhi/h9HN4gFsK5hqFjV
         uXiIzi2IBbCp0BaeWC0II8g3+cLV3FqkH+ccXP2nXJOsYMuPVXvkylNr+KgTIsh9TQrs
         P6Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FmPY4Xy03mz1vCnGspPbUoX0UiPu9Hq5FqWkhs/6VR8=;
        b=ppqAUvQ9rAsbeAJ2ofEqr4RvvDl7WAwkL5PoXYzSuTbwCJp6xwyx3YNsPywapFnuF7
         IoXH+UaUPBQZkZ1shpJA9f1Ogi3zSuyu42yNdRRyRbelVizcZmhe9nWcMkqwBR9sXxpA
         KQpOU6tuwVr/R+tYWLvEkrmW+MOSdiH7XgLzyavVrewQ9ON3HisUgW0IshOoQOANBldM
         9CdEtAIxLthv5wtxegT0m18Mj4RBe7NfGXSH3VzG/3UYrISLVlZINOI9uJKHW16Y52aX
         Im131AyP32Jtpstw+TMJr+xaReKR1jNIxpvWiWbDOi6oDDsw4VVBRKOqmvnFmNVakYfN
         78ZA==
X-Gm-Message-State: AOAM532Z5xCqAjGz9h33z+DqzMcFPKhii9iorn/1OapeR4YD89M/SRcv
        gKyJ+19y4HxXRnmOriaGy5OHkrJooEHWsdoOlynHBQ==
X-Google-Smtp-Source: ABdhPJznqJrnHceWhb+AT65ATLb4YfGUnN87XFrP/ow7TIXe1KT4/2agJYx4IKqcZ+z2A6dWGC7xjv5mG/2mmdhnqjg=
X-Received: by 2002:a63:4f50:: with SMTP id p16mr9120007pgl.40.1621402551065;
 Tue, 18 May 2021 22:35:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-31-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-31-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 18 May 2021 22:35:35 -0700
Message-ID: <CAAeT=FwW0xuJ54a1ut8bKtd4R9NWajqmJYcxwOS7nKGtEQW9iw@mail.gmail.com>
Subject: Re: [PATCH 30/43] KVM: SVM: Drop redundant writes to vmcb->save.cr4
 at RESET/INIT
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

On Fri, Apr 23, 2021 at 5:54 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Drop direct writes to vmcb->save.cr4 during vCPU RESET/INIT, as the
> values being written are fully redundant with respect to
> svm_set_cr4(vcpu, 0) a few lines earlier.  Note, svm_set_cr4() also
> correctly forces X86_CR4_PAE when NPT is disabled.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
