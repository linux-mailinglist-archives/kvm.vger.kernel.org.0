Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAAF65E99
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 19:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfGKRaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 13:30:10 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:37615 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728335AbfGKRaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 13:30:09 -0400
Received: by mail-wm1-f46.google.com with SMTP id f17so6464789wme.2
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 10:30:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DxXtv2tcQylMbBbnH2sadBaqFziDuIZTA3TgKw97vpk=;
        b=tqFrkGBMvTW8VtBhYwkaHBkkPTCwBm6L5P0HMSWL6IoBEBdGGZOsFzW3x67xaZ/Xwk
         BlzTe86fgkE/TT6xF+a9XQbWaHtcalcufpAf/P3ByxmfYTgMpocfd83D1isjmgwCxbuc
         tDKjoLX/yQVrBjHOR9//A4mh+yDsoeMcIvh3eRJGeQLmJXsu+prAGhUXDAkFeK5Y6ElB
         hapu18V0KFM1aJ17tUxJO5WqfikL0BeljPo50ZTUWZQIkcJ6M6HHHlY0Y3BusiAr1EPX
         ivUYuw/77tgJgen873+Np1s8WELYLMw1P+++lKbU/invVawYVgQiQCGu/uY8GibWECLE
         Gdpg==
X-Gm-Message-State: APjAAAVAPDZsswjKcJM7uOHA3L9RYEOAP689vT9EXgQ+FjKl/7I0ft3q
        BShJUsVHJtqh9umX7m1BD9kaUOkx0rU=
X-Google-Smtp-Source: APXvYqwt9T6YiqFLHPFpUsgUqxBYJQ/5lRFytC25yQ+f3XX/SARRc/77Sdcf1YOdRjBgoFemu3r7Xw==
X-Received: by 2002:a1c:2c41:: with SMTP id s62mr5215102wms.8.1562866207391;
        Thu, 11 Jul 2019 10:30:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id d16sm4679601wrv.55.2019.07.11.10.30.06
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 10:30:06 -0700 (PDT)
Subject: Re: KVM_SET_NESTED_STATE not yet stable
To:     Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <9eb4dd9f-65e5-627d-b288-e5fe8ade0963@siemens.com>
 <1562772280.18613.25.camel@amazon.de>
 <f1936ed9-e41b-4d36-50bb-3956434d993c@siemens.com>
 <cfd86643-dbac-3a69-9faf-03eaa8aee6a1@siemens.com>
 <47e8c75d-f39a-89f8-940f-d05a9bc91899@oth-regensburg.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e81b5c46-1700-33d2-4db7-a887e339d4ac@redhat.com>
Date:   Thu, 11 Jul 2019 19:30:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <47e8c75d-f39a-89f8-940f-d05a9bc91899@oth-regensburg.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/19 13:37, Ralf Ramsauer wrote:
> I can reproduce and confirm this issue. A system_reset of qemu after
> Jailhouse is enabled leads to the crash listed below, on all machines.
> 
> On the Xeon Gold, e.g., Qemu reports:
> 
> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000f61
> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
> EIP=0000fff0 EFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0000 00000000 0000ffff 00009300
> CS =f000 ffff0000 0000ffff 00a09b00
> SS =0000 00000000 0000ffff 00c09300
> DS =0000 00000000 0000ffff 00009300
> FS =0000 00000000 0000ffff 00009300
> GS =0000 00000000 0000ffff 00009300
> LDT=0000 00000000 0000ffff 00008200
> TR =0000 00000000 0000ffff 00008b00
> GDT=     00000000 0000ffff
> IDT=     00000000 0000ffff
> CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000680
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
> DR3=0000000000000000
> DR6=00000000ffff0ff0 DR7=0000000000000400
> EFER=0000000000000000
> Code=00 66 89 d8 66 e8 af a1 ff ff 66 83 c4 0c 66 5b 66 5e 66 c3 <ea> 5b
> e0 00 f0 30 36 2f 32 33 2f 39 39 00 fc 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> 
> Kernel:
> [ 1868.804515] kvm: vmptrld           (null)/6b8640000000 failed
> [ 1868.804568] kvm: vmclear fail:           (null)/6b8640000000
> 
> And the host freezes unrecoverably. Hosts use standard distro kernels

Thanks.  I'm going to look at it tomorrow.

Paolo
