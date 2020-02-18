Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14E78162AA3
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 17:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbgBRQbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 11:31:11 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56655 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726557AbgBRQbJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Feb 2020 11:31:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582043469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1wux/ShdRZLS6eqfJ1i2bb+05bcGXuWlAmnT6X3Ge3Y=;
        b=e2zwp3M0doguu5zBs08IxyVx/WlV6jSmV+OyqiO1oHFvm9Hyg9+FqL0liHoGptD2Hp2ZMV
        182RbtHRwwkyQqwpaJrpE7AQGDiteNdPmyX2O52Jyr4BgumoLiSNwHgaKqQ399IoY9gHt9
        hRucxEFNdA1CjETJnYVGUMqp8Di0fJQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-rlZi1ZgUNh2Osi-u5HJYvQ-1; Tue, 18 Feb 2020 11:31:06 -0500
X-MC-Unique: rlZi1ZgUNh2Osi-u5HJYvQ-1
Received: by mail-wr1-f70.google.com with SMTP id a12so11087898wrn.19
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 08:31:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1wux/ShdRZLS6eqfJ1i2bb+05bcGXuWlAmnT6X3Ge3Y=;
        b=BFFI9cXZVkLT71IdQiQq/ZCB7e7Lc7HnIZc2COnmsY5BWF8q6J7I9nT8dRt81toQCn
         X20bsyQ2VDNGUNzM7r8K7+eqR4FIRMOPG+JFn+38nhuo7uqEgaR5iuEv87PEB2ppfGOJ
         xUFjrZzj6yYCD9DoGDyFOM4DBeE7xp7mZXoeOF4eSPjD20ZfF+Y/YCQMdCrEwvMaxCFu
         RhJ0Ux/2hnbSOWlraRhn2uGJzMXdXUDFQssbSLweD1nF+TmI0TxYnYJTp+OOQFAVrs7s
         UYk04hhc73/EUSr6P7/t5eW43dlTO5P2nwbA6/8NbW4oMcABnGmaTINgL2XFqoKRMpgP
         29EQ==
X-Gm-Message-State: APjAAAVqVviFnB8htK5seT1EzSoEmN49ZaHty5iOZN2KbsRGyu3Htd4G
        MkPWbbgnwadUO5KoZwPn51Y9tuDFoUzz30HM2ipagP7lNjGTQyTFOvz6EBf04YPrj/oOqXXg+3h
        dFVFkt89xUGNC
X-Received: by 2002:a1c:8055:: with SMTP id b82mr4053685wmd.127.1582043465298;
        Tue, 18 Feb 2020 08:31:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqxcbLjDdl8yYBOLssLztWaiKZt1qolfF/drqUpVyQbR31GyH51q/Z7meOxgMs3aCiblWpkLYA==
X-Received: by 2002:a1c:8055:: with SMTP id b82mr4053661wmd.127.1582043465086;
        Tue, 18 Feb 2020 08:31:05 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id e6sm4179931wme.3.2020.02.18.08.31.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 08:31:04 -0800 (PST)
Subject: Re: [PATCH v4 1/2] KVM: X86: Less kvmclock sync induced vmexits after
 VM boots
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <1581988630-19182-1-git-send-email-wanpengli@tencent.com>
 <87r1ys7xpk.fsf@vitty.brq.redhat.com>
 <e6caee13-f8f7-596c-fb37-6120e7c25f99@redhat.com>
 <87mu9f97uv.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8804030e-db83-d212-d712-807833f9fd7e@redhat.com>
Date:   Tue, 18 Feb 2020 17:31:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87mu9f97uv.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/20 17:29, Vitaly Kuznetsov wrote:
>> No, it executes after 5 minutes.  I agree that the patch shouldn't be
>> really necessary, though you do save on cacheline bouncing due to
>> test_and_set_bit.
> 
> True, but the changelog should probably be updated then.

Yes, I agree.

Paolo

