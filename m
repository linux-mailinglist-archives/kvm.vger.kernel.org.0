Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91565177C07
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgCCQhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:37:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47307 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728497AbgCCQhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 11:37:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583253457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m/ZeDpXicreEUdZsIrFx+xNBNktO+QHj/8L3lsHUiAY=;
        b=Z5h+5q0g/HbQXVeSbaGY8AJiHpV2iGbt9Rt5zbtXZudAr7jIOAgK3gZOfwPA0xiSBa9AVs
        d5r6rS/CEpoG1fI7Sm52uDGb8OBizk16eHMUpWAO+O+4CmBu3zlW6+b0p8/uns4D3w57ns
        jR3g+/75JMSeHoPM53r+HKW8vNPs71E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-96lt53XxPGGTg9Q7Hqm5nQ-1; Tue, 03 Mar 2020 11:37:36 -0500
X-MC-Unique: 96lt53XxPGGTg9Q7Hqm5nQ-1
Received: by mail-wm1-f70.google.com with SMTP id q20so888479wmg.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 08:37:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m/ZeDpXicreEUdZsIrFx+xNBNktO+QHj/8L3lsHUiAY=;
        b=UC6fi+EYi+bNDeNCSCnvCX15qYU1gIDXm4/nEsiw6DZXeWGW8rvDIu2+J4SwRKKPn3
         uFtzu8HCSxysZ90MbXPIHgAK6TO0Yx9Qx6QWYQacUEvv2WTiGm2fNMUp1cDXVPfcR78+
         qQJKhkrpBDCrS6PhHiJLU5eSBA9CdjP349XacYZTmlZJKxBbGuh5u3kO7fSY9TDoScng
         iF5gFc9QdbuWRvjihN5uR2nUWkn0HY7zWNmBoKhq/itTXyi6SCFl+UzxjywbYA15Le0t
         dH3zX6t5zaPD7TSyXN5BvSF3T+5FShWlaQ2M9d1XYps3rCh6PNHtfWh+WuEePnrkgp88
         9O/w==
X-Gm-Message-State: ANhLgQ1/Ztl3ty6j76zlr8LmmyBgdQq3gJlfv/5rNmEl2YZwpVr2ZNCD
        7KGWuZIwXv20AhAJkSLhC2i7CTLIEbKjKAElwDbY69Xm9vkTIgHcqAmFv/QfT+Ho4CVXb+oPehD
        tUn1KQ5tBF5aY
X-Received: by 2002:a05:600c:280b:: with SMTP id m11mr2555444wmb.93.1583253455064;
        Tue, 03 Mar 2020 08:37:35 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsPDqMEjkm6g4/BYmqiljcMv4+VVa/WPH9gF0EnpbOgCkqiHN1ZDAbIRGgQjqKgCsa1fXCfHA==
X-Received: by 2002:a05:600c:280b:: with SMTP id m11mr2555430wmb.93.1583253454831;
        Tue, 03 Mar 2020 08:37:34 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id h10sm4892868wml.18.2020.03.03.08.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 08:37:34 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: x86: clear stale x86_emulate_ctxt->intercept
 value
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Bandan Das <bsd@redhat.com>, Oliver Upton <oupton@google.com>,
        linux-kernel@vger.kernel.org
References: <20200303143316.834912-1-vkuznets@redhat.com>
 <20200303143316.834912-2-vkuznets@redhat.com>
 <4f933f77-6924-249a-77c5-3c904e7c052b@redhat.com>
 <87zhcxe6qe.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <99fc27f9-bf89-7db1-d333-1433ebfa4e89@redhat.com>
Date:   Tue, 3 Mar 2020 17:37:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87zhcxe6qe.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 17:35, Vitaly Kuznetsov wrote:
>>
>> "f3 a5" is a "rep movsw" instruction, which should not be intercepted
>> at all.  Commit c44b4c6ab80e ("KVM: emulate: clean up initializations in
>> init_decode_cache") reduced the number of fields cleared by
>> init_decode_cache() claiming that they are being cleared elsewhere,
>> 'intercept', however, is left uncleared if the instruction does not have
>> any of the "slow path" flags (NotImpl, Stack, Op3264, Sse, Mmx, CheckPerm,
>> NearBranch, No16 and of course Intercept itself).
> Much better, thanks) Please let me know if you want me to resubmit.

No need, thanks.

Paolo

