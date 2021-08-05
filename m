Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3E23E1B1E
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 20:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241135AbhHESUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 14:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241126AbhHESUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 14:20:01 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F11C061765
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 11:19:45 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id nh14so10919475pjb.2
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 11:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=InNueHw56vHBV+1tT6xD7MnAUIreY9NYLVLxpAGdi8E=;
        b=CuuxnsN0QgIUDgNI0+zzS+ltEtAuQsligmM89FxcRGwaSyAFpJWi1g1UU6g8+QVwjJ
         7TheF0ELN5GPWRXdSWQWVDyRIVyh3AYbhQbqK2+ja4LzBUsSA2dLfrOeWMMytxW2w7/N
         +1D5KcQyCXFdRm/8IT96c44RWWQr5BRFk9JxbNRArHHkCZ5AK9u1FVrHE8WGCihgTyZQ
         CfmU1Y4VYsUMIoMJrhcvIjayL6yqACQhIcoYjli0ULYRjH7NTLlvj6dOGwZsNtAEQYrd
         rEc26P3Mrpv0sUL6P9aJ4A9UF45Hh7z9EtmjRVxyaWGXtb7vjnwkqmRxXiGoIypZNRVL
         +bvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=InNueHw56vHBV+1tT6xD7MnAUIreY9NYLVLxpAGdi8E=;
        b=HjckJ9OL2xCyWHoGtHgKPl6Q3RRD0WZG6iHAff5cn8o27vdSDVD/QhnILGtzX4VOCJ
         cjZPb5ETZjbin8bfwAItmzU6gfbQemp1HtVZ9E/ZH2hcFVz+K7S/I68isj0M3tiun7da
         SWivBUkPws111HTsakWf3boSh8pPCpVXbpFzPph81XRptmqv2UbjwfMuPepTsqH9YZ77
         kcCNpQuaRRCg4XB5GtU8agRiV2AN1a/igSDXR5S4h0M8UJMIpuAS/aO9QD3DNLFjCXeS
         r7aTNtQqHMA8v7zHESoSc3PwFp3J3Yz1xpgjXhivVwsGo4qeTeu+etqLbHB4K+Xp5XET
         JUIA==
X-Gm-Message-State: AOAM5316+kVWQkJ/ZuyBNxHfQ7aB7JKSTAJ0O74Qv81lJRGJOL/77Hyq
        eJEvr+//wJfWnBsgDDe4BZ4dzA==
X-Google-Smtp-Source: ABdhPJyD44lfRbmtbRyYlKYo78opElfarkxLTHe3/Hy0Me7lLaLMaId5sNULWNI48OEexuH9ivy+0Q==
X-Received: by 2002:a17:90a:3801:: with SMTP id w1mr16476553pjb.57.1628187584967;
        Thu, 05 Aug 2021 11:19:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 16sm7571735pfu.109.2021.08.05.11.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:19:44 -0700 (PDT)
Date:   Thu, 5 Aug 2021 18:19:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v3 4/7] KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs
 file
Message-ID: <YQwrvX2MHplDlxrx@google.com>
References: <20210730220455.26054-1-peterx@redhat.com>
 <20210730220455.26054-5-peterx@redhat.com>
 <8964c91d-761f-8fd4-e8c6-f85d6e318a45@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8964c91d-761f-8fd4-e8c6-f85d6e318a45@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021, Paolo Bonzini wrote:
> On 31/07/21 00:04, Peter Xu wrote:
> > Use this file to dump rmap statistic information.  The statistic is done by
> > calculating the rmap count and the result is log-2-based.
> > 
> > An example output of this looks like (idle 6GB guest, right after boot linux):
> > 
> > Rmap_Count:     0       1       2-3     4-7     8-15    16-31   32-63   64-127  128-255 256-511 512-1023
> > Level=4K:       3086676 53045   12330   1272    502     121     76      2       0       0       0
> > Level=2M:       5947    231     0       0       0       0       0       0       0       0       0
> > Level=1G:       32      0       0       0       0       0       0       0       0       0       0
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >   arch/x86/kvm/x86.c | 113 +++++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 113 insertions(+)
> 
> This should be in debugfs.c, meaning that the kvm_mmu_slot_lpages() must be
> in a header.  I think mmu.h should do, let me take a look and I can post
> myself a v4 of these debugfs parts.

When you do post v4, don't forget to include both mmu.h and mmu/mmu_internal.h. :-)
kvm/queue is still broken...

arch/x86/kvm/debugfs.c: In function ‘kvm_mmu_rmaps_stat_show’:
arch/x86/kvm/debugfs.c:115:18: error: implicit declaration of function ‘kvm_mmu_slot_lpages’;
  115 |     lpage_size = kvm_mmu_slot_lpages(slot, k + 1);
      |                  ^~~~~~~~~~~~~~~~~~~
      |                  kvm_mmu_gfn_allow_lpage
