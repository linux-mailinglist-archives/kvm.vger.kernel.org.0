Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CBC50E41E
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 17:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242762AbiDYPQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 11:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiDYPQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 11:16:12 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9BA85961
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 08:13:04 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id u6-20020a17090a1f0600b001d86bd69427so213780pja.5
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 08:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9K6RsS9yPXS4qwCnQU4PvhBaosajT6TXjveseEixd9Y=;
        b=Td8+8OcwoY3gMAuGy+Nr7PDBXjeTKxoXi6wOU0bvpucj+ZegyFRrb3nNV04TsgD8WB
         RSOLS2NTdczLjZ1AveRgpgmHKul+uTROWO9g2KaNG4ZQ/Tsef4I5BA9eGSstyX/lebc1
         Xjp4PIm9vk6XpnMvJs0fbh4nF26ppyY+R+HNauGnycg+BDyfkicDyzGEi9n04tJS/Go+
         ifSZhxhhIwUFqugC2nYiradOOf3VKGY6aKUxugzPUNvX47TUhTcufsa61KoMLhYPnPOk
         sGM6dlEaPevIBdzIJShxBddisnmzp79s5CDR38STSlzZyUV59TW3Q8W7gwBd6MsLYRY2
         /1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9K6RsS9yPXS4qwCnQU4PvhBaosajT6TXjveseEixd9Y=;
        b=hwCe2zEO4ngEJTZReAl9J2oXjGagK+ThjcZVonQL2nvrY39vbSAfConBMgqQqcdA4L
         GVsUy2wRpMrpX54kUDGraNo4ivO8OqmTbKc/mNGEGC5r+YtrL4k4x14SEVLCiEJiLZsS
         urw39z3jum+ZYEcr/wnDr58ol4z2Df0Ck7lwY3fKHtKNaizUum0DBVNvlBpNY2bx42Ph
         dNtjSNl14bDVG085p+YCeuyiFmLfmI+8vCs+c2WQmEPAmca9/p9KDD22D06KbpzA/GfI
         LpOBqi16Boi4iLGJZFEM/v2CnGatof0aklYCg3YNqZWR434B8QLaOPbIuKfk8205VgJk
         XwWg==
X-Gm-Message-State: AOAM533ZcmkqmeOgA/ONib79igkUA5BUUlC2Jd8DboKNxARDNmoQTfMS
        dedSXoMJdfSqfpnuSxne/Uth1g==
X-Google-Smtp-Source: ABdhPJwUOlDnUHF5k3woHlV9TQvV9nTL1L7mwNMrpk9JJnQLty3+DM3IyKzJ5rF+Kktvx1yg6+/bZQ==
X-Received: by 2002:a17:90b:390b:b0:1d6:b448:b26f with SMTP id ob11-20020a17090b390b00b001d6b448b26fmr21328663pjb.61.1650899583966;
        Mon, 25 Apr 2022 08:13:03 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p64-20020a622943000000b004fdd5c07d0bsm11630040pfp.63.2022.04.25.08.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 08:13:03 -0700 (PDT)
Date:   Mon, 25 Apr 2022 15:13:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make
 sequence for parallel walks
Message-ID: <Yma6fEoRstvmu6sd@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-7-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415215901.1737897-7-oupton@google.com>
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

On Fri, Apr 15, 2022, Oliver Upton wrote:
> The ARM architecture requires that software use the 'break-before-make'
> sequence whenever memory is being remapped.

What does "remapped" mean here?  Changing the pfn?  Promoting/demoting to/from a
huge page?
