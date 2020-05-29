Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC681E79A7
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgE2Jps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:45:48 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52693 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725306AbgE2Jpr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 05:45:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590745546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l8ZW/tH2umVqUL+OWD/jWV7O5by31SggI3SS9euSMFA=;
        b=c4LMUaF1tEFUBQ1azul69AGiEFaX4CxWlHKnjqA2+Xwkc1SnXX1BeBek6A8S69bo5kIegr
        Ibt04e0UYi4a5+tPaskj2SJindUGLQwhXLo6+JjxvqBHCLAlwRALShQY7r4geBNZDVGufL
        tFkHTquPd6Z32pjOVbzHu4XzUY7Kfn0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-nrmbsIq2NZSPkN-VqcNu9g-1; Fri, 29 May 2020 05:45:44 -0400
X-MC-Unique: nrmbsIq2NZSPkN-VqcNu9g-1
Received: by mail-wr1-f70.google.com with SMTP id w4so819387wrl.13
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:45:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l8ZW/tH2umVqUL+OWD/jWV7O5by31SggI3SS9euSMFA=;
        b=l9MBKBRk39kkqHe7PwMwnusC57PgOX7jkB18XJ2IQpJaaK3WUbpsOdDYllHrVYMPeL
         HzIxVGpTTHWtzDDpiXIPE7LpkdZpFTgz4c9ikEoErshsMGz79qpBC22NpfpbHTKSQDN7
         dXr3nRf5KylDVcRJZVZFMlhXwhT+y6PSg1GFTboMw82beKpo5lFKgdxSSyiaTHyzVdaT
         H/njFkyS2cVKGqo2H7ySVQCmFLZrIO8N0fP5AGnO6juLCDotSg+s3tV6TZP65MP6dSHr
         JIsDimtUawCxI1BePjP0eR/EvsAHva4JpbQR0/GNQc6B4xSzEIfdXfzBfa07uKhB4omb
         gM3g==
X-Gm-Message-State: AOAM531YcC0L3uNHDQlN1oeWOc02VtpHlkfntbcXYlSSG9810NX2rFO0
        5FnrWSWSIBG4W23ly6mkZfykSnt8DcqNwEKU2rlUF2ZAASCN/6r2mQ5SDpW6bo56ov2+fmrHvXQ
        qaFg7Fh1mYITu
X-Received: by 2002:a7b:c145:: with SMTP id z5mr8263189wmi.189.1590745543039;
        Fri, 29 May 2020 02:45:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSLpYSqepXvnWMaYv1PmZNSH3rD1k6UFrduUBoD15PDD+SsMRwjjtajGSRiXQQOKN9gTp4wA==
X-Received: by 2002:a7b:c145:: with SMTP id z5mr8263163wmi.189.1590745542760;
        Fri, 29 May 2020 02:45:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b096:1b7:7695:e4f7? ([2001:b07:6468:f312:b096:1b7:7695:e4f7])
        by smtp.gmail.com with ESMTPSA id u4sm10413031wmb.48.2020.05.29.02.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 02:45:42 -0700 (PDT)
Subject: Re: [PATCH] KVM: No need to retry for hva_to_pfn_remapped()
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200416155906.267462-1-peterx@redhat.com>
 <dba4f310-5838-cd78-73c9-3db84f93766a@redhat.com>
 <20200508022514.GU228260@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1d6fc047-6009-db27-81c3-238eba27541e@redhat.com>
Date:   Fri, 29 May 2020 11:45:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200508022514.GU228260@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/20 04:25, Peter Xu wrote:
> Even if "unlocked" is set to true, it
> means that we've got a VM_FAULT_RETRY inside fixup_user_fault(),

I have just reverted it.  Thanks!

Paolo

