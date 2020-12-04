Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232FD2CE492
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 01:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgLDAon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 19:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbgLDAon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 19:44:43 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AC0C061A4F
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 16:44:02 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id q3so2479961pgr.3
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 16:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ejOgKHN/Sl3crinl9ntSzDKpfnMB4G3TBu+kVPlrjjw=;
        b=QJiI7uR5JDxoSt0lYJ3s7jVgo8zSoJjr3do6xxDiKOkChOXA4y8vPVAISzLR8YmdGC
         h0e9Y4TSf4WHrsy7q+v7LGN1rfOK/jZKLzN6La0/1SRxEoF1eQPo2CnRpbD7byS73sjL
         pGu+On1Qy44cEbTInQ0i4t7KnrcvSqBMZYKsTSw3HoS0QNiZ9FoYVY0BgSaVKxsA4i7O
         0mzKj2pKv40kvlmmS9s85BfFMRyrBQTtDRAUFRhIlvwOBzINp+0x1dqP5pUiOoL4ZNUO
         b7xJiYoeIBYuIl2mntAtgjbQ59XIj+fpxounhLu9ATu5AnreqL3cHmziVmZV/L6t7GxY
         kY7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ejOgKHN/Sl3crinl9ntSzDKpfnMB4G3TBu+kVPlrjjw=;
        b=FhGLDPMagUKA5f6KCi/DkCAIjXqBt6ynUI+9Z+nNQqiwytRCYeSu5UoSKCoKXXxshe
         oCrY0KFUSZWYWGHfxwlZhYbZYHXT2N3kagyeApfQh4GFp1asZfos98jFzN7KVkbTaW2c
         lHHpWlffbUTKr5I0cwku1atXe+XQvAtEf4t9vXXBd/amkBdrXZRrjzdMmbgkvRVVsKnG
         ULw0STEZLLYiquGK60IbMahhW4czoj2bXo9K7k8wRzoE2dvq/PU1NJ6/KED2X6UU+drf
         RX/suAjKgfHkNTI7hTKcftgYciioqdqMgcDSia+UfHgS6t7806IChaxJ/qgTGMxiTCGl
         qRMA==
X-Gm-Message-State: AOAM532wVElf5eFMSDuHEjg9nQxTRy/hEIO/52ufLbHwjNjvv4FfDjEY
        vXyrz/CZxjMVw6G5n4WU22TxpA==
X-Google-Smtp-Source: ABdhPJzF9EgmRsavz4O9KQJyjUbJOHXJRvHrK6O6+i/J2FXNIRcI4hw9Bcm1RofXW/I5lYtxUFwkpw==
X-Received: by 2002:a63:cc4c:: with SMTP id q12mr5286511pgi.361.1607042642185;
        Thu, 03 Dec 2020 16:44:02 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id g6sm399130pjd.3.2020.12.03.16.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 16:44:01 -0800 (PST)
Date:   Thu, 3 Dec 2020 16:43:54 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86/mmu: Use cpuid to determine max gfn
Message-ID: <X8mGSoB6KCiFsJdC@google.com>
References: <20201203231120.27307-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203231120.27307-1-rick.p.edgecombe@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 03, 2020, Rick Edgecombe wrote:
> In the TDP MMU, use shadow_phys_bits to dermine the maximum possible GFN
> mapped in the guest for zapping operations. boot_cpu_data.x86_phys_bits
> may be reduced in the case of HW features that steal HPA bits for other
> purposes. However, this doesn't necessarily reduce GPA space that can be
> accessed via TDP. So zap based on a maximum gfn calculated with MAXPHYADDR
> retrieved from CPUID. This is already stored in shadow_phys_bits, so use
> it instead of x86_phys_bits.
> 
> Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Dang, in hindsight it'd be nice if KVM_CAP_SMALLER_MAXPHYADDR allowed explicitly
setting the max MAXPHYADDR for an entire VM instead of being a simple toggle.
E.g. TDX and SEV-ES likely could also make use of "what's this VM's max GPA?".

Reviewed-by: Sean Christopherson <seanjc@google.com> 
