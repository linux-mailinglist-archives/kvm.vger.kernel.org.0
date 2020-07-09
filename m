Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7301219E6C
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 12:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgGIKzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 06:55:44 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60763 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726339AbgGIKzn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 06:55:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594292142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PTDQffC1tMzQ3lRtufW6bbJO7+lFsHLO2yhqYkX2OD4=;
        b=YGLpHXQQK1hwjWmpyQam+ytuiJlr3OAgk2CDqPez25wKTQ7ukhRymY4JF7OmPd8S1wIVej
        +MR7nyRO29puTx1Qek4Jj8lvkW+BO8eskLeTxjdGQK6QbtOAj5TkRhfCeC/8njo4IqfTIH
        bcKYjm8rX+Sf5tWE5FpYCbVYa907Pxo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-AaTxJTxzN-eaV0jWkQaJ9g-1; Thu, 09 Jul 2020 06:55:41 -0400
X-MC-Unique: AaTxJTxzN-eaV0jWkQaJ9g-1
Received: by mail-wr1-f69.google.com with SMTP id 89so1606277wrr.15
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 03:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PTDQffC1tMzQ3lRtufW6bbJO7+lFsHLO2yhqYkX2OD4=;
        b=pQyVhqZvWF2BCtG4lmm3swCRXOff2Td5IVUBj+MweVnEO3OTry1FZYQ41JmVnLOksM
         ANMNBClXb937yScIwXav/FklmI1+uCE6+OU3gQm4AceYhgNpsyd+3YXF1dtjzT2obR/n
         Kx5yB8HuHyoAXZ6Z6qiA7GKR0AHcwnlInMUHhYt9GWxpcXeVcirMIqfDJ4GTawZORgqZ
         MNbi3BDt2Rl6kFN7RGCXdHRX8nlHYQaWJxjqFYY6OZZKNAwpwInG7m9nOx3byRxUz7YF
         adBDKCXPKWX/QZMgZP2ICOthG9+Eq2RSgcPYR0nc4QRzWN8/XTdhX0KQPZT8Brp+yqgo
         cUjw==
X-Gm-Message-State: AOAM5335T89aJ/Kl5dpR6MPnB6eCR8TfpsYVRU9igjjsNts700/4bTGe
        YZ9o8jMXQlRVl0VxhMOdpXaV5sPvdkucacu/855JmKSlZ3gqL1m5qsHPgWxfLTkiUqaMeyFrb/c
        MVOHzGDemzf90
X-Received: by 2002:adf:ea0f:: with SMTP id q15mr32647615wrm.113.1594292140037;
        Thu, 09 Jul 2020 03:55:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4j0HtIxJr87LdzFPez74tjNG36xLEG2m4Lx3KIWQk4DnBnjXipmFHn/FMzkdbo05bFcQn0w==
X-Received: by 2002:adf:ea0f:: with SMTP id q15mr32647598wrm.113.1594292139839;
        Thu, 09 Jul 2020 03:55:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id u74sm4334245wmu.31.2020.07.09.03.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 03:55:39 -0700 (PDT)
Subject: Re: [PATCH v4 2/5] KVM: x86: Extract kvm_update_cpuid_runtime() from
 kvm_update_cpuid()
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200709043426.92712-1-xiaoyao.li@intel.com>
 <20200709043426.92712-3-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <27a4c18f-ba14-90f6-7918-f4520e7f3a69@redhat.com>
Date:   Thu, 9 Jul 2020 12:55:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709043426.92712-3-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 06:34, Xiaoyao Li wrote:
> Beside called in kvm_vcpu_ioctl_set_cpuid*(), kvm_update_cpuid() is also
> called 5 places else in x86.c and 1 place else in lapic.c. All those 6
> places only need the part of updating guest CPUIDs (OSXSAVE, OSPKE, APIC,
> KVM_FEATURE_PV_UNHALT, ...) based on the runtime vcpu state, so extract
> them as a separate kvm_update_cpuid_runtime().

I'm not sure KVM_FEATURE_PV_UNHALT counts as one of these, but I guess
it's not a big deal.

Paolo

