Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF2132F2BB
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhCESfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhCESfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:35:21 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC82C0613D8
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:33:49 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id p21so1952439pgl.12
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gopE1fDc4vVgparSpgvp1lWA7bVSSuK93mUAKs4+V30=;
        b=YiaGCb5bE+tvCz5nKQBEiOL7qODtlLrbF8Z/tqD8Ik6DNRSrNFGBu7UNuMxkgeafDF
         v3MUspNuhmXZ3vPryyB1myvzRsZ7TO7bqtC0FRjd4VNi3+hq/xz6ABG/ofn/XZF4L19v
         JrnyNKO/A2kCk7rkzkgsBIryhOK5ZR0l+Lag7XjyNUqynw/XbE1eU6S3+b2/RrTUw1jq
         KtdFhq8AvxIrrYmKqG9ZoxShtwUPh1xkeogq36DKPowNNxDfsm9tPKyP+l5IY0YfUmJV
         KBReUWWtNszUxTueVpv4xlbYe69DoXxwQ3SiNI8LcwBspqTMoTbr6GzxctyugyNjM5Qa
         viRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gopE1fDc4vVgparSpgvp1lWA7bVSSuK93mUAKs4+V30=;
        b=GUIil+8tPlvfsn93DV7zBcQmqfgCk6nPES5hEtQ/RFvsD58w+X488Ivbmxfiu/hXi4
         F9hgQtjpnSfV2KYknnZxRDS8Mf07qGoO7OixNvFXLvTS1TVSVwJDCJaR6Dv1KohxRTpn
         u5cWNonlPyqZOUKeNrwyysvSdAwrwWX4A9ZmIRRN1o7Z/jCc5Jfy9tLcGBmQho9+SG22
         HIWOwq/OgEFzxVtIMewjVJdcFibJBNqTfDds02B7uedb7Z7AKBDhTy/TghmYp+v00xJP
         cIkv80oPWnMcW4PWNFZboqYkp96BXkt62ILZf8FLtJKQrRc9WBIiVlKwRbzUMjo+H6bf
         BvQg==
X-Gm-Message-State: AOAM5322oyLZpFWpg64piHRkTwnYNFVYr67ph8+Xg9dfGIkKnusOQRlx
        GKqwKB+Wn1m/cHZSS37dBQkdgg==
X-Google-Smtp-Source: ABdhPJzfv9A6DkoJT3pBO2IRdFRsSR/tN96ya98M6730iFgnRyno3kwUUm/9pGp9x30/lHjntR4DXw==
X-Received: by 2002:a63:d601:: with SMTP id q1mr9810597pgg.417.1614969228630;
        Fri, 05 Mar 2021 10:33:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
        by smtp.gmail.com with ESMTPSA id q205sm2235539pfc.126.2021.03.05.10.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 10:33:48 -0800 (PST)
Date:   Fri, 5 Mar 2021 10:33:41 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/11] KVM: VMX: Clean up Hyper-V PV TLB flush
Message-ID: <YEJ5hTNoDLqG7fm3@google.com>
References: <20210305183123.3978098-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305183123.3978098-1-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm an idiot and Cc'd my old @intel.com address on everything.  Apologies in
advance for the inevitable bounces. :-/

On Fri, Mar 05, 2021, Sean Christopherson wrote:
> Clean up KVM's PV TLB flushing when running with EPT on Hyper-V, i.e. as
> a nested VMM.  No real goal in mind other than the sole patch in v1, which
> is a minor change to avoid a future mixup when TDX also wants to define
> .remote_flush_tlb.  Everything else is opportunistic clean up.
