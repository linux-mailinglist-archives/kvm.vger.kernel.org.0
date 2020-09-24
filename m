Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDF727738E
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 16:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgIXOGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 10:06:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20885 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728064AbgIXOGk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 10:06:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600956399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WITCXHzAwksVt5Yjl1chINGWSfzTuBNvZDW5n9bgc5c=;
        b=aOynq9XUp7hDHjXc4ugUwCpLrr0ecd9XP6+CNlao3VGVxc0nauP6sNWZUVFcrfQScg81I5
        eq5UyXW1RTqOypFQSJre03air55Tfnnxe2FXB1JHmORhkOklFUod0mmevqUkv15vYw9Khs
        /B0jQj26Amy35uaSORk5gE4IJ+ncOiM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-aZbKGl-dNsyIhIfdacSfag-1; Thu, 24 Sep 2020 10:06:35 -0400
X-MC-Unique: aZbKGl-dNsyIhIfdacSfag-1
Received: by mail-wm1-f72.google.com with SMTP id m10so907478wmf.5
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 07:06:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WITCXHzAwksVt5Yjl1chINGWSfzTuBNvZDW5n9bgc5c=;
        b=bxiImLsYtL6351j0SCc0xnhhyXhv6tNoqQmu3xKAkhnvGMG6DM3tm6VJ4pjXa6tZgA
         m119+a7s9YEaVjIYcdJHYPJrOaDQ/NsGjzeZ9FJyFhS8lLID0zfsMRsBE97NZPao8GN3
         BQ3JOqCtl4e02mzBVJvFthOWBIyC1Rhg7b7/mpqmi/m/fIiALT3ZoaiMStRPTFoNtXXj
         edjYEcXfqyX7jX8dkbOgF2B4dEKQphypj36ljpjdG+icAWNwywmJxEsd726nNFoU1IAY
         Js87tGgwTZ9PwtjCb5DfnK/Up6zpaVi6P2ZLqPuqAJDhFx38HvtJBW0CBys7fODIDS/H
         xk3w==
X-Gm-Message-State: AOAM531rIFzODZ0CT/yxRrbRKHsP8nHRH/gFtqgjFBGS41VBNqe226Zg
        qmcMAuQuVX0iXNZhcODTf+QJ395RQOgZ+WDGGGh3BeIsQskSHWr0O1qUdNowCp+Ig5y4q/73vWz
        BjYJj/yHXkUWu
X-Received: by 2002:adf:f6cd:: with SMTP id y13mr5248540wrp.161.1600956394237;
        Thu, 24 Sep 2020 07:06:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeFLtutxlfK0jUKd+nIPQGS+H9/NyYapLhwS0/o3lRPWfvF4hf0K/D4Lm+zt0QfImtD4gXLw==
X-Received: by 2002:adf:f6cd:: with SMTP id y13mr5248511wrp.161.1600956394020;
        Thu, 24 Sep 2020 07:06:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d80e:a78:c27b:93ed? ([2001:b07:6468:f312:d80e:a78:c27b:93ed])
        by smtp.gmail.com with ESMTPSA id a10sm3586835wmb.23.2020.09.24.07.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 07:06:32 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Add a dedicated INVD intercept routine
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <16f36f9a51608758211c54564cd17c8b909372f1.1600892859.git.thomas.lendacky@amd.com>
 <87zh5fcm4f.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <26425c1b-a56d-bb52-109a-ab92eeb2c084@redhat.com>
Date:   Thu, 24 Sep 2020 16:06:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87zh5fcm4f.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/20 15:58, Vitaly Kuznetsov wrote:
> does it sill make sense to intercept INVD when we just skip it? Would it
> rather make sense to disable INVD intercept for SEV guests completely?

If we don't intercept the processor would really invalidate the cache,
that is certainly not what we want.

Paolo

