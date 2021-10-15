Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55DF42FEA5
	for <lists+kvm@lfdr.de>; Sat, 16 Oct 2021 01:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243493AbhJOXWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 19:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243488AbhJOXWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 19:22:51 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15860C061570
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 16:20:44 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id np13so8216015pjb.4
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 16:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IyogxXBF4ERdneEthK8iHsAabPbMvHTlpS6uXjP1tKo=;
        b=M9X/jbpBJ7W5abTM2rdyEIjbkTODCwbYUwLCpyBGMWEBWu7PfNk58AjevCJ+mz8by1
         RqZDCGgRZsOMqVF7n+mbu94I3V/1cSKExXkGD3OsaXQMzDSa1O9eM4hm66T7kYL3sInC
         DxDeE4C9fh0Wg5/GQjoEiMy9A4ajmvOcbifJEBSXsVqT7Fnx1t9cbrx1+Vt5As3hgRNg
         iwnypgSU3KVeqPblim3ASS/BpsbyK0Wxa1Wg+46AYDsylTjUyKAsqFLENkItvfrZzY8T
         HcDL6vqx0y8ACtTJWEYYAkaHFFFCBe8vERuCThRMk732CTdccdrovnZ1fldibr+FWePT
         JnPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IyogxXBF4ERdneEthK8iHsAabPbMvHTlpS6uXjP1tKo=;
        b=k5cplu66Ug3mNc6ts/6AtMcpKNQmgJ01lh6QzOAblgNFcmwrIpTEySWyth0Cgx+RA2
         AjwEeoWxltlwm8YeoxMPeYT77xhUhS7fpt5GG6VFStLYuX0eguBQk3z8O183KJn8rjo/
         d6qMi9/ms0rC+hgXwIB/nbovlZqP6nlWo1U4Jozy6ZzQ9duRHVxDTNhLlrfKoQjgFKVC
         3q4p3WvMoq6QbUVySk4yCpWnDDh13lSeJOjrGS/KkSHoboY1Vg5u8Wx/Vj7tLECCYVW5
         TTkgYN55FvVc8zfyUgxnwZWhVK+qLRopNo1LzXOiqJhf943kIgYN+eOt5ALllOBJnMM5
         aNMg==
X-Gm-Message-State: AOAM532xi9h0G/3y1A2EqKiZkxZ4c7korjF8fpQhASr4FDgDCJGgVG23
        HuPwinyo1OeODrr4JMOWEAqasprInPznDQ==
X-Google-Smtp-Source: ABdhPJwsYRicSOTmaFk3aW5O/z1rlArO6jBn2VN/Uts1f+Dv24k6w2WOk6nA/e8g/oNHJwVwSrBBbg==
X-Received: by 2002:a17:902:dacf:b0:13e:ab53:87dc with SMTP id q15-20020a170902dacf00b0013eab5387dcmr13518687plx.78.1634340043340;
        Fri, 15 Oct 2021 16:20:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z8sm5466931pgc.53.2021.10.15.16.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 16:20:42 -0700 (PDT)
Date:   Fri, 15 Oct 2021 23:20:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 1/3] KVM: emulate: Don't inject #GP when emulating
 RDMPC if CR0.PE=0
Message-ID: <YWoMxmq+RZ5je9Sy@google.com>
References: <1633770532-23664-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1633770532-23664-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 09, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> DM mentioned that, RDPMC: 

Heh, missing 'S' in "SDM".

> 
>   IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates a supported counter)) 
>       THEN
>           EAX := counter[31:0];
>           EDX := ZeroExtend(counter[MSCB:32]);
>       ELSE (* ECX is not valid or CR4.PCE is 0 and CPL is 1, 2, or 3 and CR0.PE is 1 *)
>           #GP(0); 
>   FI;
> 
> Let's add the CR0.PE is 1 checking to rdpmc emulate, though this isn't
> strictly necessary since it's impossible for CPL to be >0 if CR0.PE=0.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
