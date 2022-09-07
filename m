Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57875AFA03
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 04:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiIGCkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 22:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiIGCk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 22:40:28 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AF874CC9
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 19:40:27 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id c3so13558005vsc.6
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 19:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=nRLryB5Xf6lBklSjFILLPLap9evfM0qCWn2PvmAqML0=;
        b=UJVC3Gng8U3UmQUkRK7cXsWmmJL7WkoCXMlUIomBRYjM86jMhNimaEYMGH9NI5etdf
         9dXdbKNrB3zpNZCcS5BDKaFI2z6VCPAUJI2fvx+yODlYzfl7JF4X78Lw2bXsJ110PQBE
         gWjQBfPs2Xv7o7gKddMwPZNmftTqOvcoK3U987SWDvW1PaCsLcXTWJEZgE4dEimJSWOQ
         iNX8zcjUof8AGeIgkZ8aP4qrAr7mK7cOlGo5XemApDnmELEDIjjUxbsKhUc7WCKCKAWB
         5l1qhf/8q+kZvglYXBSvov+hUlZtTqxzGRm1TqvtPO7gsLSZeq93rx1+qAmg3OjPCivG
         JmFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=nRLryB5Xf6lBklSjFILLPLap9evfM0qCWn2PvmAqML0=;
        b=SQ6IXrjRwuHJglO4G8cZVCi0TLXvABatSMDSl2A8c9iPQ6h1rVn1Rb/7a5PApvnU6W
         cj0qNkp9DoPWjXXWOdKPhcF4yYQ9dqK/WA4a34FHwq6RNMaiIwr/pVcPfcSn3kmGfdX6
         Y5DXdH18W1s9iG/p+XkeiQI5lMyUf9/s+58B7mln7w6bbQbBxnebCz+8J8sGjWGmjT6P
         FGdzcn2bgvd6ax/wVPyNIIjDFaXGtSk0gU5m4Q7hguxfVrpVYF5xKdT5K9mqpUhg2TDz
         V9g8lVIku9DnUtig1J2kyycH4arUMhBBpHH9HBChVL6VnayD1QxtGTkOKYSFR6TGtqQL
         6c/g==
X-Gm-Message-State: ACgBeo1Tg0aBJWhTyTTDz4vEt2LRgGbVx2zUloSIlVrWzg+Tx6O/Zs0e
        m5VPyc328wbs7BNcdm7RjwnTfjE++uypRGklgJq2nw==
X-Google-Smtp-Source: AA6agR44iTfe4vWGY8NVG62qnMuNdo07u4WWB0Hq3elNrucYrkLoB5SpIfHwPyNFT59Q2eNPmDt6Pc0Rc8oKHU/TE/A=
X-Received: by 2002:a67:fdd0:0:b0:397:c028:db6a with SMTP id
 l16-20020a67fdd0000000b00397c028db6amr477394vsq.58.1662518426470; Tue, 06 Sep
 2022 19:40:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220902154804.1939819-1-oliver.upton@linux.dev> <20220902154804.1939819-6-oliver.upton@linux.dev>
In-Reply-To: <20220902154804.1939819-6-oliver.upton@linux.dev>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 6 Sep 2022 19:40:10 -0700
Message-ID: <CAAeT=FwZ28XRgAkUH_aTxZfSPHRRrEUSy8-R-dj6rs6fmOnv0g@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] KVM: arm64: Add a visibility bit to ignore user writes
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, Sep 2, 2022 at 8:48 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> We're about to ignore writes to AArch32 ID registers on AArch64-only
> systems. Add a bit to indicate a register is handled as write ignore
> when accessed from userspace.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
