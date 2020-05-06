Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8BD1C7643
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgEFQ34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:29:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25196 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729405AbgEFQ3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 12:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588782594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=abwCUwFlrBH0/LiV4fKJ+ekZyJJub1hZZHM26AMRfgg=;
        b=Mdbv4MJuGkogt8l9p0XYKWYeFvLBPMzSr84QJGsI2gD2nkxi8dLQxsLrplUaPFGPmVB0UO
        RVPyVRqfHiCQbXPw2jaOtgrp30Wh+JfaASNXXKzmGT51f5wrnKrWabM06hJDOa+qQd1t5s
        Pp2s4BhL8gxv/qzuJWz7jd2wEn0YXFI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-vZje_QlkPVulb0V4vlZzRQ-1; Wed, 06 May 2020 12:29:52 -0400
X-MC-Unique: vZje_QlkPVulb0V4vlZzRQ-1
Received: by mail-wr1-f71.google.com with SMTP id v17so1591601wrq.8
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 09:29:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=abwCUwFlrBH0/LiV4fKJ+ekZyJJub1hZZHM26AMRfgg=;
        b=PtIPJKe+9CJSzWOP7yZoYrFhaIJX+IpduJyOQz4Eg/3sUHh2Fhdo+0qpy1LxqNJhpJ
         baGgx2YLTvIleSR9d23hKkz25iCllyJ4Mw01ozNpROuBShrZWMUaChtBqXVdD/8QNli3
         fQ+NSq6W6RkicelJbW+FvdcxJdcVKKuvPnoUTPJVP5isBgP+Eaug0blmSbH9auxH8UQ1
         tJoNERnawwX0QGwzdM+TO87yp7sKwILS7loM+xV6JMaz2cxySHxxPfFFke40QhUaUA/6
         gr/zRWlBcInJIEdVnKSQnmFaeXJLmIXzoL5leE+6Xz5Y44Qo7cYKH0xCsHGixQE59Kq7
         I1ww==
X-Gm-Message-State: AGi0Puav/Wsa94bdZBno20iI0kymn/HrXNmZ0cBWMl4+VqKgPKSPzAuH
        WJGmaXTGKvMp04n7S9yjrpT8vMrlTVQxAZaaXhl01INNcHnK8OhGJnYuUVnnK9wnaj85pMDo6K5
        ZgGaovBzrULQ4
X-Received: by 2002:a7b:c772:: with SMTP id x18mr5716548wmk.39.1588782591384;
        Wed, 06 May 2020 09:29:51 -0700 (PDT)
X-Google-Smtp-Source: APiQypIOizF0VWlYYPBGj4lNHbkD5Wb9Jr67pX998Z7+LwMKTtIBUNp+iXihf2wcB7cDgd24ImonDg==
X-Received: by 2002:a7b:c772:: with SMTP id x18mr5716526wmk.39.1588782591146;
        Wed, 06 May 2020 09:29:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id 5sm3304030wmg.34.2020.05.06.09.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 09:29:50 -0700 (PDT)
Subject: Re: [PATCH 2/4] KVM: SVM: Fixes setting V_IRQ while AVIC is still
 enabled
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     joro@8bytes.org, jon.grimm@amd.com, mlevitsk@redhat.com
References: <1588771076-73790-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1588771076-73790-3-git-send-email-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a963a336-4096-b53a-276b-6509f5cb9402@redhat.com>
Date:   Wed, 6 May 2020 18:29:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1588771076-73790-3-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/20 15:17, Suravee Suthikulpanit wrote:
>   */
> -void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
> +void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit,
> +			      struct kvm_vcpu *except)
>  {
>  	unsigned long old, new, expected;
>  
> @@ -8110,7 +8111,16 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
>  	trace_kvm_apicv_update_request(activate, bit);
>  	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
>  		kvm_x86_ops.pre_update_apicv_exec_ctrl(kvm, activate);
> -	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
> +
> +	/*
> +	 * Sending request to update APICV for all other vcpus,
> +	 * while update the calling vcpu immediately instead of
> +	 * waiting for another #VMEXIT to handle the request.
> +	 */
> +	kvm_make_all_cpus_request_except(kvm, KVM_REQ_APICV_UPDATE,
> +					 except);
> +	if (except)
> +		kvm_vcpu_update_apicv(except);

Can you use kvm_get_running_vcpu() instead of touching all callers?
Also a slightly better subject would be "KVM: SVM: Disable AVIC before
setting V_IRQ".

Paolo

