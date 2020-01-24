Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1837147944
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 09:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgAXIWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 03:22:20 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26209 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725821AbgAXIWT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Jan 2020 03:22:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579854138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JkbP5+LvgNJD8LbEa+fzcqZQFolNmASwwPkutJLSYdg=;
        b=EHaaj6LbA+0i6IiSVPTinUeySBOgXYGrn17VliLPjIGNA/j3aX5kboNY+hzzlfIS0SYl3H
        awaza8NGagWwmc9FPeNTI0BoI70yXtol3NhgDgBYYFu3sGI5nQOeR7vePYgSr5/7vyh00H
        wBCDvRyfCXCAUIFyNv0hyKfcT6JbyOA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-RRKQoRAgNIa-ufPsgZtunA-1; Fri, 24 Jan 2020 03:22:17 -0500
X-MC-Unique: RRKQoRAgNIa-ufPsgZtunA-1
Received: by mail-wm1-f72.google.com with SMTP id 18so368655wmp.0
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2020 00:22:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JkbP5+LvgNJD8LbEa+fzcqZQFolNmASwwPkutJLSYdg=;
        b=hU0FyK2EJLpp1hkP9MEt19VVDJehlg81Lj4kNMj5SPTzG929+Te3FtPfAH+eIFeDfw
         l1AR2ky3FbqvCpANRq7CM4vJ/Guvu508i8YRVfbm68BlISUEg3Epsfp9sNXl8N4/Raf0
         kZpHf2M7oDRbrvPrRtXUwXWIUPUUuJiPTZDTbXaELcYNnyQrsJ3p8DLE9s6NhShy3cao
         l98hcgsuee40/iyua93xTBi5rs6Ya4RBmHCcQIewQPr9HlDpT1p6U2G77UrPOyIM1Mux
         L2jxAJMRlzsCB+3pEH0bIpl7S8w7IRp/RWSfi9qyFx5+v8rbXhFE28Ycwnxvph96vhYB
         eIGg==
X-Gm-Message-State: APjAAAXV7RP3g673AmJ+TbOYKlO6xvVhccHIzE+h8h4bEQkuVx38Qg8g
        PBcDjviJIDrm20uXuyaNEmFVlEeihfxguyyMOJDovDGgK24I6AAmAQeATT25+Oiu1uV/Z9cpy2w
        bJAffutfJUYBN
X-Received: by 2002:a5d:6ca1:: with SMTP id a1mr2789746wra.36.1579854135490;
        Fri, 24 Jan 2020 00:22:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqz10DrEvjEBKBDFT9OrSLCpjfy0GI6NWMPczTFepONKfqG3vqBFEl4fBzoVAQY9ySVL6vc6gg==
X-Received: by 2002:a5d:6ca1:: with SMTP id a1mr2789723wra.36.1579854135210;
        Fri, 24 Jan 2020 00:22:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id u16sm5672516wmj.41.2020.01.24.00.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 00:22:14 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: avoid incorrect writes to host
 MSR_IA32_SPEC_CTRL
To:     Xiaoyao Li <xiaoyao.li@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@redhat.com>
References: <1579614487-44583-3-git-send-email-pbonzini@redhat.com>
 <8b960dfe-620b-b649-d377-e5bb1556bb48@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6b725990-f0c2-6577-be7e-44e101e540b5@redhat.com>
Date:   Fri, 24 Jan 2020 09:22:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8b960dfe-620b-b649-d377-e5bb1556bb48@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/01/20 09:00, Xiaoyao Li wrote:
>>
>>   +bool kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
> 
> The return type should be u64.

Ugh... Thanks.

Paolo

