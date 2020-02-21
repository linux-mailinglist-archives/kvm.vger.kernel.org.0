Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01029167FFF
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 15:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgBUOUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 09:20:31 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54769 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727315AbgBUOU3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 09:20:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582294828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SoBzR7ZqtKjiFmct3fll5NpKOfUjalkqOXKRmpcWspU=;
        b=VZSFSvky/bkERBNFezM0ug9UgZkYMQeDf9QlZ5DViaPLbYJ84W062qVSHssTTRBziDc+Ew
        skUjF4fR4WPz4WRhJ5nfbMn9yKhHRY0MA0Wv8rV++BzzhtYbuskbOChZWPg/Oel//SC8Ox
        /F22Bd1u2+4Hsr/KbOHhJ5qewpPG1yg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-OZQpSkDCNvuWB1liPzoNtg-1; Fri, 21 Feb 2020 09:20:26 -0500
X-MC-Unique: OZQpSkDCNvuWB1liPzoNtg-1
Received: by mail-wm1-f70.google.com with SMTP id b205so677666wmh.2
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 06:20:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SoBzR7ZqtKjiFmct3fll5NpKOfUjalkqOXKRmpcWspU=;
        b=lwfDJa+WMBcyoHMYgDRuFj4KstAKHQ9eTi3w3HevM70lsMm6mlJ1CJvxEgarSrI5bi
         i5sBHYO6hax5H5oRVc34nLj0uDtTOoS39VZq5G/xdv5AD0hxNhEfIE7nCJYR48SH+ayf
         2m3sjfAAhmlmzsNIR/VMGOE8U+4zZ8elg5U4AqtyAxMg02CVoWdBzbr6Wr7MJleyBGzO
         jR6eo67E4CMYibDKbmIJLR0sjMowVMzvk0I0QqZhl6+VyDS4VztDrm7zR+X+CB+P3yjg
         rqoCllnqJ6ba2jFlWRVqWzLf2HAOOgGrj8edjUTh8VUAexhv5Is92JmU8k08gnGM0KbD
         ecpA==
X-Gm-Message-State: APjAAAVRjngxNFTNwxgxZ/g26xKvN8haF99FuQdMgKQwz4oL+crk6lwK
        OSYuTW+6YNjSnkcFmeCIB/6RJiXuNhowprjnf7jAILhyE/r1wEIZgPtkN670EYhUpSJnSpSLrMw
        xGR0RyDWzYmWl
X-Received: by 2002:adf:e68d:: with SMTP id r13mr48476865wrm.349.1582294825409;
        Fri, 21 Feb 2020 06:20:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqyeALhvpOT47CPYypy+gYe7rOAhcLd8Q3GisyBu9lp+EJJr+DkWBh6I7CXgvgL3PbKUdTP0tg==
X-Received: by 2002:adf:e68d:: with SMTP id r13mr48476740wrm.349.1582294823532;
        Fri, 21 Feb 2020 06:20:23 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id n3sm4158922wmc.27.2020.02.21.06.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 06:20:22 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/61] KVM: x86: Clean up CPUID 0x7 sub-leaf loop
In-Reply-To: <20200201185218.24473-11-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-11-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 15:20:21 +0100
Message-ID: <87ftf4rpi2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Refactor the sub-leaf loop for CPUID 0x7 to move the main leaf out of
> said loop.  The emitted code savings is basically a mirage, as the
> handling of the main leaf can easily be split to its own helper to avoid
> code bloat.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 6e1685a16cca..b626893a11d5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -573,16 +573,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  	case 7: {
>  		int i;
>  
> -		for (i = 0; ; ) {
> +		do_cpuid_7_mask(entry, 0);
> +
> +		for (i = 1; i <= entry->eax; i++) {
> +			if (*nent >= maxnent)
> +				goto out;
> +
> +			do_host_cpuid(&entry[i], function, i);
> +			++*nent;
> +
>  			do_cpuid_7_mask(&entry[i], i);
> -			if (i == entry->eax)
> -				break;
> -			if (*nent >= maxnent)
> -				goto out;
> -
> -			++i;
> -			do_host_cpuid(&entry[i], function, i);
> -			++*nent;
>  		}
>  		break;
>  	}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

