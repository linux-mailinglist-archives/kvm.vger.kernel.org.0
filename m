Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BD453B9D3
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 15:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbiFBNet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 09:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbiFBNep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 09:34:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B64D93527C
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 06:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654176880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8EHhCCIbi1O6ehGedFb4ihf8BQ4dVN2ahlxeyANEwXA=;
        b=c8HisQ2pkG/vmLZt3Dk1AilehWO7btv5KGzWnPfjB8/vZ/uDxTn4QC/MAQ9DB4KruHZs3Q
        ZUx2hHnyR1C8d4p1toCKuZcg1EJuucGsz54Rz+FIUY5OHvKN8fzYZKmxGm4EjeQPFN6w+q
        2qRHYsBgHMDHE3fD96JF2RxGIdR577U=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-YHbsMjo0OtOkEuPIrJj2IA-1; Thu, 02 Jun 2022 09:34:39 -0400
X-MC-Unique: YHbsMjo0OtOkEuPIrJj2IA-1
Received: by mail-ed1-f71.google.com with SMTP id t14-20020a056402020e00b0042bd6f4467cso3466182edv.9
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 06:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8EHhCCIbi1O6ehGedFb4ihf8BQ4dVN2ahlxeyANEwXA=;
        b=yapCN41pwDWCkGNbpBptn2uBJjRk74mR9/pvwpbQSO8SpoV5eSA8EVgiXzYbNbs20S
         lF5htuLXwmQI5XG8E7nUGPMiHq77pqxsmG5A3Rbl8B0ipoWNvdvqfLHKXXTPdytcA4JZ
         uTocKM6kyb4TDk/8tzPbSB3KZYhqtDjzbY7IfECc7XjdOKWzBp6bTwnsm2OmVGTVCuRw
         8uWlhDQ6SfQq5QIQMYytxQfIoaORdaDG9vQg7OwSsupdq9ihrxsyb+6kI0tKNbnIH42Y
         obGFLbx/Szx515Te0+7SAxSyL8It7B4WN344c1oO+RH0+VeyWYZ11+Vhego6uG8InwtD
         1HFQ==
X-Gm-Message-State: AOAM533+BwHbNGzExJsKakyiF7VEylJcwh24n/xk+hLwOlH4+RU3Asw8
        Z409SQkxVLTYQ7AfqS4EfObMI1SiOt41nRbwCOxACeqzAGz5hMPR4n9AFd+chgOGj+FAAIYUVR5
        PNJO84Ne2DdJt
X-Received: by 2002:a17:906:dc8e:b0:6ff:2995:992d with SMTP id cs14-20020a170906dc8e00b006ff2995992dmr4253980ejc.725.1654176878638;
        Thu, 02 Jun 2022 06:34:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVVVt/VANOJ8pLYC9/ALH1B9r2B5L9mg5D0LUHwnfbREv3zL6CbUU/H1ejf6YOpPd/ZqgI8g==
X-Received: by 2002:a17:906:dc8e:b0:6ff:2995:992d with SMTP id cs14-20020a170906dc8e00b006ff2995992dmr4253962ejc.725.1654176878440;
        Thu, 02 Jun 2022 06:34:38 -0700 (PDT)
Received: from fedora (nat-wifi.fi.muni.cz. [147.251.43.9])
        by smtp.gmail.com with ESMTPSA id l15-20020a17090615cf00b006f3ef214dd9sm1748457ejd.63.2022.06.02.06.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 06:34:38 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Make hyperv_clock selftest more stable
In-Reply-To: <YpeOkx0gkINeKFuz@google.com>
References: <20220601144322.1968742-1-vkuznets@redhat.com>
 <YpeOkx0gkINeKFuz@google.com>
Date:   Thu, 02 Jun 2022 15:34:37 +0200
Message-ID: <87ee07nq8i.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jun 01, 2022, Vitaly Kuznetsov wrote:
>> hyperv_clock doesn't always give a stable test result, especially with
>> AMD CPUs. The test compares Hyper-V MSR clocksource (acquired either
>> with rdmsr() from within the guest or KVM_GET_MSRS from the host)
>> against rdtsc(). To increase the accuracy, increase the measured delay
>> (done with nop loop) by two orders of magnitude and take the mean rdtsc()
>> value before and after rdmsr()/KVM_GET_MSRS.
>
> Rather than "fixing" the test by reducing the impact of noise, can we first try
> to reduce the noise itself?  E.g. pin the test to a single CPU, redo the measurement
> if the test is interrupted (/proc/interrupts?), etc...  Bonus points if that can
> be implemented as a helper or pair of helpers so that other tests that want to
> measure latency/time don't need to reinvent the wheel.

While I'm not certain task migration to another CPU was always the
problem here (maybe the measured interval is too short anyway), I agree
these are good ideas, I'll look into them, thanks!

-- 
Vitaly

