Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93DB7D5CCB
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 23:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344325AbjJXVAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 17:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjJXVAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 17:00:12 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C052128
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 14:00:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da040c021aeso1082809276.3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 14:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698181210; x=1698786010; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rx1aphW+wLumWiPBC/N1xqdOchKFOo2y16E65jjAifE=;
        b=0i9fCdBpRlwOwZ/XuYHj1MX6Mv/tIzlSyYnzn4vsCA2aUOkRoIFrL84S1YzvrE4YYT
         cae2IrRqAqan8q3vYWI7+k/wf4qirn8ZX29UaDOmxxcokMJdcUdLJpAhbyhpL/E2mYqB
         rbCb+ynlzhGGDPdJpDOY+YY8vfR7gWV/d9Vpb/Cg7uZ27YNGQSE/HTFeOlI43mXvMeOI
         4VBkGF434+r6ZW5/q3i8Qd2IM6U97o9yveMgsjO7eEuJhoIa+RCI1yuvOA5trxbc56nR
         2Zn1DocN4QXK57UiERbU2gOAvLqN4+V6aKs1Xywe5dJ4/ou+Vx4cEyYlFel+iT+EPRyF
         o0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698181210; x=1698786010;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rx1aphW+wLumWiPBC/N1xqdOchKFOo2y16E65jjAifE=;
        b=uxCFoLkS/udlUaXiEzGnkTG4CTU3i+FTAwY/BPbxyQLmiQVYTpynACxd4xqMIXk+a6
         sZUBJu+j6MmSFabzsldl6DVfNhFAUiEq8q4BHeUpNDeb6jwpgALHJhzYvEeXeBmlrxTj
         A85sbui0vQQF8/woCErxkb5alnDZwGN9ODSy5ePp1A90AfihX+f5q4A/6uGA/ppt7a7K
         6hEZd1VgJKVhedc7m2z11ueNy/A0d3sPUHEWEZ5QLXwb4zg1/g7L03nw1T8/4z0J06jM
         M05cBuU3duXFU/1KaJ5bB10pUnutDsdO3iOLjpHVDxCcZsaAsFnorpLxSIcMOS5WXnxS
         7/7Q==
X-Gm-Message-State: AOJu0YyKhPKXwoAzmrv9mU8I/52guZPgJdWWnJZE3h2avNjrBH95qBwz
        h111uWDVrdye06249Xmipm1EtrHkbIY=
X-Google-Smtp-Source: AGHT+IHoJiRD6LfUeV0MWaXh/VhI2enV6J0pzuXY0GRPlEWywrnKU/tBD610XkUJErtxmF7tsksMDhNN2Ms=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3507:0:b0:da0:42f3:6ce4 with SMTP id
 c7-20020a253507000000b00da042f36ce4mr51861yba.7.1698181209838; Tue, 24 Oct
 2023 14:00:09 -0700 (PDT)
Date:   Tue, 24 Oct 2023 14:00:08 -0700
In-Reply-To: <ZTgf1Cutah5VQp_q@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com> <20231024002633.2540714-9-seanjc@google.com>
 <ZTgf1Cutah5VQp_q@google.com>
Message-ID: <ZTgwWBp9BiEdWcqT@google.com>
Subject: Re: [PATCH v5 08/13] KVM: selftests: Test Intel PMU architectural
 events on gp counters
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023, Sean Christopherson wrote:
> On Mon, Oct 23, 2023, Sean Christopherson wrote:
> > +static void test_intel_arch_events(void)
> > +{
> > +	uint8_t idx, i, j;
> > +
> > +	for (idx = 0; idx < NR_INTEL_ARCH_EVENTS; idx++) {

*sigh*

Yet another KVM bug that this test _should_ catch, but doesn't because too many
things are hardcoded.  KVM _still_ advertises Top Down Slots to userspace because
KVM doesn't sanitize the bit vector or its length that comes out of perf.
