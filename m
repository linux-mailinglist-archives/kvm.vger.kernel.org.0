Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B999D177D3F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 18:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbgCCRVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 12:21:19 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53589 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729148AbgCCRVT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 12:21:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583256077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EaOtamWYiIuWCFawzzm58ZC3ME+A1/wF1UexKFuk2I8=;
        b=dLmD+f2rRUx6csX6sE3L57i6T/exPWdWotfaCdIDdmH1qsemttXTk16GeEYuY3ZfMojaPA
        4MM4KcX3K4nCL9eqwwfJvaKl+egspcou3FYi6B25ZEplgFnrmL3CU4cGs7gSD3Dw3v+2o7
        fTA9j5VE+KqfSBHuXSd9gwpQWcMhca4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-WzMSRAKaNzyR_Hle1d8ftQ-1; Tue, 03 Mar 2020 12:21:16 -0500
X-MC-Unique: WzMSRAKaNzyR_Hle1d8ftQ-1
Received: by mail-wr1-f70.google.com with SMTP id t14so1519267wrs.12
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 09:21:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EaOtamWYiIuWCFawzzm58ZC3ME+A1/wF1UexKFuk2I8=;
        b=brQS64Et/aGZS8v8jdARP2lcLHa8onbbD6LkU6wg4zkr9TsvmgxedLmg6Q1EgmxVJB
         rCuJdolNrac7PjWgsR6sMsOeAFkdlpIMaIXmyzYUPN36v9oiBB9vDqmgPhsMM+KY6C4c
         d+w95arQNcKq7h7FpP89DEbKWNCLKAIOI9pKFC3dVAi65yLHp4UlcdunZ9MLz1Sx/ZbS
         EjKRVzimCBBDD4GYgeIwj2VdQc7vKq54+06nl0LXHVfNa2zbmCXdi6UTImSkgqciH1X5
         hDJdRsxPmS4uSgOBIieRT0btNDsxwDtVF+lwGxfCLzcBTiwOY/2/FQWP5C4mt6gqoF+s
         331w==
X-Gm-Message-State: ANhLgQ3nlieOuFNmSSJv+Kb6x8K2P37ktycapdKH5sVqi0SupFtEmmMN
        kCsmaDv5iTIGhb1IqDxCub6kzw7Mk2s0Ps2byjTIwMy3bhyec1OJyafr5a/mVxabI5HLz72CQUg
        aiR8BVVd6DmLD
X-Received: by 2002:a1c:4604:: with SMTP id t4mr2354707wma.164.1583256072714;
        Tue, 03 Mar 2020 09:21:12 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsthN0yjaliTomJLbLDve2Pd5f9/FT246y79qVZv8d+l722UQN2hFL5YW5TJVgnnYSW5Kqgyg==
X-Received: by 2002:a1c:4604:: with SMTP id t4mr2354680wma.164.1583256072516;
        Tue, 03 Mar 2020 09:21:12 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id j16sm34379932wru.68.2020.03.03.09.21.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 09:21:12 -0800 (PST)
Subject: Re: [PATCH 3/6] KVM: x86: Add dedicated emulator helper for grabbing
 CPUID.maxphyaddr
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-4-sean.j.christopherson@intel.com>
 <de2ed4e9-409a-6cb1-e295-ea946be11e82@redhat.com>
 <20200303162808.GJ1439@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a1b18b18-0bf5-7e7d-ffd9-be1a29609296@redhat.com>
Date:   Tue, 3 Mar 2020 18:21:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303162808.GJ1439@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 17:28, Sean Christopherson wrote:
>> I don't think this is a particularly useful change.  Yes, it's not
>> intuitive but is it more than a matter of documentation (and possibly
>> moving the check_cr_write snippet into a separate function)?
> 
> I really don't like duplicating the maxphyaddr logic.  I'm paranoid
> something will come along and change the "effective" maxphyaddr and we'll
> forget all about the emulator, e.g. SEV, TME and paravirt XO all dance
> around maxphyaddr.

Well, I'm paranoid about breaking everything else... :)

Adding a separate emulator_get_maxphyaddr function would at least
simplify grepping, since searching for 0x80000008 isn't exactly intuitive.

Paolo

