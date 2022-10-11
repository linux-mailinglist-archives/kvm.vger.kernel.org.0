Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262085FBA27
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 20:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiJKSM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 14:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiJKSMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 14:12:54 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C738D631FE
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:12:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 189-20020a2516c6000000b006bbbcc3dd9bso14165500ybw.15
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pJ1O6Zcaa2IIxNgt2jgqe8lBQXZrKkCVTsjWXN2AggU=;
        b=rFOa/Qh8cHtvsq8C/9y/QaHu+MMCxVTNO2aBHLrfLoVjmNHd1UYKGhO1p0efl5RrKp
         vUXhUxns40uUx6NgwXrfIpqQCy64ZGYDB9r/bLR7laZNbLpBbXoQ3J8chBac9MO1COIv
         OXuEzPsOQ8gBD9Qee04vR19AEJEzzr6QyV+XYKsyUJGWYgY+vlsGYDnAeal3rj0mGfZW
         p91FOgxOiMenaojujKrEDTMzPh6XBbNZ7046UWh/F2zw7B68h7EtmkR5PA6e6QWs+Hio
         4TnoovEle2mkoPz5Wr2A2fyTYlHBt0Kh8pL+njUn5YyEaxNSaRp/Y0i1VpjalGG0k8Qw
         5WZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pJ1O6Zcaa2IIxNgt2jgqe8lBQXZrKkCVTsjWXN2AggU=;
        b=Dm9p0kl/Sgu+Czl81aa58JUKGUzxk4i1MaZM46eCM6ujHhYiPmTIPtof8HEOdhF5vl
         PvTp2bC16Ze9quFezdlx2BxKTSB+tZv01bSLWfS+TAJoV6Z1SOZqpHapX4HjwaorW5Z1
         RzllTswrUtDybpFuk4e252o8XMhQIshEI9BqrPk9KBLamOMnRc8AE0P2xKAEOOQlOwRd
         nW5lxKcbxCuAl/MAsPmgbfWdEkQNWzCDqxcC0DvyAqUGTu2nm0s8M/wsUQRjYU/v3wDv
         nz9uU+3CHn/ezjrZdItjeiMhaKzUILP2fcEFDI9ciko4f1NvMia6K6bif3HuC5dTsK8/
         DQqQ==
X-Gm-Message-State: ACrzQf0r0u9HrpGlUtyvlUzRPcJBMm9zTHMPA+ISskPyPn1eQUD0jTnr
        rzUfVlAds3txkd6Z3JLNZegk7znt+EGODSvn2Q==
X-Google-Smtp-Source: AMsMyM456eRDZ/31H6blpjFLNSHBEpHVKOEyiBIUP0qTFBJE24v91e6VGJCiZkbssU82RKMNQPmkBt1tsoKEo6wWZw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:11d0:0:b0:35b:dd9f:5358 with SMTP
 id 199-20020a8111d0000000b0035bdd9f5358mr22980219ywr.401.1665511973131; Tue,
 11 Oct 2022 11:12:53 -0700 (PDT)
Date:   Tue, 11 Oct 2022 18:12:52 +0000
In-Reply-To: <Y0CVmS9rydRbdFkN@google.com> (message from Sean Christopherson
 on Fri, 7 Oct 2022 21:09:45 +0000)
Mime-Version: 1.0
Message-ID: <gsntedve2pqz.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6 3/3] KVM: selftests: randomize page access order
From:   Colton Lewis <coltonlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com,
        andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Sep 12, 2022, Colton Lewis wrote:
>> @@ -57,7 +58,17 @@ void perf_test_guest_code(uint32_t vcpu_id)

>>   	while (true) {
>>   		for (i = 0; i < pages; i++) {
>> -			uint64_t addr = gva + (i * pta->guest_page_size);
>> +			guest_random(&rand);
>> +
>> +			if (pta->random_access)
>> +				addr = gva + ((rand % pages) * pta->guest_page_size);

> Shouldn't this use a 64-bit random number since "pages" is a 64-bit  
> value?  Ha!
> And another case where the RNG APIs can help, e.g.


Do we need to test with memory chunks that have over 2^32 pages to
choose from? That's 16 TiB of memory. Possible a computer might have
that much to dedicate to a VM, but what would be the use of such a test?

>> +
>> +			/*
>> +			 * Use a new random number here so read/write
>> +			 * is not tied to the address used.
>> +			 */
>>   			guest_random(&rand);

> Ya, I'm trippling (quadrupling?) down on my suggestion to improve the  
> APIs.  Users
> should not be able to screw up like this, i.e. shouldn't need comments to  
> warn
> readers, and adding another call to get a random number shouldn't affect  
> unrelated
> code.

Previous calls to PRNGs always affect later calls to PRNGs. That's how
they work. This "screw up" would be equally likely with any API because
the caller always needs to decide if they should reuse the same random
number or need a new one.
