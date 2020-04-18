Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051DC1AEB82
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 11:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgDRJxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Apr 2020 05:53:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50542 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgDRJxp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 18 Apr 2020 05:53:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587203622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NF4T96bZVrkbevobDslv1Gw0JUdHAt8oZbmGxEFEaSk=;
        b=MPHvMG0Yi14HfLJjhaRZbOmCfSmM+RarJ27nUne+BvFr4Ht6Pzi5v9PMXmlT/f1eFqDYOM
        W+QqD3JHTfVScv3UjWaVoq4rbkH47X48kNey/DyZ2gz5MFLihA1PlTjjhkbh1IGjeW9D3q
        8yavq5k/H/aXByGj+ssQ08wMjRBu4rc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-d71niFouOwmB3UBniZDZ5Q-1; Sat, 18 Apr 2020 05:53:40 -0400
X-MC-Unique: d71niFouOwmB3UBniZDZ5Q-1
Received: by mail-wr1-f71.google.com with SMTP id u4so2425032wrm.13
        for <kvm@vger.kernel.org>; Sat, 18 Apr 2020 02:53:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NF4T96bZVrkbevobDslv1Gw0JUdHAt8oZbmGxEFEaSk=;
        b=QwS+CBu+eOLaoqZn4kiJqFhs/2+P61gtiEYHvczsfpd+gVL8tsKBE6s2+WBuRcutMR
         udMtoXcL1yzg4tfvXTOwz+3gH1OUCGPk4WKEVIXljeGS/3JxZAq/VRpG06ZEB5mYicAv
         MaLxOgDqO8GXyDJlZkzg3sgFmWU7uXcQTuTOnFpL01DnAY5kf6DMN2lCuxYFP+hiPQtr
         DRF5yCpflnhnabpKP+h4eUoGfHo6PGLQLBZQ0sDTV4ohA8k4LdbxQh0jP1Q9LlsbAdLB
         2530ZfxL8M4iYINHsKXjksN8Zbu3tqMGe9ozK3otGlv6QGUFwt6HTfk9voM8NZNDxAh+
         gqMg==
X-Gm-Message-State: AGi0PubDhFEu1kQjbmIeMWVTFswWezDyM/wIxGxs3pXW0mk8juw+oPoZ
        PBL8VXjATP/rsgkS7i8muU/6t4aVvSvOhjticF4cdzVWEXFoSix1K0g8DcN+3r04zjeiJ7v4HEG
        QI3MNe1dBqtHe
X-Received: by 2002:adf:fd0a:: with SMTP id e10mr8148680wrr.160.1587203619633;
        Sat, 18 Apr 2020 02:53:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypIG6yAoKP0zYBeo4/bJ9Z9cXnpFvZSvS2EUS4ggzb4b+ASrv4ykztHncYUKvExHxbuEiZzsHA==
X-Received: by 2002:adf:fd0a:: with SMTP id e10mr8148646wrr.160.1587203619281;
        Sat, 18 Apr 2020 02:53:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e04c:97cb:a127:17b6? ([2001:b07:6468:f312:e04c:97cb:a127:17b6])
        by smtp.gmail.com with ESMTPSA id n124sm11165760wma.11.2020.04.18.02.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 02:53:38 -0700 (PDT)
Subject: Re: [PATCH 1/2 v2] KVM: nVMX: KVM needs to unset "unrestricted guest"
 VM-execution control in vmcs02 if vmcs12 doesn't set it
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
References: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
 <20200415183047.11493-2-krish.sadhukhan@oracle.com>
 <20200415193016.GF30627@linux.intel.com>
 <CALMp9eRvZEzi3Ug0fL=ekMS_Weni6npwW+bXrJZjU8iLrppwEg@mail.gmail.com>
 <0b8bd238-e60f-b392-e793-0d88fb876224@redhat.com>
 <d49ce960-92f9-85eb-4cfb-d533a956223e@oracle.com>
 <20200418015545.GB15609@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c37b9429-0cb8-6514-44a7-65544873dba0@redhat.com>
Date:   Sat, 18 Apr 2020 11:53:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200418015545.GB15609@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/04/20 03:55, Sean Christopherson wrote:
> 
>   static inline bool is_unrestricted_guest(struct kvm_vcpu *vcpu)
>   {
> 	return enable_unrestricted_guest && (!is_guest_mode(vcpu) ||
> 	       to_vmx(vcpu)->nested.unrestricted_guest);
>   }
>
> Putting the flag in loaded_vmcs might be more performant?  My guess is it'd
> be in the noise, at which point I'd rather have it be clear the override is
> only possible/necessary for nested guests.

Even better: you can use secondary_exec_controls_get, which does get the
flag from the loaded_vmcs :) but without actually having to add one.

>> I also see that enable_ept controls the setting of
>> enable_unrestricted_guest. Perhaps both need to be moved to loaded_vmcs ?
>
> No, letting L1 disable EPT in L0 would be pure insanity, and the overall
> paging mode of L2 is already reflected in the MMU.

Absolutely.  Unrestricted guest requires EPT, but EPT is invisible to
the guest.  (Currently EPT requires guest MAXPHYADDR = host MAXPHYADDR,
in the sense that the guest can detect that the host is lying about
MAXPHYADDR; but that is really a bug that I hope will be fixed in 5.8,
relaxing the requirement to guest MAXPHYADDR <= host PHYADDR).

Paolo

> The dependency on EPT is that VMX requires paging of some form and
> unrestricted guest allows entering non-root with CR0.PG=0, i.e. requires EPT
> be enabled.

