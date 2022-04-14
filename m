Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB4B501BE2
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 21:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243665AbiDNTYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 15:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiDNTYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 15:24:14 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2ECA1469
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 12:21:48 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n18so5479533plg.5
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 12:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tqcDskH7+pjeGH7+37qMSCHWZnRKgjNETpAFgYRNMIs=;
        b=ralvO1dTp/gCrVUeK4H59pMwEVAPwElTaOS0owWd3cnlJgqrfycvpyLMCu9ZySvvP4
         1PPPN20eN/WeHw2jUl8UVzYLCE1lEjVGlrh3pz3fD3AcMLC2Tdfr06CDPOu9p+C9reE/
         Wyi+idya0F+Oz+ascwRtDVxsF34USIwfFz4PLOYkOmHDee9GmMTLBU0CB54hCpC8QPVo
         GvvcU8PJkIke4tFlEyKV+40K9HdHkZZJtM2KlVcG9ZHLlN9QC5tHpR6poipafuFyeNkd
         viRcTpLBUZfOe1oGqMnyadap9nXgXJnRr0D/YN861mNyOP6NyHQTjNZNpkNanjk0r3RL
         PUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tqcDskH7+pjeGH7+37qMSCHWZnRKgjNETpAFgYRNMIs=;
        b=8JAPUg59kAlwsyLR3U2mtdDlUq5y2IlrA5/WLhG3/Pimtmb0N/aHChTL8KyraXlINZ
         iMYbjPvGyV41WoSA2Eg1pV7dBccn02J+4zmFudVwfjcHIaFWpYieRUl5q9Vt+tjix1i4
         QlMse5LIA1Yr2Xkc/ZUqdvjs+tmgU48wkbjDn6bQEIubLHSVJuKJkmjwo4OPAeFGnNtK
         MDfHu+VgorZnFjROmCWRBv17w9HwKy46sqBh/8cYyJhP3H9Iqxx26WSjUjqC3zAIziur
         GWQMcBoGj+JJxhHIBU1g0V/ZfQ8/zAykWQnIGDRV/HDNWlatGKjkqOaYQrioduMiG4uu
         oJfw==
X-Gm-Message-State: AOAM533Vg2vKulAp+vv5RATFpOXxFI/O6HKVuNrq9FeUHdezkwFeT4Qg
        5FZMARKlhmTcntE36No7zT/F9A==
X-Google-Smtp-Source: ABdhPJzxBPselW3Q3EB5PKFLA8hFRyq0lndHWgT+eEnFy1eNdO9RQL1DGbwuOYfNuWhRdY1rbTqVDQ==
X-Received: by 2002:a17:90a:a4e:b0:1cb:58a9:af2a with SMTP id o72-20020a17090a0a4e00b001cb58a9af2amr97699pjo.101.1649964108037;
        Thu, 14 Apr 2022 12:21:48 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b10-20020a056a00114a00b004f784ba5e6asm676940pfm.17.2022.04.14.12.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 12:21:47 -0700 (PDT)
Date:   Thu, 14 Apr 2022 19:21:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mlevitsk@redhat.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Subject: Re: [PATCH 1/2] KVM: SVM: Introduce avic_kick_target_vcpus_fast()
Message-ID: <Ylh0SE5obsyHghCM@google.com>
References: <20220414051151.77710-1-suravee.suthikulpanit@amd.com>
 <20220414051151.77710-2-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414051151.77710-2-suravee.suthikulpanit@amd.com>
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

A drive-by comment on the shortlog, something like

  KVM: SVM: Use target APIC ID to complete AVIC IRQs when possible

is much more helpful, e.g. I had to read the entire changelog and most of the
code to find out what "fast" meant.
