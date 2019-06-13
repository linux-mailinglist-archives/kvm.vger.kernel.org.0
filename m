Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B916438F4
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732337AbfFMPKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:10:20 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:46814 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732340AbfFMNzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 09:55:16 -0400
Received: by mail-wr1-f47.google.com with SMTP id n4so20852897wrw.13
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 06:55:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LUxRnqzVxBSH1F72r54SA3efp6hT9i/UqfD235oKS1I=;
        b=Ly+cT4gmOMofLECJy1vkAnmiUwsUiRTl2k1DM3rpkKy8NhtwHUm+m2KKs7PQl1sgQB
         HXD0rkqKrOaYoFuYKTXSU+nBd1F9n4nQ6CHzIVtzM6/FCA4SGBgw9QvK84Rc9kcSV54L
         L/ImIQ+rce6cB6xd3YSYcwo3m5LIcFLlY5pAKaNN0RP+zbVBOc8Ac/kwBnUan1ryLBS3
         0IwPVQae7czPvojzTaBjQ8aKIIfj7aUkzGFszZEYJRlasF7FTMZYW61aWCkHvMPVK7Mc
         V312dNVkBLfO33YEu2B4hPrlWFcTU7+PAO0T4D++Ww+MKNJNKhgmaMZKQcF7pmwNBawX
         uyhQ==
X-Gm-Message-State: APjAAAX29SEmavgVrAnUUZSYH7Ljuy7eI85A0q7PmzSj1i0QEhtW7EY4
        4BjPJ1RFes9EBTVEW6MbaUzRRsMYC2A=
X-Google-Smtp-Source: APXvYqy+3s5MTjEf1IKu3MEBD3MagZRPw8gzMiNtHU8Q1CBx7/2RMHQAlWfb4AtNRtMAiEneBF033Q==
X-Received: by 2002:a5d:53d2:: with SMTP id a18mr10352094wrw.98.1560434114220;
        Thu, 13 Jun 2019 06:55:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l190sm3169789wml.25.2019.06.13.06.55.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 06:55:13 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Subject: Re: What's with all of the hardcoded instruction lengths in svm.c?
In-Reply-To: <CALMp9eQ4k71ox=0xQKM+CfOkFe6Vqp+0znJ3Ju4ZmyL9fgjm=w@mail.gmail.com>
References: <CALMp9eQ4k71ox=0xQKM+CfOkFe6Vqp+0znJ3Ju4ZmyL9fgjm=w@mail.gmail.com>
Date:   Thu, 13 Jun 2019 15:55:12 +0200
Message-ID: <87d0jhegjj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> Take the following code in rdmsr_interception, for example.
>
> svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
>
> Yes, the canonical rdmsr instruction is two bytes. However, there is
> nothing in the architectural specification prohibiting useless or
> redundant prefixes. So, for instance, 65 66 67 67 67 0f 32 is a
> perfectly valid 7-byte rdmsr instruction.

(I don't know much about why this was added but nobody else commented
so in case I'm not terribly mistaken):

This looks ugly, it is likely an over-optimization: we seem to only
advance svm->next_rip to be able to avoid doing
kvm_emulate_instruction() in skip_emulated_instruction(). With NRIP_SAVE
feature (appeared long ago) we don't use the advanced value as we
already know the next RIP:

	if (svm->vmcb->control.next_rip != 0) {
		WARN_ON_ONCE(!static_cpu_has(X86_FEATURE_NRIPS));
		svm->next_rip = svm->vmcb->control.next_rip;
	}

IMO, always doing kvm_emulate_instruction(vcpu, EMULTYPE_SKIP) in !NRIPS
case would be the correct way. I tried throwing away these advancements
and nothing broke, with and without NRIPS.

I can try sending a patch removing the manual advancement to see if
anyone has any objections.

-- 
Vitaly
