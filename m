Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0828BBD5
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 16:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfHMOpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 10:45:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38196 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728793AbfHMOpP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 10:45:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so108000925wrr.5
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 07:45:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jWtEd3owCPSOaSqnFheJ8jWjvLGAgQi5lkfcBCpyD7o=;
        b=UevYMYv+8ldS6wgGNAFTk08WzQQqvUnr8Vkgx6vqHybt+7u12XLGrDUQNYfYKUoTSL
         zcHhrThB999kKNx8VdV1GqKl+3V45cL5fU8w1yGbcMQ5XFIQQNNmUzkYz2KC4O0OJcI7
         6/x2sr8pTuGXDM9hwkJb72QFPcGtzrTrX/Y+hW25C0SsDm4+ZcNxL1o4VNJIckkYgUdU
         zLxkiWzIhqaRZRZd5nRM1sIusXZJWGYZXz3ndC4kB1ttymVeyP+jV/nKooZgqaHEWE5N
         5Ez8XRrD+TDZ9yqdFez0EEUusRPU8mhU1cl3YOKmybe2spPYKUR/Aek4yqQZgSGCFAf3
         sU2A==
X-Gm-Message-State: APjAAAVeZM6EnAOGmaHnee2imPd736kEcTHZak77eANUGVK/HO5BDxdQ
        IGBia2uqLyuzhpqoT2uhHl1U9w==
X-Google-Smtp-Source: APXvYqwcGE4nFuUbUV12L+CuV8ssqEc28LeuFzgoubUsbyKYX9+fTashqIpI1VrJDY8+MqB+OZnDSA==
X-Received: by 2002:adf:fc51:: with SMTP id e17mr43958026wrs.348.1565707513708;
        Tue, 13 Aug 2019 07:45:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5193:b12b:f4df:deb6? ([2001:b07:6468:f312:5193:b12b:f4df:deb6])
        by smtp.gmail.com with ESMTPSA id x20sm237275027wrg.10.2019.08.13.07.45.12
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 07:45:13 -0700 (PDT)
Subject: Re: [RFC PATCH v6 14/92] kvm: introspection: handle introspection
 commands before returning to guest
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?Q?Mircea_C=c3=aerjaliu?= <mcirjaliu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-15-alazar@bitdefender.com>
 <645d86f5-67f6-f5d3-3fbb-5ee9898a7ef8@redhat.com>
 <5d52c10e.1c69fb81.26904.fd34SMTPIN_ADDED_BROKEN@mx.google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <97cdf9cb-286c-2387-6cb5-003b30f74c7e@redhat.com>
Date:   Tue, 13 Aug 2019 16:45:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5d52c10e.1c69fb81.26904.fd34SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/19 15:54, Adalbert Lazăr wrote:
>     Leaving kvm_vcpu_block() in order to handle a request such as 'pause',
>     would cause the vCPU to enter the guest when resumed. Most of the
>     time this does not appear to be an issue, but during early boot it
>     can happen for a non-boot vCPU to start executing code from areas that
>     first needed to be set up by vCPU #0.
>     
>     In a particular case, vCPU #1 executed code which resided in an area
>     not covered by a memslot, which caused an EPT violation that got
>     turned in mmu_set_spte() into a MMIO request that required emulation.
>     Unfortunatelly, the emulator tripped, exited to userspace and the VM
>     was aborted.

Okay, this makes sense.  Maybe you want to handle KVM_REQ_INTROSPECTION
in vcpu_run rather than vcpu_enter_guest?

Paolo
