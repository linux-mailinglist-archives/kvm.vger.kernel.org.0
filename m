Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE61158E50
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 13:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbgBKMUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 07:20:48 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27797 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727723AbgBKMUq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 07:20:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581423645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7YKK5qbTJbzv97NbN+A209f4bfVu66ItLSv9H/GvglE=;
        b=QR0ZO+vKpnAv5mWjNcAaJTaQR4vUDQBgz10mc/VV0LUD+iLuxZE4kprLleZdxceiQcZQGo
        +C8e8yBROodriQG72/UxSTVMVe7Isot0NP/M+x+YVJlQQagNV11s0PCAy6NbDMTJaIi3cl
        kyZES8wnmoazunqkdJWJ0dIaLwRXfVE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-LVYdxiiRNR6_MHqZYZCUvg-1; Tue, 11 Feb 2020 07:20:42 -0500
X-MC-Unique: LVYdxiiRNR6_MHqZYZCUvg-1
Received: by mail-wm1-f71.google.com with SMTP id z7so979432wmi.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 04:20:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7YKK5qbTJbzv97NbN+A209f4bfVu66ItLSv9H/GvglE=;
        b=F/3tM7CyHGTRnLOL3hrB5ytSvDhv4EJ4gmK8doZfEX2PjCC9aY1gs4IkCRE5OwbIRR
         x+raZ2c+oS/wIeKyL84FO4lHc8jf3PsURZWRf/Ki5hoZAZ0kwC5sNLq4CsUh5xLzka3s
         ZOkh6H4OD7mBU0RzrIf2JOmOZuZ/ve1GBGqxo0f+2d+UEQVPKqz9wY3rXEf7S9TJoQ+Q
         CRBalTpH4Vb1YJ7LrcA9Zw3DLkdtkrWy35e+vZl3QJ+nl+1fbvPf9aD1TAYX54uZWkc5
         WIRn8zJf6noVvdCy91bwm8ICLguR8RDLetFMVPrutiNb+s61pAbNJfuHpmK66dbydZht
         YBYw==
X-Gm-Message-State: APjAAAXqd9xpxfcwM1PwzdFZuvBj8PWcT9waxX6R6F9nvBENRxXa14I3
        9bKVnr5/1k9u0hSn3CyCzaTMKC04XZ03KTMoBGjDCzhev8rHZ7NjtIC+ps2GdTwSqV4tz3QfY2Q
        6PszxEoA8rJyo
X-Received: by 2002:a5d:410e:: with SMTP id l14mr7962948wrp.238.1581423641082;
        Tue, 11 Feb 2020 04:20:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqzYmEhFeabc16XxIDsU9tj29ediGktcdItP3SRO0jeU74xVa2TtLyGXriu2B1irqx6mHAIwzA==
X-Received: by 2002:a5d:410e:: with SMTP id l14mr7962927wrp.238.1581423640836;
        Tue, 11 Feb 2020 04:20:40 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:bd91:9700:295f:3b1e? ([2001:b07:6468:f312:bd91:9700:295f:3b1e])
        by smtp.gmail.com with ESMTPSA id g17sm5123721wru.13.2020.02.11.04.20.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 04:20:40 -0800 (PST)
Subject: Re: [PATCH v2 3/6] kvm: x86: Emulate split-lock access as a write
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
 <20200203151608.28053-4-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <95d29a81-62d5-f5b6-0eb6-9d002c0bba23@redhat.com>
Date:   Tue, 11 Feb 2020 13:20:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200203151608.28053-4-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/20 16:16, Xiaoyao Li wrote:
> A sane guest should never tigger emulation on a split-lock access, but
> it cannot prevent malicous guest from doing this. So just emulating the
> access as a write if it's a split-lock access to avoid malicous guest
> polluting the kernel log.

Saying that anything doing a split lock access is malicious makes little
sense.

Split lock detection is essentially a debugging feature, there's a
reason why the MSR is called "TEST_CTL".  So you don't want to make the
corresponding behavior wrong.  Just kill the guest with a
KVM_INTERNAL_ERROR userspace exit so people will notice quickly and
either disable the feature or see if they can fix the guest.

Paolo

