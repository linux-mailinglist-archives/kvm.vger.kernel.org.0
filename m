Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9E02DAAB4
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 11:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgLOKRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 05:17:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727182AbgLOKQw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Dec 2020 05:16:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608027325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l5LzMxbr9TROdZC3Z8tydOWFz7HFkR2idNrdymTBhAA=;
        b=KHZS7RtBjStjQHa5VqyKZQ8WqObvPUFRVBX24Lz62mIEzBwCQr6yZ8qds+D8JG7P90OdZ9
        xKkh58fQ463cTfC55Nn6U5JN06q1E7rAWoauseovIILYi65NJyTB9efdWIP2v9V9Tm4Huz
        N3GoZJ/XRbE48ilobNPR1seoBK3/ZmU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-P6G9guaRN-W4IAKSHrys1Q-1; Tue, 15 Dec 2020 05:15:23 -0500
X-MC-Unique: P6G9guaRN-W4IAKSHrys1Q-1
Received: by mail-ej1-f72.google.com with SMTP id dv25so5785215ejb.15
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 02:15:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l5LzMxbr9TROdZC3Z8tydOWFz7HFkR2idNrdymTBhAA=;
        b=s4y1PKOzHfX0QrwMa1SpFRN+B3qHEQnqiMqK8t4fIoReRaPRK3IjIgMbteRRqLeCT5
         gpNEe9NOf7rKCl1hwPdBZHHpBG3k3Vbmf7MF8kDuvtbmprS99I/NsnScE3DKtvvhp+0Z
         2TDMYarlhQ7vklosN1WOF5bBzZ0La5R35kBMrt76nILGmrbtI4dhTfo7P6NtyFCcS+qe
         LMyAaepYjzZMLNPtNB3Lhaf0Aj70ZgbB4h9PIf1QyjBQstQ6yxwJaZF7hJ/+1626J6Cs
         nVoKdVro29jC3YHS+WFUhVBrhsbLdzcZprCPQhYMP9l064zKIxepRKaPWANqIa75biM0
         5gLA==
X-Gm-Message-State: AOAM531LDaJ/BccukSMdHI3zXrNVmMMcb7arqqKmlemwY7+cUBRwtdi5
        unu2OCmsCyFKQa7osG3fT4JFz87gJyZSolW2/gJNnOcuiH06+Eg6LHb50sCP1O8m4URZrKKNvsN
        9nm66XLcj+jh1
X-Received: by 2002:aa7:cac2:: with SMTP id l2mr28919440edt.141.1608027322513;
        Tue, 15 Dec 2020 02:15:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzoKdlLvHAx7ZwpLRJe1jwkE7z+XVgot0SmkIrPwVB+yP2e6E83E5hMB2Pv29BS3+h/dE7xKA==
X-Received: by 2002:aa7:cac2:: with SMTP id l2mr28919416edt.141.1608027322322;
        Tue, 15 Dec 2020 02:15:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bo20sm17938647edb.1.2020.12.15.02.15.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 02:15:21 -0800 (PST)
Subject: Re: [PATCH v2] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
To:     Andy Lutomirski <luto@amacapital.net>,
        Michael Roth <michael.roth@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
References: <20201214220213.np7ytcxmm6xcyllm@amd.com>
 <98F09A9A-A768-4B01-A1FA-5EE681146BC5@amacapital.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <482e5526-2ee1-9ed3-19ad-3a24d56a4fc4@redhat.com>
Date:   Tue, 15 Dec 2020 11:15:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <98F09A9A-A768-4B01-A1FA-5EE681146BC5@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/12/20 23:29, Andy Lutomirski wrote:
>> One downside to that is that we'd need to do the VMSAVE on every 
>> iteration of vcpu_run(), as opposed to just once when we enter
>> from userspace via KVM_RUN. It ends up being a similar situation to
>> Andy's earlier suggestion of moving VMLOAD just after vmexit, but
>> in that case we were able to remove an MSR write to MSR_GS_BASE,
>> which cancelled out the overhead, but in this case I think it could
>> only cost us extra.
>
> If you want to micro-optimize, there is a trick you could play: use
> WRGSBASE if available.  If X86_FEATURE_GSBASE is available, you could
> use WRGSBASE to restore GSBASE and defer VMLOAD to vcpu_put().  This
> would need benchmarking on Zen 3 to see if it’s worthwhile.

If the improvement is big (100 cycles or so) it would be worthwhile. 
Otherwise, for the sake of code clarity doing VMLOAD in the assembly 
code is the simplest.

Paolo

