Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924CA486D68
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 23:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245283AbiAFW40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 17:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245250AbiAFW4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 17:56:25 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD690C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 14:56:25 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id rj2-20020a17090b3e8200b001b1944bad25so4674137pjb.5
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 14:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TCmq/XKyHjyU2L7hMwUHNdbHSxdZEg7GeFtr3bvkbLY=;
        b=JAJjX55AmGhT0YcJXD438qmjs/28U4CiYcfN6JSxe9LXn9Ebq/0u6ZNnRLZ3WP1s9S
         pypG40yjAuq5jHkB9/X3C4zF/AA0yGOQS88IPqmK6JnWlL6k7Q38+mrTb0bZylpXnzQ1
         HqZr9ACTIT6VEF3tD3ackOAIVQKFvfA3f4FM0R+vOHMEd+IwxdEVeSShK1NvsWDHKs0c
         WmjVJSIboJCJehAVjndtvtmpVTeglgShMydPoJOxEbbfti38clgefJ4NdHSl1mRhPXbX
         NJ0RizfEEooqE0zkO2ivV/fMfiTUoujCWFDvgFrMhhr8Ul4cUqMYLwdHE96OcshArqLR
         5VnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TCmq/XKyHjyU2L7hMwUHNdbHSxdZEg7GeFtr3bvkbLY=;
        b=JSg0/2fi7fvfp23uO1Nj2aeHoUDGKXmVxZR8TTMKTeSk2Nlpg+OpvenO+NMji8Mqiq
         OV91HHqlI/+JdYTWmzMp0SdJFaCQPTBgJ6O3o7+tXoEnde0LFB+QgdVjg0mw6QSjFNXL
         4JjnybMdA6D5yBgyUIVbzLRNwRyohnn313RsN+O7Ab2/e8WRLtdQpAYqQCx3z12gbq4P
         hIJ1nhRhzlbQTjSKRscabZ1LawGZdzVN/q5BCVq4r2n1/hmk9gDJJJS+v/BpeQKd+WUq
         HQtqytp/2JraOgk4Lien/MwLGqfGhp6QimeBtOjUBcHCJ9/3paghIM2EDWzrBhXaOur0
         jIoA==
X-Gm-Message-State: AOAM531Pa0KcWJhJOuVRxSXZlxuQl74Lvu0+iOstGJMLErl1+HeRARLo
        HVEPbVBIsNuz+f1N7t2z2oNbeA==
X-Google-Smtp-Source: ABdhPJyE2f6ZxtkmtjvkYj8InZ4zkex1g+t7XEA1MnnL/d39bAql28C2FqkQtCBYokPNhaRR8awhsg==
X-Received: by 2002:a17:90b:3a92:: with SMTP id om18mr12356634pjb.159.1641509784951;
        Thu, 06 Jan 2022 14:56:24 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s34sm3703409pfg.198.2022.01.06.14.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 14:56:24 -0800 (PST)
Date:   Thu, 6 Jan 2022 22:56:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 09/13] KVM: x86/mmu: Split huge pages when dirty
 logging is enabled
Message-ID: <Yddzlcz0uTMVoBV1@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-10-dmatlack@google.com>
 <Ydde9VE9vD/qo/wN@google.com>
 <CALzav=eOzX68FMjRDKAfu6N8Zp_WVkAF_OtJ99Dmb3V_kH2rWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=eOzX68FMjRDKAfu6N8Zp_WVkAF_OtJ99Dmb3V_kH2rWw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022, David Matlack wrote:
> > Nit, to be consistent with the kernel, s/huge page/hugepage.
> 
> The kernel seems pretty split on which to use actually:
> 
> $ git grep --extended "huge[ _]page" | wc -l
> 1663
> $ git grep --extended "hugepage" | wc -l
> 1558
> 
> The former has a slight edge so I went with that throughout the series.

Ha, and KVM leans even more heavily huge_page.  huge_page it is.

> > > +
> > > +static bool
> >
> > Please put the return type and attributes on the same line as the function name,
> > splitting them makes grep sad.
> 
> Sure will do. Out of curiosity, what sort of workflow expects to be
> able to grep the return type, attributes, and function name on the
> same line?

Start here[*], there are several good examples further down that thread.

[*] https://lore.kernel.org/all/CAHk-=wjS-Jg7sGMwUPpDsjv392nDOOs0CtUtVkp=S6Q7JzFJRw@mail.gmail.com
