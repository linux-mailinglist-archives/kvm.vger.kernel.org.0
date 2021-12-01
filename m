Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922E046562A
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 20:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239230AbhLATMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 14:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbhLATMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 14:12:19 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10917C061574;
        Wed,  1 Dec 2021 11:08:58 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v23so18703851pjr.5;
        Wed, 01 Dec 2021 11:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2/WVLfYcChaB2Rlq2I7dJboJflLwswX4QDTcSp5qFhY=;
        b=qZoTGUwlti1juWWDDvQW7vnkl3pfhZwTY+5yZBqD9WjHnZxgKQtSx6jHICyI7kB4fR
         1tV5XUO750umrXc8cHiF+uw9Bu7uhWGVuU6DPXU5x8znPsyoQb4XL7xiPvZKDobA7AwO
         e+lnvnW9cUb6iO0uKLy7chny6FncoLftYHedFWapYTZCp6Is/m2Hu2gyPaJDr6MIFTAI
         KqmjlBU2SLZO18vU9IDVueR47UIXKT7aXgml9SExt2UIsDqGkitZ8tnTK+p/4Z6CxFOJ
         n3WWUEaFRcX12bpcA0WCT4nqUWHdmCLkhgoEAiD09FD8ur7oXlOswtqMX1tIAIDz3d1Z
         6ufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2/WVLfYcChaB2Rlq2I7dJboJflLwswX4QDTcSp5qFhY=;
        b=MlyEUYd6nNQh3FMAuIIQZHYym5RbsihTwPe4yMgGMIro3c5h+oYaHHn3vEI4G4W9aS
         qbY0/d+m+bGpGqEXTQJVQBCJz8OJSkFUGqPNo3OVZJy+lqFZ9fBOvgTYiTWpDIY5Mj84
         gfJNnV+SRYYUM2b10zvAqAWOJXSPZiVFHJOdVJmU1mSNmj12MmhugPU/KqlPMH5TB3EA
         FbRTGPpPIPZ6IUrUHPafj+7vfKnxnpX1nO7N5LOVEfy3D1qvsEK2+jwSzROjCqmkagtz
         08XQ7iNsmzTKRhD9Hc1CQHyvNt/sXMmoNUqNIR068V/AufQBR1NFSi9Lyj9BQgomBAEA
         FbNw==
X-Gm-Message-State: AOAM533ak9rAmvmDsf76ZL27DeB9OgiD8OiaX2zSF2rILRZgQLrXMH5r
        mvz0Q+uZt4RU8hqZJN+vIvg=
X-Google-Smtp-Source: ABdhPJzDMJUFjG0ZkBA3xh74soV8Bi0OgekzKYefEeS+YpbkRevj7OOXF14YioKaFqky+wkb03TBfg==
X-Received: by 2002:a17:902:6a8a:b0:143:905f:aec7 with SMTP id n10-20020a1709026a8a00b00143905faec7mr10009094plk.8.1638385737508;
        Wed, 01 Dec 2021 11:08:57 -0800 (PST)
Received: from localhost ([2601:647:4600:a5:6f71:8916:71a8:8af8])
        by smtp.gmail.com with ESMTPSA id s19sm557279pfu.137.2021.12.01.11.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 11:08:57 -0800 (PST)
Date:   Wed, 1 Dec 2021 11:08:56 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v3 00/59] KVM: X86: TDX support
Message-ID: <20211201190856.GA1166703@private.email.ne.jp>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <YaZyyNMY80uVi5YA@google.com>
 <20211202022227.acc0b613e6c483be4736c196@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202022227.acc0b613e6c483be4736c196@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 02, 2021 at 02:22:27AM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> On Tue, 30 Nov 2021 18:51:52 +0000 Sean Christopherson wrote:
> > On Wed, Nov 24, 2021, isaku.yamahata@intel.com wrote:
> > > - drop load/initialization of TDX module
> > 
> > So what's the plan for loading and initializing TDX modules?
> 
> Although I don't quite understand what does Isaku mean here (I thought
> loading/initializing TDX module was never part of TDX KVM series), for this part
> we are working internally to improve the quality and finalize the code, but
> currently I don't have ETA of being able to send patches out, but we are trying
> to send out asap.  Sorry this is what I can say for now : (

v1/v2 has it. Anyway The plan is what Kai said.  The code will reside in the x86
common directory instead of kvm.

The only dependency between the part of loading/initializing TDX module and
TDX KVM is only single function to get the info about the TDX module.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
