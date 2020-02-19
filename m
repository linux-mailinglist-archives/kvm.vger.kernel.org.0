Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA342164C8D
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 18:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgBSRvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 12:51:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39553 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726712AbgBSRvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 12:51:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582134668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rmu/eivGKnHsckZ9SlN4grVeY3oFFfk+D2Xi3Y537u0=;
        b=f1SUOGgcXQCTD7ZZNlkOEUoTUPsEoUTJEtL+LpehPMoVUVaI3pnPIvkzROQtfZudP7jDLq
        5QXZ9cx2Hezr6QUUcKb8JD04BblDhyPto8Sc5ypg1l5/N+I3EtHZdCKPC3La7u+/9OImll
        aBVwltji2Y33/Jnt/S9MnOPwPfSp7KY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-cQUCMCxhNdGn1XSY7GWQsA-1; Wed, 19 Feb 2020 12:51:04 -0500
X-MC-Unique: cQUCMCxhNdGn1XSY7GWQsA-1
Received: by mail-wm1-f71.google.com with SMTP id m4so534409wmi.5
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 09:51:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rmu/eivGKnHsckZ9SlN4grVeY3oFFfk+D2Xi3Y537u0=;
        b=fXQCew9mbk0RNwB9qyA+bFMpkE63e4fM/5og9rk8TUNDZTX2MznD2hscYc4mnQ9Wdu
         Q5WWE7R9LW4yz4+TZ50DSYC6qrhFI3OnFKnYTFszGtjixOED3Dj1w/ZSiuvVq/Uga+gS
         VEqMBQHSFKOYZBtdEWgpB/oqe3URgULTEOA9Mn/J4I8iU7Uci3NF0DkCpspSeO7Msy8b
         kL6XyEVK9RVc98zDL4oWJMxEFTOFflzEQuJuqSRzty5m5hf0RE0l4OfokqdLtF8bhfDx
         rMpxiJP/RqE/c33OwSwoWjcflixY7fJe2LWkOIkUdoTcfSlDClgaPKXx7oXgfh6qpur0
         hD3g==
X-Gm-Message-State: APjAAAUccRpm2lBmJvrsIM5St76iDXzvdoIc853fYzCFX0uVA+91nyoJ
        C2kFO78l+aPckreTISN6nuzeYOOEtf7wJ86Q1eRp9cFe6vvGgyWJitzG+lHdcN/9K42x4d90OLZ
        dt7bKEjk5sEov
X-Received: by 2002:a1c:a382:: with SMTP id m124mr11290571wme.90.1582134663409;
        Wed, 19 Feb 2020 09:51:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqxjOrkRfd1hE1t7VmANmhu3DjJxXoMreSD+qGtuXhnlmKXNCZCyZyfbMbfvpQLPfT8+krtr1w==
X-Received: by 2002:a1c:a382:: with SMTP id m124mr11290544wme.90.1582134663118;
        Wed, 19 Feb 2020 09:51:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ec41:5e57:ff4d:8e51? ([2001:b07:6468:f312:ec41:5e57:ff4d:8e51])
        by smtp.gmail.com with ESMTPSA id l15sm639955wrv.39.2020.02.19.09.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 09:51:02 -0800 (PST)
Subject: Re: [PATCH] kvm: x86: Print "disabled by bios" only once per host
To:     Erwan Velu <e.velu@criteo.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Erwan Velu <erwanaliasr1@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200214143035.607115-1-e.velu@criteo.com>
 <20200214170508.GB20690@linux.intel.com>
 <70b4d8fa-57c0-055b-8391-4952dec32a58@criteo.com>
 <20200218184802.GC28156@linux.intel.com>
 <91db305a-1d81-61a6-125b-3094e75b4b3e@criteo.com>
 <20200219161827.GD15888@linux.intel.com>
 <646147a6-730b-0366-10db-ed74489ad11e@criteo.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ea2800cf-4c23-9cb5-5904-08a709f6d594@redhat.com>
Date:   Wed, 19 Feb 2020 18:51:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <646147a6-730b-0366-10db-ed74489ad11e@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/02/20 17:53, Erwan Velu wrote:
> 
> 
> I've been testing the ratelimited which is far better but still prints
> 12 messages.

12 is already much better than 256.  Someone else will have an even
bigger system requiring a larger delay, so I'd go with the default.

Paolo

> I saw the ratelimit is on about 5 sec, I wonder if we can explicit a
> longer one for this one.
> 
> I searched around this but it doesn't seems that hacking the delay is a
> common usage.
> 
> Do you have any insights/ideas around that ?
> 
> 
> Switching to ratelimit could be done by replacing the actual call or add
> a macro similar to  kvm_pr_unimpl() so it can be reused easily.

