Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3654CD0EB7
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 14:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbfJIM3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 08:29:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727219AbfJIM3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 08:29:49 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 975C2C057F2E
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 12:29:48 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id 4so605568wmj.6
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 05:29:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xvThJK+yx5Ccn9NmhrAQG/4aOZL4annIFveYbxX7LRY=;
        b=OzVdy02pJhMaxJ2q2wDkjqT24s6chVyocRrOa9iSv88HOOUSKX4XXU9CmVb+bEnwSe
         4l8I6S6LbxTHjpn/AlrFXcoWu4bVdbxCCsRMlQZhrLevrNydGDX1swjI1nazIlvGNS0o
         z5GHXy1Q4D3Y8hyr13GgXXwl0D71d/6uygwPZ0cvsuafKsmz0m2LF9Pe4926KJykp4Al
         G1SZcw8OjNc8ekHv8aNI4U41OsjnQ2VP4o0Y1Dh+VJU0krEseEUyg20eL8TYGIUdMVb5
         W3JPHJpLTi+JfAVpf7OSQCPwUASDjrMOrlJih1J6u7j0G1IIgOge8NIwOSpwPotED2II
         X9zg==
X-Gm-Message-State: APjAAAW4vBKDsUGBrj1JewM2LfP83JSfDUJ2TbFi4Pz4WDpSkTk2xciz
        OC/PXqTa29QyMfVpfxfDStZbm9TW32HwDqkabWFS+olIWzaIATZWeiqJbE3nDUqTnXNJjP//XYC
        ci0/H4ckSuNdd
X-Received: by 2002:a1c:6389:: with SMTP id x131mr2379534wmb.77.1570624187331;
        Wed, 09 Oct 2019 05:29:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzmSCLkj57Flq62wjjdik+sMsp+Gw9vcplMUYMGct4y5MTaJRpQ2Q5fyhVBXbKv5lQZ0l/Y2A==
X-Received: by 2002:a1c:6389:: with SMTP id x131mr2379523wmb.77.1570624187133;
        Wed, 09 Oct 2019 05:29:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 59sm3512855wrc.23.2019.10.09.05.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 05:29:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] selftests: kvm: fix sync_regs_test with newer gccs
In-Reply-To: <5b1b95e5-4836-ab55-fe4d-e9cc78a7a95e@redhat.com>
References: <20191008180808.14181-1-vkuznets@redhat.com> <20191008183634.GF14020@linux.intel.com> <b7d20806-4e88-91af-31c1-8cbb0a8a330b@redhat.com> <87d0f6yzd3.fsf@vitty.brq.redhat.com> <5b1b95e5-4836-ab55-fe4d-e9cc78a7a95e@redhat.com>
Date:   Wed, 09 Oct 2019 14:29:45 +0200
Message-ID: <874l0iyudi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 09/10/19 12:42, Vitaly Kuznetsov wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>>> There is no practical difference with Vitaly's patch.  The first
>>> _vcpu_run has no pre-/post-conditions on the value of %rbx:
>> 
>> I think what Sean was suggesting is to prevent GCC from inserting
>> anything (and thus clobbering RBX) between the call to guest_call() and
>> the beginning of 'asm volatile' block by calling *inside* 'asm volatile'
>> block instead.
>
> Yes, but there is no way that clobbering RBX will break the test,
> because RBX is not initialized until after the first _vcpu_run succeeds.
>

Right, we're always resuming after so potential clobbering doesn't
matter. Thanks!

-- 
Vitaly
