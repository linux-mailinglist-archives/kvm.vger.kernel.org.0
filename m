Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331C94633F9
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 13:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbhK3MQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 07:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241456AbhK3MQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 07:16:32 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF42C061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 04:13:13 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id w1so86049148edc.6
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 04:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Mg3S7keeNQsFddDdCnyVQDVRGZGZ3klUFjvQ3PmiQMY=;
        b=aE2RcWZO0LOsvV0n2NqC2NsNUFpfXigbXbEQoNbVrFu5S6QfGXdjlyEiZ43+9vRS6t
         We/QqJLCESxeb3GN/HO7RlP+P4OYU7hq0R0qc1ZFqPlhJ+BQG7nBa4j/fn+o4cxynDhW
         xNOvGHcgR2dw2HzMuIoAowjWmPbip0tLtA91BtFfYoK0oMil1/R7hFlZSaCpXTfdjANV
         Zp5jMUkCMa/lgnmQLQx/fQpI1lnNQ0sqshHt7GGtalex17YKySkWWYQ+6SAhMMNnpcgh
         3j3pcFG8yfW0SXnm0bjd0HkbeLZFPKV9jvyHgTxop1HuBnYN4qDUL5ktvr2FUPLQcy7l
         4eqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Mg3S7keeNQsFddDdCnyVQDVRGZGZ3klUFjvQ3PmiQMY=;
        b=5w3eShzP5vS93JofFaO1ZcmNkPMJF+IeghQbRt2283ymjmBN6KCmiqLpyn94jUT9GS
         r8EznRtDS4LpVpLlyaJlieQlFOqkTlczm5g9DQexINdMRbkv/rPof0RZ1njnQ3cXlXh4
         SayCK06bFnk52NEN+CciVwOHWPeRjiv9xow4w3RLyUxipqZyLt4ldaOYwo0Mteqh7WUs
         mC1Ii96FSKvNLh+DfMo3uJliTuYya7YyUgYOvK2JkhrKxRuZrU73mSHNhBzHiE7pI7el
         pTzJLh11/PGuqR6rhsXKbINBlfolPvdbbWUVo/MRg0es5rKwlVRMckz8t6muni3pB/Zt
         9Klw==
X-Gm-Message-State: AOAM532CmF/fwD2S6MQlB8AXlbdenn+WvqdLJS8bPXLIL3Zy6DjYgoqW
        n0tSBAuinpOeHj1NvyAVbFKavUom0yo=
X-Google-Smtp-Source: ABdhPJwTGmkp/Q6ii5xDsL10w1615S0Ur70/2LVcmM97B4ySRB9Y0L3BD+HOnL8fS/Ydo+nTDC1P3w==
X-Received: by 2002:a17:906:9744:: with SMTP id o4mr69639404ejy.322.1638274391884;
        Tue, 30 Nov 2021 04:13:11 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id p13sm11371240eds.38.2021.11.30.04.13.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 04:13:11 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <0c3c24ff-831e-d558-6f8b-2a34fc51381d@redhat.com>
Date:   Tue, 30 Nov 2021 13:13:10 +0100
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

Doh, sorry I was on the wrong branch so I couldn't find a WARN at 9886. :)

I'll Cc you on a patch.

Paolo
