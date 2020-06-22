Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EBF2043B0
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgFVWdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:33:04 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46620 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730979AbgFVWdD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592865180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xrw0gKe5/c5LtEWvIrfIEmLvBi2YnHPNOy4JhMd6bTY=;
        b=cd5UDVSyjV/B+hXAySZH0mW63/PeLCL2dTFgZNKcUhNkvtXqqpL9TX9ari6iGP+w0lfo+n
        WgutcIhlI4fB+9eePrn37QVO9dVgX3cRK1uo2HL5Yw7LpMIw9lhPfU4dwzJJnSIP7j6MZQ
        e/EqUqG8owKlVd9unPlJ6m5X7DenoZ4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-LDLaiQl-MDaRGl2tKRWeeA-1; Mon, 22 Jun 2020 18:32:58 -0400
X-MC-Unique: LDLaiQl-MDaRGl2tKRWeeA-1
Received: by mail-wm1-f70.google.com with SMTP id r1so860633wmh.7
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 15:32:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xrw0gKe5/c5LtEWvIrfIEmLvBi2YnHPNOy4JhMd6bTY=;
        b=YpxkKPpB0FbKe8N4mAHeN4DROQeMJmiIdH4qn8NgHD9Cd8g93wlcCi+8RzKdxyiQDS
         aAC2XbdFLfoWNuAK1whg4YuCwfVu5OYaeQsR2VgQVMu76b/o/KxebPHEbYQQPsPJM0uD
         Yc7bQ5HdMyuRKsFdlgZHy/EjwxWb5Mhv+/aklAVlIEALzIRaGvPajiGD4qMziep7Jf1F
         otW82j7abkrJNvBXyBD3GP5i2/5Chjo7op2SmofD3NqSZJobe5lQ7PoOkeGsMIhzBRZL
         9yEtPIPA0g/Kgn51i5BXVZM9/dp8aGjN90pEFIcXMI5iSTm7iK4C66+eRgCujIU7bqsm
         KQhw==
X-Gm-Message-State: AOAM533AIyAx5Y4hLnsWhQr1PHa0iuBu++nZchH0NbfQJeS1xxVt9yj7
        cmRZNmBc6T85kphfo0nWsH9WjssT+Jy8SfY0ltreE0pGeMlA9bMEAJ9JnhSmzc00uYNq3cqFja7
        REqUNhPzOS+3A
X-Received: by 2002:a1c:9d56:: with SMTP id g83mr6439332wme.130.1592865177208;
        Mon, 22 Jun 2020 15:32:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzL9F0heuWH59vc0OrHCfvzUi9IUx6uOSbcbNIM7Pk098MyrEnKpGaSdAcPSPXZOlegKzO0Sg==
X-Received: by 2002:a1c:9d56:: with SMTP id g83mr6439316wme.130.1592865177008;
        Mon, 22 Jun 2020 15:32:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id y196sm1239309wmd.11.2020.06.22.15.32.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 15:32:56 -0700 (PDT)
Subject: Re: [PATCH 1/2] kvm: x86: Refine kvm_write_tsc synchronization
 generations
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>
References: <20200615230750.105008-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <05fe5fcb-ef64-3592-48a2-2721db52b4e3@redhat.com>
Date:   Tue, 23 Jun 2020 00:32:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200615230750.105008-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/20 01:07, Jim Mattson wrote:
> +		} else if (vcpu->arch.this_tsc_generation !=
> +			   kvm->arch.cur_tsc_generation) {
>  			u64 tsc_exp = kvm->arch.last_tsc_write +
>  						nsec_to_cycles(vcpu, elapsed);
>  			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;

Can this cause the same vCPU to be counted multiple times in
nr_vcpus_matched_tsc?  I think you need to keep already_matched (see
also the commit message for 0d3da0d26e3c, "KVM: x86: fix TSC matching",
2014-07-09, which introduced that variable).

Thanks,

Paolo

> @@ -2062,7 +2062,6 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  			offset = kvm_compute_tsc_offset(vcpu, data);
>  		}
>  		matched = true;
> -		already_matched = (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
>  	} else {
>  		/*
>  		 * We split periods of matched TSC writes into generations.
> @@ -2102,12 +2101,10 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>  
>  	spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
> -	if (!matched) {
> -		kvm->arch.nr_vcpus_matched_tsc = 0;
> -	} else if (!already_matched) {
> +	if (matched)
>  		kvm->arch.nr_vcpus_matched_tsc++;
> -	}
> -
> +	else
> +		kvm->arch.nr_vcpus_matched_tsc = 0;

