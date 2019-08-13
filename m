Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D0A8C31A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 23:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfHMVFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 17:05:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40291 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfHMVFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 17:05:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id c3so796087wrd.7
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 14:05:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HJ28iMshNN+NfaYy5xmyO1ZNXjql14U0nhtFiTgokwg=;
        b=JCcDvud07EgZT1rre6hHEx7B7FPThQCasKRLblktNtT1gUwM/jfVad9QrKv/VupN9K
         8GOxCzLbK02uKYcE82PTb6owagQLau2l231jxWZpoJxJ10mJYDyc8I3GVxDRSxvPPtZW
         7jaeJRA/FA9GAbkkIYZNe4+Tg5E/9qTx0FltCYbamxqGMOAd3vZyEq5DJUcmsQXad+11
         2HTiVQe0GK/FZ/5fY+v/s2ieljKfV9aT0PSJuQwM2XOEZJmmyAs+WtcLf0TT2EJLaGk2
         0nBixpfQ6LOzNo/ks8JYMdpqCrPmF508pvXQSZHdRshFoFKUYV0gbJ94fjJOIEjz3aV8
         s+ig==
X-Gm-Message-State: APjAAAX2G6ZLCkXqe9PO0hTAnLEDiBVMfRX6JTHSxZ6bJe7V2199tdtJ
        2+ZhdHJguvUJSW5IhWwY/NmgNdNO6E8=
X-Google-Smtp-Source: APXvYqyZ2jr5qyk4/FAkQ2DyqARV1LTJjfCPOq/HKPV6Qw8yfVvQ3YnqFSIPzkb9wVVggdiMAOhRwQ==
X-Received: by 2002:adf:fdd0:: with SMTP id i16mr34701233wrs.260.1565730345733;
        Tue, 13 Aug 2019 14:05:45 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v65sm3210320wme.31.2019.08.13.14.05.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 14:05:44 -0700 (PDT)
Subject: Re: [RFC PATCH v6 76/92] kvm: x86: disable EPT A/D bits if
 introspection is present
To:     =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        KVM list <kvm@vger.kernel.org>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-77-alazar@bitdefender.com>
 <9f8b31c5-2252-ddc5-2371-9c0959ac5a18@redhat.com>
 <0550f8d65bb97486e98d88255ea45d490da6b802.camel@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <662761e1-5709-663f-524f-579f8eba4060@redhat.com>
Date:   Tue, 13 Aug 2019 23:05:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0550f8d65bb97486e98d88255ea45d490da6b802.camel@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/19 20:36, Mihai Donțu wrote:
>> Why?
> When EPT A/D is enabled, all guest page table walks are treated as
> writes (like AMD's NPT). Thus, an introspection tool hooking the guest
> page tables would trigger a flood of VMEXITs (EPT write violations)
> that will get the introspected VM into an unusable state.
> 
> Our implementation of such an introspection tool builds a cache of
> {cr3, gva} -> gpa, which is why it needs to monitor all guest PTs by
> hooking them for write.

Please include the kvm list too.

One issue here is that it changes the nested VMX ABI.  Can you leave EPT
A/D in place for the shadow EPT MMU, but not for "regular" EPT pages?

Also, what is the state of introspection support on AMD?

Paolo
