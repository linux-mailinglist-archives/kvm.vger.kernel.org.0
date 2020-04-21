Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8811B30AD
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 21:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgDUTwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 15:52:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35591 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726017AbgDUTwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 15:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587498772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TTdCjw+xJyiyOVepRoiBzPpX6UPTHW6RSy1+eF5nCoY=;
        b=OKA7CqagVR8YJzhv3BP5d/4LXlmwR9B72PI+za5vSt9aKcCss+YcZnwM860ZfhQj0DUAN+
        Sg+yHE6uGqfnoYoutwIEYKkeQRqSURHX1c6Pvo6v7SQ5U4jTEF1zR6+usFdfwtfCN4o2XT
        02ioOqsbExewzZlU6whFtbws/Yd3K0A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-5n4p6joUO5SDcGQTSGRbUw-1; Tue, 21 Apr 2020 15:52:50 -0400
X-MC-Unique: 5n4p6joUO5SDcGQTSGRbUw-1
Received: by mail-wr1-f71.google.com with SMTP id j16so8264168wrw.20
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 12:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TTdCjw+xJyiyOVepRoiBzPpX6UPTHW6RSy1+eF5nCoY=;
        b=IfUyeKVSbtcFTmHjKrKyR26KMQn7fMHN98T0lQ02c6kCyTGnWYa97CyS711lHZNBJK
         1vJdLMYC08mgvmJbOCGaOseuRvTMxl6rrKq7dG+ZvzJaH4wgOWr6OoSBzqZkBnL+CZSN
         SdoxbSG8hTVsxMpHUgayKNVATEBW3JlMs4AW8JnYDq/1672oW8McREEEioS+3z6nQTwg
         NTLORIHNcEDJfWMSaufs4/1eg1lLs0iZ8mJObocIi2ds2PaNoK+uNAYANBjB874zC//k
         Yl7szDZ/XgwW9IH7oXvwK6WxowCVlKixoQ9PBYzZRNUzY0DrIopJy8qXAY2UFmEYWMnO
         6RoA==
X-Gm-Message-State: AGi0PuYwY96JZcSDeETCDLD6QxmthXGeBBGAJKJonJekcvlS6EiXNbCs
        dBWlkfk/5sS8j4HMDUzKTu1BdPt/ZavbPkQ1Rbh5ltWgf4V7o2EzFGlMD7Tard8SAlv43tzGunE
        BxDpMZo50JlVX
X-Received: by 2002:adf:bc05:: with SMTP id s5mr25183113wrg.70.1587498769683;
        Tue, 21 Apr 2020 12:52:49 -0700 (PDT)
X-Google-Smtp-Source: APiQypLppZDmxlXD8GhpLz87T+p+wy/ipriyB1TljFwkP+/SqFt2cdsfkDNAw/S0mujJ1KBuTCSHFg==
X-Received: by 2002:adf:bc05:: with SMTP id s5mr25183091wrg.70.1587498769480;
        Tue, 21 Apr 2020 12:52:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id 5sm4473852wmg.34.2020.04.21.12.52.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 12:52:48 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: Replace vcpu->swait with rcuwait
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     Marc Zyngier <maz@kernel.org>, tglx@linutronix.de,
        kvm@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>,
        peterz@infradead.org, torvalds@linux-foundation.org,
        bigeasy@linutronix.de, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, linux-mips@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>, joel@joelfernandes.org,
        will@kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200324044453.15733-1-dave@stgolabs.net>
 <20200324044453.15733-4-dave@stgolabs.net>
 <20200420164132.tjzk5ebx35m66yce@linux-p48b>
 <418acdb5001a9ae836095b7187338085@misterjones.org>
 <20200420205641.6sgsllj6pmsnwrvp@linux-p48b>
 <f7cc83fe-3e91-0057-9af2-26c201456689@redhat.com>
 <20200420215014.sarodevmhphnkkn7@linux-p48b>
 <02e1b00d-a8ea-a947-bbe6-0b1380aa7ec4@redhat.com>
 <20200421180733.xrl5ta6cuo2weuva@linux-p48b>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ab78bbc8-aa03-6e88-940e-5e1c041f48e4@redhat.com>
Date:   Tue, 21 Apr 2020 21:52:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200421180733.xrl5ta6cuo2weuva@linux-p48b>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/20 20:07, Davidlohr Bueso wrote:
>> 
> 
> I should have looked closer here - I was thinking about the return
> value of rcuwait_wait_event. Yes, that signal_pending check you
> mention makes the sleep semantics change bogus as interruptible is no
> longer just to avoid contributing to the load balance.
> 
> And yes, unfortunately adding prepare_to and finish_rcuwait() looks
> like the most reasonable approach to keeping the tracepoint
> semantics. I also considered extending rcuwait_wait_event() by
> another parameter to pass back to the caller if there was any wait at
> all, but that enlarges the call and is probably less generic.

Yes, at some point the usual prepare_to/finish APIs become simpler.

> I'll send another version keeping the current sleep and tracepoint 
> semantics.

Thanks---and sorry, I should have noticed that way earlier.

Paolo

