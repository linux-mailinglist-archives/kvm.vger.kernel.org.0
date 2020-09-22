Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2782744F1
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 17:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgIVPEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 11:04:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41366 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726628AbgIVPEq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 11:04:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600787085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V1IJHLNzyNWfSG7yNwnqHpoKpV5hYRM7LWoOpXtg+hw=;
        b=NnHdlhNmBcY9RsStbtVPrdyVSNO97vjJpPGYMombV1kWtKCZe48iP20IDv6jAMzPpJ0cHm
        0M8e1vRdTf0kF/dgMCK5fs/MHOLHt4MlLHIh4mH/DF+eXcuroqHFP5tA+FRQ+cAk/NE5ES
        U0xzwAMo+VNeSXM2dW3kmYJChy0h/HE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-SG1xgq6zNF26JkXowVeWMQ-1; Tue, 22 Sep 2020 11:04:43 -0400
X-MC-Unique: SG1xgq6zNF26JkXowVeWMQ-1
Received: by mail-wm1-f71.google.com with SMTP id b14so667850wmj.3
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 08:04:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V1IJHLNzyNWfSG7yNwnqHpoKpV5hYRM7LWoOpXtg+hw=;
        b=imY+KEgk3MISLjxFowMZwOPviruL6ak4UcuLZFh3tZhlU0cZfH6C99sijBQ0FgyU1c
         V/IFae8neA2/rstxwlOhXbN01zX8ZwlfkBK7KIazrQwoZSdz6Pjyaj1312MevgiTf07k
         DURIYEPBWGLL5yVbf02c4sD0fUIdanTOiboU0w4jZ/zp24nGO19DNEJg57vfoidhM72s
         jJyyjsZgvuWcHVVOM0bV8yMjeK5D9aCDd4FcfmqQP4GRQxK9IW4GdnotZbCIxJGKkzve
         nSAwboPWM2XkEb0OGtOYz9k40OQBbo9RjjQaZ5KspQqDAdkFWoGti5tHzA7R3VW5WEca
         jEnQ==
X-Gm-Message-State: AOAM533/1P9QRlqsJfTPUmPI0ydB2OhYp6/Y9qtF3D/pU4UZiwcmuevq
        oj1wojGjilSiITIim8SQ22jdlqjaMw3229Z028iVcmgN19wGCajpLBGndte9pm6W4QQc/JfJFuQ
        OiO+rO8zSz34P
X-Received: by 2002:adf:8b1d:: with SMTP id n29mr5638126wra.383.1600787081983;
        Tue, 22 Sep 2020 08:04:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/dstyumNGENv2ku/5jDo0w0oo0cy9PXaBGO3Rl3qxDh1bcFIFsMTU6FqXA9ACfYNftkaiYQ==
X-Received: by 2002:adf:8b1d:: with SMTP id n29mr5638106wra.383.1600787081809;
        Tue, 22 Sep 2020 08:04:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id u17sm4965715wmm.4.2020.09.22.08.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 08:04:40 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Use a separate vmcb for the nested L2 guest
To:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, wei.huang2@amd.com
References: <20200917192306.2080-1-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a6ed7866-69c3-ab5e-7219-d7c5075509db@redhat.com>
Date:   Tue, 22 Sep 2020 17:04:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200917192306.2080-1-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/09/20 21:23, Cathy Avery wrote:
> 
> 2) There is a workaround in nested_svm_vmexit() where
> 
>    if (svm->vmcb01->control.asid == 0)
>        svm->vmcb01->control.asid = svm->nested.vmcb02->control.asid;
> 
>    This was done as a result of the kvm selftest 'state_test'. In that
>    test svm_set_nested_state() is called before svm_vcpu_run().
>    The asid is assigned by svm_vcpu_run -> pre_svm_run for the current
>    vmcb which is now vmcb02 as we are in nested mode subsequently
>    vmcb01.control.asid is never set as it should be.

I think the asid should be kept in svm->asid, and copied to
svm->vmcb->control.asid in svm_vcpu_run.  It's slightly overkill for
non-nested but it simplifies the nested case a lot so it's worth it.

That would be a first patch in the series, placed before this one.

Paolo

