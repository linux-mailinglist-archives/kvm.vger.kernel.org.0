Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73F9256077
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 20:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgH1S3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 14:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgH1S3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 14:29:22 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60FEC06121B
        for <kvm@vger.kernel.org>; Fri, 28 Aug 2020 11:29:21 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id k2so46008ots.4
        for <kvm@vger.kernel.org>; Fri, 28 Aug 2020 11:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Uqz1c4wz/+QeP0lM37IWyWpsW+8C5dMpeQfSu9DoCw=;
        b=fUqN/qrtMEMO1vhmrWg18jXZ1lLte1cnW9Dn+onsT+OTP1TlLgml7d0yrIF7Kzqc+4
         PhxEu3abE9D0QKhUGRAHmQ3sMJvqeCojDVHC912uDllWZbw0LR7vUWf9YOGMjQHKyj/w
         w8VrgsfzDeaW9UjiISiTPXjTE8DJiYaBCTcVi41UCUlc/VPG85nmefKnjQqBwpQsGmpe
         Em9kBR+E/F2IJIxcyhszVcmJjdalSi2Yi6aXLJy5Jocz2J5XcrbfQWt2PKnvWTe+ZQhw
         u6G6de0S6vFEeVRwEpitdqPKj7wGfqBQYrp7kCs35PkSDszusnwzz4saPhKK4H3biwE4
         chuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Uqz1c4wz/+QeP0lM37IWyWpsW+8C5dMpeQfSu9DoCw=;
        b=bR2NVEq5Aoq1qlh7RXGw3uJrlNLHpryDvnmkmNQupil4o0aNe2dUD1H2Eqbpbhf0ST
         6YpE0z8HKOizXmd06ahhUHGKfGIWWDgSf06gI30I7g3b6Z/Yt8cHAPJplbqLomlRNY3x
         nn+fBOpEkLYmmj2bzPlQm2OzwiYtfE9oqh+LhirInfY65TIhaVGyBGyQDlW1Yjswrzyj
         fgUGIhf70c9LWr7qi9aSxrjm8unwX5Mu997+7jEAjylPjAC6Ptzth7AtZcGdaG8KTHZw
         wdyV0fq1eFSSU0rEVIwL3UnEtULEIfINXSb7gn0d4GJft1Sq9A4vxZL4G24RAUBjVGz0
         8FeA==
X-Gm-Message-State: AOAM533YAAIByg3hbLYIA3Njg1HaMdCFDVMfebZrFmpnviBNeCcrXsmZ
        G2RVocp7majb6qwoCE1NzmXoL+J+musYBIeDUS+f2Q==
X-Google-Smtp-Source: ABdhPJzz92se4PNrhB2hOBoElmY3QW0kQDcYEwrrHi7oPMn+QHDAsAH4wkO7+qT/DwnKY98YLJ0pL8Ysp5VsQFW9pgg=
X-Received: by 2002:a05:6830:1ad0:: with SMTP id r16mr2244855otc.295.1598639359262;
 Fri, 28 Aug 2020 11:29:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200828085622.8365-1-chenyi.qiang@intel.com> <20200828085622.8365-5-chenyi.qiang@intel.com>
In-Reply-To: <20200828085622.8365-5-chenyi.qiang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 28 Aug 2020 11:29:07 -0700
Message-ID: <CALMp9eThgAgzvvPDktD2PZOthqPWMYNKTAhu=NpcXq=6fbiGJA@mail.gmail.com>
Subject: Re: [PATCH 4/5] KVM: nVMX: Fix the update value of nested load
 IA32_PERF_GLOBAL_CTRL control
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 1:54 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>
> A minor fix for the update of VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL field
> in exit_ctls_high.
>
> Fixes: 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
> VM-{Entry,Exit} control")
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
