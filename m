Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C028C16840C
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 17:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgBUQub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 11:50:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59814 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727346AbgBUQub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 11:50:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582303830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6NHqowpj9sFTIlaqI5W3sqbjgCgVgH/qVpq549i91vE=;
        b=ijo+lPbFntx/v0BueB9Kd+/Ej0O6FXHRd/Cs/kzd2/JY+OKWoKqWOxGcgfzj/FIdYzmLKS
        fs9P/YQOjDrcP8xZTXGQyt+keOBi9CPqEq+omGRpPP4eHGY+7yone93TVrNh56cvSA2l0Q
        L/EYmiZZVg8AuG0fGmuZj8cpjxdE4EQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-Yc_TgT7FPgezWqFCPfcV1w-1; Fri, 21 Feb 2020 11:50:27 -0500
X-MC-Unique: Yc_TgT7FPgezWqFCPfcV1w-1
Received: by mail-wm1-f72.google.com with SMTP id k21so813266wmi.2
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 08:50:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6NHqowpj9sFTIlaqI5W3sqbjgCgVgH/qVpq549i91vE=;
        b=Ql4rLNojs5VD4PSaoqLd2gLsGrekJbYxqgbZM2BkiqkZUBafAb2pokMCAZPfQ4YMK9
         8XBMGMsosEBHr4yJno6NlqwRtHWhQnPnSNnHiMNksLS+fqZ41vAsJRjkPgn7h/DcuhxJ
         gYmlo+457lPdLillWT8SHprp91vffCtquj2ZedQLjRKbhzY74zJoGtBkDOnU05SkDtYU
         VvXd8hGxv29xghcqSiqG8Sk2R8TvtnkCX1qd8ODaPaQ3cfjB7BPeZud/fJM68NiffNu1
         I0yFjzIrESGCrSmdW7qrTQPJmrN6pSg0OM1tOYANIV5qzCPk1srxCqLxbueuLqc8OtLv
         LxnA==
X-Gm-Message-State: APjAAAXN2XV87CMV21faniiVv22SWnFwbG08P84wkAJf8A5tGSPSqaTJ
        YSLSmv03aTSZKam3TcFfbF+HdR+OT8QxLH8gAWnFlqgkXmn4pPhrqktWGXcBfFK75PhWIEnJjqp
        a3FbFude5td8N
X-Received: by 2002:a05:600c:114d:: with SMTP id z13mr4736972wmz.105.1582303826388;
        Fri, 21 Feb 2020 08:50:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqymKzX64TWzubc4hSzd0fMC8UpF6S1vGssgHLycf1GMTwxlUdeu3kddyaomcTMKsPX4HPf04w==
X-Received: by 2002:a05:600c:114d:: with SMTP id z13mr4736951wmz.105.1582303825996;
        Fri, 21 Feb 2020 08:50:25 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id f1sm4614872wro.85.2020.02.21.08.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 08:50:24 -0800 (PST)
Subject: Re: [PATCH RFC 0/2] KVM: nVMX: fix apicv disablement for L1
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org
References: <20200220172205.197767-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <71921ae9-56b2-2f1c-410b-f61c37db1a17@redhat.com>
Date:   Fri, 21 Feb 2020 17:50:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200220172205.197767-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/02/20 18:22, Vitaly Kuznetsov wrote:
> 
> RFC: I looked at the code and ran some tests and nothing suspicious popped
> out, however, I'm still not convinced this is a good idea to have apicv
> enabled for L2 when it's disabled for L1... Also, we may prefer to merge
> or re-order these two patches.

I swapped the patches and queued them.  The basic observation is that
APICv is only about virtualizing the APIC, without any interaction with
the hypervisor's APIC apart from the IPI path.  So if L1 turns it on it
wants L1 and L2's APICs to be completely independent, and SynIC is
completely irrelevant.  All that matters is again whether the IPI path
works, and that is what patch 2 fixes.

Paolo

