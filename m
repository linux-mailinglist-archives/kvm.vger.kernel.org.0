Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDFBA16849A
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 18:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgBURON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 12:14:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29835 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727291AbgBUROL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 12:14:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582305249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=43kfDTCiVzkWMTtQLFuPZFiW+eHoPSitQf9eB3dJ7to=;
        b=aoJa/1uN9ko6vyM6eYnGoIbdV+ccQWJwoayJvakEilQxSj9OQlc/2Q6u6iyArape/XepSo
        Vfhp4Jicg6VfDQ0BCF92AJdw5/5KCFcgo0Rq2i4PNCrkWlwLxb07BIWqv7wXDTpXdp0wtk
        bvNL0IlGpgOHx7Re2OC2THYcL9oWdXM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-oEkkDUYWML-o1CwGibdKIw-1; Fri, 21 Feb 2020 12:14:08 -0500
X-MC-Unique: oEkkDUYWML-o1CwGibdKIw-1
Received: by mail-wr1-f72.google.com with SMTP id 50so1309624wrc.2
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 09:14:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=43kfDTCiVzkWMTtQLFuPZFiW+eHoPSitQf9eB3dJ7to=;
        b=TCwr0emy+twd0zx2Jkgd0VRfgjt2qqgEa5vINbPRA0jSyR+r+0FBrV4ZGUyOHcVwqs
         /gw9GWVbmRau3LgBab9tDnvszbnjC67d3tIQ10hkA+qfbHq6hxrqObhpO5Lgv21o1wpi
         IWuC1KwsREplfmJl9oeV+A3FKrz6wcf+4X+j9ydDBqQTVOBpeg+A52Gfz7jOWb/VaDb4
         thqtdm8oL5G7wBVBPB+tPz3ZXaW4A8pwMoXxkWLO/i4Z4G8nayZwX1ogCfoULtda352d
         8beM3+T2Vxckfg04zVyYpvgQXa743F72LxmkvVx/tlGMX4OQclH64ecReeb5uJ+mHMyd
         0hlQ==
X-Gm-Message-State: APjAAAUzSSYN/ZCsjU8LTWS8CTLIhxq0dOTRPab8zVVqZYYsxU9TIXa9
        1ib7z62dKfsS4sExh7isPZUBol0zHq0B96T90RRG1MlvtAdaOXsix+HtJSP5eirK/c8GZhRbfea
        +yHxAmXXdAOLe
X-Received: by 2002:a05:600c:21c5:: with SMTP id x5mr5050277wmj.72.1582305246964;
        Fri, 21 Feb 2020 09:14:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqzqrTrGHNJy+4GBDeTRch/681B16eH9c4fXOpHFasnECSyy6jW57hTfGuNbgVq4rg8sjDeKQw==
X-Received: by 2002:a05:600c:21c5:: with SMTP id x5mr5050254wmj.72.1582305246694;
        Fri, 21 Feb 2020 09:14:06 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id x6sm4423401wmi.44.2020.02.21.09.14.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 09:14:06 -0800 (PST)
Subject: Re: [PATCH v2 3/3] KVM: x86: Move #PF retry tracking variables into
 emulation context
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200218230310.29410-1-sean.j.christopherson@intel.com>
 <20200218230310.29410-4-sean.j.christopherson@intel.com>
 <40c8d560-1a5d-d592-5682-720980ca3dd9@redhat.com>
 <20200219151644.GB15888@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d5626891-82f6-0a0c-401c-89a901a8455d@redhat.com>
Date:   Fri, 21 Feb 2020 18:14:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200219151644.GB15888@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/02/20 16:16, Sean Christopherson wrote:
> The easy solution to that is to move retry_instruction() into emulate.c.
> That would also allow making x86_page_table_writing_insn() static.  All
> other functions invoked from retry_instruction() are exposed via kvm_host.h.

emulate.c is supposed to invoke no (or almost no) function outside the
ctxt->ops struct.  In particular, retry_instruction() invokes
kvm_mmu_gva_to_gpa_write and kvm_mmu_unprotect_page.

Paolo

