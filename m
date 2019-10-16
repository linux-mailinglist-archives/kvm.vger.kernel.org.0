Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C92D8F62
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 13:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404909AbfJPL0i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 07:26:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389701AbfJPL0i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 07:26:38 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF58185360
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 11:26:37 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id z205so1063020wmb.7
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 04:26:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AmDD8rV/4ss55aPkIj/Kxa/elLa9S+t5SdIR+jVrE6Y=;
        b=Le+XXM7gUqFzBD3PVIo+GV1LHlJ+jCfNWpAiDUqNQ0wEzEMDcHmE3/gDAyZnkOwdEZ
         3xb7gJm1qrT9AIYAzocnqc9Czw6s7oNX6DcA+xo714IfgnGdj+y85dMQYlP7GFzIHZee
         3BpeVfJ3BEXIPY23njxcO9/SIeNmTNbqn6dp9HiD89pfBgd+S1Ml+6MUgKqR/v5bUCnr
         hOjooyrqivZKA/5XXC855zQuCBTxlyURiJRRigoEKrblXmFdO2CltGifB798cS53/Zw+
         PB8qtLDt77C3wQhRlUCQTTAw/nqT9fCyLVZpQOZFvr54pCHYB4mgymMMNPSxzA/fLx0I
         +10g==
X-Gm-Message-State: APjAAAWWShyLZP7C0axV0rojSupdniNYFe+b1dYchOuvYW1T0BO6DB+4
        cgt1210Cb3BBWyVsOzrK3wGucIIBR/z3BwtijPVlsJSauxAJ7WCByWCzes5piHJFxis9RvdTKWx
        VYuZKox8YqmQV
X-Received: by 2002:a5d:4a87:: with SMTP id o7mr2366020wrq.374.1571225196188;
        Wed, 16 Oct 2019 04:26:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzxt7Ch8OEk4m4oTfe5uVlwjGCFhsFo8DPHcaBp7QjGTURqov0ZV0Sbqg0WNheETxcfIkxchw==
X-Received: by 2002:a5d:4a87:: with SMTP id o7mr2365992wrq.374.1571225195888;
        Wed, 16 Oct 2019 04:26:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id n22sm2163146wmk.19.2019.10.16.04.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 04:26:35 -0700 (PDT)
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
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
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de>
 <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de>
 <20190925180931.GG31852@linux.intel.com>
 <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com>
Date:   Wed, 16 Oct 2019 13:26:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 13:23, Xiaoyao Li wrote:
> KVM always traps #AC, and only advertises split-lock detection to guest
> when the global variable split_lock_detection_enabled in host is true.
> 
> - If guest enables #AC (CPL3 alignment check or split-lock detection
> enabled), injecting #AC back into guest since it's supposed capable of
> handling it.
> - If guest doesn't enable #AC, KVM reports #AC to userspace (like other
> unexpected exceptions), and we can print a hint in kernel, or let
> userspace (e.g., QEMU) tell the user guest is killed because there is a
> split-lock in guest.
> 
> In this way, malicious guests always get killed by userspace and old
> sane guests cannot survive as well if it causes split-lock. If we do
> want old sane guests work we have to disable the split-lock detection
> (through booting parameter or debugfs) in the host just the same as we
> want to run an old and split-lock generating userspace binary.

Old guests are prevalent enough that enabling split-lock detection by
default would be a big usability issue.  And even ignoring that, you
would get the issue you describe below:

> But there is an issue that we advertise split-lock detection to guest
> based on the value of split_lock_detection_enabled to be true in host,
> which can be turned into false dynamically when split-lock happens in
> host kernel.

... which means that supposedly safe guests become unsafe, and that is bad.

> This causes guest's capability changes at run time and I
> don't if there is a better way to inform guest? Maybe we need a pv
> interface?

Even a PV interface would not change the basic fact that a supposedly
safe configuration becomes unsafe.

Paolo
