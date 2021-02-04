Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503CF30FA92
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 19:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbhBDSCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 13:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238683AbhBDSBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 13:01:41 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FB8C0617A7
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 10:01:21 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id i7so2643960pgc.8
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 10:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VwQNuwUjwq+Nww2o+LSNyWsERhy5B65x0MZjKZu7QiE=;
        b=V9WwpPLP510i8wJfZNgvI28QHF86yvPAF2UbjF490A7UdbG6rWNl1lQHI6iUez5P5I
         q6P3soanpTjeUf7jM1+3IbMM+rTkkV/uuAaPppCcVM/cZI6cBnr5ZUijJ6+z0XQp+sEx
         qtiNPD/C/bRpT/qHUjo1Wx3gZ4c/7Ko9mzN1N8JLcdN+7NuNDQ6Z2kwJEgogdx8chFsV
         Zjk1/y8n+y+ml5Mh/X8H/kCSTrosuDhIluZYTHjJuFXHJ4jjWKNzrgrIt7PumonTLmiy
         zZDxXOLnfnoOYKdnCEBlvNQeWMN7qt/V6dy0jLRKgqhvzYfaM/qFP2o0gXdD7TozX+KR
         CSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VwQNuwUjwq+Nww2o+LSNyWsERhy5B65x0MZjKZu7QiE=;
        b=HKEgw+Q+utHK/dGbYGVWMyMBiaP0ERQLAbYGgA+F+1CTuzgB194MFR5yomZY2wqt7R
         uXlsxljVpPlQzw1c3rdAkbaY7Twjx0IM7u+JGYyqbvH+y7dMcS+GQpl0aULe0Suyi6GQ
         7a8Z3kgXTWGi0g7CuZSIEgBITI502Niak2o1Z9VlAgBUeeYSS+va7tjkml3dLGLzxLTO
         KS80tge0kpWVPC+Ldtrwv7DoHxfqjb9hIfu/DlczU5YJkH8ac5TMLNBCoVdnY6Cgmqgf
         EXh0dF7cDdJ3ZmwT0iMM/mLP4wdenYxb/bM21IfKdFv5daSxW6Hq1maC50N6P0eQzm2I
         Kjyg==
X-Gm-Message-State: AOAM533R0mRjrrriHHfwKnpgKusfB9Ynj4FiI1sz/OSn8rrudPn96dBl
        gkFjQ8m/dvK384V2E41or5pKSg==
X-Google-Smtp-Source: ABdhPJzOC4xxlH8L2u8oSxdvrRQJdYz2hMvPZgL6PoMbtEguOgWPoV+goVrLoronxVDJyxq5LXLWEQ==
X-Received: by 2002:a63:1110:: with SMTP id g16mr136027pgl.357.1612461680989;
        Thu, 04 Feb 2021 10:01:20 -0800 (PST)
Received: from google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
        by smtp.gmail.com with ESMTPSA id v21sm6613993pfn.80.2021.02.04.10.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 10:01:20 -0800 (PST)
Date:   Thu, 4 Feb 2021 10:01:14 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>
Subject: Re: [PATCH 07/12] KVM: x86: SEV: Treat C-bit as legal GPA bit
 regardless of vCPU mode
Message-ID: <YBw2akNhCBGkoaSZ@google.com>
References: <20210204000117.3303214-1-seanjc@google.com>
 <20210204000117.3303214-8-seanjc@google.com>
 <5fa85e81a54800737a1417be368f0061324e0aec.camel@intel.com>
 <YBtZs4Z2ROeHyf3m@google.com>
 <f1d2f324-d309-5039-f4f6-bbec9220259f@redhat.com>
 <e68beed4c536712ddf28cdd8296050222731415e.camel@intel.com>
 <YBw0a5fFvtOrDwOR@google.com>
 <c16cbc1c-a834-edd4-bfdf-753ec07c7008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c16cbc1c-a834-edd4-bfdf-753ec07c7008@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Paolo Bonzini wrote:
> On 04/02/21 18:52, Sean Christopherson wrote:
> > > Alternatively there could be something like a is_rsvd_cr3_bits() helper that
> > > just uses reserved_gpa_bits for now. Probably put the comment in the wrong
> > > place.  It's a minor point in any case.
> > That thought crossed my mind, too.  Maybe kvm_vcpu_is_illegal_cr3() to match
> > the gpa helpers?
> 
> Yes, that's certainly a good name but it doesn't have to be done now. Or at
> least, if you do it, somebody is guaranteed to send a patch after one month
> because the wrapper is useless. :)

LOL, I can see myself doing that...
