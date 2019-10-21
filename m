Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6641FDED06
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 15:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbfJUNC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 09:02:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36206 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbfJUNC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 09:02:59 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C846E796E7
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 13:02:58 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id e25so6687346wra.9
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 06:02:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eF2g6ycIsvHZKXf5+W5UwvelEhbKRjaOcX8P7/jfVL0=;
        b=f9AKbVWQCyo544H9mauYpzDLnD4bBtowfNiWMIKcWPkm4U1WH2ELxWI/owcrQJF+A5
         zbOqQSj2o7s8SwFlQM7tgU44AODTiKbjeTLzXz8QyxMx4viAbhDDsO0ZSH5OvBIRDgOy
         uFmQkVTr+EZXeTmiBA31djJXgWLurKw1Lx5j59J2rlX5ykY0sBBzeYg34iBE/xlARrmE
         HPICSy1Zz94jH8fBaLxYeK11vfvIMIwHq7T+HepnUUgv29BR4+of2YQ4nZRQhJCX2jyw
         hBK2S6KSk8CxIc3928pK6mg7OrrU3muItAGkvtzYTXEj/iCeHAIS2Inou9e6aS8lY15V
         F6+g==
X-Gm-Message-State: APjAAAXOkJkBcZIZf7MmaKxpZc6RCoMrO93rgIl7ku/oi2EMKVnTK1M7
        3B9CXk6q6F9tw9X55g4eJYyRNNVvioDlFqqPLbbku5GxpWxcGExfVho4SXo5+OLkRK9t7QfvGQg
        lZ/w5JcGfpcie
X-Received: by 2002:a5d:464f:: with SMTP id j15mr6154808wrs.366.1571662970588;
        Mon, 21 Oct 2019 06:02:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw8eEoQCOsr7dhBRnnc9WFPQaqin+Qyx8So9afzziGxaMtUTqnyeqqzNX6YHHVvA66ycTY3Jg==
X-Received: by 2002:a5d:464f:: with SMTP id j15mr6154764wrs.366.1571662970264;
        Mon, 21 Oct 2019 06:02:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:566:fc24:94f2:2f13? ([2001:b07:6468:f312:566:fc24:94f2:2f13])
        by smtp.gmail.com with ESMTPSA id c8sm1383182wml.44.2019.10.21.06.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 06:02:49 -0700 (PDT)
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
References: <20190925180931.GG31852@linux.intel.com>
 <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <alpine.DEB.2.21.1910161244060.2046@nanos.tec.linutronix.de>
 <3a12810b-1196-b70a-aa2e-9fe17dc7341a@redhat.com>
 <b2c42a64-eb42-1f18-f609-42eec3faef18@intel.com>
 <d2fc3cbe-1506-94fc-73a4-8ed55dc9337d@redhat.com>
 <20191016154116.GA5866@linux.intel.com>
 <d235ed9a-314c-705c-691f-b31f2f8fa4e8@redhat.com>
 <20191016162337.GC5866@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c8b2219b-53d5-38d2-3407-2476b45500eb@redhat.com>
Date:   Mon, 21 Oct 2019 15:02:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191016162337.GC5866@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 18:23, Sean Christopherson wrote:
>> Yes we can get fancy, but remember that KVM is not yet supporting
>> emulation of locked instructions.  Adding it is possible but shouldn't
>> be in the critical path for the whole feature.
> Ah, didn't realize that.  I'm surprised emulating all locks with cmpxchg
> doesn't cause problems (or am I misreading the code?).

It would cause problems if something was trying to do crazy stuff such
as locked operations on MMIO registers, or more plausibly (sort of...)
SMP in big real mode on pre-Westmere processors.  I've personally never
seen X86EMUL_CMPXCHG_FAILED happen in the real world.

Paolo

> reading the code correctly, the #AC path could kick all other vCPUS on
> emulation failure and then retry emulation to "guarantee" success.  Though
> that's starting to build quite the house of cards.
> 

