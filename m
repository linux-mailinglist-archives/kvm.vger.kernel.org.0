Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669DE484956
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 21:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbiADUe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 15:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbiADUe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 15:34:59 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55ADAC061784
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 12:34:59 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id l16so15749892plg.10
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 12:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OMgPsxT7s5PUJzgh0jesH43SAy7zYp7IDqaflLd8kOc=;
        b=BnDklxMF7GBWTXml42AjnB8XOURccxORWmexAsnJvQUg+zPmhAke+angtUP+2jxFp5
         8YuDGsxl76thTZaW0BtpYLlfafDST7n2NfpnIhBs6q9ZH+guJqzDHCK0uuDvrlG2/nEZ
         Em/cMx0FJ+AmI3oeRyFDN/JKVwYfc3rgodds2IwwfSXBaD+4o+gmdx3w/xee2pPrNZuO
         v67koTt5zCsm2lO1T3pHwa51JCNtiPLfnqr478W5NnIK9QdzD7AgxSxGfFVzZ7Us9QqP
         mi2ifaursDFUk4PZduCJHC4SCrmaZM45O5/b6TwXc2Hav2yfvqZmy/HaWeCVrOz4ThGf
         bhfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OMgPsxT7s5PUJzgh0jesH43SAy7zYp7IDqaflLd8kOc=;
        b=5MjztB7T2dw8lZHJsTjKCDCewVcspoPpUfxSzkF4Bo9hwef8SQGiZFMqZval5FPHl+
         RcHuq7pCegf4xtEutasL9anF1Y+pgdmq0uVNh+m/NalGnMmwTbI/Qg0U3xxvEquVejgv
         GmQpDmO0MdPKNeIItJSr2giVYUKG+Nj6nHGSyYO87gRybTsM3oQaRQrt32iJR0Kvscfl
         Y8b69sKPOiUz4j7NHgFE0nuaRDx1Cgcoh4sEsJuOQSn5hT/Lmd2Gb/Cu9LdUhKtxPyXC
         AOA/hg3uN79iE4V7u8pA9TvitGoipN92ASFqd417wHMNyPusf/VcKioFEJQxpisaCSf1
         SiFg==
X-Gm-Message-State: AOAM533GV2/81kzKZBlL6OUlE9+yI6OORP0w6XquZEfGW6PhnJiYBihD
        J9IJFzwCKriI+WRWHehdoiL2cg==
X-Google-Smtp-Source: ABdhPJzDELlvn+sVviC6DXPdOsKXoAEYSXl3/DER8ndMXGraW8vZtyulFLLmGVGlcwUtk4Ty0nd5hQ==
X-Received: by 2002:a17:903:2307:b0:149:1bb6:fc28 with SMTP id d7-20020a170903230700b001491bb6fc28mr50288398plh.84.1641328498636;
        Tue, 04 Jan 2022 12:34:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y3sm187543pju.37.2022.01.04.12.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 12:34:58 -0800 (PST)
Date:   Tue, 4 Jan 2022 20:34:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 2/6] KVM: X86: Walk shadow page starting with
 shadow_root_level
Message-ID: <YdSvbsb5wt/WURtw@google.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
 <20211210092508.7185-3-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210092508.7185-3-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Walking from the root page of the shadow page table should start with
> the level of the shadow page table: shadow_root_level.
> 
> Also change a small defect in audit_mappings(), it is believed
> that the current walking level is more valuable to print.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>  arch/x86/kvm/mmu/mmu_audit.c | 5 ++---

I vote we remove mmu_audit.c.  It has bitrotted horribly, and none of the
current set of KVM developers even knows how to use it effectively.
