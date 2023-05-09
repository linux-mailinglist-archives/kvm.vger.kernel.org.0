Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371096FC91D
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbjEIOfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbjEIOfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:35:09 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50909E45
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 07:35:08 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-30796c0cbcaso2335051f8f.1
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 07:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683642907; x=1686234907;
        h=content-transfer-encoding:mime-version:message-id:date:reply-to
         :user-agent:references:in-reply-to:subject:cc:to:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q1YdxCB85DjavEkSSztecs/1uZiFEj5gdNIdoSOu2jU=;
        b=JjwcIBMfH+BKJVT6FcDztOmongSI6w+OBJ3K9dqquNYFHFhfY1nBfCuSiaQvTio+3q
         wPer1OGk4WFag7yRr2sj4GG65I2c5wIpn4I7aRYIzWj/EHyEDaIf0JOGLNMYI7akj0q0
         r4JRt7SZUYifZc8eNv8nzcGzuwNFB8emQ3EzaTBg5IzyWjMKUUv3lskT6TwhaU9i3oX/
         nb5NfU4EOSHOEoLNn/VrzvMT2SCtToGbf1BihltZYcPw4li7nhDS9qPJN6UvVBQNkD/V
         yRNbK4OdCUdyDJWZnal2bHI0gJ621BCZO/ZcpL3Z8Ue+ES23pD8QXdzBx5EW1z2ccpkE
         ci8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683642907; x=1686234907;
        h=content-transfer-encoding:mime-version:message-id:date:reply-to
         :user-agent:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1YdxCB85DjavEkSSztecs/1uZiFEj5gdNIdoSOu2jU=;
        b=hxawRZGsWo0uiRGY14Q/Yy3gKbjUcyznRHt8+bIbwfoUOWvRlOdDr6KZCQOuqr1SBH
         64k9aAuUyL2J7ors+gtviILTA3DIoYcMozn0eHLoyi42j1d6BSZ4SgHV5oJrH2O+lG8J
         ulb7QkXKm97y7HQbAmP1buLbXVElMMPRwi8Lep+q0e0te75J9tk0PnSvlWq1a5V5nNMx
         mCUdwhJpCu9W7O7lXvXN/mHH4Gtcl8BfSEZMWzWvkgWDHGHPZnBxnSO3sW7/FzX+urlf
         01iPET9ur402j1nrz6KJLwndLxZ3zNVver9o3mUxj4SDb0u77bNt1o++d5ONmJD06rCq
         LiMQ==
X-Gm-Message-State: AC+VfDy0IlPUF1CACmURUtbOONHJfTPJTdDWUpEFyDnNFVsHEka5ST5x
        hxsKT8bWwXcdpftOswxi1jM=
X-Google-Smtp-Source: ACHHUZ5CsIMAIYa0KMYVoSFLvRU9hT596yzswoHdUDGZmpOnYS1VpOcagpzLja7w4fJycoNIhgFXXA==
X-Received: by 2002:adf:fa50:0:b0:307:a3e9:8b93 with SMTP id y16-20020adffa50000000b00307a3e98b93mr1960264wrr.2.1683642906530;
        Tue, 09 May 2023 07:35:06 -0700 (PDT)
Received: from gmail.com (static-92-120-85-188.ipcom.comunitel.net. [188.85.120.92])
        by smtp.gmail.com with ESMTPSA id n3-20020a7bc5c3000000b003f0b1b8cd9bsm20181621wmk.4.2023.05.09.07.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 07:35:06 -0700 (PDT)
From:   Juan Quintela <juan.quintela@gmail.com>
To:     Mark Burton <mburton@qti.qualcomm.com>
Cc:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        "afaerber@suse.de" <afaerber@suse.de>,
        Alessandro Di Federico <ale@rev.ng>,
        "anjo@rev.ng" <anjo@rev.ng>,
        "bazulay@redhat.com" <bazulay@redhat.com>,
        "bbauman@redhat.com" <bbauman@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>, "cw@f00f.org" <cw@f00f.org>,
        "david.edmondson@oracle.com" <david.edmondson@oracle.com>,
        "dustin.kirkland@canonical.com" <dustin.kirkland@canonical.com>,
        "eblake@redhat.com" <eblake@redhat.com>,
        "edgar.iglesias@gmail.com" <edgar.iglesias@gmail.com>,
        "elena.ufimtseva@oracle.com" <elena.ufimtseva@oracle.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "f4bug@amsat.org" <f4bug@amsat.org>,
        Felipe Franciosi <felipe.franciosi@nutanix.com>,
        "iggy@theiggy.com" <iggy@kws1.com>, Warner Losh <wlosh@bsdimp.com>,
        "jan.kiszka@web.de" <jan.kiszka@web.de>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "jidong.xiao@gmail.com" <jidong.xiao@gmail.com>,
        "jjherne@linux.vnet.ibm.com" <jjherne@linux.vnet.ibm.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mdean@redhat.com" <mdean@redhat.com>,
        "mimu@linux.vnet.ibm.com" <mimu@linux.vnet.ibm.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "wei.w.wang@intel.com" <wei.w.wang@intel.com>,
        "z.huo@139.com" <z.huo@139.com>,
        "zwu.kernel@gmail.com" <zwu.kernel@gmail.com>
Subject: Re: QEMU developers fortnightly call for agenda for 2023-05-16
In-Reply-To: <70D7039C-F950-421C-A3A8-D5559DDD6E0C@qti.qualcomm.com> (Mark
        Burton's message of "Tue, 9 May 2023 14:25:41 +0000")
References: <calendar-f9e06ce0-8972-4775-9a3d-7269ec566398@google.com>
        <70D7039C-F950-421C-A3A8-D5559DDD6E0C@qti.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: juan.quintela@gmail.com
Date:   Tue, 09 May 2023 16:35:05 +0200
Message-ID: <87zg6dd146.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mark Burton <mburton@qti.qualcomm.com> wrote:
> I=E2=80=99d appreciate an update on single binary.
> Also, What=E2=80=99s the status on the =E2=80=9Cicount=E2=80=9D plugin ?

Annotated.

BTW, if people are interested I can expose the "idea" of all the
migration patches going on the tree.

Later, Juan.
