Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA9C535441
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 22:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345951AbiEZUJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 16:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiEZUJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 16:09:01 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B996EC0381
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 13:08:58 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t6so3418449wra.4
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 13:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KDEmYOOyoOP2tQlMyYbksUoCrMBj3K7WkocsVGt/GNE=;
        b=dHMXbu81V1p8lsCx1fltXdZyN0c2mVuAOYAI/LTIgHtinTY1YkSKHhFH4K2z/xFp1q
         Od+v2kkgf56CZj5kGs5hhJRFzvA2IOBEnN72WDljkbHjvlMu0T5gSmSUDDlOpwjY7OUT
         gmqz1bVuRdoBngs55rnyoQAvFbKvodBpG4gl8vr3VFsjc4Yuexub+noaUD4/v8h1P1/4
         m8YI2qINRKRJsGyzkEocy7INhgZoojFpQHo+VPqKEZE+Je/tdGzWng1W/gBoVxF0iJRE
         C3CNT5yEUHq4gy5B4AEkyvT/1xDJVkTEvR0BoisEuiJq4nPgztUPLDqvenCgNrU9Uejk
         /jwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KDEmYOOyoOP2tQlMyYbksUoCrMBj3K7WkocsVGt/GNE=;
        b=iH6C1/IfvdqhUeRgLCPSusuOEs0vg5nYD7z4b316LeellWd1tkRL+8nxMEczaBaP1m
         PECXHF3vhDSN5S9TvsXOeAP7Byo0lSdpsj8O5YRzRQF9yuYkWVRhR+XAwUJs2kBrnqJH
         15lNopK89EnTrzn9a0lH0JGPSmAKiPjbaXCLbkYgS3S6gsd5FC3qIJ8DIRxvIK80u5cP
         29IYKpK3N6lrZ2MeBLFIP29Ob8t3F69HalNdSPuOgplwpuCFSW7W35i8WQKF7CCDw9Gd
         i2LVB1UrbWafWi2XAWCEhOGhCM+H89RHa5YNploFUmtWtjpASHaZUxvIcibrbrL8mQq2
         HUMg==
X-Gm-Message-State: AOAM530pnZKecQT6oLarbVT80H+zWn46sf+wNfQl7glIfgJps42wKToJ
        75clubk4bSRAS2s3J+7N08+2yPze8QPdJb/VQot0rw==
X-Google-Smtp-Source: ABdhPJyaxPLGqTMtr/VToX80lhngruza82vVEBGRO0bKZQpIdREr22K3VR4QqvnYJmC04nw+CeHbap8M7tbV1tQuP/0=
X-Received: by 2002:adf:d1ee:0:b0:210:d63:6570 with SMTP id
 g14-20020adfd1ee000000b002100d636570mr3269809wrd.673.1653595737089; Thu, 26
 May 2022 13:08:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220519134204.5379-1-will@kernel.org> <20220519134204.5379-60-will@kernel.org>
In-Reply-To: <20220519134204.5379-60-will@kernel.org>
From:   Peter Collingbourne <pcc@google.com>
Date:   Thu, 26 May 2022 13:08:45 -0700
Message-ID: <CAMn1gO4_d75_88fg5hcnBqx+tdu-9pG7atzt-qUD1nhUNs5TyQ@mail.gmail.com>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, May 19, 2022 at 7:40 AM Will Deacon <will@kernel.org> wrote:
>
> From: Fuad Tabba <tabba@google.com>
>
> Return an error (-EINVAL) if trying to enable MTE on a protected
> vm.

I think this commit message needs more explanation as to why MTE is
not currently supported in protected VMs.

Peter
