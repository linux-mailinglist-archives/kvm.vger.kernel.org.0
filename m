Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4AB51AE5
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 20:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfFXSnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 14:43:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34694 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbfFXSng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 14:43:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id k11so15034247wrl.1
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2019 11:43:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GfjEkDFqzgTZBEb7tk5FQBBfhGJ6qrc4fpvCj0iHlvg=;
        b=lfXrlJnF8UoyfVYIvsVegIAjcXn02kXESNSVDNZMoAkbQ4wYpBn+dEu3S05W3RVpso
         gjQWcKHmOvVz1nu+YMtYuI/PcFtqi78XgL2Q9/7buRXe1gXbv3s9TP5BNkAkZCVNjlx0
         5MTOm6n0V/jb6IB2fkMjMzH8PZKZKNYtgCWglx7yBXHBDKlFrBWlgMxwvk98oqxw+mKF
         J/O1BgWrCo4M+m5LTObCIzzD6oAnlLMfaEKbnPcII8kUDTQMNRCjPvIF4r76OR1js1eZ
         3p3qiYrXvEYerR8w8NyltmKyfH7+yB+hDC8uOTAS9aOs0vrYmHXcsnbaRDEcoq0nNRi/
         vaaA==
X-Gm-Message-State: APjAAAUArNMOz/3XnRJs1tQ5vwApOZ+1HRzvF1yIDGCWu7b+yMgxhAHP
        y24F8/U1oDYyC9a1PO1jmK6KzFZb8G8=
X-Google-Smtp-Source: APXvYqw37VJQFJbX+dUabx4CSUB5gIDbQkk/Rk2XlTrf2S7d3VSRR3BHYb/8IS7tK0hRyAS3jV9ftA==
X-Received: by 2002:a5d:66ce:: with SMTP id k14mr45670884wrw.308.1561401815379;
        Mon, 24 Jun 2019 11:43:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:45fb:a0de:928e:79e8? ([2001:b07:6468:f312:45fb:a0de:928e:79e8])
        by smtp.gmail.com with ESMTPSA id y19sm397750wmc.21.2019.06.24.11.43.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 11:43:34 -0700 (PDT)
Subject: Re: [PATCH v9 02/17] drivers/net/b44: Align pwol_mask to unsigned
 long for better performance
To:     David Laight <David.Laight@ACULAB.COM>,
        'Fenghua Yu' <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-3-git-send-email-fenghua.yu@intel.com>
 <fce80c42ba1949fd8d7924786bbf0ec8@AcuMS.aculab.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4cd9d48f-e655-4943-2ec9-1b74a77e317c@redhat.com>
Date:   Mon, 24 Jun 2019 20:43:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <fce80c42ba1949fd8d7924786bbf0ec8@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/19 17:12, David Laight wrote:
> From: Fenghua Yu
>> Sent: 18 June 2019 23:41
>> From: Peter Zijlstra <peterz@infradead.org>
>>
>> A bit in pwol_mask is set in b44_magic_pattern() by atomic set_bit().
>> But since pwol_mask is local and never exposed to concurrency, there is
>> no need to set bit in pwol_mask atomically.
>>
>> set_bit() sets the bit in a single unsigned long location. Because
>> pwol_mask may not be aligned to unsigned long, the location may cross two
>> cache lines. On x86, accessing two cache lines in locked instruction in
>> set_bit() is called split locked access and can cause overall performance
>> degradation.
>>
>> So use non atomic __set_bit() to set pwol_mask bits. __set_bit() won't hit
>> split lock issue on x86.
>>
>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
>> ---
>>  drivers/net/ethernet/broadcom/b44.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
>> index 97ab0dd25552..5738ab963dfb 100644
>> --- a/drivers/net/ethernet/broadcom/b44.c
>> +++ b/drivers/net/ethernet/broadcom/b44.c
>> @@ -1520,7 +1520,7 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
>>
>>  	memset(ppattern + offset, 0xff, magicsync);
>>  	for (j = 0; j < magicsync; j++)
>> -		set_bit(len++, (unsigned long *) pmask);
>> +		__set_bit(len++, (unsigned long *)pmask);
>>
>>  	for (j = 0; j < B44_MAX_PATTERNS; j++) {
>>  		if ((B44_PATTERN_SIZE - len) >= ETH_ALEN)
>> @@ -1532,7 +1532,7 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
>>  		for (k = 0; k< ethaddr_bytes; k++) {
>>  			ppattern[offset + magicsync +
>>  				(j * ETH_ALEN) + k] = macaddr[k];
>> -			set_bit(len++, (unsigned long *) pmask);
>> +			__set_bit(len++, (unsigned long *)pmask);
> 
> Is this code expected to do anything sensible on BE systems?

Probably not, but it's not wrong in different ways before/after the patch.

Paolo

> Casting the bitmask[] argument to any of the set_bit() functions is dubious at best.
