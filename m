Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8E77C406
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 15:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfGaNug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 09:50:36 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33116 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfGaNug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 09:50:36 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so1359801wme.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 06:50:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xiMsAjiDDo/ioi8HvaBXBSlL3/9tipDJZfJL08Je2vI=;
        b=eEiKcXpCXU1ndb3v3TAXFbB4wx4Y6FX9gEZyNaY1VBxHfH7mzlUn1wxwsZMMuPxyCM
         9Dr5DVilZpT780wLwFP2RAY9hcEMxu5Zq8DT+zTLkiCKKBOSfrMgbQWcJ1Adjf7nD48+
         k10tPP4tKyFOvgBmIf1MFVmhMZVddKJbuxeXiN8y9xsdCoOqnY2Hon2tK55fW7z98bUK
         bM1HfGDq0Z1sUC6xb5JU+tB2SFl063R5mmG268Je1izVRwzBrz8w1a0BEjx0Qw1fL1g2
         QwvVtpIz6aXAMrblAY3KKyLSM94QRWLXdDF2z+qvrxMxgQ+iYd0R902zNveIVw4BP9+O
         uuXQ==
X-Gm-Message-State: APjAAAX6+WEvHTpg7vNXJ4PH3o7VxmE1r0NSpzy361ciZHI/i6B8oVXM
        qMQdbJD0Xre9ot62BErOXbh8UQ==
X-Google-Smtp-Source: APXvYqyHaBpgxxRj2uo8Nfd7YRV3VKghabyOA1q/9XZIpgUAeDUPX+n7PU6c96hFKkpOXsnROLRBBg==
X-Received: by 2002:a1c:2dd1:: with SMTP id t200mr287523wmt.1.1564581034087;
        Wed, 31 Jul 2019 06:50:34 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y24sm49973593wmi.10.2019.07.31.06.50.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 06:50:33 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH RFC 3/5] x86: KVM: svm: clear interrupt shadow on all paths in skip_emulated_instruction()
In-Reply-To: <CALMp9eQ85h58NMDh-yOYvHN6_2f2T-wu63f+yLnNbwuG+p3Uvw@mail.gmail.com>
References: <20190620110240.25799-1-vkuznets@redhat.com> <20190620110240.25799-4-vkuznets@redhat.com> <CALMp9eQ85h58NMDh-yOYvHN6_2f2T-wu63f+yLnNbwuG+p3Uvw@mail.gmail.com>
Date:   Wed, 31 Jul 2019 15:50:32 +0200
Message-ID: <87ftmm71p3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Thu, Jun 20, 2019 at 4:02 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Regardless of the way how we skip instruction, interrupt shadow needs to be
>> cleared.
>
> This change is definitely an improvement, but the existing code seems
> to assume that we never call skip_emulated_instruction on a
> POP-SS/MOV-to-SS/STI. Is that enforced anywhere?

(before I send v1 of the series) I looked at the current code and I
don't think it is enforced, however, VMX version does the same and
honestly I can't think of a situation when we would be doing 'skip' for
such an instruction.... and there's nothing we can easily enforce from
skip_emulated_instruction() as we have no idea what the instruction
is... 

I can of course be totally wrong and would appreciate if someone more
knowledgeable chimes in :-)

-- 
Vitaly
