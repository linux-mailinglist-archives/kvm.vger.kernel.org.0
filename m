Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEF83E2D23
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 17:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243541AbhHFPF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 11:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241898AbhHFPFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 11:05:24 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763A4C061798
        for <kvm@vger.kernel.org>; Fri,  6 Aug 2021 08:05:08 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so23238798pjs.0
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 08:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5eZrYc9DJUkTA1iAssqHy9p2WRfYMo/VyY/QvADARYY=;
        b=scjfM2KAwvMr0J0xp0SYBnTDo3ApPj7hK5atstwmV/OGXWjEglaJS/poY5hkj1kzKz
         VYsVd9nNWgtisBaQNXTSQrwQjwPSG0BREg5oF/i/LHX4ghsTljrBb00qTaEUqAvv7m4Q
         wr90ti6/x0aFWJ6Ggh1coi9tpGKp4jaCPZLdTLI1zRNSCX9dfftJ4JwCCKMQ1gwO0XIA
         0VALv7wyOrCj8xtB6rtAWhBfCxcuqS1nzuuGZvekZAEVWkUK/tUQiTFiE4NN/cyGBn9C
         TsbWFDeNNnmAHfa49asadyj9F+VDC9m2sfk5dS1IKBtTr8lr7rahWrh3HWKmO+6Z+IvK
         mNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5eZrYc9DJUkTA1iAssqHy9p2WRfYMo/VyY/QvADARYY=;
        b=dN6fouMw/wZRjQ5HSETR3HnaLJTV3Q1yCj3pX3CdDZsZkdCTqa9vnzZ1PbnejZKf8E
         iUTx1kqfvPbUiX3gizxJ8uvlOo7oiueIEWRzHlLMLb2IvZw2P1lkB6+9NTV14v83vmYh
         TZSd3a4lq/Bk7/HtkRRBSyW/5EzWSf8RXRbAvNMYUsxY9fCx7xnntFgGfgqODSHLSD2e
         p87DQCONeL/CTTPWe2//UuCiGT3ilZiCA12S4Y8wLEurl2JA5d1pXfetR1PiDRvDYyG2
         HLF1e84uqNwihHV0z7vQlp3ne4UlgjWkGfXVqolVdtfNgg55p0xtw3uKrvg/moBm8VTy
         vO1Q==
X-Gm-Message-State: AOAM533TsZmGf52UgPLhVfpCyNoEiCIg7O+8oLwleWVpHkc5HqwqQqg3
        pXPtEGlnFiFzpfO02FNwcBVrUA==
X-Google-Smtp-Source: ABdhPJywOhz85rUeq9sfYzgRc3T33E50AG7rhHUhlIZkEJYslkgHGgdx50E1SFw0y9fZ0eki4xw4sw==
X-Received: by 2002:a63:ef45:: with SMTP id c5mr122429pgk.78.1628262307730;
        Fri, 06 Aug 2021 08:05:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id dw15sm9422535pjb.42.2021.08.06.08.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 08:05:07 -0700 (PDT)
Date:   Fri, 6 Aug 2021 15:05:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH v3 2/6] KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to
 support 64-bit variation
Message-ID: <YQ1Pn4YwmLC5zHP3@google.com>
References: <20210805151317.19054-1-guang.zeng@intel.com>
 <20210805151317.19054-3-guang.zeng@intel.com>
 <YQxnGIT7XLQvPkrz@google.com>
 <86b1a46b-10b7-a495-8793-26374ebc9b90@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86b1a46b-10b7-a495-8793-26374ebc9b90@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 06, 2021, Zeng Guang wrote:
> On 8/6/2021 6:32 AM, Sean Christopherson wrote:
> > On Thu, Aug 05, 2021, Zeng Guang wrote:
> > > +BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
> > This fails to compile because all the TERTIARY collateral is in a later patch.
> 
> 
> Alternative to derive relative TERTIARY collateral and prepare them in this
> patch. Ok for that ?

It'd be better to move this line to the next patch, that way all the TERTIARY
stuff is in a single patch and isolated from controls shadow enhancement.
