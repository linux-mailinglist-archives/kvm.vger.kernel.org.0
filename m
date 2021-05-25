Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E01F38FCA9
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 10:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhEYIZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 04:25:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231391AbhEYIZi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 04:25:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621931048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nMNrS2AH+pWQGLicYKYrV08FbwOU09YffgbHD3gux2Q=;
        b=P5A9KrRtsLXVNPfo0wac7J6zkBsiE3zNljU6u/nSwBLWx10PyV8FJQt2aQ43h2l/4UhwDD
        8Z9AfNhpf0kWa+K0kHPPlY3Jbhdnab5yaHxyEpdsaANCRS8faNOSZ6YBJg96j+ryz2GkGd
        LdW8So2jMFAxzQ8ZsD4jSh9NVFVHg4Q=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-gZ2W5-zxPkWJpfYR6RrKtg-1; Tue, 25 May 2021 04:24:06 -0400
X-MC-Unique: gZ2W5-zxPkWJpfYR6RrKtg-1
Received: by mail-ed1-f72.google.com with SMTP id u14-20020a05640207ceb029038d4bfbf3a6so13370280edy.9
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 01:24:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nMNrS2AH+pWQGLicYKYrV08FbwOU09YffgbHD3gux2Q=;
        b=mXApMNrXJN818x6gKH3bO+wzNmROOFc/jnVcaxBV+ZCntPg1WbThlcTr3fybSe+Qmx
         ERoIbPSq0iZtXV6MzhIsKGB3z1OLtKeueE/P3ft6vj+jxWtGBqT6AryAd626h0i2Rdo2
         vtmgcd2gfxmKMAiKfuP7YSO5wUQBZHIMGQuwZY72XLJ9J54DcECQoJMhJILwed/kUOc4
         ZRjdMpYwjTlQhnucED452DgzgrD4xGfwxUjLSZ3hGyge8ldP6Hb7j2ql9CJ8fqm0PIxl
         m3ZZziY213uE/Ek1LeTRDpspdK7fwtEg7EcBv8icke7431QKYsH2nDCwHMpE7KopsKJ0
         T3Cg==
X-Gm-Message-State: AOAM5303SCztZ1+bTgW37c5vFqtazThJ/Iwom4IKgcpxJ6slHxJCbAb1
        JrX+1+dthrsrT8ExPlvzz98QZho/TlfzUPJD1Vf8UFnf9p4w20GN/4TMQehNnRRmG80xXWKObJJ
        OIo4jtziNa6BE
X-Received: by 2002:a17:906:2749:: with SMTP id a9mr7301259ejd.498.1621931045768;
        Tue, 25 May 2021 01:24:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3ejiTVjnk0KxP0784vBVyBVdsw1rtPY3FP7JEZB/fGwja1e9e9HqFVf3ExrM8SXokAJlR3w==
X-Received: by 2002:a17:906:2749:: with SMTP id a9mr7301238ejd.498.1621931045543;
        Tue, 25 May 2021 01:24:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gl20sm8752886ejb.5.2021.05.25.01.24.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 01:24:05 -0700 (PDT)
To:     Greg KH <gregkh@linuxfoundation.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Palmer Dabbelt <palmerdabbelt@google.com>,
        "guoren@kernel.org" <guoren@kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "graf@amazon.com" <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "anup@brainfault.org" <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>
References: <mhng-b093a5aa-ff9d-437f-a10b-47558f182639@palmerdabbelt-glaptop>
 <DM6PR04MB708173B754E145BC843C4123E7269@DM6PR04MB7081.namprd04.prod.outlook.com>
 <YKypJ5SJg2sDtn7/@kroah.com>
 <DM6PR04MB7081843419AFCECABA75AD74E7259@DM6PR04MB7081.namprd04.prod.outlook.com>
 <YKyxMy+djlscUhr1@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v18 00/18] KVM RISC-V Support
Message-ID: <fb03a89a-873d-ab85-8b05-f5f283f54489@redhat.com>
Date:   Tue, 25 May 2021 10:24:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKyxMy+djlscUhr1@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/05/21 10:11, Greg KH wrote:
>> 1) facilitate the development work overall, both for Paolo and Anup on the KVM
>> part, but also others to check that their changes do not break KVM support.
> 
> Who are the "others" here?  You can't force your code into the tree just
> to keep it up to date with internal apis that others are changing, if
> you have no real users for it yet.  That's asking others to do your work
> for you:(

I don't know about changes that would break KVM support.  However, 
"other KVM developers" would be able to check that their changes do not 
break the RISC-V implementation, and I would certainly either enforce 
that or do the work myself.

Also, excluding simulators and emulators from the set of "real users" 
ignores the needs of userspace developers, as well as other uses such as 
education/academia.  Linux for x86 (both KVM and bare metal) supports 
features that are only available in emulators and simulators which are 
not even free software.  I am pretty sure that there would be more users 
of KVM/RISC-V than with KVM/MIPS, despite the latter having support in 
real hardware.

Paolo

