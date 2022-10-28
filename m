Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FD5610DF9
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 11:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiJ1J6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 05:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiJ1J5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 05:57:52 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9C9895D4
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 02:57:09 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id f7so1443059edc.6
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 02:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mvHL5Drr+3t1aS/5ADf3q7iM5WIuHk2AYt4Ze0ZBgjk=;
        b=XzOlmJP/jS7VT1xg6wG+42FDDXw981TfzCCruFtGWZepNQEEDI1xBoIQxendEL6nVw
         gV++vJ7t7L7EWZHnXPGmx0WFIw3SkrgmFHy7yiCJmdCaMetbBp4gmGb8H0OpwnEhz4uA
         NXR0EIjkLtokHm+btvWViZasIH8uRkLuXGJU84pBFCN9ZAMKWmzhw1vgpkv0EaZCYXGC
         lRB/IpHGfMApklvbsCU3KW8TkXSHNoNTekYSvt6CgCgcciE56e87YjFKyn9JXOirreG8
         e5BSpaR4vnFx+66Pxz1mIral+3sROyLK+wRy96aO3CnMOlMYCH/XbevP2WLneL9Q/7Yd
         BWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mvHL5Drr+3t1aS/5ADf3q7iM5WIuHk2AYt4Ze0ZBgjk=;
        b=D7QEvGxuKTuzmhiJhSwi5VlLb7qKdnkEQBXC/o/huYZA/1HsZ7MdirmPQ1dH04qocw
         A/e+ur1dp4NIfIrWElaEQJr73+8i7tPHgXwxV+bgexQin8zvIfgR0qYPqW7sX+ptP+s/
         77Fa7Se9DrWHCSL6HZXkG7K27PmsWTQBFlb3TkhjMlI0RxN4pnT3SvbX3TC7RB0Y0usL
         xzoU7zcHSCw5qSJ27jhpRujYeM0HWFA05ks762SecsbuyPZzcO5IHAYNZoF/hNxDufUG
         OUv++u11f1mLqiJNSTzmFoBLkU3TyAitfVVpvbZaG4CxHP0gZkqiQeWrT8sZNgRKskBB
         5Sng==
X-Gm-Message-State: ACrzQf0Ny8xCUvYpBMtrteiCjqGOVXgoNlSDGFP/XLPjvG9M2BRIxzNK
        JJliYHmA72qsLTlDfaMWkqaoZA==
X-Google-Smtp-Source: AMsMyM5zJVsp3vp9yM+1qZ9xU/7wt91EQOkPXZmY19wmU4+a4o6tvJjAEaJRmC8JNHIxmOjkkdPfsw==
X-Received: by 2002:a50:ff09:0:b0:456:fd61:83b3 with SMTP id a9-20020a50ff09000000b00456fd6183b3mr48978165edu.166.1666951028189;
        Fri, 28 Oct 2022 02:57:08 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id x1-20020a05640226c100b00443d657d8a4sm2435255edd.61.2022.10.28.02.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 02:57:07 -0700 (PDT)
Date:   Fri, 28 Oct 2022 09:57:04 +0000
From:   Quentin Perret <qperret@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Redefine pKVM memory transitions in
 terms of source/target
Message-ID: <Y1uncNq2oyc5wALG@google.com>
References: <20221028083448.1998389-1-oliver.upton@linux.dev>
 <20221028083448.1998389-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028083448.1998389-3-oliver.upton@linux.dev>
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

Hey Oliver,

On Friday 28 Oct 2022 at 08:34:48 (+0000), Oliver Upton wrote:
> Perhaps it is just me, but the 'initiator' and 'completer' terms are
> slightly confusing descriptors for the addresses involved in a memory
> transition. Apply a rename to instead describe memory transitions in
> terms of a source and target address.

Just to provide some rationale for the initiator/completer terminology,
the very first implementation we did of this used 'sender/recipient (or
something along those lines I think), and we ended up confusing
ourselves massively. The main issue is that memory doesn't necessarily
'flow' in the same direction as the transition. It's all fine for a
donation or a share, but reclaim and unshare become funny. 'The
recipient of an unshare' can be easily misunderstood, I think.

So yeah, we ended up with initiator/completer, which may not be the
prettiest terminology, but it was useful to disambiguate things at
least.

Thanks for the review!
Quentin
