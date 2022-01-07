Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85970487E63
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 22:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiAGVjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 16:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiAGVjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 16:39:19 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A390C061574
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 13:39:19 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id g2so6510205pgo.9
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 13:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y5FuFyQxIv14ab8oAzdBUKknfbLIngFGkHJLyCf1g44=;
        b=UWcMFda8BsM3DpUrpqttjCKn9iOrq2mf6K5RKBqpdo3pw6QTuAcB8D6petfGIy6Wvq
         xDjVq0qyoSfpK8h4yTyPZFgZWQFdeIOBiOCURLT5FrQZ13bscf/8gMi0B9Hk4aPBxzDn
         QlvqljXrxC3xjrc7DHD6Y4rB7FleHjiDB93HaRRKMM2R06tV0z8qHO2Js+n+kap6aJ59
         lfu4+7HLk0Vf/X4En4J3WKOUeWC2rk8kRqXurVLoui3+2HxlphE4AKCMTBg2btH6BJgc
         RtZ61Ry4te4pwvT78RoolRGLJSwy46oxhAxUyJBpkLjIApTtzoxTbKSckTYDy9M+NUfM
         +U7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y5FuFyQxIv14ab8oAzdBUKknfbLIngFGkHJLyCf1g44=;
        b=k0iqU552bxgiEbiaxPxecCQo8FKcXzUMSvZSY3kyqjCwH8JT1FkbLQd3Ux0LGF3NQd
         lf86SfaiomcH6JYEkFbF2wmVB1mw6mY5xl45FNfQo1LNuBr7H6JO16Grphr1UwlpK9Vq
         VQcQQi0yhBydocs0bMALJJ8PI3Y+9Axlchlb6Xm/lsh7c+7C2Yim32cLFoTdHs4V0xUA
         B5y1UJZSfiWU8L5njMsCOs9LbL/Vdj7yZOj6qMDKCFefwIIh3ilgev/i5ZUe964kv7S1
         aexY0/3CIuHu1Bhlpxad/0sy9Jm1an+JCkwwXT5c2/QeFyRQISzdXIn4nr9K5+SgpfBA
         6hyA==
X-Gm-Message-State: AOAM5323cxoBVWcw+IPtjUzs5BaFE5WkRG5Etyj53Oc7+9V78m9SjMJb
        tVXSi+YQV7/np/NUEvOZve9rUQ==
X-Google-Smtp-Source: ABdhPJzxBdAnLF2k267NahMyIcIWSrMGdPK1aUtpbvmW0KlfcrmL6wKET7AWnlJooK2ztRiBureEVw==
X-Received: by 2002:aa7:8b0b:0:b0:4bc:d5eb:93c6 with SMTP id f11-20020aa78b0b000000b004bcd5eb93c6mr16076060pfd.71.1641591558337;
        Fri, 07 Jan 2022 13:39:18 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nl16sm10881418pjb.22.2022.01.07.13.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 13:39:17 -0800 (PST)
Date:   Fri, 7 Jan 2022 21:39:14 +0000
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
Subject: Re: [PATCH v1 04/13] KVM: x86/mmu: Factor out logic to atomically
 install a new page table
Message-ID: <YdizAr8WhfqlsAz3@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-5-dmatlack@google.com>
 <YddNIMWaARotqOSZ@google.com>
 <CALzav=cW9jB49gdKa6xYVy-7Jh1PK8NLChwPMNwK_bK-55a=3w@mail.gmail.com>
 <CALzav=coNhq-+Q1c3+H5xyFMYVLNgE=w=hgSWFeUQyNANOLxFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=coNhq-+Q1c3+H5xyFMYVLNgE=w=hgSWFeUQyNANOLxFQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 07, 2022, David Matlack wrote:
> While I'm here how do you feel about renaming alloc_tdp_mmu_page() to
> tdp_mmu_alloc_sp()? First to increase consistency that "tdp_mmu" is a
> prefix before the verb, and to clarify that we are allocating a shadow
> page.

I like that idea.

Ben, any objections to the suggested renames?  I know it's a bit weird calling TDP
pages "shadow" pages, but having consistent and unique terminology is very helpful
for discussions.
