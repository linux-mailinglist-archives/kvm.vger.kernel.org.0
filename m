Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAE721BC77
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 19:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgGJRlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 13:41:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25540 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728269AbgGJRlb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 13:41:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594402890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7T4TcT2qNwd8q//O8oeeKh44NiN7UalnMtay1RITTRY=;
        b=gqZnUZmjM2Fe/lT5G3swUzgeTIQsfDOiRI/HRNfwlY6opG0Q9ftbQvZunTZmajzvnGr/VD
        gHSqnY+2AYA2+CbONUypNhqEIHuCr3qS9yUjZuekwwI7rDtO78f4znfTKOpD9KPLK7iMxc
        BVbocoi4KfhfHuqFwvqU7FHlAdEUBTU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-5unx3Ol-Ne2ltdexCHnN7w-1; Fri, 10 Jul 2020 13:41:28 -0400
X-MC-Unique: 5unx3Ol-Ne2ltdexCHnN7w-1
Received: by mail-wr1-f72.google.com with SMTP id v3so6720832wrq.10
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 10:41:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7T4TcT2qNwd8q//O8oeeKh44NiN7UalnMtay1RITTRY=;
        b=FuzNaYqYcnMPtVrBQ4UQWPday1DyFm95X+AzWsqDPxQgB9/9yUTanZHPRvd65DBiPo
         aUlp2GvNUVQHYpOQLVdKMlhROjCmy6TRP/LktJNHIgX3XNqqFmovx3GdHjHmV2hSlKnt
         cgSoVwb78IaYlUqVmHyU9UDZBrYrfz2CuPWMBeIJG7+0UK18j2OzpFvlkPcHahzpC2L6
         TLF6T1fbWH5uFgWpGf+Nff1XrKhTXpgl5oQ67wD4nhZDlCEQwVczy6t6RBZMAUNxYfIu
         p/MRmWdulN47h3d2d7tnHE6EHDl+fK7SQocy9gDuT/Pft3ufWImFpN9Z3BuaeNNFxKvA
         fyFw==
X-Gm-Message-State: AOAM530csi3RYYuA54O3COOirfyyTocniXPYD86PC7H8sn5DDh6SNGe3
        nFy+zAsT1NJ3HOBKK54/QFCA/yTTWm5cKe3XXVmm2/xjaXHXhcKrxyb5Gp7NKdq+O2GyMEQ7TTv
        jztbArBvYGSnm
X-Received: by 2002:adf:ded2:: with SMTP id i18mr69328394wrn.109.1594402887029;
        Fri, 10 Jul 2020 10:41:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwrtPwmb9f55CL4HZe2X7qWuIbLQhQOjCKYpZfEsOm39uG7VPPyBFZshHpOp8qjLfKKI0zQQ==
X-Received: by 2002:adf:ded2:: with SMTP id i18mr69328381wrn.109.1594402886824;
        Fri, 10 Jul 2020 10:41:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id j14sm11250889wrs.75.2020.07.10.10.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 10:41:26 -0700 (PDT)
Subject: Re: [PATCH v3 3/9] KVM: x86: mmu: Add guest physical address check in
 translate_gpa()
To:     Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
References: <20200710154811.418214-1-mgamal@redhat.com>
 <20200710154811.418214-4-mgamal@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2cb33bf8-f4f9-6a5b-ca72-d2dbcafc436d@redhat.com>
Date:   Fri, 10 Jul 2020 19:41:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200710154811.418214-4-mgamal@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/20 17:48, Mohammed Gamal wrote:
> In case of running a guest with 4-level page tables on a 5-level page
> table host, it might happen that a guest might have a physical address
> with reserved bits set, but the host won't see that and trap it.
> 
> Hence, we need to check page faults' physical addresses against the guest's
> maximum physical memory and if it's exceeded, we need to add
> the PFERR_RSVD_MASK bits to the PF's error code.
> 
> Also make sure the error code isn't overwritten by the page table walker.
> 

New commit message:


    KVM: x86: mmu: Add guest physical address check in translate_gpa()
    
    Intel processors of various generations have supported 36, 39, 46 or 52
    bits for physical addresses.  Until IceLake introduced MAXPHYADDR==52,
    running on a machine with higher MAXPHYADDR than the guest more or less
    worked, because software that relied on reserved address bits (like KVM)
    generally used bit 51 as a marker and therefore the page faults where
    generated anyway.
    
    Unfortunately this is not true anymore if the host MAXPHYADDR is 52,
    and this can cause problems when migrating from a MAXPHYADDR<52
    machine to one with MAXPHYADDR==52.  Typically, the latter are machines
    that support 5-level page tables, so they can be identified easily from
    the LA57 CPUID bit.
    
    When that happens, the guest might have a physical address with reserved
    bits set, but the host won't see that and trap it.  Hence, we need
    to check page faults' physical addresses against the guest's maximum
    physical memory and if it's exceeded, we need to add the PFERR_RSVD_MASK
    bits to the page fault error code.
    
    This patch does this for the MMU's page walks.  The next patches will
    ensure that the correct exception and error code is produced whenever
    no host-reserved bits are set in page table entries.

Paolo

