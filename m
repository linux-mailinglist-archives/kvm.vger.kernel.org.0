Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F08D45BB5
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 13:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfFNLu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 07:50:56 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38447 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfFNLu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 07:50:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id d18so2215838wrs.5
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2019 04:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j/mrTktDdZBIOs0fb7bg3GlLfNmxkoW9xlbMZCkSZ0I=;
        b=X57dInWjSfJLzXwFIEJdQ5q6FsaS7CvV1EF+IkBVFhkzOOrUcEJ8GYohyKra30O9bL
         DgC889Z97zOmyYvArr3dNR5uguITXF/4k25N90biUzdDwX1YLc0K55cClHn5hD/m9DQr
         GdX6zoEcAVANQOs9OMkNUHsBNPvc6+jXi/+cnRu1AqqUYVMizGmHhzJuymsJAs72qSnY
         e8F3/ZPbxbdHSq7MdgpmfoT4ec4DS0vA3tZVPQHXLmbCs/pEXNbRSZdJNq/EDlac9ieS
         yGsbdUapKayV7E6lyKh04LQsF1MKh2CokJE48bCM7aGEJOUNIYWhm+teYHC79YzfoQJa
         GwVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j/mrTktDdZBIOs0fb7bg3GlLfNmxkoW9xlbMZCkSZ0I=;
        b=I4nutNQ3XHKkQmCLTXPMz1a6C9N8edsKkyRWwhyFXKNOS0pPuaINOCjMDT1yKWGsLd
         AV7pnuo+EPVPNfFKZBTP1fy1oUyNovphP4p6pX/moBJBlff1RAL40Mzj67Ri4Lwiw/i6
         jQjIwekp7Y7maz4qzfTfKFqc5yOG2uw2k2Uw58W6E0tTrUFz+n8mShBiMCdGsgAWWdwu
         2GXceO7VkhmYrtUE3G8u9NzjW689vRQyQswYRTRr58GiRVjqf2eSxfADTB0LUw3Dln+V
         R2yU9RUdxR9O/Tnw2hMrt3i5+6p5mi9cusjjTyU67KT6SJWHSg1OUxMtn14pzNfFFRVl
         c57g==
X-Gm-Message-State: APjAAAXSpmlHDjvBSzvHmYUdxwjiI5PDy7JQ0PDft5fmQ0TX+qzTly6X
        a9CWyJU4MwQSWJpXxro0K8it3Q==
X-Google-Smtp-Source: APXvYqzAYHdO6w8DBfi5lPDXVFzFFl/H9Zr+6ay+lTLK6DZ+DrLmMao9TSeNccrggbh94rgdTebIrA==
X-Received: by 2002:a5d:540e:: with SMTP id g14mr5857286wrv.346.1560513053775;
        Fri, 14 Jun 2019 04:50:53 -0700 (PDT)
Received: from [10.83.36.153] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id x129sm4138600wmg.44.2019.06.14.04.50.52
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 04:50:53 -0700 (PDT)
Subject: Re: [PATCH] x86/hyperv: Disable preemption while setting
 reenlightenment vector
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Prasanna Panchamukhi <panchamukhi@arista.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Cathy Avery <cavery@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>,
        Mohammed Gamal <mmorsy@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Sasha Levin <sashal@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        devel@linuxdriverproject.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, x86@kernel.org
References: <20190611212003.26382-1-dima@arista.com>
 <8736kff6q3.fsf@vitty.brq.redhat.com>
 <20190614082807.GV3436@hirez.programming.kicks-ass.net>
 <877e9o7a4e.fsf@vitty.brq.redhat.com>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <cb9e1645-98c2-4341-d6da-4effa4f57fb1@arista.com>
Date:   Fri, 14 Jun 2019 12:50:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <877e9o7a4e.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/14/19 11:08 AM, Vitaly Kuznetsov wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
>> @@ -182,7 +182,7 @@ void set_hv_tscchange_cb(void (*cb)(void))
>>  	struct hv_reenlightenment_control re_ctrl = {
>>  		.vector = HYPERV_REENLIGHTENMENT_VECTOR,
>>  		.enabled = 1,
>> -		.target_vp = hv_vp_index[smp_processor_id()]
>> +		.target_vp = hv_vp_index[raw_smp_processor_id()]
>>  	};
>>  	struct hv_tsc_emulation_control emu_ctrl = {.enabled = 1};
>>  
> 
> Yes, this should do, thanks! I'd also suggest to leave a comment like
> 	/* 
>          * This function can get preemted and migrate to a different CPU
> 	 * but this doesn't matter. We just need to assign
> 	 * reenlightenment notification to some online CPU. In case this
>          * CPU goes offline, hv_cpu_die() will re-assign it to some
>  	 * other online CPU.
> 	 */

What if the cpu goes down just before wrmsrl()?
I mean, hv_cpu_die() will reassign another cpu, but this thread will be
resumed on some other cpu and will write cpu number which is at that
moment already down?

(probably I miss something)

And I presume it's guaranteed that during hv_cpu_die() no other cpu may
go down:
:	new_cpu = cpumask_any_but(cpu_online_mask, cpu);
:	re_ctrl.target_vp = hv_vp_index[new_cpu];
:	wrmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));

-- 
          Dima
