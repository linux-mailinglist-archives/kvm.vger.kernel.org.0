Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CF831EE6C
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhBRSfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbhBRR5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 12:57:08 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9E4C061786
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 09:56:25 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gb24so1788317pjb.4
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 09:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PNc6nW1j6gyGUgECPSUhdPjrew3Be+XPvKlUbO4tTHY=;
        b=DtQ6nFpPenOo69rxexkekvnfFCZ0wbVN5UmYKXGoQGGOsohrlCN8jXbyfECdFl3o4Q
         5jJbQ1RD0LtXmjc1CmqiSgALH7AVMeO3aNwcsfe9gi8yiAvX5VDrwbvlwGizXA+p+5+P
         66mx8Qee1nontChro3pbiM+/0J2XDwJXJHKxCEmp98Iv/zuv9fI6H+R34mGJBVFBbl5O
         gon9EFLcoQx0NLH3N8lMsmvHCfs0wCtrMo0Ar5c/5uTmhVLVYzBGz2XiOzERqvJ8H/1u
         wYI8D3Zo1+yaT1LCuyMWjWYn+RZvIhpTt0MxGuc5IzECkXVt2K5qrTl6LlExHIJJyNYH
         hTwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PNc6nW1j6gyGUgECPSUhdPjrew3Be+XPvKlUbO4tTHY=;
        b=Yo/5x6fN0ri87w/VIgWILZauuL6jjc3k+zegvhHP3GrgQZ7geEaTrDLGUgg61VLaRb
         8NC25Mx0m7Gd4j/9/jBigfmgLQQm9E6huB1riyn5xvqABM5VboA6vG8sFzP8Gn9Vbm9I
         cXhVw6nXZxmLGCman+RVjQKfwHLvsSETM0/eHMG0hwkgi2OABE6KbtUocV1VYHyfW9YB
         o8/gE1OSnlI4bbhPbzF/6htVhMtQiSrKSwwaqWBCMzhLX187hGlFqNhUhghmR1jAv1D6
         2isBAM/7ns70B0EmwdCc9oBpluDSq1kWuRMcaiONHEij1hJVhPkWmtKkS0jqrvUsS83A
         ZKQg==
X-Gm-Message-State: AOAM532+GOIw9mG2/ak2ke6WUxCchgjjFE9Wak43jmRxtBr3iBkTic7u
        OqyEQPwdku0rh3WiATV8WC4FGg==
X-Google-Smtp-Source: ABdhPJz8UU5r7+x+NFb2TQVORev6WH5WcsHhj0FwlFefXKVSlSiB9TpH+SOPHiERHkzdVPYlRpZsMQ==
X-Received: by 2002:a17:902:363:b029:e3:2305:7e97 with SMTP id 90-20020a1709020363b02900e323057e97mr4968275pld.11.1613670984652;
        Thu, 18 Feb 2021 09:56:24 -0800 (PST)
Received: from google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
        by smtp.gmail.com with ESMTPSA id u15sm6672711pfm.130.2021.02.18.09.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 09:56:24 -0800 (PST)
Date:   Thu, 18 Feb 2021 09:56:17 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v10 14/16] KVM: x86: Add guest support for detecting and
 enabling SEV Live Migration feature.
Message-ID: <YC6qQZpkdwueyFjs@google.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <6daa898789dc8de02072b1ee6e6390088dbbc5a4.1612398155.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6daa898789dc8de02072b1ee6e6390088dbbc5a4.1612398155.git.ashish.kalra@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>

...

>  arch/x86/include/asm/mem_encrypt.h |  8 +++++
>  arch/x86/kernel/kvm.c              | 52 ++++++++++++++++++++++++++++++
>  arch/x86/mm/mem_encrypt.c          | 41 +++++++++++++++++++++++
>  3 files changed, 101 insertions(+)

Please use "x86/kvm:" in the shortlog for guest side changes so that reviewers
can easily differentiate between host and guest patches.  Past changes haven't
exactly been consistent for guest changes, but "x86/kvm:" is the most popular
at a glance, and IMO aligns best with other kernel (non-KVM) changes.
