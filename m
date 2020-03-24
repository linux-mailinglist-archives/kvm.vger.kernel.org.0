Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E4519028F
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 01:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbgCXAMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 20:12:16 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39484 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbgCXAMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 20:12:16 -0400
Received: by mail-io1-f65.google.com with SMTP id c19so16342964ioo.6
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 17:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Frtkek3ERXBMHbMs52Wt6U/vIOFGM5o4rI98r+84Zvs=;
        b=lXJcxWQki4RLClZml8Uw1p+iCf3elgEZQ2BtbaWtCNm1C9BhktBTPbc1u0UC+Jc/Hn
         9i3RcocLtEXdzm5Jj6dRfLKDnJ88IWUkFHFcfsaevwXH+e2m4A0u0dLIUrRPekJEPlUR
         a8jwh6/Et+DysEHpmcULQ7m/0JfZSHRpxiVbOmMMn9Z54MJEZYzx9409Cke7Kvm5W+YV
         jpgdlPhbqqoX+69GZisysMSNsXD1aMg68XiM7VC34eBRh4KRZGi0P0HLNtPjn1XXK3ed
         nS06qZ3is+xYDLAM0kT0P5DY6GF0B8Aob0NHAYPJhNYMciUK6sjrXNVNuuIYM36HGUSw
         pMYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Frtkek3ERXBMHbMs52Wt6U/vIOFGM5o4rI98r+84Zvs=;
        b=cEf7h/Mm9IjWeFuSI/hrz6AXhrIuoulodKEMopkYGORad44pMsYoYYM3ho3DTpsAV+
         4ze8xxmdIz9Kmsn3yaGvitkZstaxTbO7kdSk+Z7Q5zIF0XBiibUZs1VwP5wuKVOk2s6N
         Bj1xIiq4zpaUdJUB9iq3USuQB6pBUDm/cYVpNkVdZIxJ3iCETKQznPw2nnMdv3l1i3JP
         1p6IkKeBENOiFnhRjXzpjNLMW7qDUpsvJKy2Pj0iv+vpyH/4u6F9kHqvXz2T/TuqUaZa
         /TOxR1Eyoqkh3NpuzAWS4FsO6VzRoXVLKJMD6sK7LfFvRyyWKJB08oA1zNWA3v8lzMcz
         Y0zQ==
X-Gm-Message-State: ANhLgQ35giXSagHygkELI7gnNKnN44hiqiGeHt+s0U5Ag/5Yj7wM/OLa
        lHZTsqP3dwO8FaSlgfeBi7LX5x0qbbjLIaRmIA+Jcw==
X-Google-Smtp-Source: ADFU+vs4T4owZbp9NLgLiyMN+JqDFKJAzoNdh7TqSfJJEEkuFCgXdRh0KDDS5vdk0H/LlQPyZnmJEXu4ihoSzeyHN6k=
X-Received: by 2002:a02:5a87:: with SMTP id v129mr21018278jaa.48.1585008735321;
 Mon, 23 Mar 2020 17:12:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-4-sean.j.christopherson@intel.com> <CALMp9eR5Uu7nRDOS2nQHGzb+Gi6vjDEk1AmuiqkkGWFjKNG+sA@mail.gmail.com>
 <20200323162807.GN28711@linux.intel.com> <CALMp9eR42eM7g81EgHieyNky+kP2mycO7UyMN+y2ibLoqrD2Yg@mail.gmail.com>
 <20200323164447.GQ28711@linux.intel.com> <8d99cdf0-606a-f4df-35e7-3b856bb3ea0e@redhat.com>
In-Reply-To: <8d99cdf0-606a-f4df-35e7-3b856bb3ea0e@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 23 Mar 2020 17:12:04 -0700
Message-ID: <CALMp9eQ-rzdZHdM0DFzVyaynEhf0+e9rYGqi57fhN54VTFcNnA@mail.gmail.com>
Subject: Re: [PATCH v3 03/37] KVM: nVMX: Invalidate all EPTP contexts when
 emulating INVEPT for L1
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 4:51 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/03/20 17:44, Sean Christopherson wrote:
> > So I think
> >
> >   Fixes: 14c07ad89f4d ("x86/kvm/mmu: introduce guest_mmu")
> >
> > would be appropriate?
> >
>
> Yes.

I think it was actually commit efebf0aaec3d ("KVM: nVMX: Do not flush
TLB on L1<->L2 transitions if L1 uses VPID and EPT").
