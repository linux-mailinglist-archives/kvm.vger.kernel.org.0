Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4199316B4E8
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 00:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgBXXM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 18:12:28 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35428 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727721AbgBXXM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 18:12:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582585946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vs3dntWvSoZuKohT+PUhBTZyrkXf/ZjGkKMw3SgzXtU=;
        b=cSwd29eCR3ZlzaQflWp6QwzXmEXTJfJQw4DDErM7Kv2L9iwV/70SWulXV8IGWRlhNcZJa6
        h9FJeDZMtASGmvTe4aFviALpXzMMX8NN9zm3AndwMotQghKGm4Wz7w2Fc7hxoj8O5rXHgE
        JpUAHkgv3Y2mOaZ2+XxMTxw+E7qNzJY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-dyaPUnjGOiOgsPaeOYEUHw-1; Mon, 24 Feb 2020 18:12:25 -0500
X-MC-Unique: dyaPUnjGOiOgsPaeOYEUHw-1
Received: by mail-wr1-f69.google.com with SMTP id t3so4555324wrp.2
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 15:12:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Vs3dntWvSoZuKohT+PUhBTZyrkXf/ZjGkKMw3SgzXtU=;
        b=uNPDxkkPfhlIIdXm5MPvDnYNIL10psbC7T2OwUKBKR18DZfSwG1dsM2ovdGKlilPDe
         8gpoM1K5nGrWLOhhS9Vvia3hJpzndZFsaiao1P05gp5obpUS3t9pqZ4Pw37FTwJb9wU0
         Z2qxnwQqNK/H2d8996+yOMCpeyktQNvZTOQoYK7riepdby05gEbvqoCdMYe8Y1wl00df
         LJ3q1xCW17l522zZqCculgC9vfRcm96n2NmPq6dmKaYvqfjjSKv26SGR1VlE0KqMtXgW
         YsW9yiktJaVLKI7JuUmglmByMbIDNmmRW3x1m5MJ4XlI0HPPaWarJyYwUt4yDV+Q55+c
         zCVw==
X-Gm-Message-State: APjAAAV4vwxALYsEooRKHRfCkoEWCfhzRMkrgTLTN+tOv9VpYlroj+gd
        xQSwUhSx8PYlPO0WoOeFJtjX3kAFT6JJXxo6hM2QOVBnooKYaRStfPfaCAERj3bNEMiavhAxze9
        /k6saqPMnURZF
X-Received: by 2002:a05:600c:34b:: with SMTP id u11mr1238006wmd.69.1582585943916;
        Mon, 24 Feb 2020 15:12:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqwgQZ09o1S3AQ6goRcV2RRdIuwUHwSHfgfjMonpALA8g9GRiuIjN7qDVPsCp3yZB1JBAtesqw==
X-Received: by 2002:a05:600c:34b:: with SMTP id u11mr1237992wmd.69.1582585943720;
        Mon, 24 Feb 2020 15:12:23 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t1sm1367352wma.43.2020.02.24.15.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 15:12:23 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/61] KVM: x86: Encapsulate CPUID entries and metadata in struct
In-Reply-To: <20200224215551.GL29865@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-17-sean.j.christopherson@intel.com> <87y2swq95k.fsf@vitty.brq.redhat.com> <20200224215551.GL29865@linux.intel.com>
Date:   Tue, 25 Feb 2020 00:12:22 +0100
Message-ID: <87imjvmvft.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Fri, Feb 21, 2020 at 03:58:47PM +0100, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> 
>
>> > +			if (!entry)
>> >  				goto out;
>> >  		}
>> >  		break;
>> > @@ -802,22 +814,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>> >  	return r;
>> >  }
>> >  
>> > -static int do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 func,
>> > -			 int *nent, int maxnent, unsigned int type)
>> > +static int do_cpuid_func(struct kvm_cpuid_array *array, u32 func,
>> > +			 unsigned int type)
>> >  {
>> > -	if (*nent >= maxnent)
>> > +	if (array->nent >= array->maxnent)
>> >  		return -E2BIG;
>> >  
>> >  	if (type == KVM_GET_EMULATED_CPUID)
>> > -		return __do_cpuid_func_emulated(entry, func, nent, maxnent);
>> > +		return __do_cpuid_func_emulated(array, func);
>> 
>> Would it make sense to move 'if (array->nent >= array->maxnent)' check
>> to __do_cpuid_func_emulated() to match do_host_cpuid()?
>
> I considered doing exactly that.  IIRC, I opted not to because at this
> point in the series, the initial call to do_host_cpuid() is something like
> halfway down the massive __do_cpuid_func(), and eliminating the early check
> didn't feel quite right, e.g. there is a fair amount of unnecessary code
> that runs before hitting the first do_host_cpuid().
>
> What if I add a patch towards the end of the series to move this check into
> __do_cpuid_func_emulated(), i.e. after __do_cpuid_func() has been trimmed
> down to size and the early check really is superfluous.
>

Works for me, thanks!

-- 
Vitaly

