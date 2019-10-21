Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2308DF40B
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 19:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbfJURT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 13:19:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728828AbfJURT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 13:19:27 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 14F95C05E740
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 17:19:27 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id l4so4994527wru.10
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 10:19:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ld2sD7K11SrzwjFl9eHxvksw0/zWsi3v0XYvIHwISxY=;
        b=jRzmSOtya+bKas3wCsM9UkhuS6nC+ldxAz2gmrVNX7BZ4BlilyaxXF/vW8bhAE9y6v
         HvQNWMHX3KooyqqN8ozJ2jzub8YrDAXHJzvrVuJZ23wYuBSO09Ge9vcOE/w57zkpFG44
         vGLN2oJ1Sx23k7tlhxgUBbUQBykYo74b7raCawPAlTn64RvdvIXCCzRFZdw4D+D6pmU2
         ifZs3OYJb0+ImFjBgeCna08r7FtCkJGOpK9W2G49l4XW730Dg1Hzd0FHq3REthIePEGx
         Y/WCjDylKr/5BlBkhp/dbsg8X4mivSFScBnwGQ1HXdHwzK4it3ZEPYhxX1ARZZmBfLL5
         2JHg==
X-Gm-Message-State: APjAAAWk22/SsjtKdDUHJmmOTXJE7xtnsBrVLF6Qr/AGL2XN5cY2ks2e
        1T0yqw2L9cwd7x8dLIc1VnE2mi39SRwjqQho1nmtKmHvC4Ol9pgB9xGrRBerdO98g/RVOrsIh3T
        rsS/yG6oW4LQM
X-Received: by 2002:adf:f686:: with SMTP id v6mr22337049wrp.141.1571678365525;
        Mon, 21 Oct 2019 10:19:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyiywPmg6NJ1czyf6ouMoCYDpKf4Afn/Dv4XonOBOJn93D/U1NSTqiVTKULCWxKEGXSL0j/KA==
X-Received: by 2002:adf:f686:: with SMTP id v6mr22337034wrp.141.1571678365267;
        Mon, 21 Oct 2019 10:19:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:847b:6afc:17c:89dd? ([2001:b07:6468:f312:847b:6afc:17c:89dd])
        by smtp.gmail.com with ESMTPSA id 126sm16138702wma.48.2019.10.21.10.19.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 10:19:24 -0700 (PDT)
Subject: Re: [PATCH] kvm: clear kvmclock MSR on reset
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     suleiman@google.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <1570704617-32285-1-git-send-email-pbonzini@redhat.com>
 <87wod439hq.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <62a31237-8b15-48da-50ef-2649daa20fdb@redhat.com>
Date:   Mon, 21 Oct 2019 19:19:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87wod439hq.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 19:06, Vitaly Kuznetsov wrote:
>>  		/* we verify if the enable bit is set... */
>> +		vcpu->arch.pv_time_enabled = false;
>>  		if (!(data & 1))
>>  			break;
>>  
>>  		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
>>  		     &vcpu->arch.pv_time, data & ~1ULL,
>>  		     sizeof(struct pvclock_vcpu_time_info)))
>> -			vcpu->arch.pv_time_enabled = false;
>> -		else
>>  			vcpu->arch.pv_time_enabled = true;

Yes...

Paolo
