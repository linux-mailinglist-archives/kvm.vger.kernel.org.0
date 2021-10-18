Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB364324F9
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 19:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbhJRR26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 13:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhJRR25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 13:28:57 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F7AC06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 10:26:46 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s136so13678841pgs.4
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 10:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H26XgAKSyXMi5EsE0IrTEpUxoqQGIi6HhStgdc+Rcd4=;
        b=Jf1dUBBLoXfZ62kg+5xHWRihOgsJ/2RNF3xC4LXWVxs665D5eHdz/MxVyH/WSQZEXV
         QYf1q6MqumZ0307fjCbJdb9BfpgnQ/Ld7FT5Zog6v84Jo+Zx8BMkJWSqgs0smXZJdlbL
         TnBF6mZEhXSbMdjxz/xrbFYTCaYASBnrPjNFqSO0IuQjc/tyDqmJbP1ezJ9zc+vILufB
         sgcttw7o9tDAa6aSLgl9brGTkukAIduj+j1HTxiJZz+Z1Kw+mUMD3Le+kX9x1vsmMiC8
         5IzNmlcXMPIPTMyz1Y/8N8AEW5nW0NigLb1/pbDNRvRsPKo0H0Wzk9YAzf7z1dfyq24C
         zAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H26XgAKSyXMi5EsE0IrTEpUxoqQGIi6HhStgdc+Rcd4=;
        b=EGt0RHsvBG++k0Ykfs+Gjfm1FPZRcs+dYEmya+P7iDqXJ33cS1g/ZfB2FxWbIWY9jt
         Yguh/q/JEh4n95Na+QtUqjt34hv3pT4PoVJ3pEaIxytl8XpZWg63SFxY/li9tLFAh1Qw
         6c49jbKbMP5IwdHl3K9RC+r/mBTqMi9+OiaLlHP1xy9sNDczkSo8eZRJsHu3gZvBUOlY
         mi61YayXcOVrUrxYZrZYzEvKUuSpHqtjWcjlebbEP+hjovBaz00V7eTBOSfgo1cJUItf
         7QdzeCafNLWNN34RwXoro9BbrJsXJ/4xREZ497XReKNprH4NXerSje/M6nJxM/iEbajb
         El3Q==
X-Gm-Message-State: AOAM532EvCBQ+BWZbT4p4UaeKQ2qDTtU5kpoiW+7MnpJYmvsC1Dcvua5
        UMsX0IvEPSBbITrSmHrrAwLEPA==
X-Google-Smtp-Source: ABdhPJwPK5yDwYS69j2DgbI4iGQED39/ST4jIBvqJdcuNtGdSeYu6YlIPxZFHZoXFp0/PUVX6gpYOA==
X-Received: by 2002:a62:8f53:0:b0:44c:5d10:9378 with SMTP id n80-20020a628f53000000b0044c5d109378mr29876734pfd.19.1634578005650;
        Mon, 18 Oct 2021 10:26:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g17sm13608578pfu.22.2021.10.18.10.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 10:26:45 -0700 (PDT)
Date:   Mon, 18 Oct 2021 17:26:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] KVM: VMX: Check Intel PT related CPUID leaves
Message-ID: <YW2uUcor5nhDZ3DS@google.com>
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
 <20210827070249.924633-7-xiaoyao.li@intel.com>
 <YTp/oGmiin19q4sQ@google.com>
 <a7988439-5a4c-3d5a-ea4a-0fad181ad733@intel.com>
 <486f0075-494d-1d84-2d85-1d451496d1f0@redhat.com>
 <157ba65d-bd2a-288a-6091-9427e2809b02@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157ba65d-bd2a-288a-6091-9427e2809b02@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 18, 2021, Xiaoyao Li wrote:
> On 10/18/2021 8:47 PM, Paolo Bonzini wrote:
> > > > One option would be to bump that to the theoretical max of 15,
> > > > which doesn't seem too horrible, especially if pt_desc as a whole
> > > > is allocated on-demand, which it probably should be since it isn't
> > > > exactly tiny (nor ubiquitous)
> > > > 
> > > > A different option would be to let userspace define whatever it
> > > > wants for guest CPUID, and instead cap nr_addr_ranges at
> > > > min(host.cpuid, guest.cpuid, RTIT_ADDR_RANGE).
> > 
> > This is the safest option.
> 
> My concern was that change userspace's input silently is not good.

Technically KVM isn't changing userspace's input, as KVM will still enumerate
CPUID as defined by userspace.  What KVM is doing is refusing to emulate/virtualize
a bogus vCPU model, e.g. by injecting #GP on an MSR access that userspace
incorrectly told the guest was legal.  That is standard operation procedure for
KVM, e.g. there are any number of instructions that will fault if userspace lies
about the vCPU model.

> prefer this, we certainly need to extend the userspace to query what value
> is finally accepted and set by KVM.

That would be __do_cpuid_func()'s responsibility to cap leaf 0x14 output with
RTIT_ADDR_RANGE.  I.e. enumerate the supported ranges in KVM_GET_SUPPORTED_CPUID,
after that it's userspace's responsibility to not mess up.
