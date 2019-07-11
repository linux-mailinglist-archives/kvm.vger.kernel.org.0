Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7D4652A8
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 09:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbfGKHwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 03:52:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42122 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfGKHwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 03:52:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id j8so1046041wrj.9
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 00:52:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0eQT9U+ySDhN1Rp7c4eWQ7uBiGRgy3zkrcnHUZ9sazo=;
        b=Na9BJNPqhN5ecGeyNsU5h4vIs3b/QACpIYrMOEbet5zs5kOym9YJXV919gmkBUCqzs
         7fP4M51AQ4ZcVIjeUVv7F/3LxvnZ23Qwpdu/Ps+YzlaGiaMqvpBDaOce0cTqWE6AHdCw
         drAbXXwqPtP4HHP3Q+MgaMwEiS5BYNShrPeepA1SWCoknAPOcN4wZXENwTGMHPUroiff
         xlZGzuTSMvgTzTGRH2fXVqb2EEFOrHLqglYw0Kvlg9O42ux+ywZM6ux2zGUx5ceDM/u9
         0L4/ZPPRqlWf8V2C53yOEMOFtViKyr3EyzkluKraJHA7GYomZbeZg7sHl1GrVXrGmpzn
         PqnA==
X-Gm-Message-State: APjAAAXqO7xY/MW87/mIOxmtFefNy4hJ+SLUDLM23Xu3x9CnmSkLAuin
        BZ+pjx6AU6wOn9fKegE20HPK5jwcvwQ=
X-Google-Smtp-Source: APXvYqzczFDh0c/gcZge3Wef96/ux6nizriw1jHvvaR0X6MGlzhO9gsosffCTmt+HhncNDC8NZeZ6w==
X-Received: by 2002:adf:ed41:: with SMTP id u1mr3098151wro.162.1562831564315;
        Thu, 11 Jul 2019 00:52:44 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id f204sm5014690wme.18.2019.07.11.00.52.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 00:52:43 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
To:     Alexander Graf <graf@amazon.com>,
        Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        kvmarm@lists.cs.columbia.edu
References: <20190710132724.28350-1-graf@amazon.com>
 <20190710180235.25c54b84@donnerap.cambridge.arm.com>
 <35e19306-d31b-187b-185d-e783f8d5a51a@redhat.com>
 <1537a9f2-9d23-97dd-b195-8239b263d5db@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c88eb2e-b401-42c7-f04f-2162f26af32c@redhat.com>
Date:   Thu, 11 Jul 2019 09:52:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1537a9f2-9d23-97dd-b195-8239b263d5db@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/19 07:49, Alexander Graf wrote:
>> I agree that it would belong more in qtest, but tests in not exactly the
>> right place is better than no tests.
> 
> The problem with qtest is that it tests QEMU device models from a QEMU
> internal view.

Not really: fundamentally it tests QEMU device models with stimuli that
come from another process in the host, rather than code that runs in a
guest.  It does have hooks into QEMU's internal view (mostly to
intercept interrupts and advance the clocks), but the main feature of
the protocol is the ability to do memory reads and writes.

> I am much more interested in the guest visible side of things. If
> kvmtool wanted to implement a PL031, it should be able to execute the
> same test that we run against QEMU, no?

Well, kvmtool could also implement the qtest protocol; perhaps it should
(probably as a different executable that shares the device models with
the main kvmtool executable).  There would still be issues in reusing
code from the QEMU tests, since it has references to QEMU command line
options.

> If kvm-unit-test is the wrong place for it, we would probably want to
> have a separate testing framework for guest side unit tests targeting
> emulated devices.
> 
> Given how nice the kvm-unit-test framework is though, I'd rather rename
> it to "virt-unit-test" than reinvent the wheel :).

Definitely, or even just "hwtest". :)  With my QEMU hat I would prefer
the test to be a qtest, but with my kvm-unit-tests hat on I see no
reason to reject this test.  Sorry if this was not clear.

Paolo
