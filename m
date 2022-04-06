Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555094F6A33
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 21:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbiDFTpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 15:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbiDFTp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 15:45:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B395021CC5E
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 10:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649266399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JsflgPsqFmMeboA+E+ObIhwzjD0l7tM2YPcfbgODEK4=;
        b=Wa+bVKOC/Ik5yHxsGnMLpWs687dsiHBW/heQwTeUjksykHx+RhJBMUk9KLlN+kVcgzS1P+
        i47aEG84Ulcw+Ov7GmNcRv5ZcglF1eSvZTLZoyCDXbVTdx04GlzQA5v2K1jVLpafK5+9gv
        Sjwb2zg09lsr24B4sCZqOXV3v9oOOKI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-u12ziaFjP_aNLX0e52UUsg-1; Wed, 06 Apr 2022 13:33:18 -0400
X-MC-Unique: u12ziaFjP_aNLX0e52UUsg-1
Received: by mail-ed1-f69.google.com with SMTP id w14-20020aa7d28e000000b0041cd144f3c6so1588865edq.18
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 10:33:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JsflgPsqFmMeboA+E+ObIhwzjD0l7tM2YPcfbgODEK4=;
        b=cQIi7ekac6sMB2FuhWA/sp2sflWq7XVmrgSx17B9cQYI7Is189KD22lLXsriwH9hTr
         pb4gz6VzOHrYQWK9T6eRn6zrIVun2R/i9e3iR25+jIIZqlT2oRdJ1RzGCaiXY5qfpLrl
         ORyYrWeRfgiNYwDV1/eY8PHiAz2gauefCHHK4ym9gCNl+G77E4t9l8FFM5d4uMT67bJB
         kXlvpH1Qy4MKp20rl8M1shmf/RfMWoYIA9rjshYfHsSRuCRRVpKb9lfbYXDqNcuHE3ID
         D6q00BEg5x0Uh3DgEsGWqDcnC3Hnb9BQVfj4Wf1qm3F7prBcds9m6h0CzDd9RORXsTn1
         b4fA==
X-Gm-Message-State: AOAM530BgMkCR81z0drauMl8ayrUQnL5XsOgCi/8hWKycp1cVMTudi5i
        kE/DyNVIRacKm2bY8J+D/jpDz9gLOGLDh1D03PQdMEIcf8vl1k5X/pV7DUlw4GgN0dnxtaowZyc
        nP0yL4DEo7Pmh
X-Received: by 2002:a17:906:2991:b0:6cd:ac19:ce34 with SMTP id x17-20020a170906299100b006cdac19ce34mr9458075eje.746.1649266397443;
        Wed, 06 Apr 2022 10:33:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymsJF1UHVP+8vuPjco6L6obKdcfN6lM3rJUdqFr1Q2lEaGhsfxKtM9Tn7BrlIx1igdunVYIw==
X-Received: by 2002:a17:906:2991:b0:6cd:ac19:ce34 with SMTP id x17-20020a170906299100b006cdac19ce34mr9458047eje.746.1649266397198;
        Wed, 06 Apr 2022 10:33:17 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id k14-20020a170906128e00b006e4b67514a1sm6871372ejb.179.2022.04.06.10.33.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 10:33:16 -0700 (PDT)
Message-ID: <7108f263-5cda-d91d-792b-d3f18b63c6d7@redhat.com>
Date:   Wed, 6 Apr 2022 19:33:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [syzbot] upstream build error (17)
Content-Language: en-US
To:     syzbot <syzbot+6b36bab98e240873fd5a@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        mingo@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
References: <000000000000008dae05dbfebd85@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <000000000000008dae05dbfebd85@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/6/22 18:20, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3e732ebf7316 Merge tag 'for_linus' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10ca0687700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=eba855fbe3373b4f
> dashboard link: https://syzkaller.appspot.com/bug?extid=6b36bab98e240873fd5a
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6b36bab98e240873fd5a@syzkaller.appspotmail.com
> 
> arch/x86/kvm/emulate.c:3332:5: error: stack frame size (2552) exceeds limit (2048) in function 'emulator_task_switch' [-Werror,-Wframe-larger-than]
> drivers/block/loop.c:1524:12: error: stack frame size (2648) exceeds limit (2048) in function 'lo_ioctl' [-Werror,-Wframe-larger-than]

I spot-checked these two and the stack frame is just 144 and 320 bytes 
respectively on a normal compile.  This is probably just the effect of 
some of the sanitizer options.

Paolo

