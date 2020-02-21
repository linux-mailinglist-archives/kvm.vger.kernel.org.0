Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2229316855D
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 18:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgBURsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 12:48:03 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30445 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726150AbgBURsD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 12:48:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582307282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RrMvZJoVJBWqnzqNr9KyLlzqZ46CEJlOdAIqg//g6XU=;
        b=dIe+RgCzUCc+j7/6priU5r1awTTJQpfHKW2bI2qO6EjtMl47Qz3hE64Uw/VgBVyGkzxC42
        2zU1dBq0ERQMUFnIFWtvhrgWHJRJfV3GxpUdsIJ1MhKCGjYxobTul+jQSvkfmgaPas+dOm
        /FAGwnA7Pd7J02ViLqFWSUZZGWvZkEY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-M4Jk66hBOlisCtlD-FOgwg-1; Fri, 21 Feb 2020 12:47:56 -0500
X-MC-Unique: M4Jk66hBOlisCtlD-FOgwg-1
Received: by mail-wr1-f72.google.com with SMTP id t3so1317123wrm.23
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 09:47:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RrMvZJoVJBWqnzqNr9KyLlzqZ46CEJlOdAIqg//g6XU=;
        b=eR7yIUKazbQqefXLH+VCSjsCTzfAHW4+O6rkxlTZX1+cDH58cKVpmVFVvT85qM9T9a
         Ip2glGnOX4UMpV5e+66ISZ1HN9FWFzkcyZU+LDi07/stRElmO+da+7CPgXH1KEBGjN7x
         HkMMswEZAzS7XFVLkmdGcnldT9Tb4fhFl5VFAuGvCI/vNAX8/sskVakLoo8tQIdKt6C4
         TQe8twBqP93VIRhEXU7ijrWA+M+EV++0zETBb1+CQC4F5tlc4JOuxzv06qE2FYQB+dFM
         yGO7bNryQft9GJHj0lKNM702Fsg/gwfE422i+wLhll7GknjeccBEekP+9J1KLvm+MWAS
         r86A==
X-Gm-Message-State: APjAAAVB9BJRPNE2/rWVJtfBlUf8OvM0AtMnF59blxIcyLqeBmuBvNcb
        NP8JCfu6UuipaVAuvttoPSYpy7FUSsOcK2fbfU/8v9vz+gV+YGUI+pz4Vx5lotvQBwhtf8oTIap
        arGAd2ggW1fIV
X-Received: by 2002:adf:e68d:: with SMTP id r13mr49225906wrm.349.1582307275646;
        Fri, 21 Feb 2020 09:47:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqzI29TQnMTxhegOPTR5SZPy7HDTeZP8mdmwqeW3b3wvRv6t/VcN7GX1ZnOVCmuZ9M9Iv9A8Vg==
X-Received: by 2002:adf:e68d:: with SMTP id r13mr49225876wrm.349.1582307275388;
        Fri, 21 Feb 2020 09:47:55 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id x6sm4531952wmi.44.2020.02.21.09.47.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 09:47:54 -0800 (PST)
Subject: Re: [PATCH v6 17/22] KVM: Terminate memslot walks via used_slots
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
 <20200218210736.16432-18-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <216d647a-e598-d5d6-e20f-9c44c9ca157f@redhat.com>
Date:   Fri, 21 Feb 2020 18:47:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200218210736.16432-18-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/20 22:07, Sean Christopherson wrote:
>  	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> -	old = *tmp;
> -	tmp = NULL;
> +	if (tmp) {
> +		old = *tmp;
> +		tmp = NULL;
> +	} else {
> +		memset(&old, 0, sizeof(old));
> +		old.id = id;
> +	}
>  

So much for my previous brilliant suggestion. :)

Paolo

