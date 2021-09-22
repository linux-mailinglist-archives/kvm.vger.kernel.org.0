Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95163414C53
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbhIVOrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbhIVOrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 10:47:37 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC41C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 07:46:07 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c4so1909297pls.6
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 07:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rCwvv55ksRRBZPVu5dfkaaUj0wQlCK647s+02LK9KDc=;
        b=Ptd33SYY0b9VtKRZaOwNHMFlPoO75TZNibpm48/DsYN0B3BAnVd3tD/BhI9WX1Mg/S
         ILLECWbJQ8SLGhT+FLov0jY/4rHIcu/wKb2D0gu2lBFx8ShWch0ssEqEFMgKJfZ182o+
         M5gYXk+36mZqx3QcLTrI2z2UKDy9vhIQ9ZUiMUOLb2P7lMXrJwlYctMV6pbiNVfDcXoz
         LqjKLhLLeJ2Vf8qG3oNZ375re+6Uvk646I/p/z2d8Fs/aHfFyw84tyqMbpag8zyOiM9M
         03Q+Le2wzYiMOfHKm18zbvjBurHUGWxcjKDpoUZXMflylNDJNgnECJL6M5FRscb9EEnW
         9Hgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rCwvv55ksRRBZPVu5dfkaaUj0wQlCK647s+02LK9KDc=;
        b=huNyjDdS4oZ6YJnKQeNIgLQvhPDdxvfaqe4VDGTYPRDYY9e+ekVu9hC6ISqpjsgo4d
         TEcSgZ4ZDAYT8oEvYQSvK1D3J7s5mZVN+FKEcNMSNdLY8qrMgASOnwLwbSnGDYZElM6v
         AP8EIH5CZ/39i1c6wRoGdqgpZdtBWLUw+cjT2TWwxV0jShQ+O7NQyuANa+9Z+S8G+gsI
         mvZS17bVg8l6Dj0EI0+f7d0qI5wqPDIG6fp2bdmv72YYSOQufr/XCfy3VeG4DwL+RZcd
         wggxjh6ynZUG9qc8dB7+j7+CvYv/iEpaUbYIvJsuC0WiN8Ir6CIQDROitAJwwexnrpTo
         u8zg==
X-Gm-Message-State: AOAM531/aZXWggb2savhCPwAilA9GZi7s7O1pEA4Wut1mSvzX031aiXq
        XVhm5sAF6sf7tI3opEtER1fLjg==
X-Google-Smtp-Source: ABdhPJwU+dyHlhyA/XTKqvfNb2Q4uQkhOvVMY/EtyP7rxZt/Vk5ie7j2lZv72Al+NamQUIEcfeOL/Q==
X-Received: by 2002:a17:90a:307:: with SMTP id 7mr11783832pje.176.1632321966848;
        Wed, 22 Sep 2021 07:46:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e24sm2801631pfn.8.2021.09.22.07.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 07:46:06 -0700 (PDT)
Date:   Wed, 22 Sep 2021 14:46:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v3 0/7] KVM: few more SMM fixes
Message-ID: <YUtBqsiur6uFWh3o@google.com>
References: <20210913140954.165665-1-mlevitsk@redhat.com>
 <22916f0c-2e3a-1fd6-905e-5d647c15c45b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22916f0c-2e3a-1fd6-905e-5d647c15c45b@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021, Paolo Bonzini wrote:
> On 13/09/21 16:09, Maxim Levitsky wrote:
> >    KVM: x86: nVMX: re-evaluate emulation_required on nested VM exit

...
 
> Queued, thanks.  However, I'm keeping patch 1 for 5.16 only.

I'm pretty sure the above patch is wrong, emulation_required can simply be
cleared on emulated VM-Exit.
