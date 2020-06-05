Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06CA1EF6F6
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 14:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgFEMBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 08:01:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49935 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726496AbgFEMBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 08:01:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591358471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=koYvTfzTJI5r8VtL4DRaQD0KHilxQUR15cCQUq6rzzk=;
        b=cmqLpOuWuQ+TPVL0qI63jG0xEHIY3k6c2C0v+GvfcaVySnUSt9dSm4SMDLzhXuwqpo/Kpv
        L6K7WXTYlKFwdGFj3BSMxBn8dmeixW3dZjoCChUnm2dDnm1qgNEz76LnQbnfsnQQwYUmwz
        4G8UD7vLixhM5s3BGouTCyBgPgnBcJg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-38liJCgzMCuQBM_0y3C91g-1; Fri, 05 Jun 2020 08:01:08 -0400
X-MC-Unique: 38liJCgzMCuQBM_0y3C91g-1
Received: by mail-ed1-f70.google.com with SMTP id c20so3829833edy.17
        for <kvm@vger.kernel.org>; Fri, 05 Jun 2020 05:01:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=koYvTfzTJI5r8VtL4DRaQD0KHilxQUR15cCQUq6rzzk=;
        b=NPtM98lDEnzAK5AKSOA0l6Nmawk6TOfPnwZVrYr0VxkAntGBjC3YNYg8ujNPB8cnMn
         ccEJ+ouHMorBRRJp1wxjI3GsAkhjnK4YIWeEIqhtdrNbIx2AHX2RtKGXKs+PUOAJ6N5T
         J6CrcnhNkf4Ons19oHJ1J4R8eIt11S6a6zWeg0k/cEqF+uHvG4700XfCg4kC03iiEQSg
         bxBN52pYRfVqQZmOkT9PQ0yZnBxO/8tWeOpFjJZvldj0J8HlMDFj6ABTVxEMa98m5mK5
         c+8WfftTweq5X+5U0FDEDn9AQwYa6rcsZmJXOWfGlfmD0duWsusEfLmBoq43nASxhqBS
         p7yg==
X-Gm-Message-State: AOAM531hQmH5OFUQZ1Zw6I/ugehiFJ7ah1qKldAY6QoaXmE6AleuahKo
        uFSfQ+9zy2TIbmrZ2z3ckYpRFuIttb3X8ItFA5tvCSR8IqFWD4RAF2SNJtVDHgWqEF05D0xaHN8
        VM1gPOMir1iax
X-Received: by 2002:a17:906:3282:: with SMTP id 2mr7348338ejw.93.1591358466799;
        Fri, 05 Jun 2020 05:01:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4mg+1ju4xwuQjCgV74nKX0+9fP5fpSq/euIfIv9LH5AlAojtnD1kk4Ji9SxivYef/Pf9tLg==
X-Received: by 2002:a17:906:3282:: with SMTP id 2mr7348292ejw.93.1591358466170;
        Fri, 05 Jun 2020 05:01:06 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f13sm4674767edk.36.2020.06.05.05.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 05:01:05 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: nVMX: Properly handle kvm_read/write_guest_virt*() result
In-Reply-To: <20200605115906.532682-1-vkuznets@redhat.com>
References: <20200605115906.532682-1-vkuznets@redhat.com>
Date:   Fri, 05 Jun 2020 14:01:04 +0200
Message-ID: <87v9k5d8n3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Syzbot reports the following issue:

Noticed while sending: the prefix of the patch should be "KVM: VMX:" as
it is not only nested related...

-- 
Vitaly

