Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07286BBF64
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 02:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503649AbfIXAhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 20:37:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388800AbfIXAhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 20:37:21 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A2074862E
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 00:37:20 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id k67so16704wmf.3
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 17:37:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LHmEi+os+D0XekQst/axaZyK+/1jvY+ikX3lz8Z3eVo=;
        b=KoYVDnRFe2gQ70Qv3CO6PnRNh6LgkxDaLAgBFzBKhBAB65Uwu1Ku8TI6lZCd3MjvPm
         uKyLYEslCdShrrTIwmDDdLX7cKoCWILgLuWsr+yb+fipg+FPCe8w16GMhe+7j6GmjZpu
         3hPNBDiC/pA+/Qbs45PZRpiqYIZwXYgBxbYmGc538LePI8uSmToCZ/JyAm2zuCWxGy5o
         a+b7UR1n0df6+pBJu2Q5t9BOUunZUi/ZBxtoTgfud1SQ2CdTqtwBBpB0UAKrLlwGLzMF
         wmyBrbGx92YB/kH9dtWaX7cWXe/qcZhOtfhK+JYljZgVIkoqLRAgY9OEWOYPDALqamVW
         zQCA==
X-Gm-Message-State: APjAAAW+S41ygIlwFlJQ07bBABztXE0iymru4ZHG23p2iLntw1a+LBNb
        Oh6SOYF3SrE6PZ7YmNYbas2HXbZ1DjWA6kj83drhMvzAhan9jUH/B3wQFEr/q2dFr3E9it8BKge
        QksvnHvyItyXC
X-Received: by 2002:a7b:c10b:: with SMTP id w11mr199638wmi.108.1569285439339;
        Mon, 23 Sep 2019 17:37:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxpYSYti8BI01M0rZ0ppMB3xZdaOJULpHyf5Iueq0t73HDKfp0Fu4g9AC5vJdsyguZ+XhKPNg==
X-Received: by 2002:a7b:c10b:: with SMTP id w11mr199623wmi.108.1569285439098;
        Mon, 23 Sep 2019 17:37:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id e6sm64650wrp.91.2019.09.23.17.37.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 17:37:18 -0700 (PDT)
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <7329012d-0b3b-ce86-f58d-3d2d5dc5a790@redhat.com>
 <20190923190514.GB19996@redhat.com> <20190923202349.GL18195@linux.intel.com>
 <20190923210838.GA23063@redhat.com>
 <b58d2305-284f-8652-a0f3-380b26642fe0@redhat.com>
 <20190924003459.GA13147@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4e5e3459-98a3-8263-f328-f2e636d5e046@redhat.com>
Date:   Tue, 24 Sep 2019 02:37:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924003459.GA13147@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/19 02:35, Sean Christopherson wrote:
>> I agree.  I think the way Andrea did it in his patch may not the nicest
>> but is (a bit surprisingly) the easiest and most maintainable.
> Heh, which patch?  The original patch of special casing the high
> priority exits?

Yes.

Paolo
