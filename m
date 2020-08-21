Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C434F24D05C
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 10:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHUIJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 04:09:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58468 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726119AbgHUIJJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 04:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597997347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kuv27KkdzWeRw0okScxNF6ME0DnUfvMSl85Yx9SjFI4=;
        b=ZSAgctt6grrW5qVRnKk/jdccAIu4TKojRwIKGOLF/H8ovR8L1+0dSX5H+A5Q/scU7J4U9x
        pCOun5zGVC9Cbvf27v10sneRd4F5StiMY683rMhV+QzMGyM3/G6rrgaVGbn5MMXyvKlf1G
        MW0MjmxGKO24+Sq808clOM+IXAuBSFk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-aql5F0b9OMW_DvJsXXMiQg-1; Fri, 21 Aug 2020 04:09:05 -0400
X-MC-Unique: aql5F0b9OMW_DvJsXXMiQg-1
Received: by mail-wr1-f72.google.com with SMTP id b8so306461wrr.2
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 01:09:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kuv27KkdzWeRw0okScxNF6ME0DnUfvMSl85Yx9SjFI4=;
        b=gtlvSwIaDMaYOMmaSvj/7ej4q3NPHX9bW21+5gatwSsa5mB2RlD8+PymmKt6ONdqob
         8MKQgPfGAOYhAZfg1xIisHDNQ0B8chamE8FiIZU/TB89wr0w8D7a9CMJxQgSKJMg+Ynp
         6iKBze8E+FfB0VfpV7+2LiHcVEsCKtkkT/lZUS+SMnGc9TQ7aZcJAqs7iQdlTTFPBDh0
         dUZin/j4QBDmESkKynk+xQ9sVJHNyJ4442IsA6uPlCPbdc6wG2VIjajAHgd1mydbeLTW
         TZfPBU0f4nwcBwfjfdUGIt5fArQU4orFQuUS0yeN/+EaiiFRHeEHtATYqmB2uhGtMiBe
         UINQ==
X-Gm-Message-State: AOAM530E/TPVYy5r6Tu3IG5BjWZHx2gwo4yL1uDB9GUHcL6vajGW6qXR
        yWn+Gn6CCZoFYc3pGyJ+N1vhkt/eW5zl58cuC3/D201x2ZqutrYFtYsbncyjRpIf1oEmuCB89yu
        HLgIHTviWtf8e
X-Received: by 2002:a7b:c242:: with SMTP id b2mr1981485wmj.90.1597997344007;
        Fri, 21 Aug 2020 01:09:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHY1ITn5JcVj0dvaRsByYUByLRDSGyp3RfKZXp3gpLmamr7JT/gqsy22MhRt27obuHXYNTIg==
X-Received: by 2002:a7b:c242:: with SMTP id b2mr1981446wmj.90.1597997343663;
        Fri, 21 Aug 2020 01:09:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cc0:4e4e:f1a9:1745? ([2001:b07:6468:f312:1cc0:4e4e:f1a9:1745])
        by smtp.gmail.com with ESMTPSA id t11sm2607917wrs.66.2020.08.21.01.09.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 01:09:02 -0700 (PDT)
Subject: Re: [PATCH] x86/entry/64: Disallow RDPID in paranoid entry if KVM is
 enabled
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200821025050.32573-1-sean.j.christopherson@intel.com>
 <20200821074743.GB12181@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3eb94913-662d-5423-21b1-eaf75635142a@redhat.com>
Date:   Fri, 21 Aug 2020 10:09:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200821074743.GB12181@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/08/20 09:47, Borislav Petkov wrote:
> On Thu, Aug 20, 2020 at 07:50:50PM -0700, Sean Christopherson wrote:
>> +	 * Disallow RDPID if KVM is enabled as it may consume a guest's TSC_AUX
>> +	 * if an NMI arrives in KVM's run loop.  KVM loads guest's TSC_AUX on
>> +	 * VM-Enter and may not restore the host's value until the CPU returns
>> +	 * to userspace, i.e. KVM depends on the kernel not using TSC_AUX.
>>  	 */
> And frankly, this is really unfair. The kernel should be able to use any
> MSR. IOW, KVM needs to be fixed here. I'm sure it context-switches other
> MSRs so one more MSR is not a big deal.

The only MSR that KVM needs to context-switch manually are XSS and
SPEC_CTRL.  They tend to be the same on host and guest in which case
they can be optimized away.

All the other MSRs (EFER and PAT are those that come to mind) are
handled by the microcode and thus they don't have the slowness of
RDMSR/WRMSR

One more MSR *is* a big deal: KVM's vmentry+vmexit cost is around 1000
cycles, adding 100 clock cycles for 2 WRMSRs is a 10% increase.

Paolo

