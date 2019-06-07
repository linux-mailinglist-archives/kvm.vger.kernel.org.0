Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 917553893C
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 13:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbfFGLk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 07:40:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37544 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbfFGLk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 07:40:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id v14so1834780wrr.4
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2019 04:40:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vLxKuD8Q9wwUVjVM5QN8V/ttjY8nyaYy6ZwD+eu1hZ0=;
        b=VpCMsKX7aORixPs3s5cfVtO9YXNRA9vaO3Z3bFEn0N3pm2xLmysMtRFUyzt9HFTq/w
         d+k0TxxhGNDGNBna1+rEe3Ch/WpfDrTNooCoVhxV6CExIFGc45a5w1dpRioxAupyK+mA
         x6UCs6dK5zaW9XNAz9/khpDQ6fDSEXgJ+CHKOwfOyE+6KcVZlbv/7U34o29duYF69JX4
         S/4KmjAPbmHZmhrhyluS+5gdg3sdO2AgvaXbxBiD/t4+8f6j7+zdO8P1Y+M9hdk9omNh
         7ubSO9YzFDoA+Ot9v8kzPh5srYwnPJT0DJ6IqQTU1qFt2b50CY8KIVEgTmSaD6AZfrbs
         ro2Q==
X-Gm-Message-State: APjAAAWNbE6bDnPCIbLz9RvDMX/fOs8z/6taO4N2vXUoUIz2x2/kyj8C
        aukFcpi3W4CXKs2YjwFM6Fxa2AJ2JFQ=
X-Google-Smtp-Source: APXvYqwFJ/Pm5S5Cg/UDafeAyEh5tRtl/6NtmopygyjhW2qIOz90TxuXyvQL/4q5jirge5bzmahh4w==
X-Received: by 2002:adf:ee49:: with SMTP id w9mr10356463wro.112.1559907657490;
        Fri, 07 Jun 2019 04:40:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d43d:6da3:9364:a775? ([2001:b07:6468:f312:d43d:6da3:9364:a775])
        by smtp.gmail.com with ESMTPSA id z17sm1520128wru.21.2019.06.07.04.40.56
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 04:40:56 -0700 (PDT)
Subject: Re: [PATCH 5/5] KVM: VMX: Handle NMIs, #MCs and async #PFs in common
 irqs-disabled fn
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
References: <20190420055059.16816-1-sean.j.christopherson@intel.com>
 <20190420055059.16816-6-sean.j.christopherson@intel.com>
 <746c7e2c-176f-d772-e37d-41bb9f524dd6@redhat.com>
 <20190606151420.GB23169@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5fa8dd02-e801-9ebc-95d6-e343eeb2595a@redhat.com>
Date:   Fri, 7 Jun 2019 13:40:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190606151420.GB23169@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/06/19 17:14, Sean Christopherson wrote:
> The code disagrees, e.g.
> 
>   /*
>    * Are we running in atomic context?  WARNING: this macro cannot
>    * always detect atomic context; in particular, it cannot know about
>    * held spinlocks in non-preemptible kernels.  Thus it should not be
>    * used in the general case to determine whether sleeping is possible.
>    * Do not use in_atomic() in driver code.
>    */
>   #define in_atomic()	(preempt_count() != 0)

You're totally right.  "_irqoff" seems to be the common suffix for
irq-disabled functions.

Paolo
