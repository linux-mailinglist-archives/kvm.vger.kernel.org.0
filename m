Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF9210FF79
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 14:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfLCN7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 08:59:20 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56516 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbfLCN7U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Dec 2019 08:59:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575381558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SoDHsKfGXaF4SVOK9FpzJoN4EZym00SZYVVw6Skh79M=;
        b=chVjacX/hFt18fAxFTtUazoUhzjNbOdB4uBt3/bR+5o8mzok6sQqzZN/Qr7ng/ycEnChsg
        H8mfksroNV+3eO517PLIeGM2NLVKmm951Aty9nUQbxJTmYctcnG90+CzPQqOOL23KRIlpa
        WYpXCmLpo6Dv2TZyxX2xlfvug8LwbIA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-NMLXEeB6PJi1HxTseFBmng-1; Tue, 03 Dec 2019 08:59:17 -0500
Received: by mail-wr1-f69.google.com with SMTP id z15so1843128wrw.0
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 05:59:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SoDHsKfGXaF4SVOK9FpzJoN4EZym00SZYVVw6Skh79M=;
        b=RFeUMb3lgGvFyC4hueT9cwMBhpPYvFGHEOUpdlcx+1PakMm6i2jeAPdPe61QXb1Ljq
         4MysHfURgV1YEzJwGMDtwBgqm0xtZjbRqo3Q+RFbof6lnhPJnx7srxswOK324lnU62GA
         fTdgM2oWkZPPd/KFQV1Dm+DXFWUOrOUlsSvhaTKlbCSA3gIavtUuBabiKB7sk0vaxSuz
         bwDcXZiugv1mD3bXFsmYKePNX6z3KkHw/sQhSoxRfUI7Rurgw4n2EHBEIdpBYDvU1OnA
         CJnHtXxyC0W4zj9fZTMjyjjMubgEXNet5EEcxp4mLrBGa5py7cYoNkMSqYg6rpUoZeqQ
         tP3A==
X-Gm-Message-State: APjAAAWt1Mmj4oQDDcYmaKgXaIHHl4zlMmPdo6ORX4xpc5BC7qeuDRan
        SRyIjrl3u5Ho8jokJV3AD8dCtuX37ssoY3g7zYB7F+mmtIM2+yVL9VbqXxCctgmtQjMUaCfbUsA
        B7ldy4n/CnEBT
X-Received: by 2002:a1c:9cce:: with SMTP id f197mr28970908wme.133.1575381556176;
        Tue, 03 Dec 2019 05:59:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqwNaGQEu1cfoctJHTQunT9pwM3nITR9w5ShT2vg8Npr4Cp5hfb8lnoJ1/v1m+J+ydgbO3E4VA==
X-Received: by 2002:a1c:9cce:: with SMTP id f197mr28970883wme.133.1575381555838;
        Tue, 03 Dec 2019 05:59:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id d12sm3629784wrp.62.2019.12.03.05.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2019 05:59:15 -0800 (PST)
Subject: Re: [PATCH RFC 00/15] KVM: Dirty ring interface
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <b8f28d8c-2486-2d66-04fd-a2674b598cfd@redhat.com>
 <20191202021337.GB18887@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b893745e-96c1-d8e4-85ec-9da257d0d44e@redhat.com>
Date:   Tue, 3 Dec 2019 14:59:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191202021337.GB18887@xz-x1>
Content-Language: en-US
X-MC-Unique: NMLXEeB6PJi1HxTseFBmng-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/19 03:13, Peter Xu wrote:
>> This is not needed, it will just be a false negative (dirty page that
>> actually isn't dirty).  The dirty bit will be cleared when userspace
>> resets the ring buffer; then the instruction will be executed again and
>> mark the page dirty again.  Since ring full is not a common condition,
>> it's not a big deal.
> 
> Actually I added this only because it failed one of the unit tests
> when verifying the dirty bits..  But now after a second thought, I
> probably agree with you that we can change the userspace too to fix
> this.

I think there is already a similar case in dirty_log_test when a page is
dirty but we called KVM_GET_DIRTY_LOG just before it got written to.

> I think the steps of the failed test case could be simplified into
> something like this (assuming the QEMU migration context, might be
> easier to understand):
> 
>   1. page P has data P1
>   2. vcpu writes to page P, with date P2
>   3. vmexit (P is still with data P1)
>   4. mark P as dirty, ring full, user exit
>   5. collect dirty bit P, migrate P with data P1
>   6. vcpu run due to some reason, P was written with P2, user exit again
>      (because ring is already reaching soft limit)
>   7. do KVM_RESET_DIRTY_RINGS

Migration should only be done after KVM_RESET_DIRTY_RINGS (think of
KVM_RESET_DIRTY_RINGS as the equivalent of KVM_CLEAR_DIRTY_LOG).

>   dirty_log_test-29003 [001] 184503.384328: kvm_entry:            vcpu 1
>   dirty_log_test-29003 [001] 184503.384329: kvm_exit:             reason EPT_VIOLATION rip 0x40359f info 582 0
>   dirty_log_test-29003 [001] 184503.384329: kvm_page_fault:       address 7fc036d000 error_code 582
>   dirty_log_test-29003 [001] 184503.384331: kvm_entry:            vcpu 1
>   dirty_log_test-29003 [001] 184503.384332: kvm_exit: reason EPT_VIOLATION rip 0x40359f info 582 0
>   dirty_log_test-29003 [001] 184503.384332: kvm_page_fault:       address 7fc036d000 error_code 582
>   dirty_log_test-29003 [001] 184503.384332: kvm_dirty_ring_push:  ring 1: dirty 0x37f reset 0x1c0 slot 1 offset 0x37e ret 0 (used 447)
>   dirty_log_test-29003 [001] 184503.384333: kvm_entry:            vcpu 1
>   dirty_log_test-29003 [001] 184503.384334: kvm_exit:             reason EPT_VIOLATION rip 0x40359f info 582 0
>   dirty_log_test-29003 [001] 184503.384334: kvm_page_fault:       address 7fc036e000 error_code 582
>   dirty_log_test-29003 [001] 184503.384336: kvm_entry:            vcpu 1
>   dirty_log_test-29003 [001] 184503.384336: kvm_exit:             reason EPT_VIOLATION rip 0x40359f info 582 0
>   dirty_log_test-29003 [001] 184503.384336: kvm_page_fault:       address 7fc036e000 error_code 582
>   dirty_log_test-29003 [001] 184503.384337: kvm_dirty_ring_push:  ring 1: dirty 0x380 reset 0x1c0 slot 1 offset 0x37f ret 1 (used 448)
>   dirty_log_test-29003 [001] 184503.384337: kvm_dirty_ring_exit:  vcpu 1
>   dirty_log_test-29003 [001] 184503.384338: kvm_fpu:              unload
>   dirty_log_test-29003 [001] 184503.384340: kvm_userspace_exit:   reason 0x1d (29)
>   dirty_log_test-29000 [006] 184503.505103: kvm_dirty_ring_reset: ring 1: dirty 0x380 reset 0x380 (used 0)
>   dirty_log_test-29003 [001] 184503.505184: kvm_fpu:              load
>   dirty_log_test-29003 [001] 184503.505187: kvm_entry:            vcpu 1
>   dirty_log_test-29003 [001] 184503.505193: kvm_exit:             reason EPT_VIOLATION rip 0x40359f info 582 0
>   dirty_log_test-29003 [001] 184503.505194: kvm_page_fault:       address 7fc036f000 error_code 582              <-------- [1]
>   dirty_log_test-29003 [001] 184503.505206: kvm_entry:            vcpu 1
>   dirty_log_test-29003 [001] 184503.505207: kvm_exit:             reason EPT_VIOLATION rip 0x40359f info 582 0
>   dirty_log_test-29003 [001] 184503.505207: kvm_page_fault:       address 7fc036f000 error_code 582
>   dirty_log_test-29003 [001] 184503.505226: kvm_dirty_ring_push:  ring 1: dirty 0x381 reset 0x380 slot 1 offset 0x380 ret 0 (used 1)
>   dirty_log_test-29003 [001] 184503.505226: kvm_entry:            vcpu 1
>   dirty_log_test-29003 [001] 184503.505227: kvm_exit:             reason EPT_VIOLATION rip 0x40359f info 582 0
>   dirty_log_test-29003 [001] 184503.505228: kvm_page_fault:       address 7fc0370000 error_code 582
>   dirty_log_test-29003 [001] 184503.505231: kvm_entry:            vcpu 1
>   ...
> 
> The test was trying to continuously write to pages, from above log
> starting from 7fc036d000. The reason 0x1d (29) is the new dirty ring
> full exit reason.
> 
> So far I'm still unsure of two things:
> 
>   1. Why for each page we faulted twice rather than once.  Take the
>      example of page at 7fc036e000 above, the first fault didn't
>      trigger the marking dirty path, while only until the 2nd ept
>      violation did we trigger kvm_dirty_ring_push.

Not sure about that.  Try enabling kvmmmu tracepoints too, it will tell
you more of the path that was taken while processing the EPT violation.

If your machine has PML, what you're seeing is likely not-present
violation, not dirty-protect violation.  Try disabling pml and see if
the trace changes.

>   2. Why we didn't get the last page written again after
>      kvm_userspace_exit (last page was 7fc036e000, and the test failed
>      because 7fc036e000 detected change however dirty bit unset).  In
>      this case the first write after KVM_RESET_DIRTY_RINGS is the line
>      pointed by [1], I thought it should be a rewritten of page
>      7fc036e000 because when the user exit happens logically the write
>      should not happen yet and eip should keep.  However at [1] it's
>      already writting to a new page.

IIUC you should get, with PML enabled:

- guest writes to page
- PML marks dirty bit, causes vmexit
- host copies PML log to ring, causes userspace exit
- userspace calls KVM_RESET_DIRTY_RINGS
  - host marks page as clean
- userspace calls KVM_RUN
  - guest writes again to page

but the page won't be in the ring until after another vmexit happens.
Therefore, it's okay to reap the pages in the ring asynchronously, but
there must be a synchronization point in the testcase sooner or later,
where all CPUs are kicked out of KVM_RUN.  This synchronization point
corresponds to the migration downtime.

Thanks,

Paolo

