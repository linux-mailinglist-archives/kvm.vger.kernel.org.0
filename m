Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C3C1046CF
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 00:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfKTXBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 18:01:15 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:45129 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfKTXBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 18:01:15 -0500
Received: by mail-il1-f195.google.com with SMTP id o18so1251749ils.12
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 15:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Py1RJehv66Laz4hT10AB0rCVAQDuppTFgL0wa3P1xA0=;
        b=l8yn17f4rhSif6/L/NfuqnusPrmQxW+8jJkgjupmHGTx+KYSekMFWNeJygLbuKxjb4
         JlZYKHXP+ngw2fujiQOtf9+23GkDliNZMjVzVunfK6XUgQvl29pqW+mYyzCOLlS0szz1
         k8CYer1qFs8ZO2K9jLguiieMMr3xvMm4SV+pX2cNBXsp+Ze3E4NgHUssu/Qh6z91Oovx
         gTQHkCErL+Xz7afpBYfc1iXrlyr86zr1vdpHxc0o3CLYKXiVUOGuqE7rfbw47yQYmmLI
         k1LAGgEqAu3goijmV5qi1YBzohm8qA0mDj1xyslD9PmfIBWgjG2ukGr4ZbsqjygM6FnA
         alsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Py1RJehv66Laz4hT10AB0rCVAQDuppTFgL0wa3P1xA0=;
        b=k42/yse68Wo3BVuuMWJTsLUjOULNMR24AdmINfsh4lsL0JmJLQ9CDDf9n8O/8OCbkk
         MWTKRrJydwO5WYD03NT8rAAxOBx62+Y4RBe7rY7IuB8miDNKKNNkitLO+25DBqK9YLjk
         En+FuC+x79zGIRHz2e7Eqg6dVZnRoD8rjmrizbrN9rWGYQfkBxOHRKCP6TssQrtTgUJ4
         JTnE6EIA46nMmOjGKWK4NuvF2H9/aHyIo9HgipSw6/aEtNT2oHysDPsOm4EmhUtjF4Mf
         wujCUVI0lh9/SDdDXJkaEq+FimHkRV4NSgzFM5RqeKyF1yByv6o7vBy8Z+8REU2V0BQk
         VAZA==
X-Gm-Message-State: APjAAAV7n+bs627Ibxkt55+N5oSDuoVniHudWnz8p0JMa1CAU05nVHpE
        smBnzo8xKOQE8614c5h26fVKTE6vpe2SEMN3zycMuA==
X-Google-Smtp-Source: APXvYqxtw9ja/9+ohda5x5+wdUB9V4piGp4h2Tn+zHbugHlJ8a1jJiqNrPSIuCQRmQU51cQ9vK0PmZ0umHVaskQM1ec=
X-Received: by 2002:a92:8983:: with SMTP id w3mr6870062ilk.108.1574290872328;
 Wed, 20 Nov 2019 15:01:12 -0800 (PST)
MIME-Version: 1.0
References: <20191120223147.63358-1-liran.alon@oracle.com>
In-Reply-To: <20191120223147.63358-1-liran.alon@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 20 Nov 2019 15:01:01 -0800
Message-ID: <CALMp9eQhxEa-gUvcH1_Z1bcL-R0mo=FT4pULR0_SAffY2qB1mw@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Do not mark vmcs02->apic_access_page as dirty
 when unpinning
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 20, 2019 at 2:32 PM Liran Alon <liran.alon@oracle.com> wrote:
>
> vmcs->apic_access_page is simply a token that the hypervisor puts into
> the PFN of a 4KB EPTE (or PTE if using shadow-paging) that triggers
> APIC-access VMExit or APIC virtualization logic whenever a CPU running
> in VMX non-root mode read/write from/to this PFN.
>
> As every write either triggers an APIC-access VMExit or write is
> performed on vmcs->virtual_apic_page, the PFN pointed to by
> vmcs->apic_access_page should never actually be touched by CPU.
>
> Therefore, there is no need to mark vmcs02->apic_access_page as dirty
> after unpin it on L2->L1 emulated VMExit or when L1 exit VMX operation.
>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
