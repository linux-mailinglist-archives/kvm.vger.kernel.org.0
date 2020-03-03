Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02226177D72
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 18:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgCCR3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 12:29:36 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56484 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727440AbgCCR3f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 12:29:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583256575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OrfJnMYXSp8JuLlI51btEW+NHNdpcFTSzHFKKNkjZ3g=;
        b=A/Rc2cZL8ekexL98p2j0M0lsyyKddR0wltaCmHtHcGk7JZWPgy3pxCZh45AeA5RIKm7Bom
        HbxSje6Gm+3Q/3WPbYCMVdzOsZZXblfawHl9UFDoCFmZvuWxborkJTqQVyS3IG/FJ7elu+
        HMxO5dvU6G+9RD7ME40lWwQApfCxjcI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-juCibk9vPuKZJGnM0t6blA-1; Tue, 03 Mar 2020 12:29:33 -0500
X-MC-Unique: juCibk9vPuKZJGnM0t6blA-1
Received: by mail-wr1-f69.google.com with SMTP id q18so1539054wrw.5
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 09:29:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OrfJnMYXSp8JuLlI51btEW+NHNdpcFTSzHFKKNkjZ3g=;
        b=R8oN2LM42ZbfRI58E2kWwn9LcIKega/Txi3g7/c08lpHqkbDcIdQ448R8aofEhzuH/
         Rcz+DBZHvlpXsq+JCggfEs8lVbybSTSh2NE8h0ZaZBvkZ1StpwJ+mEzvup5HYVBqH8gt
         SFG0bnt4nWXrDQKUTdxYnNvTUM75vL7IYVkSglC0q8CmYu4Cd3BL7dmTtBf/lrK+U6p0
         7jEPMHZopcwBvh6uVb3JKsnqu5IDUMhot/MIJ/mMUgFB0v/ykmVWBrMLLEcFtFyPRCwR
         YyS9k3gyV3Zk8WEsb8j6os3aq+YKdv8SSiVbI7gz2RgWJfOkjoiyPxxh9+8UE2LsJ4aC
         tLyg==
X-Gm-Message-State: ANhLgQ2+X4+M5qg2OThaTrs2clDAfAUcr/e1X/JRU1I+Ubjd+0lrot9r
        b5Dv+Nn1fCoXUACHhn4AZrHcafXGS5g5f7m5FNomgqWNFCAUhachgaouEs+5y13bpyBS8Ri1x+U
        eSHThCxMAl4Bd
X-Received: by 2002:adf:ab4e:: with SMTP id r14mr6584102wrc.350.1583256572436;
        Tue, 03 Mar 2020 09:29:32 -0800 (PST)
X-Google-Smtp-Source: ADFU+vupGdoUnfoghBjUL1FIu3d71GoeGRPzgmv5uLVuiDEfNO0XORZcpwr/9jEOAVGm1kpiW/5Fyw==
X-Received: by 2002:adf:ab4e:: with SMTP id r14mr6584088wrc.350.1583256572246;
        Tue, 03 Mar 2020 09:29:32 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id n8sm33290957wrm.46.2020.03.03.09.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 09:29:31 -0800 (PST)
Subject: Re: [PATCH v2 06/13] KVM: x86: Refactor emulate tracepoint to
 explicitly take context
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
 <20200218232953.5724-7-sean.j.christopherson@intel.com>
 <8736axjmte.fsf@vitty.brq.redhat.com> <20200303164813.GL1439@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2f3f7aff-2bd0-fa62-4b66-9f90f125e44e@redhat.com>
Date:   Tue, 3 Mar 2020 18:29:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303164813.GL1439@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 17:48, Sean Christopherson wrote:
>>>  	TP_fast_assign(
>>>  		__entry->csbase = kvm_x86_ops->get_segment_base(vcpu, VCPU_SREG_CS);
>> This seems the only usage of 'vcpu' parameter now; I checked and even
>> after switching to dynamic emulation context allocation we still set
>> ctxt->vcpu in alloc_emulate_ctxt(), can we get rid of 'vcpu' parameter
>> here then (and use ctxt->vcpu instead)?
> Hmm, ya, not sure what I was thinking here.
> 

As long as we have one use of vcpu, I'd rather skip this patch and
adjust patch 8 to use "->".  Even the other "explicitly take context"
parts are kinda debatable since you still have to do emul_to_vcpu.
Throwing a handful of

- 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
+ 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;

into patch 8 is not bad at all and limits the churn.

Paolo

