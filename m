Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5131A557D4F
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 15:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiFWNwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 09:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiFWNwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 09:52:30 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069D938189
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 06:52:30 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id e7so2055073wrc.13
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 06:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=1X9lbKKIV9qycrXRpNydQ+hZtRjdEcBHpnSHAhTustc=;
        b=Q8wLdsGGO2EMGYwRe1qx9L+Id/qeH5FGsNpDqssmOAVha+fiBs8gU15mzwp99iHf3q
         POCKEFtPz9KVHJhzxKH/HhM/1fXiknbk+U23hgE/upekiyWIg6RIq9ieJjrFkznBfLl7
         kWxfSUzP2FIWpewjxG5dF2FJdWSb8fBOcTgdUNgQu5N0RMq98vclEOSuYQQSD/n2m6EO
         GvG76m8q47B5zc6aKTjN9AQ79Z2mKMrKztuOAcpPVkr0H8xu5ETRuxswK9KXrHzeEIFa
         HfjENT5CZl8ih1nw44Oj0gQA9aPwUSNF+otJHjcagPq24kR5XfdSbhtZCsLMKGhE5hM3
         79pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=1X9lbKKIV9qycrXRpNydQ+hZtRjdEcBHpnSHAhTustc=;
        b=0GsowC3swkLxTi9xx2mbBGF2J936WTARnOb/l5rQYzVqx75OMfOE6anrKuT/y/OmjY
         HCRQHwvsFYEaRpBk1V4TI4FQMOg/9iM4/q5rySDkJY/w+d+nuRbLc3AAqyiE/XW7YW8m
         n+iuLBWDEaYA4UJDTZ+cCodtgI5T0O7TEc36hfuKFgMKjeOZ/rggB9g2Ld0l5yYOPJw/
         dXz8I5rJ6fBkgJlN4lN0URUYXHgsxjtuc1W9Ox0H1jrbQQbb5O9d6NL4wU5NO+CRrTLQ
         BCjxMpKL2HpzRxmwFCAGLtFjLuvRWjBOpalCTTlUFci9BTll0tFpiFUo1FMR0E47p8Cc
         sQvw==
X-Gm-Message-State: AJIora9uCCbb9+wF0hkjFjZrQEtsh4A/wS3Y0RsaYVSYvOkyZWMmoYfJ
        aeMS/zqsM1sJZTk6bmmSxBfbqA==
X-Google-Smtp-Source: AGRyM1s1YMX1GREKjHaIpDGqwB6jmYus7bPtupyPY19Kc6pNGoYQY2OMTwz4NdaQOxFdEYiwc0jUJg==
X-Received: by 2002:adf:ebc4:0:b0:21b:815b:d135 with SMTP id v4-20020adfebc4000000b0021b815bd135mr8145392wrn.653.1655992348613;
        Thu, 23 Jun 2022 06:52:28 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id m18-20020a05600c4f5200b0039748be12dbsm3470135wmq.47.2022.06.23.06.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 06:52:27 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id E271E1FFB7;
        Thu, 23 Jun 2022 14:52:26 +0100 (BST)
References: <20220623131017.670589-1-drjones@redhat.com>
User-agent: mu4e 1.7.27; emacs 28.1.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com,
        thuth@redhat.com, alexandru.elisei@arm.com, andre.przywara@arm.com,
        nikos.nikoleris@arm.com, ricarkol@google.com, seanjc@google.com,
        maz@kernel.org, peter.maydell@linaro.org
Subject: Re: [PATCH kvm-unit-tests] MAINTAINERS: Change drew's email address
Date:   Thu, 23 Jun 2022 14:52:22 +0100
In-reply-to: <20220623131017.670589-1-drjones@redhat.com>
Message-ID: <87pmizpjvp.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Andrew Jones <drjones@redhat.com> writes:

> As a side effect of leaving Red Hat I won't be able to use my Red Hat
> email address anymore. I'm also changing the name of my gitlab group.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
