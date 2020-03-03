Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE95177A50
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 16:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgCCPW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 10:22:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43111 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727070AbgCCPW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 10:22:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583248975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D6hhj4RvcDIVxgBY1G9BhKvJtpYMpqc/o5vlGdiOVd4=;
        b=MGJKhkkuGK2FJcjXGg1tDNJ6iexTSmqIcZI6ys9R2H1QncnTMxwffGc8d17ucm1uBSqD3C
        bSGCWjbyrZPm4AmR8PQCEnukBdl1KiOJ6PE1B3U+LYA4frSpnJBhuIlqqF1Y2cAkGxe7su
        Ve/ZUxcUgcXB72SdatH2oURDlKMlHfs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-OIajYlXsO2yJslHMETMJCQ-1; Tue, 03 Mar 2020 10:22:54 -0500
X-MC-Unique: OIajYlXsO2yJslHMETMJCQ-1
Received: by mail-wm1-f71.google.com with SMTP id w3so789150wmg.4
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 07:22:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D6hhj4RvcDIVxgBY1G9BhKvJtpYMpqc/o5vlGdiOVd4=;
        b=ND/kiv4dUbh9ZcTaVpHXlb4t/u70mAet/anKSB41ZmAJo+7MxAJnWpGcEKZgXRRq2r
         pp2BZ4yYf1I4zYPrpiIZC5E/i4t+6uw+bafIMqZny3204zsjr4XGk+WzcuuFBOWNMDSU
         BcpVnjtQ3lKd+6UsilkSsPbOJiXmH3DwbRfuo6kzWoJMNLrqfDbjSzp1swOLliTKznhc
         CNGrxB7KySjULsnyfDtuTTkxS3J0pn5K5rwm+JQycnFuVCnDp9kApXAPc5/5p3+9H3ce
         ms5lZP8vg1vO4fkHYnHItmnuS4zLOhzXVZVYzGOGvcGeSaPqFsA9+GEBjg5W7YPDES/G
         MaIw==
X-Gm-Message-State: ANhLgQ0JSPUXDJnov8x9eJ7zkOlredDr1fA/EtuRNrtRIjOM9oEyvE0Q
        ykxvhyQPAwa13iaU7gGdPnL8pkXT6QAwd/bBYBNbpNKX+wN7idoKHz0kBwef3jXkunY0ZZ71gDh
        xIp+EzXGSQtOr
X-Received: by 2002:a1c:9816:: with SMTP id a22mr5188130wme.16.1583248970834;
        Tue, 03 Mar 2020 07:22:50 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuTNzqhBy0I3FEAXGnUvMoxzAdxqzcJ4L5n+wIvurTlnl7KUwZjhKeCzWa1Ppb76Rb7y4PDpg==
X-Received: by 2002:a1c:9816:: with SMTP id a22mr5188100wme.16.1583248970533;
        Tue, 03 Mar 2020 07:22:50 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id c14sm18893149wro.36.2020.03.03.07.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 07:22:49 -0800 (PST)
Subject: Re: [PATCH v2 50/66] KVM: x86: Override host CPUID results with
 kvm_cpu_caps
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <20200302235709.27467-51-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ec995c8-5fc4-eb6c-716b-3f18a05c3f77@redhat.com>
Date:   Tue, 3 Mar 2020 16:22:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302235709.27467-51-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 00:56, Sean Christopherson wrote:
> Override CPUID entries with kvm_cpu_caps during KVM_GET_SUPPORTED_CPUID
> instead of masking the host CPUID result, which is redundant now that
> the host CPUID is incorporated into kvm_cpu_caps at runtime.
> 
> No functional change intended.
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

The UMIP adjustment is now redundant in vmx_set_supported_cpuid, it's
done in the next patch but it makes more sense to remove it here (so the
next patch only moves code from set_supported_cpuid to set_cpu_caps).

Paolo

