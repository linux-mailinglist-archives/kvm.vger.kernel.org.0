Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7E8446546
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 19:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfFNRB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 13:01:57 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:35010 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfFNRB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 13:01:57 -0400
Received: by mail-wm1-f53.google.com with SMTP id c6so3029371wml.0
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2019 10:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FDTPCht6DM0v96DbDzYCiGZJAIeuN8vGRfcypyzSQEQ=;
        b=mLJc9Qtm4/hEeW51fbUs947grPKl9GAjEA8dCVAAwODNTt9bTREKo5cVQjLgek5Q7z
         DNZ6+5QZzt5n2SxDX8nFZZUcvth5U00G1ARaMIlMpohNUFm5kyRk/AnhRYufXca1/Atr
         1y8I8hszkOihHIJjb5Mu5Efg/OF14Fgdw1FLHhj53ffJ6q8Whz3/mpm+eDsMKYMogZjn
         eWxKZk8Q3TvfTBE+k4VrsImz3zpXl19vLCKfb5BLJ6KLjzYeAaR2SA9h/3iaaa2FfCwX
         cOxNp7TqemHHaFIV7JkMOFYokf5KbUq6XtHnQsKli0LqszbQePETJgo7AzK1D4Yd+8Hr
         sxIg==
X-Gm-Message-State: APjAAAUDIj99KqXMuDXXcVodqHKng9LnAu9t0tehTMIUOjDs2uYlA9n6
        2RwjwwRp+NB5iqXmrVVk4P9EPWoOglA=
X-Google-Smtp-Source: APXvYqxHZAuecCiZJ7O9d8PmWCmXdRWHQ1WocjBc8FoI9W1eMJA5anxIMC6YiewGHGPsZjh3+GtI+g==
X-Received: by 2002:a1c:9a05:: with SMTP id c5mr8186532wme.36.1560531714639;
        Fri, 14 Jun 2019 10:01:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-78-102-201-117.net.upcbroadband.cz. [78.102.201.117])
        by smtp.gmail.com with ESMTPSA id f197sm4536883wme.39.2019.06.14.10.01.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 10:01:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Subject: Re: What's with all of the hardcoded instruction lengths in svm.c?
In-Reply-To: <CALMp9eTe_iSgn5ihod_B=H1JzXwc_=CW22u+5sQCyPT=EJuLPQ@mail.gmail.com>
References: <CALMp9eQ4k71ox=0xQKM+CfOkFe6Vqp+0znJ3Ju4ZmyL9fgjm=w@mail.gmail.com> <87d0jhegjj.fsf@vitty.brq.redhat.com> <CALMp9eTe_iSgn5ihod_B=H1JzXwc_=CW22u+5sQCyPT=EJuLPQ@mail.gmail.com>
Date:   Fri, 14 Jun 2019 19:01:48 +0200
Message-ID: <87woho5ceb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Thu, Jun 13, 2019 at 6:55 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
>> I can try sending a patch removing the manual advancement to see if
>> anyone has any objections.
>
> That would be great!
>

Turns out this is harder than I initially thought, in the emulator we
don't emulate everything (e.g. XSETVB) and emulating some instructions
(even with EMULTYPE_SKIP) gives us some unintended side-effects,
e.g. I'm currently observing a hang when trying to apply
kvm_emulate_instruction() to HLT.  

Overall, I still think this is the right approach, we just need to make
EMULTYPE_SKIP skip correctly. Stay tuned...

-- 
Vitaly
