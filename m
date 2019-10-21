Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4659BDED08
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 15:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbfJUNDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 09:03:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbfJUNDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 09:03:15 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 55C97C087353
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 13:03:15 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id c6so7285777wrp.3
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 06:03:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SRsEP7MdZ/U/cm1kcGdYUO6agWlHXT6j/oNDoj6CtAE=;
        b=LbBPQmYx/B3346jsFtUwvUQUnqd6AWbVTXf1uoCI8cIDg5aQgeyQKnStd+QwkiwhkK
         YdX/KKXJZT1n+DDaIFgBU6J9JCRj05BtjcwQIx6qZ+g2/JcCJFE22BA9JChs7jeBTqPX
         1ffEMDCnV5F5C5EKxG9oc1wcvhYWPwqu/YnszY5/VSL72Ca+5DROPlQgXsJSnRynmbPD
         Ji8xVVhiyr0s+uZ+l6zPNqEsxSCd22HLsI44qebHuFVjYAgwvjVyuDxOobPMtdotkNa4
         8Cb2KrUPDLhD7DKbS0Gg/zm6cmXqXgpkvP23wt5uCIzd4y3E9LVxpwFol7NVsBfKghZx
         T8Tg==
X-Gm-Message-State: APjAAAV2Vdup9ujRsi27OamX26oK9iAuS6WozuhKC3chwgx+iPfhNA+w
        +XgeszkEg5F2t70MsnowRemY6m3IV066jiObI0GJ9fsw1WDrvU37ZH+FrynVzGI4JShc/ShPg6W
        NJhWMQyzVwaN9
X-Received: by 2002:adf:ea83:: with SMTP id s3mr4300757wrm.43.1571662992512;
        Mon, 21 Oct 2019 06:03:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx0vfWrFJ17dOTpy0SjdT50aBC6AoFTEf08r3xOJ2JAlE1xg/YCfk4j4w2W0Kt7dxid70mggw==
X-Received: by 2002:adf:ea83:: with SMTP id s3mr4300716wrm.43.1571662992251;
        Mon, 21 Oct 2019 06:03:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:566:fc24:94f2:2f13? ([2001:b07:6468:f312:566:fc24:94f2:2f13])
        by smtp.gmail.com with ESMTPSA id l18sm19087044wrn.48.2019.10.21.06.03.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 06:03:10 -0700 (PDT)
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
References: <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <alpine.DEB.2.21.1910161244060.2046@nanos.tec.linutronix.de>
 <3a12810b-1196-b70a-aa2e-9fe17dc7341a@redhat.com>
 <b2c42a64-eb42-1f18-f609-42eec3faef18@intel.com>
 <d2fc3cbe-1506-94fc-73a4-8ed55dc9337d@redhat.com>
 <20191016154116.GA5866@linux.intel.com>
 <d235ed9a-314c-705c-691f-b31f2f8fa4e8@redhat.com>
 <20191016162337.GC5866@linux.intel.com>
 <20191016174200.GF5866@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e5affe77-ac99-ce3b-dc08-352d9632766d@redhat.com>
Date:   Mon, 21 Oct 2019 15:03:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191016174200.GF5866@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 19:42, Sean Christopherson wrote:
> KVM uses a locked cmpxchg in emulator_cmpxchg_emulated() and the address
> is guest controlled, e.g. a guest could coerce the host into disabling
> split-lock detection via the host's #AC handler by triggering emulation
> and inducing an #AC in the emulator.

Yes, that's a possible issue.

Paolo
