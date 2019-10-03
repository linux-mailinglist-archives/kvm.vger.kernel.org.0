Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFD4C9C60
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 12:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfJCKdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 06:33:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728608AbfJCKdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 06:33:02 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6453D81DE7
        for <kvm@vger.kernel.org>; Thu,  3 Oct 2019 10:33:02 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id i10so910174wrb.20
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 03:33:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TDB02z0QH3vJLwWOjOv1DtoyGTjTT6QfGUMhQzSF13g=;
        b=fMRWw0513+sfIh3HpMH/eH5IES/ePCdTLr6XuEhgAUB8Zqi2pBNPxigPQfHVzIhLpA
         jw9+iMu0fPpGCoofA8DUTC4e+IS+rO1vcDjiV2vXw1ztVmr+LU1Clp4esBeGlICZmSwE
         +jSlbu+JpV4kAkqHRBVPdZGJ5+HE7FPkeqG0Yv5MPFEB4JzGPq8haKXEARr0/tnkhoRg
         ARLglyoKpgCZYALZBcT6fgwwMuXQZj5SU1MtlWYNRP3JG18yiFheaEkyKkKJOZYjApEQ
         uJUiGl5vZKsanYQ7O+EYtPsmFUaVonTaExDm8z/yfCPvcoYeK+NV/Gfv1QxP/jiylPk/
         TzqQ==
X-Gm-Message-State: APjAAAXkK2nWOSv3TI3sbbM18A1K3LZFQJB88L1iz1UU1jZx0SDDwJ0A
        3IVaVZTFeEsKpxvQURQJTuAfTutGGMbKCWpubk51/Ev8aypXLayuShF34naYAbE1sriueVHw9xk
        TbmVC/IKbDgSL
X-Received: by 2002:adf:b60b:: with SMTP id f11mr6182427wre.95.1570098781062;
        Thu, 03 Oct 2019 03:33:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzR73rVAuncaKpVwzdd3+MqciGKk4WU0zynSuyLk788ukn8unkJ2AA2IjoXx3nNxwOcOHxGyw==
X-Received: by 2002:adf:b60b:: with SMTP id f11mr6182413wre.95.1570098780819;
        Thu, 03 Oct 2019 03:33:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b903:6d6f:a447:e464? ([2001:b07:6468:f312:b903:6d6f:a447:e464])
        by smtp.gmail.com with ESMTPSA id w18sm2323706wmc.9.2019.10.03.03.32.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 03:33:00 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Fix consistency check on injected exception
 error code
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nadav Amit <nadav.amit@gmail.com>
References: <20191001162123.26992-1-sean.j.christopherson@intel.com>
 <CALMp9eT+kkdrDhHW4QHaSHQOeXnpcE2Quhd=kOhZq_y6ydjdJA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <78c156df-3fd5-1eeb-c34e-d0a3afa99970@redhat.com>
Date:   Thu, 3 Oct 2019 12:32:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eT+kkdrDhHW4QHaSHQOeXnpcE2Quhd=kOhZq_y6ydjdJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/19 18:28, Jim Mattson wrote:
> Reviewed-by: Jim Mattson <jmattson@google.com>

Queued, thanks.

Paolo
