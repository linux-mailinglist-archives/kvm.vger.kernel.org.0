Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495FA1B5868
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgDWJlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:41:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47748 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726346AbgDWJlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 05:41:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587634877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=azl4EOKrk5ieu/X3rC1ejOH/OCp4GqTP+vS6TG0Ikm0=;
        b=EKGNSNHzdn910QtysBG+jUTJj05EHFgXatnTcLIXVUkIejJtchvoxUv92jGSUH6PPVfh+W
        ifSrncinOyDXQcf6af6evlaUIPmCedIMrq8rwZQJY4JI+/XMCJu8p103Dh1Fi0cCe41lkb
        rJeO48qJ8zx51IDuOQ8WA4dlsoa8jFk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-Pl7O-Ih4NXS6-qZ74DDWLA-1; Thu, 23 Apr 2020 05:41:15 -0400
X-MC-Unique: Pl7O-Ih4NXS6-qZ74DDWLA-1
Received: by mail-wr1-f70.google.com with SMTP id m5so2572318wru.15
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 02:41:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=azl4EOKrk5ieu/X3rC1ejOH/OCp4GqTP+vS6TG0Ikm0=;
        b=XxHna+uccxiTMSZk7K/pB31uYXJLCdlJ3t9DqMLX5/Rc7aoS3+wpVDmNdnP4wY4bMd
         Pi7EoUyBWavHFllMsokBZJSTNsblOmJ4TilECTxMR74zExOEnnujX0Y6s2Fb9ntqqEzg
         DAHPKAyVDsk00wvMi7QSzL5d6/Ohraupw5gX6LeIGACmNZ3E8sfJMnj/4mxZ/ziGrRHy
         sSF5TWHpvXPv9J9D4jA3RoIUrnVXGZyOj0UeSf9N2hcPZuwMGNbag7cRCAD3NPnQ12xz
         2L9uEtq4bTChywQk3fueuIIREsjV2PpnElkpHt0JnFg5nCk5uXec38wphcAqOHifMm77
         5LRg==
X-Gm-Message-State: AGi0PuYQWYCE0FfZYxfCUhnJAc/XMtrttoDmaslApVw16304AMZwcowe
        m8Bp9Q452DLxiiXiz3ukEoifvTkfvIpBP6pFrTtru7dlJaZH6Qj6Ckqc4jnGTQye6N8kdS6Tl5K
        ug7nee/zFvL14
X-Received: by 2002:a5d:4645:: with SMTP id j5mr3833207wrs.282.1587634873997;
        Thu, 23 Apr 2020 02:41:13 -0700 (PDT)
X-Google-Smtp-Source: APiQypKmS21JtTUsn1ahG9txOKjxAk/HDnRTv0ERS+dV5m610jdf8hdz/jbKFEmKVINrb0EQb/vgsA==
X-Received: by 2002:a5d:4645:: with SMTP id j5mr3833184wrs.282.1587634873822;
        Thu, 23 Apr 2020 02:41:13 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id h188sm3135576wme.8.2020.04.23.02.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 02:41:13 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] KVM: LAPIC: Introduce interrupt delivery fastpath
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
References: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
 <1587632507-18997-2-git-send-email-wanpengli@tencent.com>
 <09cba36c-61d8-e660-295d-af54ceb36036@redhat.com>
 <CANRm+Cybksev1jJK7Fuog43G9zBCqmtLTYGvqAdCwpw3f6z0yA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8a29181c-c6bb-fe36-51ac-49d764819393@redhat.com>
Date:   Thu, 23 Apr 2020 11:39:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cybksev1jJK7Fuog43G9zBCqmtLTYGvqAdCwpw3f6z0yA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 11:35, Wanpeng Li wrote:
>> Ok, got it now.  The problem is that deliver_posted_interrupt goes through
>>
>>         if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
>>                 kvm_vcpu_kick(vcpu);
>>
>> Would it help to make the above
>>
>>         if (vcpu != kvm_get_running_vcpu() &&
>>             !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
>>                 kvm_vcpu_kick(vcpu);
>>
>> ?  If that is enough for the APICv case, it's good enough.
> We will not exit from vmx_vcpu_run to vcpu_enter_guest, so it will not
> help, right?

Oh indeed---the call to sync_pir_to_irr is in vcpu_enter_guest.  You can
add it to patch 3 right before "goto cont_run", since AMD does not need it.

Paolo

