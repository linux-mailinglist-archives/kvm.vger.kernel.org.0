Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC7B2B88C
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 17:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfE0PoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 11:44:16 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:33556 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfE0PoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 11:44:10 -0400
Received: by mail-wr1-f42.google.com with SMTP id d9so17302126wrx.0
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 08:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2A4/Dy7CeUNWJQHbbLk0HO1r8qYMXPrMtWyOg+ikpyk=;
        b=KzSDx165yq32+IDr5c5PA0e7guMO3UTVJ+ItIZlUnA0KxMvvTLpjjv1L6pFMWM5QOd
         c6Eg/uKGTelx7NDt5naTKYmvcy4mwhyKl70LL/hC28kfXmWqte75JzczVyCm8UzHfN6r
         BjLWaZBdqgzV1qNNt3J4WzV+yCPU+NMDua1NhXxJyyrl9QZR8Fs2X3YfNbONOWDmRLFb
         cASFgbD/XEhclrcg9WsJQquD4c/7tArkDyOP62cWrNYv26ocVmdrg3XzgMEFJyr3R8mW
         /TVQRXD7Neg4Q6z81ZnGYatiNl0/nTPHe488encdtm9G8pGBrcTJBb5T3teyKqQAC19n
         F8Zg==
X-Gm-Message-State: APjAAAVXL6OnsPSALdZ31KcOhTfigDudi0RSVrM4y9mQ4zqb4TCOxrv/
        SBLl6ZyxcZ9oN+oCtq06bxGqhw==
X-Google-Smtp-Source: APXvYqxek10K/dO9NSTEttg+mnORuKnxwc7jyGofKaHXmyE/ma/6TRaCxUAv7G+DGuJ8bDopIl1MFQ==
X-Received: by 2002:adf:ef8d:: with SMTP id d13mr6429556wro.60.1558971848967;
        Mon, 27 May 2019 08:44:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c92d:f9e8:f150:3553? ([2001:b07:6468:f312:c92d:f9e8:f150:3553])
        by smtp.gmail.com with ESMTPSA id s62sm22814951wmf.24.2019.05.27.08.44.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 08:44:08 -0700 (PDT)
Subject: Re: [RFC/PATCH] refs: tone down the dwimmery in refname_match() for
 {heads,tags,remotes}/*
To:     Junio C Hamano <gitster@pobox.com>,
        =?UTF-8?B?w4Z2YXIgQXJuZmrDtnLDsCBCamFybWFzb24=?= <avarab@gmail.com>
Cc:     git@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        Michael Haggerty <mhagger@alum.mit.edu>
References: <CAHk-=wgzKzAwS=_ySikL1f=Gr62YXL_WXGh82wZKMOvzJ9+2VA@mail.gmail.com>
 <20190526225445.21618-1-avarab@gmail.com>
 <5c9ce55c-2c3a-fce0-d6e3-dfe5f8fc9b01@redhat.com>
 <874l5gezsn.fsf@evledraar.gmail.com>
 <xmqqef4jewj6.fsf@gitster-ct.c.googlers.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a40c5388-4274-6bfa-4213-6013601c8fae@redhat.com>
Date:   Mon, 27 May 2019 17:44:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <xmqqef4jewj6.fsf@gitster-ct.c.googlers.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/19 17:39, Junio C Hamano wrote:
> I do not think lightweight vs annotated should be the issue.  The
> tag that the requestor asks to be pulled (from repository ../b)
> should be what the requestor has locally when writing the request
> (in repository .).  Even if both tags at remote and local are
> annotated, we should still warn if they are different objects, no?

Right, lightweight vs annotated then is the obvious special case where
one of the two is a commit and the other is a tag, hence they ought not
to have the same SHA1.  I'll take a look.

Paolo
