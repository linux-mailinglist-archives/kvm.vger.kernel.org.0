Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B70A3011B8
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 01:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbhAWAaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 19:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbhAWAaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 19:30:07 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA66C0613D6
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 16:29:27 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id x20so4915216pjh.3
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 16:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JYV4rqk7TIJOls4aIYOUfgRgv+FJ3Bybe0z5zvt0O7Q=;
        b=El3nUfopMydRnCl9GOyvd5cxCak0al5FXcbT6BiVzxoyts5vmsuAa4eUFOTzbUIlp6
         GVZzkro3xnR49VaHW3drFk4t+/eTDBPxIjl2nOT+xZuAUlCe/B3SHZcdpSaqwXDL6ykg
         7mG55vp4pb0wuZPlFnuhZswUdQMi/EAN2WTlOT52gAcWuhs18ENKphCjt8ZjDAR92x23
         pkT/xCeFIoZKW074PTlX7eKG4SfBVFwwAFKg7sgZRJa/Q3rtMD6P3FbVGkvlrD2iC3Pf
         ZEkBHjaSvF+Ql1/7LKzJAkGxyd6jjZNx4EYGtkRUs9dRdm8Kk70rZ8oHGX5INX0JbOLb
         PsyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JYV4rqk7TIJOls4aIYOUfgRgv+FJ3Bybe0z5zvt0O7Q=;
        b=A21W72qqYJgTF/vw92LiOzPln6oVs5TlMFi+w7ZP9bL5zT0g28Oz7gcwK+HvAc+jo6
         RKUVY8doV0BrVL61nSIcZSAkXl1M6k4Kqa5CfUsLPKyh/us/2xw4ivU77IE9W1w4yJ75
         B65BvL6qcVRQDhvkBOhGw/ofki7GxTARhPC9KZ2UplBtwjjwQdzAfT2Jmn3eBgq7smdu
         8B3lI4GAc6tW1w7hgduXGRWbVOd2dQokAmiw5yNNlcxHV4NqdqFPiEJ5boka3v6OPF+6
         ImZn3FapOsrQlY2Bm+H8yxWVc3oH+Eh1IG4qOm5bnwTZlYeGLekE1cV5cZo+UxHouYRI
         iXMA==
X-Gm-Message-State: AOAM530ca7/nhQ0GXOv9MLUTcBvEIl1ouJUIymXoP5A1v0J12ckoDNLk
        v1YRpg1/M4OKZzKISADyDpUOzA==
X-Google-Smtp-Source: ABdhPJyoONkEm2J9ITe4V6jvZN8X3b2s30ELlnoOthsB+837AdhIk2k9C1PL1ntyue/tv/K7/zZibA==
X-Received: by 2002:a17:90b:313:: with SMTP id ay19mr2089571pjb.184.1611361766735;
        Fri, 22 Jan 2021 16:29:26 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id x125sm9323072pgb.35.2021.01.22.16.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 16:29:26 -0800 (PST)
Date:   Fri, 22 Jan 2021 16:29:19 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH 3/3] KVM: SVM: Sync GPRs to the GHCB only after VMGEXIT
Message-ID: <YAtt38s4GLG9cviK@google.com>
References: <20210122235049.3107620-1-seanjc@google.com>
 <20210122235049.3107620-4-seanjc@google.com>
 <0d8e9d63-1fe9-af08-dae9-edd80083e940@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d8e9d63-1fe9-af08-dae9-edd80083e940@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 22, 2021, Tom Lendacky wrote:
> On 1/22/21 5:50 PM, Sean Christopherson wrote:
> > Sync GPRs to the GHCB on VMRUN only if a sync is needed, i.e. if the
> > previous exit was a VMGEXIT and the guest is expecting some data back.
> > 
> 
> The start of sev_es_sync_to_ghcb() checks if the GHCB has been mapped, which
> only occurs on VMGEXIT, and exits early if not. And sev_es_sync_from_ghcb()
> is only called if the GHCB has been successfully mapped. The only thing in
> between is sev_es_validate_vmgexit(), which will terminate the VM on error.
> So I don't think this patch is needed.

Ah, nice!  Yep, this can be dropped.  Thanks!
