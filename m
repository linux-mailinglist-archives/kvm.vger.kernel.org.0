Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0132747596A
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 14:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhLONJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 08:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbhLONJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 08:09:33 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA91C061747
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 05:09:32 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id q72so29924603iod.12
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 05:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o4iIShwRZXVs+Jqe3sjEL4qca2b6WBA7S1kQI8tQZtI=;
        b=YtPWBvOOukfpvhAJj/xlXfYe8gUBwnx8340HV/ecPejIFL3fKlsIoOnR0af5pSq7xP
         uYBx9sDiDfMX7GhmzKnez0oE+TrU1OrbESwb2i1d0zhGpBLq2cVSCxwWNGrPGcPx08KK
         IHDRff46Ut75ToL5XSc2IknpJwHetqXnPS3YmSeihIiGU+ourObiTDUfXX1/pXQSg7zi
         aZ+JBWfeWFHfPSm06flG4XgdvPr4Hu4i/pkSmPDCzq8q5iDu6o0K6nI5cOYJpAv50L+W
         KT9sz2A/VM7a0QM2zYopHRbLHjoEY/hx/3rQUpiw+5uS1cfVSAbcjUFxZuonSjRQ+7RT
         AH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o4iIShwRZXVs+Jqe3sjEL4qca2b6WBA7S1kQI8tQZtI=;
        b=EFkBIr3IEpysZxnc4QvXJg9IyidauQqsPrgBbXdTDCZ9pZDwzNF+tcW1WdLVymEcg3
         N+l3jxGFBu+MYep/IJ1AheTfwRTsNDqRCf0ssHDC2YOXBkqggQKqnQET5yxzOV3ESKk7
         Ut8mtvuzo/WNaAIIudBiFQltsdGoHY39qXE5DA9sg9nG/5QkCkTHauUXSz5ArkmQXeQA
         ZAF9qdbCv4IPlZkJ0Uk4AzR+ygLbNpodf3a78dsH6wWzSMtUuPCp+FypTqFvsL60kOiW
         WmsD0N5Rn4RTfVGsofwjQHh/1FqFADHHp3/I7CcZFLlOcQHNsA50rQzVTIExciE5bkDL
         zmCA==
X-Gm-Message-State: AOAM533vLv/rc/af+icfxbevDZw0BAZxn+0sZsBXwuFc/Wyyw6GulYst
        lLAXzyKsvrEWVA46lfgItCU2D3bWuIAp6Q==
X-Google-Smtp-Source: ABdhPJxHP9shiYlKk4jWXLjv34HJNRfwkTsv5D61mMoKrRdSXUIyH2G+QT3+Yuji/sEszZxl2Bdq1g==
X-Received: by 2002:a05:6638:2503:: with SMTP id v3mr5510689jat.397.1639573772084;
        Wed, 15 Dec 2021 05:09:32 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id t6sm1088516iov.39.2021.12.15.05.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 05:09:31 -0800 (PST)
Date:   Wed, 15 Dec 2021 13:09:28 +0000
From:   Oliver Upton <oupton@google.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1
 as undefined
Message-ID: <YbnpCFBPNgmkEXjf@google.com>
References: <20211214172812.2894560-1-oupton@google.com>
 <20211214172812.2894560-2-oupton@google.com>
 <YbnUDny3GSNpyabJ@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbnUDny3GSNpyabJ@FVFF77S0Q05N>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mark,

On Wed, Dec 15, 2021 at 11:39:58AM +0000, Mark Rutland wrote:
> Hi Oliver,
> 
> On Tue, Dec 14, 2021 at 05:28:07PM +0000, Oliver Upton wrote:
> > Any valid implementation of the architecture should generate an
> > undefined exception for writes to a read-only register, such as
> > OSLSR_EL1. Nonetheless, the KVM handler actually implements write-ignore
> > behavior.
> > 
> > Align the trap handler for OSLSR_EL1 with hardware behavior. If such a
> > write ever traps to EL2, inject an undef into the guest and print a
> > warning.
> 
> I think this can still be read amibguously, since we don't explicitly state
> that writes to OSLSR_EL1 should never trap (and the implications of being
> UNDEFINED are subtle). How about:
> 
> | Writes to OSLSR_EL1 are UNDEFINED and should never trap from EL1 to EL2, but
> | the KVM trap handler for OSLSR_EL1 handlees writes via ignore_write(). This
> | is confusing to readers of the code, but shouldn't have any functional impact.
> |
> | For clarity, use write_to_read_only() rather than ignore_write(). If a trap
> | is unexpectedly taken to EL2 in violation of the architecture, this will
> | WARN_ONCE() and inject an undef into the guest.

Agreed, I like your suggested changelog better :-)

> With that:
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Thanks!

--
Best,
Oliver
