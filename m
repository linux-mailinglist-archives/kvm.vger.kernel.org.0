Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5CD7D4ED4
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 13:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjJXLbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 07:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjJXLbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 07:31:46 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8835F10C3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 04:31:44 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-507d7b73b74so6337604e87.3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 04:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1698147103; x=1698751903; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BYH227TNmETvLgiFYzkkeDFOa5cAeGRjW0q0lGDqvfQ=;
        b=LkWA72+QQjW1VRie6IUqpx88ISjxtA0vFTfrp9CPgnlREOOJ8GK0AfLsYeMXSfTydP
         RvFJjLp+ZECIRJ2+eTJF1ddr+QO7OmEWTHkewS1DFKrjgsPnBqwsKNJLqnuc5URa06gB
         HSCXcMzysjzo/PcVyv/A9knsnVk7KIgJYdh8d1W/tiSjkU+y2OWyuwTP9nXZdwZof0AQ
         hbs2+gKzJdJQW4dY1ID5+661Ghrf91YDw9MAWp5Orm+AcsHqX/r+mp5LArRXhEVM4Rq+
         PaaquuTCIrL1DeuA8INH4g9EC1x4UHPL1cugbinNt7wJRNV7ZdQ2faW4bPyQMr309x6H
         NtoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698147103; x=1698751903;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BYH227TNmETvLgiFYzkkeDFOa5cAeGRjW0q0lGDqvfQ=;
        b=lQe36YerENqIfLNCatRt14DRnK8pC530O2ZTou1IUos47ElPj7IrqA/34Dp2S9r8T2
         ma8J207CecJIKPLFKBPYZw/bew2kXqTfSHwHppjdTJhxOslhYs0nMMhKG5eq5ep2z22q
         58Uq0Zkj4caVQo055Gt7ZK9pBPjD9NGaLd+o6Ey167ZNSdEiwklO5S3GDbUg4NgjJpjB
         Xe+AAbvy89nQ6GKW3CrxlmDHZP1yBNqZB4caus4ZU6p7Gj1VghCmqvBjxQp+HaNMnDfu
         L2JAR1zORDYQK7Lv4QNt5qvY+7yJ66oixk8cMSZqy8GUwJybR4bRW496XsHUMkF8YNOJ
         iOuQ==
X-Gm-Message-State: AOJu0Yy73ryneVB+6ppHOaRi5lR6CUc/Psy+CW/gE31Ri3RllZQrTL/O
        hk2VuwUweslqmqGLZe/au6SRPw==
X-Google-Smtp-Source: AGHT+IFeJyUG+BU9vPz+IRDCZmjWiKngbqDyjvsC5ZvlsbdlYH+ryb1lqbxUSUqD1xb8tTeqWFPocA==
X-Received: by 2002:a05:6512:4db:b0:507:a671:3231 with SMTP id w27-20020a05651204db00b00507a6713231mr7925311lfq.52.1698147102559;
        Tue, 24 Oct 2023 04:31:42 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id a3-20020a5d4d43000000b003196b1bb528sm9700676wru.64.2023.10.24.04.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 04:31:42 -0700 (PDT)
Date:   Tue, 24 Oct 2023 13:31:41 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Matthias Rosenfelder <matthias.rosenfelder@nio.io>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH] arm: pmu: Fix overflow test condition
Message-ID: <20231024-9418f5e7b9e014986bdd4b58@orel>
References: <FRYP281MB31463EC1486883DDA477393DF2C0A@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FRYP281MB31463EC1486883DDA477393DF2C0A@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 29, 2023 at 09:19:37PM +0000, Matthias Rosenfelder wrote:
> Hello,
> 
> I think one of the test conditions for the KVM PMU unit test "basic_event_count" is not strong enough. It only checks whether an overflow occurred for counter #0, but it should also check that none happened for the other counter(s):
> 
> report(read_sysreg(pmovsclr_el0) & 0x1,
>       "check overflow happened on #0 only");
> 
> This should be "==" instead of "&".
> 
> Note that this test uses one more counter (#1), which must not overflow. This should also be checked, even though this would be visible through the "report_info()" a few lines above. But the latter does not mark the test failing - it is purely informational, so any test automation will not notice.
> 
> 
> I apologize in advance if my email program at work messes up any formatting. Please let me know and I will try to reconfigure and resend if necessary. Thank you.

Hey Matthias,

We let you know the formatting was wrong, but we haven't yet received a
resend. But, since Eric already reviewed it, I've gone ahead and applied
it to arm/queue with this fixes tag

Fixes: 4ce2a8045624 ("arm: pmu: Basic event counter Tests")

drew
