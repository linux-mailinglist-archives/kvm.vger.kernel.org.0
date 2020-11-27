Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3FB2C6BA4
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 19:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgK0Shj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 13:37:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20959 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726014AbgK0Shi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 13:37:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606502257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=edygWYeyP0OpQNUjzo7ma4qdy91dY8qJpxVNwKfGpNU=;
        b=fRej35UA+KgS8E/pH4saV4FLerEhis31dUIquMY4a/ptmd5HkGRjbxGgyVPkqDl/bTFpp8
        dHaF0RSRd/hB/dFsX5wTEBLRbFt3q0882nfaAalU7r5isibCh6u3V29RiSy7xtXaMAB7Cz
        S+4TQ2hev6oakbETXqMnQ2za4gZXVks=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-d_ZrxsRONXW_4ejonf7rpg-1; Fri, 27 Nov 2020 13:37:35 -0500
X-MC-Unique: d_ZrxsRONXW_4ejonf7rpg-1
Received: by mail-wm1-f71.google.com with SMTP id v5so3519730wmj.0
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 10:37:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=edygWYeyP0OpQNUjzo7ma4qdy91dY8qJpxVNwKfGpNU=;
        b=A8F7hZvdSYpiL2smok6Jg8mJijknG62Mjhahs2b7f0lh2ZzS3d+JVSM3btjxNeQ7mm
         Fg6XoUcG3Yqs8g0U1bWrCDDwWw2f1Td4slkFryz+15Jgt7q/EzXMgn81VfC9pAZxrCzk
         yi+yucMMpK8YvHEcexFOc8+WYlEbqO9aZP29QPfGDdVCcRRsJw4GnJxM0kJCpuqJBYp1
         y85JJC/hasFBxOCt2rxFJDT5Z2OhEWz5hm7beI/nRf7B5OmjeyE7mftMqCcszbbsWy1I
         aOef0VG9rq8E4eNxDaaN9PliPJPJs50utIembQrJn33LvxnM5dP+VM/18feMHVCSkpmk
         TVkw==
X-Gm-Message-State: AOAM533711X+sTEawbPPpOWc9MrtF/kA3BCpZY2Lw757oZI3CS4HaUnV
        nkxnvdmPyiIOOXXiTPDUnjzZBa4HQ1/wF15YL1oZGmDywgo7T4HZq1CvG0BPMrPeGL9au70WzVr
        zlbsDbnVvqBmB
X-Received: by 2002:a05:600c:d1:: with SMTP id u17mr10589703wmm.38.1606502254197;
        Fri, 27 Nov 2020 10:37:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQqiDttuPLViVIAjwPDIeJkj0VlLEmbthxPkkPN98uYe4IxrmBQi2nTbmp0kQWfkhqJyJLnA==
X-Received: by 2002:a05:600c:d1:: with SMTP id u17mr10589508wmm.38.1606502251477;
        Fri, 27 Nov 2020 10:37:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e14sm16385683wrm.84.2020.11.27.10.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2020 10:37:30 -0800 (PST)
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com
References: <20201019223557.36491-1-krish.sadhukhan@oracle.com>
 <20201019223557.36491-2-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2 v2] KVM: nSVM: Check reserved values for 'Type' and
 invalid vectors in EVENTINJ
Message-ID: <9e69d384-f4e4-539c-554e-0548450ef181@redhat.com>
Date:   Fri, 27 Nov 2020 19:37:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201019223557.36491-2-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/20 00:35, Krish Sadhukhan wrote:
> +	valid = control->event_inj & SVM_EVTINJ_VALID;
> +	type = control->event_inj & SVM_EVTINJ_TYPE_MASK;
> +	if (valid && ((type == SVM_EVTINJ_TYPE_RESV1) ||
> +	    (type >= SVM_EVTINJ_TYPE_RESV5)))
> +		return false;
> +
> +	vector = control->event_inj & SVM_EVTINJ_VEC_MASK;
> +	if (valid && (type == SVM_EVTINJ_TYPE_EXEPT) &&
> +	    (vector == NMI_VECTOR || (vector > 31 && vector < 256)))
> +		return false;
> +
>   	return true;
>   }
>   
> 

No Pascal-like parentheses; please rebase on top of kvm.git's nested-svm 
branch and resend.

Thanks,

Paolo

