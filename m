Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E44B1B282C
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 15:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgDUNip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 09:38:45 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41122 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728519AbgDUNio (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 09:38:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587476323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LEkmEchC7I6Vap+POG7SrCstDGTOmfDnvgVnpaVVqk0=;
        b=EoRIJCZpLtBSoreadek2bJaY7n8tLDc3usSGlQaN4Q3Qb1wgLV3s5fRRKvz/i7vvvYWH9j
        mpik2VG4C+VTyFBVC00kPCQrs5g31fPeNydaPVsl92MkxAIFEAjizGBB2pFWc0Sx33ALAb
        /sqzEwHzgLVmsKnSO7bII0PsY0F2wVI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-uPXykxBIPHmOr-E7fL00Gg-1; Tue, 21 Apr 2020 09:38:41 -0400
X-MC-Unique: uPXykxBIPHmOr-E7fL00Gg-1
Received: by mail-wm1-f72.google.com with SMTP id f81so1391494wmf.2
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 06:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LEkmEchC7I6Vap+POG7SrCstDGTOmfDnvgVnpaVVqk0=;
        b=YCWXJOmF/8BhwNgteJxXGfntMUK0xasF+gX8o3GzBoKAoaCxYo+ivCIYiNrRJpGOP1
         zrs2pqyN/dQB1cXFszM8vCD2Xr5CM5TYgaAxAopc+t8c6t7kSmeLu+hjKZ3CcvMufMcR
         ToKWLR2sQQ1/LUywpQPl1oFG24+Jk+OVeKFymwwcBTnleA/Zl+ZF9B5usoVMKcmNHmre
         pZR98LDDTMPPFLglRdKvZTReL7P30uxbrFrD2bO/MXCtdWhDXwkDNAAxdAXwEepAWMEM
         hbrSzTyABD5mBxgRlz0V6+z9XByRRgeIBDPTqe7fHmGlnRCObGsDossHt1Ncw/AL0ht9
         7aeQ==
X-Gm-Message-State: AGi0PubffD0Nk0CQ2nXwQHwrKl/MsQR0oKBBXt3YULYYgg5jyewQjUwI
        3hnWsuzYvcF7hulKD0ghWLc/mzpBHhDbA/TE6nlSaRsM9a9zUcRuHZd6d7nxHh6QXvtsm9wJk+b
        xMeoo5Th01P0a
X-Received: by 2002:adf:fc4f:: with SMTP id e15mr24315802wrs.415.1587476320530;
        Tue, 21 Apr 2020 06:38:40 -0700 (PDT)
X-Google-Smtp-Source: APiQypKGek4tZqkiTucU3V8cPDTVi9zZurddNwoKPsBF0EAMyszVMjHpOEpUuGJxWg6voWo+68yGKQ==
X-Received: by 2002:adf:fc4f:: with SMTP id e15mr24315782wrs.415.1587476320320;
        Tue, 21 Apr 2020 06:38:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id k9sm3741361wrd.17.2020.04.21.06.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 06:38:39 -0700 (PDT)
Subject: Re: KASAN: out-of-bounds Write in nested_sync_vmcs12_to_shadow
To:     syzbot <syzbot+6ad11779184a3afe9f7e@syzkaller.appspotmail.com>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, sean.j.christopherson@intel.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
References: <000000000000b77ac905a3c1e81f@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3fed5719-9b30-fe69-9b2d-3584440759d1@redhat.com>
Date:   Tue, 21 Apr 2020 15:38:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <000000000000b77ac905a3c1e81f@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/04/20 02:15, syzbot wrote:
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+6ad11779184a3afe9f7e@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: out-of-bounds in copy_vmcs12_to_enlightened arch/x86/kvm/vmx/nested.c:1820 [inline]
> BUG: KASAN: out-of-bounds in nested_sync_vmcs12_to_shadow+0x49e3/0x4a60 arch/x86/kvm/vmx/nested.c:2000
> Write of size 2 at addr ffffc90004db72e8 by task syz-executor.4/8294
> 
> CPU: 1 PID: 8294 Comm: syz-executor.4 Not tainted 5.7.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0x5/0x315 mm/kasan/report.c:382
>  __kasan_report.cold+0x35/0x4d mm/kasan/report.c:511
>  kasan_report+0x33/0x50 mm/kasan/common.c:625
>  copy_vmcs12_to_enlightened arch/x86/kvm/vmx/nested.c:1820 [inline]
>  nested_sync_vmcs12_to_shadow+0x49e3/0x4a60 arch/x86/kvm/vmx/nested.c:2000
>  </IRQ>

That's a weird stack trace for a reproducer that is doing operations on
/dev/fb0.  What's going on?

Paolo

