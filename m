Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE2D10568A
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 17:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKUQIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 11:08:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23421 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726379AbfKUQIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 11:08:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574352492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=MeeOedOyzrBDgLHnAaEdYtdPw/Bnh3YjiRhbRgcresI=;
        b=jRVCyxHoWKFGiftrW97OuKr6Hq9Gfmwxu2/bijtaexDMzt3Kug6SxSOoFXNC23U/E2PprF
        /HL2tNl9Rj9EbrbsybPzcbKaLiQZwBX5pKkHdRILSlFlXbt+mDHuzSUWKX7CkpobrufzYx
        0XrjV9Q0sdLxOmUso5LIFO88suFac8E=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-CrP3dveoOFOYxOGH8BK8dQ-1; Thu, 21 Nov 2019 11:08:10 -0500
Received: by mail-wr1-f71.google.com with SMTP id c12so1041294wrq.7
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 08:08:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KMDjZkzrlqiVQ/Y8A6t0DAiUQ9UpMG4ktLorbVn8v3Q=;
        b=qey+iytvKSR6rQ+/0WmREeITYAhDd7TxnGUUNf4vTjXAB6gluzPjbrSEMXLkZE0xo2
         22BzWtx7sBAYa9QcUyuyC+Q8w1bd33V/Wb+/GrNgoiaoI1I/jkY24Nl9AdDXK/x1ys+G
         LwtKPFeFmpE8k1BH0H3TkiCYAItOpP4fpiVqLRLDgxAgEP0+wE5CPQ/ZWQwU35kgZ+D4
         b3W5P9+v4ULaqMAhVPWjEqeGEDzsNOn/axwAhAhu48NbzZnUgBn1C5foWQiRUQTA97Ky
         NhghkanV3Khai/Dxf0EsNJ5MdkNJ7WkQN9AnH+fkGmPtTVdiBj9cgeJfUtAA/fBu2fAf
         A7Nw==
X-Gm-Message-State: APjAAAVE88aSpylUi566GSDSQz8YWQholNwVxiEPSskUk5ec+vHRdJcV
        1cSmhaJxhZtCSjwevY3QGH7ul0chujMQ15Dl5eTLvv2a8Tq5Wb412BshxrgGLDtQnzdKQAwTPdy
        SfnLjegBH6u44
X-Received: by 2002:a1c:7f94:: with SMTP id a142mr10568871wmd.33.1574352489475;
        Thu, 21 Nov 2019 08:08:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDnhT3JBlp/jXfwl4CJh7SlIP82w3enQZE3lpWjhvdGmtTQ7g4eELgQdIiSIVuH65LYDfs1w==
X-Received: by 2002:a1c:7f94:: with SMTP id a142mr10568840wmd.33.1574352489181;
        Thu, 21 Nov 2019 08:08:09 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id f19sm4087872wrf.23.2019.11.21.08.08.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 08:08:08 -0800 (PST)
Subject: Re: [PATCH v7 6/9] vmx: spp: Set up SPP paging table at
 vmentry/vmexit
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmattson@google.com, sean.j.christopherson@intel.com,
        yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-7-weijiang.yang@intel.com>
 <a7ce232b-0a54-0039-7009-8e92e8078791@redhat.com>
 <20191121152212.GG17169@local-michael-cet-test>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7cdcd2b2-ced8-4c08-82c7-b3a25ed8bb15@redhat.com>
Date:   Thu, 21 Nov 2019 17:08:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191121152212.GG17169@local-michael-cet-test>
Content-Language: en-US
X-MC-Unique: CrP3dveoOFOYxOGH8BK8dQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/11/19 16:22, Yang Weijiang wrote:
> On Thu, Nov 21, 2019 at 11:18:48AM +0100, Paolo Bonzini wrote:
>> On 19/11/19 09:49, Yang Weijiang wrote:
>>> +=09=09=09if (spte & PT_SPP_MASK) {
>>> +=09=09=09=09fault_handled =3D true;
>>> +=09=09=09=09vcpu->run->exit_reason =3D KVM_EXIT_SPP;
>>> +=09=09=09=09vcpu->run->spp.addr =3D gva;
>>> +=09=09=09=09kvm_skip_emulated_instruction(vcpu);
>>
>> Do you really want to skip the current instruction?  Who will do the wri=
te?
>>
> If the destination memory is SPP protected, the target memory is
> expected unchanged on a "write op" in guest, so would like to skip curren=
t=20
> instruction.

This is how you are expecting SPP to be used, but another possibility is
to unprotect and reenter the guest.  In this case
kvm_skip_emulated_instruction would be wrong (and once this decision is
made, it would be very, very hard to change it).

However, you clearly need a way to skip the instruction, and for that
you could store the current instruction length in vcpu->run->spp.  Then
userspace can adjust RIP manually if desired.

Thanks,

Paolo

