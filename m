Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D38572D9D
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 07:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbiGMFvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 01:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiGMFvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 01:51:42 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D5FB9698
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 22:51:42 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id q26so7388626vsp.11
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 22:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V6DsLVB1Os/T467zl8XHHfVTC79R6u1QIg76nXthRf0=;
        b=X07y/aH0bERy3yMTWnhLUJfEU4C3NSMDvTZ2dqjIhvWFXrV5dn+isPnxxXf6wkY9EW
         Be45usNE+fO2CyTyVnM+8YL9iTkWOuR1dUeJ7u9M645jE4fgcP3ezP75uR+Jp9LaJ9xv
         P9fQjwoC69dhtrVRWBJHuki2xt6YhU0mQlaeruRXko32UKJfOY7GbC++VP9rhJZ8HMjI
         9ZHlNheUJu5x92W2EPuum6PxktoSelq/+SKK2NHiDoPsW/MmpM00ePiXQQUsAAmwOwjO
         FuEhU454w2bVLRbpT28sMpGXdmHOR6JAJhrltMOraKg+W41dIRomFpqqpjo8Aanh7z6R
         jK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V6DsLVB1Os/T467zl8XHHfVTC79R6u1QIg76nXthRf0=;
        b=sYBWXy2LSwjOQX9EJO7Od9Sf7qVb68WdjF4ezcie2IC0DtXGwVaAVPU1U7WQiAxwm2
         ymv3sxpsR88FtWaVU6HzRzptJLqFJ7vL7KjLMUGyMecjnmxadLKIlgzPhbFEM7BsGrBY
         uS12V5iqCe10hnk6fmwIMQkLGiJ0IW4VJLkr+5tlX0WF7E+jJ3TubH7TwkEvFbb/WCND
         6tpYs+gt/w52xgsxFaF2jisRBHo9eADYGQLVugYNCgDnGH3zzVBpSvOAHYQu853DnC2f
         kXItop+imO6CHsPLYBxlCCW6jweaNpplDLYk9q1tk/Ozacw8Pt0SLGr2A/fybEk7Tnu6
         CETg==
X-Gm-Message-State: AJIora9NcMoHwSPnUk9vHqjhJXcaTfoJGfXqWXrp9tZqz8pPSKRcNRpK
        iDKeYdukzdEyWr0UFTEmWtW1iBx3QqFlw+tyTim++w==
X-Google-Smtp-Source: AGRyM1vmw3DqET09DU69NtxLbHGCoiebSBcuxxz9079JWzLSn2pteanGKVgXbkE8PBhG6kBPfsnDc2/g7nxtlqiayyY=
X-Received: by 2002:a67:5c41:0:b0:356:20ab:2f29 with SMTP id
 q62-20020a675c41000000b0035620ab2f29mr502511vsb.63.1657691501271; Tue, 12 Jul
 2022 22:51:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-11-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-11-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 12 Jul 2022 22:51:25 -0700
Message-ID: <CAAeT=FwrHpyhHD3spc_e70uQCHoHwc-n80iMY30ypymgFEQ7QA@mail.gmail.com>
Subject: Re: [PATCH 10/19] KVM: arm64: vgic-v3: Convert userspace accessors
 over to FIELD_GET/FIELD_PREP
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
        Oliver Upton <oliver.upton@linux.dev>
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

On Wed, Jul 6, 2022 at 10:05 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The GICv3 userspace accessors are all about dealing with conversion
> between fields from architectural registers and internal representations.
>
> However, and owing to the age of this code, the accessors use
> a combination of shift/mask that is hard to read. It is nonetheless
> easy to make it better by using the FIELD_{GET,PREP} macros that solely
> rely on a mask.
>
> This results in somewhat nicer looking code, and is probably easier
> to maintain.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
