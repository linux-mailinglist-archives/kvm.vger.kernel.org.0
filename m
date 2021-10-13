Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B937742CD55
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 00:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhJMWKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 18:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhJMWKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 18:10:00 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE52C061749
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 15:07:56 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 133so3658541pgb.1
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 15:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8C0qxsgkWODnLcBN3gRCnuaqFNYoLtWLymmFyee06vE=;
        b=qzOf0UKBPYMZhUVRWye57Cil5q4kTDCu6JSxz6jtIAQUJBpqkc2N9pB5caDsJ6ziWY
         SoPHcS7snsl5bzsmLWYRC1SQiZxGQGjBHg97ZR9IqIq5twy5hmz1etsVD6ISCv2qs/EV
         4dYZcrbV0+G29Lq3odHruLP3Vkw+q6ZC3BRQOktkKG+bSPsDBqSmvCHO3XhMH8sihedI
         Y3q1ib9jNUhx2m14gDf5CI8R0POu+H5OOsUgVGgLnHJoupFoa8oXcs4Xo4cQiuX6iG+g
         r+H5Wvr2OF5i4wFagvxMl3oj0RdRfwkopRKLmDxlsB4OdYfUugB/EIMN1K+HkQ74g3u6
         Tl+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8C0qxsgkWODnLcBN3gRCnuaqFNYoLtWLymmFyee06vE=;
        b=BK/c5QaaNj6U+yYKU2zLrIisCa34mehPZ7LHhtmAH72Gcej/xtSErH+U5Oyk6ir6ST
         85OiLU4wvWvoDYKrCdOHR5vCVNPEJSqKRmL7BzWU0bxy03shbm76MZLz26cU6WX/S5Q+
         j51xiy/1X/lNQzalJFijeYQsnkCTbuCRp1L9VpHRFFzPD9+w+e0tdbdQMfT3YbjIcF8T
         i9VrIVM8z3ZXo4eAR01wE+j2CkF3oxzQL1byE6wZNRJ7Z147y2tTtboxzMe1ubaM0RnY
         VQVmLoM1H7XXFuuvQVu4Mb2DOZxEIUPPF4w13OvgsGSb3WzPhUosYNOamrzpyi4yEqvG
         UI5w==
X-Gm-Message-State: AOAM530qBOlbZ/Mjhw7gAGeJDaR78CZEQLyN7HKvdRRPtspoTrTqMXdN
        UCGmS4j6JCFV31PIy9iOBq0uKw==
X-Google-Smtp-Source: ABdhPJy9fA5TH7e2MCJjKgc9WVyvSHvD1mzM8KwTopIi2IMGAgPspXyj9+JoEDO6FevsdP3jn+IZjA==
X-Received: by 2002:a63:e651:: with SMTP id p17mr1429235pgj.66.1634162843772;
        Wed, 13 Oct 2021 15:07:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d21sm436094pfl.135.2021.10.13.15.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:07:23 -0700 (PDT)
Date:   Wed, 13 Oct 2021 22:07:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v4 1/5] KVM: SVM: Get rid of set_ghcb_msr() and
 *ghcb_msr_bits() functions
Message-ID: <YWdYlzeJ0zUpXQma@google.com>
References: <20210929155330.5597-1-joro@8bytes.org>
 <20210929155330.5597-2-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929155330.5597-2-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Replace the get_ghcb_msr_bits() function with macros and open code the
> GHCB MSR setters with hypercall specific helper macros and functions.
> This will avoid preserving any previous bits in the GHCB-MSR and
> improves code readability.
> 
> Also get rid of the set_ghcb_msr() function and open-code it at its
> call-sites for better code readability.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I suspect my SoB got picked up accidentally.  If the intent was to attribute some
code snippets via Co-developed-by, feel free to just drop my SoB.
