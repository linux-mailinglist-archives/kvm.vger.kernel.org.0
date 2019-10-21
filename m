Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7EFDED1C
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 15:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbfJUNGz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 09:06:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbfJUNGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 09:06:55 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E1F76641DA
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 13:06:54 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id 67so7249623wrm.18
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 06:06:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OR1AnertDj9O4GLIj+lVWxAfR9XbJVaHE5lZ4ZzOGVw=;
        b=eMEZMdhP4cUp5jYxlEsN0iAYyESnSf56cens9u/c06+0vE+wT7d9XJdtk9drywrBCd
         uVyMk2nXnUu9mIDYFtgVLRYGLXPIxDJv7XDuC2rwdH8xAAn+ICeryysZCUTepZDirzpR
         bjfWTu9pD9F7wzaFBVqAgucYyiTRzRkyQzveMZeKykbN9z9MLMhYtwtFP7AlCW+IFYUq
         zDzFoQPGiwdWHCMh7JvLCNk2RoQEIGo2+5AagxW2NQSMLWcpjDS87m9nnrBOn/wRJKZ1
         aIsNmouS8MH+51NGzQ+YT+B955Lf4loprAM1E1o+Hf6Z1dmYUVxCHgr0X/NWxHMQQ3J7
         3Cfg==
X-Gm-Message-State: APjAAAXHPHhAdzUGDL+bipir4W5Oav+/OIJX42qtMRh7iKk5nJOMGjjH
        rSHjEYrq6w9et0ZMl2P1xrhDjTxW2RYcWhAXFKeY4h3L7HvzzdpIa2ctC3rr8wpXBiJM9+2kX5+
        uO4VvwcJzWu8O
X-Received: by 2002:a7b:cb42:: with SMTP id v2mr18624149wmj.165.1571663213197;
        Mon, 21 Oct 2019 06:06:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz/4LPbaN2Besmntxj94BKXEekqUBRvHZViOeLPLikyg307qenBIlxEQZdWScP+C+9YX5Gw8g==
X-Received: by 2002:a7b:cb42:: with SMTP id v2mr18624115wmj.165.1571663212929;
        Mon, 21 Oct 2019 06:06:52 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id k3sm1750717wro.77.2019.10.21.06.06.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 06:06:52 -0700 (PDT)
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
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
 <54cba514-23bb-5a96-f5f7-10520d1f0df2@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8c5b11c9-58df-38e7-a514-dc12d687b198@redhat.com>
Date:   Mon, 21 Oct 2019 15:06:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <54cba514-23bb-5a96-f5f7-10520d1f0df2@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/19 03:23, Xiaoyao Li wrote:
> However, without force_emulation_prefix enabled, I'm not sure whether
> malicious guest can create the case causing the emulation with a lock
> prefix and going to the emulator_cmpxchg_emulated().
> I found it impossible without force_emulation_prefix enabled and I'm not
> familiar with emulation at all. If I missed something, please let me know.

It's always possible to invoke the emulator on arbitrary instructions
without FEP:

1) use big real mode on processors without unrestricted mode

2) set up two processors racing between executing an MMIO access, and
rewriting it so that the emulator sees a different instruction

3) a variant of (2) where you rewrite the page tables so that the
processor's iTLB lookup uses a stale translation.  Then the stale
translation can point to an MMIO access, while the emulator sees the
instruction pointed by the current contents of the page tables.

FEP was introduced just to keep the test code clean.

Paolo
