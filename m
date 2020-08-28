Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094A7256061
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 20:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgH1SYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 14:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgH1SX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 14:23:57 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AF1C06121B
        for <kvm@vger.kernel.org>; Fri, 28 Aug 2020 11:23:57 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id r6so508814oon.13
        for <kvm@vger.kernel.org>; Fri, 28 Aug 2020 11:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2iXkGuZDPH4c7YYMkQMRwiYMRp5lf9MC5NLMKzhRWWI=;
        b=dYbDgKBbk0VjD6Y/A7wPhWL9z+uEz/dNKUmyetpjnIGuq277TcZgnKD/U2KIUTyLEQ
         FUzpxvVBvO8f/VDWiixr0WMaqSsIKHUL8oMIje1HEtU0/eTy3Cx3aZ1JyufdJUql1l0O
         rKqyYCs9I7gyhfJx309EBd9rXd274mgypn0ovu0XZjDgs+OqpCgo4mYxLz9X9MmaXB6j
         cHUFuOFhKM0DUI165h9NviZX9SiCnkE83onyl/oFaC+eHobxPGWMH7tXqChHwDffmb1P
         mxrF+mejSYCg/PSky2/fN1T18S5XzusIOBna49BqaBLgkGRKed9Hvi3zfIn+vQI4GFvj
         N9Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2iXkGuZDPH4c7YYMkQMRwiYMRp5lf9MC5NLMKzhRWWI=;
        b=Jzaeq+Y9jVZwzEegP3H+HpNjN2kXNcRQ3M7VMtGezFVTg4RsuGMvh2cYter09N0bNQ
         AyS1FAY2nBwCDwuHdCWpb3mSG6Muck/XcOzo9WCOwbV0kN1/cfyYDKDSOY6/BZQt+nmY
         dZhi9uD117n0juZIqggHPgdqE/7lnuPHj22RCE585llJdOCrx7tdI/TQsdTi1OudYdfy
         zyq3yg8iNnWB9JZWNtOp/yRj5sBymO7CGmFilew1gD/WWcQkP7QXB3fjLFSCUIDJGnD7
         24eEdfl6W3CTDvVTCNHQ2HZI1plHAWPQSSBFnCIdE5Qtd3+o+oAwHJux5MPMgmcrOMyd
         5DMw==
X-Gm-Message-State: AOAM530Nx1I3zPjyrfK8EPCyIg2r3nWB8bhZyjVEbAx4Lec17oKBQQ4O
        NFJuVNmNSa1/Oa+C0vyEbJWqUcLMKV56eUqRCZr9MA==
X-Google-Smtp-Source: ABdhPJySAuOpV6dilUu/GNbZMtR+q2kM1vv4eGjjRdnlsLx632hTsZax7LCdUkUWwJqPAFjX2AzrVEdSEI0IuaThf9s=
X-Received: by 2002:a4a:3015:: with SMTP id q21mr2381852oof.55.1598639035545;
 Fri, 28 Aug 2020 11:23:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200828085622.8365-1-chenyi.qiang@intel.com> <20200828085622.8365-3-chenyi.qiang@intel.com>
In-Reply-To: <20200828085622.8365-3-chenyi.qiang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 28 Aug 2020 11:23:43 -0700
Message-ID: <CALMp9eTDTeKQrCnYsSsMPF3-0N=GW7QPOQY8xg4oiCcmv8hgYA@mail.gmail.com>
Subject: Re: [PATCH 2/5] KVM: nVMX: Verify the VMX controls MSRs with the
 global capability when setting VMX MSRs
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
> When setting the nested VMX MSRs, verify it with the values in
> vmcs_config.nested_vmx_msrs, which reflects the global capability of
> VMX controls MSRs.
>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

You seem to have entirely missed the point of this code, which is to
prevent userspace from adding features that have previously been
removed for this vCPU (e.g as a side-effect of KVM_SET_CPUID).
