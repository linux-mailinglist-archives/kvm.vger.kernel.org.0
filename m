Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954926101F0
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 21:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbiJ0ToI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 15:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236684AbiJ0ToF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 15:44:05 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6928380BF7
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 12:44:03 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id z15-20020a5e860f000000b006c09237cc06so1939893ioj.21
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 12:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7ku/5CsX6n22rlRfR+h/Xq5Kz+EHNDlvp71Dyi/bUeg=;
        b=ATv4vWrI7VmhkXElyscy6UYYRB/i3/zuPhKYo+hSGv8umVyhrb9OiMaei2ex4lNWDQ
         BsuYepK7tyDKpyjKBB5NqmLxSd7q92+ba32ArJI69bLGkCgClVo2ihGBgOMpbk50zxUs
         SsAPVmKNwRkZbgVxHPFPS52Xxf8ZAcfrNbVJmE+4nQzN11F+gZHUuRJZCbdGeEhaCbro
         bib1DnkzD4O7z5/MsfP7cZ1mN9anMGekTawJVZ3S/kYmtX1YEKxzUPOfEuMrmX4igC3C
         a3B3JnFbUbiPINqi9br8NzrsNTHbbu3/Hi+BP/gKIxTvX5weadxMWAFJ3KM8CTYb0FVg
         YslQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7ku/5CsX6n22rlRfR+h/Xq5Kz+EHNDlvp71Dyi/bUeg=;
        b=uUwHbmZzMJM0j0Uz8qFLiRQT1yRXB5icX0hH0BO7MIN7d0XUods50gMjUGRNQG9uI5
         +B6JXBjBl8qyJ01nISgNigI7lGyevrAjGAKCTT9vKPbtr6NwIOObS8l5Gii0rKuPUs0O
         tGD+OkYUD/pfebOmdpE214IHXeXDpv9rBIPIPmr47dTWN244jTI/Ihz1npR5BpkkZb5J
         QfkiXjtBeo0VIi7t9Tm4sgv/nGI54tFPR/lI9vKKfPv46K28z+YLnbjlgAKx+yBK8LiJ
         M5RNd4iQT8K5iCGX4oDrEj4q3zfiHxWJd0N2uqsNuPXokXWyLjQWqpN+zr0F8Vp53nPn
         Edbg==
X-Gm-Message-State: ACrzQf2tTSV4HxFrVn7PyJkmdcJpVqdVwA7Z4hUsAdrkB18HNbH+yK5n
        rwjaZlDx+pibUPFsmsC82tEowEsc36kueMNtEA==
X-Google-Smtp-Source: AMsMyM6TsVwGY7kMwKgbIjqw7/SQgMkOxA3SRckyMmgh3BD+cyb66jjwuzJxKR96emR2eNRUgibF9oiy2kW7qnOurg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:b884:0:b0:363:bc3b:775c with SMTP
 id p4-20020a02b884000000b00363bc3b775cmr33998985jam.300.1666899842890; Thu,
 27 Oct 2022 12:44:02 -0700 (PDT)
Date:   Thu, 27 Oct 2022 19:44:02 +0000
In-Reply-To: <Y1mi34Qq5oQhzswU@google.com> (message from Sean Christopherson
 on Wed, 26 Oct 2022 21:13:03 +0000)
Mime-Version: 1.0
Message-ID: <gsntwn8l127x.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v7 3/3] KVM: selftests: randomize page access order
From:   Colton Lewis <coltonlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com
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

> On Wed, Oct 19, 2022, Colton Lewis wrote:
>> @@ -422,11 +426,15 @@ int main(int argc, char *argv[])

>>   	guest_modes_append_default();

>> -	while ((opt = getopt(argc, argv, "eghi:p:m:nb:v:or:s:x:w:")) != -1) {
>> +	while ((opt = getopt(argc, argv, "aeghi:p:m:nb:v:or:s:x:w:")) != -1) {
>>   		switch (opt) {
>> +		case 'a':
>> +			p.random_access = true;
>> +			break;
>>   		case 'e':
>>   			/* 'e' is for evil. */
>>   			run_vcpus_while_disabling_dirty_logging = true;
>> +			break;

> Heh, I appreciate the fix for my bug, but this belongs in a separate  
> patch.
> Isolating bug fixes isn't exactly critical for selftests, but it does  
> matter.
> E.g. Vipin also has an in-flight patch to fix this, and isolating the fix  
> makes
> it easier on maintainers to resolve the conflicts between the two series.

> [*]  
> https://lore.kernel.org/all/20221021211816.1525201-2-vipinsh@google.com

Unintentional, I had a conflict there and assumed there was a break
there.

Will take it out.
