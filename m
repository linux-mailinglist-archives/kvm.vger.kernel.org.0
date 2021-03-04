Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BA832D6E2
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 16:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhCDPmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 10:42:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235146AbhCDPmQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 10:42:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614872450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oEsOz/8T8z2ylZ4ja7cwKljdny+N8pW5D/wcdQijxOA=;
        b=c3vh7NvzRuUejUKVeCaLZje7XxQfsXGO9N8xgWfA2/Xj6lxGRDM9hgOwV6WSAZL74NBs8w
        6zlDW3TCP26VCcx8bh6H2Cj2dvKn9eb8vyIgYSkuVjECqb3dWBH2z0+nXoqGgKQGrnd/99
        WUT2bq6uZZ1uLslApsqNjJQw0kQ4bRA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-2eGkJGCvNgKvRND_EenlNQ-1; Thu, 04 Mar 2021 10:40:48 -0500
X-MC-Unique: 2eGkJGCvNgKvRND_EenlNQ-1
Received: by mail-wr1-f72.google.com with SMTP id m9so8822011wrx.6
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 07:40:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oEsOz/8T8z2ylZ4ja7cwKljdny+N8pW5D/wcdQijxOA=;
        b=WiXyHE0ELqoxtQUZeEwwM52seAW2N6SuG37E/8iCSjWxj/Eu6X20l4CqXwrAis/rma
         HIi+/hW/kn3PJh8O76TsRfEc4pWgwTg4WF57MaNdAU/FyAXDp1GGfxyOOEk6qcU9iSu6
         lNxqauKQ6/geyD1qaKZL4N1G992mJ8KSm6kOcvDCCijdHpKqwQnOCLjS6UM+y66kMe7J
         HA8lcuASIe4l4MDVOMipcKdv8Goqy4w4OLzEh0fWO9670HqKZheyyyI4TvW+sfxgxRm/
         wE+olkUYzRbue3uuGY+CBUzsQOvOqZ3huUe2yL0wlqVZHT3IO8U9EqOUsOpPUfpxxdvh
         zvRg==
X-Gm-Message-State: AOAM531/42+K/GPfbJKC1d/OvLMH3Z3Nt7YUlqfW8RgF7LORhyJCG+4/
        K/6O+KeWNy6jy/ZoJNMBJfnT3aSRYMzwV0Ntm/uB1X69lbKJWCR2QB7wJZfvJhh/iWNFXtowpE8
        42FI6X8WxI5ur
X-Received: by 2002:a7b:c0c3:: with SMTP id s3mr4475375wmh.11.1614872447598;
        Thu, 04 Mar 2021 07:40:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwP0EpyGjhDBDf+Mc0MzjfE82cjiMYcXu9FVzWL7+roDia1wTJrSkAJZpvXM7B/U1zggnOmBg==
X-Received: by 2002:a7b:c0c3:: with SMTP id s3mr4475350wmh.11.1614872447432;
        Thu, 04 Mar 2021 07:40:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 4sm11076508wma.0.2021.03.04.07.40.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 07:40:46 -0800 (PST)
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com
References: <20210303182219.1631042-1-philmd@redhat.com>
 <a84ce2e5-2c4c-9fce-d140-33e4c55c5055@redhat.com>
 <1eda0f3a-1b11-a90e-8502-cf86ef91f77e@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 00/19] accel: Introduce AccelvCPUState opaque
 structure
Message-ID: <438743f3-6e97-1735-6c11-26d261fa91b4@redhat.com>
Date:   Thu, 4 Mar 2021 16:40:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1eda0f3a-1b11-a90e-8502-cf86ef91f77e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/03/21 15:54, Philippe Mathieu-Daudé wrote:
> On 3/4/21 2:56 PM, Paolo Bonzini wrote:
>> On 03/03/21 19:22, Philippe Mathieu-Daudé wrote:
>>> Series is organized as:
>>> - preliminary trivial cleanups
>>> - introduce AccelvCPUState
>>> - move WHPX fields (build-tested)
>>> - move HAX fields (not tested)
>>> - move KVM fields (build-tested)
>>> - move HVF fields (not tested)
>>
>> This approach prevents adding a TCG state.  Have you thought of using a
>> union instead, or even a void pointer?
> 
> Why does it prevent it? We can only have one accelerator per vCPU.

You're right, my misguided assumption was that there can only be one of 
WHPX/HAX/KVM/HVF.  This is true for WHPX/KVM/HVF but HAX can live with 
any of the others.

However this means that AccelvCPUState would have multiple definitions. 
  Did you check that gdb copes well with it?  It's also forbidden by 
C++[1], so another thing to check would be LTO when using the C++ 
compiler for linking.

Paolo

[1] https://en.wikipedia.org/wiki/One_Definition_Rule

> TCG state has to be declared as another AccelvCPUState implementation.
> 
> Am I missing something?
> 
> Preventing building different accelerator-specific code in the same
> unit file is on purpose.
> 
> Regards,
> 
> Phil.
> 

