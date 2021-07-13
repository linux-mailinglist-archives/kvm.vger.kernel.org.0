Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E793C75F0
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 19:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhGMRwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 13:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbhGMRwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 13:52:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E4CC0613EF
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 10:49:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id me13-20020a17090b17cdb0290173bac8b9c9so1892578pjb.3
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 10:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yXz5SZYhJFQ5rmn/Ssf8L6wKyoGLCudJATpd74s+yXw=;
        b=vaxecE7vRw5jdKsbzPNK05mEQM6dGDFHY2yAwByMcGJk26SebCFBHHn0n6t045+DAr
         Wyu3+0dxhwxmIFP0uz6GU0pQYsIqBPzQZdl3INEOiJzgPcGBr6ahX4U1tRoIvPyzSQJC
         JTJYv2okDk8zum3YZoFehv8A99oN7DxdvXQVyeyYNTMYANbuEyeVu6uc4Ya0iZXfd9Nz
         rLk4b0VytMFL+gXQhsW3pcQq4z6t+4rcEeVNMueBtkdKTAr5JRhNaBVMqlbIqlAHLf1e
         tnbZ8re8J3xqGzOQcl+yR07YFI3eBmmaHD95TE74zVBZLJexpKatIq6oeZj2IdT5b8ly
         HaSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yXz5SZYhJFQ5rmn/Ssf8L6wKyoGLCudJATpd74s+yXw=;
        b=ZJAl5ZtLvyPYd/CbnIba012+JWKvuRmdpLawuHT7mnSg6dlhSaeSJnme2btif2JVn+
         SYdpLkqMP+n4pFoCWxGXMvbJ/si7/TnPOEGdjF2csqrkmf0D/xAFLYpwScJiZnnqd78N
         SM5bFu/Geyh6n61Mr+g3nGjZfaZizNt/XelRv8z7uUVRXTOvXwhjKeuiVPgtjcUjso83
         sR5MYxQEE1SBmtadHeS0200uqflesJrwNc82m17k8YtXH0dikbzXMXeFIgkX6GanXF2G
         v9N7gP35iYsx3e9gakrOF771FpzsTttOM/XdBYypL120ioj21V2b1Hpcpzi9EkcltyIN
         HaMg==
X-Gm-Message-State: AOAM5311OcIc0xBN2sBfbTYrx+bVeViCmwYaJs06XoWZFEq1nFZ+F3n6
        jmElToJftBtqpGkOOi7bnBdYdg==
X-Google-Smtp-Source: ABdhPJx9hpbMAIO9agDZpdwnBXUWw1cQ4vYR2gBkqCKocfq9tp7VqFM1UL0j3m8TwXv4upPS0Hz3Aw==
X-Received: by 2002:a17:90a:564a:: with SMTP id d10mr5456913pji.120.1626198561523;
        Tue, 13 Jul 2021 10:49:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d3sm16980036pjo.31.2021.07.13.10.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 10:49:21 -0700 (PDT)
Date:   Tue, 13 Jul 2021 17:49:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v2 02/69] KVM: X86: move kvm_cpu_vmxon() from vmx.c
 to virtext.h
Message-ID: <YO3SHUzwCH+haEgZ@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <cb2256563ec5aacdb7ab6122343e86be9f1cbd60.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb2256563ec5aacdb7ab6122343e86be9f1cbd60.1625186503.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This is preparatory clean up for TDX support.
> Move out kvm_cpu_vmxon() from vmx.c to virtext.h with rename to
> vcpu_vmxon(). Which will be used outside of kvm.
> SEAMLDER to load TDX module which occurs at kernel early boot phase.
  ^^^^^^^^
  SEAMLDR?

This patch can't be reviewed without seeing the TDX-Module load/init code, and
that code has been moved to a different (not yet posted?) series.  E.g. at the
end of this series, KVM is still the only user.

> As bonus, this also increases the symetry with cpu_vmxoff().
                                    ^^^^^^^
                                    symmetry
