Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0CB486D5C
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 23:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245230AbiAFWsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 17:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245167AbiAFWsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 17:48:16 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF78C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 14:48:15 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id r14-20020a17090b050e00b001b3548a4250so1740397pjz.2
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 14:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l+fxVEP2+Qr3elbZodhGken/HREcYcqD2mCaK9pZtDQ=;
        b=iuxwhiIc52AIRabAXoO1QCylunXdfM14iu1U5l9jH8+l9hI+PI5oPPeXkCETx+xpem
         EQiK2ve9tetgf4fZkXKvt/4Zrb9McBTpbaCT524mCahx2xUyCTqXs+kTBVj2cev/R1p+
         6I7tvp6gw37Bu5SzVe7NloOM7smB5s71tD+lG0U7YIc3Pn0nySTTsYDdK8Nlp/irRJZo
         pATxle/ddB7hrfmohjuDh+W+B+bEH0RvkaU2ZFZ1GIs8F10flWcpDMhRs7QHyIqDhwmc
         STcZYXWUjlh8smFVa/H8TKwmBKmE2RLawTbPgCgHmaLFIypufmzcMJ8XYie3eltcQV9h
         pFJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l+fxVEP2+Qr3elbZodhGken/HREcYcqD2mCaK9pZtDQ=;
        b=km1qlI/ajxzKQh+onBURQ2mS7Lx0mpeUk34uffuhKz8dSexuc4n4G1ydfSIwDC5IRY
         79SeyWrGhXlCLRe5/uESPv+B37cvRXFFCrKa/TfN8aZJdibcHyNzu3w2zzrOf9mLy1/d
         ID2qJYYmiIIH9Be5UZKO2ofCa/QwzAjZrGja7W98ylJepKOAj8kyTTk9NosWzGYz5thv
         TwJB++GQoaLy6yy1t+9q7G5EYpxXYL22U48lnRLyIPDxe7SvPZsJtRN2byp82KZ9OkCq
         hPZNjHXef4VP/NsXzC3frAVW8EY+Ci9WSuMzlv8mEHultAO9dUSbUTPly+s0pOAsonqb
         5Q7Q==
X-Gm-Message-State: AOAM530EGBXEYM+8nXL7m7VYeVRd1AR7FJuVpO8BL59l/gkpDm3d2XB0
        In6d6n1KZKhRjmhr5cJCnfoCSA==
X-Google-Smtp-Source: ABdhPJwVdXJzhQfbGGCjGUHnQbANRD0yiAJqCGSvfV0VgmULzqbuWNyNi+osv3dAz7J/guKnMkbHwA==
X-Received: by 2002:a17:902:d385:b0:149:8864:a556 with SMTP id e5-20020a170902d38500b001498864a556mr46965445pld.170.1641509294743;
        Thu, 06 Jan 2022 14:48:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m14sm3577839pfk.3.2022.01.06.14.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 14:48:14 -0800 (PST)
Date:   Thu, 6 Jan 2022 22:48:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 09/13] KVM: x86/mmu: Split huge pages when dirty
 logging is enabled
Message-ID: <Yddxqs7tI/iKpEY0@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-10-dmatlack@google.com>
 <YdVOycjyfi4Wr9ke@xz-m1.local>
 <CALzav=dbJhibg1Qy5FGaCPKJZ+AmwjFyoAAzHNFAwLy-dLmCQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=dbJhibg1Qy5FGaCPKJZ+AmwjFyoAAzHNFAwLy-dLmCQw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022, David Matlack wrote:
> > I don't even see anywhere that the tdp mmu disables the EXEC bit for 4K.. if
> > that's true then perhaps we can even drop "access" and this check?  But I could
> > have missed something.
> 
> TDP MMU always passes ACC_ALL so the access check could be omitted
> from this patch. But it will be needed to support eager splitting for
> the shadow MMU, which does not always allow execution.

Sure, but let's add that complexity when it's needed.  That also has the advantage
of documenting, in git history, why the param is in needed.
