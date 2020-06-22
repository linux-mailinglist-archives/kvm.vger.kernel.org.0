Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AEA2039B0
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 16:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbgFVOhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 10:37:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45576 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729377AbgFVOhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 10:37:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592836630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rhaA+I0JFMBynaEViVLcWDggNAbJpIVf0sPk39R0QYE=;
        b=GSQwoEhs8Q4sbDE3us0RhSKS91aF9N3ibXkaMCD8TxI1xD0pFMu+xNSfkV0QNTLW0JUBMn
        zi0pk7qWGilKHhe46VTxEPQ+exXcFCF19q5UvyOo3r7JjVBAUweNT6YFi7Khlw3ZrgE+39
        UdlNINJwawZZVm16GCpRjtW9YLMWABM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-az20D47rNQa8LaHRoZP1nQ-1; Mon, 22 Jun 2020 10:37:09 -0400
X-MC-Unique: az20D47rNQa8LaHRoZP1nQ-1
Received: by mail-wr1-f70.google.com with SMTP id o25so9039129wro.16
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 07:37:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rhaA+I0JFMBynaEViVLcWDggNAbJpIVf0sPk39R0QYE=;
        b=YHEEDFXu99z0ZYKFTuZ9kD8q3OQ1dvKoEa4yhScXy3huweb+xKhpn4myn2f1KxqqhM
         8ZvlEfMaZIYtXCal46b9EMzeltlYRS/vjxaWcYmime1IdneyvPo6USUPgjuDKssgD3N6
         sPdYo9NXsbpjJop1tv7w1pknov7wGQm9Qa/kkdHzhQVOFFEqU1W3oB4Ep+/UBDgfrsi2
         TENFkDQMF2tRyTfgqDSBYDwmOM+uEmdkvr6UG+lQ5fXmy4LmZjnHml4dMsRHbj1dvB9r
         3D9R6VGCUuQFJwMbRjsHrDSJElTNjsi5OQNzY3ZCtNnhL8f8DjOUM4Reqy12o8bmz+WY
         YoiA==
X-Gm-Message-State: AOAM531efYgX5fmtRb5hgTRCvnxjh2ijRFVQGR8gj3GUwYiBib9Yo0nU
        MSp09JMO/sD5CmAJEd1D3D/2FQrjKArYVV9iBls2f/cX8EZSSNT8E99D4B580qJxAXRTWive1e4
        TY/2uFFxIcat3
X-Received: by 2002:a05:600c:2317:: with SMTP id 23mr19095312wmo.139.1592836627930;
        Mon, 22 Jun 2020 07:37:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztqu1oKbzSSjrl7L3+QyPP72A21fy7XJuosE7miCXFYthUAfyXzD1V8PIxlT2RSA76DOqswg==
X-Received: by 2002:a05:600c:2317:: with SMTP id 23mr19095292wmo.139.1592836627759;
        Mon, 22 Jun 2020 07:37:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id w7sm12908477wmc.32.2020.06.22.07.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 07:37:07 -0700 (PDT)
Subject: Re: [PATCH v3] KVM: LAPIC: Recalculate apic map in batch
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1582684862-10880-1-git-send-email-wanpengli@tencent.com>
 <20200619143626.1b326566@redhat.com>
 <3e025538-297b-74e5-f1b1-2193b614978b@redhat.com>
 <20200622002637.33358827@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cc8b429e-74dd-70f1-8f1c-8893a5485e76@redhat.com>
Date:   Mon, 22 Jun 2020 16:37:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200622002637.33358827@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/20 00:26, Igor Mammedov wrote:
> 
> following sequence looks like a race that can cause lost map update events:
> 
>          cpu1                            cpu2
>                              
>                                 apic_map_dirty = true     
>   ------------------------------------------------------------   
>                                 kvm_recalculate_apic_map:
>                                      pass check
>                                          mutex_lock(&kvm->arch.apic_map_lock);
>                                          if (!kvm->arch.apic_map_dirty)
>                                      and in process of updating map
>   -------------------------------------------------------------
>     other calls to
>        apic_map_dirty = true         might be too late for affected cpu
>   -------------------------------------------------------------
>                                      apic_map_dirty = false
>   -------------------------------------------------------------
>     kvm_recalculate_apic_map:
>     bail out on
>       if (!kvm->arch.apic_map_dirty)

I will post a fix for that.  Thanks for the analysis!

Paolo

