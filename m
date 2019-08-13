Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 980308C28E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 23:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfHMVDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 17:03:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41215 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfHMVDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 17:03:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id j16so6787283wrr.8
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 14:03:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tEhHgLcqlA5tSM/U7PsVGRMmj61U+t1w86jQUqeFNZo=;
        b=pvSdnyckch9MIN26oFs0E0l7Rc1wBtK1GzSgybjvWMNdagvju9ZVU1hNfbDCPY04FP
         dRuVTYCKNRoYOfjyPe/GSGsvYucwTZ63ohu7DN/RShB39ppP+Q+SFhioynaMFLeRa7/7
         y5/3HUtCcvBasVh7OKfdOyxJwJTpz2EptsUev6IfC2JiDibVYx+DWiI96mAviX+JOwGi
         BIijeyFRkj/Mvd7HHyiQhJvqM63l81r/8pakCohOACiFW3kjXHiHoznnU1pa20i0VsCH
         YE0HVY3MJe//N1GJgUEpyHT8IwWgzDCHmvaljhYsZwN1YgfVNUjWkGCwyOAX/gxjaAWf
         b7Bg==
X-Gm-Message-State: APjAAAWvMLYHMqa4v3YGDu7SqjtiTQ70W3x3kALyafEZElZbeP67Eavs
        sshn2bp716sxdgGqXGxIaRwepQ==
X-Google-Smtp-Source: APXvYqzCH0YYNT+mm2NCMtG/p/XSQ0nRVPLtvaYvNv2whhtGv6yScErnL+PDu/Cb4oX9gIIDZ6+Shg==
X-Received: by 2002:a05:6000:14b:: with SMTP id r11mr48965825wrx.196.1565730192616;
        Tue, 13 Aug 2019 14:03:12 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id u8sm1872737wmj.3.2019.08.13.14.03.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 14:03:11 -0700 (PDT)
Subject: Re: [RFC PATCH v6 01/92] kvm: introduce KVMI (VM introspection
 subsystem)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?Q?Mircea_C=c3=aerjaliu?= <mcirjaliu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-2-alazar@bitdefender.com>
 <20190812202030.GB1437@linux.intel.com>
 <5d52a5ae.1c69fb81.5c260.1573SMTPIN_ADDED_BROKEN@mx.google.com>
 <5fa6bd89-9d02-22cd-24a8-479abaa4f788@redhat.com>
 <20190813150128.GB13991@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <add4f505-7011-c7f4-2361-c8814cac2424@redhat.com>
Date:   Tue, 13 Aug 2019 23:03:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813150128.GB13991@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/19 17:01, Sean Christopherson wrote:
>>> It's a bit unclear how, but we'll try to get ride of the refcount object,
>>> which will remove a lot of code, indeed.
>> You can keep it for now.  It may become clearer how to fix it after the
>> event loop is cleaned up.
> By event loop, do you mean the per-vCPU jobs list?

Yes, I meant event handling (which involves the jobs list).

Paolo
