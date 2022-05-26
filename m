Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FDA53519C
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 17:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348014AbiEZPoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 11:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242969AbiEZPoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 11:44:19 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B15D808E
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:44:19 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id b135so1972977pfb.12
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FjwbNPlaX7Gyu37oT3WUuGl7t7EIl/tWer4JTW1xkmY=;
        b=TxLR0140fr8cr3Rhcx0XVtopJlCMmPcZZO0seYbfjPCu/UuicZOP2o10OUoZVf+Yvx
         x2CW0Xzdiyx4LaM7oYO0HunymxwuE3Q+Dp9YKRLb/TCaplMdSlaQZXESwj3JQ5EwnQXm
         j2VwTxoy+K3sXUVIH9FjN8HhtdaeAOymgXNunK/FK+7ujjkr9QeNb+t/1zBDnzwiqiAg
         D+5ssb0XObhZmFCAEG5JYK2MB1CHs2u4KY49i6FwdGyMv3BOZxwVBmGR1FscH1AanpQj
         dGfb/3u58anHDRPaxhegp2/rLpqOHwdMgwOpBZlNlkElmGDlEr1iTC2eJ2lVSKn4MXt3
         NpSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FjwbNPlaX7Gyu37oT3WUuGl7t7EIl/tWer4JTW1xkmY=;
        b=cwnCfEjx3gFPQagPCQt8+X08DIoZqZIOzdZJ9nZFKZiQGJwHIET66Ze1DHI7L2WDRE
         PQIH3qjArljOvknhc4wEMTgm14Ldgzz9dVFCQB/wwY17BIK0PIltJXOvgNh95DQJARvW
         2uN5EYmUcRUJAD6IkL7BolVUiG/E4NAq8BEGzH3Soy4nt5vpnkUxw1ef+4J8g/mI9MwD
         5dVdfmJyGGaUpFsnn2Kl/IF6aJ0qDIo9hA0Zu6RUrOeexur+GbupySUJIPEfTiT4CZpv
         4lONtJWDkRehazfOZBEC0wpO6I0uANP1nNMECrMVkwC96qyk67whoozbH2bQx4pKP88s
         PGMw==
X-Gm-Message-State: AOAM531S+9yZDCqGbcAq7JdIcVyoVlcvUixQMn2+ExSI4/xG273RE903
        fXasJH7LbPmFFADXFDEfVCeebA==
X-Google-Smtp-Source: ABdhPJzTxz5kWhe+KvcHd/i8kumDC6CHY7eXMFydg2j4e0sOISTlnFFftwwwQVkq2mrYZ1mu9wlVpw==
X-Received: by 2002:a05:6a00:14d4:b0:518:b918:fae4 with SMTP id w20-20020a056a0014d400b00518b918fae4mr17067267pfu.55.1653579858174;
        Thu, 26 May 2022 08:44:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902eb8c00b0015e8d4eb1d7sm1680678plg.33.2022.05.26.08.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 08:44:17 -0700 (PDT)
Date:   Thu, 26 May 2022 15:44:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Shivam Kumar <shivam.kumar1@nutanix.com>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v4 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <Yo+gTbo5uqqAMjjX@google.com>
References: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
 <20220521202937.184189-2-shivam.kumar1@nutanix.com>
 <87h75fmmkj.wl-maz@kernel.org>
 <bf24e007-23fd-2582-ec0c-5e79ab0c7d56@nutanix.com>
 <878rqomnfr.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rqomnfr.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022, Marc Zyngier wrote:
> > >> +{
> > >> +	struct kvm_run *run = vcpu->run;
> > >> +	u64 dirty_quota = READ_ONCE(run->dirty_quota);
> > >> +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
> > >> +
> > >> +	if (!dirty_quota || (pages_dirtied < dirty_quota))
> > >> +		return 1;
> > > What happens when page_dirtied becomes large and dirty_quota has to
> > > wrap to allow further progress?
> > Every time the quota is exhausted, userspace is expected to set it to
> > pages_dirtied + new quota. So, pages_dirtied will always follow dirty
> > quota. I'll be sending the qemu patches soon. Thanks.
> 
> Right, so let's assume that page_dirtied=0xffffffffffffffff (yes, I
> have dirtied that many pages).

Really?  Written that many bytes from a guest?  Maybe.  But actually marked that
many pages dirty in hardware, let alone in KVM?  And on a single CPU?

By my back of the napkin math, a 4096 CPU system running at 16ghz with each CPU
able to access one page of memory per cycle would take ~3 days to access 2^64
pages.

Assuming a ridiculously optimistic ~20 cycles to walk page tables, fetch the cache
line from memory, insert into the TLB, and mark the PTE dirty, that's still ~60
days to actually dirty that many pages in hardware.

Let's again be comically optimistic and assume KVM can somehow propagate a dirty
bit from hardware PTEs to the dirty bitmap/ring in another ~20 cycles.  That brings
us to ~1200 days.

But the stat is per vCPU, so that actually means it would take ~13.8k years for a
single vCPU/CPU to dirty 2^64 pages... running at a ludicrous 16ghz on a CPU with
latencies that are a likely an order of magnitude faster than anything that exists
today.
