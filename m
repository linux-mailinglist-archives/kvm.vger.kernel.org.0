Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D6252938E
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 00:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348670AbiEPW03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 18:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349712AbiEPW0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 18:26:24 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200176361
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:26:23 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id t25so19802525ljd.6
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 15:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FV6an1DR8owtvHnv3AhkUWCDZYEmKCy0OBJ7ZaxmSHM=;
        b=AWiVsV4iL/68MJADWUEUdrczDiwSaXlwfUdVy7kl/+nPfuu7IXT2GsvziRMgrWY5sD
         IS2Z4spjwucapTTvZEcnfdnJzrmAAjB2CDXi7jTV3DTPu4mXz9Z2UJ6gELWX+0s8xGF9
         RXSCyBoUuy6qdmfhZfC4/Q3vqpeen6fzHMpNp2XM/MCphncHFzb1xM30cBauEFbemq1b
         8YdEbMEOjw7EALrUH9WHksNrX9B5eKLdfc2hdm0DmQ3xXsbcj2BcqwYQSRbc787lHFsN
         IrhkkaEpD42yDdLb5NiT/Q6857q6q51pZBP43HgjRgH6UTIukTg7HDc25qWwO9fxowhQ
         YMHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FV6an1DR8owtvHnv3AhkUWCDZYEmKCy0OBJ7ZaxmSHM=;
        b=ZNWTgondLUWPAxMBOYMXdtb7Yw6gBkrvswjU2uEFFiiCQIXIrs0wH+nlUo8+QI727v
         o38i69ew3zCJae6rYDCqQl/4zPYDD3VqEOdhfN40LvIvWBwvtC8cN0adTwkkhJNCHA5J
         T4Nge9+IFIxmMwGNuj7a1LWZ/vPi/bXd9H7sqGrpmXC/06ftbVou/EEPkg8uWVqrDfCP
         75fktszk2AFsbjWeRWKLK+6hoYcocZ9heLiujMRg3Mh95Rj58MAZ8WCAKfYyIj//FtnI
         ZnfnlgowTAPAN2uXgJVZX5oIJzr5sFB/qsmOx6hd0xxKAgVPZsDoZwgBmtrn0G2lNlHV
         fm6A==
X-Gm-Message-State: AOAM530dsVjuRJTo/gd6X0/AZtXtY7wSaRD1OQAwrqV9p4MJh8qDf1GN
        4hXyl5QuwsSFG7VmGJxvuQdBV5veIijGtbjtSEoSyTF82pQ=
X-Google-Smtp-Source: ABdhPJye8eA5rVzLGV1KatRqH4PwvGiuMzc63uPjUaW9asslLapEyOMxZd/m8RRpjOIrCK5ZFeBzEi9q6rtiWgz2GvM=
X-Received: by 2002:a2e:818b:0:b0:253:b8db:26e6 with SMTP id
 e11-20020a2e818b000000b00253b8db26e6mr20253ljg.170.1652739981243; Mon, 16 May
 2022 15:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220415201542.1496582-1-oupton@google.com> <20220415201542.1496582-3-oupton@google.com>
 <YoK7jfvi1RB/w1B5@google.com>
In-Reply-To: <YoK7jfvi1RB/w1B5@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 16 May 2022 15:26:10 -0700
Message-ID: <CAOQ_Qsif=0CZV0dPXqJ9+r36Tuj4jgV-XrvOt7p0W3nVQWAHdQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] KVM: Shove vcpu stats_id init into kvm_vcpu_create_debugfs()
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022 at 2:01 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 15, 2022, Oliver Upton wrote:
> > Again, the stats_id is only ever used by the stats code; put it where it
> > belongs with the rest of the stats initialization.
>
> Heh, again, no?  Ah, but here you've conflated debugfs and stats in the changelog.
> They are two different things.  And most critically, stats is not dependent on debugfs.

Agreed. Patch 1 and 2 arise from being bitter that struct kvm and
struct kvm_vcpu fields are initialized out of line with other fields.
I'll yank these into kvm_create_vm() and kvm_vcpu_init(),
respectively.

--
Thanks,
Oliver
