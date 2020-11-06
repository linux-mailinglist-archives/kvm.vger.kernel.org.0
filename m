Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57102A94F0
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 12:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgKFLAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 06:00:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24612 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726317AbgKFLAq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 06:00:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604660445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZtZT7itrVpNRfBlr3Cazy0HWs7zXJS+GGQb2VbmhUxk=;
        b=TKeVCi6Ia6/6HDDkPD9zWQH7p49GLrICe2IB/Oqi9ugpp3JJyn/WNoOl+/lAwdEM4ge6V6
        BtTwDyJa/C7gXjBbtoSJx31hwLXnPsQhIHIVZdwFErupbTlZEOQng6gvxMv1XsQPcl6B3R
        OqmoCGjZA6kOAmkDe2W0kir/kj7k+lw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-CX5Wwd0WM5mdr-Asgr8q7A-1; Fri, 06 Nov 2020 06:00:44 -0500
X-MC-Unique: CX5Wwd0WM5mdr-Asgr8q7A-1
Received: by mail-wm1-f72.google.com with SMTP id g3so291693wmh.9
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 03:00:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZtZT7itrVpNRfBlr3Cazy0HWs7zXJS+GGQb2VbmhUxk=;
        b=adQdI2BwMXjGefc/yXda8Xp0nuzGjUbIRLZhx9d6SybnxmXV0x9QXlYJ5goA/qqs0T
         4Npw+x0KI43ZP9VO4h/wqVpz7a/NvbkWaV747hDPoM07i0ppR+2bULXECM8iPYTNwMtE
         BI7TTOnDWFZV6mhY3t0xEz+doA+K1KZdi4PPzVJEb7NYwFTfVtLqDDrl9jXjPVMbCFoJ
         UGqdhM+JiphzTP5LEcDKMVReNmawEo0I3PtK6+dqPyir6TfX+ygVjrgRnoD3z+FR4zUm
         dQcy0SGps6Wn+govv/fg663smkSFS38Oj7RTjm8syWhZ50xEbXVxQ6nfJgVACgqtNlUs
         jFxw==
X-Gm-Message-State: AOAM531HJBuIRwQTcbKg4sGCOJhqwZ7nGqxzyqJJbFOF4KR0IqNwQ3pC
        kOigzXVLGBU7XnlzKLBwXAWHJ5PNrnHGfPHNX5hr4N3bipvwC31f5zsJCjjc1l24KvH/90eZzXE
        bZQrDsNSBXfK1
X-Received: by 2002:a1c:b041:: with SMTP id z62mr1861615wme.183.1604660443112;
        Fri, 06 Nov 2020 03:00:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy998yT/dbdVsyfPvdRyx12Gso3/GpsD6DmKxXxQdpz/rRJ9mO5IMFzBixjrV3UiX4aJV0qjg==
X-Received: by 2002:a1c:b041:: with SMTP id z62mr1861590wme.183.1604660442885;
        Fri, 06 Nov 2020 03:00:42 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id l3sm1969557wmf.0.2020.11.06.03.00.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 03:00:42 -0800 (PST)
Subject: Re: [PATCH v13 06/14] KVM: Make dirty ring exclusive to dirty bitmap
 log
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20201001012044.5151-1-peterx@redhat.com>
 <20201001012224.5818-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <26c461bc-b2e3-bc23-fff6-0377b09d325a@redhat.com>
Date:   Fri, 6 Nov 2020 12:00:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201001012224.5818-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/20 03:22, Peter Xu wrote:
>   
> +	/* Dirty ring tracking is exclusive to dirty log tracking */
> +	if (kvm->dirty_ring_size)
> +		return -EINVAL;
> +

ENXIO is slightly more appropriate (especially for debugging, as EINVAL 
suggests that the arguments were wrong and not some external state).

Paolo

