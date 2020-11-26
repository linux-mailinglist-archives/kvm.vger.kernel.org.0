Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C522C4BED
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 01:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgKZASS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 19:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgKZASR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Nov 2020 19:18:17 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC73EC061A4F
        for <kvm@vger.kernel.org>; Wed, 25 Nov 2020 16:18:17 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id b63so3869682pfg.12
        for <kvm@vger.kernel.org>; Wed, 25 Nov 2020 16:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xtBIT+qCa4sChxL+g/WnRTB/dJzsn+HqrG84pMp2t10=;
        b=COvT4aht2jG422Iu3213TCLTGLiFAt31wx54BSu839Y8cnch/0pTvNa8oZsp/OSJCH
         ne6Iy0Ut3NbdciltZkFNg7EHIN5kwZyxxbjSWtZUAUupADu2YSI5q3dY+c1UmcCgjKJv
         RlVlqgsv8Q/vWcEbNciGyj8iH8ytA+PHEZOkvws0+0gAezFxIH3mBw+k9JN1Yu3Nackz
         2KhUn8ddo5AsCOEElNB2Wa00U/xbHvtC6J3Vd7PXuxM+M/sHLwRG30no3kbiuNZn6rU1
         zTQlUD33i7ceTAfYJL1Qwfwv5KmAMW0K0JNnjwSAQHqkSYaADrn2rVvFxpVr6SOhru3E
         fcog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xtBIT+qCa4sChxL+g/WnRTB/dJzsn+HqrG84pMp2t10=;
        b=C2lPNhcJLn2mywtG+H757WiFNbGCw+zBadbw0kNhLOP776WC3vectf/WdAQISmNqR3
         ONHEDD6ppO2CZYL551astfLo20/V+hxVnhhM/VtUt5kzWoVr7/RVyIcOC3f2CPk3Z/hn
         T1jPVTJtng0/czSZhWo1LuE7IvjIjkmHbSivA4HJSt6XaK/ltq3SXDUzPrCquIS0OYiq
         H/nPtb68saF3yK+iMFYk7apo7IcAlXXDqFqy40gM09ZewOklSXcjQIm9WXLOV3gjfuhH
         AnnN5KJSrnZStm16KJ00SXQSs5TTb32G07dYkeMzaVYj/upPS7fbgDjLh3PmtRlwcQcS
         ECjQ==
X-Gm-Message-State: AOAM532gkAyhx9P5XVZCm0Z9nPuEVTE+kHCbT5LyqsaJQRTOLMXUvkM5
        8gWsBwAqrlpSDjvjOnwTbFPOAQ==
X-Google-Smtp-Source: ABdhPJwVXwFQUkPRmrtdawKMQiObLLorOQP4o8gBCh5mCLyW5sJ+mGJGg5pYuKG1nirh/SrPYQCihA==
X-Received: by 2002:a17:90b:3604:: with SMTP id ml4mr365790pjb.209.1606349897129;
        Wed, 25 Nov 2020 16:18:17 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id u22sm3743817pjy.31.2020.11.25.16.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 16:18:16 -0800 (PST)
Date:   Thu, 26 Nov 2020 00:18:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com, Zhang Chen <chen.zhang@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH 03/67] x86/cpu: Move get_builtin_firmware() common
 code (from microcode only)
Message-ID: <20201126001812.GD450871@google.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
 <46d35ce06d84c55ff02a05610ca3fb6d51ee1a71.1605232743.git.isaku.yamahata@intel.com>
 <20201125220947.GA14656@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125220947.GA14656@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 25, 2020, Borislav Petkov wrote:
> On Mon, Nov 16, 2020 at 10:25:48AM -0800, isaku.yamahata@intel.com wrote:
> > From: Zhang Chen <chen.zhang@intel.com>
> > 
> > Move get_builtin_firmware() to common.c so that it can be used to get
> > non-ucode firmware, e.g. Intel's SEAM modules, even if MICROCODE=n.
> 
> What for?
> 
> This is used for microcode built in the kernel - a non-common use case.
> Why is your thing built into the kernel and not a normal module object?

The SEAM module needs to be loaded during early boot, it can't be deferred to a
module, at least not without a lot more blood, sweat, and tears.

The SEAM Loader is an ACM that is invoked via GETSEC[EnterACCS], which requires
all APs to be in WFS.  SEAM Loader also returns control to the kernel with a
null IDT and NMIs unblocked, i.e. we're toast if there's a pending NMI.  And
unlike the run-time SEAMCALLs, boot-time SEAMCALLs do not have a strictly
bounded runtime.  Invoking configuration SEAMCALLs after the kernel is fully up
and running could cause instability as IRQ, NMI, and SMI are all blocked in SEAM
mode, e.g. a high priority IRQ/NMI/SMI could be blocked for 50+ usecs (it might
be far more than 50 usecs, I haven't seen real numbers for all SEAMCALLs).
