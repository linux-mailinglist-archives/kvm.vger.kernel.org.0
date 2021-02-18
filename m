Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A5F31EFD6
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 20:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhBRT3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 14:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhBRSsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 13:48:37 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B1CC0617A7
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 10:47:53 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id fy5so1869451pjb.5
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 10:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B9XROnsRjOrUM2s1XfiXJPnmRnJjYF8hX2hr/yT+6O4=;
        b=BXPxlaubos+1d1tncuAjiT9AMIJPSLMkDA8atOmQWJaGBID1GSapGxkzeYFhCWAnPt
         kmDOQ6QaqeFal45dnJEEG+1BJP4F8KktsHUNinGj3PKv5w6f61sj5vewq0Ku4qa5Yjv/
         RuLf/PoUrP/sQvjeidDiRnVlx5vfajfbmz3rqFN/rO+r1EGFDNuT+UZkrRtf0m9KUuDc
         BCs8PZ8Akz7CcDNRD0AUsfD/85b+rdzxQKXKL0Q2bJN6XITZZpaZ9laDBVG6MHwiOwpA
         KD7wL7hH6SftMCQ/oPzNMClIUukk9QxE06DNOxmSNBrFOjbLXrBVKFebc/Qn01Xt6lG2
         iXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B9XROnsRjOrUM2s1XfiXJPnmRnJjYF8hX2hr/yT+6O4=;
        b=egnsQwavaOkbGEyW3/3B0+o+vRWtXbK1K5U1gw1Cvv9xtIAgod2neOT1xLf/crWhtl
         xkGPIgF3+LQc4ZgG+2WNY+zwyeQIq0VByrgUqZrhQq8xmcbeCR0tl/Xs9ypL9HqHAVgl
         Co8Tvm8FEyVQJGiHti1wxIWq8IiBA4naqi6sKQ9Ek+c+2sIGhi7CrvMsDP/dqH0/Fa3Y
         wWxoJ3S/ZNAscJUPpsSSOUiH4UTQVRcVT8hEMNSI758QgvQD1nrfMgEV2dq1t0YpTd02
         W8OoBgh4N6Y0K2glW9qAw/IIZgkawZbHP65smvxumOCj4u4dOzRP8m0+dkrisE6/dJ2r
         M1Gw==
X-Gm-Message-State: AOAM533Qp2f5dMbt/6DhjrsbVaDvlnaDeuvcHpC2/RtE8l+hA5HmZ6YX
        oj/px7Fj53negS7tF/FsbU3KaiFhWJSX5Q==
X-Google-Smtp-Source: ABdhPJzEhYZzod9xwYN95K0PCcab0zZL7GFXyopzITdq9DIWf+ofRdKmAqpoI47t0wIGQqNFHLh2Zg==
X-Received: by 2002:a17:902:e74c:b029:e3:bc74:33c3 with SMTP id p12-20020a170902e74cb02900e3bc7433c3mr641715plf.51.1613674073336;
        Thu, 18 Feb 2021 10:47:53 -0800 (PST)
Received: from google.com ([2620:15c:f:10:903f:bec1:f9d:479b])
        by smtp.gmail.com with ESMTPSA id s23sm6753645pfc.211.2021.02.18.10.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:47:52 -0800 (PST)
Date:   Thu, 18 Feb 2021 10:47:46 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, Steve Rutherford <srutherford@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2] selftests: kvm: Mmap the entire vcpu mmap area
Message-ID: <YC62UiPCtAIFgS6L@google.com>
References: <20210217172730.1521644-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217172730.1521644-1-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 17, 2021, Aaron Lewis wrote:
> The vcpu mmap area may consist of more than just the kvm_run struct.
> Allocate enough space for the entire vcpu mmap area. Without this, on
> x86, the PIO page, for example, will be missing.  This is problematic
> when dealing with an unhandled exception from the guest as the exception
> vector will be incorrectly reported as 0x0.
> 
> Co-developed-by: Steve Rutherford <srutherford@google.com>
> Signed-off-by: Steve Rutherford <srutherford@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---


Reviewed-by: Sean Christopherson <seanjc@google.com>
