Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568141543C2
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 13:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgBFMJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 07:09:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49944 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727835AbgBFMJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 07:09:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580990942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E0dTUFkCATPXVv287UdMap2gGam4zjJ6lvZcBnT8osI=;
        b=ElX4uVDHHPqAMBa8hVyKF048pADsMrhExmmplOphx9HtW/at+8DJBpDw+DD6zjkTooI9Xq
        K0D4k3rQkMCQff5R/0R1HmNfy1C5PmiXyOnUz8oscXoGctY+o7tpCUpsCqzH4mjmYdrVEO
        YcgEMNSi173ugTgoe8+IW3t+oq2TrNE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-TBujGeIyMD2GRAx65f9eiQ-1; Thu, 06 Feb 2020 07:08:57 -0500
X-MC-Unique: TBujGeIyMD2GRAx65f9eiQ-1
Received: by mail-wm1-f70.google.com with SMTP id b133so2543786wmb.2
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 04:08:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=E0dTUFkCATPXVv287UdMap2gGam4zjJ6lvZcBnT8osI=;
        b=bekSonCV40Jw7T5G81dv5BytE1XkiUGUH8USY8nQY52M+TAY1RrUcviY/2aQqcAZVv
         DbU3hmrPLKNno4/B5nijI87Eebc8a4U+Es6Nr1rW8lQAdleXmCDVduFhtPFJGR5uvvro
         73pqBupwQDFeIkYJ5+NwDc3BugrFLkkjWxGXUwvslKhUxdwwhi/LwjXjg2HvCZvA2GjU
         m+pu/PeYcUDkgPyKRaXZIyG37A9ma+0HquRJFoWgOfOZdjxKWGpOAcHIqf5AJQp8fJZ+
         m124dTKhqBrQmsEDneE4ONvWUcapMZKeAVQ2Ju3jLzERpbFBE9LSPvujdswvvjECvJD7
         OFpw==
X-Gm-Message-State: APjAAAXOiChclMAmDy0vCZgZb+WGhnT8LydnJRtfgFU+PChBkMZv6SPg
        cLJdo0PXYES40vjRSCAlOR7HRSAYAodpDj7jcAJAsdwd4NV+D4y7IKWOZk0EU98ahqYACXAmLrE
        UpP4gQBggpN80
X-Received: by 2002:a1c:7317:: with SMTP id d23mr4362682wmb.165.1580990936359;
        Thu, 06 Feb 2020 04:08:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqxbbMXe8FHfJITDoTG5ycCef7EyduSOW9ahh6f1qWfindtlKQK2JEURiiqEWYgbRJ/1F6WOSw==
X-Received: by 2002:a1c:7317:: with SMTP id d23mr4362665wmb.165.1580990936162;
        Thu, 06 Feb 2020 04:08:56 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a22sm3490157wmd.20.2020.02.06.04.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 04:08:55 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 04/26] KVM: x86: Add a kvm_x86_ops hook to query virtualized MSR support
In-Reply-To: <20200205170209.GH4877@linux.intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com> <20200129234640.8147-5-sean.j.christopherson@intel.com> <87eev9ksqy.fsf@vitty.brq.redhat.com> <20200205145923.GC4877@linux.intel.com> <8736bpkqif.fsf@vitty.brq.redhat.com> <20200205153508.GD4877@linux.intel.com> <87tv45j7nf.fsf@vitty.brq.redhat.com> <20200205170209.GH4877@linux.intel.com>
Date:   Thu, 06 Feb 2020 13:08:54 +0100
Message-ID: <871rr7hq95.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Wed, Feb 05, 2020 at 05:55:32PM +0100, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> > I dug deeper into the CPUID crud after posting this series because I really
>> > didn't like the end result for vendor-specific leafs, and ended up coming
>> > up with (IMO) a much more elegant solution.
>> >
>> > https://lkml.kernel.org/r/20200201185218.24473-1-sean.j.christopherson@intel.com/
>> >
>> > or on patchwork
>> >
>> > https://patchwork.kernel.org/cover/11361361/
>> >
>> 
>> Thanks, I saw it. I tried applying it to kvm/next earlier today but
>> failed. Do you by any chance have a git branch somewhere? I'll try to
>> review it and test at least AMD stuff (if AMD people don't beat me to it
>> of course).
>
> Have you tried kvm/queue?  I'm pretty sure I based the code on kvm/queue.
> If that doesn't work, I'll push a tag to my github repo.

My bad, kvm/queue worked like a charm!

>
> This is exactly why I usually note the base for large series.  *sigh*

Pull requests, anyone? :-)

-- 
Vitaly

