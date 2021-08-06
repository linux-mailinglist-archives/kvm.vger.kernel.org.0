Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28FD3E3188
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 00:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245474AbhHFWJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 18:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245460AbhHFWJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 18:09:57 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0812CC0613CF
        for <kvm@vger.kernel.org>; Fri,  6 Aug 2021 15:09:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso19958177pjf.4
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 15:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yXtLp5mFbNs2K0XuuKSxUcF4dNWpNzn+5MPoGaJAJtU=;
        b=aSgDj0Y/r/a3naWQ65dmyylrY/CsJ6633DvELHg1r0k6vPieJelzG/b2jAcM3dDthJ
         wN8V8lFRUQH19JnK1STNdvVn92fIbgD3Uf+H613h2nNkFz6vWO6X660DRp1ypAU1EKWX
         v4k9UfqP641eCpZomgsyJ9w/L33qXNsr5WQAN5BX7BYOmzzyTN9nqBVkmUU69dl5dss9
         3/3C4R6LtKQGcZxU9nApBIdgwB+LWSz4BlTlQKa+lIMmytzEYpTu5qlW2MRGkbfq/Sxr
         ioZr10k9Ogkzi+1Wv6dMdS0enZJAEVpIcI1FfS7QXw+XBwmQOYXJ0WfGZOUrFxcwRr2Y
         cK8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yXtLp5mFbNs2K0XuuKSxUcF4dNWpNzn+5MPoGaJAJtU=;
        b=Q+T178Y6H0a2Ma8n2VUCKf4p29LH5FwESiVSqF6w5Y+2f9AB7zLOF7TJq4f/xXB0y7
         eXhTXVu9lprhuRfBF2BoBcPJBAN9YErPIV2seg81cN4rWDeaLMYkl9YlN7Odd8bhAbWD
         y7/38kzFGHmsD/ZyCM01P9nmPULyWRWj2sUlLuQvo8ijoR4/zTNJ8fGmUyX+3h1H0Fcf
         X5jfBgMO+/qymvJD5Hrjymgdotu3xEEddAVX9Cds+o4SSuhDdo8ZLBDWXc0fiO3Jwn80
         JwPGQpkID0+CxL1FYH7I++WPaQedkFv+UALP/l7lWv2xdXcR5A0J3pA3PkiogyXSESzy
         7XLg==
X-Gm-Message-State: AOAM531k8g087YbnIdKV2jILL8a7jOGrDU1cuSV5681suoJBqYvoujA+
        XkU2h+0C4z4cH6gPqJvr4dOWmg==
X-Google-Smtp-Source: ABdhPJyhhVa3xTLuiQI9QTy9DGbWO9kLU8eJ91KOYmDq8h019tDOaczTDzNrzWk9rEiBQKJeFV83AQ==
X-Received: by 2002:a17:90b:4ac8:: with SMTP id mh8mr12080592pjb.5.1628287779379;
        Fri, 06 Aug 2021 15:09:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id qe3sm13080347pjb.21.2021.08.06.15.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 15:09:38 -0700 (PDT)
Date:   Fri, 6 Aug 2021 22:09:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH v2 41/69] KVM: x86: Add infrastructure for stolen GPA
 bits
Message-ID: <YQ2zH+XiLCLQWs0l@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <c958a131ded780808a687b0f25c02127ca14418a.1625186503.git.isaku.yamahata@intel.com>
 <20210805234424.d14386b79413845b990a18ac@intel.com>
 <YQwMkbBFUuNGnGFw@google.com>
 <20210806095922.6e2ca6587dc6f5b4fe8d52e7@intel.com>
 <YQ2HT3dL/bFjdEdS@google.com>
 <20210807100006.3518bf9fbdecf13006030c22@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807100006.3518bf9fbdecf13006030c22@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 07, 2021, Kai Huang wrote:
> So could we have your final suggestion? :)

Try the kvm_mmu_page_role.private approach.  So long as it doesn't end up splattering
code everywhere, I think that's more aligned with how KVM generally wants to treat
the shared bit.

In the changelog for this patch, make it very clear that ensuring different aliases
get different shadow page (if necessary) is the responsiblity of each individual
feature that leverages stolen gfn bits.
