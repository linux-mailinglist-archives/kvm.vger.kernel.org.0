Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6D0644AE3
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 19:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiLFSKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 13:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLFSKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 13:10:38 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECE13B9E3
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 10:10:36 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id k7so14713255pll.6
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 10:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gAdL/5nVVJu1FQlGTdfBjUls0ERNiH40RtP9DKw3LIs=;
        b=l9AGT4fXhM1oH7Du6wFnaTWjSCn3ASy0EdsFYwoxpz1XTmSJrI/6IYPrztRWGtgphI
         MEU1JwB6naZw7c/1ettMldjjpLk7glwpCWqV3EXpRuhUI+cM9iyuVCU+X8uFtQpMw16H
         y+VgP6Yz+mAMFxaAy3HgfBPOTFYdo5y/iogmk26sWTFOPpJyLaBDhg94MEROnHf5IE94
         nWYww6CfABnUnL1AnWY2Cgwf8IRzYPXH3CPErKTJKwYOxZqve3srRPJGRu+YDWCJOMyj
         ciVWMbA+0QFhqsdHTxv5x8llaaAKjhSyqtXi87fJCtsbFm+lXv45WSeSP6LhgyyqgED4
         rVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gAdL/5nVVJu1FQlGTdfBjUls0ERNiH40RtP9DKw3LIs=;
        b=v/At562JCTuLW2hwGL1yRPgsnt9/Hxj4cjup4aF9o+As55P6PMFwpr/8rDUMJfhvH3
         bzD/z035OlTYH5yt6OalSi6K/BWoXbBivGpmJc77J3gUpqicU9YjoUSwXUU1kG3qpiRQ
         Lgp1F8NFATwZAoke7PO87XZwo74fa968WsAglekf2G3XDfWX+jGQ4P1o44o125n4jGB1
         6ggPcIm0Q9zev/7grGg+/myDNk+1yOdCf45lBfZVDI54sGxieuVuYXPoIHCwS7Y6R8sJ
         qxsnmZX/2TuqIECDKFCffadj9p0fWYkrE5WGwBKZhfsIjZcKPmNML2iSubZsP9MDkrYm
         aBww==
X-Gm-Message-State: ANoB5pmC+JBBBerLEuSaFrg8ohC0IjT/i3IFLJ1njlRkQqhUus+UoxPw
        t58OflLp/Qb36LlMgOympND3HA==
X-Google-Smtp-Source: AA0mqf5SWGEOLKnaGxze9XgAsm4nFZyJ++7ROo35teN3Ikc66p+MXKu2i9uybgiJng0VsXfgkbFF9Q==
X-Received: by 2002:a17:90a:c68d:b0:219:d415:d787 with SMTP id n13-20020a17090ac68d00b00219d415d787mr11690151pjt.127.1670350236316;
        Tue, 06 Dec 2022 10:10:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902ec8e00b001897916be2bsm12957433plg.268.2022.12.06.10.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 10:10:35 -0800 (PST)
Date:   Tue, 6 Dec 2022 18:10:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Ben Gardon <bgardon@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Fuad Tabba <tabba@google.com>, Gavin Shan <gshan@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morse <james.morse@arm.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Peter Collingbourne <pcc@google.com>,
        Peter Xu <peterx@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Steven Price <steven.price@arm.com>,
        Usama Arif <usama.arif@bytedance.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Will Deacon <will@kernel.org>,
        Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
Message-ID: <Y4+FmDM7E5WYP3zV@google.com>
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022, Paolo Bonzini wrote:
> On 12/5/22 16:58, Marc Zyngier wrote:
> > - There is a lot of selftest conflicts with your own branch, see:
> > 
> >    https://lore.kernel.org/r/20221201112432.4cb9ae42@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201113626.438f13c5@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201115741.7de32422@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201120939.3c19f004@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201131623.18ebc8d8@canb.auug.org.au
> > 
> >    for a rather exhaustive collection.
> 
> Yeah, I saw them in Stephen's messages but missed your reply.
> 
> In retrospect, at least Gavin's series for memslot_perf_test should have
> been applied by both of us with a topic branch, but there's so many
> conflicts all over the place that it's hard to single out one series.
> It just happens.

Alternatively, we could have a dedicated selftests/kvm tree (or branch)?

I almost suggested doing that on multiple occasions this cycle, but ultimately
decided not to because it would effectively mean splitting series that touch KVM
and selftests into different trees, which would create a different kind of
dependency hell.  Or maybe a hybrid approach where series that only (or mostly?)
touch selftests go into a dedicated tree?

I get the feeling that I'm overthinking things though, this level of activity and
conflicts should be relatively rare.
