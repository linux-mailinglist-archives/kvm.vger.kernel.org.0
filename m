Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65E04AE4F7
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 09:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbfIJH5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 03:57:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729267AbfIJH5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 03:57:46 -0400
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2F92DC050061
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 07:57:46 +0000 (UTC)
Received: by mail-pf1-f198.google.com with SMTP id a8so12461727pfo.12
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 00:57:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3LKLkxRAiXJ9DCcofUay+XNoeWVIY719M/7auDmA12E=;
        b=qENaLQWXKcGiy1ZC2sQ8pTkEM/WAdKccN6JHaOHYicR94ujD9mJYhopR6BW4Jws00o
         Hx/6fPhrn59i98+opZC2HHFBBvno67Ng5d32NKLI6LWo7rVJeNYpdTvu6zfHRLtKv/Jc
         S9hFOMSXOJ73CvEWJN3mA/kxm2t2iOKHnl4zrZxC4ZXFG4KAXCVkVGRDekR2xpeRzPnP
         UMSCnrovyfx6cY4jItME1tENNuoigSkyDdl1MhmNfAhmyZwbVYslmU+5kx6q63IflM7C
         zLjNEudlYcBmfX5RK1y40acZAlsF0CQ5jhTt5VpLd3ImHONxOFRzmC7tQRbZJ2r7cbYE
         o5jg==
X-Gm-Message-State: APjAAAWZOZlRVfz0E2rUDGdG+KzWhOls76+qOkGVxKO931t/DqaJxOHn
        VbMvSG75+H8wbf4mzx61OMgg2DOJcaYqOAcpR59D25mgBRPXpve9/GDu+dXBtKnIgFmiP7zj7SO
        mgwTrDe65R91o
X-Received: by 2002:a63:ba47:: with SMTP id l7mr1512107pgu.201.1568102265665;
        Tue, 10 Sep 2019 00:57:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxSPWl+W46niXG1xE3PRAdspVT8qtfPVUEnZIyfAFDNcPov7t2yNTu2Z1p/INAfYLe4XU2Y1Q==
X-Received: by 2002:a63:ba47:: with SMTP id l7mr1512090pgu.201.1568102265348;
        Tue, 10 Sep 2019 00:57:45 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t14sm2110885pgb.33.2019.09.10.00.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 00:57:44 -0700 (PDT)
Date:   Tue, 10 Sep 2019 15:57:35 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Evgeny Yakovlev <wrfsh@yandex-team.ru>
Subject: Re: [kvm-unit-tests PATCH 0/3] x86: Cleanup max test CPUs
Message-ID: <20190910075735.GC8696@xz-x1>
References: <20190906163450.30797-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190906163450.30797-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 06, 2019 at 09:34:47AM -0700, Sean Christopherson wrote:
> Fix a bug Evgeny reported where init_apic_map() can cause random
> corruption due accessing random bytes far beyond the bounds of
> online_cpus.  Take the opportunity to bump the max number of test CPUs
> to a realistic maximum, i.e. what kvm-unit-tests can support without a
> major rework.
> 
> Sean Christopherson (3):
>   x86: Fix out of bounds access when processing online_cpus
>   x86: Declare online_cpus based on MAX_TEST_CPUS
>   x86: Bump max number of test CPUs to 255

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu
