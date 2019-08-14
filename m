Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5E958D3D8
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 14:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbfHNMxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 08:53:51 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36299 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbfHNMxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 08:53:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so4378105wme.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2019 05:53:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w/9WmrcXj+WSf8mG3UP1CEm5oCxjeGmdpSMvc0IgVzQ=;
        b=GxWDKFaN06q3ZgwMBqZ+3Ypsqg5eYguDYuNwkbrrTdlXNc/d3Bkw262XKmBarT8XW0
         FGj4k6SVZ2zSPUyKUk+ad+cDg/cEZSK8fiKaUyYjUPDSP97f9qttElvdfHgb55U1U4mk
         HKZ78apsoSD7o+Gl4EmMnTTdX7d6WlTHQvmrWAQ8F202ktnQoFVRSJLdaIaNQFrfP5xa
         h3SCkjnpnGcKUU1EOt3eor5XQYr8mD3K9vzI6u0cH9RVws34lZtOX28BIoB4Gc8Leusj
         RZUfbDOroKh4IjiDJSZcT1xP7o4llXm6CGR2wBmrz3pZk3jgaIxGiI1hzSdw7NeDswBx
         fGEw==
X-Gm-Message-State: APjAAAVqCIl/E7zwVTUPkQS3ywg9UqF3Wky+moz5RjuXWeHhIVOQ04Az
        10hDqQTt2FR7JvK/AgI/4NnfHA==
X-Google-Smtp-Source: APXvYqzEPFLFieg69AnBNaGIyKSm/YC4cyNCjZwla3TXgTG28lqZ11s6Gsx1a538xj5khmA4ksXdvw==
X-Received: by 2002:a1c:c018:: with SMTP id q24mr8315429wmf.162.1565787228293;
        Wed, 14 Aug 2019 05:53:48 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id d19sm28086256wrb.7.2019.08.14.05.53.46
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 05:53:47 -0700 (PDT)
Subject: Re: [RFC PATCH v6 64/92] kvm: introspection: add single-stepping
To:     Nicusor CITU <ncitu@bitdefender.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        "Zhang@linux.intel.com" <Zhang@linux.intel.com>,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-65-alazar@bitdefender.com>
 <20190812205038.GC1437@linux.intel.com>
 <f03ff5fbba2a06cd45d5bebb46da4416bc58e968.camel@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5851eb00-3d00-1213-99cb-7bab2da3ba89@redhat.com>
Date:   Wed, 14 Aug 2019 14:53:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f03ff5fbba2a06cd45d5bebb46da4416bc58e968.camel@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/08/19 14:36, Nicusor CITU wrote:
> Thank you for signaling this. This piece of code is leftover from the
> initial attempt to make single step running.
> Based on latest results, we do not actually need to change
> interruptibility during the singlestep. It is enough to enable the MTF
> and just suppress any interrupt injection (if any) before leaving the
> vcpu entering in guest.
> 

This is exactly what testcases are for...

Paolo
