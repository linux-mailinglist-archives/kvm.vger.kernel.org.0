Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B410D3398
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 23:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfJJVnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 17:43:03 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46638 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJJVnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 17:43:03 -0400
Received: by mail-io1-f68.google.com with SMTP id c6so17016641ioo.13
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 14:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cgBbezehA3ikP9oZRce9D/NdIFW9A/2nwCHvWz1qbio=;
        b=PXWibDixpgKJCby0TQFLHsZui075Akm20g2TmZP0MeUZu3m3TF2pxyJ6S0YjeAMB9k
         BNLlTLTKCcnK4fLg9rTzwLxxAE8f37HmurDGiwgHD846Eire0Z+6V97ptIkKb/Pw4WZQ
         JMSVx2LWoEFLhcZvxaggKnTPoNhmm0x/mCblauI4fbockAsXT2GtwizjO/RPdB2iPzPS
         KoZHu81rUu/NoB97BqerCDfp1ZwOIMHhsBzYxM9zAkAV+QumBorRWlW1Ui1MYMHgBs/t
         nAw0lKVjeuQqcj4TsSy+XCp6RuzzXuEk81yruvFRraHNrYc2NHN3gVLwcB8XqkwJAEMe
         fjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cgBbezehA3ikP9oZRce9D/NdIFW9A/2nwCHvWz1qbio=;
        b=sIK6diNWbrpp8Lw4t0olDFNa+zT0Kmt8UDKLKDzIbJCSuzNiPGhciEEX7a63ZmCKoE
         LqTXzJEw4c14ljG9h/8D1+Pf2j/EdLJogB7JQ086lfzkuDI3nEgFJWFr1LceJQCdZ/9O
         J/giYt3IrjA+SUU0VtSP57BXMA15Arw/Kjd+5jwqa2S8cz70JLLspqwYDOIaThGu8KBi
         Fh5CGHOK8RukQsrE+Zejmtr11y1wYl0h9KJuesZxeqMmoK/rTeXvxVZ70JyqHrdyS9qQ
         YUa+xEfvwUr0FwZpvsPUh3KTYwcp106rJYs8epjFoRaG3vLHyO578ho0/MnPegfs5WHH
         f4Bw==
X-Gm-Message-State: APjAAAXndXMNCFKnlJu2IuYI6YVxeVeSn3523cl+RPmI7inakKev7cRB
        gJBIDLKCCUFMkdiGSTcHWwJw6i6DhNtaMGvNe6eG6g==
X-Google-Smtp-Source: APXvYqzyL4eIxkMFi6sg1vb8I0p+Byp7KJS0VWOUTKHzD3FfxdDEDF/ndhyoviKqw/bxI8kk0ZY7KIOYr8HJSACfp78=
X-Received: by 2002:a5d:9057:: with SMTP id v23mr1741177ioq.119.1570743782188;
 Thu, 10 Oct 2019 14:43:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190917085304.16987-1-weijiang.yang@intel.com>
In-Reply-To: <20190917085304.16987-1-weijiang.yang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 10 Oct 2019 14:42:51 -0700
Message-ID: <CALMp9eSTz+XbmLtWZLqWvSNjjb4Ado4s+SfABtRuVNQBXUHStQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/9] Enable Sub-page Write Protection Support
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        yu.c.zhang@intel.com, alazar@bitdefender.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 1:52 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> EPT-Based Sub-Page write Protection(SPP)is a HW capability which allows
> Virtual Machine Monitor(VMM) to specify write-permission for guest
> physical memory at a sub-page(128 byte) granularity. When this
> capability is enabled, the CPU enforces write-access check for sub-pages
> within a 4KB page.
>
> The feature is targeted to provide fine-grained memory protection for
> usages such as device virtualization, memory check-point and VM
> introspection etc.
>
> SPP is active when the "sub-page write protection" (bit 23) is 1 in
> Secondary VM-Execution Controls. The feature is backed with a Sub-Page
> Permission Table(SPPT), SPPT is referenced via a 64-bit control field
> called Sub-Page Permission Table Pointer (SPPTP) which contains a
> 4K-aligned physical address.
>
> To enable SPP for certain physical page, the gfn should be first mapped
> to a 4KB entry, then set bit 61 of the corresponding EPT leaf entry.
> While HW walks EPT, if bit 61 is set, it traverses SPPT with the guset
> physical address to find out the sub-page permissions at the leaf entry.
> If the corresponding bit is set, write to sub-page is permitted,
> otherwise, SPP induced EPT violation is generated.

How do you handle sub-page permissions for instructions emulated by kvm?
