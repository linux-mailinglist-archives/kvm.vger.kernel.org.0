Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0D140B2FE
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 17:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbhINP1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 11:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbhINP1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 11:27:47 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C017AC061762
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 08:26:24 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y8so7202498pfa.7
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 08:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N7ykuFrZgQNrrQ2Zlhx5pG6g+CHOtU1cJGoIFqwfvqU=;
        b=XPLge0u+LIdLxAg6W9OajtpRKOHwPg7NImAAwLgOkHLlOB4pzG81/2uI/5+TBdkzK0
         SjWs9VLQfLHDujNI+QUUcELIYERuGqUONenOqbTTlq06ysbL3lKwInjCMSq1MEd7nWIP
         1XX4OTiDk4NZPxpkSEx6cl7JJ/Z5Dl9XcAVlec9vn1F8Zy4Ntrfk7hm5H9ihrZNMuxRU
         gw5CZ5Zzy1qdWztusbd48QGxsKRf5gqkDEVLwvrV/64N5m8qz+POFJWKsmgkQo1LuI9t
         55CbRsskYOwwzxQFbsjYdRTo59Ck4QMihNmKWnYPgCchsft87zGSIT+R4ZoJewobg6sK
         qVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N7ykuFrZgQNrrQ2Zlhx5pG6g+CHOtU1cJGoIFqwfvqU=;
        b=GthMoLKNiF70rrv3JHCLoSSdwU1Gqg1/AEIT8/7uqnECJUDn9oZldGRloipzviI/eC
         rYmreVFQegjyDr7Etxnmgzbr01ZXBdW7COhSgilT74iwTcubAUzW44XFRZ9MsR1KitJc
         uVzB21S9HDnHvL1ZPd2Ar3yd7u83l1PoufQfDyPDVhKSEvIydyU1mjmqRnaBaqMUyRMA
         kiPqcaJIYLuBwPWxRCazmOk0bKb1mg2+1ozCJPTk+tkSD5JuhiffuuwBJ5LLY710yZ/D
         B9qE1zlQ+gcYsK0twbw2ci4y1p1EXpiVv9va1EIAo/K9rMmos4iibJ3wgvVaN1AiLte8
         C/nw==
X-Gm-Message-State: AOAM531HDTml9uJsyFruweJga+rG/yghyXOhnrI0Ey4nTraGa7SRgG4G
        Gk4q3NukQQ352a0CRSm6vpsTNQ==
X-Google-Smtp-Source: ABdhPJw1SHGjvAYnjmvm6bYe5xG2pNY28wJqBOTLgNEVctGBB21oROpxDsdEjZcvt8UkYkGczQH2og==
X-Received: by 2002:aa7:8e56:0:b029:3cd:c2ec:6c1c with SMTP id d22-20020aa78e560000b02903cdc2ec6c1cmr5399378pfr.80.1631633183972;
        Tue, 14 Sep 2021 08:26:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v7sm2005297pjg.34.2021.09.14.08.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 08:26:23 -0700 (PDT)
Date:   Tue, 14 Sep 2021 15:26:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, John Allen <john.allen@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH] KVM: SVM: fix missing sev_decommission in
 sev_receive_start
Message-ID: <YUC/GzN29dWDVCda@google.com>
References: <20210912181815.3899316-1-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210912181815.3899316-1-mizhang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 12, 2021, Mingwei Zhang wrote:
> sev_decommission

It's not a ubiquitous "requirement", but adding parantheses after function names
in changelogs is generally preferred as it succinctly identifies a function call.

> is needed in the error path of sev_bind_asid. The purpose

"error path of sev_bind_asid()" could be interpreted as meaning DECOMMISSION is
needed within sev_bind_asid(), whereas you mean when sev_bind_asid() fails.  One
way to avoid confusion, and a good habit in general, is to avoid talking in
terms of code details when possible.  There are certainly cases where talking
about the code itself is absolutely necessary, but this could be worded as:

  DECOMMISSION the current SEV context if binding an ASID fails after
  RECEIVE_START.  Per AMD's SEV API, RECEIVE_START generates a new guest
  context and thus needs to be paired with DECOMMISSION:

     The RECEIVE_START command is the only command other than the LAUNCH_START
     command that generates a new guest context and guest handle.

  The missing DECOMMISSION can result in subsequent SEV launch failures due to
  <fill in this part>.

  Note, LAUNCH_START suffered the same bug, but was previously fixed by
  934002cd660b ("KVM: SVM: Call SEV Guest Decommission if ASID binding fails").

> of this function is to clear the firmware context. Missing this step may

Kind of a nit: "this function" is ambiguous.  I'm pretty sure you're referring
to sev_decommission(), but it's trivially easy to be 100% unambiguous (see above).

> cause subsequent SEV launch failures.
>
> Although missing sev_decommission issue has previously been found and was
> fixed in sev_launch_start function. It is supposed to be fixed on all
> scenarios where a firmware context needs to be freed.

More nits: provide the commit ID of the previous fix so that folks don't have
to hunt it down (even though it's an easy git blame away).  And this is better
as a footnote of sorts as it's not relevant to the justification of the patch in
the sense that it's best to avoid "we do x there, so we should do x here".  That
might be a true statement, as is the case here, but the patch still needs to be
justified without that type of reasoning.

> According to the AMD SEV API v0.24 Section 1.3.3:
>
> "The RECEIVE_START command is the only command other than the LAUNCH_START
> command that generates a new guest context and guest handle."
>
> The above indicates that RECEIVE_START command also requires calling
> sev_decommission if ASID binding fails after RECEIVE_START succeeds.
>
> So add the sev_decommission function in sev_receive_start.

And more nits :-)  As alluded to above the, last few sentences are somewhat
redundant and can be dropped and/or worded into the statement about what the
patch is doing.

> Cc: Alper Gun <alpergun@google.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: David Rienjes <rientjes@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Vipin Sharma <vipinsh@google.com>
> 
> Reviewed-by: Marc Orr <marcorr@google.com>
> Acked-by: Brijesh Singh <brijesh.singh@amd.com>
> Fixes: af43cbbf954b ("KVM: SVM: Add support for KVM_SEV_RECEIVE_START command")

Cc: stable@vger.kernel.org

> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---

With a cleaned up changelog,

Reviewed-by: Sean Christopherson <seanjc@google.com>
