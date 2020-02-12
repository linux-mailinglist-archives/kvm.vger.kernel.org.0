Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10BC15B06C
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 20:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgBLTCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 14:02:41 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40163 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbgBLTCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 14:02:41 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so3827067wmi.5;
        Wed, 12 Feb 2020 11:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p3lNgk+TYooq4tXMdxoYh8fTZhSP4S6HBRdG87ZYQ1k=;
        b=H7uaTfcrBsVbqs44lge/QIOCNu1WdwpdmethH5sH6JGwFFWQHriQFanmEH+wz0DvvI
         VWhrANErbzaUIKrkUbcDpM/rneF+XYI1tLlcyYTTz1hu5CoKK3U+IXpGwrTtXVedLwUV
         uMeTq5iMDmpKtNNt8HqC46nTpjAoEgJzgmh+F8F348lqz0fVe8mLNtnPkoyMPCxuRRb/
         12yoiStxh1B+Fg1FcV+AYCcwBwcwT8wLlIaXnu88KoRs6FJ8DkFadei8bsBSHNUkzmUt
         vKh4CzMf1vaXbCHsN0MVeopNRT9lIx1/T7SCCQVGtbtBryWUH9W/fGKL5sX+D6yX/7re
         GfOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=p3lNgk+TYooq4tXMdxoYh8fTZhSP4S6HBRdG87ZYQ1k=;
        b=sTVRuXb8z9uPRLFDAGSKbOULQmYwpPh6diuiRqBOF5Hi9mU9TDCBMgdd4+Bnbbk8i0
         Erg9CKUoTKwdzes4gwYmKGG5wkTjYD36rzvhL/AccYl9Num1iuug35hLAcKs7595Rsh7
         LahL4EmfDItVGmlByMjXBA/eXQleh3U4TsDSCGeqt8wm1s7swGxHedJbDQURIMoqaVMp
         OSeF5n5gsmaz8WE3VJarjw+8JmTNIHrUMLrOhKuZ3tOg4ytHQ2uLvx5tPFZgFWGv+77Z
         tkQeArC2/wwyjyKJrA/UsEvxoN3gNihT6dr4o7AgPWwMOhDMu4NMcG/WYD59BF7tCF3i
         zFlQ==
X-Gm-Message-State: APjAAAUfEE7Nr/f6pxjpmO5klfbc+5ljADtG+TB0vdweVZLBSCnA2dYf
        p02bUTiL/krxQcgJqEdQLMopzLPgaqA=
X-Google-Smtp-Source: APXvYqz0kyCzLSP31LckMOpCvUHvngByIqX7uN5Tx3o8wOzMKxisaUMQKGFFho2Amo1/AGeJ1oRGoQ==
X-Received: by 2002:a1c:2089:: with SMTP id g131mr467303wmg.63.1581534155701;
        Wed, 12 Feb 2020 11:02:35 -0800 (PST)
Received: from [192.168.1.35] (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id n3sm1685295wrs.8.2020.02.12.11.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 11:02:35 -0800 (PST)
Subject: Re: [PATCH RFC 0/4] KVM: MIPS: Provide arch-specific
 kvm_flush_remote_tlbs()
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Burton <paulburton@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mips@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200207223520.735523-1-peterx@redhat.com>
 <44ba59d6-39a5-4221-1ae6-41e5a305d316@redhat.com>
 <20200212163004.cpd33ux4zslfc3es@lantea.localdomain>
 <66e0a38c-a7f5-dcd1-d06b-b317588fad7a@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Autocrypt: addr=f4bug@amsat.org; keydata=
 mQINBDU8rLoBEADb5b5dyglKgWF9uDbIjFXU4gDtcwiga9wJ/wX6xdhBqU8tlQ4BroH7AeRl
 u4zXP0QnBDAG7EetxlQzcfYbPmxFISWjckDBFvDbFsojrZmwF2/LkFSzlvKiN5KLghzzJhLO
 HhjGlF8deEZz/d/G8qzO9mIw8GIBS8uuWh6SIcG/qq7+y+2+aifaj92EdwU79apZepT/U3vN
 YrfcAuo1Ycy7/u0hJ7rlaFUn2Fu5KIgV2O++hHYtCCQfdPBg/+ujTL+U+sCDawCyq+9M5+LJ
 ojCzP9rViLZDd/gS6jX8T48hhidtbtsFRj/e9QpdZgDZfowRMVsRx+TB9yzjFdMO0YaYybXp
 dg/wCUepX5xmDBrle6cZ8VEe00+UQCAU1TY5Hs7QFfBbjgR3k9pgJzVXNUKcJ9DYQP0OBH9P
 ZbZvM0Ut2Bk6bLBO5iCVDOco0alrPkX7iJul2QWBy3Iy9j02GnA5jZ1Xtjr9kpCqQT+sRXso
 Vpm5TPGWaWljIeLWy/qL8drX1eyJzwTB3A36Ck4r3YmjMjfmvltSZB1uAdo1elHTlFEULpU/
 HiwvvqXQ9koB15U154VCuguvx/Qnboz8GFb9Uw8VyawzVxYVNME7xw7CQF8FYxzj6eI7rBf2
 Dj/II6wxWPgDEy3oUzuNOxTB7sT3b/Ym76yOJzWX5BylXQIJ5wARAQABtDFQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoRjRCVUcpIDxmNGJ1Z0BhbXNhdC5vcmc+iQJVBBMBCAA/AhsPBgsJ
 CAcDAgYVCAIJCgsEFgIDAQIeAQIXgBYhBPqr514SkXIh3P1rsuPjLCzercDeBQJd660aBQks
 klzgAAoJEOPjLCzercDe2iMP+gMG2dUf+qHz2uG8nTBGMjgK0aEJrKVPodFA+iedQ5Kp3BMo
 jrTg3/DG1HMYdcvQu/NFLYwamUfUasyor1k+3dB23hY09O4xOsYJBWdilkBGsJTKErUmkUO2
 3J/kawosvYtJJSHUpw3N6mwz/iWnjkT8BPp7fFXSujV63aZWZINueTbK7Y8skFHI0zpype9s
 loU8xc4JBrieGccy3n4E/kogGrTG5jcMTNHZ106DsQkhFnjhWETp6g9xOKrzZQbETeRBOe4P
 sRsY9YSG2Sj+ZqmZePvO8LyzGRjYU7T6Z80S1xV0lH6KTMvq7vvz5rd92f3pL4YrXq+e//HZ
 JsiLen8LH/FRhTsWRgBtNYkOsd5F9NvfJtSM0qbX32cSXMAStDVnS4U+H2vCVCWnfNug2TdY
 7v4NtdpaCi4CBBa3ZtqYVOU05IoLnlx0miKTBMqmI05kpgX98pi2QUPJBYi/+yNu3fjjcuS9
 K5WmpNFTNi6yiBbNjJA5E2qUKbIT/RwQFQvhrxBUcRCuK4x/5uOZrysjFvhtR8YGm08h+8vS
 n0JCnJD5aBhiVdkohEFAz7e5YNrAg6kOA5IVRHB44lTBOatLqz7ntwdGD0rteKuHaUuXpTYy
 CRqCVAKqFJtxhvJvaX0vLS1Z2dwtDwhjfIdgPiKEGOgCNGH7R8l+aaM4OPOd
Message-ID: <26c57acc-cec4-9f61-a98e-25c49d5f43e6@amsat.org>
Date:   Wed, 12 Feb 2020 20:02:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <66e0a38c-a7f5-dcd1-d06b-b317588fad7a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/12/20 5:40 PM, Paolo Bonzini wrote:
> On 12/02/20 17:30, Paul Burton wrote:
>> Hi Paolo,
>>
>> On Wed, Feb 12, 2020 at 01:25:30PM +0100, Paolo Bonzini wrote:
>>> MIPS folks, I see that arch/mips/kvm/mmu.c uses pud_index, so it's not
>>> clear to me if it's meant to only work if CONFIG_PGTABLE_LEVELS=4 or
>>> it's just bit rot.  Should I add a "depends on PGTABLE_LEVEL=4" to
>>> arch/mips/Kconfig?
>>
>> I'm no expert on this bit of code, but I'm pretty sure the systems
>> KVM/VZ has been used on the most internally had PGTABLE_LEVEL=3.
>>
>> I suspect this is actually a regression from commit 31168f033e37 ("mips:
>> drop __pXd_offset() macros that duplicate pXd_index() ones"). Whilst
>> that commit is correct that pud_index() & __pud_offset() are the same
>> when pud_index() is actually provided, it doesn't take into account the
>> __PAGETABLE_PUD_FOLDED case. There __pud_offset() was available but
>> would always evaluate to zero, whereas pud_index() isn't defined...
> 
> Ok, I'll try to whip out a patch that handles __PAGETABLE_PUD_FOLDED.
> On the other hand this makes me worry about how much KVM is being tested
> by people that care about MIPS (even just compile-tested).

FYI last time James confirmed he tested QEMU was in 2017:
https://www.mail-archive.com/qemu-devel@nongnu.org/msg477133.html

At the end of 2019 he orphaned the QEMU part:
https://www.mail-archive.com/qemu-devel@nongnu.org/msg667240.html
and dropped the kernel maintainance:
https://git.kernel.org/pub/scm/linux/kernel/git/mips/linux.git/commit/?id=9c48c48cd499
