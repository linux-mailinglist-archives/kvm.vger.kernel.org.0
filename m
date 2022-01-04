Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CE1483FF9
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 11:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiADKf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 05:35:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229731AbiADKf1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jan 2022 05:35:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641292527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WvZndWSQ+zrrTiu8plr7UNDuSbJXU8G5GfrNUxHwja4=;
        b=NuJG0jBPgtrPIghJOx3//uyjPjDs0D/hq3bKvGTp2eDJ7VqAN9mNHkCp/5jynMJRNb4l/v
        IdhpEIQmsAvVhBv2M2e3uIsQc4DBEVmoDr1y8T7pvS02dM4UGcehA7R3/yrHw9FnyBelLJ
        1W6mkK07MWoy9un8H++CADAysvcm1vQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-fZffvTtIPNO2ZDCO4tDaGg-1; Tue, 04 Jan 2022 05:35:26 -0500
X-MC-Unique: fZffvTtIPNO2ZDCO4tDaGg-1
Received: by mail-pj1-f72.google.com with SMTP id a17-20020a17090abe1100b001b1e42e6db9so1749275pjs.0
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 02:35:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WvZndWSQ+zrrTiu8plr7UNDuSbJXU8G5GfrNUxHwja4=;
        b=5yCQo8e9kB2AGws40CkgyDazUCBaC5+lZK8EkU5mH+bjfvI/tWAoLY8e0OJ34YumMd
         JtKRj6gxAnH9cEOkzeSqp8KQ2jHuQ/x74TREMhlFtasnbPZ4IDUMCP36INtwoLtZZ/q/
         rWcJ4pTDY1D1nF5PlojbEmiZS0LpEenVSMLUDz5UxNflOfmF22MxkcbryCiWyWclHr5s
         +yaskoLxsNcN+ij3ZwTRgf0BBeeA+yn5TU5TUgcoMCDICa+i+yNhaAumbpb5rPSjrd9z
         BDrDKSc2CS532AGp4m0zutOccVklGqFOLrAMvlXVJYnpib10SZEbVqoYw611rjqCxu+S
         PlGw==
X-Gm-Message-State: AOAM5323PPqK+r/pCptZYLGT7UXF/r1vikWQO2xwcs3vt17T4bdxRNo6
        /0e6V2SMhatBYPR9YRw4eLySWszZ3ej2+Cst8oRDaRref27yx3VWj4Kbbn9SSJ0Sl77lOv3JPu1
        SsfbsiIgrVQPv
X-Received: by 2002:a63:7d46:: with SMTP id m6mr12500213pgn.290.1641292525294;
        Tue, 04 Jan 2022 02:35:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVNVJoQn200LEvnyi5W9rRN7eSnhCjETv3k1ekMJC+gbRkLvrwv9kuVEv6JqoF+7xGsh50tw==
X-Received: by 2002:a63:7d46:: with SMTP id m6mr12500199pgn.290.1641292525093;
        Tue, 04 Jan 2022 02:35:25 -0800 (PST)
Received: from xz-m1.local ([191.101.132.50])
        by smtp.gmail.com with ESMTPSA id m3sm40032766pjz.10.2022.01.04.02.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 02:35:24 -0800 (PST)
Date:   Tue, 4 Jan 2022 18:35:03 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 06/13] KVM: x86/mmu: Refactor tdp_mmu iterators to
 take kvm_mmu_page root
Message-ID: <YdQi14SL31sYI9iz@xz-m1.local>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-7-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-7-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 10:59:11PM +0000, David Matlack wrote:
> Instead of passing a pointer to the root page table and the root level
> separately, pass in a pointer to the kvm_mmu_page that backs the root.
> This reduces the number of arguments by 1, cutting down on line lengths.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

