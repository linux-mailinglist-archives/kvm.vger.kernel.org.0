Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B45483F5D
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 10:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiADJtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 04:49:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36058 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229544AbiADJtm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jan 2022 04:49:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641289781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YpNiKCEEClifXbrrffhTc71qnle0TERlVItJBwJNSFk=;
        b=bAVqRj2eknEt2FN0ucBxf6pN007s2G5hDGGGFgAYpq1hIoQghN/edj3zg0tfDsQeS48H7r
        kFUmKut+e4J0vsZ3SESjrd1NpwQ4qHhrN10zRrJimvNIPQuf9ZbNNdauZ/oXrEJI57XTyO
        978khK+Qa9ykP/KG3OV8JlaSnj9z998=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-iraxi8DuMlSI2wk7u4YW4w-1; Tue, 04 Jan 2022 04:49:40 -0500
X-MC-Unique: iraxi8DuMlSI2wk7u4YW4w-1
Received: by mail-pj1-f72.google.com with SMTP id r1-20020a17090a438100b001b1906bd90cso28918453pjg.2
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 01:49:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YpNiKCEEClifXbrrffhTc71qnle0TERlVItJBwJNSFk=;
        b=iUd7DoY+jcVJh3Z+yP/GoBvj+VnIYqqTD0/0zRx03q4ZoS2YV1dtKB8k/ZhTyVPye+
         0Cp/kyne/0zLOUMRylDjj1UR3iC4nzVAm2HDZPu8KWYoT3GT25FdaQNpIz0qO8cdDhdr
         a+xgRGoKcvRceoTNS3lRFLmowkIq78odvxG4GKAz6N1PGevImBBWMLvkQQqpwyIiQGq+
         rdcDxs1urUEUW781EUGLi+eF+176XwG+H3uHdSygzrj8M+fxjZrywO6gnoM4QYxwzAif
         v7GGw0LUoH+MDxY39ifJBBHC1na/dR0vrBs2F3S/JeL/eZ+Ku7+D/AxwA2mbUzfzZYs2
         qTOA==
X-Gm-Message-State: AOAM532bqUWt/DKIArBl4bjdcchobSIxYk7mmPDiAPcd//9BRCIzhtRy
        SvtzwhKhNTtnpCkTlYmhUfKYfa+9OTNLWGrk6+wCQ/TWnJdv19nbeWL0w+xIRLRev0+9WdI28cZ
        CGnfHVTSQDV4V
X-Received: by 2002:a17:902:ea0a:b0:149:1f26:bce1 with SMTP id s10-20020a170902ea0a00b001491f26bce1mr49150995plg.92.1641289778754;
        Tue, 04 Jan 2022 01:49:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwH0a8yjIxd15fFWlBfdDYNRS1vCNIbcIoHgqDlad1dv6sP1ey5Qr7nvKC07aMG4Oe9m7F0g==
X-Received: by 2002:a17:902:ea0a:b0:149:1f26:bce1 with SMTP id s10-20020a170902ea0a00b001491f26bce1mr49150987plg.92.1641289778486;
        Tue, 04 Jan 2022 01:49:38 -0800 (PST)
Received: from xz-m1.local ([191.101.132.50])
        by smtp.gmail.com with ESMTPSA id y32sm43349062pfa.92.2022.01.04.01.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 01:49:37 -0800 (PST)
Date:   Tue, 4 Jan 2022 17:49:31 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vasant.hegde@amd.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH] KVM: x86: Do not create mmu_rmaps_stat for TDP MMU
Message-ID: <YdQYK4oRDU2Dmfwe@xz-m1.local>
References: <20220104092814.11553-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220104092814.11553-1-nikunj@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Nikunj,

On Tue, Jan 04, 2022 at 02:58:14PM +0530, Nikunj A Dadhania wrote:
> With TDP MMU being the default now, access to mmu_rmaps_stat debugfs
> file causes following oops:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 7 PID: 3185 Comm: cat Not tainted 5.16.0-rc4+ #204
> RIP: 0010:pte_list_count+0x6/0x40
>  Call Trace:
>   <TASK>
>   ? kvm_mmu_rmaps_stat_show+0x15e/0x320
>   seq_read_iter+0x126/0x4b0
>   ? aa_file_perm+0x124/0x490
>   seq_read+0xf5/0x140
>   full_proxy_read+0x5c/0x80
>   vfs_read+0x9f/0x1a0
>   ksys_read+0x67/0xe0
>   __x64_sys_read+0x19/0x20
>   do_syscall_64+0x3b/0xc0
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>  RIP: 0033:0x7fca6fc13912
> 
> Create mmu_rmaps_stat debugfs file only when rmaps are created.
> 
> Reported-by: Vasant Hegde <vasant.hegde@amd.com>
> Tested-by: Vasant Hegde <vasant.hegde@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Shall we put the check into kvm_mmu_rmaps_stat_show()?  As iiuc the rmap can be
allocated dynamically (shadow_root_allocated changing from 0->1).

Thanks,

-- 
Peter Xu

