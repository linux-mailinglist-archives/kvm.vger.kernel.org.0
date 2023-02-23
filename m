Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D337D6A12D4
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 23:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjBWWaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 17:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBWWaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 17:30:05 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27455212B7
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:30:05 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id z5-20020a6b5c05000000b007447572f3f8so7050425ioh.3
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ECyQ2h7pgSQ60EmXtNk1SWocHJlTygvBJCNq5ZcRNTo=;
        b=g8cKGXIYlOpwQIMI0zxYk1r5qU2O7f6RyEzh/KJBha7sUA9jfC465GN/y1ukzVsDmI
         TOAy0MVajT6cwunNgMzH8m3VmpL9sZ2y2WHe1ViAKxBEUVYDZuw4mwHamNqPj/G/J15z
         ekLz2v6YF5E5dr5YZdH1qtfCY+gS4DMEozX4fRruQvsdFBb/1emAzmyXMCkrgfiFIuLi
         mBXkfwQLoF+Sk0hP5R4tSAuHEG/sCt6YvWNxZRkSeRw6zF1Y/PCWmbqzxFvOH+hSSa2L
         qQA4LPwBUZyk7QUNLAheaoStrYcp84ivG1n/QfLQEy5qBk155HPBAQc6yrWBVdDxzM1h
         rWLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ECyQ2h7pgSQ60EmXtNk1SWocHJlTygvBJCNq5ZcRNTo=;
        b=SWO70DPVGcJa62NpDXaPrl11qkDmmwcHvbG4oESamIPWqR3c6VCm0P1C4wSXb4zdiC
         3kjpN4wjlfV97jAAoaSxDch8beZZwdi+uW2uok1dRAumftc/sVYRcVbCQd7Mi/mq+TDv
         PmqPHMNvKUuATfK/1cpRUQzVG+0xLG6pO515EcUHH+aJqSFMabaAGC4jVuNzVc1hmqqz
         K1capL1ZpZ4q036d8F+ouczSG2I0TX0Cp0LGtTTEqyW926kCk+5aw3Di2xwDDZqF76l/
         5rgeCpfz01FyZWETwxxx6Cy8VId6lDqEpW6bTaYN8Kpb8rzsDkCg7VrftWo7OOA8I2FK
         0a7A==
X-Gm-Message-State: AO0yUKUBWNRv8C8irsAb9K6bC4NsDOjkr2vwiqy0MTnWuL2a4cew/XsG
        R8UBWUg7hIKF0HAmmgqIQtBrs69HJCxcNWJSPg==
X-Google-Smtp-Source: AK7set/gbGS3Uv2EswHYrTPmM4XxtlKLhss8UMOfmPrTUjGWeUJQrEGWJMcGShq3M35ce3TCkIqNRr9Ylp/xLNBnxg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:229a:b0:3be:81d3:5af3 with
 SMTP id y26-20020a056638229a00b003be81d35af3mr5208190jas.3.1677191404566;
 Thu, 23 Feb 2023 14:30:04 -0800 (PST)
Date:   Thu, 23 Feb 2023 22:30:03 +0000
In-Reply-To: <20230216142123.2638675-4-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:10 +0000)
Mime-Version: 1.0
Message-ID: <gsnt356w9fro.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 03/16] kvm: arm64: Expose {un,}lock_all_vcpus() to the
 reset of KVM
From:   Colton Lewis <coltonlewis@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de,
        dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nit: kvm should be capitalized in the summary line
