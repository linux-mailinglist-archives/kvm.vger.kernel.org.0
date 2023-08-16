Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3628677E6FF
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 18:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344966AbjHPQyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 12:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345031AbjHPQxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 12:53:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4999FE4C
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 09:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692204791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gs4/ygsmx60svnx/BACaLYethMvInQSVH+8hNUPRRfQ=;
        b=hm4fu6Gbu4hM8ka7Q6KmGyOj3rZ8gwXGoi3DCFJgdJx18lmg1N+EC+Ve6+bHWf1lE5mcp6
        mLrnRgR8tta9Sl/CvJDO5ziX7Jwjno5Vopv5pKZw8sooWhbNGcL0tt67jmU5HF+1ikdisK
        1/JweEhpF9pXIuEwwl4zpGkWVcps9OU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-xPC7SSzFPZObTLFJOWzNAg-1; Wed, 16 Aug 2023 12:53:09 -0400
X-MC-Unique: xPC7SSzFPZObTLFJOWzNAg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-993831c639aso403196666b.2
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 09:53:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692204788; x=1692809588;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gs4/ygsmx60svnx/BACaLYethMvInQSVH+8hNUPRRfQ=;
        b=OMYZVuSnpBXAPaJQ55uhiNM7nrJYa/r7QixZV3VD44edD+IIa6x3fqwLK7V5HcJIEX
         kfbyY8HOcSDxzEjQ7f9KEyomWMNLG5Fibk9OFgs4uFQk8ulu1ETRhj9puB0ijJ9OHAE4
         63wYJjanTEY37IporiKb/EeURop0tAkge7PycbNA32TU34/bj8zicjTv54AMXZDzuBss
         ZiEl/7gqMqAludkukBU2UG9YFz+dXz8yuWK1QE1QAQWOtBLYV2p0x/57g/HcCo9Q8gp5
         ik8yeWDm9IYLYpOt9jsiVA+swNk74y10gVEa7BOm0Vf2cGRsjAEtz7Y8AkGSdbVm06ls
         2wqg==
X-Gm-Message-State: AOJu0YwZFraV4i3+hMcZbfTPT9W0bpF7y6s6MtxVL1NkUD5wXL6hVgwy
        WDI4U5iAe2SP0Tdi8aIOiuNQOfAwbmmKC/cPK2CQdeHet4Pe6rmiG/POJP+W41XBxF8N+5rDx6E
        OiHhD1v8oG6A+
X-Received: by 2002:a17:906:8a6c:b0:98e:2b01:ab97 with SMTP id hy12-20020a1709068a6c00b0098e2b01ab97mr1640172ejc.68.1692204788522;
        Wed, 16 Aug 2023 09:53:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFU1ojiVZymlqloH4pPtPiX1lfCdcDJ2adbg7XhEXCcNlm0BxaLm0gVIFz94ySyezwHEVrMGA==
X-Received: by 2002:a17:906:8a6c:b0:98e:2b01:ab97 with SMTP id hy12-20020a1709068a6c00b0098e2b01ab97mr1640156ejc.68.1692204788162;
        Wed, 16 Aug 2023 09:53:08 -0700 (PDT)
Received: from starship ([77.137.131.138])
        by smtp.gmail.com with ESMTPSA id k17-20020a17090646d100b00997d76981e0sm8672389ejs.208.2023.08.16.09.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 09:53:07 -0700 (PDT)
Message-ID: <6b2aedbcff7625574596b363651e0bbd76b03140.camel@redhat.com>
Subject: Re: Fwd: kvm: Windows Server 2003 VM fails to work on 6.1.44 (works
 fine on 6.1.43)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Roman Mamedov <rm+bko@romanrm.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Date:   Wed, 16 Aug 2023 19:53:05 +0300
In-Reply-To: <87cyzn5cln.fsf@redhat.com>
References: <8cc000d5-9445-d6f1-f02e-4629a4a59e0e@gmail.com>
         <87o7j75g0g.fsf@redhat.com> <87il9f5eg1.fsf@redhat.com>
         <87cyzn5cln.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У ср, 2023-08-16 у 15:41 +0200, Vitaly Kuznetsov пише:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
> > Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> > 
> > > Bagas Sanjaya <bagasdotme@gmail.com> writes:
> > > 
> > > > Hi,
> > > > 
> > > > I notice a regression report on Bugzilla [1]. Quoting from it:
> > > > 
> > > > > Hello,
> > > > > 
> > > > > I have a virtual machine running the old Windows Server 2003. On kernels 6.1.44 and 6.1.45, the QEMU VNC window stays dark, not switching to any of the guest's video modes and the VM process uses only ~64 MB of RAM of the assigned 2 GB, indefinitely. It's like the VM is paused/halted/stuck before even starting. The process can be killed successfully and then restarted again (with the same result), so it is not deadlocked in kernel or the like.
> > > > > 
> > > > > Kernel 6.1.43 works fine.
> > > > > 
> > > > > I have also tried downgrading CPU microcode from 20230808 to 20230719, but that did not help.
> > > > > 
> > > > > The CPU is AMD Ryzen 5900. I suspect some of the newly added mitigations may be the culprit?
> > > > 
> > > > See Bugzilla for the full thread.
> > > > 
> > > > Anyway, I'm adding it to regzbot as stable-specific regression:
> > > > 
> > > > #regzbot introduced: v6.1.43..v6.1.44 https://bugzilla.kernel.org/show_bug.cgi?id=217799
> > > > #regzbot title: Windows Server 2003 VM boot hang (only 64MB RAM allocated)
> > > > 
> > > > Thanks.
> > > > 
> > > > [1]: https://bugzilla.kernel.org/show_bug.cgi?id=217799
> > > 
> > > From KVM's PoV, I don't see any KVM/x86 patches v6.1.44..v6.1.45 
> > 
> > Oh, sorry, my bad, in the description of the BZ it is said that 6.1.44
> > is already broken, so it's most likely srso stuff then:
> > 
> > dd5f2ef16e3c x86: fix backwards merge of GDS/SRSO bit
> > 4f25355540ad x86/srso: Tie SBPB bit setting to microcode patch detection
> > 77cf32d0dbfb x86/srso: Add a forgotten NOENDBR annotation
> > c7f2cd045542 x86/srso: Fix return thunks in generated code
> > c9ae63d773ca x86/srso: Add IBPB on VMEXIT
> > 79c8091888ef x86/srso: Add IBPB
> > 98f62883e751 x86/srso: Add SRSO_NO support
> > 9139f4b6dd4f x86/srso: Add IBPB_BRTYPE support
> > ac41e90d8daa x86/srso: Add a Speculative RAS Overflow mitigation
> 
> Sean's https://lore.kernel.org/all/20230811155255.250835-1-seanjc@google.com/
> (alteady in 'tip') can actually be related and I see it was already
> tagged for stable@. Can anyone check if it really helps?
> 
> > dec3b91f2c4b x86/cpu, kvm: Add support for CPUID_80000021_EAX
> > 
> > it would still be great to try to bisect to the particular patch causing
> > the issue.

My 0.2 cents on something that might be related:

On my Intel laptop I can't boot a windows guest with hyperv enabled inside (either regular hyperv win10 or win11 with core isolation)
I know now that 'ibt=off' on host kernel line fixes this, but I didn't yet bisected it to see which commit started it.
(I took this from https://bugzilla.redhat.com/show_bug.cgi?id=2221531, which is unrelated but I just noticed it somehow and tried the solution)

I run upstream 6.4 kernel + kvm/queue on that laptop.

Best regards,
	Maxim Levitsky

