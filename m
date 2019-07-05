Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547976062C
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 14:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbfGEMqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 08:46:14 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33529 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728116AbfGEMqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 08:46:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so9843570wru.0
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2019 05:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b+rUgDFc8Xj3OzxPRTReIh2TVRm86cFh+ybCvMQ5Hic=;
        b=L6jWqzjv0td8EjrEAEuRUg+82/y/h0npPrrjKrQnGd2JEfYtDc72CB7Wa+TPJr1gwr
         2u2v6S1U+oD9oP+ZHZ4v6DJ3N/QxOo3aL8iqdf1MOwG7Kyl/pnnN9eHvkEB8LhrT3XWJ
         2ZlBZcNWWnBqeWK174Qy+bPT7uHrfzGgklBm64ZNDB45SKG5zaqIdyXV5SLQJXTXzwrp
         /hGX8iAP6+XP5c5mx0dRQUtE/a0exJ3j0CGc7ssdYj54prF2ff/BK2wSzylqTD/dPo9V
         /86zDZl4dgKTux8z2/I9V5UdcbuV15sGTUDUa3OkIWDfIcN/Uy5JK+v3wPyoXG6KzuTZ
         Xu0Q==
X-Gm-Message-State: APjAAAUtcLpqy6DTjTIuymdq2zDhuuKyktzfRzC65Ew5DEMQho0ZCUz3
        sIj2qI86upE1xzbXOMvW6kRW2TPOqpY=
X-Google-Smtp-Source: APXvYqyqp47fm5Ov3nASK6uQBAIXIoVpy72iyvaVIJ7JLTUX/Dy715g93EFgYnDXLc0la/0pbC5toA==
X-Received: by 2002:adf:91c2:: with SMTP id 60mr4271400wri.334.1562330771790;
        Fri, 05 Jul 2019 05:46:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e943:5a4e:e068:244a? ([2001:b07:6468:f312:e943:5a4e:e068:244a])
        by smtp.gmail.com with ESMTPSA id t140sm9922367wmt.0.2019.07.05.05.46.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 05:46:11 -0700 (PDT)
Subject: Re: [PATCH] KVM: LAPIC: ARBPRI is a reserved register for x2APIC
To:     Liran Alon <liran.alon@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1562328872-27659-1-git-send-email-pbonzini@redhat.com>
 <D76638DF-1934-4B1C-84CD-FFCE11AA175F@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e8926d53-173b-c525-1c6e-36df9315337a@redhat.com>
Date:   Fri, 5 Jul 2019 14:46:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <D76638DF-1934-4B1C-84CD-FFCE11AA175F@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/19 14:37, Liran Alon wrote:
>> +	u64 rmask = 0x43ff01ffffffe70cULL;
> Why not rename this to “used_bits_mask” and calculate it properly by macros?
> It seems a lot nicer than having a pre-calculated magic.

Yes, I wanted to do the same but I didn't have time right now.  I am
planning to cleanup after the merge window, but if a patch comes soon I
can apply it instead of course. :)

Something like

#define APIC_VALID_REG_MASK(reg)	(1ull << ((reg) >> 4))
#define APIC_VALID_REGS_MASK(first, count) \
	(APIC_VALID_REG_MASK(first) * (1ull << ((count) - 1)))

followed by

	if (offset > 0x3f0 ||
	    !(valid_regs_mask & APIC_VALID_REG_MASK(offset))

Paolo

> -Liran
> 

