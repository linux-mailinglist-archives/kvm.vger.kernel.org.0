Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B273F8313
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 23:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfKKWnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 17:43:24 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38671 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726988AbfKKWnX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 17:43:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573512202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=+3E68Um6Tt8y9CXkua7izwyEPRiZxPLXIv8+dZ2zBd8=;
        b=LDRFeT0057J4I2jXvpcWbWMx0UY6Xvyev/bamh7cmJAm5LpOO5ZOz1tbqK7veK1p++4Qdx
        d2SdhhQTpMrGdTLjFuAn2kSFzx5hxrOkv+L/Ve8feWfTBnr/cG+CkPxP5XxztZ2UOqv31z
        vHEhs6AcgiN5vuWt+JGyuOthFmQ6Li4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-OGeBD92gOGeyC3giPP5S1Q-1; Mon, 11 Nov 2019 17:43:21 -0500
Received: by mail-wm1-f72.google.com with SMTP id g13so595673wme.0
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 14:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0imOcBZtHzOC2GY9nm8Jh6eW98nYnDyTJ620lFBF2zY=;
        b=Go2i5nVFd3PpOaX1mzhuCt64ZsBzOUpbev9IB+pYdK4qRpMT5aNwdaJBr+P8dZiwx/
         lTHWdY7YcKjbW5i8DgGVDaj5jPyjBqTA/IRjQppR4lKNbkwr+vgYKmCm6e2GXmC1PHPj
         dihk9XlsXZIEWuR08CRvldqycxFQ1nok/pPjWpJBjxI2q8T+fC+n9fcUoZiyLhCxo6Kk
         /0/RVHL5W+AkqVtRcVpxxOjneON72YBIL6kGs5zJ4yqpLVrjFhxHaZuER2TPBgq5jpWc
         2uatJqpecebgrmTWw0tl+BkqwykN6nL/3jgCqRTtKubEEqG8G6pTTYJ5U+QAXqHP4rXT
         75Zg==
X-Gm-Message-State: APjAAAVh1D3S0FjWQZfTZp5iUy71tstIGcX+v18t4E/f8to5ZU9DQ5Xt
        4YRIGddyc9xHTxXTFmPjnN54E03a10RtOpzdDWAig9H2y/5PXBF7Oum9cIcz99ao3/rMxSG2cyd
        Np0L11/Csjmpx
X-Received: by 2002:a5d:4982:: with SMTP id r2mr23000771wrq.254.1573512200152;
        Mon, 11 Nov 2019 14:43:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqwxQSI41mJobzK6Insrsq0qbtd7QRgNmgRi09jVXFAoyeD8/PfQM1mPq+1MQCPHtR592LQpMw==
X-Received: by 2002:a5d:4982:: with SMTP id r2mr23000749wrq.254.1573512199844;
        Mon, 11 Nov 2019 14:43:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8c9d:1a6f:4730:367c? ([2001:b07:6468:f312:8c9d:1a6f:4730:367c])
        by smtp.gmail.com with ESMTPSA id j7sm7755986wro.54.2019.11.11.14.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 14:43:19 -0800 (PST)
Subject: Re: [PATCH v2 1/3] KVM: MMU: Do not treat ZONE_DEVICE pages as being
 reserved
To:     Dan Williams <dan.j.williams@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>
References: <20191111221229.24732-1-sean.j.christopherson@intel.com>
 <20191111221229.24732-2-sean.j.christopherson@intel.com>
 <CAPcyv4hyPWv0OpZVBJ-Vq8pGny1B59EkvykZ0RKZAgHB0tq2og@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4d5a1f52-ca25-bbf9-fb3c-d7cec90caafc@redhat.com>
Date:   Mon, 11 Nov 2019 23:43:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hyPWv0OpZVBJ-Vq8pGny1B59EkvykZ0RKZAgHB0tq2og@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: OGeBD92gOGeyC3giPP5S1Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 23:39, Dan Williams wrote:
>> [*] http://lkml.kernel.org/r/20190919115547.GA17963@angband.pl
>>
>> Reported-by: Adam Borowski <kilobyte@angband.pl>
>> Debugged-by: David Hildenbrand <david@redhat.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
>=20
>> Cc: stable@vger.kernel.org
> Perhaps add:
>=20
> Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
>=20
> ...since that was the first kernel that broke KVM's assumption about
> which pfn types needed to have the reference count managed.
>=20

Done, thanks!

Paolo

