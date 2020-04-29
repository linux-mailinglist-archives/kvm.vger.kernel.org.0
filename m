Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AF51BE56E
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 19:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgD2Rk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 13:40:58 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37742 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726774AbgD2Rk6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 13:40:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588182056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ifxZyJaIcgDMF24Z/FnGdjxceJQS9w7pXlbPKDemc0=;
        b=Q3jXwt47s/rLcW65RCo4z8AFPM7E7U8cxtTpYwJddsT8t+gWSu+DJiNR+A1SF0KL04BYsh
        7z/4DAzWtZQ4x5PGKLDg45nkL6OLw4lFUIoK6vQr5F2AQY4SZsMof1APlCSMZF6EpcAXrq
        0pDFZ4/q9qq9JDpcH6rxPZ1/uKyhvwA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-zyn5QC8yPsSzi-3udlZifA-1; Wed, 29 Apr 2020 13:40:55 -0400
X-MC-Unique: zyn5QC8yPsSzi-3udlZifA-1
Received: by mail-wr1-f70.google.com with SMTP id p16so2103856wro.16
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 10:40:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+ifxZyJaIcgDMF24Z/FnGdjxceJQS9w7pXlbPKDemc0=;
        b=BBDktEyACf/ZbYO9qKe7C0TFlsiylRHaYFQiYkETCroLcuHmgZ/CAL8hRJipVrXF1+
         hYZ2irj/16qAtRAdriHLinUvJVY02mDg3rh78MaPY1aSzpLYrtQZi09JBZvEimJuSSzt
         FRN0+2gzCIEKSR5leKiRrpgPoX+8DLjqaIVd7BZ41IqRmBDwAmJHrKAwnMKXCp1Ia+XQ
         bXQEnUXWFS2D4oLHSNA7iqla9cqp7Gi6CuaNFI50gv/UUdsTQZFqkFZwudAeux9U5PAX
         +BR31Them2rRh55G4kgybvIfGbyBd38bkpPtzrJ1sTYCBSDwGTCrLgLUEKTE2JTux60K
         8roA==
X-Gm-Message-State: AGi0PuaCvn8iLQdqSL5az96ElfwXkK6tocTxqqzENngfeDhFggtCkzUL
        ZC5tCnDYoRw/rxIpbyuj2XMwS6tsTodGg/blUWt5wJ7hYgfMXmkU7LUmzGYTDa1u8MNdTpkT7CP
        Tab6ZFOny0s5l
X-Received: by 2002:a1c:1d92:: with SMTP id d140mr4387552wmd.67.1588182054030;
        Wed, 29 Apr 2020 10:40:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypKJurOLijS7qOB8eqd6TzSPyHSGOpNFHCTkIqRnaycYuXvYCsf9epD1BeOSFaygjfwcKqsDRA==
X-Received: by 2002:a1c:1d92:: with SMTP id d140mr4387530wmd.67.1588182053727;
        Wed, 29 Apr 2020 10:40:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2c8e:3b22:4882:7794? ([2001:b07:6468:f312:2c8e:3b22:4882:7794])
        by smtp.gmail.com with ESMTPSA id n6sm33498690wrs.81.2020.04.29.10.40.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 10:40:53 -0700 (PDT)
Subject: Re: [PATCH RFC 4/6] KVM: x86: acknowledgment mechanism for async pf
 page ready notifications
To:     Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-5-vkuznets@redhat.com>
 <CALCETrXEzpKNhNJQm+SshiEfyHjYkB7+1c+7iusZy66rRsWunA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0de4a809-e965-d0ad-489f-5b011aa5bf89@redhat.com>
Date:   Wed, 29 Apr 2020 19:40:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALCETrXEzpKNhNJQm+SshiEfyHjYkB7+1c+7iusZy66rRsWunA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 19:28, Andy Lutomirski wrote:
> This seems functional, but I'm wondering if it could a bit simpler and
> more efficient if the data structure was a normal descriptor ring with
> the same number slots as whatever the maximum number of waiting pages
> is.  Then there would never need to be any notification from the guest
> back to the host, since there would always be room for a notification.

No, it would be much more complicated code for a slow path which is
already order of magnitudes slower than a vmexit.  It would also use
much more memory.

> It might be even better if a single unified data structure was used
> for both notifications.

That's a very bad idea since one is synchronous and one is asynchronous.
 Part of the proposal we agreed upon was to keep "page not ready"
synchronous while making "page ready" an interrupt.  The data structure
for "page not ready" will be #VE.

Paolo

