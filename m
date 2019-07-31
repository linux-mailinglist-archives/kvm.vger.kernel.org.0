Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2CB7C2AA
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 15:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfGaNDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 09:03:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40502 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729091AbfGaNDE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 09:03:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so69574416wrl.7
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 06:03:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6tuOZnHqaG3S/kW7Gc2GJzSdvEDHwY1ehrhqvfGBrTA=;
        b=i46HpwpfQC2RlIWAu+h6iIHvKVEuaCzYj0wmB7UnO2B0Ji5ImGBfwL37DHijms4SmM
         HeGrNuln7cIKIf/D3BDNTp01QZFlkjtVM75FkQWJ8zo8j43JnJKA1JzcYVn8V+jUbpIA
         4SNiTHC3jUvxdL1pW3VwFnp7UHYXjlpHu7GNrrbzvjTO/ybuPz/ZylU1jDxE+Zpl0/DN
         z5ZyAAQOylyYm3Tk0FsHhtlom9hjEp5dLuMLZDA1D8uUpcsukWFIPltZZEIAeT7s+W6g
         qBpHpjdj2lVcaQ0REh2mAYC1BBNrGb7+wuE7YPxXy+pFN3f3RHauXVAVWa4ZBunnAZYt
         KiTw==
X-Gm-Message-State: APjAAAU1SeotRrSPnVU1qbm7gj5mtpyMzMsy6T4ddYr+ZfCfyCUI0SHf
        l7faZuGyB3HBRkKDm/iTRBn/uw==
X-Google-Smtp-Source: APXvYqxvj2NnCMXj09R1SeZlYJ9gWJtaTck7xRuR/yQ+wJh0fkCYe9eoa9Hzi5kavRfZMIfrLo53SQ==
X-Received: by 2002:adf:ea88:: with SMTP id s8mr125860239wrm.68.1564578182860;
        Wed, 31 Jul 2019 06:03:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91e7:65e:d8cd:fdb3? ([2001:b07:6468:f312:91e7:65e:d8cd:fdb3])
        by smtp.gmail.com with ESMTPSA id b8sm88518509wmh.46.2019.07.31.06.03.01
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 06:03:02 -0700 (PDT)
Subject: Re: [PATCH 3/3] i386/kvm: initialize struct at full before ioctl call
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-block@nongnu.org" <qemu-block@nongnu.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "berto@igalia.com" <berto@igalia.com>,
        "mdroth@linux.vnet.ibm.com" <mdroth@linux.vnet.ibm.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        Denis Lunev <den@virtuozzo.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
 <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
 <14b60c5b-6ed4-0f4d-17a8-6ec861115c1e@redhat.com>
 <30f40221-d2d2-780b-3375-910e9f755edd@de.ibm.com>
 <08958a7e-1952-caf7-ab45-2fd503db418c@virtuozzo.com>
 <bdbee2e0-62a7-8906-8076-408922511146@de.ibm.com>
 <f9346216-a4e9-4882-4a36-33580529b75e@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <72f0fe91-3ced-ea7c-b675-1f219586213c@redhat.com>
Date:   Wed, 31 Jul 2019 15:03:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f9346216-a4e9-4882-4a36-33580529b75e@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/19 14:43, Christian Borntraeger wrote:
>>>>>>       if (has_xsave) {
>>>>>>           env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
>>>>>> +        memset(env->xsave_buf, 0, sizeof(struct kvm_xsave));
> This is memsetting 4k? 
> Yet another variant would be to use the RUNNING_ON_VALGRIND macro from
> valgrind/valgrind.h to only memset for valgrind. But just using MAKE_MEM_DEFINED
> from memcheck.h is simpler. 
> 

Yes, it's 4k but only at initialization time and I actually prefer not
to have potentially uninitialized host data in there.

Paolo
