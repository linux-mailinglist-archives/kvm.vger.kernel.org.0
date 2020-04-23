Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2EF1B5C75
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 15:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgDWNWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 09:22:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44125 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbgDWNWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 09:22:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id d17so6800453wrg.11;
        Thu, 23 Apr 2020 06:22:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iuq6pBRpV7QPrN7TD8s7GlKdVuT8Rr6JcPkVbP2MpI0=;
        b=lV4MAxxosL9zDQLgP9WYOiOj2gaOdh3izALQKSMs61nHjt8K+sjKA1UZxQD+DpuEoC
         7SHfvHmRGkeXrkxOOLe2hMDf+62IhAsefH2U/DeZHGauCDNKKDtRbhnZ/ar5itsZ7vE+
         gKpgzm2ocdhyZKQnjFurGMUO8CPnOp1HqqpUwMcJQqSZFScdmppObN9RKVFqyYfd/OvQ
         zW5G7bXT96AFhMTZ6C7b4sq8cGcQnCG+fZ04VEkSH0837WA2NULq6LBWRI9rOXxZxNtJ
         8HQUr+gjFAC5mNvYuBFZdfO7bH0ieu/y6pP3CwKVOTDEjV/eekDF38foYYr4l7w+8c/d
         r1RA==
X-Gm-Message-State: AGi0Pubky7IW14786yQSvY836Pynit0b/Zib/xQfVbl2UBQMOcLfhLCD
        Olgx0gVFP5BYESzvwyY3LKw=
X-Google-Smtp-Source: APiQypIEZxPpWwZO1dJPmZJRXbxGHGkpj0uIQN9V5WBHqfcSsT+C5L1UlHcfMdotuTpqLaVZIGAXig==
X-Received: by 2002:a05:6000:4:: with SMTP id h4mr5088646wrx.386.1587648131443;
        Thu, 23 Apr 2020 06:22:11 -0700 (PDT)
Received: from liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id b22sm11963106wmj.1.2020.04.23.06.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 06:22:10 -0700 (PDT)
Date:   Thu, 23 Apr 2020 13:22:08 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Split hyperv-tlfs.h into generic and arch
 specific files
Message-ID: <20200423132208.i522jqpevglruhur@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
References: <20200422195737.10223-1-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422195737.10223-1-mikelley@microsoft.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 12:57:33PM -0700, Michael Kelley wrote:
> This series splits hyperv-tlfs.h into architecture independent and
> architecture specific files so that the arch independent portion can
> be shared between the x86/x64 and ARM64 code for Hyper-V.  While the
> Hyper-V team has not released a version of the TLFS document that
> clearly specifies which portions of the interface are arch independent,
> we can make a fairly good assessment based on implementation work done
> to support Linux guests on Hyper-V on ARM64, and on private communication
> with the Hyper-V team.  Definitions are considered arch independent if
> they are implemented by Hyper-V on both architectures (x86/x64 and ARM64),
> even if they are currently needed by Linux code only on one architecture.
> 
> Many definitions in hyperv-tlfs.h have historically contained "X64" in the
> name, which doesn't make sense for architecture independent definitions.
> While many of the occurrences of "X64" have already been removed, some
> still remain in definitions that should be arch independent. The
> split removes the "X64" from the definitions so that the arch
> independent hyper-tlfs.h has no occurrences of "X64". However, to
> keep this patch set separate from a wider change in the names, aliases
> are added in the x86/x64 specific hyperv-tlfs.h so that existing code
> continues to compile.  The definitions can be fixed throughout the code
> in a more incremental fashion in separate patches, and then the aliases
> can be removed.
> 
> Where it is not clear if definitions are arch independent, they have been
> kept in the x86/x64 specific file. The Hyper-V team is aiming to have a
> version of the TLFS document covering ARM64 by the end of calendar 2020,
> so additional definitions may be moved into the arch independent portion
> after the new TLFS document is released.
> 
> The first two patches in the series clean up the existing hyperv-tlfs.h
> file a bit by removing duplicate or unnecessary definitions so they are
> not propagated across the split. The third patch does the split, and the
> fourth patch adds new definitions that are needed on ARM64 but are generic.
> 
> These changes have no functional impact.
> 
> These patches are built against linux-next-20200415

Applied to hyperv-next. Thanks.

Wei.
