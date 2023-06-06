Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DE1724A1B
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 19:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238712AbjFFRWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 13:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238731AbjFFRWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 13:22:20 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1171705
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 10:22:16 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f06f7cc74so3455748a12.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 10:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686072136; x=1688664136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mRpAkL7dAZj37Xfm4jemHK02mHerX93Wk1k4AInL4jM=;
        b=RwZkWCk7kdV86E5yWrMaMCVoVT+BSkAzKG8Bsg+fP3JPmhNI5gLndL89s48ZjrZAC1
         fkRkYJJrH3GKGrEL0Tt4MRw+H64kU1/aDvwlIKwPN4cnpcYgQnKOlIrpBaKYLe5SwRWl
         OBVGplsQUh9tGhp/Pp6fXpiu4GCnI5+k7Q1EebsGUYjf+ETDgUSttBTnIOkabhuALJWg
         9kvN/hy8ZGB5XhuMRtnZ31dEPSX7s/hKySTXEsZJN5voqCDBEX5Zv/MZsTF/Xs6bMVTH
         dh3wfvnO2ClN5qH14Wd9oBGxvoWES7Nl5HvJLHT7znyUFYyUtsaKwne687J45rLlOgZt
         fXAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686072136; x=1688664136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mRpAkL7dAZj37Xfm4jemHK02mHerX93Wk1k4AInL4jM=;
        b=BZMh6pYOrz0x3P5bXPg/X1JzDzT1hkQgzbegQUa7S92LM/DdjhKXYjwfZoA4Pem7zX
         kbDfdP75HRpl7x1s9UQ3HgONCRvZLx8gygsNLHAVjind2pY6Yu34x4dLKJv3O90f459I
         +J4/Mt/Y24RSFalPunCrNWhuez6iAWvQs0JLHjJtEWRmKbOodN9LLm4tAWwlBoNE24O6
         FErYEs4NBT96eGmgvXgl/SgxSYCRWx9Rc4J+7YAV3ZxyufwCTzPGFNLNtRfK7TichBoC
         DEj3E3Vg9/lJcRettShWTTK/rAO9N95/UI5SiMKuCyOPJnxA4gxvgqE1hvCQRqNptj3p
         vFyw==
X-Gm-Message-State: AC+VfDxX9Ae7VotCtTKG+uUCaNXsXpF7jucKpaumVBw230KZ+FfsSaEX
        dYRII2YqomlHSbt49HaEPbs4PnktaQg=
X-Google-Smtp-Source: ACHHUZ5CdTWpaz9pAirrwFFOkiNuHjSMrxxHITHdSJZQnqUWOhi1md3VO+FsZQFTjgBjAEQXf6cw2hKbbqw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:5848:0:b0:53f:b200:6b57 with SMTP id
 s8-20020a655848000000b0053fb2006b57mr903490pgr.3.1686072135778; Tue, 06 Jun
 2023 10:22:15 -0700 (PDT)
Date:   Tue, 6 Jun 2023 10:22:14 -0700
In-Reply-To: <87wn0hnxh7.fsf@nvidia.com>
Mime-Version: 1.0
References: <20230602011518.787006-1-seanjc@google.com> <20230602011518.787006-2-seanjc@google.com>
 <87wn0hnxh7.fsf@nvidia.com>
Message-ID: <ZH9rRnU8h+gDZZuB@google.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Retry APIC-access page reload if
 invalidation is in-progress
From:   Sean Christopherson <seanjc@google.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023, Alistair Popple wrote:
> 
> Thanks for doing this. I'm not overly familiar with KVM implementation
> but am familiar with mmu notifiers so read through the KVM usage. Looks
> like KVM is sort of doing something similar to what mmu_interval_notifiers
> do and I wonder if some of that could be shared.

They're very, very similar.  At a glance, KVM likely could be moved over to the
common interval tree implementation, but it would require a substantial amount of
work in KVM, and various extensions to the mmu notifiers too.  I definitely wouldn't
be opposed to converging KVM if someone wants to put in the effort, but at the same
time I wouldn't recommend that anyone actually do the work as the ROI is likely
very low.
