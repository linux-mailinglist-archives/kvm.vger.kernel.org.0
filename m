Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C112201D4
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 03:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgGOB0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 21:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgGOB0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 21:26:00 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B822C061794
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:26:00 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l63so873342pge.12
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=//8Ju0FArBc4zb01MxBoUcI/VYVDSlzg+BW3vSvSIkE=;
        b=aGa5ZBgHdWlGrdfvyqG//oW9uMRL8c4lif5pE5f9n31J0nGMfTfTLdQH8s0aTTbj5E
         XseYVdFj/m/ggc4SYgZzFFvS4yWNkLyoDsxCgYX3tfj9qjanEQCxrddTm1aZfG0VbwNO
         xgWTY5KoMFbPTRNg4DxovW5nmKheMJSQTsCOE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=//8Ju0FArBc4zb01MxBoUcI/VYVDSlzg+BW3vSvSIkE=;
        b=ga/DoUS5daCmVJlkkTO24fnXRvRx4A4JiVDtQcQyMfkcq+cYBAgT4o4nlAZHTRWt/S
         vkmV6yjtCjRYxwlhMjx5aLcjss+huPqiXfn1LifpKgqkKpsSkdD9WY5KIkmzB4qT3ik0
         pR9L/vVhCkkEnt5cDNFpbsei/QY1LALbP/2zCNY5EHb0s7PYSnHZ8qB1ulGX0dmqGyO9
         TiNK4EHZkszjRcIHdDdtURShfg1T7aSu8QTs1rn2G2dQ/pdIkz8ZGI2rDUdRZ4hsIn9L
         mIYK2wCM8XsHPPJhPYQAaXw1456nDMclC72vMLjASpDkRradFfDBzMArf+ZuKQJcCa6u
         Pjbg==
X-Gm-Message-State: AOAM530K3uyZv4vuNRJhaXaYtqpYy58LVfxUdrPHvCEolRN87y1ZxfC2
        ekbRp2b16XxjoKohDe4ort+1OA==
X-Google-Smtp-Source: ABdhPJzLdhmv/sgESdhBL5NEfWWnipaR1+RTxq1oQwAzUR+7rkRLawIsRncUD/eUpdU7XimBXhr5BQ==
X-Received: by 2002:a63:5004:: with SMTP id e4mr5816911pgb.208.1594776360077;
        Tue, 14 Jul 2020 18:26:00 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l23sm246555pjy.45.2020.07.14.18.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 18:25:59 -0700 (PDT)
Date:   Tue, 14 Jul 2020 18:25:58 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 27/75] x86/idt: Move IDT to data segment
Message-ID: <202007141825.7A90799@keescook>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-28-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714120917.11253-28-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:08:29PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> With SEV-ES, exception handling is needed very early, even before the
> kernel has cleared the bss segment. In order to prevent clearing the
> currently used IDT, move the IDT to the data segment.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
