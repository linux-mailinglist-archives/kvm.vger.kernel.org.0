Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E07E16848E
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 18:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgBURMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 12:12:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22133 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725957AbgBURMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 12:12:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582305156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3L1ZoX/TxjkXS/fwqsg0irgxYEbxhFv9zJWuTR+8M4=;
        b=IAmyAQynDj01UY6WenRa4vmz0SBGmrwl9eUhEeDes1GV+f+tXDI0JBOq2MrMTTLpQRilA/
        ExcE1/lFHtwgHsBo3N5Xy3jhhVSgFb/XGoHzGCJhh7s51MjQ6aZdyxHKNjos90iUti2mSN
        cqT6gZzf13ss9ghXhvzxleL+I4ANlNI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-maAn_s6_Mh-M77TPa6ui0A-1; Fri, 21 Feb 2020 12:12:34 -0500
X-MC-Unique: maAn_s6_Mh-M77TPa6ui0A-1
Received: by mail-wr1-f71.google.com with SMTP id t3so1275748wrm.23
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 09:12:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g3L1ZoX/TxjkXS/fwqsg0irgxYEbxhFv9zJWuTR+8M4=;
        b=QfTqWSWxJ6RJcN/K4OR5PGaE3ww9v2xmsyqUViv6ScgypNRWiFmepNdhXzzuq/sXVu
         RV+b72ekY8t9bbVo6khCU6EHuiZ2SvsszjLnmOP3dMWILeq1+xOoFt1n7GboaB9Mqgta
         K4Z0WYCRuyvA6YqqwUTb2+jmCX20Hfyrli0QgphThBaQVTQ82bIaVp8zqZ+QnQxmXXto
         95l2Ks3//muWiyxy2AugliV48gZM7vlq6ueWU/dIjmQ7U1pFxqARlKcQtZ60H2irWNVa
         1Y8tHzHmCLbzGMZYzDbVxzmZ35SJnzmephJ1D+pq/cZzj3xBVhQ58FYBhgZqJdhD4KwP
         4d2g==
X-Gm-Message-State: APjAAAUCquaPLrVJJiGGp0ECSIkqgfuWeBwr2ahQ1bbV5DtstEce/OcF
        A7H3i6X1Fy1R1GyKHoY6fw0m5FnsnGNxxSiqbCkoE4QqZMWwQsyyYsbULq4RNcUeEIDb+hIJ8Gs
        5ezg/hj1jxney
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr48865561wrp.167.1582305153493;
        Fri, 21 Feb 2020 09:12:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqxzWyB6s7IwAppJnceUdyTwctOskCid+p4JUdfGldG0cym2Ms87VdXP5N1NlYKfWlZBVYTZFA==
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr48865545wrp.167.1582305153286;
        Fri, 21 Feb 2020 09:12:33 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id g15sm4814994wro.65.2020.02.21.09.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 09:12:32 -0800 (PST)
Subject: Re: [PATCH v2 1/3] KVM: x86: Add EMULTYPE_PF when emulation is
 triggered by a page fault
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200218230310.29410-1-sean.j.christopherson@intel.com>
 <20200218230310.29410-2-sean.j.christopherson@intel.com>
 <7d564331-9a77-d59a-73d3-a7452fd7b15f@intel.com>
 <20200220201145.GI3972@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b47c043-5fa5-3ae5-6c97-e2532dcff80e@redhat.com>
Date:   Fri, 21 Feb 2020 18:12:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200220201145.GI3972@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/02/20 21:11, Sean Christopherson wrote:
>> How about naming it as EMULTYPE_PF_ALLOW_RETRY and exchanging the bit
>> position with EMULTYPE_PF ?
> Hmm, EMULTYPE_PF_ALLOW_RETRY does sound better.  I'm on the fence regarding
> shuffling the bits.  If I were to shuffle the bits, I'd do a more thorough
> reorder so that the #UD and #PF types are consecutive, e.g.

Let's just change the name, I can do it.

Paolo

