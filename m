Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBF40143FC9
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 15:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgAUOku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 09:40:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26896 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727508AbgAUOku (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 09:40:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579617648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JSSit0Wm+RQr1Jgst7x5naV4XKUyLXD3AhAyDv7TiYs=;
        b=Tj7tj63hMPU19wrJcoj1TH8CGkiDyBpUV3lfXKpgy2kY8apxYkEalVoHqja4B886ckbsla
        +UrtKNn3GJ1fSQym3X5fbjorDKM6/GCXAXtUvWlvrlsa02kmH+/vbw1UsKo+MhYL9VMKoa
        qtADOhqfqaNDHHfMIPqDxYy9/nL2ugM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-rVfezA-IM9yoEyaDz31ZXg-1; Tue, 21 Jan 2020 09:40:46 -0500
X-MC-Unique: rVfezA-IM9yoEyaDz31ZXg-1
Received: by mail-wr1-f72.google.com with SMTP id c6so1382878wrm.18
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 06:40:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JSSit0Wm+RQr1Jgst7x5naV4XKUyLXD3AhAyDv7TiYs=;
        b=ckNNqd1KHLbhPi/gXJbjQ09lSZLu5ogWHPAxU4cA2y64hz7cyBT8bHYxPaN9kGjY6F
         zKWnky5aB8YIIU7VQg6gno7JWonPfi0wNgaWKWdESaVusoS6KERaUuPYZnW3yb9i1Ama
         k1VtpQ81usmjKp5RDzRwJG7X++rzwQ1xHC5DqPTRS8QxNeacpPoGvQq7F/lrM5+n6RTZ
         dg44K1nqUX6Fdn5HCSm7jmgBNOlDeRbWB5ENcRoahE0uxV3gsq9QJP1dcTRty/pe7aW5
         7M2EAVeXkjZByMcNOzCTCY6jD0XBOZfUcgXRkTOHjd9mD+wi0JBN2ewDbhLPIWxD0asH
         QMIQ==
X-Gm-Message-State: APjAAAUMCTL08duazqVfq25SgARoZai0Eew0SXfSBaHUCzUfM7UgWRXc
        Sn/ygfFwOpeh+wVUpIfrTVmSBtFob0wOXfnA2G3TmkXK34Aj1QiKzJAb7z10Q7suWGv43AIhNha
        Mhz5wBReWq550
X-Received: by 2002:a7b:c851:: with SMTP id c17mr4596874wml.71.1579617645321;
        Tue, 21 Jan 2020 06:40:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqyUkg5d8MSonCO4Ge0L397jZ+4TsON4lVJzpAggAw2WjkJCWhAHkQt1Jw0IPvgT93BvWQD3aw==
X-Received: by 2002:a7b:c851:: with SMTP id c17mr4596848wml.71.1579617645022;
        Tue, 21 Jan 2020 06:40:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id b67sm4417502wmc.38.2020.01.21.06.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 06:40:44 -0800 (PST)
Subject: Re: [PATCH 07/14] KVM: x86/mmu: Walk host page tables to find THP
 mappings
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Barret Rhoden <brho@google.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Zeng <jason.zeng@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
 <20200108202448.9669-8-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6e9987a2-c34f-362d-a123-7dc4849811d1@redhat.com>
Date:   Tue, 21 Jan 2020 15:40:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200108202448.9669-8-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/20 21:24, Sean Christopherson wrote:
> +
> +	/*
> +	 * Manually do the equivalent of kvm_vcpu_gfn_to_hva() to avoid the
> +	 * "writable" check in __gfn_to_hva_many(), which will always fail on
> +	 * read-only memslots due to gfn_to_hva() assuming writes.  Earlier
> +	 * page fault steps have already verified the guest isn't writing a
> +	 * read-only memslot.
> +	 */
> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +	if (!memslot_valid_for_gpte(slot, true))
> +		return PT_PAGE_TABLE_LEVEL;
> +
> +	hva = __gfn_to_hva_memslot(slot, gfn);
> +

Using gfn_to_memslot_dirty_bitmap is also a good excuse to avoid
kvm_vcpu_gfn_to_hva.

+	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, true);
+	if (!slot)
+		return PT_PAGE_TABLE_LEVEL;
+
+	hva = __gfn_to_hva_memslot(slot, gfn);

(I am planning to remove gfn_to_hva_memslot so that __gfn_to_hva_memslot
can lose the annoying underscores).

Paolo

