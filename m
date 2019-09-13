Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B30EB22CF
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 17:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390368AbfIMPBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 11:01:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388170AbfIMPBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 11:01:30 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E842A69086
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 15:01:29 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id m9so5579158wrs.13
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 08:01:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zuzwEhDdM8nFD/eqeUMdkZbahAvWuck1YuH/cdNiv9o=;
        b=PjxXhMbxa+xSYoXxLItV6eH6SJvgk/3UwuGViptFDFGpHPLloerz7KikrWse4dg4BB
         WFko1n0aCobLTo85rLUXxZGU8Dexc4HDdiMe9kpH0JFRIBvvNsfAIe3fPw68Oh0kJ47j
         LY/aaHfHJoVS5FbbV2BgW+tAt8lzgjlDFtdyhSficwa9k97bwgPVfDX1CzY436a0Y9ba
         6qaoL2QuX0bzq+RORTdXHu0hQpkAwFkog8J5PnjZrxjMQZ400t6w2BG3vFPq6wR0usOg
         pjldtopUR+3wSThHKYKAGm1WEcQfZdsEkQe0hq0icJ+9MPIajYv4DTPaMRSTnmelPcBT
         QtJA==
X-Gm-Message-State: APjAAAURRaWIfkbDx/fvyLzSLKPZDrS00IU+jyF1dWcbblIf+pmey72B
        +OiBysWCVtoSMq0kQ5uZptRQO0FsD5u3xbwDhoWGLyfpaNPZcyAw1iJ6P07kY2vztcTm5bvGeM5
        DODnLMIoTYw0m
X-Received: by 2002:a1c:c013:: with SMTP id q19mr3447798wmf.87.1568386884926;
        Fri, 13 Sep 2019 08:01:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxVmkhicWbX9sM2V6LPnr+xLUUrZU9HvAJMzAOfyJJVoRtNarvooFR4sjG8yibYs2ccdb68wg==
X-Received: by 2002:a1c:c013:: with SMTP id q19mr3447762wmf.87.1568386884662;
        Fri, 13 Sep 2019 08:01:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c5d2:4bb2:a923:3a9a? ([2001:b07:6468:f312:c5d2:4bb2:a923:3a9a])
        by smtp.gmail.com with ESMTPSA id y15sm1949532wmj.32.2019.09.13.08.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Sep 2019 08:01:24 -0700 (PDT)
Subject: Re: KASAN: slab-out-of-bounds Read in handle_vmptrld
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        bp@alien8.de, carlo@caione.org, catalin.marinas@arm.com,
        devicetree@vger.kernel.org, hpa@zytor.com, jmattson@google.com,
        joro@8bytes.org, khilman@baylibre.com,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, narmstrong@baylibre.com,
        rkrcmar@redhat.com, robh+dt@kernel.org,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, wanpengli@tencent.com, will.deacon@arm.com,
        x86@kernel.org,
        syzbot <syzbot+46f1dd7dbbe2bfb98b10@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        USB list <linux-usb@vger.kernel.org>
References: <000000000000a9d4f705924cff7a@google.com>
 <87lfutei1j.fsf@vitty.brq.redhat.com>
 <5218e70e-8a80-7c5f-277b-01d9ab70692a@redhat.com>
 <20190913044614.GA120223@kroah.com>
 <db02a285-ad1d-6094-6359-ba80e6d3f2e0@redhat.com>
 <20190913130226.GB403359@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6a0ec3a2-2a52-f67a-6140-e0a60874538a@redhat.com>
Date:   Fri, 13 Sep 2019 17:01:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190913130226.GB403359@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/19 15:02, Greg Kroah-Hartman wrote:
> Look at linux-next, we "should" have fixed up hcd_buffer_alloc() now to
> not need this type of thing.  If we got it wrong, please let us know and
> then yes, a fix like this would be most appreciated :)

I still see

	/* some USB hosts just use PIO */
	if (!hcd_uses_dma(hcd)) {
		*dma = ~(dma_addr_t) 0;
		return kmalloc(size, mem_flags);
	}

in linux-next's hcd_buffer_alloc and also in usb.git's usb-next branch.
 I also see the same

	if (remap_pfn_range(vma, vma->vm_start,
			virt_to_phys(usbm->mem) >> PAGE_SHIFT,
			size, vma->vm_page_prot) < 0) {
		...
	}

in usbdev_mmap.  Of course it's possible that I'm looking at the wrong
branch, or just being dense.

Paolo
