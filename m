Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDB6546C11
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 23:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfFNVok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 17:44:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41583 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfFNVok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 17:44:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so3946903wrm.8
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2019 14:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Ld3jYaYOalugs6NakkhvxfE6gQQVFoIIwwhNaKu9MOs=;
        b=m74IXzbLYCt9n5AFyI3yPS4CSIGGfcLABXnNFDcZKCD3i3kvi1U940PSIF18gx0lWO
         4j9J6/fUdsqX8s1jQAgnc/JJXBdpa2x680aus9Y17F7wnQ7tEm0223D4aMUuljv3BvL1
         Ce+VbZGHrgGz+VNBFUCnnCvZhZSs5Myu6/TMhVzgJuXUCG4AjiH/Is0IgPoLyVvebemM
         SKNtSfL+CJ0fCJOfBRuyT7Crtk0QzkaiJ5w1iNHliX+a4eACBIO3Obe+4xtqe5qd+pUy
         yCfRbYJ/ZjRWNp+p5r0T+4rTUYE3g0uCvANMtL8/GfIHEEukqPjOt3GflcypLWLBajp7
         BPNA==
X-Gm-Message-State: APjAAAUl+dD03vvGlCaEsmOYZ74SkC+GXM1rvcX/apArUWtfY0GOab9D
        zH4rtiTmFyJe8ZkEabzAD0dSog==
X-Google-Smtp-Source: APXvYqwtUzuPcck2AHyIXDAtw0zg3eNPDxrY9SB60wA2LaOW4/UoaSEnBo/i0WOqLauPH2dS3zi6EA==
X-Received: by 2002:a5d:4a0e:: with SMTP id m14mr19268175wrq.91.1560548678052;
        Fri, 14 Jun 2019 14:44:38 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-78-102-201-117.net.upcbroadband.cz. [78.102.201.117])
        by smtp.gmail.com with ESMTPSA id h23sm2938104wmb.25.2019.06.14.14.44.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 14:44:37 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Prasanna Panchamukhi <panchamukhi@arista.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Cathy Avery <cavery@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Michael Kelley \(EOSG\)" <Michael.H.Kelley@microsoft.com>,
        Mohammed Gamal <mmorsy@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Sasha Levin <sashal@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        devel@linuxdriverproject.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, x86@kernel.org,
        Dmitry Safonov <dima@arista.com>
Subject: Re: [PATCH] x86/hyperv: Disable preemption while setting reenlightenment vector
In-Reply-To: <20190614122726.GL3436@hirez.programming.kicks-ass.net>
References: <20190611212003.26382-1-dima@arista.com> <8736kff6q3.fsf@vitty.brq.redhat.com> <20190614082807.GV3436@hirez.programming.kicks-ass.net> <877e9o7a4e.fsf@vitty.brq.redhat.com> <cb9e1645-98c2-4341-d6da-4effa4f57fb1@arista.com> <20190614122726.GL3436@hirez.programming.kicks-ass.net>
Date:   Fri, 14 Jun 2019 23:44:36 +0200
Message-ID: <87pnnf6dvf.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

>
> I know you probably can't change the HV interface, but I'm thinking its
> rather daft you have to specify a CPU at all for this. The HV can just
> pick one and send the notification there, who cares.

Generally speaking, hypervisor can't know if the CPU is offline (or
e.g. 'isolated') from guest's perspective so I think having an option to
specify affinity for reenlightenment notification is rather a good
thing, not bad.

(Actually, I don't remember if I tried specifying 'HV_ANY' (U32_MAX-1)
here to see what happens. But then I doubt it'll notice the fact that we 
offlined some CPU so we may get a totally unexpected IRQ there).

-- 
Vitaly
