Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D24C5B275F
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 23:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390121AbfIMVjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 17:39:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389867AbfIMVjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 17:39:09 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 05F0B80F7C
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 21:39:09 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id f23so1734807wmh.9
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 14:39:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H/HgiF+ormPJec9ucKfvq3B1GbgLkHD6NvKq1m15REE=;
        b=pE06FOrf1+K8lMyWrTCWc9FSNRJQ+s4xR+HMe78K7pXW291F74s6YwurxdvupmeBUq
         0bUTN6Sh4hOlv2exOsPa/KyrvaDFJFLUVeyHiH4Nle9OM6xpdtjvw0IszApfXI7CIFzi
         /LBQvCBVmf5HywnMedwr+tyIysCJX95mFut+MLa0t8J0swI8nV3Ziuq3X34dpWAAZazO
         njHTHmsh+UCjg6L+sIsQFDZoBQkL//Xd1YQYdJnIiHkekHy8TexhZ92TzHkCeJNy/0cp
         L/R+NmwgZzSjnXoxQZa1CAmW7E86yp3HAyhB1nziGR4DXFimHNo05AACIVukUnmtwyzq
         YuwQ==
X-Gm-Message-State: APjAAAXXxbd06ga76FlG0U0wU4hLNj1JPuWau99B2wwJSJiBadjDchvt
        AVrZ5Z3vpx0TL9AiMcYXiQx1gB35thIa79jy+KlHq7CYHb78DquYGFLKsWQu2O0HhPjIzkdIdD1
        f35g5b102j84m
X-Received: by 2002:a1c:a54a:: with SMTP id o71mr5188546wme.51.1568410747388;
        Fri, 13 Sep 2019 14:39:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx8xng5YAyNbwPHIzedIu8ZCTqFN32yL3gtxtyPP/chrRkzUD4Hr9V7c5rHI5vdwgEV7dIuVQ==
X-Received: by 2002:a1c:a54a:: with SMTP id o71mr5188535wme.51.1568410747142;
        Fri, 13 Sep 2019 14:39:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3166:d768:e1a7:aab8? ([2001:b07:6468:f312:3166:d768:e1a7:aab8])
        by smtp.gmail.com with ESMTPSA id n2sm2788701wmc.1.2019.09.13.14.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Sep 2019 14:39:06 -0700 (PDT)
Subject: Re: KASAN: slab-out-of-bounds Read in handle_vmptrld
To:     Robin Murphy <robin.murphy@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     mark.rutland@arm.com, x86@kernel.org, wanpengli@tencent.com,
        kvm@vger.kernel.org, narmstrong@baylibre.com,
        catalin.marinas@arm.com, will.deacon@arm.com, hpa@zytor.com,
        khilman@baylibre.com, joro@8bytes.org, rkrcmar@redhat.com,
        mingo@redhat.com, Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+46f1dd7dbbe2bfb98b10@syzkaller.appspotmail.com>,
        devicetree@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        robh+dt@kernel.org, bp@alien8.de,
        linux-amlogic@lists.infradead.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, jmattson@google.com,
        USB list <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        carlo@caione.org, Vitaly Kuznetsov <vkuznets@redhat.com>
References: <000000000000a9d4f705924cff7a@google.com>
 <87lfutei1j.fsf@vitty.brq.redhat.com>
 <5218e70e-8a80-7c5f-277b-01d9ab70692a@redhat.com>
 <20190913044614.GA120223@kroah.com>
 <db02a285-ad1d-6094-6359-ba80e6d3f2e0@redhat.com>
 <20190913130226.GB403359@kroah.com>
 <6a0ec3a2-2a52-f67a-6140-e0a60874538a@redhat.com>
 <462660f4-1537-cece-b55f-0ceba0269eb8@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a85cee75-99f9-7de3-6e5c-86f9bb41bca5@redhat.com>
Date:   Fri, 13 Sep 2019 23:39:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <462660f4-1537-cece-b55f-0ceba0269eb8@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/19 17:32, Robin Murphy wrote:
> Oh, that bit of usbdev_mmap() is already known to be pretty much totally
> bogus for various reasons - there have been a few threads about it, of
> which I think [1] is both the most recent and the most informative.
> There was another patch[2], but that might have stalled (and might need
> reworking with additional hcd_uses_dma() checks anyway).

Neither is enough, see my reply to Alan.  Memory from kmalloc just
*cannot* be passed down to remap_pfn_range, dma_mmap_coherent or
anything like that.  It's a simple alignment issue.

Paolo
