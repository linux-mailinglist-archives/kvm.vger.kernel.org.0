Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3C3487ADB
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 18:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348407AbiAGRBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 12:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiAGRBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 12:01:15 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9F0C06173E
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 09:01:15 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id n16so5333827plc.2
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 09:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RCDylDwp4qWpGPqTMGoN1aJK5ip8JgfAyNjEVu75o/k=;
        b=V6I8lxiQNnQrAKFZ2CUCzV8K+abyDM+LMfXG6HoexupRV/6hrwJqZHkAw3XiffHvoY
         Mc04tPLWG+kiNR4K4jHhFblETm54FbwnCxJ1j3dBpYRCErmoDzgnCKSFZWBuHKI1Z8ix
         MzlMDH2p7SjfVTxkCFKMrv4bcsq4InIPUz3aGBOUrrvw4RKpC/eL66gkBSW+qKFF0boz
         MvLgIEeRR3ZEm4suKDigRXYALTJXqzfveD/jB1c3ghnhK+NVA2yNmnGVr4T92PkKofwV
         orv+QNs3o13LsgmdBwbhWnGfc9VLB777y4kcc8mzuV5BWBdfpdzn62wzzerAGTSouj3a
         UPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RCDylDwp4qWpGPqTMGoN1aJK5ip8JgfAyNjEVu75o/k=;
        b=8BB5MszNpfEwN4ETtlAzbiKRWnU3BBaCX76QFlZSitY9TL+/GWwf8rxw4GV/x/8TpN
         m5lcvFZBYcAcwkodS+GrXl/nCEtIVYAA2Lj6owBZlu3pRUDpN+6ERYqCwnMwU2I/DHWA
         BBOIkuybNXbs82ddl6hs2VIPK7V58gnaShoUU1gQ8E451cbTpOnh59GmHe8JM6r4lH9K
         0hqrWR8UPAMZNI3JVceVfjkPwflWa8CnyhYTWWdQnN4H9HD9feCQPbnzJoyu6A8FrOnG
         Wsc9mNAEtBVk9tH12yNIvCSNa4wJG9vRPCjnxxC6XDREAqAks+Dex4Hvr2D853fFhc+0
         Z7JA==
X-Gm-Message-State: AOAM533avzyxDfhP91HBlNOmeklK7l3JPvAyl7oHtuUR+v3QsSUjCVEi
        zK30D2c57oE/RcpsEwFcZLaoyQ==
X-Google-Smtp-Source: ABdhPJxrdS6TFey8UeW8tmES7ten30cTzhYZqIv9a1GAH3sbpye1aE7WgQ6sPovElcjiNEJxVW8J2Q==
X-Received: by 2002:a17:90a:5411:: with SMTP id z17mr16813096pjh.176.1641574874319;
        Fri, 07 Jan 2022 09:01:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o27sm5166412pgm.1.2022.01.07.09.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 09:01:13 -0800 (PST)
Date:   Fri, 7 Jan 2022 17:01:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Nikunj A Dadhania <nikunj@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vasant.hegde@amd.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH v2] KVM: x86: Check for rmaps allocation
Message-ID: <Ydhx1qguxVZxOGfo@google.com>
References: <20220105040337.4234-1-nikunj@amd.com>
 <YdVfvp2Pw6JUR61K@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdVfvp2Pw6JUR61K@xz-m1.local>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022, Peter Xu wrote:
> On Wed, Jan 05, 2022 at 09:33:37AM +0530, Nikunj A Dadhania wrote:
> > With TDP MMU being the default now, access to mmu_rmaps_stat debugfs
> > file causes following oops:
> > 
> > BUG: kernel NULL pointer dereference, address: 0000000000000000
> > PGD 0 P4D 0
> > Oops: 0000 [#1] PREEMPT SMP NOPTI
> > CPU: 7 PID: 3185 Comm: cat Not tainted 5.16.0-rc4+ #204
> > RIP: 0010:pte_list_count+0x6/0x40
> >  Call Trace:
> >   <TASK>
> >   ? kvm_mmu_rmaps_stat_show+0x15e/0x320
> >   seq_read_iter+0x126/0x4b0
> >   ? aa_file_perm+0x124/0x490
> >   seq_read+0xf5/0x140
> >   full_proxy_read+0x5c/0x80
> >   vfs_read+0x9f/0x1a0
> >   ksys_read+0x67/0xe0
> >   __x64_sys_read+0x19/0x20
> >   do_syscall_64+0x3b/0xc0
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> >  RIP: 0033:0x7fca6fc13912
> > 
> > Return early when rmaps are not present.
> > 
> > Reported-by: Vasant Hegde <vasant.hegde@amd.com>
> > Tested-by: Vasant Hegde <vasant.hegde@amd.com>
> > Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> > ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
