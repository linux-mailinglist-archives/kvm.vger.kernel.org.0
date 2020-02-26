Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D0516FDD9
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 12:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgBZLf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 06:35:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55810 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727785AbgBZLf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 06:35:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582716958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1z8Vnv+ZSGKmMU3hkE2Z0QKdlZ3TU8dOb0I4zJBvWvE=;
        b=P6aoZy/fZybr3A83bkYucI7wEAa1POYZDg8i5YG7SGHr5o2yAP8SIFywrUWixA9ycVAFnu
        NIXHHCKjb1dwuA/vANab9L0B+OCuOrK25XF7lajwnApDZxQejps+M3mUDfPoLoXHryrFfh
        YZV5g7eQlIA9OWjYGq5/69Vd5dqnDZM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-CX9Wl8CANBO9q-7WVkECGg-1; Wed, 26 Feb 2020 06:35:56 -0500
X-MC-Unique: CX9Wl8CANBO9q-7WVkECGg-1
Received: by mail-wr1-f69.google.com with SMTP id o9so1345230wrw.14
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 03:35:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1z8Vnv+ZSGKmMU3hkE2Z0QKdlZ3TU8dOb0I4zJBvWvE=;
        b=iTIH8I4atGREmIyqZMYA0zyZNdbX3A/+Q3n7gGOVWVU6LRch7eAem63aMaFMIylvQD
         GpAzUMDMMWHm0mi2dbEaYo/b4HN1JOw9HEDy0t4W79st1iMaclJEgSWPN4IMAFDmKKun
         KQaEJxzoGCn+8lUl7wmm1p1FKLBYLeJ14+WrMfORU53SBbw3c6ei7iwYcknqXhM8syWS
         xmBxoKht4fLQtDes+aVf7xKvmXkQBQghYB8azDx9J7fKRgaSVisuUB2ZlFkRhiSu7Tit
         llC8BYve2ysl1WyWjb0GzSD34UsNv1yEgdgDKJHXgpnZB7CZ99Mk6mxOsB7iTq+55uDc
         sDHQ==
X-Gm-Message-State: APjAAAUS2KVCe7Mvmq8X+XQD5RsqDytueuUmJT6fE4ktVpe+k6hpR/nB
        vrSakIpG+mWlCwMSc8jbfAe+Z6tHDy/YhTH4+pX0yIagGHIyIAUzGuSnlncy4vB1WCUt/nquRmQ
        WO1rx6RKQJmQw
X-Received: by 2002:a1c:610a:: with SMTP id v10mr4982381wmb.44.1582716955501;
        Wed, 26 Feb 2020 03:35:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqzBgaEfEsjp6JTaDjZIQy0AvKC++lUWandMWYKVxP0enkxb4qDBtTT08vOTi53OgQm1W9G99Q==
X-Received: by 2002:a1c:610a:: with SMTP id v10mr4982359wmb.44.1582716955261;
        Wed, 26 Feb 2020 03:35:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f? ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
        by smtp.gmail.com with ESMTPSA id e8sm2888683wrr.69.2020.02.26.03.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 03:35:54 -0800 (PST)
Subject: Re: [PATCH 43/61] KVM: x86: Use KVM cpu caps to mark CR4.LA57 as
 not-reserved
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-44-sean.j.christopherson@intel.com>
 <8736azocyp.fsf@vitty.brq.redhat.com>
 <66467dd7-09f0-7975-5c4e-c0404d779d8d@redhat.com>
 <20200225212242.GJ9245@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a214484a-f946-aab9-e503-fcd2cc4dbc0f@redhat.com>
Date:   Wed, 26 Feb 2020 12:35:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200225212242.GJ9245@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/02/20 22:22, Sean Christopherson wrote:
>>> I know this works (and I even checked C99 to make sure that it works not
>>> by accident) but I have to admit that explicit '!!' conversion to bool
>>> always makes me feel safer :-)
>> Same here, I don't really like the automagic bool behavior...
> Sounds like I need to add '!!'?
> 

Either that or "!= 0", as you prefer.

Paolo

