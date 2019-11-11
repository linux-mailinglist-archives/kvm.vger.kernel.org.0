Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE348F7FA1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 20:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfKKTPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 14:15:34 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24754 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726949AbfKKTPd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 14:15:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573499731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=MXbL31P0IYDtqcq6qHdukj+j63qKz90Nd8tCQFpdhYo=;
        b=W9Q/wl5RythjsovedCR4QlakcHKmubbn310hqH6IkGmmPnfvDM4/P40WRRgGrZfyckePde
        V2YshzJjVE5o8TPbee1rSf+shfmNCKy/pEfKttSxc7EiBNKe7sfyx12uuYJKVzpOLxrP6Z
        nMrMo/Xpfssyv4pTtk4Bqn6rTvCcRW4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-yNhbjAOXPFy1_P5wuvEBlA-1; Mon, 11 Nov 2019 14:15:28 -0500
Received: by mail-wr1-f71.google.com with SMTP id h7so10278144wrb.2
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 11:15:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MXbL31P0IYDtqcq6qHdukj+j63qKz90Nd8tCQFpdhYo=;
        b=D3NGHOHhQ6bW1Xz7R1l5isC/g8dSEKusNgXPpguPntiaUopqvC1OuCSjzM+zlLfPnL
         dm3e4310wylN6UHTZUI/3hbOp4CMIUdvftsE9aSPvVW2cOmHj4xIRkvBC1P2qVZqgqvE
         Ff/Jm8iBIk5Fh9VDmCiUgrS3GKBV9o7MxexTxdJbRr32N9o5UfjJ7wqsIvRAlE/zyF4j
         5pQ11LPz5At0Dk3G1QIZJ6hbSoctmTsQQXIzc03KUqAgpq2riPU5fPM2C2kALbwzS7jZ
         fHlyI+Ke7/oMsGpB++y6iVzXhb7j1L/ipj8XBj4T39lRK+AEh6F3v5Zb4Hpqpo71Nc10
         otCg==
X-Gm-Message-State: APjAAAXUHwHcKXVyE7iy/SWgIh8WeUH6IJq2yZ3ngTlK5OXcQBdOSktl
        jU2k3wsv5K5YRAmVGm5cJJtAWFN1WFyUIF+/8CbbGRIoTKKG8FZdwVlNqHajk08YUKcVGLuly8x
        /ibyPbaS2Quni
X-Received: by 2002:adf:9786:: with SMTP id s6mr16010297wrb.188.1573499727514;
        Mon, 11 Nov 2019 11:15:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqwMA0iXMYBtSAK6xNIx73LEz/q0H0IE8ruho9T5MZSF3Oq1lrSQVESW1HPGLguBk1ORuT4PRw==
X-Received: by 2002:adf:9786:: with SMTP id s6mr16010258wrb.188.1573499726976;
        Mon, 11 Nov 2019 11:15:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8c9d:1a6f:4730:367c? ([2001:b07:6468:f312:8c9d:1a6f:4730:367c])
        by smtp.gmail.com with ESMTPSA id b17sm17965088wru.36.2019.11.11.11.15.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 11:15:26 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: MMU: Do not treat ZONE_DEVICE pages as being
 reserved
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>
References: <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com>
 <CAPcyv4hMOxPDKAZtTvWKEMPBwE_kPrKPB_JxE2YfV5EKkKj_dQ@mail.gmail.com>
 <20191106233913.GC21617@linux.intel.com>
 <CAPcyv4jysxEu54XK2kUYnvTqUL7zf2fJvv7jWRR=P4Shy+3bOQ@mail.gmail.com>
 <CAPcyv4i3M18V9Gmx3x7Ad12VjXbq94NsaUG9o71j59mG9-6H9Q@mail.gmail.com>
 <0db7c328-1543-55db-bc02-c589deb3db22@redhat.com>
 <CAPcyv4gMu547patcROaqBqbwxut5au-WyE_M=XsKxyCLbLXHTg@mail.gmail.com>
 <20191107155846.GA7760@linux.intel.com>
 <20191109014323.GB8254@linux.intel.com>
 <CAPcyv4hAY_OfExNP+_067Syh9kZAapppNwKZemVROfxgbDLLYQ@mail.gmail.com>
 <20191111182750.GE11805@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <707ce7d4-7149-f4c4-c150-801962a3197d@redhat.com>
Date:   Mon, 11 Nov 2019 20:15:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111182750.GE11805@linux.intel.com>
Content-Language: en-US
X-MC-Unique: yNhbjAOXPFy1_P5wuvEBlA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 19:27, Sean Christopherson wrote:
>> Thanks for this clarification. I do want to put out though that
>> ZONE_DEVICE pages go idle, they don't get freed. As long as KVM drops
>> its usage on invalidate it's perfectly fine for KVM to operate on idle
>> ZONE_DEVICE pages. The common case is that ZONE_DEVICE pages are
>> accessed and mapped while idle. Only direct-I/O temporarily marks them
>> busy to synchronize with invalidate. KVM obviates that need by
>> coordinating with mmu-notifiers instead.
> Only the KVM MMU, e.g. page fault handler, coordinates via mmu_notifier,
> the kvm_vcpu_map() case would continue using pages across an invalidate.

Yes, and it gets/puts the page correctly.

Paolo

