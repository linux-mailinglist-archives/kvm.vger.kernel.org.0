Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0801B1810
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 23:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgDTVKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 17:10:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42308 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725774AbgDTVJ7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 17:09:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587416998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7lDCFaFUw4R9AWRYUPjaGqLtTptNqr4/gsP5Cs91YoI=;
        b=i3QzTOsIAck+sP2L+KgYkA1GHxlNVDHp/1bbrNXp6//5fnheMEVNxO7R1RFF7QFSarmv0p
        BJRfVel0tsAgydbwwUJXWfvjzcv32pROe5sKwC95HD61CR1GZ/KgfE66M2+xC8Mc2n25Cq
        OUGuq88gTl4PYWGvCQoEwj8AQ4cv1no=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-4tVM5bpUMKyvMIXleMy_Aw-1; Mon, 20 Apr 2020 17:09:57 -0400
X-MC-Unique: 4tVM5bpUMKyvMIXleMy_Aw-1
Received: by mail-wm1-f69.google.com with SMTP id o5so451165wmo.6
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 14:09:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7lDCFaFUw4R9AWRYUPjaGqLtTptNqr4/gsP5Cs91YoI=;
        b=tPbP1MMXZDoZzLk3i9NRLHRdXdxDEJdY65L6VHudqYCBsgWAzBU5ohAv2gGxlLCk3z
         ANU9k3FLSd7Nyc+YNM8pGda7DvC4Q1YNMIJbSzV/cFnOLpNCUj1IRiOe4DnESLF0Y9t3
         xpp5MOeTY0izyqFTOi6YPLd87SgDr/UsQHAGD2KbKI7QIpxP772gojI0jonyyLivqOa7
         W9f1ziYmmd0gFvDoNp7Le9e+7OHmht0bKLhEVGrJdJqFlrl7Sqz/ahP1iKmd5P/U4IvQ
         vxSR/biqSXZsXKhqhcGYPwP2ETjI4Y5jYFkbyr6NDcz87iGroleWHPxlc0yAml73piiz
         brrA==
X-Gm-Message-State: AGi0PuaErtkLEhQuQ4oA/eb0kkJC9YfnKTFuPA0wRoTUYGZYlGTXWQ1Y
        ws5H3c5fAXzFVy1SLlsyKZKDt0/iPb/tnrc4vnGfKS96z3mBM4m45GsNpqwPJfbWOnP6r0aye1Q
        QJBtQ/gBi18Ls
X-Received: by 2002:a1c:2e0a:: with SMTP id u10mr1274824wmu.119.1587416996032;
        Mon, 20 Apr 2020 14:09:56 -0700 (PDT)
X-Google-Smtp-Source: APiQypK6od6W0dj1gZbWeyxDBs/v6PJZ1fc/3Z8V3Hi0ONmnXmb1L3h9dzlN2r24n5ADl1uYH1Bh5A==
X-Received: by 2002:a1c:2e0a:: with SMTP id u10mr1274770wmu.119.1587416995274;
        Mon, 20 Apr 2020 14:09:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5c18:5523:c13e:fa9f? ([2001:b07:6468:f312:5c18:5523:c13e:fa9f])
        by smtp.gmail.com with ESMTPSA id j13sm901220wro.51.2020.04.20.14.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 14:09:54 -0700 (PDT)
Subject: Re: [PATCH] kvm: add capability for halt polling
To:     Jon Cargille <jcargill@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200417221446.108733-1-jcargill@google.com>
 <87d083td9f.fsf@vitty.brq.redhat.com>
 <CANxmayg3ML5_w=pY3=x7_TLOqawojxYGbqMLrXJn+r0b_gvWgA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <02039a7b-01b4-ea5c-bd73-100ea753bf5e@redhat.com>
Date:   Mon, 20 Apr 2020 23:09:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CANxmayg3ML5_w=pY3=x7_TLOqawojxYGbqMLrXJn+r0b_gvWgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/20 20:47, Jon Cargille wrote:
>> Is it safe to allow any value from userspace here or would it maybe make
>> sense to only allow [0, global halt_poll_ns]?
> I believe that any value is safe; a very large value effectively disables
> halt-polling, which is equivalent to setting a value of zero to explicitly
> disable it, which is legal.

Doesn't a large value make KVM poll all the time?  But you could do that
just by running "for (;;)" so there's no reason to limit the parameter.

Paolo

