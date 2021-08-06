Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E823A3E2E53
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 18:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhHFQbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 12:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbhHFQbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 12:31:18 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDBAC0613CF
        for <kvm@vger.kernel.org>; Fri,  6 Aug 2021 09:31:01 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id nh14so17462708pjb.2
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 09:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=84hY5jDAppUM2aQUi/DIf2atf7Ty47vhaafi4V0naGE=;
        b=KdvF1wfl42VsDxUShMXwSpC4rhv0zdr+gVFsmfAwaFUkHd6dylwqkqcDY3njHKRETd
         s06qFvZCIekJr6w7GgTCTZ5h3Nfx/uu8wHKfqkQVBQBxnf6ae3oa3Ger6bdeMGLDKOGF
         ISgPrQxVjOBP14Nw86opXLNvQ06SvJgbBOrjvjrfIMMJtj+Ik7ao8PnpFwtayUFflXuB
         dIa+tOyZxCong/Tga8xXnXn+86OS5lNlCqgZsHkO2Xq2zV/834HUHXabeViOwLBP1Low
         j2qk1swKizFSzRbW3RhpAWMOjPlYMj76B0oxTS7z4j3uI3Q5M2PE21ePHQcPDe0yMo9n
         NrbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=84hY5jDAppUM2aQUi/DIf2atf7Ty47vhaafi4V0naGE=;
        b=I2j/7um+0q5fekodJhuoIG3ZgNQE8aocgK8U9nyjGxIymyXIJ6alri5jhZvJFZ7hd2
         uL0MDD1CXBfxYNiSrrGmfwru3K3NkGVShg5LUdKvVnPiOmz8PfWWqpwGkBz/Q0C7GgsQ
         +KPsyXr/PAA4gfaOXIAIkq+o7bgEEjRehAI5vSN/P9Ih3wHki3usHIRTEGFUHpR4g5O4
         MQSgjBHSP0cCJOAixjKUr2kxXXgUM8cHP8OVOd8qTYx9ECGsRbHK39BKQCxX+l2Slgf/
         zHqESrIazowwQg5qNqeK8AxjLu4mh6VgCaDOadumiN/KfCRcmx3kTE5cVbNtgUkfExGs
         BzUw==
X-Gm-Message-State: AOAM533EqHQB38AZ6Az5/Qe3pYiauahWXFA8X+QUsh5x0n8VBodYsG2H
        uxAqF3Zu09kjgN6Q8pPcBGS5Qg==
X-Google-Smtp-Source: ABdhPJyCtsGwyPBwANptW14Gj0TNbhDEtRkyTTY5E91Himc0xAxv1pOEj0Ovr0v9/IsQL37B65Pt3w==
X-Received: by 2002:a17:90a:4894:: with SMTP id b20mr11434237pjh.13.1628267460943;
        Fri, 06 Aug 2021 09:31:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id iq4sm6145622pjb.28.2021.08.06.09.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 09:31:00 -0700 (PDT)
Date:   Fri, 6 Aug 2021 16:30:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH v3 2/6] KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to
 support 64-bit variation
Message-ID: <YQ1jwHuDoSNxKDVW@google.com>
References: <20210805151317.19054-1-guang.zeng@intel.com>
 <20210805151317.19054-3-guang.zeng@intel.com>
 <YQxnGIT7XLQvPkrz@google.com>
 <a984cf7e-fe3e-98bd-744f-9d0ff3759e01@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a984cf7e-fe3e-98bd-744f-9d0ff3759e01@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 06, 2021, Paolo Bonzini wrote:
> On 06/08/21 00:32, Sean Christopherson wrote:
> > > -BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
> > > -BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
> > > -BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
> > > -BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
> > > -BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
> > > +BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
> > > +BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
> > > +BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL, 32)
> > > +BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL, 32)
> > > +BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL, 32)
> > > +BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
> > 
> > This fails to compile because all the TERTIARY collateral is in a later patch.
> > 
> > I think I'd also prefer hiding the 32/64 param via more macros, e.g.
> > 
> > #define __BUILD_CONTROLS_SHADOW(lname, uname, bits)				\
> 
> No, please don't. :)  Also because the 64 bit version is used only once.

LOL, fine.  I'm beginning to think you have a filter for "macros" that sounds off
alarms and flashing lights ;-)
