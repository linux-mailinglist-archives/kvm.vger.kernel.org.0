Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4826F380691
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 11:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhENJ6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 05:58:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34366 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231474AbhENJ6o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 May 2021 05:58:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620986252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zBNv4081Q/Y0r/u4hcRuN6ngx5638R1+Ds+qvxVrHNs=;
        b=ZuEJAf2vcTIXp/8EzA1GAkkeNGOHL9QMWkQ3wiegyjChUelyD6J5edj11IHMts54OQsNSP
        /0fkqGfn/k6rOK1pS+oyqzhYTiAcGjW6JwDiYDE94YBWPU90gXW1RFFC4h3y3FlCj05L5z
        8iA4jB9AyV6Ce+lwNwTJiSm8YCH4YEM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-v-aiH4rYMwaXZgCLmSpGLA-1; Fri, 14 May 2021 05:57:31 -0400
X-MC-Unique: v-aiH4rYMwaXZgCLmSpGLA-1
Received: by mail-ed1-f70.google.com with SMTP id r19-20020a05640251d3b02903888eb31cafso16106549edd.13
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 02:57:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zBNv4081Q/Y0r/u4hcRuN6ngx5638R1+Ds+qvxVrHNs=;
        b=hCASc76YQ+g0TxU334Rzmqtmbdo+BlWJvlig1PpxyZTbrW+QvRnx9rWYt4DnbMo6IL
         J4E/RTJzoTjcFBCZe13Zcc9spokYS6ZlroKzWgdGw/qZu80uRD29oeLocOv4FHrCoAdW
         Ryxtf2GbRckuw61lbkpCjdycRiT2yCqgSs187OAPD0YO0AfRgUrz7iaU9cix/zIQ1lYL
         IelJ/ExgjzMx5xfx9Bw/nioG7aSFF8a9Rjht+MYe+61jfpQlP/adFE20FiifKiYHLu5x
         mLXUG55ibnuFtPCCDg998DL6uHttPXMByLMSIXusadEurnvL46kcPonZ/eXfi6WowG3e
         ka7A==
X-Gm-Message-State: AOAM531KTqCVVrDWTVVsA43CTEpGXpjjZSeuHq0fxC99Z7GoKPD/fibX
        5uWqQB3FXe++EnbkJzB4nDeNCHfC9eqBmfjNOCAaP53dHm/Fl6lzSfEYELa5gX2/quZrOyhXCV9
        ya69Wl2rY8Nuq
X-Received: by 2002:a50:f744:: with SMTP id j4mr19524861edn.211.1620986250007;
        Fri, 14 May 2021 02:57:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwab357uxeZHtttG7nRq/nhPpYCqczyAKsKTrZS3ZkCINwE5JXCbpcSRJgglIgbjM73w0y+w==
X-Received: by 2002:a50:f744:: with SMTP id j4mr19524848edn.211.1620986249812;
        Fri, 14 May 2021 02:57:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id zo6sm3317903ejb.77.2021.05.14.02.57.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 02:57:29 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic> <20210513043441.GA28019@ashkalra_ubuntu_server>
 <YJ4n2Ypmq/7U1znM@zn.tnic> <7ac12a36-5886-cb07-cc77-a96daa76b854@redhat.com>
 <20210514090523.GA21627@ashkalra_ubuntu_server>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <70951773-fe39-c694-abeb-69052934b76b@redhat.com>
Date:   Fri, 14 May 2021 11:57:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210514090523.GA21627@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/05/21 11:05, Ashish Kalra wrote:
> I absolutely agree with both of your point of view. But what's the
> alternative ?
> 
> Ideally we should fail/stop migration even if a single guest page
> encryption status cannot be notified and that should be the way to
> proceed in this case, the guest kernel should notify the source
> userspace VMM to block/stop migration in this case.
> 
>  From a practical side, i do see Qemu's migrate_add_blocker() interface
> but that looks to be a static interface and also i don't think it will
> force stop an ongoing migration, is there an existing mechanism
> to inform userspace VMM from kernel about blocking/stopping migration ?

On the Linux side, all you need to do is WARN and write 0 to the 
MIGRATION_CONTROL MSR.

QEMU can check the MSR value when migrating the CPU registers at the 
end, and fail migration if the MSR value is 0.

Paolo

