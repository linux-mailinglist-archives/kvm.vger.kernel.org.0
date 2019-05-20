Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CA22329D
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 13:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733019AbfETLdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 07:33:32 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43484 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733015AbfETLdb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 07:33:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id r4so14157200wro.10
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 04:33:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7yhZpsDUhANl2Z2Dw10e3o+cyHg6NesHSnxHIjr6nRg=;
        b=mhxXgxQEN4i6XMHT4UGMegb1s1dD8866dnQh6xaNpUplc6GA+wbe6AFc21TKZzLOfF
         LNaxL9ntMbQ+ciZUBes+p9i3FqDaKrSs/k/sVCAyCMvpYE5YhWv5I8JVlMIIxYz4RAsO
         BcNe2pmhgQLTDXSmPKHki0xkbpRknd3ZsNJerZbNBAFSU1CoBl0dJ40tb85+Xmnwst9U
         qWskPjAHuTvuR0D+llQ+ICBhR5hkVTccL0bzZ90YqMNVPOm7JNPAg8epCcBM1hmhNg2d
         PJjQHbUtVhQfVk/rq9hrWE1835V4BYdFIrmQBJ0E6RI+v3vHBHOJcn7esQIVMyUtkmGd
         XHyA==
X-Gm-Message-State: APjAAAUaq/Ukj6IQSFBY3i7QIB/R0V9rQGLy1HfParvI8HYS01q3ZAOq
        3g/VYjvS2wcVI+k6Tx8uE2y2dw==
X-Google-Smtp-Source: APXvYqwvNe9RKnRbqyhGMHN2J8QriyDrZzVPw1rR8tiyL92RyU7WMYn5vjJxKdYvlKh9B9swK89fww==
X-Received: by 2002:adf:8306:: with SMTP id 6mr32920357wrd.155.1558352010019;
        Mon, 20 May 2019 04:33:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id z20sm20168646wmf.14.2019.05.20.04.33.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 04:33:29 -0700 (PDT)
Subject: Re: [PATCH v4 4/5] KVM: LAPIC: Delay trace advance expire delta
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
References: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
 <1558340289-6857-5-git-send-email-wanpengli@tencent.com>
 <b80a0c3b-c5b1-bfd1-83d7-ace3436b230e@redhat.com>
 <CANRm+CyDpA-2j28soX9si5CX3vFadd4_BASFzt1f4FbNNNDzyw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bd60e5c2-e3c5-80fc-3a1d-c75809573945@redhat.com>
Date:   Mon, 20 May 2019 13:33:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CANRm+CyDpA-2j28soX9si5CX3vFadd4_BASFzt1f4FbNNNDzyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 13:22, Wanpeng Li wrote:
>>
>> We would like to move wait_lapic_expire() just before vmentry, which would
>> place wait_lapic_expire() again inside the extended quiescent state.  Drop
>> the tracepoint, but add instead another one that can be useful and where
>> we can check the status of the adaptive tuning procedure.
> https://lkml.org/lkml/2019/5/15/1435
> 
> Maybe Sean's comment is reasonable, per-vCPU debugfs entry for
> adaptive tuning and wait_lapic_expire() tracepoint for hand tuning.

Hmm, yeah, that makes sense.  The location of the tracepoint is a bit
weird, but I guess we can add a comment in the code.

Paolo
