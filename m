Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43EDF1934F8
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 01:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgCZA2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 20:28:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:33008 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727530AbgCZA2J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 20:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585182487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SDXVjwabGcLnnuvHuXD+2C6fjzzt3JFDASzYAhuMkEg=;
        b=XqU5v+aqaY7tU6RFlZxJtffvM1J1iHRsVor6nD5HG1lK/zJGSsRsmAv5yU5NuHX3/cJMOV
        wjWhsXgygFqnoEC+XYOVURgD8AiCuhVZ33OMjIr0ONGGSrXoMtETKYOcm5GVBVpM6x3BAE
        sSloQqmgCBwdQg3V3l62kbGQysf5sqA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-YSqd4OlpMES46cvJHz4K1Q-1; Wed, 25 Mar 2020 20:28:06 -0400
X-MC-Unique: YSqd4OlpMES46cvJHz4K1Q-1
Received: by mail-wm1-f71.google.com with SMTP id f185so1467248wmf.8
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 17:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SDXVjwabGcLnnuvHuXD+2C6fjzzt3JFDASzYAhuMkEg=;
        b=XbNLYIj0KcEJKX94NPUTeGmQUAfITKVSeb1LsE0UV9qbQqa/4T7XEMEjykuFscVZ42
         rlvT4Ri7wTnL+wYg3iMycfvdG3NZs3wAFrDs70dM9eBAqbNqnuQ8YbC8slx7SgGzldpV
         7vojnX3y1ywuzNX4zYE7UCsel9DyrIWHi+eYhKssocpUteCx9tDV7wgaDjqBZEn0l0bD
         KYBj7M+DsY0afYIIjyVixjyO/QJnZ3zvLpkPVAnsstiYv/rY/6dn54CraSEA3J001B5k
         9slTLEB4X/Mi09HJ76cvns5D8e0m8ucomK1NbR8f8fPaFEzKD6vSZIK09B6mMFC9azE1
         NPjA==
X-Gm-Message-State: ANhLgQ1025xrgY12lFoU6RV2+JvLu5KpDG58UwLE3hkUGWIlIk6bmebd
        AsAq3+j8bx4e+QjLKjpGCazw5qWi6tVj9pRA7LBqwzlMABggS6ZPrj8NQtzqTCtK8gOdk2Eu1s+
        Lc4/U0mdEMc1W
X-Received: by 2002:a1c:cc0a:: with SMTP id h10mr186278wmb.127.1585182485154;
        Wed, 25 Mar 2020 17:28:05 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtAeCtfvyg1e/6on18f0iRgwGs0bFCeegTp5Koi0KhHlOdFq4kOD9JbFWu4AHOeYtV60i0H1Q==
X-Received: by 2002:a1c:cc0a:: with SMTP id h10mr186264wmb.127.1585182484845;
        Wed, 25 Mar 2020 17:28:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e4f4:3c00:2b79:d6dc? ([2001:b07:6468:f312:e4f4:3c00:2b79:d6dc])
        by smtp.gmail.com with ESMTPSA id b82sm972243wmb.46.2020.03.25.17.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 17:28:04 -0700 (PDT)
Subject: Re: [PATCH] KVM: LAPIC: Also cancel preemption timer when disarm
 LAPIC timer
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1585031530-19823-1-git-send-email-wanpengli@tencent.com>
 <708f1914-be5e-91a0-2fdf-8d34b78ca7da@redhat.com>
 <CANRm+CwGT4oU_CcpRcDhS992htXdP4rcO6QqkA1CyryUJbE6Ug@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5582f554-5ae9-4cb9-d8e9-f1ff57fca35c@redhat.com>
Date:   Thu, 26 Mar 2020 01:28:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CwGT4oU_CcpRcDhS992htXdP4rcO6QqkA1CyryUJbE6Ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/20 01:20, Wanpeng Li wrote:
>> There are a few other occurrences of hrtimer_cancel, and all of them
>> probably have a similar issue.  What about adding a cancel_apic_timer
> Other places are a little different, here we just disarm the timer,
> other places we will restart the timer just after the disarm except
> the vCPU reset (fixed in commit 95c065400a1 (KVM: VMX: Stop the
> preemption timer during vCPU reset)), the restart will override
> vmx->hv_deadline_tsc. What do you think? I can do it if introduce
> cancel_apic_timer() is still better.

At least start_apic_timer() would benefit from adding hrtimer_cancel(),
removing it from kvm_set_lapic_tscdeadline_msr and kvm_lapic_reg_write.
 But you're right that it doesn't benefit from a cancel_apic_timer(),
because ultimately they either update the preemption timer or cancel it
in start_sw_timer.  So I'll apply your patch and send a cleanup myself
for start_apic_timer.

Thanks,

Paolo

