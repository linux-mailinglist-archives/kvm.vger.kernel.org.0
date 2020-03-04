Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBBF6178F73
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 12:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387851AbgCDLSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 06:18:20 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51386 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387833AbgCDLSU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Mar 2020 06:18:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583320698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tnbYBEfHFy2uHBhpK72x5hzqEk/RbkzKjku1Fg6oRoM=;
        b=SOoAKofWTfS9JkRqHDKMMkmWhaT4vyESh80eMQh7Hkcucbl64gIWCz4jIFbRcJNQqzVm4B
        E4W6qd+fLQumBPK6sOKufMgDpaWuq4YA6F3Sj8jCBOxwp5OSfppDZkz0aO22q3wf/zrPj6
        +HkRK2Vtj99UePA5BklZM/bT2mbGMqQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-NdUVPeMlMuKbdfK8Vdlraw-1; Wed, 04 Mar 2020 06:18:17 -0500
X-MC-Unique: NdUVPeMlMuKbdfK8Vdlraw-1
Received: by mail-wr1-f72.google.com with SMTP id x14so126930wrv.23
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 03:18:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tnbYBEfHFy2uHBhpK72x5hzqEk/RbkzKjku1Fg6oRoM=;
        b=Ul0sKkotQxAVT5inuoFOAhyrlDIKSzMs/UaC+CFoWUm9A1rG7lWEmfEvdRuIf15XBc
         9DY0UF8JYPBMDyzc+OKj/VtWVWrcXEGnWbglejpU7jeJVXH0AzrC9PRnCuKwKmH9OKDm
         pZkEL2wdmmtbMRy45EbSKM9cYI7ptyomWr5dUD6geEGGTX5etj+ojjF5oyfUZwR/S9rU
         suQ3D8FGage2F+0yuDsmrrGeTlC21fn9JuRgOeaQSaAC1Bg1wqXDU7NC3A3bsAqjKih4
         to/eLEcMcb/feY3dOZZ7zOsxgPfaltg9Ec4/KktbFSRycIGJjy4toAHh4Unn4j7TNTl6
         b9xw==
X-Gm-Message-State: ANhLgQ1rjSD6PTBCxeI8N7zgFeQkh5jZt4K2TfcapYpUIYYhbw+FoKoS
        FdxXWDsO7o7lgynn9yktHMXfnCMtLqUnDjPme1KIU+KQsT9qG/FosnJCr2TAES8WJWw0a2uXfbC
        xFuX8QKPUY4GR
X-Received: by 2002:a1c:f214:: with SMTP id s20mr3089669wmc.57.1583320695926;
        Wed, 04 Mar 2020 03:18:15 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuzwSpBrWFCEylCbjzVGJupWHaIFw5613/wH2N8f6ImpbqVP4zei3xmBS7rl8UDQcyeH0dqWA==
X-Received: by 2002:a1c:f214:: with SMTP id s20mr3089656wmc.57.1583320695676;
        Wed, 04 Mar 2020 03:18:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id o26sm3527451wmc.33.2020.03.04.03.18.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 03:18:14 -0800 (PST)
Subject: Re: [PATCH 2/6] KVM: x86: Fix CPUID range check for Centaur and
 Hypervisor ranges
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-3-sean.j.christopherson@intel.com>
 <CALMp9eThBnN3ktAfwhNs7L-O031JDFqjb67OMPooGvmkcdhK4A@mail.gmail.com>
 <CALMp9eR0Mw8iPv_Z43gfCEbErHQ6EXX8oghJJb5Xge+47ZU9yQ@mail.gmail.com>
 <20200303045838.GF27842@linux.intel.com>
 <CALMp9eSYZKUBko4ZViNbasRGJs2bAO2fREHX9maDbLrYj8yDhQ@mail.gmail.com>
 <20200303180122.GO1439@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <41235370-c095-6d8a-2546-be88b3974bfe@redhat.com>
Date:   Wed, 4 Mar 2020 12:18:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303180122.GO1439@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 19:01, Sean Christopherson wrote:
> static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
> {
> 	struct kvm_cpuid_entry2 *max;
> 
> 	if (function >= 0x40000000 && function <= 0x4fffffff)
> 		max = kvm_find_cpuid_entry(vcpu, function & 0xffffff00, 0);
> 	else
> 		max = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
> 	return max && function <= max->eax;
> }

Yes, this is a good idea (except it should be & 0xc0000000 to cover
Centaur).

Paolo

