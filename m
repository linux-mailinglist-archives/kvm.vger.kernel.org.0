Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2635124B977
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 13:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbgHTKDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 06:03:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20780 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730342AbgHTKBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 06:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597917680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xtUkw1+pgkP1u0CE6ZeSzJD33eQ60AqxVBB24zxNhsI=;
        b=OiDyaWk5d5AhnAHKmBZYkcd6kn0qtiOTFcY4p2fJSK4ANTzpHgrhnb0yi2nRIh9a0g1IZf
        mbLjbdI0fqzfG0ez9+s72f9jvXduR6o+ZN375g2zs7MhItUPgOZ8HmPD1DBlJmkf7xDME7
        WuPsn86VYsNFm27eex3ABcBEeZLX8Ic=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-qqfpza8ROfiQzY0Ohpqz9Q-1; Thu, 20 Aug 2020 06:01:18 -0400
X-MC-Unique: qqfpza8ROfiQzY0Ohpqz9Q-1
Received: by mail-wr1-f72.google.com with SMTP id e14so472253wrr.7
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 03:01:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xtUkw1+pgkP1u0CE6ZeSzJD33eQ60AqxVBB24zxNhsI=;
        b=BvA8SFYWL/Z9GFdYmDMBxcEA8RAY6YCK0RbeGTK2IRcYfL5t9atVky58YQum+lB562
         IZ2w4I3u+vCRrKM655K7I24dPLJ1SQ17246HTu3+jr8pi85ZaeyNkLupselzifmpzdaf
         pWN/rKcqPyv97qUZSXPbxdnFHmUQQ1vcQerUpCpbYwJfPYC4vaNOfj/2qlD3E/Lbk1yl
         PEP8Kk0kWWl07Ac5k11aE7aFYvtuG1VeINOC4anupDeCXs1vTPx0r+ZhQGaB4ITlKqYy
         uj5sX2X+hP6QfKODOEmta+tbuXOhaioCSmKMB6MMHjfsLZgzwmGQng545Kk5W9mDQsaa
         QFqA==
X-Gm-Message-State: AOAM530isvZpZ/SnAgLr4hWaygUBSs+xtZrKtsLja1VwmXtPbyvcCGie
        8TbQQ4BL/MvN0uk6S+mPgDQjsBFZz/kmuSECbRfGVm9e99eVIdWvRl4qFwQ6yBM3UfPBhIpEdEY
        UK4elYMvd/AdU
X-Received: by 2002:a1c:3dc3:: with SMTP id k186mr2687077wma.122.1597917677218;
        Thu, 20 Aug 2020 03:01:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4gKUiUJ6EoQh9xoNdvazNihbXQF/czcITGb1+BqN75JHRCFO/tyWZLCjckhAt6e9saona4Q==
X-Received: by 2002:a1c:3dc3:: with SMTP id k186mr2687048wma.122.1597917676995;
        Thu, 20 Aug 2020 03:01:16 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id n18sm3077185wrp.58.2020.08.20.03.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 03:01:16 -0700 (PDT)
Subject: Re: [PATCH 8/8] KVM: nSVM: read only changed fields of the nested
 guest data area
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
 <20200820091327.197807-9-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <53afbfba-427e-72f5-73a6-faea7606e78e@redhat.com>
Date:   Thu, 20 Aug 2020 12:01:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200820091327.197807-9-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/08/20 11:13, Maxim Levitsky wrote:
> +	u32 clean = nested_vmcb->control.clean;
> +
> +	if (svm->nested.vmcb_gpa != vmcb_gpa) {
> +		svm->nested.vmcb_gpa = vmcb_gpa;
> +		clean = 0;
> +	}

You probably should set clean to 0 also if the guest doesn't have the
VMCBCLEAN feature (so, you first need an extra patch to add the
VMCBCLEAN feature to cpufeatures.h).  It's probably best to cache the
guest vmcbclean in struct vcpu_svm, too.

Paolo

