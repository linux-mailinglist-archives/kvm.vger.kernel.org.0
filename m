Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043C8D88EF
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 09:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389398AbfJPHHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 03:07:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47652 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388897AbfJPHHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 03:07:41 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D9CAEC0546F1
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 07:07:40 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id m16so559223wmg.8
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 00:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N+9zhD6sQkjtyZn9LozIr63oV0xoTG40KqwCVlYDKHM=;
        b=NB8Q9dnGri6NNaPbPEwwkgsqUfSUBtxc5GFjtcETEDOn7/fXio7K6FXdx+/MOC44Dx
         mOwwFczuZcZKnyz+c6BBeGiUYM0YMS2G5N7AjYD1iqMJT1lMqSBrRW48/9yfP2qRIOMH
         cF37GNz59p6EKExh+tG3smQpaNs107agkuIAkz0Z2j6f46LPOT/YEUV9ZtBxxUV9bbi9
         ioJ4HGiZleoY7L6iYjoZJd6tEynfCfLGJGokklvIKkewZdr6IXCjEy1HnbvtkN/iSM04
         zI2LiKB0lyYRQ008M8i6uJe/nNI+3rZ/oNHRI4T2VcNSUDlQI4s5ZARd9DRIa4HE4YgV
         weZA==
X-Gm-Message-State: APjAAAUHVl/GdDbHSofU+QCL54yucZkPwpk3aPAMiYSCojqGA5Gz2Ya+
        VLciILStNwy3vNTLr4slv3ax5fTeH80FyTzPffE/bIwPgfCP+1Wyn70MuntAQctcUnuwDIUmnxx
        vX4C1V3aTPHy0
X-Received: by 2002:adf:8295:: with SMTP id 21mr1239229wrc.14.1571209659466;
        Wed, 16 Oct 2019 00:07:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxoZ2u9pyRAua6Ul/ChncLAqQBC2pUX3xcLpP8/GnoCUcKnPgyeub7C/seFKjjOj2y3m+oRsg==
X-Received: by 2002:adf:8295:: with SMTP id 21mr1239207wrc.14.1571209659089;
        Wed, 16 Oct 2019 00:07:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id a9sm2047772wmf.14.2019.10.16.00.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 00:07:38 -0700 (PDT)
Subject: Re: [PATCH 12/14] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
 <20190928172323.14663-13-aarcange@redhat.com>
 <933ca564-973d-645e-fe9c-9afb64edba5b@redhat.com>
 <20191015164952.GE331@redhat.com>
 <870aaaf3-7a52-f91a-c5f3-fd3c7276a5d9@redhat.com>
 <20191015203516.GF331@redhat.com>
 <f375049a-6a45-c0df-a377-66418c8eb7e8@redhat.com>
 <20191015234229.GC6487@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <27cc0d6b-6bd7-fcaf-10b4-37bb566871f8@redhat.com>
Date:   Wed, 16 Oct 2019 09:07:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015234229.GC6487@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 01:42, Andrea Arcangeli wrote:
> On Wed, Oct 16, 2019 at 12:22:31AM +0200, Paolo Bonzini wrote:
>> Oh come on.  0.9 is not 12-years old.  virtio 1.0 is 3.5 years old
>> (March 2016).  Anything older than 2017 is going to use 0.9.
> 
> Sorry if I got the date wrong, but still I don't see the point in
> optimizing for legacy virtio. I can't justify forcing everyone to
> execute that additional branch for inb/outb, in the attempt to make
> legacy virtio faster that nobody should use in combination with
> bleeding edge KVM in the host.

Yet you would add CPUID to the list even though it is not even there in
your benchmarks, and is *never* invoked in a hot path by *any* sane
program? Some OSes have never gotten virtio 1.0 drivers.  OpenBSD only
got it earlier this year.

>> Your tables give:
>>
>> 	Samples	  Samples%  Time%     Min Time  Max time       Avg time
>> HLT     101128    75.33%    99.66%    0.43us    901000.66us    310.88us
>> HLT     118474    19.11%    95.88%    0.33us    707693.05us    43.56us
>>
>> If "avg time" means the average time to serve an HLT vmexit, I don't
>> understand how you can have an average time of 0.3ms (1/3000th of a
>> second) and 100000 samples per second.  Can you explain that to me?
> 
> I described it wrong, the bpftrace record was a sleep 5, not a sleep
> 1. The pipe loop was sure a sleep 1.

It still doesn't add up.  0.3ms / 5 is 1/15000th of a second; 43us is
1/25000th of a second.  Do you have multiple vCPU perhaps?

> The issue is that in production you get a flood more of those with
> hundred of CPUs, so the exact number doesn't move the needle.
> This just needs to be frequent enough that the branch cost pay itself off,
> but the sure thing is that HLT vmexit will not go away unless you execute
> mwait in guest mode by isolating the CPU in the host.

The number of vmexits doesn't count (for HLT).  What counts is how long
they take to be serviced, and as long as it's 1us or more the
optimization is pointless.

Consider these pictures

         w/o optimization                   with optimization
         ----------------------             -------------------------
0us      vmexit                             vmexit
500ns    retpoline                          call vmexit handler directly
600ns    retpoline                          kvm_vcpu_check_block()
700ns    retpoline                          kvm_vcpu_check_block()
800ns    kvm_vcpu_check_block()             kvm_vcpu_check_block()
900ns    kvm_vcpu_check_block()             kvm_vcpu_check_block()
...
39900ns  kvm_vcpu_check_block()             kvm_vcpu_check_block()

                            <interrupt arrives>

40000ns  kvm_vcpu_check_block()             kvm_vcpu_check_block()


Unless the interrupt arrives exactly in the few nanoseconds that it
takes to execute the retpoline, a direct handling of HLT vmexits makes
*absolutely no difference*.

>> Again: what is the real workload that does thousands of CPUIDs per second?
> 
> None, but there are always background CPUID vmexits while there are
> never inb/outb vmexits.
> 
> So the cpuid retpoline removal has a slight chance to pay for the cost
> of the branch, the inb/outb retpoline removal cannot pay off the cost
> of the branch.

Please stop considering only the exact configuration of your benchmarks.
 There are known, valid configurations where outb is a very hot vmexit.

Thanks,

Paolo
