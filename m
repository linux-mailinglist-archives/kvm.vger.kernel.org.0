Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7383C1168F9
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 10:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfLIJPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 04:15:16 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22965 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727370AbfLIJPM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Dec 2019 04:15:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575882911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YfELO45T0KxxEI+GHyVFfpIjRmClA+hBogWql5/W6SQ=;
        b=f4yX73UzOXwC/5HsOrgxhBCaj3AvQmeGI+KH/Fdt9sVxnojb/KwLb2xmcDGeX3S/hggy9G
        /CYlvOqIsGxcJJx4tNGD7PnM1A/EExkq8bCUepRNr1+qp70ny7ABOyYSX58VtTqocU63TK
        tvbJvkHSTlzoLGqYqk5VmBJLJo0GxB4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-ycsPezmHPnOwdQEk2RoEfQ-1; Mon, 09 Dec 2019 04:15:09 -0500
Received: by mail-wr1-f72.google.com with SMTP id r2so7228924wrp.7
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 01:15:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YfELO45T0KxxEI+GHyVFfpIjRmClA+hBogWql5/W6SQ=;
        b=NSSsr/Tk2AdJDjX2TxFLkTKsgZjtbp/vEbN4gtfXB2UKm3702HTre9BeUokrcbO2mv
         xBD3de2DpChwbBZVX/qUfbTib7FgvH+QyHQtFdpAW0dbD+6VUfXZ3uces6PeBQrPO4ji
         +SyX56w1CJDo57YzwNtrOm6Pc1bd0DGAu9X3y2hwFlbpPyXWQir7++3saOPwP0bfh5cz
         DSNVRK8U2cxTabEGVFLXjyol1JtngaeK0ns/XMtAAFqJsc9wRTlJ9jKxI4Os3Pd+5pIS
         qpxyDRZRVNkfgKzdSJV4EYouijkh09WQzOPqLEL2RNPNlU5rgcEWrrGZZGT+6QU2Gs2/
         GOdg==
X-Gm-Message-State: APjAAAXy5R6xkk93TGK++W23xb3fkxVjQGnx3XBC1BLCRw+ZUZX1cock
        vM1YlQElnC69Ilz2D4wiM78RHFeyTenU+yPF5xpn3iNMDNLpUR51pqD692IFPD5QoIfAb4uK7mw
        CD0LZ4YhPXeDG
X-Received: by 2002:adf:df8e:: with SMTP id z14mr906545wrl.190.1575882908454;
        Mon, 09 Dec 2019 01:15:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqzx+0F73j75Sg0V4zv67J/A/gwFnTAMcfnz17PTb7O/+EUxA4H0I9/yLw8pcSUGf1X5vymqMA==
X-Received: by 2002:adf:df8e:: with SMTP id z14mr906513wrl.190.1575882908118;
        Mon, 09 Dec 2019 01:15:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id t81sm13500137wmg.6.2019.12.09.01.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 01:15:07 -0800 (PST)
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
To:     Ankur Arora <ankur.a.arora@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        kvm@vger.kernel.org
References: <20191105161737.21395-1-vkuznets@redhat.com>
 <de3cade3-c069-dc6b-1d2d-aa10abe365b8@redhat.com>
 <4f835a11-1528-a04e-9e06-1b8cdb97a04d@oracle.com>
 <87wob9d0t3.fsf@vitty.brq.redhat.com>
 <2e16b707-f020-22a3-a618-4960db917dfa@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a8e0cd22-f61f-88e4-1594-6784fb39e41f@redhat.com>
Date:   Mon, 9 Dec 2019 10:15:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <2e16b707-f020-22a3-a618-4960db917dfa@oracle.com>
Content-Language: en-US
X-MC-Unique: ycsPezmHPnOwdQEk2RoEfQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/19 21:31, Ankur Arora wrote:
>> If we, however, discuss other hints such 'pre-ACK' mechanism may make
>> sense, however, I'd make it an option to a 'challenge/response'
>> protocol: if host wants to change a hint it notifies the guest and waits
>> for an ACK from it (e.g. a pair of MSRs + an interrupt). I, however,
>
> My main reason for this 'pre-ACK' approach is some discomfort with
> changing the CPUID edx from under the guest.

Changing the CPUID is fine, if we document which CPUID can change.
There are CPUID leaves that change at runtime, for example in leaf 0Dh
(though in that case it's based on XCR0 and not on external circumstances).

> As we've discussed offlist, the particular hint I'm interested in is
> KVM_HINT_REALTIME. That's not a particularly good candidate though
> because there's no correctness problem if the host does switch it
> off suddenly. 

Or perhaps it's a good candidate, exactly because there's no correctness
problem.  For SMT topology, there are security issues if the host
doesn't respect it anymore, so making it changeable is of limited utility.

Paolo

