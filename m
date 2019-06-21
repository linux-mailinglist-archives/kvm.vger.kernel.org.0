Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF484E21B
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 10:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfFUImj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 04:42:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33270 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfFUImi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 04:42:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so5760472wru.0
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2019 01:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NCZe/wzhmqVTkfL4kbg/RhaDPy78lQA1X7HEK+EaBNc=;
        b=Wq+Z40XQp15Bq2uWcoXflQ3bbzCoqKWeDHzImEKH95328k4N44p2l+cbJAwLCbxSYk
         8QRVu9fyhJO1qw1Jirj3fQe1qVUYfBhCvhB7LhLR7qaPqWjjlVDQYZ0TzJ6P4YAqaMyr
         IMyOM1M/4zo63YV3SeJBSImIaleFN6imn03FPLcU8jCSSnMxyBx+tQimwZuf2qxgPtQH
         1TUCWL5nwrcBZl0RRaCQQ/F4FdkRAo1L8rHRcEkWQub0ipy8bon93DLZoEU4DxSEpDyt
         oHkFHbyGbG09U6QfwZq+4Bb2TKsNLhS5q/rvl1WibZ5MxhEU/7TXq5kD8irZV4axKRuO
         mqJQ==
X-Gm-Message-State: APjAAAU2weSsv9HdenfFUe7t+14sIT1SHI3D/cz5Q7+akyv3h3LxNRCf
        hvnLjXm6eGW8qL+sPA74jmVKaw==
X-Google-Smtp-Source: APXvYqxHByJaYhGLeLp7ST63EtIhJTeBSDbHrjOV2E/XCor6/o/FJQ21g0mLwcv3882Pfibb/UxTow==
X-Received: by 2002:adf:e841:: with SMTP id d1mr32311861wrn.204.1561106556746;
        Fri, 21 Jun 2019 01:42:36 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-127-31.net.upcbroadband.cz. [89.176.127.31])
        by smtp.gmail.com with ESMTPSA id c4sm1707922wrt.86.2019.06.21.01.42.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 01:42:36 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH RFC 1/5] x86: KVM: svm: don't pretend to advance RIP in case wrmsr_interception() results in #GP
In-Reply-To: <CALMp9eTZSWA-7SOHS=2xrMKaXv_imKpURHGcDpfgusF+JDXFMg@mail.gmail.com>
References: <20190620110240.25799-1-vkuznets@redhat.com> <20190620110240.25799-2-vkuznets@redhat.com> <CALMp9eTZSWA-7SOHS=2xrMKaXv_imKpURHGcDpfgusF+JDXFMg@mail.gmail.com>
Date:   Fri, 21 Jun 2019 10:42:35 +0200
Message-ID: <87r27nfhxg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Thu, Jun 20, 2019 at 4:02 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> svm->next_rip is only used by skip_emulated_instruction() and in case
>> kvm_set_msr() fails we rightfully don't do that. Move svm->next_rip
>> advancement to 'else' branch to avoid creating false impression that
>> it's always advanced.
>>
>> By the way, rdmsr_interception() has it right already.
>
> I think I actually prefer the current placement, because this allows
> the code that's common to both kvm-amd.ko and kvm-intel.ko to be
> hoisted into the vendor-agnostic kvm module. Also, this hard-coded '2'
> should be going away, right?

This whole change goes away in PATCH5 (with hardcoded '+2'), I added
this patch just to make it clear that RIP advancement we're doing here
is only being used by kvm_skip_emulated_instruction() and
kvm_inject_gp() branch is not affected.

We can throw this patch away from the series.

-- 
Vitaly
