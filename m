Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879B5470FFC
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 02:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbhLKBwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 20:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhLKBwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 20:52:41 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1E8C061714
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 17:49:05 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id l25so35567832eda.11
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 17:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CtUEEf0nYmx09LAdIiwLN87OWs0KrNUSNDB3nl76mgs=;
        b=WxBB0Vf9aKolqwS3o7uidMMn8Hxf4+SmCRYd38xaOV/yxIFVyj/gjyaEbePaVchn1J
         foHs1r88nKTTFCGWIO184Dr/wmNR7H9T+a6ifnwvt5lDPJ/+XeLBf1WFQGjvk6zFJM4N
         nyFVk2dGdTjovdk8emtse8KVWjpdt9D0FzCrd2DAJct1Va6Yk12Q8mIfnkJocOkMCub/
         agnOSPv8WDXvBS1J887Gv3ens/NkUMJ3PRS1uYshKcLjoAea030qoon7qE5+J+NNnsWV
         KLdxxKebHv6Z1WwEniAVPYy+LxlLPzhDhVZGI0SzVnOPlv5jgVPYe4EQRx4ZuuzEVN1n
         tnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CtUEEf0nYmx09LAdIiwLN87OWs0KrNUSNDB3nl76mgs=;
        b=pWDfhJYQS81G/ppGAltwRxzvq48e6Ww7D/PpuczBGEdOfn72JBJg0Kkb9RyZ3gao6Y
         HR0vpCwaJ21yVdWSb9AHzhA3gSPojCKumpvhwCEhwNIfCrvEw0eiMVRM/0dLFilmfmLp
         Av1q1hzsS5o/bG84SwwiyE8NSdUevBHEZKGse5trrFba/Vi1O4J/XoMQngGmSzlSJMqc
         kUbRN4fp2pV7j3Aoh63ftABAz6MSzFD1ki1joWBukPFoQyJZq1jkoC3ceen+cky9CV+T
         PuUfyCKgafqrPYAs1dNJfvANfIUyef3Oit/H6oxh0ZuRLqUvL9v48hko+xUjTrZC4a4y
         CA8A==
X-Gm-Message-State: AOAM531keUy/E7NFoAfCyZSEJIv3Sk/npUcLrBzqyqVeH/ATbScqShDi
        xRitd8Z4bHs8lrMfMnr4brjZRs7/nlw=
X-Google-Smtp-Source: ABdhPJz0Bu/XNCGU1cOhATSO5zzCuGLKAMn/lnf9EFaT06KpKxpO1ap6Cvwec2KitdEJD8zTa6GAOw==
X-Received: by 2002:a50:ce4a:: with SMTP id k10mr44436312edj.31.1639187343704;
        Fri, 10 Dec 2021 17:49:03 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id ne33sm2363211ejc.6.2021.12.10.17.49.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 17:49:03 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <e995aceb-40cc-e4cc-f3c8-2e8c2877a896@redhat.com>
Date:   Sat, 11 Dec 2021 02:49:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Potential bug in TDP MMU
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Ignat Korchagin <ignat@cloudflare.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        stevensd@chromium.org, kernel-team <kernel-team@cloudflare.com>
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com>
 <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
 <YaaIRv0n2E8F5YpX@google.com>
 <CALrw=nGrAhSn=MkW-wvNr=UnaS5=t24yY-TWjSvcNJa1oJ85ww@mail.gmail.com>
 <CALrw=nE+yGtRi-0bFFwXa9R8ydHKV7syRYeAYuC0EBTvdFiidQ@mail.gmail.com>
 <CALzav=fyaXAn4CLRW2qKTrROGUh6+F4bphhfoMZ13Qp5Njx3gw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALzav=fyaXAn4CLRW2qKTrROGUh6+F4bphhfoMZ13Qp5Njx3gw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/21 02:34, David Matlack wrote:
> The stacks help, thanks for including them. It seems like a race
> during do_exit teardown. One thing I notice is that
> do_exit->mmput->kvm_mmu_zap_all can interleave with
> kvm_vcpu_release->kvm_tdp_mmu_put_root (full call chains omitted),
> since the former path allows yielding. But I don't yet see that could
> lead to any issues, let alone cause us to encounter a PFN in the EPT
> with a zero refcount.

Can it? The call chains are

     zap_gfn_range+2229
     kvm_tdp_mmu_put_root+465
     kvm_mmu_free_roots+629
     kvm_mmu_unload+28
     kvm_arch_destroy_vm+510
     kvm_put_kvm+1017
     kvm_vcpu_release+78
     __fput+516
     task_work_run+206
     do_exit+2615
     do_group_exit+236

and

     zap_gfn_range+2229
     __kvm_tdp_mmu_zap_gfn_range+162
     kvm_tdp_mmu_zap_all+34
     kvm_mmu_zap_all+518
     kvm_mmu_notifier_release+83
     __mmu_notifier_release+420
     exit_mmap+965
     mmput+167
     do_exit+2482
     do_group_exit+236

but there can be no parallelism or interleaving here, because the call 
to kvm_vcpu_release() is scheduled in exit_files() (and performed in 
exit_task_work()).  That comes after exit_mm(), where mmput() is called.

Even if the two could interleave, they go through the same zap_gfn_range 
path.  That path takes the lock for write and only yields on the 512 
top-level page structures.  Anything below is handled by 
tdp_mmu_set_spte's (with mutual recursion between handle_changed_spte 
and handle_removed_tdp_mmu_page), and there are no yields on that path.

Paolo
