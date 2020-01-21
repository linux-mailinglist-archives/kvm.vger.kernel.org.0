Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD3F144031
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 16:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgAUPKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 10:10:36 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20928 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727059AbgAUPKg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 10:10:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579619434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dLNqv137Ty3zBX/5Bsp+2Ypr44jpbB2i9ogizbwLSF8=;
        b=drrf4QMBHxXoWg9WgIWiKbODi9TGWBjJwEZfUWwDozvERW3WSBiWvM7OXQyKnrXZgdfuIv
        8w5MbK3xLKzOfvoYzQYU2zoirJcP7Qw1mNuKq7UaAz9nuduakJFA+djTRlD+l6FAPnAKbF
        0m1jiK/Pmm4lbJlE0u/vp0pJagiIZhM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-epkIWMoFOLKDwokYkGL6Xg-1; Tue, 21 Jan 2020 10:10:33 -0500
X-MC-Unique: epkIWMoFOLKDwokYkGL6Xg-1
Received: by mail-wm1-f72.google.com with SMTP id c4so730008wmb.8
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 07:10:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dLNqv137Ty3zBX/5Bsp+2Ypr44jpbB2i9ogizbwLSF8=;
        b=jHiv8L2nyZq2Qu0Zq0u3NLMpl8MIJFaTegx1bPU2tjfUc1khKRnVZHi7z4rg72/2oH
         ukfmVwHz+7NtW0CN4I0VuRmsEFCEbKLILqwd6j/YpKeBiKVR/rLc9Tej7NxJYIePGJd+
         5e4uDxs47sJAresYc4WynY/ndScybs5a74t5Spb/XLKwF+WEMW0tYJNU05fLLv5hdX/k
         Q1kLkNvjTZ3JoevL9MFBYYJ+ZuDOuqIJTXbHlOSDek3rQrF1cGbDa5hES9dug3LI4WIX
         LPmJkyZ/O3W2iDdstw46MrzT+gsRnzYOmobUr/SXM9tt41Jyx3yU8/fsBeQoGl4JSisj
         GWIQ==
X-Gm-Message-State: APjAAAV/ipCPY+58Ip6tm5FUoTdy+TTJMjdW9qYf/FzkfrNi2SKyHqld
        ohbUyopqzBiZo2UVQ8o4/XQzPKstn2orxDXqwlZoanyZCEGW3BeDWhX1Ab81rqAln8gUt0vepzz
        lmPD6dRo6wouP
X-Received: by 2002:a5d:484d:: with SMTP id n13mr5658176wrs.420.1579619431916;
        Tue, 21 Jan 2020 07:10:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqxxEyxfwVY/ROHiQo6nFEJMG0NaKySaBG+B/YnTEdUCo5yvn8VFW7mI2ukJg01QncMPDMI9zQ==
X-Received: by 2002:a5d:484d:: with SMTP id n13mr5658133wrs.420.1579619431579;
        Tue, 21 Jan 2020 07:10:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id h2sm53828069wrv.66.2020.01.21.07.10.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 07:10:31 -0800 (PST)
Subject: Re: [PATCH 00/14] KVM: x86/mmu: Huge page fixes, cleanup, and DAX
To:     Barret Rhoden <brho@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
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
        David Hildenbrand <david@redhat.com>,
        Jason Zeng <jason.zeng@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
 <e3e12d17-32e4-84ad-94da-91095d999238@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d7d0801b-79be-a5e7-a376-abd92b5c09b2@redhat.com>
Date:   Tue, 21 Jan 2020 16:10:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <e3e12d17-32e4-84ad-94da-91095d999238@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/01/20 20:47, Barret Rhoden wrote:
> Hi -
> 
> On 1/8/20 3:24 PM, Sean Christopherson wrote:
>> This series is a mix of bug fixes, cleanup and new support in KVM's
>> handling of huge pages.  The series initially stemmed from a syzkaller
>> bug report[1], which is fixed by patch 02, "mm: thp: KVM: Explicitly
>> check for THP when populating secondary MMU".
>>
>> While investigating options for fixing the syzkaller bug, I realized KVM
>> could reuse the approach from Barret's series to enable huge pages for
>> DAX
>> mappings in KVM[2] for all types of huge mappings, i.e. walk the host
>> page
>> tables instead of querying metadata (patches 05 - 09).
> 
> Thanks, Sean.  I tested this patch series out, and it works for me.
> (Huge KVM mappings of a DAX file, etc.).

Queued, thanks.

Paolo

