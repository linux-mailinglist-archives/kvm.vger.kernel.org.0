Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA6232CECE
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 09:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236814AbhCDIwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 03:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbhCDIv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 03:51:59 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29EAC061756;
        Thu,  4 Mar 2021 00:51:18 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id h7so6242846qvm.2;
        Thu, 04 Mar 2021 00:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I4gktfqxylGB3DlwpHUJlo46LXTYxo6+TuJCmtDgwqg=;
        b=WYjdeOOvSLFpvDoGjRRqZlAOwzlmZdzsKW62eY2+C+MatfU5IHlRHugMRRHognkKJa
         7I/NGS3uGqF63bl8cu+Sd8jPUj2wa8lNZWhg6s7FdnFPLRsxr7AK4HzzeD65KBmPz6wN
         VQcjeJJbBgX5qiMV1/Cq6/FQCVXVPWIa+tMGhn9gGdfcb2+PL56qDI1QfMLy9cayAD8R
         QXnYX4JEzS6BN9ANqF2JSjPoHHX1U+rqiF5qO+KIN6ax+4qAeRnkp97wMpAOHuQIRs5o
         Kj46nYkNjqGS+ndlohRvyB8MUQ4HYU2dQPbGtA8rAwwGGcZ43FjhtD3OMnmovFe3Uaft
         0aqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=I4gktfqxylGB3DlwpHUJlo46LXTYxo6+TuJCmtDgwqg=;
        b=SCssvo3JnDfv2x8MNnb1/0o+1zLiG2oje8dRx4H1mu3yQalM9G/sMrsYMNayyjE51W
         sCSb5goftX0iIsrtcfVzhxMcUL7ngF4pW+yzTuM0fwH/mCb1GoG9fcn5O5yIxghzliR0
         0YezW/4DwQkIjzDV7SUCH0gAvwfkrleLMaEbwynXHPgQHbyo2S+3igidli5SB8zei8yZ
         whfSFSkj1i8EIiIOlYd+3Iend4J7BapyEn5YMveSeBeihBljxq4uqKPNBQSrP5nTOgOx
         0R1eP+vMPA+0IWVAAKadCbWMh8Op6LcgJf82lSkL0rLgwsJwXITO1TLJkPt1YKHopkYM
         f4IA==
X-Gm-Message-State: AOAM5310QWmMUK2qvXWN5TcTp/zSFJlNBoihJskbq3tpgY0GIh1CBB42
        3VNl1VlyHSY8VuhWLBkBqyc=
X-Google-Smtp-Source: ABdhPJzBUoqqJVrNBlQvGGRR49f0+8IuJLMipV5zoSogL0KIUeUBdiMnYRbldFvy1u4CXAnQ7dzQOw==
X-Received: by 2002:ad4:53ac:: with SMTP id j12mr2877734qvv.3.1614847877771;
        Thu, 04 Mar 2021 00:51:17 -0800 (PST)
Received: from localhost (2603-7000-9602-8233-06d4-c4ff-fe48-9d05.res6.spectrum.com. [2603:7000:9602:8233:6d4:c4ff:fe48:9d05])
        by smtp.gmail.com with ESMTPSA id m16sm1347504qkm.100.2021.03.04.00.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 00:51:17 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 4 Mar 2021 03:51:16 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Jacob Pan <jacob.jun.pan@intel.com>, mkoutny@suse.com,
        rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Message-ID: <YECfhCJtHUL9cB2L@slm.duckdns.org>
References: <20210302081705.1990283-1-vipinsh@google.com>
 <20210302081705.1990283-3-vipinsh@google.com>
 <20210303185513.27e18fce@jacob-builder>
 <YEB8i6Chq4K/GGF6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEB8i6Chq4K/GGF6@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Wed, Mar 03, 2021 at 10:22:03PM -0800, Vipin Sharma wrote:
> > I am trying to see if IOASIDs cgroup can also fit in this misc controller
> > as yet another resource type.
> > https://lore.kernel.org/linux-iommu/20210303131726.7a8cb169@jacob-builder/T/#u
> > However, unlike sev IOASIDs need to be migrated if the process is moved to
> > another cgroup. i.e. charge the destination and uncharge the source.
> > 
> > Do you think this behavior can be achieved by differentiating resource
> > types? i.e. add attach callbacks for certain types. Having a single misc
> > interface seems cleaner than creating another controller.
> 
> I think it makes sense to add support for migration for the resources
> which need it. Resources like SEV, SEV-ES will not participate in
> migration and won't stop can_attach() to succeed, other resources which
> need migration will allow or stop based on their limits and capacity in
> the destination.

Please note that cgroup2 by and large don't really like or support charge
migration or even migrations themselves. We tried that w/ memcg on cgroup1
and it turned out horrible. The expected usage model as decribed in the doc
is using migration to seed a cgroup (or even better, use the new clone call
to start in the target cgroup) and then stay there until exit. All existing
controllers assume this usage model and I'm likely to nack deviation unless
there are some super strong justifications.

Thanks.

-- 
tejun
