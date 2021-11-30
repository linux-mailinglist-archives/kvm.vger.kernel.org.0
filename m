Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FADB463353
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 12:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhK3Lw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 06:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241005AbhK3Lwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 06:52:50 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99A8C061756
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 03:49:31 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v1so85468012edx.2
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 03:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BACblW4KDQBW7cLydHavMr2eZogUDu8MnhIh0WY0Kb4=;
        b=DYLVZj68DNy38UFuOGCP4dcvKhbQLBhsd9ZA+s4+zFKMVRvxGVxn29RQWn04CC0CqP
         DNYX985k3RXNhHnndaBBRFozkDUtCujKcB8A0qsfUUewNLpMHUGtajafVtpdQLwFNx2x
         /CG0i+Sw+1s5OHUXPH63KIdAbthfXlh0R+fsogrtiS5fOv0tG86c5SewAscUJC9zHa/I
         BrJJCO17plSWf9j1NnukjG6al6ViQOQA3omo0oPePbygrkL5cDDLnKt3ArIKI+XcvnN9
         WtvHgjTIZ2A5NeFM+cEcu/nJ912/Fkbvzt/hhPL5JEYJL5mPPK53zRBxnj7lMq5ktyJ/
         +6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BACblW4KDQBW7cLydHavMr2eZogUDu8MnhIh0WY0Kb4=;
        b=nuQLmuuT9Vu7DIYSp9/dBCnch5rFI5Uny+mQ1ouNx36B/YZ5ck2/ss/r+zG0fXaXdQ
         IygfVG3f60W9t+sES26qsesOlgwQJE76BTYN3y2bVrGjhFP9yekprhlaB5vUmrPBf4E9
         gnChRBWvaxS+3qh0DXSCKWarhD2mPvHIG5aT5XRvCd4wZD8cdNhJR3bIC/3CQvd05Txy
         dnn3/94vu9CkgC/ZEDVuy3MUWT/0Vnh4bWhrb4kf1QfaYNxOWi+7/lMFfNtzFewXDeO5
         1qQkOEK+Rg0DGmu/Aha7yfyidPxiwukCjy/OAXviZmOVbts2ntyTYCM+JP2+XlLz/ynE
         Iqhw==
X-Gm-Message-State: AOAM532O1Wd+uVbLgUZQo6URajh6f3yzB/16zhZ+u8pvwveZ54IBVQb3
        D4bxFbtu+NA/xstRAE/3dNU=
X-Google-Smtp-Source: ABdhPJw3OGarWSmSo/aPBCnna3Y+R8QYLpVwVS+4hUxfgmTLZKkiQwlExeiosWvm53LxgPAVaq4aGA==
X-Received: by 2002:aa7:d048:: with SMTP id n8mr81274097edo.333.1638272970188;
        Tue, 30 Nov 2021 03:49:30 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id qf8sm9291149ejc.8.2021.11.30.03.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 03:49:29 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <538b1ba5-0ab0-4d1e-56c0-c51321e6b21f@redhat.com>
Date:   Tue, 30 Nov 2021 12:49:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Potential bug in TDP MMU
Content-Language: en-US
To:     Ignat Korchagin <ignat@cloudflare.com>, kvm@vger.kernel.org
Cc:     stevensd@chromium.org, kernel-team <kernel-team@cloudflare.com>
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com>
 <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
 <041803a2-e7cc-4c0a-c04a-af30d6502b45@redhat.com>
 <CALrw=nHFy7rG4FbUf+sGMWbWfWzzDizjPonrUEqN89SQNdWTWg@mail.gmail.com>
 <CALrw=nFzEhrfLR=sQwCz_eyrSbksn4qKqgkNyxG9LGQvkw8_fg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALrw=nFzEhrfLR=sQwCz_eyrSbksn4qKqgkNyxG9LGQvkw8_fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/21 12:43, Ignat Korchagin wrote:
> I have also noticed another new warning, when running this on the
> kernel from kvm.git branch:
> 
> [   70.284354][ T2928] WARNING: CPU: 4 PID: 2928 at
> arch/x86/kvm/x86.c:9886 kvm_arch_vcpu_ioctl_run+0x126c/0x17d0
> [   70.284354][ T2928] Modules linked in:
> [   70.284354][ T2928] CPU: 4 PID: 2928 Comm: exe Not tainted 5.16.0-rc2 #2
> [   70.284354][ T2928] Hardware name: QEMU Standard PC (Q35 + ICH9,
> 2009), BIOS 0.0.0 02/06/2015
> [   70.284354][ T2928] RIP: 0010:kvm_arch_vcpu_ioctl_run+0x126c/0x17d0
> [   70.284354][ T2928] Code: 49 89 b7 f8 01 00 00 e9 8e ee ff ff 49 8b
> 87 80 00 00 00 45 31 e4 c7 40 08 07 00 00 00 49 83 87 b8 20 00 00 01
> e9 35 f2 ff ff <0f> 0b 4c 89 ff e8 ea 72 03 00 83 f8 01 41 89 c4 0f 85
> 47 f9 ff ff

Can you check which line of the source this is?

Paolo
