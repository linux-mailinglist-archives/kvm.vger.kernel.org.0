Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE8C36854F
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 18:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbhDVQ4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 12:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237917AbhDVQ4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 12:56:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E8FC06138B
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 09:55:47 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so1318431pjj.3
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 09:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n6a5jB5vsbHsHNaYOEmKOrdM81c54DldKWj75CigVaQ=;
        b=CjG6FHmsUDSpGnoGadKDSnlkzv2/jjuV0fuispVRiMf3RBQ8H5atKOj3kVxiyUNJAY
         C3bdxafd0iyjFSFiEZGGEo7fQDYXPDA/mU0z/1F1mM/1/yeJCnpZNb7vz9qHKN327ru4
         jMi/sJYa3DcnmJb6ejURqm9/1MXxl/i/s6wGijsRe0EjdrmCJhHJ98/dIuKDnMBjETZR
         SHuABpIOvHYMd3rQYezi8pOpws3EeDlHv1ADgiNkx5Jv9/R8lsPO06f2Ax4SVCSDgaPT
         DXMlkjNlIhfzi8Tbf768prYzfzYjIr0UmAGOjVSI+WnG7c+D1cnp8dw4a6D/olTbcSZn
         fwWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n6a5jB5vsbHsHNaYOEmKOrdM81c54DldKWj75CigVaQ=;
        b=ZMuV21miEK4O/xlffWSp34ka4QJvic7DVikhs7HM/dGQMGujvCokgjvxEP1GlvwdwE
         Ad1e12OTW6dIQzvVkKCb4MOcESHJ0TpYvMNCE3GtgTqck9PudUjxoDNK5bX7Y01T1vX2
         FKeSSXBMyjhtkUFV4odOGXepkTtPclC4Hi8rN/EXVZ9Ewe8R4TlsBkuiV2WmmL6XIZgr
         uKvNKKI3qXVl2rejHexjUo2DmqBgr0bQYFCS6a9wHbKUxx98JN1YIZt2iXrBnUZKrVyC
         ZMYy3YB8edfh42guNmXaIPP1M8wtb5xw2aMh8f8/JcAvRhzSESy5WKRl08+xZDteezvh
         5Cvw==
X-Gm-Message-State: AOAM530ZT6emI0xTvgUzmkIbv1DkVVixGVnsFdP79ztfeNbABQYRT7oB
        zK80MSX2MrtALiDkYovZvMD6qDIhGhUu7Q==
X-Google-Smtp-Source: ABdhPJz0rv8gCpduJab4WDKbQoF49ie8V+7gtLo01+J9NCXu4kC15THjV7jhMSoCeM20fugpo0NFdw==
X-Received: by 2002:a17:90a:bb85:: with SMTP id v5mr5059337pjr.106.1619110546372;
        Thu, 22 Apr 2021 09:55:46 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h11sm2638815pjs.52.2021.04.22.09.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 09:55:45 -0700 (PDT)
Date:   Thu, 22 Apr 2021 16:55:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v2 2/9] KVM: x86: Check CR3 GPA for validity regardless
 of vCPU mode
Message-ID: <YIGqjoHwG+7rHWyp@google.com>
References: <20210422022128.3464144-1-seanjc@google.com>
 <20210422022128.3464144-3-seanjc@google.com>
 <8716951d-cddb-d5f9-e7e2-b651120a51e7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8716951d-cddb-d5f9-e7e2-b651120a51e7@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021, Paolo Bonzini wrote:
> On 22/04/21 04:21, Sean Christopherson wrote:
> > Check CR3 for an invalid GPA even if the vCPU isn't in long mode.  For
> > bigger emulation flows, notably RSM, the vCPU mode may not be accurate
> > if CR0/CR4 are loaded after CR3.  For MOV CR3 and similar flows, the
> > caller is responsible for truncating the value.
> > 
> > Note, SMRAM.CR3 is read-only, so this is mostly a theoretical bug since
> > KVM will not have stored an illegal CR3 into SMRAM during SMI emulation.
> 
> Well, the guest could have changed it...

That's what I tried to address with "SMRAM.CR3 is read-only".  Both Intel and
AMD state that modifying read-only fields will result in unpredictable behavior,
i.e. KVM going into the weeds would be within spec.  IIRC, there's no real
danger to the host, it'll "just" fail VM-Enter.

SDM:
  Some register images are read-only, and must not be modified (modifying these
  registers will result in unpredictable behavior)

APM:

  Software should not modify offsets specified as read-only or reserved,
  otherwise unpredictable results can occur.
