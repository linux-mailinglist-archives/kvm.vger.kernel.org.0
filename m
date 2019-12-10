Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90443119231
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 21:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLJUgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 15:36:52 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32381 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726366AbfLJUgw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 15:36:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576010210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=akibSntb0ZDkV7c+opTsEO1BzvpSU5bY4v8e9ukM1GE=;
        b=SX7yGghK5E5C9FAJv4Nibr+Y+DB0S/HlOsTorjZUc4ASmli2aD2MGPwKImtZX3H9eSv+xN
        9tXaucq1+46EhOupFRkQmMGDFqcZN4KWm6YjhZj7c9zeYBCWmvIAXlk0yTOZi7hGdWX/KQ
        DnR/VbUJ/Maq8QthBGEp9TCZJIlULUo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-PWoA-g2yPfGnE-QS9Nf6wg-1; Tue, 10 Dec 2019 15:36:49 -0500
Received: by mail-wm1-f71.google.com with SMTP id l13so1415063wmj.8
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 12:36:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=akibSntb0ZDkV7c+opTsEO1BzvpSU5bY4v8e9ukM1GE=;
        b=TpyUBYnF+9nCM4b+kuZLpSpVCzP4QYpiTfafek/kmiOjd6tbTn3l/Kr9ip47BrTBvB
         +IZt4yj5IcuKwW0UOquQTyLcixATtdpi1c1KdnYqUP6XdW118N01Zbxro6VyBz0fijfN
         OqlQNDp2bPGk0Anmm2C+gNdrmzi2Oab22x//Y5+FjwegNAZBUHoB+eMXSsaU6IVKHmNO
         1KdcDPdxuf1qbCBdXIx+sBmP0uvEcccbpQYriMXDplOb/IdILOt68lkqmPnCWjKfLf03
         fiFhJh3tizu8/ltymmRx7oEtAWqH8yE0PN7FpVDb23+GxHT6cggPuOxYo7xe4HudZqtw
         ORRw==
X-Gm-Message-State: APjAAAWjjv4qRrUFbTci/OcEjGanXvP3TA57B8ggH3n3IGnrLJ8PxKue
        /x+G+TsOHcGGkNKW4IOe2AsRxYEgkgNt36+XGrS6LXxOzuuPU/MSmk1eBOIlzB2aiNHSRdjVQx2
        34SOqCddqZ2cd
X-Received: by 2002:a1c:4483:: with SMTP id r125mr7099883wma.97.1576010207668;
        Tue, 10 Dec 2019 12:36:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqxYr+zuzjwED+9pyLW7KY5uR7R30bnx2UXOE6OT9T94lgOIR2M7BmTt9+tM4NWQz5ZIe+xOlg==
X-Received: by 2002:a1c:4483:: with SMTP id r125mr7099868wma.97.1576010207423;
        Tue, 10 Dec 2019 12:36:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id x10sm4630061wrv.60.2019.12.10.12.36.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 12:36:46 -0800 (PST)
Subject: Re: [PATCH 1/4] KVM: nVMX: Check GUEST_SYSENTER_ESP and
 GUEST_SYSENTER_EIP on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
References: <20191206231302.3466-1-krish.sadhukhan@oracle.com>
 <20191206231302.3466-2-krish.sadhukhan@oracle.com>
 <CALMp9eQ4_qtcO1BbraOwXHamXwi4M3AOq1NE7X84wgxxm=ismA@mail.gmail.com>
 <47daeae4-6836-9d60-729a-d5e2d5810edd@oracle.com>
 <CALMp9eRaX-bdyxAP4C=mdSOFLjCpT+f5RTAb+DchTVktZ+_xfQ@mail.gmail.com>
 <43382539-7646-c913-e3cd-bf696e524ea3@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6db4b31c-08f4-c01c-34c3-e307324fc4d2@redhat.com>
Date:   Tue, 10 Dec 2019 21:36:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <43382539-7646-c913-e3cd-bf696e524ea3@oracle.com>
Content-Language: en-US
X-MC-Unique: PWoA-g2yPfGnE-QS9Nf6wg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/19 21:29, Krish Sadhukhan wrote:
> 
> Thanks for the explanation !
> 
> So the kvm-unit-test is still needed to verify that hardware does the
> check. Right ?

Yes, and I've queued that part.

Paolo

