Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9C8F82B0
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 22:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfKKV7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 16:59:19 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37721 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727122AbfKKV7T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 16:59:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573509558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=5JMGc6ZNt3Kt87cTt6dbWaP1bAXTKUa7TPW46Nj75J0=;
        b=VMy1vBtLn5w+/s/LH76dXSxG4MfxYwPMz+FUJ5YFEx5qT+bwCE+IC+HeKnZSA4+OcBUesk
        dyJio420Gfb0D8GVNDpNHyWrjQILhz0+6GKHwJfkgQQXC5aGIAh7CLtYk44EHwYvW/QzM6
        on2rkDV3yv6ZDvzC+PZzEZvsZ0Gf0VA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430--eRGsUuzONKoa1IozRAxjg-1; Mon, 11 Nov 2019 16:59:16 -0500
Received: by mail-wr1-f69.google.com with SMTP id e10so8269506wrt.16
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 13:59:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n2KX+tENMt/6R+J+74Qa4Dthv4cuV76s4hBzTDosBdo=;
        b=QqbitIDhnfoNsTMdsFLc7bfSGCqc63Nbf5o1lRoOtAbLErQxMI7eMjQbufjY3/ykV0
         lpbcR5p3aftdWUGr7/4SmCnfJqwl2Q2PzRjeMGNM7KVNuDbyv1We8TCtoxON/O8NTDH9
         Wu/enkt2F8uoI9cAtawPzPD9W5YMRldO9jzaAO4FppTzso6+pgnKUHbC9ZBFCBHm3vB8
         YajfapGw/pFwlpscTdmwolMiIV2F7S3BcF28RLFUvuzNU3ZlA7LqcpTYk48imebeeMGY
         +Ped8zh/d+DhlOeGFILK9+OC2XuHCqQ6Ckdj7HiXp6jI+qrvszNU0oWzAfOhwXD9JIO1
         cbcQ==
X-Gm-Message-State: APjAAAXxsUFT14n73D1HEDzvxJt+rJSZqww40yz2W2NIwYHXnEVxcQds
        +Gpn1gSEaaR4Z+3EkpRbYhYIFoF6ofKvBOZQsWM9y1R0dQyFJIvHms+7/aw98nNqAI5iRGqlncx
        2eoAkN0dXTZTv
X-Received: by 2002:adf:de86:: with SMTP id w6mr22575214wrl.220.1573509555613;
        Mon, 11 Nov 2019 13:59:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqzFH81eJPsJFWm6/v9HDiXiBPV2gYCw4cA0ZvscuxcTs7YdwXTZJmbkmW8OAhesOnXybRQw5g==
X-Received: by 2002:adf:de86:: with SMTP id w6mr22575197wrl.220.1573509555313;
        Mon, 11 Nov 2019 13:59:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8c9d:1a6f:4730:367c? ([2001:b07:6468:f312:8c9d:1a6f:4730:367c])
        by smtp.gmail.com with ESMTPSA id n23sm960755wmc.18.2019.11.11.13.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 13:59:14 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: X86: Single target IPI fastpath
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4418c734-68e1-edaf-c939-f24d041acf2e@redhat.com>
Date:   Mon, 11 Nov 2019 22:59:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
Content-Language: en-US
X-MC-Unique: -eRGsUuzONKoa1IozRAxjg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/11/19 08:05, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
>=20
> This patch tries to optimize x2apic physical destination mode, fixed deli=
very
> mode single target IPI by delivering IPI to receiver immediately after se=
nder
> writes ICR vmexit to avoid various checks when possible.
>=20
> Testing on Xeon Skylake server:
>=20
> The virtual IPI latency from sender send to receiver receive reduces more=
 than
> 330+ cpu cycles.
>=20
> Running hackbench(reschedule ipi) in the guest, the avg handle time of MS=
R_WRITE
> caused vmexit reduces more than 1000+ cpu cycles:
>=20
> Before patch:
>=20
>   VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time   Avg ti=
me
> MSR_WRITE    5417390    90.01%    16.31%      0.69us    159.60us    1.08u=
s
>=20
> After patch:
>=20
>   VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time   Avg ti=
me
> MSR_WRITE    6726109    90.73%    62.18%      0.48us    191.27us    0.58u=
s

Do you have retpolines enabled?  The bulk of the speedup might come just
from the indirect jump.

Paolo

