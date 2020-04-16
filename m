Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D191ABCAB
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 11:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440174AbgDPJTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 05:19:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32107 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2392129AbgDPJTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 05:19:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587028740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3UAzo5xnlnsk6DxsjAuNLPe6hkLDWjM29CuriEr8TxM=;
        b=GgsIIWwn5GUZzy9z6d+Lx7yNaNeDleIOwU5uiThjw8pthsNjyBY52L1uVANQg5oXCXyJnZ
        pe+I7ssZmdyjY4BQZBZWVOna7cS2nNz0G4PM/JLIYdfEOJTPHqDgw2jB/AobyP6ASq8jEV
        d1DCejxlZD+QIXij4Lt7SFvFzGPzE78=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-YwbvOtKLPtSWrds54_KMkA-1; Thu, 16 Apr 2020 05:18:59 -0400
X-MC-Unique: YwbvOtKLPtSWrds54_KMkA-1
Received: by mail-wr1-f69.google.com with SMTP id p16so1391112wro.16
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 02:18:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3UAzo5xnlnsk6DxsjAuNLPe6hkLDWjM29CuriEr8TxM=;
        b=oF/weFJVPFUt3Rh+P5xF0xOVE4oy4Xkt1PTgEmIAAvPSjZ3eLflovG3PT9IpWLQaPQ
         dqbs7nrC6/eEwo/T4wKInToxQXgNW2dI5l/zkgYHNyyuicvqqS2u8nfD/Mgo+A8avhDQ
         VJnZsnmLRJGgJQpLE1PAspObJbdn2cJq2lyP7pzNlLeIPmGM8omYaYMXPv3KbNJmgZiz
         7roIFxQ8WOVTuQasMJz5y9XQvJGY2Vf1M8h5Lj+NnTLKoNgk3IeF9w5vDrEKFmKFIKf/
         Mx/8YIlcgSKxzkj74h30Jq6oIKJVRjOfgHvBxUnKkfQoF5URQflDFBQ2OptnJXOExuKG
         3BXg==
X-Gm-Message-State: AGi0PuakzFR0n+H7wBiAllC1R8L4yqIuVrZHTtlajsXOFXjZsbrhq2GJ
        8/pPCygar8efty0LWPjPsEGgqrrImFGh1hIPxCnsof5XTR8JVpih0STR51RDstCcWElRmut3Ta/
        wT2ae+7y7qFRo
X-Received: by 2002:a7b:ce89:: with SMTP id q9mr4064110wmj.185.1587028737978;
        Thu, 16 Apr 2020 02:18:57 -0700 (PDT)
X-Google-Smtp-Source: APiQypIR7cq4Cm2xEbsMV0hmO9J2nFWh0TGC7aQmaeO8Hr5HV65EJtjAjDDgoXPF/yvpV+luAHpdew==
X-Received: by 2002:a7b:ce89:: with SMTP id q9mr4064089wmj.185.1587028737767;
        Thu, 16 Apr 2020 02:18:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:59f3:e385:f957:c478? ([2001:b07:6468:f312:59f3:e385:f957:c478])
        by smtp.gmail.com with ESMTPSA id s14sm2803325wmh.18.2020.04.16.02.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 02:18:57 -0700 (PDT)
Subject: Re: [PATCH 1/2 v2] KVM: nVMX: KVM needs to unset "unrestricted guest"
 VM-execution control in vmcs02 if vmcs12 doesn't set it
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>
References: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
 <20200415183047.11493-2-krish.sadhukhan@oracle.com>
 <20200415193016.GF30627@linux.intel.com>
 <CALMp9eRvZEzi3Ug0fL=ekMS_Weni6npwW+bXrJZjU8iLrppwEg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b8bd238-e60f-b392-e793-0d88fb876224@redhat.com>
Date:   Thu, 16 Apr 2020 11:18:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRvZEzi3Ug0fL=ekMS_Weni6npwW+bXrJZjU8iLrppwEg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/20 22:18, Jim Mattson wrote:
>> Has anyone worked through all the flows to verify this won't break any
>> assumptions with respect to enable_unrestricted_guest?  I would be
>> (pleasantly) surprised if this was sufficient to run L2 without
>> unrestricted guest when it's enabled for L1, e.g. vmx_set_cr0() looks
>> suspect.
> 
> I think you're right to be concerned.

Thirded, but it shouldn't be too hard.  Basically,
enable_unrestricted_guest must be moved into loaded_vmcs for this to
work.  It may be more work to write the test cases for L2 real mode <->
protected mode switch, which do not entirely fit into the vmx_tests.c
framework (but with the v2 tests it should not be hard to adapt).

Paolo

